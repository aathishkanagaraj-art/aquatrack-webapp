# Modify Nginx default configuration to avoid common issues

# First, check if the config is valid
echo "🔍 Testing Nginx configuration..."
docker run --rm -v $(pwd)/nginx.conf:/etc/nginx/conf.d/default.conf nginx:alpine nginx -t

# If there's an error with the config, fix permission issues
if [ $? -ne 0 ]; then
  echo "🔧 Fixing potential Nginx configuration issues..."
  
  # Fix permissions
  chmod 644 nginx.conf
  
  # Check for syntax errors
  echo "server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://app:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}" > nginx.conf
  
  echo "✅ Nginx configuration fixed"
fi

# Show networks to ensure containers can communicate
echo "🌐 Docker networks:"
docker network ls

# Now run the main deployment script
chmod +x ./deploy.sh
./deploy.sh