#!/bin/bash

# Local development script that uses Docker for database only
# This bypasses network issues during Docker builds

set -e

echo "🌊 AquaTrack Local Development Setup"
echo "==================================="

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Check if database container is running
if ! docker-compose -f docker-compose.dev.yml ps db | grep -q "Up"; then
    echo "🗄️ Starting database container..."
    docker-compose -f docker-compose.dev.yml up -d db
    
    echo "⏳ Waiting for database to be ready..."
    sleep 10
    
    # Wait for database health check
    while ! docker-compose -f docker-compose.dev.yml ps db | grep -q "healthy"; do
        echo "   ... still waiting for database..."
        sleep 5
    done
    echo "✅ Database is ready!"
else
    echo "✅ Database container is already running"
fi

# Set environment variables for local development
export NODE_ENV=development
export DATABASE_URL="mysql://aquatrack_user:aquatrack_pass@localhost:3307/aquatrack"
export NEXTAUTH_SECRET="your-secret-key-change-this"
export NEXTAUTH_URL="http://localhost:9002"

echo ""
echo "🔧 Setting up Prisma..."

# Generate Prisma client (offline)
echo "📦 Generating Prisma client..."
npx prisma generate

echo "🗄️ Setting up database schema..."
npx prisma db push

echo ""
echo "🚀 Starting Next.js development server..."
echo "   App will be available at: http://localhost:9002"
echo "   Database is running on: localhost:3307"
echo ""
echo "Press Ctrl+C to stop the development server"
echo ""

# Start the development server
npm run dev