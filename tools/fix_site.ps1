Param(
    [string]$RootPath = (Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)),
    [switch]$DryRun,
    [switch]$Verbose
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-HtmlFiles {
    param([string]$Base)
    $targets = @(
        Join-Path $Base '.'
        Join-Path $Base 'languages'
        Join-Path $Base 'locations'
    )
    $files = @()
    foreach ($t in $targets) { if (Test-Path $t) { $files += Get-ChildItem -Path $t -File -Filter *.html -Recurse } }
    $files | Sort-Object FullName -Unique
}

function Replace-InContent {
    param([string]$Content, [string]$Pattern, [string]$Replacement)
    return [regex]::Replace($Content, $Pattern, $Replacement)
}

function Fix-DuplicateFormActions {
    param([string]$Content)
    $formRx = '(?is)<form\b[^>]*>'
    $sb = New-Object System.Text.StringBuilder $Content
    $matches = [regex]::Matches($Content, $formRx)
    # Adjust from the end to keep indices valid
    for ($i = $matches.Count - 1; $i -ge 0; $i--) {
        $m = $matches[$i]
        $openTag = $m.Value
        $actionMatches = [regex]::Matches($openTag, 'action\s*=\s*"[^"]*"', 'IgnoreCase')
        if ($actionMatches.Count -gt 1) {
            # Keep the first action=... value and remove all others
            $firstAttr = $actionMatches[0].Value
            # Remove all action attributes
            $fixed = [regex]::Replace($openTag, 'action\s*=\s*"[^"]*"', '', 'IgnoreCase')
            # Normalize extra spaces
            $fixed = [regex]::Replace($fixed, '\s{2,}', ' ')
            # Ensure single space before reinserting the first action attribute before closing '>'
            $fixed = [regex]::Replace($fixed, '>\s*$', (' ' + $firstAttr + '>'))
            $sb.Remove($m.Index, $m.Length) | Out-Null
            $sb.Insert($m.Index, $fixed) | Out-Null
        }
    }
    return $sb.ToString()
}

function Fix-MapIframeTitle {
    param([string]$Content)
    $rx = '(?i)<iframe(?![^>]*\btitle=)([^>]*google\.com/maps[^>]*)>'
    return [regex]::Replace($Content, $rx, '<iframe title="Ace Language Services location map"$1>')
}

function Fix-CloseSidebarAriaLabel {
    param([string]$Content)
    $rx = '(?i)<button([^>]*class\s*=\s*"[^"]*close-sidebar[^"]*"[^>]*)>'
    if ($Content -notmatch $rx) { return $Content }
    return [regex]::Replace($Content, $rx, { param($m)
            $attrs = $m.Groups[1].Value
            if ($attrs -match '(?i)aria-label\s*=') { return $m.Value }
            return '<button' + $attrs + ' aria-label="Close menu">'
        })
}

function Fix-ButtonRedundantAttrs {
    param([string]$Content)
    # Remove role="button" and tabindex="..." only inside <button ...>
    $rx = '(?is)(<button\b[^>]*>)'
    return [regex]::Replace($Content, $rx, { param($m)
            $tag = $m.Groups[1].Value
            $tag = [regex]::Replace($tag, '\s+role\s*=\s*"button"', '', 'IgnoreCase')
            $tag = [regex]::Replace($tag, '\s+tabindex\s*=\s*"-?\d+"', '', 'IgnoreCase')
            return $tag
        })
}

