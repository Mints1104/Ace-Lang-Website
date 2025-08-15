$ErrorActionPreference = 'Stop'

$files = Get-ChildItem -Recurse -File -Include *.html
foreach ($f in $files) {
    $c = Get-Content -Raw -Path $f.FullName

    # Remove obsolete/low-value meta tags
    $c = [regex]::Replace($c, '(?im)^\s*<meta\s+name="keywords"[^>]*>\s*\r?\n?', '')
    $c = [regex]::Replace($c, '(?im)^\s*<meta\s+name="distribution"[^>]*>\s*\r?\n?', '')
    $c = [regex]::Replace($c, '(?im)^\s*<meta\s+name="rating"[^>]*>\s*\r?\n?', '')
    $c = [regex]::Replace($c, '(?im)^\s*<meta\s+name="revisit-after"[^>]*>\s*\r?\n?', '')

    # Remove social image/twitter meta (user preference)
    $c = [regex]::Replace($c, '(?im)^\s*<meta\s+property="og:image"[^>]*>\s*\r?\n?', '')
    $c = [regex]::Replace($c, '(?im)^\s*<meta\s+property="og:site_name"[^>]*>\s*\r?\n?', '')
    $c = [regex]::Replace($c, '(?im)^\s*<meta\s+name="twitter:card"[^>]*>\s*\r?\n?', '')
    $c = [regex]::Replace($c, '(?im)^\s*<meta\s+name="twitter:image"[^>]*>\s*\r?\n?', '')

    # Remove non-existent Welsh hreflang alternates
    $c = [regex]::Replace($c, '(?is)\s*<link\s+rel="alternate"\s+hreflang="cy"[^>]*>\s*', '')

    # Ensure security rel on target _blank links
    $c = [regex]::Replace($c, 'target="_blank"(?![^>]*\srel=)', 'target="_blank" rel="noopener noreferrer"')

    # Add id to mobile sidebar containers
    $c = $c -replace '<div\s+class="mobile-sidebar">', '<div class="mobile-sidebar" id="mobile-sidebar">'

    # Add ARIA to burger-menu button if missing
    $c = [regex]::Replace($c, '<button\s+class="burger-menu"((?:(?!>).)*)>', {
        param($m)
        $tag = $m.Value
        if ($tag -notmatch 'aria-controls') { $tag = $tag -replace '>$',' aria-controls="mobile-sidebar">' }
        if ($tag -notmatch 'aria-expanded') { $tag = $tag -replace '>$',' aria-expanded="false">' }
        if ($tag -notmatch '\stype=') { $tag = $tag -replace '>$',' type="button">' }
        return $tag
    })

    # Add ARIA role/tabindex for div-based burger-menu (fallback)
    $c = [regex]::Replace($c, '<div\s+class="burger-menu"((?:(?!>).)*)>', {
        param($m)
        $tag = $m.Value
        if ($tag -notmatch 'aria-controls') { $tag = $tag -replace '>$',' aria-controls="mobile-sidebar">' }
        if ($tag -notmatch 'aria-expanded') { $tag = $tag -replace '>$',' aria-expanded="false">' }
        if ($tag -notmatch 'role=') { $tag = $tag -replace '>$',' role="button">' }
        if ($tag -notmatch 'tabindex=') { $tag = $tag -replace '>$',' tabindex="0">' }
        return $tag
    })

    # Netlify forms: ensure method and action present
    $c = [regex]::Replace($c, '(<form(?=[^>]*data-netlify="true")(?![^>]*method=)(?![^>]*action=)[^>]*)>', '$1 method="POST" action="/">')
    $c = [regex]::Replace($c, '(<form(?=[^>]*data-netlify="true")[^>]*method="POST"[^>]*)(?![^>]*action=)([^>]*)>', '$1$2 action="/">')

    # Mandarin canonical/og:url correction
    if ($f.Name -eq 'mandarin-translation-services.html' -and $f.DirectoryName -like '*\languages') {
        $c = $c -replace 'https://www\.acelang\.com/mandarin-translation-services\.html', 'https://www.acelang.com/languages/mandarin-translation-services.html'
    }

    # Fix subdir anchors to root sections (../#...)
    if ($f.DirectoryName -like '*\languages' -or $f.DirectoryName -like '*\locations') {
        $c = $c -replace 'href="index\.html#', 'href="../#'
    }

    # Normalize incorrect phone
    $c = $c -replace '\+44-1633-123456', '+441633266201'

    Set-Content -Path $f.FullName -Value $c -Encoding UTF8
}

Write-Host "Batch fixes applied to $($files.Count) HTML files."


