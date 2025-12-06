# Download and Install Complete Boost 1.72.0 Headers
# This fixes the missing serialization headers issue

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Installing Complete Boost 1.72.0 Headers" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$tempDir = ".\temp_downloads"
New-Item -ItemType Directory -Force -Path $tempDir | Out-Null

$boostUrl = "https://boostorg.jfrog.io/artifactory/main/release/1.72.0/source/boost_1_72_0.tar.gz"
$boostFile = "$tempDir\boost_1_72_0.tar.gz"
$boostDest = ".\app\src\main\cpp\boost\boost-1_72_0"

Write-Host "`nDownloading Boost 1.72.0 headers..." -ForegroundColor Yellow
Write-Host "  Source: $boostUrl" -ForegroundColor Gray
Write-Host "  Size: ~120 MB (this may take a few minutes)" -ForegroundColor Magenta

if (-not (Test-Path $boostFile)) {
    try {
        Invoke-WebRequest -Uri $boostUrl -OutFile $boostFile -UseBasicParsing
        Write-Host "  ✓ Downloaded successfully" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ Download failed: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "`nAlternative: Manual download" -ForegroundColor Yellow
        Write-Host "  1. Go to: https://www.boost.org/users/history/version_1_72_0.html" -ForegroundColor White
        Write-Host "  2. Download boost_1_72_0.tar.gz" -ForegroundColor White
        Write-Host "  3. Place it in: $tempDir\" -ForegroundColor White
        Write-Host "  4. Run this script again" -ForegroundColor White
        exit 1
    }
} else {
    Write-Host "  ⊙ Boost archive already downloaded" -ForegroundColor Gray
}

Write-Host "`nExtracting Boost headers..." -ForegroundColor Yellow
Write-Host "  This may take 2-3 minutes..." -ForegroundColor Gray

# First, decompress .gz to .tar using 7-Zip or try tar
try {
    # Try with tar first
    $tarOutput = & tar -tzf $boostFile 2>&1
    if ($LASTEXITCODE -eq 0) {
        tar -xzf $boostFile -C $tempDir
        Write-Host "  ✓ Extraction complete (tar)" -ForegroundColor Green
    } else {
        # Alternative: Use .NET for extraction
        Write-Host "  Using PowerShell extraction method..." -ForegroundColor Gray
        
        # Install 7-Zip module if needed
        if (-not (Get-Command Expand-7Zip -ErrorAction SilentlyContinue)) {
            Write-Host "  Installing extraction tools..." -ForegroundColor Gray
            Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope CurrentUser | Out-Null
            Install-Module -Name 7Zip4PowerShell -Force -Scope CurrentUser -AllowClobber | Out-Null
        }
        
        Import-Module 7Zip4PowerShell -ErrorAction SilentlyContinue
        if (Get-Command Expand-7Zip -ErrorAction SilentlyContinue) {
            Expand-7Zip -ArchiveFileName $boostFile -TargetPath $tempDir
            Write-Host "  ✓ Extraction complete (7-Zip)" -ForegroundColor Green
        } else {
            Write-Host "  ✗ Automatic extraction not available" -ForegroundColor Red
            Write-Host "`nManual extraction required:" -ForegroundColor Yellow
            Write-Host "  1. Download 7-Zip: https://www.7-zip.org/" -ForegroundColor White
            Write-Host "  2. Extract: $boostFile" -ForegroundColor White
            Write-Host "  3. To folder: $tempDir" -ForegroundColor White
            Write-Host "  4. Run this script again" -ForegroundColor White
            exit 1
        }
    }
} catch {
    Write-Host "  ✗ Extraction failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Find the extracted boost directory
$extractedBoost = Get-ChildItem -Path $tempDir -Filter "boost_1_72_0" -Directory | Select-Object -First 1

if (-not $extractedBoost) {
    Write-Host "  ✗ Extracted directory not found" -ForegroundColor Red
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
} else {
    Write-Host "  ✗ Boost headers not found in extracted archive" -ForegroundColor Red
    exit 1
}

# Verify serialization headers are present
$serializationPath = "$boostDest\boost\serialization\serialization.hpp"
if (Test-Path $serializationPath) {
    Write-Host "`n✓ Verification passed: serialization headers found!" -ForegroundColor Green
} else {
    Write-Host "`n⚠ Warning: serialization headers still not found" -ForegroundColor Yellow
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Boost Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "  1. Run: .\fix_boost_cpp17.ps1" -ForegroundColor White
Write-Host "  2. Try building the project again" -ForegroundColor White

Write-Host "`nOptional cleanup:" -ForegroundColor Gray
Write-Host "  Remove-Item -Recurse -Force temp_downloads" -ForegroundColor Gray