function Ensure-SidebarOverlay {
    param([string]$Content)
    if ($Content -match '(?i)class\s*=\s*"[^"]*mobile-sidebar[^"]*"' -and $Content -notmatch '(?i)class\s*=\s*"[^"]*sidebar-overlay[^"]*"') {
        # Insert before closing body
        return [regex]::Replace($Content, '(?is)</body>', "  <div class=`"sidebar-overlay`"></div>`r`n</body>")
    }
    return $Content
}

function Fix-IconsAriaHidden {
    param([string]$Content)
    # Add aria-hidden="true" to <i> with fa classes lacking aria-hidden
    $rx = '(?i)<i(?![^>]*aria-hidden=)([^>]*\bfa[\w\s\-]*[^>]*)>'
    return [regex]::Replace($Content, $rx, '<i aria-hidden="true"$1>')
}

function Ensure-SkipLinkAndMain {
    param([string]$Content)
    # Ensure skip link exists right after <body ...>
    if ($Content -notmatch '(?i)<a[^>]*class\s*=\s*"[^"]*\bskip-link\b[^"]*"[^>]*>') {
        $bodyMatch = [regex]::Match($Content, '(?is)<body[^>]*>')
        if ($bodyMatch.Success) {
            $injection = "`r`n    <a href=`"#main-content`" class=`"skip-link`">Skip to main content</a>"
            $Content = $Content.Substring(0, $bodyMatch.Index) + $bodyMatch.Value + $injection + $Content.Substring($bodyMatch.Index + $bodyMatch.Length)
        }
    }
    # Ensure a main-content target exists
    if ($Content -notmatch '(?i)\bid\s*=\s*"main-content"') {
        $mainTagMatch = [regex]::Match($Content, '(?is)<main\b([^>]*)>')
        if ($mainTagMatch.Success) {
            $mainOpen = $mainTagMatch.Value
            if ($mainOpen -notmatch '(?i)\bid\s*=') {
                $replacement = '<main id="main-content' + '"' + $mainTagMatch.Groups[1].Value + '>'
                $Content = $Content.Substring(0, $mainTagMatch.Index) + $replacement + $Content.Substring($mainTagMatch.Index + $mainTagMatch.Length)
            }
        }
        else {
            $sectionTagMatch = [regex]::Match($Content, '(?is)<section\b([^>]*)>')
            if ($sectionTagMatch.Success) {
                $sectionOpen = $sectionTagMatch.Value
                if ($sectionOpen -notmatch '(?i)\bid\s*=') {
                    $replacement = '<section id="main-content' + '"' + $sectionTagMatch.Groups[1].Value + '>'
                    $Content = $Content.Substring(0, $sectionTagMatch.Index) + $replacement + $Content.Substring($sectionTagMatch.Index + $sectionTagMatch.Length)
                }
            }
        }
    }
    return $Content
}

function Fix-CollapseAria {
    param([string]$Content)
    # Normalize collapseServices: remove any existing aria-expanded/aria-controls then add once
    $Content = [regex]::Replace($Content, '(?is)<button([^>]*\bid\s*=\s*"collapseServices"[^>]*)>', {
            param($m)
            $attrs = $m.Groups[1].Value
            $attrs = [regex]::Replace($attrs, '\s+aria-expanded\s*=\s*"[^"]*"', '', 'IgnoreCase')
            $attrs = [regex]::Replace($attrs, '\s+aria-controls\s*=\s*"[^"]*"', '', 'IgnoreCase')
            return '<button' + $attrs + ' aria-expanded="false" aria-controls="servicesGrid">'
        })
    # Normalize collapseLanguages similarly
    $Content = [regex]::Replace($Content, '(?is)<button([^>]*\bid\s*=\s*"collapseLanguages"[^>]*)>', {
            param($m)
            $attrs = $m.Groups[1].Value
            $attrs = [regex]::Replace($attrs, '\s+aria-expanded\s*=\s*"[^"]*"', '', 'IgnoreCase')
            $attrs = [regex]::Replace($attrs, '\s+aria-controls\s*=\s*"[^"]*"', '', 'IgnoreCase')
            return '<button' + $attrs + ' aria-expanded="false" aria-controls="languageGrid">'
        })
    return $Content
}

function Fix-CurrencyMojibakeAll {
    param([string]$Content)
    $pound = [string][char]0x00A3
    $rc = [char]0xFFFD
    # Replace U+FFFD + digits => £digits
    $pattern1 = [regex]::Escape([string]$rc) + '\s*([0-9]+)'
    $Content = [regex]::Replace($Content, $pattern1, { param($m) $pound + $m.Groups[1].Value })
    # Replace 'Â£' (U+00C2 U+00A3) + digits => £digits
    $c2pound = [string]([char]0x00C2) + [string]([char]0x00A3)
    $pattern2 = [regex]::Escape($c2pound) + '\s*([0-9]+)'
    $Content = [regex]::Replace($Content, $pattern2, { param($m) $pound + $m.Groups[1].Value })
    # Replace ? + digits => £digits (common mojibake)
    $Content = [regex]::Replace($Content, '\?\s*([0-9]+)', { param($m) $pound + $m.Groups[1].Value })
    return $Content
}

function Fix-JsonLdLogo {
    param([string]$Content)
    # Replace logo path used in ContactPage JSON-LD if pointing to /images/logo.png
    return [regex]::Replace($Content, '(?i)"logo"\s*:\s*"https?://www\.acelang\.com/images/logo\.png"', '"logo": "https://www.acelang.com/images/company_logo_transparent.png"')
}

