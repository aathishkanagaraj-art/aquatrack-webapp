#!/bin/bash
# deploy.sh - AquaTrack deployment script with proper container startup sequence

# Exit immediately if a command exits with a non-zero status
set -e

echo "🚀 Starting AquaTrack deployment..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
  echo "❌ Docker is not running or you don't have permissions."
  echo "Run: sudo systemctl start docker"
  echo "And: sudo usermod -aG docker $USER && newgrp docker"
  exit 1
fi

# Stop any existing containers
echo "🛑 Stopping existing containers..."
docker-compose -f docker-compose.prod.yml down || true

# Remove any anonymous volumes
echo "🗑️ Cleaning up volumes..."
docker volume prune -f

# Build the services with no cache to ensure fresh builds
echo "🏗️ Building containers (no cache)..."
docker-compose -f docker-compose.prod.yml build --no-cache

# Start only the database first to ensure it's ready
echo "📦 Starting MySQL database..."
docker-compose -f docker-compose.prod.yml up -d db

# Wait for the database to be healthy
echo "⏳ Waiting for MySQL to be ready..."
attempt=1
max_attempts=30
until docker-compose -f docker-compose.prod.yml exec -T db mysqladmin ping -h localhost -u root --password=rootpassword --silent || [ $attempt -eq $max_attempts ]; do
  echo "Waiting for MySQL to be ready... ($attempt/$max_attempts)"
  sleep 3
  ((attempt++))
done

if [ $attempt -eq $max_attempts ]; then
  echo "❌ MySQL failed to start within the expected time"
  docker-compose -f docker-compose.prod.yml logs db
  exit 1
fi

# Start the application
echo "🚀 Starting application..."
docker-compose -f docker-compose.prod.yml up -d app

# Check if the app is running
echo "⏳ Waiting for the application to start..."
sleep 10

# Start Nginx last after app is ready
echo "🌐 Starting Nginx..."
docker-compose -f docker-compose.prod.yml up -d nginx

# Check if nginx is running
if docker-compose -f docker-compose.prod.yml ps | grep nginx | grep -q Up; then
  echo "✅ Nginx is running!"
else
  echo "❌ Nginx failed to start"
  docker-compose -f docker-compose.prod.yml logs nginx
  echo "🔍 Checking for permission issues with nginx.conf..."
  ls -la nginx.conf
  echo "🔍 Checking nginx configuration..."
  docker-compose -f docker-compose.prod.yml exec -T nginx nginx -t || true
fi

# Show container status
echo "📊 Container status:"
docker-compose -f docker-compose.prod.yml ps

# Check if all required containers are running
required_services=("app" "db" "nginx")
all_running=true

for service in "${required_services[@]}"; do
  if ! docker-compose -f docker-compose.prod.yml ps | grep $service | grep -q Up; then
    all_running=false
    echo "❌ $service is not running"
    docker-compose -f docker-compose.prod.yml logs $service
  fi
done

if $all_running; then
  echo "✅ All services are running!"
  echo "🌐 Your application is now available at: http://$(hostname -I | awk '{print $1}')"
else
  echo "❌ Some services failed to start. See logs above."
  exit 1
fi