@echo off
REM AquaTrack Quick Start - Skip Prisma for now
REM This version skips Prisma generation to get the server running

REM Change to the script's directory
cd /d "%~dp0"

echo 🌊 Starting AquaTrack Development Server (Skipping Prisma)...

REM Check if we're in the right directory
if not exist "package.json" (
    echo ❌ package.json not found. Make sure you're in the project directory.
    exit /b 1
)

REM Check if node_modules exists, install if not
if not exist "node_modules" (
    echo 📦 Installing dependencies...
    npm install
    if %errorlevel% neq 0 (
        echo ❌ Failed to install dependencies.
        exit /b 1
    )
)

REM Start development server directly (skip Prisma for now)
echo 🚀 Starting development server on http://localhost:9002
echo ✅ 🌊 AquaTrack is starting up...
echo 📝 Note: Prisma client generation is skipped. Run 'npx prisma generate' manually if needed.
npm run dev