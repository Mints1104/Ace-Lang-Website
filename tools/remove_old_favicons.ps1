# Remove old incorrect favicon links
Write-Host "=== Removing old incorrect favicon links ===" -ForegroundColor Green

# Find all HTML files
$htmlFiles = Get-ChildItem -Path "." -Recurse -Filter "*.html"
Write-Host "Found $($htmlFiles.Count) HTML files to process" -ForegroundColor Cyan

$processedCount = 0
$skippedCount = 0

foreach ($file in $htmlFiles) {
    Write-Host "Processing: $($file.Name)" -ForegroundColor White
    
    # Read file content
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    # Check if favicon links exist
    if ($content -match "<!-- Favicon -->") {
        # Create backup
        $backupPath = "$($file.FullName).backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        Copy-Item -Path $file.FullName -Destination $backupPath
        Write-Host "  Backup created" -ForegroundColor Green
        
        # Remove the favicon section
        $newContent = $content -replace "    <!-- Favicon -->\r?\n    <link rel='icon' type='image/x-icon' href='/favicon.ico'>\r?\n    <link rel='icon' type='image/png' sizes='16x16' href='/favicon-16x16.png'>\r?\n    <link rel='icon' type='image/png' sizes='32x32' href='/favicon-32x32.png'>\r?\n    <link rel='apple-touch-icon' sizes='180x180' href='/apple-touch-icon.png'>\r?\n    <link rel='icon' type='image/png' sizes='192x192' href='/android-chrome-192x192.png'>\r?\n    <link rel='icon' type='image/png' sizes='512x512' href='/android-chrome-512x512.png'>", ""
        
        # Write the updated content back to the file
        Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8 -NoNewline
        Write-Host "  Old favicon links removed successfully" -ForegroundColor Green
        
        $processedCount++
    } else {
        Write-Host "  No favicon links found, skipping..." -ForegroundColor Yellow
        $skippedCount++
    }
}

Write-Host "`n=== Summary ===" -ForegroundColor Green
Write-Host "Files processed: $processedCount" -ForegroundColor Green
Write-Host "Files skipped: $skippedCount" -ForegroundColor Yellow
Write-Host "Script completed!" -ForegroundColor Green
