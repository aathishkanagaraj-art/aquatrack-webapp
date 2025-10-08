#!/bin/bash

# Docker build script with network issue handling
# This script provides better error handling and retry logic for Docker builds

set -e

echo "🚀 Starting Docker build with network optimization..."

# Function to check internet connectivity
check_internet() {
    echo "🔍 Checking internet connectivity..."
    if ping -c 1 8.8.8.8 &> /dev/null; then
        echo "✅ Internet connection is working"
        return 0
    else
        echo "❌ No internet connection detected"
        return 1
    fi
}

# Function to check DNS resolution
check_dns() {
    echo "🔍 Checking DNS resolution for npm registry..."
    if nslookup registry.npmjs.org &> /dev/null; then
        echo "✅ DNS resolution working for npm registry"
        return 0
    else
        echo "❌ DNS resolution failed for npm registry"
        echo "💡 Try: sudo systemctl restart systemd-resolved"
        return 1
    fi
}

# Function to build with Docker
build_docker() {
    local dockerfile=${1:-"Dockerfile"}
    local max_attempts=3
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        echo "🔨 Build attempt $attempt/$max_attempts using $dockerfile..."
        
        if docker build \
            --build-arg BUILDKIT_INLINE_CACHE=1 \
            --network=host \
            --dns=8.8.8.8 \
            --dns=8.8.4.4 \
            -f "$dockerfile" \
            -t aquatrack-webapp:latest .; then
            echo "✅ Docker build successful!"
            return 0
        else
            echo "❌ Build attempt $attempt failed"
            if [ $attempt -lt $max_attempts ]; then
                echo "⏳ Waiting 10 seconds before retry..."
                sleep 10
            fi
            ((attempt++))
        fi
    done
    
    echo "💥 All build attempts failed"
    return 1
}

# Function to build with docker-compose
build_compose() {
    local max_attempts=3
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        echo "🔨 Docker Compose build attempt $attempt/$max_attempts..."
        
        if DOCKER_BUILDKIT=1 docker-compose build --parallel; then
            echo "✅ Docker Compose build successful!"
            return 0
        else
            echo "❌ Compose build attempt $attempt failed"
            if [ $attempt -lt $max_attempts ]; then
                echo "⏳ Waiting 10 seconds before retry..."
                sleep 10
            fi
            ((attempt++))
        fi
    done
    
    echo "💥 All compose build attempts failed"
    return 1
}

# Main execution
main() {
    echo "🌊 AquaTrack Docker Build Script"
    echo "================================"
    
    # Check prerequisites
    check_internet
    check_dns
    
    # Determine build method
    if [ "$1" = "compose" ]; then
        echo "📦 Building with Docker Compose..."
        build_compose
    elif [ "$1" = "prod" ]; then
        echo "🏭 Building production image..."
        build_docker "Dockerfile.prod"
    else
        echo "🔧 Building development image..."
        build_docker "Dockerfile"
    fi
    
    if [ $? -eq 0 ]; then
        echo "🎉 Build completed successfully!"
        echo ""
        echo "Next steps:"
        echo "  - For development: docker-compose up"
        echo "  - For production: docker run -p 3000:3000 aquatrack-webapp:latest"
    else
        echo "💥 Build failed. Check the errors above."
        echo ""
        echo "Troubleshooting tips:"
        echo "  1. Check your internet connection"
        echo "  2. Try: sudo systemctl restart docker"
        echo "  3. Try: sudo systemctl restart systemd-resolved"
        echo "  4. Check if any VPN/proxy is interfering"
        echo "  5. Try building without cache: docker build --no-cache ..."
        exit 1
    fi
}

# Run main function with all arguments
main "$@"