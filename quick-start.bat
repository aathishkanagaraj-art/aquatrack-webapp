@echo off
REM AquaTrack Quick Start - Minimal script for fast development

echo 🌊 AquaTrack Quick Start...

cd /d "%~dp0"

if not exist "package.json" (
    echo ❌ Not in project directory
    pause
    exit /b 1
)

if not exist "node_modules" (
    echo 📦 Installing...
    npm install
)

if exist "prisma\schema.prisma" (
    npx prisma generate >nul 2>&1
)

echo 🚀 Starting on http://localhost:9002
npm run dev