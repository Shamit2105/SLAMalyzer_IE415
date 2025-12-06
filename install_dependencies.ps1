# Install Dependencies for ORB_SLAM3_AR-for-Android
# Run this AFTER download_dependencies.ps1

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Installing ORB_SLAM3 Dependencies" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$tempDir = ".\temp_downloads"

# Check if downloads exist
if (-not (Test-Path $tempDir)) {
    Write-Host "ERROR: temp_downloads folder not found!" -ForegroundColor Red
    Write-Host "Please run download_dependencies.ps1 first" -ForegroundColor Yellow
    exit 1
}

# Install Eigen
Write-Host "`n[1/3] Installing Eigen 3.4.0..." -ForegroundColor Yellow
$eigenDest = ".\app\src\main\cpp\Eigen\eigen-3.4.0"

if (Test-Path "$tempDir\eigen-3.4.0.tar.gz") {
    Write-Host "  Extracting Eigen..." -ForegroundColor Gray
    tar -xzf "$tempDir\eigen-3.4.0.tar.gz" -C $tempDir
    
    # Copy Eigen and unsupported folders
    $eigenExtracted = Get-ChildItem -Path $tempDir -Filter "eigen-3.4.0" -Directory | Select-Object -First 1
    if ($eigenExtracted) {
        Copy-Item "$($eigenExtracted.FullName)\Eigen" -Destination $eigenDest -Recurse -Force
        Copy-Item "$($eigenExtracted.FullName)\unsupported" -Destination $eigenDest -Recurse -Force
        Write-Host "  ✓ Eigen installed successfully" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Failed to extract Eigen" -ForegroundColor Red
    }
} else {
    Write-Host "  ✗ Eigen archive not found" -ForegroundColor Red
}

# Install Sophus
Write-Host "`n[2/3] Installing Sophus 1.24.6..." -ForegroundColor Yellow
$sophusDest = ".\app\src\main\cpp\ORB\Thirdparty\Sophus"

if (Test-Path "$tempDir\Sophus-1.24.6.tar.gz") {
    Write-Host "  Extracting Sophus..." -ForegroundColor Gray
    tar -xzf "$tempDir\Sophus-1.24.6.tar.gz" -C $tempDir
    
    # Copy sophus folder
    $sophusExtracted = Get-ChildItem -Path $tempDir -Filter "Sophus-1.24.6" -Directory | Select-Object -First 1
    if ($sophusExtracted) {
        New-Item -ItemType Directory -Force -Path $sophusDest | Out-Null
        Copy-Item "$($sophusExtracted.FullName)\sophus" -Destination $sophusDest -Recurse -Force
        Write-Host "  ✓ Sophus installed successfully" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Failed to extract Sophus" -ForegroundColor Red
    }
} else {
    Write-Host "  ✗ Sophus archive not found" -ForegroundColor Red
}

# Install OpenCV
Write-Host "`n[3/3] Installing OpenCV 4.12.0 Android SDK..." -ForegroundColor Yellow

if (Test-Path "$tempDir\opencv-4.12.0-android-sdk.zip") {
    Write-Host "  Extracting OpenCV SDK (this may take a minute)..." -ForegroundColor Gray
    Expand-Archive -Path "$tempDir\opencv-4.12.0-android-sdk.zip" -DestinationPath $tempDir -Force
    
    $opencvSdk = "$tempDir\OpenCV-android-sdk\sdk"
    
    if (Test-Path $opencvSdk) {
        # Copy SDK contents to opencvLibrary
        Write-Host "  Copying OpenCV SDK to opencvLibrary..." -ForegroundColor Gray
        Copy-Item "$opencvSdk\*" -Destination ".\opencvLibrary" -Recurse -Force
        
        # Copy include files
        Write-Host "  Copying OpenCV include files..." -ForegroundColor Gray
        $includeDest = ".\app\src\main\cpp\opencv\opencv-4.12.0\include"
        New-Item -ItemType Directory -Force -Path $includeDest | Out-Null
        
        $includeSource = "$opencvSdk\native\jni\include"
        if (Test-Path $includeSource) {
            # Copy all except videoio, photo, gapi
            Get-ChildItem $includeSource -Directory | Where-Object { 
                $_.Name -notin @('videoio', 'photo', 'gapi') 
            } | ForEach-Object {
                Copy-Item $_.FullName -Destination $includeDest -Recurse -Force
            }
            # Also copy files in root include
            Get-ChildItem $includeSource -File | ForEach-Object {
                Copy-Item $_.FullName -Destination $includeDest -Force
            }
        }
        
        # Copy native libraries
        Write-Host "  Copying OpenCV native libraries..." -ForegroundColor Gray
        $libsSource = "$opencvSdk\native\libs"
        $libsDest = ".\app\src\main\jniLibs"
        
        if (Test-Path $libsSource) {
            foreach ($arch in @('arm64-v8a', 'armeabi-v7a', 'x86', 'x86_64')) {
                if (Test-Path "$libsSource\$arch") {
                    New-Item -ItemType Directory -Force -Path "$libsDest\$arch" | Out-Null
                    Copy-Item "$libsSource\$arch\libopencv_java4.so" -Destination "$libsDest\$arch\" -Force -ErrorAction SilentlyContinue
                }
            }
        }
        
        Write-Host "  ✓ OpenCV installed successfully" -ForegroundColor Green
    } else {
        Write-Host "  ✗ OpenCV SDK extraction failed" -ForegroundColor Red
    }
} else {
    Write-Host "  ✗ OpenCV archive not found" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "  1. Open project in Android Studio" -ForegroundColor White
Write-Host "  2. Let Gradle sync" -ForegroundColor White
Write-Host "  3. Build and run on device" -ForegroundColor White
Write-Host "`nOptional: Delete temp_downloads folder to save space" -ForegroundColor Gray