function Ensure-MultipartEnctype {
    param([string]$Content)
    # If the page has a file input, ensure the containing form includes enctype="multipart/form-data"
    if ($Content -match '(?i)<input[^>]*type\s*=\s*"file"') {
        $Content = [regex]::Replace($Content, '(?is)<form\b(?![^>]*enctype=)([^>]*)>', '<form$1 enctype="multipart/form-data">')
    }
    return $Content
}

function Remove-BrokenSomaliLinks {
    param([string]$Content)
    # Remove list items linking to somali-translation-services.html (single-line)
    $Content = [regex]::Replace($Content, '(?im)^\s*<li>\s*<a\s+href=\"(?:\.\.\/)?languages\/somali-translation-services\.html\"[^>]*>.*?</li>\s*$', '')
    # Remove list items linking to somali-translation-services.html (multi-line/DOTALL)
    $Content = [regex]::Replace($Content, '(?is)<li[^>]*>[^<]*<a[^>]*href=\"(?:\.\.\/)?languages\/somali-translation-services\.html\"[^>]*>.*?<\/a>.*?<\/li>', '')
    # As a fallback, strip any remaining anchors to that page
    $Content = [regex]::Replace($Content, '(?is)<a[^>]*href=\"(?:\.\.\/)?languages\/somali-translation-services\.html\"[^>]*>.*?<\/a>', '')
    return $Content
}

function Demote-HeaderBrandH1 {
    param([string]$Content)
    # Demote brand H1 to div on pages with another H1 (heuristic: 404 and careers by filename)
    return $Content -replace '(?is)(<div class="logo">\s*<img[^>]*>\s*)<h1>([\s\S]*?)</h1>', '$1<div class="site-title">$2</div>'
}

function Fix-LanguageTyposIndex {
    param([string]$Content)
    # Bajunu -> Bajuni
    $Content = $Content -replace '(?i)>(\s*)Bajunu(\s*)Translation(\s*)<', '>$1Bajuni$2Translation$3<'
    # Remove Mandingo card block
    $Content = [regex]::Replace($Content, '(?is)<div\s+class="language-item"[^>]*>\s*<i[^>]*>.*?</i>\s*<h4>\s*Mandingo\s+Translation\s*</h4>[\s\S]*?</div>\s*', '')
    return $Content
}

function Fix-PolishCurrency {
    param([string]$Content)
    $pound = [string][char]0x00A3
    # Replace ?25 -> £25 (mojibake)
    $Content = [regex]::Replace($Content, '(?<!\w)\?(\d+)', { param($m) $pound + $m.Groups[1].Value })
    return $Content
}

function Process-File {
    param([System.IO.FileInfo]$File)
    $orig = Get-Content -Path $File.FullName -Raw
    $new = $orig
    $new = Fix-DuplicateFormActions -Content $new
    $new = Fix-MapIframeTitle -Content $new
    $new = Fix-CloseSidebarAriaLabel -Content $new
    $new = Fix-ButtonRedundantAttrs -Content $new
    $new = Ensure-SidebarOverlay -Content $new
    $new = Fix-IconsAriaHidden -Content $new
    $new = Ensure-SkipLinkAndMain -Content $new
    $new = Ensure-MultipartEnctype -Content $new
    $new = Fix-CollapseAria -Content $new
    $new = Fix-CurrencyMojibakeAll -Content $new
    if ($File.Name -ieq 'index.html') { 
        $new = Fix-JsonLdLogo -Content $new 
        $new = Fix-LanguageTyposIndex -Content $new
    }
    if ($File.Name -ieq 'polish-translation-services.html') { $new = Fix-PolishCurrency -Content $new }
    if ($File.Name -ieq '404.html' -or $File.Name -ieq 'careers.html') { $new = Demote-HeaderBrandH1 -Content $new }
    if ($File.DirectoryName -match '(?i)locations$') { $new = Remove-BrokenSomaliLinks -Content $new }

    if ($new -ne $orig) {
        if ($DryRun) {
            if ($Verbose) { Write-Host "Would update: $($File.FullName)" -ForegroundColor Yellow }
        }
        else {
            Set-Content -Path $File.FullName -Value $new -Encoding UTF8
            if ($Verbose) { Write-Host "Updated: $($File.FullName)" -ForegroundColor Green }
        }
        return $true
    }
    return $false
}

$root = Resolve-Path $RootPath
$files = Get-HtmlFiles -Base $root
if (-not $files) { Write-Error "No HTML files found at $root"; exit 1 }

$changed = 0
foreach ($f in $files) { if (Process-File -File $f) { $changed++ } }

Write-Host ("Files changed: {0}" -f $changed)
exit 0


