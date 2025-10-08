#!/bin/bash#!/bin/bash



# AquaTrack Development Server - Bash Script# AquaTrack Quick Development Start

# Optimized for quick development setup and execution# Simple script to quickly start the development server



set -e  # Exit on any errorecho "🌊 Starting AquaTrack Development Server..."



# Colors for output# Check if we're in the right directory

RED='\033[0;31m'if [ ! -f "package.json" ]; then

GREEN='\033[0;32m'    echo "❌ package.json not found. Make sure you're in the project directory."

YELLOW='\033[1;33m'    exit 1

CYAN='\033[0;36m'fi

NC='\033[0m' # No Color

# Check if node_modules exists, install if not

# Function to display helpif [ ! -d "node_modules" ]; then

show_help() {    echo "📦 Installing dependencies..."

    echo -e "${CYAN}AquaTrack Development Script${NC}"    npm install

    echo -e "${CYAN}=============================${NC}"fi

    echo ""

    echo -e "${NC}Usage: ./dev.sh [options]${NC}"# Generate Prisma client if schema exists

    echo ""if [ -f "prisma/schema.prisma" ]; then

    echo -e "${YELLOW}Options:${NC}"    echo "🔧 Generating Prisma client..."

    echo -e "  --clean    Clean install (removes node_modules and reinstalls)"    npx prisma generate

    echo -e "  --install  Force reinstall dependencies"fi

    echo -e "  --help     Show this help message"

    echo ""# Start development server

    echo -e "${YELLOW}Examples:${NC}"echo "🚀 Starting development server on http://localhost:9002"

    echo -e "  ./dev.sh           # Start development server"npm run dev
    echo -e "  ./dev.sh --clean   # Clean install and start"
    echo -e "  ./dev.sh --install # Reinstall dependencies and start"
    exit 0
}

# Parse command line arguments
CLEAN=false
INSTALL=false

for arg in "$@"; do
    case $arg in
        --clean)
            CLEAN=true
            shift
            ;;
        --install)
            INSTALL=true
            shift
            ;;
        --help)
            show_help
            ;;
        *)
            echo -e "${RED}Unknown option: $arg${NC}"
            echo "Use --help for available options"
            exit 1
            ;;
    esac
done

# Display banner
echo ""
echo -e "${CYAN}==========================================${NC}"
echo -e "${CYAN} 🌊 AquaTrack Development Environment${NC}"
echo -e "${CYAN}==========================================${NC}"
echo ""

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo -e "${RED}❌ Error: package.json not found!${NC}"
    echo -e "${YELLOW}   Make sure you're in the correct project directory.${NC}"
    echo ""
    exit 1
fi

echo -e "${GREEN}✅ Project directory verified${NC}"
echo ""

# Check Node.js installation
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Error: Node.js is not installed${NC}"
    echo -e "${YELLOW}   Please install Node.js from https://nodejs.org/${NC}"
    echo ""
    exit 1
fi

NODE_VERSION=$(node --version)
echo -e "${GREEN}✅ Node.js detected: ${NODE_VERSION}${NC}"

# Clean install if requested
if [ "$CLEAN" = true ] && [ -d "node_modules" ]; then
    echo ""
    echo -e "${YELLOW}🗑️  Performing clean install...${NC}"
    rm -rf node_modules package-lock.json 2>/dev/null || true
    echo -e "${GREEN}   Cleaned previous installation${NC}"
fi

# Install dependencies
if [ "$INSTALL" = true ] || [ "$CLEAN" = true ] || [ ! -d "node_modules" ]; then
    echo ""
    echo -e "${YELLOW}📦 Installing project dependencies...${NC}"
    echo -e "${NC}   This may take a few minutes...${NC}"
    
    if ! npm install; then
        echo ""
        echo -e "${RED}❌ Failed to install dependencies${NC}"
        echo -e "${YELLOW}   Please check your internet connection and try again${NC}"
        echo ""
        exit 1
    fi
    echo -e "${GREEN}✅ Dependencies installed successfully${NC}"
else
    echo -e "${GREEN}✅ Dependencies already installed${NC}"
fi

# Generate Prisma client if schema exists
if [ -f "prisma/schema.prisma" ]; then
    echo ""
    echo -e "${YELLOW}🔧 Generating Prisma client...${NC}"
    if ! npx prisma generate; then
        echo -e "${RED}❌ Failed to generate Prisma client${NC}"
        echo ""
        exit 1
    fi
    echo -e "${GREEN}✅ Prisma client generated successfully${NC}"
fi

# Check environment file
if [ ! -f ".env" ]; then
    echo ""
    echo -e "${YELLOW}⚠️  Warning: .env file not found${NC}"
    echo -e "${NC}   The application may not work correctly without environment variables${NC}"
fi

echo ""
echo -e "${CYAN}==========================================${NC}"
echo -e "${CYAN} 🚀 Starting Development Server${NC}"
echo -e "${CYAN}==========================================${NC}"
echo ""
echo -e "${GREEN}🌐 Server will be available at: http://localhost:9002${NC}"
echo -e "${GREEN}🔄 Hot reload enabled - changes will auto-refresh${NC}"
echo -e "${YELLOW}🛑 Press Ctrl+C to stop the server${NC}"
echo ""

# Start development server
npm run dev

echo ""
echo -e "${CYAN}Server stopped. Thank you for using AquaTrack! 🌊${NC}"