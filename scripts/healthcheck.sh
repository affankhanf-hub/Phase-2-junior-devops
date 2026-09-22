#!/usr/bin/env bash
set -euo pipefail

echo "========== HEALTH CHECK =========="

if docker info >/dev/null 2>&1; then
    echo "✅ Docker is running"
else
    echo "❌ Docker is NOT running"
    exit 1
fi

for container in shopeasy-web shopeasy-db shopeasy-cache; do
    if docker ps --format '{{.Names}}' | grep -q "^$container$"; then
        echo "✅ Container '$container' is running"
    else
        echo "❌ Container '$container' is NOT running"
    fi
done

if curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 | grep -q "200"; then
    echo "✅ Website is reachable"
else
    echo "❌ Website is NOT reachable"
fi

echo "=================================="
