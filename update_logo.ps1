# =============================================================================
# Ace Language Services - Logo Update Script
# =============================================================================
# 
# This script allows you to quickly update the logo across ALL pages of your website.
# It can handle both text-based logos and image-based logos.
#
# INSTRUCTIONS:
# =============
# 1. Place your new logo image file in the website root directory
# 2. Run this script with appropriate parameters
# 3. The script will update all HTML files automatically
#
# USAGE EXAMPLES:
# ===============
# Text Logo Only:     .\update_logo.ps1 -CompanyName "Your Company Name" -Slogan "Your Slogan"
# Image Logo Only:    .\update_logo.ps1 -LogoImage "your-logo.png" -LogoAlt "Your Company Name"
# Both Text & Image:  .\update_logo.ps1 -CompanyName "Your Company" -Slogan "Your Slogan" -LogoImage "logo.png" -LogoAlt "Your Company"
# 
# =============================================================================

param(
    [string]$CompanyName = "",
    [string]$Slogan = "",
    [string]$LogoImage = "",
    [string]$LogoAlt = ""
)

# Function to display colored output
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

# Function to backup files before modification
function Backup-Files {
    $backupDir = "logo_backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    New-Item -ItemType Directory -Name $backupDir -Force | Out-Null
    
    Write-ColorOutput "Creating backup in: $backupDir" "Yellow"
    
    # Copy all HTML files to backup
    Get-ChildItem -Recurse -Filter "*.html" | ForEach-Object {
        $relativePath = $_.FullName.Substring((Get-Location).Path.Length + 1)
        $backupPath = Join-Path $backupDir $relativePath
        $backupDirPath = Split-Path $backupPath -Parent
        
        if (!(Test-Path $backupDirPath)) {
            New-Item -ItemType Directory -Path $backupDirPath -Force | Out-Null
        }
        
        Copy-Item $_.FullName -Destination $backupPath
    }
    
    Write-ColorOutput "Backup completed successfully!" "Green"
    return $backupDir
}

# Function to update text-based logo
function Update-TextLogo {
    param(
        [string]$CompanyName,
        [string]$Slogan
    )
    
    Write-ColorOutput "Updating text-based logo..." "Cyan"
    
    # Get all HTML files
    $htmlFiles = Get-ChildItem -Recurse -Filter "*.html"
    $updatedCount = 0
    
    foreach ($file in $htmlFiles) {
        $content = Get-Content $file.FullName -Raw
        $originalContent = $content
        $fileUpdated = $false
        
        # Update company name in logo section
        if ($CompanyName -and $content -match '<div class="logo">\s*<h1[^>]*>([^<]+)</h1>') {
            $content = $content -replace '<div class="logo">\s*<h1[^>]*>([^<]+)</h1>', "<div class=`"logo`">`n                    <h1>$CompanyName</h1>"
            $fileUpdated = $true
        }
        
        # Update company name in logo section (alternative pattern)
        if ($CompanyName -and $content -match '<div class="logo">\s*<h1><a[^>]*>([^<]+)</a></h1>') {
            $content = $content -replace '<div class="logo">\s*<h1><a[^>]*>([^<]+)</a></h1>', "<div class=`"logo`">`n                    <h1><a href=`"../index.html`" style=`"color: inherit; text-decoration: none;`">$CompanyName</a></h1>"
            $fileUpdated = $true
        }
        
        # Update slogan
        if ($Slogan -and $content -match '<p class="slogan">([^<]+)</p>') {
            $content = $content -replace '<p class="slogan">([^<]+)</p>', "<p class=`"slogan`">$Slogan</p>"
            $fileUpdated = $true
        }
        
        # Update mobile sidebar header
        if ($CompanyName -and $content -match '<div class="sidebar-header">\s*<h3>([^<]+)</h3>') {
            $content = $content -replace '<div class="sidebar-header">\s*<h3>([^<]+)</h3>', "<div class=`"sidebar-header`">`n            <h3>$CompanyName</h3>"
            $fileUpdated = $true
        }
        
        # Update schema markup logo if present
        if ($CompanyName -and $content -match '"logo":\s*"[^"]*"') {
            $content = $content -replace '"logo":\s*"[^"]*"', "`"logo`": `"https://www.acelang.com/images/logo.png`""
            $fileUpdated = $true
        }
        
        if ($fileUpdated) {
            Set-Content -Path $file.FullName -Value $content -NoNewline
            $updatedCount++
            Write-ColorOutput "Updated: $($file.Name)" "Green"
        }
    }
    
    Write-ColorOutput "Text logo updates completed. Updated $updatedCount files." "Green"
}

