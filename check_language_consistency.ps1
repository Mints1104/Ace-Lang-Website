# Comprehensive language consistency checker for all language pages
# This script will identify any incorrect language references or inconsistencies

Write-Host "=== COMPREHENSIVE LANGUAGE CONSISTENCY CHECK ===" -ForegroundColor Green
Write-Host "Checking all 41 language pages for consistency issues..." -ForegroundColor Yellow
Write-Host ""

$issues = @()
$totalPages = 0
$pagesWithIssues = 0

# Get all language pages
$languagePages = Get-ChildItem "languages/*.html"

foreach ($page in $languagePages) {
    $totalPages++
    $fileName = $page.Name
    $expectedLanguage = $fileName -replace "-translation-services\.html$", ""
    $expectedLanguage = $expectedLanguage -replace "-", " "
    $expectedLanguage = (Get-Culture).TextInfo.ToTitleCase($expectedLanguage.ToLower())
    
    Write-Host "Checking: $fileName" -ForegroundColor Cyan
    
    # Read the page content
    $content = Get-Content $page.FullName -Raw
    $pageIssues = @()
    
    # Check 1: French references in non-French pages
    if ($expectedLanguage -ne "French") {
        $frenchReferences = [regex]::Matches($content, "French", [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        if ($frenchReferences.Count -gt 0) {
            $pageIssues += "Has $($frenchReferences.Count) French references"
        }
    }
    
    # Check 2: Incorrect language name in title
    $titleMatch = [regex]::Match($content, '<title>(.*?)</title>')
    if ($titleMatch.Success) {
        $title = $titleMatch.Groups[1].Value
        if ($title -notmatch $expectedLanguage) {
            $pageIssues += "Title mismatch: expected '$expectedLanguage' but found different language"
        }
    }
    
    # Check 3: Incorrect language name in hero section
    $heroMatch = [regex]::Match($content, '<h2>(.*?)</h2>')
    if ($heroMatch.Success) {
        $heroText = $heroMatch.Groups[1].Value
        if ($heroText -notmatch $expectedLanguage) {
            $pageIssues += "Hero section mismatch: expected '$expectedLanguage' but found different language"
        }
    }
    
    # Check 4: Incorrect language name in slogan
    $sloganMatch = [regex]::Match($content, 'class="slogan">(.*?)</p>')
    if ($sloganMatch.Success) {
        $slogan = $sloganMatch.Groups[1].Value
        if ($slogan -notmatch $expectedLanguage) {
            $pageIssues += "Slogan mismatch: expected '$expectedLanguage' but found different language"
        }
    }
    
    # Check 5: Incorrect language name in service titles
    $serviceMatches = [regex]::Matches($content, '<h3>(.*?)</h3>')
    foreach ($match in $serviceMatches) {
        $serviceTitle = $match.Groups[1].Value
        if ($serviceTitle -match "Translation" -and $serviceTitle -notmatch $expectedLanguage) {
            $pageIssues += "Service title mismatch: '$serviceTitle' should contain '$expectedLanguage'"
        }
    }
    
    # Check 6: Incorrect language name in business context
    $businessMatch = [regex]::Match($content, "Welsh-([^-]+) business relationships")
    if ($businessMatch.Success) {
        $businessLanguage = $businessMatch.Groups[1].Value
        if ($businessLanguage -ne $expectedLanguage) {
            $pageIssues += "Business context mismatch: expected '$expectedLanguage' but found '$businessLanguage'"
        }
    }
    
    # Check 7: Incorrect language name in community context
    $communityMatch = [regex]::Match($content, "([^-]+)-speaking community")
    if ($communityMatch.Success) {
        $communityLanguage = $communityMatch.Groups[1].Value
        if ($communityLanguage -ne $expectedLanguage) {
            $pageIssues += "Community context mismatch: expected '$expectedLanguage' but found '$communityLanguage'"
        }
    }
    
    # Check 8: Incorrect language name in footer links
    $footerMatch = [regex]::Match($content, '<li><a href="[^"]*">([^<]+)</a></li>')
    if ($footerMatch.Success) {
        $footerLanguage = $footerMatch.Groups[1].Value
        if ($footerLanguage -ne $expectedLanguage) {
            $pageIssues += "Footer link mismatch: expected '$expectedLanguage' but found '$footerLanguage'"
        }
    }
    
    # Check 9: Incorrect language name in HTML comments
    $commentMatches = [regex]::Matches($content, "<!-- ([^-]+) (Services Section|language Variants|Business & Community Context) -->")
    foreach ($match in $commentMatches) {
        $commentLanguage = $match.Groups[1].Value
        if ($commentLanguage -ne $expectedLanguage) {
            $pageIssues += "HTML comment mismatch: expected '$expectedLanguage' but found '$commentLanguage'"
        }
    }
    
    # Report issues for this page
    if ($pageIssues.Count -gt 0) {
        $pagesWithIssues++
        Write-Host "  ❌ ISSUES FOUND:" -ForegroundColor Red
        foreach ($issue in $pageIssues) {
            Write-Host "    - $issue" -ForegroundColor Red
            $issues += "$fileName`: $issue"
        }
    }
    else {
        Write-Host "  ✅ No issues found" -ForegroundColor Green
    }
    
    Write-Host ""
}

# Summary report
Write-Host "=== SUMMARY REPORT ===" -ForegroundColor Green
Write-Host "Total pages checked: $totalPages" -ForegroundColor White
Write-Host "Pages with issues: $pagesWithIssues" -ForegroundColor $(if ($pagesWithIssues -gt 0) { "Red" } else { "Green" })
Write-Host "Total issues found: $($issues.Count)" -ForegroundColor $(if ($issues.Count -gt 0) { "Red" } else { "Green" })

if ($issues.Count -gt 0) {
    Write-Host ""
    Write-Host "=== DETAILED ISSUES ===" -ForegroundColor Red
    foreach ($issue in $issues) {
        Write-Host "- $issue" -ForegroundColor Red
    }
}
else {
    Write-Host ""
    Write-Host "🎉 ALL PAGES ARE CONSISTENT! No language reference issues found." -ForegroundColor Green
}
