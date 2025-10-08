#!/bin/bash

# AquaTrack Project Startup Script
# This script sets up and starts the Next.js application

set -e  # Exit on any error

echo "🚀 Starting AquaTrack Project..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    print_error "Node.js is not installed. Please install Node.js first."
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    print_error "npm is not installed. Please install npm first."
    exit 1
fi

print_status "Node.js version: $(node --version)"
print_status "npm version: $(npm --version)"

# Check if package.json exists
if [ ! -f "package.json" ]; then
    print_error "package.json not found. Make sure you're in the project directory."
    exit 1
fi

# Install dependencies if node_modules doesn't exist
if [ ! -d "node_modules" ]; then
    print_status "Installing dependencies..."
    npm install
    print_success "Dependencies installed successfully!"
else
    print_status "Dependencies already installed. Checking for updates..."
    npm outdated || true
fi

# Check if .env file exists
if [ ! -f ".env" ]; then
    print_warning ".env file not found. You may need to create one with your environment variables."
    if [ -f ".env.example" ]; then
        print_status "Found .env.example. Consider copying it to .env and updating the values."
    fi
fi

# Check for Prisma schema and generate client if needed
if [ -f "prisma/schema.prisma" ]; then
    print_status "Prisma schema found. Generating Prisma client..."
    npx prisma generate
    print_success "Prisma client generated!"
fi

# Build the project
print_status "Building the project..."
npm run build

if [ $? -eq 0 ]; then
    print_success "Build completed successfully!"
else
    print_error "Build failed. Please check the errors above."
    exit 1
fi

# Start the development server
print_status "Starting the development server on port 9002..."
print_success "🌊 AquaTrack is ready! Open http://localhost:9002 in your browser"

# Start the server (this will keep running)
npm run dev