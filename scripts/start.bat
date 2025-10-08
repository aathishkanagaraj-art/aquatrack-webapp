@echo off
REM AquaTrack Project Startup Script for Windows
REM This script sets up and starts the Next.js application

REM Change to the script's directory
cd /d "%~dp0"

echo 🚀 Starting AquaTrack Project...

REM Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js is not installed. Please install Node.js first.
    exit /b 1
)

REM Check if npm is installed
npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ npm is not installed. Please install npm first.
    exit /b 1
)

echo ℹ️ Node.js version:
node --version
echo ℹ️ npm version:
npm --version

REM Check if package.json exists
if not exist "package.json" (
    echo ❌ package.json not found. Make sure you're in the project directory.
    exit /b 1
)

REM Install dependencies if node_modules doesn't exist
if not exist "node_modules" (
    echo 📦 Installing dependencies...
    npm install
    if %errorlevel% neq 0 (
        echo ❌ Failed to install dependencies.
        exit /b 1
    )
    echo ✅ Dependencies installed successfully!
) else (
    echo ℹ️ Dependencies already installed. Checking for updates...
    npm outdated
)

REM Check if .env file exists
if not exist ".env" (
    echo ⚠️ .env file not found. You may need to create one with your environment variables.
    if exist ".env.example" (
        echo ℹ️ Found .env.example. Consider copying it to .env and updating the values.
    )
)

REM Check for Prisma schema and generate client if needed
if exist "prisma\schema.prisma" (
    echo 🔧 Prisma schema found. Generating Prisma client...
    npx prisma generate
    if %errorlevel% neq 0 (
        echo ❌ Failed to generate Prisma client.
        exit /b 1
    )
    echo ✅ Prisma client generated!
)

REM Build the project
echo 🔨 Building the project...
npm run build
if %errorlevel% neq 0 (
    echo ❌ Build failed. Please check the errors above.
    exit /b 1
)
echo ✅ Build completed successfully!

REM Start the development server
echo 🚀 Starting the development server on port 9002...
echo ✅ 🌊 AquaTrack is ready! Open http://localhost:9002 in your browser

REM Start the server (this will keep running)
npm run dev