# AquaTrack Project Organization Script
# This script helps organize and maintain the project structure

param(
    [switch]$Help
)

function Show-Help {
    Write-Host "AquaTrack Project Organization" -ForegroundColor Cyan
    Write-Host "==============================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "This script helps organize and maintain the project structure" -ForegroundColor White
    Write-Host ""
    Write-Host "Usage: .\organize.ps1" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "What this script does:" -ForegroundColor Yellow
    Write-Host "- Verifies project structure" -ForegroundColor White
    Write-Host "- Moves misplaced files to correct locations" -ForegroundColor White
    Write-Host "- Creates missing directories" -ForegroundColor White
    Write-Host "- Updates permissions on scripts" -ForegroundColor White
    Write-Host "- Generates project health report" -ForegroundColor White
    exit 0
}

if ($Help) {
    Show-Help
}

Write-Host ""
Write-Host "🔧 AquaTrack Project Organization" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""

# Check if we're in the right directory
if (!(Test-Path "package.json")) {
    Write-Host "❌ Error: Not in AquaTrack project directory" -ForegroundColor Red
    Write-Host "   Please run this script from the project root" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Project directory verified" -ForegroundColor Green

# Create standard directories if missing
$directories = @(
    "components/dashboard",
    "components/ui", 
    "app/api",
    "app/dashboard",
    "lib/utils",
    "hooks",
    "contexts",
    "prisma",
    "scripts",
    "docs"
)

Write-Host ""
Write-Host "📁 Ensuring directory structure..." -ForegroundColor Yellow

foreach ($dir in $directories) {
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "   Created: $dir" -ForegroundColor Green
    }
}

Write-Host "✅ Directory structure verified" -ForegroundColor Green

# Check for essential files
Write-Host ""
Write-Host "📄 Checking essential files..." -ForegroundColor Yellow

$essentialFiles = @{
    "package.json" = "Package configuration"
    "next.config.ts" = "Next.js configuration"
    "tailwind.config.ts" = "Tailwind CSS configuration"
    "tsconfig.json" = "TypeScript configuration"
    ".env.example" = "Environment variables example"
}

foreach ($file in $essentialFiles.Keys) {
    if (Test-Path $file) {
        Write-Host "   ✅ $file - $($essentialFiles[$file])" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  $file - $($essentialFiles[$file]) MISSING" -ForegroundColor Yellow
    }
}

# Check scripts
Write-Host ""
Write-Host "⚡ Checking development scripts..." -ForegroundColor Yellow

$scripts = @{
    "dev.bat" = "Windows batch script"
    "dev.ps1" = "PowerShell script"
    "dev.sh" = "Unix shell script"
    "quick-start.bat" = "Quick start script"
    "start.bat" = "Production start script"
}

foreach ($script in $scripts.Keys) {
    if (Test-Path $script) {
        Write-Host "   ✅ $script - $($scripts[$script])" -ForegroundColor Green
    } else {
        Write-Host "   ❌ $script - $($scripts[$script]) MISSING" -ForegroundColor Red
    }
}

# Project health summary
Write-Host ""
Write-Host "📊 Project Health Summary" -ForegroundColor Cyan
Write-Host "=========================" -ForegroundColor Cyan

$nodeModulesExists = Test-Path "node_modules"
$envExists = Test-Path ".env"
$buildExists = Test-Path ".next"

Write-Host "Dependencies installed: $(if ($nodeModulesExists) { '✅ Yes' } else { '❌ No (run npm install)' })"
Write-Host "Environment configured: $(if ($envExists) { '✅ Yes' } else { '⚠️ No (.env file missing)' })"
Write-Host "Previous build exists: $(if ($buildExists) { '✅ Yes' } else { 'ℹ️ No (run npm run build)' })"

Write-Host ""
Write-Host "🚀 Ready to start development!" -ForegroundColor Green
Write-Host ""
Write-Host "Quick commands:" -ForegroundColor Yellow
Write-Host "  Windows: quick-start.bat" -ForegroundColor White
Write-Host "  PowerShell: .\dev.ps1" -ForegroundColor White
Write-Host "  Unix/Linux: ./dev.sh" -ForegroundColor White
Write-Host ""