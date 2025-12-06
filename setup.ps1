# Complete Setup Script for ORB_SLAM3_AR-for-Android
# This script automates the entire setup process

$ErrorActionPreference = "Stop"

Write-Host @"
========================================
ORB_SLAM3_AR Android - Complete Setup
========================================
"@ -ForegroundColor Cyan

Write-Host "`nThis script will:" -ForegroundColor Yellow
Write-Host "  ✓ Download required dependencies (~300MB total)" -ForegroundColor White
Write-Host "  ✓ Install Eigen 3.4.0" -ForegroundColor White
Write-Host "  ✓ Install Sophus 1.24.6" -ForegroundColor White
Write-Host "  ✓ Install OpenCV 4.12.0 Android SDK" -ForegroundColor White
Write-Host "  ✓ Fix Boost C++17 compatibility" -ForegroundColor White
Write-Host ""

$confirmation = Read-Host "Continue? (Y/N)"
if ($confirmation -ne 'Y' -and $confirmation -ne 'y') {
    Write-Host "Setup cancelled." -ForegroundColor Yellow
    exit 0
}

# Step 1: Download
Write-Host "`n[STEP 1/3] DOWNLOADING DEPENDENCIES" -ForegroundColor Magenta
Write-Host "======================================" -ForegroundColor Magenta
& .\download_dependencies.ps1
if ($LASTEXITCODE -ne 0) {
    Write-Host "`nERROR: Download failed!" -ForegroundColor Red
    exit 1
}

# Step 2: Install
Write-Host "`n[STEP 2/3] INSTALLING DEPENDENCIES" -ForegroundColor Magenta
Write-Host "======================================" -ForegroundColor Magenta
& .\install_dependencies.ps1
if ($LASTEXITCODE -ne 0) {
    Write-Host "`nERROR: Installation failed!" -ForegroundColor Red
    exit 1
}

# Step 3: Fix Boost
Write-Host "`n[STEP 3/3] FIXING BOOST COMPATIBILITY" -ForegroundColor Magenta
Write-Host "======================================" -ForegroundColor Magenta
& .\fix_boost_cpp17.ps1
if ($LASTEXITCODE -ne 0) {
    Write-Host "`nERROR: Boost fix failed!" -ForegroundColor Red
    exit 1
}

Write-Host @"

========================================
✓ SETUP COMPLETE!
========================================
"@ -ForegroundColor Green

Write-Host @"

Next Steps:
  1. Open Android Studio
  2. Open this project folder
  3. Wait for Gradle sync to complete
  4. Connect your Android device (USB debugging enabled)
  5. Click 'Run' button (or Shift+F10)

Requirements:
  • Android device with API 29+ (Android 10+)
  • USB debugging enabled
  • Camera permission

Notes:
  • First build may take 10-15 minutes
  • Point camera at textured scene to initialize SLAM
  • Red text = SLAM not initialized
  • Green text = SLAM working

"@ -ForegroundColor White

Write-Host "Happy coding! 🚀" -ForegroundColor Cyan
