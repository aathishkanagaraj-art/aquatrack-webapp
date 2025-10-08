#!/bin/bash

# AquaTrack Quick Development Start
# Simple script to quickly start the development server

echo "🌊 Starting AquaTrack Development Server..."

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ package.json not found. Make sure you're in the project directory."
    exit 1
fi

# Check if node_modules exists, install if not
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

# Generate Prisma client if schema exists
if [ -f "prisma/schema.prisma" ]; then
    echo "🔧 Generating Prisma client..."
    npx prisma generate
fi

# Start development server
echo "🚀 Starting development server on http://localhost:9002"
npm run dev