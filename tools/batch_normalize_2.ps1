$ErrorActionPreference = 'Stop'

$files = Get-ChildItem -Recurse -File -Include *.html

foreach ($f in $files) {
    $c = Get-Content -Raw -Path $f.FullName

    # 1) Convert div.burger-menu → button.burger-menu (preserve inner burger-icon)
    $c = [regex]::Replace(
        $c,
        '<div class="burger-menu"([^>]*)>\s*(<div class="burger-icon">[\s\S]*?</div>)\s*</div>',
        '<button class="burger-menu"$1 type="button">$2</button>',
        'Singleline'
    )

    # 2) Ensure mobile sidebar has id="mobile-sidebar"
    $c = [regex]::Replace(
        $c,
        '<div class="mobile-sidebar"(?![^>]*id=)',
        '<div class="mobile-sidebar" id="mobile-sidebar"',
        'Singleline'
    )

    # 3) Deduplicate duplicate action attributes introduced earlier
    $c = [regex]::Replace(
        $c,
        '<form([^>]*?)action="/"(.*?)action="/"(.*?)>',
        '<form$1action="/"$2$3>',
        'Singleline'
    )

    # 3b) Ensure Netlify forms have method and action
    # Add method if missing
    $c = [regex]::Replace(
        $c,
        '(<form[^>]*data-netlify="true"(?![^>]*\bmethod=)([^>]*))>',
        '$1 method="POST">',
        'Singleline'
    )
    # Add action if missing
    $c = [regex]::Replace(
        $c,
        '(<form[^>]*data-netlify="true"(?![^>]*\baction=)([^>]*))>',
        '$1 action="/">',
        'Singleline'
    )

    # 4) Normalize canonical/og:url/hreflang paths for language and location detail pages
    if ($f.DirectoryName -match "\\languages(\\|$)" -and $f.Name -ne 'index.html') {
        $fname = $f.Name
        $c = [regex]::Replace($c, '<link\s+rel="canonical"\s+href="https://www\.acelang\.com/[^"#>]*"', "<link rel=\"canonical\" href=\"https://www.acelang.com/languages/$fname\"")
        $c = [regex]::Replace($c, '<meta\s+property="og:url"\s+content="https://www\.acelang\.com/[^"#>]*"', "<meta property=\"og:url\" content=\"https://www.acelang.com/languages/$fname\"")
        $c = [regex]::Replace($c, '<link\s+rel="alternate"\s+hreflang="en-GB"\s+href="https://www\.acelang\.com/[^"#>]*"', "<link rel=\"alternate\" hreflang=\"en-GB\" href=\"https://www.acelang.com/languages/$fname\"")
        $c = [regex]::Replace($c, '<link\s+rel="alternate"\s+hreflang="x-default"\s+href="https://www\.acelang\.com/[^"#>]*"', "<link rel=\"alternate\" hreflang=\"x-default\" href=\"https://www.acelang.com/languages/$fname\"")
    }
    elseif ($f.DirectoryName -match "\\locations(\\|$)" -and $f.Name -ne 'index.html') {
        $fname = $f.Name
        $c = [regex]::Replace($c, '<link\s+rel="canonical"\s+href="https://www\.acelang\.com/[^"#>]*"', "<link rel=\"canonical\" href=\"https://www.acelang.com/locations/$fname\"")
        $c = [regex]::Replace($c, '<meta\s+property="og:url"\s+content="https://www\.acelang\.com/[^"#>]*"', "<meta property=\"og:url\" content=\"https://www.acelang.com/locations/$fname\"")
        $c = [regex]::Replace($c, '<link\s+rel="alternate"\s+hreflang="en-GB"\s+href="https://www\.acelang\.com/[^"#>]*"', "<link rel=\"alternate\" hreflang=\"en-GB\" href=\"https://www.acelang.com/locations/$fname\"")
        $c = [regex]::Replace($c, '<link\s+rel="alternate"\s+hreflang="x-default"\s+href="https://www\.acelang\.com/[^"#>]*"', "<link rel=\"alternate\" hreflang=\"x-default\" href=\"https://www.acelang.com/locations/$fname\"")
    }

    Set-Content -Path $f.FullName -Value $c -NoNewline
}

Write-Host "Normalization complete."

