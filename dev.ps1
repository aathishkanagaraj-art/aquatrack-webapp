# AquaTrack Development Server - PowerShell Script# AquaTrack Development Start Script for PowerShell

# Optimized for quick development setup and execution# This script sets up and starts the Next.js development server



param(Write-Host "🌊 Starting AquaTrack Development Server..." -ForegroundColor Cyan

    [switch]$Clean,

    [switch]$Install,# Change to script directory

    [switch]$Help$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path

)Set-Location $scriptPath



# Function to display help# Check if package.json exists

function Show-Help {if (!(Test-Path "package.json")) {

    Write-Host "AquaTrack Development Script" -ForegroundColor Cyan    Write-Host "❌ package.json not found. Make sure you're in the project directory." -ForegroundColor Red

    Write-Host "============================" -ForegroundColor Cyan    exit 1

    Write-Host ""}

    Write-Host "Usage: .\dev.ps1 [options]" -ForegroundColor White

    Write-Host ""# Check if node_modules exists, install if not

    Write-Host "Options:" -ForegroundColor Yellowif (!(Test-Path "node_modules")) {

    Write-Host "  -Clean    Clean install (removes node_modules and reinstalls)" -ForegroundColor White    Write-Host "📦 Installing dependencies..." -ForegroundColor Yellow

    Write-Host "  -Install  Force reinstall dependencies" -ForegroundColor White    npm install

    Write-Host "  -Help     Show this help message" -ForegroundColor White    if ($LASTEXITCODE -ne 0) {

    Write-Host ""        Write-Host "❌ Failed to install dependencies." -ForegroundColor Red

    Write-Host "Examples:" -ForegroundColor Yellow        exit 1

    Write-Host "  .\dev.ps1           # Start development server" -ForegroundColor White    }

    Write-Host "  .\dev.ps1 -Clean    # Clean install and start" -ForegroundColor White}

    Write-Host "  .\dev.ps1 -Install  # Reinstall dependencies and start" -ForegroundColor White

    exit 0# Generate Prisma client if schema exists

}if (Test-Path "prisma\schema.prisma") {

    Write-Host "🔧 Generating Prisma client..." -ForegroundColor Yellow

if ($Help) {    npx prisma generate

    Show-Help    if ($LASTEXITCODE -ne 0) {

}        Write-Host "❌ Failed to generate Prisma client." -ForegroundColor Red

        exit 1

# Display banner    }

Write-Host ""    Write-Host "✅ Prisma client generated successfully!" -ForegroundColor Green

Write-Host "==========================================" -ForegroundColor Cyan}

Write-Host " 🌊 AquaTrack Development Environment" -ForegroundColor Cyan

Write-Host "==========================================" -ForegroundColor Cyan# Start development server

Write-Host ""Write-Host "🚀 Starting development server on http://localhost:9002" -ForegroundColor Green

Write-Host "✅ 🌊 AquaTrack is starting up..." -ForegroundColor Green

# Change to script directorynpm run dev
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

# Check if package.json exists
if (!(Test-Path "package.json")) {
    Write-Host "❌ Error: package.json not found!" -ForegroundColor Red
    Write-Host "   Make sure you're in the correct project directory." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "✅ Project directory verified" -ForegroundColor Green
Write-Host ""

# Check Node.js installation
try {
    $nodeVersion = node --version 2>$null
    Write-Host "✅ Node.js detected: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Error: Node.js is not installed or not in PATH" -ForegroundColor Red
    Write-Host "   Please install Node.js from https://nodejs.org/" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

# Clean install if requested
if ($Clean -and (Test-Path "node_modules")) {
    Write-Host ""
    Write-Host "🗑️  Performing clean install..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force "node_modules" -ErrorAction SilentlyContinue
    Remove-Item -Force "package-lock.json" -ErrorAction SilentlyContinue
    Write-Host "   Cleaned previous installation" -ForegroundColor Green
}

# Install dependencies
if ($Install -or $Clean -or !(Test-Path "node_modules")) {
    Write-Host ""
    Write-Host "📦 Installing project dependencies..." -ForegroundColor Yellow
    Write-Host "   This may take a few minutes..." -ForegroundColor Gray
    
    npm install
    if ($LASTEXITCODE -ne 0) {
        Write-Host ""
        Write-Host "❌ Failed to install dependencies" -ForegroundColor Red
        Write-Host "   Please check your internet connection and try again" -ForegroundColor Yellow
        Write-Host ""
        Read-Host "Press Enter to exit"
        exit 1
    }
    Write-Host "✅ Dependencies installed successfully" -ForegroundColor Green
} else {
    Write-Host "✅ Dependencies already installed" -ForegroundColor Green
}

# Generate Prisma client if schema exists
if (Test-Path "prisma\schema.prisma") {
    Write-Host ""
    Write-Host "🔧 Generating Prisma client..." -ForegroundColor Yellow
    npx prisma generate
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to generate Prisma client" -ForegroundColor Red
        Write-Host ""
        Read-Host "Press Enter to exit"
        exit 1
    }
    Write-Host "✅ Prisma client generated successfully" -ForegroundColor Green
}

# Check environment file
if (!(Test-Path ".env")) {
    Write-Host ""
    Write-Host "⚠️  Warning: .env file not found" -ForegroundColor Yellow
    Write-Host "   The application may not work correctly without environment variables" -ForegroundColor Gray
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " 🚀 Starting Development Server" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "🌐 Server will be available at: http://localhost:9002" -ForegroundColor Green
Write-Host "🔄 Hot reload enabled - changes will auto-refresh" -ForegroundColor Green
Write-Host "🛑 Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host ""

# Start development server
npm run dev

Write-Host ""
Write-Host "Server stopped. Thank you for using AquaTrack! 🌊" -ForegroundColor Cyan