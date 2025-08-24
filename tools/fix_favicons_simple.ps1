# Simple Favicon Fix - No Backups
Write-Host "=== Adding Favicons to All HTML Pages (Simple) ===" -ForegroundColor Green

# Find all HTML files
$htmlFiles = Get-ChildItem -Path "." -Recurse -Filter "*.html"
Write-Host "Found $($htmlFiles.Count) HTML files to process" -ForegroundColor Cyan

$processedCount = 0
$skippedCount = 0

foreach ($file in $htmlFiles) {
    Write-Host "Processing: $($file.Name)" -ForegroundColor White
    
    # Read file content
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    # Check if favicon links already exist
    if ($content -match "<!-- Favicon -->") {
        Write-Host "  Favicon links already exist, skipping..." -ForegroundColor Yellow
        $skippedCount++
        continue
    }
    
    # Find the insertion point - look for the closing </head> tag
    if ($content -match "</head>") {
        # Insert favicon links before </head>
        $faviconLinks = "`n    <!-- Favicon -->`n    <link rel='icon' type='image/x-icon' href='/images/favicon.ico'>`n    <link rel='icon' type='image/png' sizes='16x16' href='/images/favicon-16x16.png'>`n    <link rel='icon' type='image/png' sizes='32x32' href='/images/favicon-32x32.png'>`n    <link rel='apple-touch-icon' sizes='180x180' href='/images/apple-touch-icon.png'>`n    <link rel='icon' type='image/png' sizes='192x192' href='/images/android-chrome-192x192.png'>`n    <link rel='icon' type='image/png' sizes='512x512' href='/images/android-chrome-512x512.png'>`n"
        
        $newContent = $content -replace "</head>", "$faviconLinks</head>"
        
        # Write the updated content back to the file
        Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8 -NoNewline
        Write-Host "  Favicon links added successfully" -ForegroundColor Green
        
        $processedCount++
    }
    else {
        Write-Host "  </head> tag not found, skipping..." -ForegroundColor Red
        $skippedCount++
    }
}

Write-Host "`n=== Summary ===" -ForegroundColor Green
Write-Host "Files processed: $processedCount" -ForegroundColor Green
Write-Host "Files skipped: $skippedCount" -ForegroundColor Yellow
Write-Host "Script completed!" -ForegroundColor Green
