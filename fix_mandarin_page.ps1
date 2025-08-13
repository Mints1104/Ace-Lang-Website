# Script to fix the Mandarin page to use "Mandarin" consistently instead of "Chinese"

Write-Host "Fixing Mandarin page to use consistent language naming..." -ForegroundColor Yellow

$mandarinFile = "languages/mandarin-translation-services.html"
$content = Get-Content $mandarinFile -Raw

# Replace Chinese with Mandarin in various contexts
$content = $content -replace "Professional Chinese Translators", "Professional Mandarin Translators"
$content = $content -replace "Certified Chinese translators", "Certified Mandarin translators"
$content = $content -replace "Chinese translator Swansea", "Mandarin translator Swansea"
$content = $content -replace "Chinese translator Cardiff", "Mandarin translator Cardiff"
$content = $content -replace "Chinese document translation", "Mandarin document translation"
$content = $content -replace "certified Chinese translator Bristol", "certified Mandarin translator Bristol"
$content = $content -replace "Chinese Business Translation", "Mandarin Business Translation"
$content = $content -replace "Chinese Document Translation", "Mandarin Document Translation"
$content = $content -replace "Chinese Legal Translation", "Mandarin Legal Translation"
$content = $content -replace "Chinese Medical Translation", "Mandarin Medical Translation"
$content = $content -replace "Chinese Interpretation Services", "Mandarin Interpretation Services"
$content = $content -replace "Chinese Language Expertise", "Mandarin Language Expertise"
$content = $content -replace "Chinese students", "Mandarin students"
$content = $content -replace "Chinese documents", "Mandarin documents"
$content = $content -replace "Chinese-speaking patients", "Mandarin-speaking patients"
$content = $content -replace "Get Chinese Translation Quote", "Get Mandarin Translation Quote"
$content = $content -replace "Welsh-Chinese business partnerships", "Welsh-Mandarin business partnerships"
$content = $content -replace "Chinese community", "Mandarin community"
$content = $content -replace "Chinese Language Variants", "Mandarin Language Variants"

# Fix HTML comments
$content = $content -replace "<!-- Chinese Services Section -->", "<!-- Mandarin Services Section -->"
$content = $content -replace "<!-- Chinese Language Variants -->", "<!-- Mandarin Language Variants -->"

# Fix specific text that should remain "Chinese" for regional context
$content = $content -replace "Simplified Chinese for business with mainland China", "Simplified Mandarin for business with mainland China"
$content = $content -replace "Traditional Chinese translators for business with Taiwan and Hong Kong", "Traditional Mandarin translators for business with Taiwan and Hong Kong"

# Write the updated content back
$content | Out-File -FilePath $mandarinFile -Encoding UTF8

Write-Host "✅ Mandarin page has been updated to use consistent language naming!" -ForegroundColor Green
Write-Host "All 'Chinese' references have been changed to 'Mandarin' where appropriate." -ForegroundColor Green