# Function to update image-based logo
function Update-ImageLogo {
    param(
        [string]$LogoImage,
        [string]$LogoAlt
    )
    
    Write-ColorOutput "Updating image-based logo..." "Cyan"
    
    # Check if logo image exists
    if (!(Test-Path $LogoImage)) {
        Write-ColorOutput "ERROR: Logo image '$LogoImage' not found!" "Red"
        Write-ColorOutput "Please place your logo image in the website root directory." "Yellow"
        return
    }
    
    # Get all HTML files
    $htmlFiles = Get-ChildItem -Recurse -Filter "*.html"
    $updatedCount = 0
    
    foreach ($file in $htmlFiles) {
        $content = Get-Content $file.FullName -Raw
        $originalContent = $content
        $fileUpdated = $false
        
        # Replace text logo with image logo
        if ($content -match '<div class="logo">\s*<h1[^>]*>([^<]+)</h1>') {
            $newLogoHtml = @"
                <div class="logo">
                    <img src="$LogoImage" alt="$LogoAlt" class="logo-image">
                    <p class="slogan">Bridging Language Barriers Worldwide</p>
                </div>
"@
            $content = $content -replace '<div class="logo">\s*<h1[^>]*>([^<]+)</h1>\s*<p class="slogan">([^<]+)</p>\s*</div>', $newLogoHtml.Trim()
            $fileUpdated = $true
        }
        
        # Update schema markup logo
        if ($content -match '"logo":\s*"[^"]*"') {
            $content = $content -replace '"logo":\s*"[^"]*"', "`"logo`": `"$LogoImage`""
            $fileUpdated = $true
        }
        
        if ($fileUpdated) {
            Set-Content -Path $file.FullName -Value $content -NoNewline
            $updatedCount++
            Write-ColorOutput "Updated: $($file.Name)" "Green"
        }
    }
    
    Write-ColorOutput "Image logo updates completed. Updated $updatedCount files." "Green"
}

# Function to add CSS for logo image
function Add-LogoCSS {
    param(
        [string]$LogoImage
    )
    
    if (!$LogoImage) { return }
    
    Write-ColorOutput "Adding CSS for logo image..." "Cyan"
    
    $cssFile = "css/header.css"
    if (Test-Path $cssFile) {
        $cssContent = Get-Content $cssFile -Raw
        
        # Check if logo image CSS already exists
        if ($cssContent -notmatch '\.logo-image') {
            $logoCSS = @"

/* Logo Image Styles */
.logo-image {
    max-height: 60px;
    max-width: 200px;
    height: auto;
    width: auto;
    display: block;
    margin-bottom: 10px;
}

@media (max-width: 768px) {
    .logo-image {
        max-height: 50px;
        max-width: 150px;
    }
}
"@
            $cssContent += $logoCSS
            Set-Content -Path $cssFile -Value $cssContent -NoNewline
            Write-ColorOutput "Added logo CSS to header.css" "Green"
        }
        else {
            Write-ColorOutput "Logo CSS already exists in header.css" "Yellow"
        }
    }
}

# Main execution
Write-ColorOutput "===============================================" "Magenta"
Write-ColorOutput "Ace Language Services - Logo Update Script" "Magenta"
Write-ColorOutput "===============================================" "Magenta"
Write-Host ""

# Validate parameters
if (!$CompanyName -and !$LogoImage) {
    Write-ColorOutput "ERROR: You must specify either -CompanyName or -LogoImage (or both)" "Red"
    Write-ColorOutput "" "White"
    Write-ColorOutput "Examples:" "Yellow"
    Write-ColorOutput "  .\update_logo.ps1 -CompanyName 'Your Company' -Slogan 'Your Slogan'" "Cyan"
    Write-ColorOutput "  .\update_logo.ps1 -LogoImage 'logo.png' -LogoAlt 'Your Company'" "Cyan"
    Write-ColorOutput "  .\update_logo.ps1 -CompanyName 'Your Company' -Slogan 'Your Slogan' -LogoImage 'logo.png' -LogoAlt 'Your Company'" "Cyan"
    exit 1
}

# Create backup
$backupDir = Backup-Files

try {
    # Update text logo if specified
    if ($CompanyName -or $Slogan) {
        Update-TextLogo -CompanyName $CompanyName -Slogan $Slogan
    }
    
    # Update image logo if specified
    if ($LogoImage) {
        Update-ImageLogo -LogoImage $LogoImage -LogoAlt $LogoAlt
        Add-LogoCSS -LogoImage $LogoImage
    }
    
    Write-Host ""
    Write-ColorOutput "===============================================" "Green"
    Write-ColorOutput "Logo update completed successfully!" "Green"
    Write-ColorOutput "===============================================" "Green"
    Write-ColorOutput "Backup created in: $backupDir" "Yellow"
    Write-ColorOutput "Total files processed: $(Get-ChildItem -Recurse -Filter '*.html' | Measure-Object | Select-Object -ExpandProperty Count)" "Cyan"
    
    if ($LogoImage) {
        Write-ColorOutput "" "White"
        Write-ColorOutput "IMPORTANT: Make sure your logo image '$LogoImage' is accessible from all pages!" "Yellow"
        Write-ColorOutput "Consider placing it in an 'images' folder for better organization." "Yellow"
    }
    
}
catch {
    Write-ColorOutput "ERROR: An error occurred during the update process" "Red"
    Write-ColorOutput "Error details: $($_.Exception.Message)" "Red"
    Write-ColorOutput "You can restore from backup: $backupDir" "Yellow"
}

Write-Host ""
Write-ColorOutput "Script completed. Press any key to exit..." "White"
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
