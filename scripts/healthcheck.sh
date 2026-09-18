#!/usr/bin/env bash
set -euo pipefail

echo "========== HEALTH CHECK =========="

# Check Docker
if docker info >/dev/null 2>&1; then
    echo "✅ Docker is running"
else
    echo "❌ Docker is NOT running"
    exit 1
fi

# Check HTTP
for port in 8080 8081; do
    if curl -s -o /dev/null -w "%{http_code}" "http://localhost:$port" | grep -q "200"; then
        echo "✅ HTTP localhost:$port is reachable"
    else
        echo "❌ HTTP localhost:$port is NOT reachable"
    fi
done

echo "=================================="
