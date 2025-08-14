# PowerShell script to add improved breadcrumbs to all HTML files
# This script will add proper breadcrumbs with context for different page types

Write-Host "Adding improved breadcrumbs to all HTML files..." -ForegroundColor Green

# Function to add breadcrumbs to the home page (index.html)
function Add-HomePageBreadcrumbs {
    param([string]$FilePath)
    
    try {
        $content = Get-Content $FilePath -Raw -Encoding UTF8
        
        # Check if breadcrumbs.css is already added
        if ($content -match "breadcrumbs\.css") {
            Write-Host "Skipping $FilePath - breadcrumbs already added" -ForegroundColor Yellow
            return
        }
        
        # Add breadcrumbs.css link after utility.css
        $content = $content -replace '(<link rel="stylesheet" href="css/utility\.css">)', '$1`n    <link rel="stylesheet" href="css/breadcrumbs.css">'
        
        # Add breadcrumbs HTML structure after sidebar-overlay and before Hero Section
        $content = $content -replace '(<div class="sidebar-overlay"></div>)', '$1

    <!-- =========================
         2. Breadcrumb Navigation
         ========================= -->
    <nav class="breadcrumbs" aria-label="Breadcrumb">
        <div class="breadcrumbs-container">
            <ol class="breadcrumbs-list">
                <li class="breadcrumbs-item">
                    <span class="breadcrumbs-current breadcrumbs-home">
                        <i class="fas fa-home"></i>
                        <span>Home</span>
                    </span>
                </li>
            </ol>
        </div>
    </nav>'
        
        # Write the updated content back to the file
        Set-Content $FilePath $content -Encoding UTF8
        Write-Host "Added home page breadcrumbs to $FilePath" -ForegroundColor Green
    }
    catch {
        Write-Host "Error processing $FilePath : $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Function to add breadcrumbs to language pages
function Add-LanguagePageBreadcrumbs {
    param([string]$FilePath)
    
    try {
        $content = Get-Content $FilePath -Raw -Encoding UTF8
        
        # Check if breadcrumbs.css is already added
        if ($content -match "breadcrumbs\.css") {
            Write-Host "Skipping $FilePath - breadcrumbs already added" -ForegroundColor Yellow
            return
        }
        
        # Extract language name from filename (e.g., "polish-translation-services.html" -> "Polish")
        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($FilePath)
        $languageName = $fileName -replace '-translation-services$', ''
        $languageName = (Get-Culture).TextInfo.ToTitleCase($languageName.ToLower())
        
        # Add breadcrumbs.css link after utility.css
        $content = $content -replace '(<link rel="stylesheet" href="\.\./css/utility\.css">)', '$1`n    <link rel="stylesheet" href="../css/breadcrumbs.css">'
        
        # Add breadcrumbs HTML structure after sidebar-overlay and before Hero Section
        $content = $content -replace '(<div class="sidebar-overlay"></div>)', '$1

    <!-- =========================
         2. Breadcrumb Navigation
         ========================= -->
    <nav class="breadcrumbs" aria-label="Breadcrumb">
        <div class="breadcrumbs-container">
            <ol class="breadcrumbs-list">
                <li class="breadcrumbs-item">
                    <a href="../" class="breadcrumbs-link breadcrumbs-home">
                        <i class="fas fa-home"></i>
                        <span>Home</span>
                    </a>
                </li>
                <li class="breadcrumbs-item">
                    <span class="breadcrumbs-category">Language Services</span>
                </li>
                <li class="breadcrumbs-item">
                    <span class="breadcrumbs-current breadcrumbs-current-page">' + $languageName + '</span>
                </li>
            </ol>
        </div>
    </nav>'
        
        # Write the updated content back to the file
        Set-Content $FilePath $content -Encoding UTF8
        Write-Host "Added language page breadcrumbs to $FilePath" -ForegroundColor Green
    }
    catch {
        Write-Host "Error processing $FilePath : $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Function to add breadcrumbs to location pages
function Add-LocationPageBreadcrumbs {
    param([string]$FilePath)
    
    try {
        $content = Get-Content $FilePath -Raw -Encoding UTF8
        
        # Check if breadcrumbs.css is already added
        if ($content -match "breadcrumbs\.css") {
            Write-Host "Skipping $FilePath - breadcrumbs already added" -ForegroundColor Yellow
            return
        }
        
        # Extract city name from filename (e.g., "translation-services-cardiff.html" -> "Cardiff")
        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($FilePath)
        $cityName = $fileName -replace 'translation-services-', ''
        $cityName = (Get-Culture).TextInfo.ToTitleCase($cityName.ToLower())
        
        # Add breadcrumbs.css link after utility.css
        $content = $content -replace '(<link rel="stylesheet" href="\.\./css/utility\.css">)', '$1`n    <link rel="stylesheet" href="../css/breadcrumbs.css">'
        
        # Add breadcrumbs HTML structure after sidebar-overlay and before Hero Section
        $content = $content -replace '(<div class="sidebar-overlay"></div>)', '$1

    <!-- =========================
         2. Breadcrumb Navigation
         ========================= -->
    <nav class="breadcrumbs" aria-label="Breadcrumb">
        <div class="breadcrumbs-container">
            <ol class="breadcrumbs-list">
                <li class="breadcrumbs-item">
                    <a href="../" class="breadcrumbs-link breadcrumbs-home">
                        <i class="fas fa-home"></i>
                        <span>Home</span>
                    </a>
                </li>
                <li class="breadcrumbs-item">
                    <span class="breadcrumbs-category">Location Services</span>
                </li>
                <li class="breadcrumbs-item">
                    <span class="breadcrumbs-current breadcrumbs-current-page">' + $cityName + '</span>
                </li>
            </ol>
        </div>
    </nav>'
        
        # Write the updated content back to the file
        Set-Content $FilePath $content -Encoding UTF8
        Write-Host "Added location page breadcrumbs to $FilePath" -ForegroundColor Green
    }
    catch {
        Write-Host "Error processing $FilePath : $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Function to add breadcrumbs to other pages (like careers.html)
function Add-OtherPageBreadcrumbs {
    param([string]$FilePath)
    
    try {
        $content = Get-Content $FilePath -Raw -Encoding UTF8
        
        # Check if breadcrumbs.css is already added
        if ($content -match "breadcrumbs\.css") {
            Write-Host "Skipping $FilePath - breadcrumbs already added" -ForegroundColor Yellow
            return
        }
        
        # Extract page name from filename (e.g., "careers.html" -> "Careers")
        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($FilePath)
        $pageName = (Get-Culture).TextInfo.ToTitleCase($fileName.ToLower())
        
        # Add breadcrumbs.css link after utility.css
        $content = $content -replace '(<link rel="stylesheet" href="css/utility\.css">)', '$1`n    <link rel="stylesheet" href="css/breadcrumbs.css">'
        
        # Add breadcrumbs HTML structure after sidebar-overlay and before Hero Section
        $content = $content -replace '(<div class="sidebar-overlay"></div>)', '$1

    <!-- =========================
         2. Breadcrumb Navigation
         ========================= -->
    <nav class="breadcrumbs" aria-label="Breadcrumb">
        <div class="breadcrumbs-container">
            <ol class="breadcrumbs-list">
                <li class="breadcrumbs-item">
                    <a href="index.html" class="breadcrumbs-link breadcrumbs-home">
                        <i class="fas fa-home"></i>
                        <span>Home</span>
                    </a>
                </li>
                <li class="breadcrumbs-item">
                    <span class="breadcrumbs-current breadcrumbs-current-page">' + $pageName + '</span>
                </li>
            </ol>
        </div>
    </nav>'
        
        # Write the updated content back to the file
        Set-Content $FilePath $content -Encoding UTF8
        Write-Host "Added other page breadcrumbs to $FilePath" -ForegroundColor Green
    }
    catch {
        Write-Host "Error processing $FilePath : $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Process the home page (index.html)
if (Test-Path "index.html") {
    Write-Host "Processing home page..." -ForegroundColor Cyan
    Add-HomePageBreadcrumbs -FilePath "index.html"
}

# Process all language files
$languageFiles = Get-ChildItem -Path "languages" -Filter "*.html" -Recurse
Write-Host "Found $($languageFiles.Count) language files" -ForegroundColor Cyan

foreach ($file in $languageFiles) {
    Add-LanguagePageBreadcrumbs -FilePath $file.FullName
}

# Process all location files
$locationFiles = Get-ChildItem -Path "locations" -Filter "*.html" -Recurse
Write-Host "Found $($locationFiles.Count) location files" -ForegroundColor Cyan

foreach ($file in $locationFiles) {
    Add-LocationPageBreadcrumbs -FilePath $file.FullName
}

# Process other root-level pages (excluding index.html)
$otherFiles = Get-ChildItem -Path "." -Filter "*.html" | Where-Object { $_.Name -ne "index.html" }
Write-Host "Found $($otherFiles.Count) other root-level files" -ForegroundColor Cyan

foreach ($file in $otherFiles) {
    Add-OtherPageBreadcrumbs -FilePath $file.FullName
}

Write-Host "Improved breadcrumbs addition completed!" -ForegroundColor Green
Write-Host "Total files processed: $($languageFiles.Count + $locationFiles.Count + $otherFiles.Count + 1)" -ForegroundColor Cyan
Write-Host "`nBreadcrumb structure summary:" -ForegroundColor Yellow
Write-Host "- Home page: Home (current)" -ForegroundColor White
Write-Host "- Language pages: Home > Language Services > [Language]" -ForegroundColor White
Write-Host "- Location pages: Home > Location Services > [City]" -ForegroundColor White
Write-Host "- Other pages: Home > [Page Name]" -ForegroundColor White
