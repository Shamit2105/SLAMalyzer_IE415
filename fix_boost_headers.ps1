# Quick Fix: Download Complete Boost 1.72.0 Headers (ZIP version)
# This fixes the missing serialization headers issue

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Installing Complete Boost 1.72.0 Headers" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$tempDir = ".\temp_downloads"
New-Item -ItemType Directory -Force -Path $tempDir | Out-Null

# Use Sourceforge mirror with ZIP file (easier to extract on Windows)
$boostUrl = "https://sourceforge.net/projects/boost/files/boost/1.72.0/boost_1_72_0.zip/download"
$boostFile = "$tempDir\boost_1_72_0.zip"
$boostDest = ".\app\src\main\cpp\boost\boost-1_72_0"

Write-Host "`nDownloading Boost 1.72.0 headers (ZIP)..." -ForegroundColor Yellow
Write-Host "  Size: ~120 MB (this may take a few minutes)" -ForegroundColor Magenta

if (-not (Test-Path $boostFile)) {
    try {
        Write-Host "  Starting download..." -ForegroundColor Gray
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $boostUrl -OutFile $boostFile -UseBasicParsing -TimeoutSec 600
        $ProgressPreference = 'Continue'
        Write-Host "  ✓ Downloaded successfully ($([math]::Round((Get-Item $boostFile).Length / 1MB, 2)) MB)" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ Download failed: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "`nPlease download manually:" -ForegroundColor Yellow
        Write-Host "  1. Open: https://www.boost.org/users/history/version_1_72_0.html" -ForegroundColor White
        Write-Host "  2. Download: boost_1_72_0.zip" -ForegroundColor White
        Write-Host "  3. Save to: $boostFile" -ForegroundColor White
        Write-Host "  4. Run this script again" -ForegroundColor White
        exit 1
    }
} else {
    Write-Host "  ⊙ Boost archive already downloaded" -ForegroundColor Gray
}

Write-Host "`nExtracting Boost headers..." -ForegroundColor Yellow
Write-Host "  This may take 2-3 minutes..." -ForegroundColor Gray

# Extract the ZIP archive
try {
    Expand-Archive -Path $boostFile -DestinationPath $tempDir -Force
    Write-Host "  ✓ Extraction complete" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Extraction failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Find the extracted boost directory
$extractedBoost = Get-ChildItem -Path $tempDir -Filter "boost_1_72_0" -Directory | Select-Object -First 1

if (-not $extractedBoost) {
    Write-Host "  ✗ Extracted directory not found" -ForegroundColor Red
    Write-Host "  Looking for: boost_1_72_0 in $tempDir" -ForegroundColor Gray
    exit 1
}

Write-Host "`nInstalling Boost headers..." -ForegroundColor Yellow

# Remove old incomplete boost folder if it exists
$oldBoostHeaders = "$boostDest\boost"
if (Test-Path $oldBoostHeaders) {
    Write-Host "  Removing incomplete Boost headers..." -ForegroundColor Gray
    Remove-Item -Recurse -Force $oldBoostHeaders
}

# Copy the complete boost headers
$sourceBoostHeaders = "$($extractedBoost.FullName)\boost"
if (Test-Path $sourceBoostHeaders) {
    Write-Host "  Copying complete Boost headers (this may take a minute)..." -ForegroundColor Gray
    Copy-Item $sourceBoostHeaders -Destination $boostDest -Recurse -Force
    Write-Host "  ✓ Boost headers installed successfully" -ForegroundColor Green
    
    # Count files to verify
    $fileCount = (Get-ChildItem -Path "$boostDest\boost" -Recurse -File).Count
    Write-Host "  📊 Installed $fileCount header files" -ForegroundColor Cyan
} else {
    Write-Host "  ✗ Boost headers not found in extracted archive" -ForegroundColor Red
    exit 1
}

# Verify serialization headers are present
$serializationPath = "$boostDest\boost\serialization\serialization.hpp"
if (Test-Path $serializationPath) {
    Write-Host "`n✓ Verification passed: serialization headers found!" -ForegroundColor Green
    Write-Host "  Location: $serializationPath" -ForegroundColor Gray
} else {
    Write-Host "`n⚠ Warning: serialization headers still not found" -ForegroundColor Yellow
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Boost Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "  1. Run: .\fix_boost_cpp17.ps1" -ForegroundColor White
Write-Host "  2. Build the project in Android Studio" -ForegroundColor White

Write-Host "`nOptional cleanup (saves ~500MB):" -ForegroundColor Gray
Write-Host "  Remove-Item -Recurse -Force temp_downloads" -ForegroundColor Gray
