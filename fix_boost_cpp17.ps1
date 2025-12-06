# Fix Boost C++17 Compatibility Issue
# This script fixes std::unary_function removal in C++17

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Fixing Boost C++17 Compatibility" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$hashFile = ".\app\src\main\cpp\boost\boost-1_72_0\boost\container_hash\hash.hpp"

if (-not (Test-Path $hashFile)) {
    Write-Host "ERROR: Boost hash.hpp not found!" -ForegroundColor Red
    Write-Host "Expected location: $hashFile" -ForegroundColor Yellow
    exit 1
}

Write-Host "`nReading hash.hpp..." -ForegroundColor Yellow
$content = Get-Content $hashFile -Raw

# Check if already patched
if ($content -match "C\+\+17 and later - std::unary_function was removed") {
    Write-Host "✓ Already patched! No changes needed." -ForegroundColor Green
    exit 0
}

Write-Host "Applying C++17 compatibility patch..." -ForegroundColor Yellow

# Original pattern to find
$oldPattern = @"
template <typename T>
    struct hash_base : std::unary_function<T, std::size_t> {};
"@

# New C++17 compatible code
$newPattern = @"
template <typename T>
#if defined(__cplusplus) && __cplusplus >= 201703L
    // C++17 and later - std::unary_function was removed
    struct hash_base {
        typedef T argument_type;
        typedef std::size_t result_type;
    };
#else
    // C++14 and earlier - use std::unary_function
    struct hash_base : std::unary_function<T, std::size_t> {};
#endif
"@

# Apply the fix
$content = $content -replace [regex]::Escape($oldPattern), $newPattern

# Write back to file
Set-Content -Path $hashFile -Value $content -NoNewline

Write-Host "✓ Boost compatibility patch applied successfully!" -ForegroundColor Green
Write-Host "`nThe file has been updated to support C++17" -ForegroundColor Gray
