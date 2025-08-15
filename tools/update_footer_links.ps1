$ErrorActionPreference = 'Stop'

# Standard lists
$servicesLanguagesList = @(
    '                        <li><a href="/#services">Our Services</a></li>',
    '                        <li><a href="/languages/polish-translation-services.html">Polish</a></li>',
    '                        <li><a href="/languages/arabic-translation-services.html">Arabic</a></li>',
    '                        <li><a href="/languages/spanish-translation-services.html">Spanish</a></li>',
    '                        <li><a href="/languages/french-translation-services.html">French</a></li>',
    '                        <li><a href="/languages/welsh-translation-services.html">Welsh</a></li>',
    '                        <li><a href="/languages/">All Languages</a></li>'
)

$servicesLanguagesList404 = @(
    '                        <li><a href="/#services">Our Services</a></li>',
    '                        <li><a href="/languages/">All Languages</a></li>'
)

$quickLinksList = @(
    '                        <li><a href="/#about">About Us</a></li>',
    '                        <li><a href="/#contact">Contact</a></li>',
    '                        <li><a href="/careers.html">Careers</a></li>',
    '                        <li><a href="/locations/">All Locations</a></li>'
)

$files = Get-ChildItem -Recurse -File -Include *.html

foreach ($f in $files) {
    $c = Get-Content -Raw -Path $f.FullName

    # Normalize malformed <ul> tags that may be missing the closing '>' before a newline
    $c = [regex]::Replace($c, '(?im)<ul\s*(?=\r?\n)', '<ul>')

    # Replace Services & Languages UL if present
    if ($c -match '<h3>Services\s*&\s*Languages</h3>') {
        $list = if ($f.Name -ieq '404.html') { $servicesLanguagesList404 } else { $servicesLanguagesList }
        # Ensure the opening <ul> includes the closing '>' so output is valid
        $c = [regex]::Replace($c, '(?is)(<h3>Services\s*&\s*Languages</h3>\s*<ul\s*>)([\s\S]*?)(</ul>)', "`$1`r`n$($list -join "`r`n")`r`n                    `$3")
    }

    # Replace Quick Links UL to standardized hub list
    if ($c -match '<h3>Quick\s*Links</h3>') {
        # Ensure the opening <ul> includes the closing '>' so output is valid
        $c = [regex]::Replace($c, '(?is)(<h3>Quick\s*Links</h3>\s*<ul\s*>)([\s\S]*?)(</ul>)', "`$1`r`n$($quickLinksList -join "`r`n")`r`n                    `$3")
    }

    Set-Content -Path $f.FullName -Value $c -NoNewline
}

Write-Host "Footer links updated."

