Param(
    [string]$RootPath = (Split-Path -Parent $MyInvocation.MyCommand.Path),
    [switch]$SummaryOnly
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Section([string]$text) {
    Write-Host ('=' * 80) -ForegroundColor DarkGray
    Write-Host $text -ForegroundColor Cyan
}

function Get-HtmlFiles {
    param(
        [string]$Base
    )
    $targets = @(
        Join-Path $Base '.'
        Join-Path $Base 'languages'
        Join-Path $Base 'locations'
    )
    $files = @()
    foreach ($t in $targets) {
        if (Test-Path $t) {
            $files += Get-ChildItem -Path $t -File -Filter *.html -Recurse -ErrorAction SilentlyContinue
        }
    }
    return $files | Sort-Object FullName -Unique
}

function Test-DuplicateFormAction {
    param([string]$Content)
    $issues = @()
    $formRegex = '<form\b[^>]*>'
    foreach ($m in [regex]::Matches($Content, $formRegex, 'IgnoreCase')) {
        $openTag = $m.Value
        $actionCount = ([regex]::Matches($openTag, 'action\s*=\s*"', 'IgnoreCase')).Count
        if ($actionCount -gt 1) {
            $issues += "Form has duplicate action attributes: $openTag"
        }
    }
    return $issues
}

function Test-MapIframeTitle {
    param([string]$Content)
    $issues = @()
    $iframeRegex = '<iframe\b[^>]*google\.com/maps[^>]*>'
    foreach ($m in [regex]::Matches($Content, $iframeRegex, 'IgnoreCase')) {
        $tag = $m.Value
        if (-not ($tag -match 'title\s*=')) {
            $issues += 'Google Maps <iframe> missing title attribute.'
        }
    }
    return $issues
}

function Test-CloseButtonAria {
    param([string]$Content)
    $issues = @()
    $btnRegex = '<button\b[^>]*class\s*=\s*"[^"]*close-sidebar[^"]*"[^>]*>'
    foreach ($m in [regex]::Matches($Content, $btnRegex, 'IgnoreCase')) {
        $tag = $m.Value
        if ($tag -notmatch 'aria-label\s*=') {
            $issues += 'Close button (.close-sidebar) missing aria-label.'
        }
    }
    return $issues
}

function Test-ButtonSemantic {
    param([string]$Content)
    $issues = @()
    $btnRegex = '<button\b[^>]*>'
    foreach ($m in [regex]::Matches($Content, $btnRegex, 'IgnoreCase')) {
        $tag = $m.Value
        if ($tag -match 'role\s*=\s*"button"') {
            $issues += 'Redundant role="button" on <button>.'
        }
        if ($tag -match 'tabindex\s*=\s*"-?\d+"') {
            $issues += 'Redundant tabindex on <button>.'
        }
    }
    return $issues
}

function Test-JsonLdCurrency {
    param([string]$Content)
    $issues = @()
    if ($Content -match '[�\?]\s*\d{1,3}(?:,\d{3})*(?:\.\d+)?') {
        $issues += 'Suspicious currency symbol encoding in text/JSON-LD (e.g., �25 or ?25).'
    }
    if ($Content -match 'Â£') {
        $issues += 'Mojibake detected for pound sign (Â£). Use £ or \u00A3.'
    }
    return $issues
}

function Test-LogoPathJsonLd {
    param([string]$Content, [string]$BasePath)
    $issues = @()
    $logoRegex = '"logo"\s*:\s*"([^"]+)"'
    foreach ($m in [regex]::Matches($Content, $logoRegex, 'IgnoreCase')) {
        $url = $m.Groups[1].Value
        if ($url -match '/images/logo\.png$') {
            $local = Join-Path $BasePath 'images/logo.png'
            if (-not (Test-Path $local)) {
                $issues += 'JSON-LD references /images/logo.png but file not found.'
            }
        }
    }
    return $issues
}

function Test-MissingOverlay {
    param([string]$Content)
    $issues = @()
    if ($Content -match 'class\s*=\s*"[^"]*mobile-sidebar[^"]*"' -and $Content -notmatch 'class\s*=\s*"[^"]*sidebar-overlay[^"]*"') {
        $issues += 'Mobile sidebar present but missing .sidebar-overlay element.'
    }
    return $issues
}

function Test-MultipleH1 {
    param([string]$Content)
    $issues = @()
    $count = ([regex]::Matches($Content, '<h1\b', 'IgnoreCase')).Count
    if ($count -gt 1) { $issues += "Multiple <h1> elements found ($count)." }
    return $issues
}

function Test-CollapseToggleAria {
    param([string]$Content)
    $issues = @()
    $btnRegex = '<(button|a)\b[^>]*class\s*=\s*"[^"]*collapse-toggle[^"]*"[^>]*>'
    foreach ($m in [regex]::Matches($Content, $btnRegex, 'IgnoreCase')) {
        $tag = $m.Value
        if ($tag -notmatch 'aria-expanded\s*=') {
            $issues += 'Collapse toggle missing aria-expanded attribute.'
        }
        if ($tag -notmatch 'aria-controls\s*=') {
            $issues += 'Collapse toggle missing aria-controls attribute.'
        }
    }
    return $issues
}

function Test-IconAriaHidden {
    param([string]$Content)
    $issues = @()
    $icons = [regex]::Matches($Content, '<i\b[^>]*class\s*=\s*"[^"]*fa[\w\s\-]*"[^>]*>', 'IgnoreCase')
    $missing = 0
    foreach ($m in $icons) {
        $tag = $m.Value
        if ($tag -notmatch 'aria-hidden\s*=') { $missing++ }
    }
    if ($missing -gt 0) {
        $issues += "FontAwesome <i> without aria-hidden (count=$missing). Add when decorative."
    }
    return $issues
}

function Resolve-LinkPath {
    param([string]$Href, [string]$BasePath)
    if ($Href -match '^(https?:)?//') { return $null }
    $p = $Href
    $p = $p.TrimStart('/')
    while ($p.StartsWith('../')) { $p = $p.Substring(3) }
    return Join-Path $BasePath $p
}

function Test-BrokenLanguageLinks {
    param([string]$Content, [string]$BasePath)
    $issues = @()
    $rx = 'href\s*=\s*"([^"]*languages/[^"]+?\.html)"'
    foreach ($m in [regex]::Matches($Content, $rx, 'IgnoreCase')) {
        $href = $m.Groups[1].Value
        $local = Resolve-LinkPath -Href $href -BasePath $BasePath
        if ($null -ne $local) {
            if (-not (Test-Path $local)) {
                $issues += "Link to non-existent language page: $href"
            }
        }
    }
    return $issues
}

function Test-KnownTypos {
    param([string]$Content)
    $issues = @()
    if ($Content -match '>\s*Bajunu Translation\s*<') { $issues += 'Possible typo: "Bajunu" (did you mean "Bajuni"?).' }
    if ($Content -match '>\s*Mandingo Translation\s*<') { $issues += 'Possible duplicate/variant: "Mandingo" vs "Mandinka".' }
    return $issues
}

function Audit-File {
    param([System.IO.FileInfo]$File, [string]$RepoRoot)
    $content = Get-Content -Path $File.FullName -Raw
    $issues = @()
    $issues += Test-DuplicateFormAction -Content $content
    $issues += Test-MapIframeTitle -Content $content
    $issues += Test-CloseButtonAria -Content $content
    $issues += Test-ButtonSemantic -Content $content
    $issues += Test-JsonLdCurrency -Content $content
    $issues += Test-LogoPathJsonLd -Content $content -BasePath $RepoRoot
    $issues += Test-MissingOverlay -Content $content
    $issues += Test-MultipleH1 -Content $content
    $issues += Test-CollapseToggleAria -Content $content
    $issues += Test-IconAriaHidden -Content $content
    $issues += Test-BrokenLanguageLinks -Content $content -BasePath $RepoRoot
    $issues += Test-KnownTypos -Content $content
    return , $issues
}

Write-Section "Ace-Lang Website Audit"
$repoRoot = Resolve-Path $RootPath
$files = Get-HtmlFiles -Base $repoRoot
if (-not $files) {
    Write-Error "No HTML files found under $repoRoot"
    exit 1
}

$totalIssues = 0
$fileIssueMap = @{}

foreach ($f in $files) {
    $issues = Audit-File -File $f -RepoRoot $repoRoot
    if ($issues.Count -gt 0) {
        $fileIssueMap[$f.FullName] = $issues
        $totalIssues += $issues.Count
        if (-not $SummaryOnly) {
            Write-Host ("`n[ISSUES] {0}" -f ($f.FullName.Replace($repoRoot, '.'))) -ForegroundColor Yellow
            $idx = 1
            foreach ($i in $issues) {
                Write-Host ("  {0}. {1}" -f $idx, $i) -ForegroundColor White
                $idx++
            }
        }
    }
}

Write-Host "`n" -NoNewline
Write-Section "Summary"
Write-Host ("Scanned files: {0}" -f $files.Count) -ForegroundColor Gray
Write-Host ("Files with issues: {0}" -f $fileIssueMap.Keys.Count) -ForegroundColor Gray
Write-Host ("Total issues: {0}" -f $totalIssues) -ForegroundColor Gray

if ($fileIssueMap.Keys.Count -gt 0 -and $SummaryOnly) {
    foreach ($k in $fileIssueMap.Keys) {
        $rel = $k.Replace($repoRoot, '.')
        Write-Host ("- {0}: {1} issue(s)" -f $rel, $fileIssueMap[$k].Count) -ForegroundColor Yellow
    }
}

Write-Host "`nChecks performed:" -ForegroundColor DarkGray
Write-Host "- Duplicate <form> action attributes" -ForegroundColor DarkGray
Write-Host "- Google Maps <iframe> missing title" -ForegroundColor DarkGray
Write-Host "- .close-sidebar buttons missing aria-label" -ForegroundColor DarkGray
Write-Host "- Redundant role/tabindex on <button>" -ForegroundColor DarkGray
Write-Host "- Currency symbol mojibake in JSON-LD/text" -ForegroundColor DarkGray
Write-Host "- JSON-LD logo path pointing to missing images/logo.png" -ForegroundColor DarkGray
Write-Host "- Mobile sidebar missing .sidebar-overlay" -ForegroundColor DarkGray
Write-Host "- Multiple <h1> occurrences" -ForegroundColor DarkGray
Write-Host "- Collapse toggle missing aria-expanded/aria-controls" -ForegroundColor DarkGray
Write-Host "- <i> icons missing aria-hidden (advisory)" -ForegroundColor DarkGray
Write-Host "- Broken links to languages/*.html" -ForegroundColor DarkGray
Write-Host "- Known typos (Bajunu/Mandingo)" -ForegroundColor DarkGray

if ($totalIssues -gt 0) { exit 2 } else { exit 0 }


