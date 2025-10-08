# AquaTrack Development Start Script for PowerShell
# This script sets up and starts the Next.js development server

Write-Host "🌊 Starting AquaTrack Development Server..." -ForegroundColor Cyan

# Change to script directory
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

# Check if package.json exists
if (!(Test-Path "package.json")) {
    Write-Host "❌ package.json not found. Make sure you're in the project directory." -ForegroundColor Red
    exit 1
}

# Check if node_modules exists, install if not
if (!(Test-Path "node_modules")) {
    Write-Host "📦 Installing dependencies..." -ForegroundColor Yellow
    npm install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to install dependencies." -ForegroundColor Red
        exit 1
    }
}

# Generate Prisma client if schema exists
if (Test-Path "prisma\schema.prisma") {
    Write-Host "🔧 Generating Prisma client..." -ForegroundColor Yellow
    npx prisma generate
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to generate Prisma client." -ForegroundColor Red
        exit 1
    }
    Write-Host "✅ Prisma client generated successfully!" -ForegroundColor Green
}

# Start development server
Write-Host "🚀 Starting development server on http://localhost:9002" -ForegroundColor Green
Write-Host "✅ 🌊 AquaTrack is starting up..." -ForegroundColor Green
npm run dev