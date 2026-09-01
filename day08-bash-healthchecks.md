Objective
Learn to write Bash scripts for automation, including variables, conditionals, loops, and exit codes.

Textbook Chapters Studied
Chapter 5 – Bash Automation for DevOps

Section 5.2: Why Bash still matters

Section 5.3: Script safety

Section 5.4: Variables and arguments

Section 5.5: Exit codes

Section 5.6: Idempotency

Theory Summary (In My Own Words)
Bash scripting is the foundation of automation in DevOps. Instead of typing commands manually, I write scripts that run multiple commands together. I learned about set -euo pipefail for safety, exit codes (0 = success), and idempotency (running scripts safely multiple times).

Lab Environment
OS: Ubuntu 22.04 (WSL2)

Shell: Bash

 Files Created
1. scripts/healthcheck.sh
bash
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

# Check containers
for container in debug optimized; do
    if docker ps --format '{{.Names}}' | grep -q "^$container$"; then
        echo "✅ Container '$container' is running"
    else
        echo "❌ Container '$container' is NOT running"
    fi
done

# Check HTTP endpoints
for port in 8080 8081; do
    if curl -s -o /dev/null -w "%{http_code}" "http://localhost:$port" | grep -q "200"; then
        echo "✅ HTTP localhost:$port is reachable"
    else
        echo "❌ HTTP localhost:$port is NOT reachable"
    fi
done

echo "=================================="
2. scripts/backup.sh
bash
#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="${HOME}/backups"
SOURCE_DIR="${HOME}/phase-2-junior-devops"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="backup_${TIMESTAMP}.tar.gz"

mkdir -p "$BACKUP_DIR"

echo "========== BACKUP SCRIPT =========="

if tar -czf "$BACKUP_DIR/$BACKUP_FILE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")" 2>/dev/null; then
    echo "✅ Backup created: $BACKUP_DIR/$BACKUP_FILE"
    SIZE=$(du -h "$BACKUP_DIR/$BACKUP_FILE" | cut -f1)
    echo "📦 Backup size: $SIZE"
else
    echo "❌ Backup failed"
    exit 1
fi

echo "===================================="
3. scripts/collect-logs.sh
bash
#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="${HOME}/logs/collect"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_FILE="${LOG_DIR}/container_logs_${TIMESTAMP}.txt"

mkdir -p "$LOG_DIR"

echo "========== COLLECTING CONTAINER LOGS =========="

{
    echo "================================"
    echo "Container Logs Collection"
    echo "Date: $(date)"
    echo "================================"
    
    for container in $(docker ps --format '{{.Names}}'); do
        echo ""
        echo "----------- $container -----------"
        docker logs "$container" --tail 20 2>&1 || echo "Failed to get logs for $container"
        echo "-----------------------------------"
    done
    
    echo ""
    echo "================================"
    echo "Collection Complete"
    echo "================================"
} > "$OUTPUT_FILE"

echo "✅ Logs saved to: $OUTPUT_FILE"
🔧 Commands Used
bash
chmod +x scripts/*.sh
./scripts/healthcheck.sh
./scripts/backup.sh
./scripts/collect-logs.sh
📊 Important Output Evidence
Health Check Output
text
========== HEALTH CHECK ==========
✅ Docker is running
✅ Container 'debug' is running
❌ Container 'optimized' is not running
✅ HTTP localhost:8080 is reachable
❌ HTTP localhost:8081 is not reachable
==================================
Backup Output
text
========== BACKUP SCRIPT ==========
✅ Backup created: /home/affanlinux/backups/backup_20260901_120000.tar.gz
📦 Backup size: 12M
====================================

Log Collection Output
text
========== COLLECTING CONTAINER LOGS ==========
✅ Logs saved to: /home/affanlinux/logs/collect/container_logs_20260901_120000.txt
✅ Validation Result
Check	Command	Result	Status
Scripts executable	ls -la scripts/	✅ 3 scripts	PASS
Health check	./scripts/healthcheck.sh	✅ Output shown	PASS
Backup	./scripts/backup.sh	✅ Backup created	PASS
Logs collected	./scripts/collect-logs.sh	✅ Logs saved	PASS
🐛 Issue or Failure Encountered
Issue: Permission Denied
Symptom:

bash
./healthcheck.sh
-bash: ./healthcheck.sh: Permission denied
Root Cause: The script was not executable.

Fix Applied:

bash
chmod +x healthcheck.sh
💼 What I Would Check in a Real Job
Are scripts executable? → ls -la *.sh

Do scripts have proper shebang? → head -1 script.sh

Are backups being created? → ls -la ~/backups/

Are logs being saved? → ls -la ~/logs/

🗣️ 60-Second Interview Answer
"Bash scripting is the foundation of automation. I wrote scripts for health checks, backups, and log collection. This saves time and reduces errors compared to typing commands manually."


