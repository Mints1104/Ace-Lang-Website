# PowerShell script to generate 5 new high-impact language pages
# Based on the French translation services template - FIXED VERSION
# Languages selected from index.html that are supported but missing

$languages = @(
    @{Name = "Oromo"; Native = "Oromo"; Region = "african" },
    @{Name = "Tigrinya"; Native = "Tigrinya"; Region = "african" },
    @{Name = "Amharic"; Native = "Amharic"; Region = "african" },
    @{Name = "Nuer"; Native = "Nuer"; Region = "african" },
    @{Name = "Lingala"; Native = "Lingala"; Region = "african" }
)

$templateFile = "languages/french-translation-services.html"

foreach ($lang in $languages) {
    $langName = $lang.Name
    $nativeName = $lang.Native
    $region = $lang.Region
    $outputFile = "languages/$($langName.ToLower())-translation-services.html"
    
    Write-Host "Generating $langName translation services page..."
    
    # Read the template file
    $content = Get-Content $templateFile -Raw
    
    # Replace French-specific content with the new language - COMPREHENSIVE REPLACEMENT
    $content = $content -replace "French Translation Services Newport Cardiff Swansea Wales", "$nativeName Translation Services Newport Cardiff Swansea Wales"
    $content = $content -replace "Professional French Translators", "Professional $nativeName Translators"
    $content = $content -replace "Expert French translation", "Expert $nativeName translation"
    $content = $content -replace "Certified French translators", "Certified $nativeName translators"
    $content = $content -replace "French translation Newport", "$nativeName translation Newport"
    $content = $content -replace "French translation Swansea", "$nativeName translation Swansea"
    $content = $content -replace "French translator Swansea", "$nativeName translator Swansea"
    $content = $content -replace "French translator Cardiff", "$nativeName translator Cardiff"
    $content = $content -replace "French interpreter Wales", "$nativeName interpreter Wales"
    $content = $content -replace "French document translation", "$nativeName document translation"
    $content = $content -replace "certified French translator Bristol", "certified $nativeName translator Bristol"
    $content = $content -replace "French business translation", "$nativeName business translation"
    $content = $content -replace "French legal translation Wales", "$nativeName legal translation Wales"
    $content = $content -replace "French Translation Services Newport Cardiff Swansea Wales", "$nativeName Translation Services Newport Cardiff Swansea Wales"
    $content = $content -replace "Expert French translation & interpretation services in Newport, Cardiff, Swansea, Bristol & Wales", "Expert $nativeName translation & interpretation services in Newport, Cardiff, Swansea, Bristol & Wales"
    $content = $content -replace "Certified French translators since 2003", "Certified $nativeName translators since 2003"
    $content = $content -replace "Expert French translation services in Newport, Cardiff, Bristol & Wales", "Expert $nativeName translation services in Newport, Cardiff, Bristol & Wales"
    $content = $content -replace "French Translation Services", "$nativeName Translation Services"
    $content = $content -replace "Professional French translation and interpretation services", "Professional $nativeName translation and interpretation services"
    $content = $content -replace "Certified French translators for legal, medical, business and personal documents", "Certified $nativeName translators for legal, medical, business and personal documents"
    $content = $content -replace "french-translation-services.html", "$($langName.ToLower())-translation-services.html"
    $content = $content -replace "acelang.com/french-translation-services.html", "acelang.com/$($langName.ToLower())-translation-services.html"
    $content = $content -replace "cy/french-translation-services.html", "cy/$($langName.ToLower())-translation-services.html"
    
    # Update the title
    $content = $content -replace "French Translation Services Newport Cardiff Swansea Wales \| Professional French Translators \| Ace Language Services", "$nativeName Translation Services Newport Cardiff Swansea Wales | Professional $nativeName Translators | Ace Language Services"
    
    # Update the meta description
    $content = $content -replace "Expert French translation & interpretation services in Newport, Cardiff, Bristol & Wales", "Expert $nativeName translation & interpretation services in Newport, Cardiff, Bristol & Wales"
    
    # Update the meta keywords
    $content = $content -replace "French translation Newport, French translation Swansea, French translator Swansea, French translator Cardiff, French interpreter Wales, French document translation, certified French translator Bristol, French business translation, French legal translation Wales", "$nativeName translation Newport, $nativeName translation Swansea, $nativeName translator Swansea, $nativeName translator Cardiff, $nativeName interpreter Wales, $nativeName document translation, certified $nativeName translator Bristol, $nativeName business translation, $nativeName legal translation Wales"
    
    # Update the canonical URL
    $content = $content -replace "https://www.acelang.com/french-translation-services.html", "https://www.acelang.com/$($langName.ToLower())-translation-services.html"
    
    # Update the Open Graph URL
    $content = $content -replace "https://www.acelang.com/french-translation-services.html", "https://www.acelang.com/$($langName.ToLower())-translation-services.html"
    
    # Update the schema markup
    $content = $content -replace '"name": "French Translation Services"', '"name": "$nativeName Translation Services"'
    $content = $content -replace '"description": "Professional French translation and interpretation services', '"description": "Professional $nativeName translation and interpretation services'
    $content = $content -replace '"name": "French Translation Services"', '"name": "$nativeName Translation Services"'
    $content = $content -replace '"description": "Professional French translation and interpretation services in Newport, Cardiff, Swansea, Bristol and throughout Wales', '"description": "Professional $nativeName translation and interpretation services in Newport, Cardiff, Swansea, Bristol and throughout Wales'
    $content = $content -replace '"name": "French Translation Services"', '"name": "$nativeName Translation Services"'
    
    # Update the page content sections - COMPREHENSIVE CONTENT REPLACEMENT
    $content = $content -replace "French Translation Services", "$nativeName Translation Services"
    $content = $content -replace "French translation", "$nativeName translation"
    $content = $content -replace "French translator", "$nativeName translator"
    $content = $content -replace "French interpreter", "$nativeName interpreter"
    $content = $content -replace "French language", "$nativeName language"
    $content = $content -replace "French speakers", "$nativeName speakers"
    $content = $content -replace "French community", "$nativeName community"
    $content = $content -replace "French culture", "$nativeName culture"
    $content = $content -replace "French documents", "$nativeName documents"
    $content = $content -replace "French text", "$nativeName text"
    $content = $content -replace "French content", "$nativeName content"
    $content = $content -replace "French version", "$nativeName version"
    $content = $content -replace "French to English", "$nativeName to English"
    $content = $content -replace "English to French", "English to $nativeName"
    
    # Additional replacements for content sections that were missed
    $content = $content -replace "Welsh-French business relationships", "Welsh-$nativeName business relationships"
    $content = $content -replace "Francophone community", "$nativeName-speaking community"
    $content = $content -replace "French markets", "$nativeName markets"
    $content = $content -replace "French students", "$nativeName students"
    $content = $content -replace "French Legal Translation", "$nativeName Legal Translation"
    $content = $content -replace "French Medical Translation", "$nativeName Medical Translation"
    $content = $content -replace "French-speaking patients", "$nativeName-speaking patients"
    $content = $content -replace "French Interpretation Services", "$nativeName Interpretation Services"
    $content = $content -replace "French Interpretation", "$nativeName Interpretation"
    $content = $content -replace "Face-to-face and telephone French interpretation services", "Face-to-face and telephone $nativeName interpretation services"
    $content = $content -replace "Metropolitan French", "Standard $nativeName"
    $content = $content -replace "Native Albanian translators specializing in standard French", "Native $nativeName translators specializing in standard $nativeName"
    $content = $content -replace "Canadian French", "Regional $nativeName"
    $content = $content -replace "Expert Canadian Albanian translators for business with Quebec", "Expert regional $nativeName translators for business with $nativeName-speaking regions"
    $content = $content -replace "French-speaking Canada", "$nativeName-speaking regions"
    $content = $content -replace "French Business & Community Context", "$nativeName Business & Community Context"
    $content = $content -replace "French-speaking", "$nativeName-speaking"
    
    # Fix HTML comments and specific sections
    $content = $content -replace "<!-- French Services Section -->", "<!-- $nativeName Services Section -->"
    $content = $content -replace "<!-- French language Variants -->", "<!-- $nativeName language Variants -->"
    $content = $content -replace "<!-- French Business & Community Context -->", "<!-- $nativeName Business & Community Context -->"
    
    # REMOVED: Footer link replacement - keeping French reference in footer as intended
    
    # Fix specific text that still references French
    $content = $content -replace "for business with France", "for business with $nativeName-speaking regions"
    $content = $content -replace "academic institutions, and official government communications", "academic institutions, and official government communications"
    $content = $content -replace "specialized Quebec terminology and cultural adaptation", "specialized regional terminology and cultural adaptation"
    
    # Catch the remaining "standard French" references
    $content = $content -replace "specializing in standard French", "specializing in standard $nativeName"
    
    # Update the region data attribute if needed
    $content = $content -replace 'data-region="european"', "data-region=`"$region`""
    
    # Write the new file
    $content | Out-File -FilePath $outputFile -Encoding UTF8
    
    Write-Host "Created: $outputFile"
}

Write-Host "`nAll 5 new language pages have been generated successfully!"
Write-Host "Generated pages:"
foreach ($lang in $languages) {
    Write-Host "- $($lang.Name) ($($lang.Native))"
}
