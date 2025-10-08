#!/bin/bash

# Quick fix script for npm registry DNS issues
# Run this before attempting Docker builds

echo "🔧 Applying quick fixes for npm registry connectivity..."

# Fix 1: Flush DNS cache
echo "1️⃣ Flushing DNS cache..."
sudo systemctl flush-dns 2>/dev/null || echo "DNS flush not available on this system"

# Fix 2: Restart systemd-resolved
echo "2️⃣ Restarting DNS resolver..."
sudo systemctl restart systemd-resolved 2>/dev/null || echo "systemd-resolved not available"

# Fix 3: Add DNS servers to resolv.conf temporarily
echo "3️⃣ Adding reliable DNS servers..."
echo "nameserver 8.8.8.8" | sudo tee -a /etc/resolv.conf >/dev/null
echo "nameserver 8.8.4.4" | sudo tee -a /etc/resolv.conf >/dev/null
echo "nameserver 1.1.1.1" | sudo tee -a /etc/resolv.conf >/dev/null

# Fix 4: Test npm registry connectivity
echo "4️⃣ Testing npm registry connectivity..."
if ping -c 3 registry.npmjs.org; then
    echo "✅ npm registry is reachable"
else
    echo "❌ npm registry still unreachable"
    echo "💡 You may need to check your network connection or proxy settings"
fi

# Fix 5: Configure Docker to use host network during build
echo "5️⃣ Setting up Docker environment..."
export DOCKER_BUILDKIT=1

echo ""
echo "🎯 Quick fixes applied! Now try building again:"
echo "  ./docker-build.sh"
echo "  or"
echo "  docker-compose build"
echo ""
echo "If issues persist, try:"
echo "  - Check if you're behind a corporate firewall"
echo "  - Verify no VPN is interfering"
echo "  - Try building with: docker build --network=host ."