# Install Boost from Manually Downloaded ZIP
# Run this AFTER you have placed boost_1_72_0.zip in temp_downloads

$ErrorActionPreference = "Stop"
$zipFile = ".\temp_downloads\boost_1_72_0.zip"
$destDir = ".\app\src\main\cpp\boost\boost-1_72_0"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Installing Boost from Manual Download" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Check if file exists
if (-not (Test-Path $zipFile)) {
    Write-Host "ERROR: File not found!" -ForegroundColor Red
    Write-Host "Please download boost_1_72_0.zip manually and place it in:" -ForegroundColor Yellow
    Write-Host "  $(Convert-Path .\temp_downloads)" -ForegroundColor White
    exit 1
}

# Check file size (should be > 100MB)
$size = (Get-Item $zipFile).Length / 1MB
if ($size -lt 50) {
    Write-Host "ERROR: File is too small ($([math]::Round($size, 2)) MB)" -ForegroundColor Red
    Write-Host "It seems the download was incomplete or blocked." -ForegroundColor Yellow
    Write-Host "Please download again from SourceForge." -ForegroundColor White
    exit 1
}

Write-Host "✓ Found valid archive ($([math]::Round($size, 2)) MB)" -ForegroundColor Green

# Extract
Write-Host "`nExtracting archive (this takes 1-2 minutes)..." -ForegroundColor Yellow
$tempExtract = ".\temp_downloads\extract_temp"
Remove-Item -Recurse -Force $tempExtract -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $tempExtract | Out-Null

try {
    Expand-Archive -Path $zipFile -DestinationPath $tempExtract -Force
    Write-Host "✓ Extraction complete" -ForegroundColor Green
} catch {
    Write-Host "✗ Extraction failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Install
Write-Host "`nInstalling headers..." -ForegroundColor Yellow
$source = "$tempExtract\boost_1_72_0\boost"

if (-not (Test-Path $source)) {
    Write-Host "✗ Could not find 'boost' folder in extracted archive" -ForegroundColor Red
    exit 1
}

# Clean old headers
if (Test-Path "$destDir\boost") {
    Remove-Item -Recurse -Force "$destDir\boost"
}

# Copy new headers
Copy-Item $source -Destination $destDir -Recurse -Force

# Verify
if (Test-Path "$destDir\boost\serialization\serialization.hpp") {
    Write-Host "`n✓ SUCCESS: Boost installed correctly!" -ForegroundColor Green
    Write-Host "  Serialization headers found." -ForegroundColor Gray
    
    # Run C++17 fix
    Write-Host "`nApplying C++17 compatibility fix..." -ForegroundColor Yellow
    & .\fix_boost_cpp17.ps1
} else {
    Write-Host "`n✗ FAILURE: Serialization headers still missing" -ForegroundColor Red
}

# Cleanup
Remove-Item -Recurse -Force $tempExtract
