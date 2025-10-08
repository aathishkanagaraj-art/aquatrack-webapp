#!/bin/bash

# AquaTrack Production Startup Script
# This script builds and starts the application in production mode

set -e  # Exit on any error

echo "🚀 Starting AquaTrack in Production Mode..."

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

print_status "Node.js version: $(node --version)"

# Check if package.json exists
if [ ! -f "package.json" ]; then
    print_error "package.json not found. Make sure you're in the project directory."
    exit 1
fi

# Install production dependencies
print_status "Installing production dependencies..."
npm ci --only=production

# Check for Prisma schema and generate client if needed
if [ -f "prisma/schema.prisma" ]; then
    print_status "Generating Prisma client..."
    npx prisma generate
    print_success "Prisma client generated!"
fi

# Build the project for production
print_status "Building project for production..."
npm run build

if [ $? -eq 0 ]; then
    print_success "Production build completed successfully!"
else
    print_error "Production build failed. Please check the errors above."
    exit 1
fi

# Start the production server
print_status "Starting production server..."
print_success "🌊 AquaTrack production server is running!"

# Start the production server (this will keep running)
npm run start