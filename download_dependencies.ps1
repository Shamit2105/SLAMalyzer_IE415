# Download Dependencies for ORB_SLAM3_AR-for-Android
# Run this script to download required libraries

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Downloading ORB_SLAM3 Dependencies" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Create temp directory
$tempDir = ".\temp_downloads"
New-Item -ItemType Directory -Force -Path $tempDir | Out-Null

# URLs for downloads
$eigenUrl = "https://gitlab.com/libeigen/eigen/-/archive/3.4.0/eigen-3.4.0.tar.gz"
$sophusUrl = "https://github.com/strasdat/Sophus/archive/refs/tags/1.24.6.tar.gz"
$opencvUrl = "https://github.com/opencv/opencv/releases/download/4.12.0/opencv-4.12.0-android-sdk.zip"

Write-Host "`n[1/3] Downloading Eigen 3.4.0..." -ForegroundColor Yellow
$eigenFile = "$tempDir\eigen-3.4.0.tar.gz"
if (-not (Test-Path $eigenFile)) {
    Invoke-WebRequest -Uri $eigenUrl -OutFile $eigenFile -UseBasicParsing
    Write-Host "  ✓ Downloaded Eigen (~7 MB)" -ForegroundColor Green
} else {
    Write-Host "  ⊙ Eigen already downloaded" -ForegroundColor Gray
}

Write-Host "`n[2/3] Downloading Sophus 1.24.6..." -ForegroundColor Yellow
$sophusFile = "$tempDir\Sophus-1.24.6.tar.gz"
if (-not (Test-Path $sophusFile)) {
    Invoke-WebRequest -Uri $sophusUrl -OutFile $sophusFile -UseBasicParsing
    Write-Host "  ✓ Downloaded Sophus (~500 KB)" -ForegroundColor Green
} else {
    Write-Host "  ⊙ Sophus already downloaded" -ForegroundColor Gray
}

Write-Host "`n[3/3] Downloading OpenCV 4.12.0 Android SDK..." -ForegroundColor Yellow
Write-Host "  ⚠ This is ~300MB and may take several minutes..." -ForegroundColor Magenta
$opencvFile = "$tempDir\opencv-4.12.0-android-sdk.zip"
if (-not (Test-Path $opencvFile)) {
    Invoke-WebRequest -Uri $opencvUrl -OutFile $opencvFile -UseBasicParsing
    Write-Host "  ✓ Downloaded OpenCV Android SDK" -ForegroundColor Green
} else {
    Write-Host "  ⊙ OpenCV already downloaded" -ForegroundColor Gray
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "All dependencies downloaded!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "`nNext step: Run install_dependencies.ps1" -ForegroundColor Yellow
