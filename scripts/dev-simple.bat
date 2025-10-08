@echo off
REM AquaTrack Simple Development Start for Windows
REM Basic script to start the development server without Prisma checks

REM Change to the script's directory
cd /d "%~dp0"

echo 🌊 Starting AquaTrack Development Server...

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

REM Start development server directly
echo 🚀 Starting development server on http://localhost:9002
echo ✅ 🌊 AquaTrack is starting up...
npm run dev