@echo off
REM AquaTrack Development Server - Windows Batch Script
REM Optimized for quick development setup and execution

echo.
echo ==========================================
echo  🌊 AquaTrack Development Environment
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
    echo    Please install Node.js from https://nodejs.org/
    echo.
    pause
    exit /b 1
)

echo ✅ Node.js detected: 
node --version

REM Check if node_modules exists, install if not
if not exist "node_modules" (
    echo.
    echo 📦 Installing project dependencies...
    echo    This may take a few minutes...
    npm install
    if %errorlevel% neq 0 (
        echo.
        echo ❌ Failed to install dependencies
        echo    Please check your internet connection and try again
        echo.
        pause
        exit /b 1
    )
    echo ✅ Dependencies installed successfully
) else (
    echo ✅ Dependencies already installed
)

REM Generate Prisma client if schema exists
if exist "prisma\schema.prisma" (
    echo.
    echo 🔧 Generating Prisma client...
    npx prisma generate
    if %errorlevel% neq 0 (
        echo ❌ Failed to generate Prisma client
        echo.
        pause
        exit /b 1
    )
    echo ✅ Prisma client generated successfully
    echo.
)

REM Check if .env file exists
if not exist ".env" (
    echo.
    echo ⚠️  Warning: .env file not found
    echo    The application may not work correctly without environment variables
    echo.
)

echo.
echo ==========================================
echo  🚀 Starting Development Server
echo ==========================================
echo.
echo 🌐 Server will be available at: http://localhost:9002
echo 🔄 Hot reload enabled - changes will auto-refresh
echo 🛑 Press Ctrl+C to stop the server
echo.

REM Start development server
npm run dev

echo.
echo Server stopped. Thank you for using AquaTrack! 🌊
pause