@echo off
echo 🌊 AquaTrack - Simple Start
cd /d "%~dp0"
echo 📦 Checking dependencies...
if not exist "node_modules" npm install
echo 🔧 Setting up database...
npx prisma generate
npx prisma db push
echo 🚀 Starting server at http://localhost:9002
npm run dev
pause