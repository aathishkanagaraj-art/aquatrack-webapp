@echo off
REM AquaTrack Production Build and Start - Windows Batch Script

echo.
echo ==========================================
echo  🌊 AquaTrack Production Deployment
echo ==========================================
echo.

REM Change to the script's directory
cd /d "%~dp0"

REM Check if we're in the right directory
if not exist "package.json" (
    echo ❌ Error: package.json not found!
    echo    Make sure you're in the correct project directory.
    echo.
    pause
    exit /b 1
)

echo ✅ Project directory verified
echo.

REM Check Node.js installation
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Error: Node.js is not installed or not in PATH
    echo.
    pause
    exit /b 1
)

echo ✅ Node.js detected: 
node --version

REM Install dependencies if needed
if not exist "node_modules" (
    echo.
    echo 📦 Installing production dependencies...
    npm ci --only=production
    if %errorlevel% neq 0 (
        echo ❌ Failed to install dependencies
        pause
        exit /b 1
    )
) else (
    echo ✅ Dependencies found
)

REM Generate Prisma client
if exist "prisma\schema.prisma" (
    echo.
    echo 🔧 Generating Prisma client...
    npx prisma generate
    if %errorlevel% neq 0 (
        echo ❌ Failed to generate Prisma client
        pause
        exit /b 1
    )
)

REM Build the application
echo.
echo 🏗️  Building application for production...
npm run build
if %errorlevel% neq 0 (
    echo ❌ Build failed
    pause
    exit /b 1
)

echo ✅ Build completed successfully
echo.
echo ==========================================
echo  🚀 Starting Production Server
echo ==========================================
echo.
echo 🌐 Server starting on port 9002
echo 🛑 Press Ctrl+C to stop the server
echo.

REM Start production server
npm start

echo.
echo Production server stopped. 🌊
pause