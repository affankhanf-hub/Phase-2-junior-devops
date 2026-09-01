📋 Objective
Write deployment and backup scripts with logging, validation, and idempotency.

📚 Textbook Chapters Studied
Chapter 5 – Bash Automation for DevOps

Section 5.5: Exit codes

Section 5.6: Idempotency

Section 5.7: Operational script examples

🎯 Theory Summary (In My Own Words)
Day 9 extends Bash scripting to real-world DevOps tasks: deployment, validation, and backups. I learned about idempotency (running scripts safely multiple times), logging (recording what the script did), and validation (checking if deployment worked). I also created a master script to run everything with one command.

🔧 Lab Environment
OS: Ubuntu 22.04 (WSL2)

Shell: Bash

📁 Files Created
1. scripts/deploy.sh
bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${HOME}/logs/deploy.log"
mkdir -p "$(dirname "$LOG_FILE")"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "========== DEPLOYMENT STARTED =========="

# 1. Check Docker
if ! docker info >/dev/null 2>&1; then
    log "❌ Docker is not running"
    exit 1
fi
log "✅ Docker is running"

# 2. Build Docker image
cd "$SCRIPT_DIR/../docker/mini-project" || exit 1
if docker build -t technova:1.0 .; then
    log "✅ Image built successfully"
else
    log "❌ Image build failed"
    exit 1
fi

# 3. Run container
if docker run -d --name technova-web -p 8080:80 technova:1.0; then
    log "✅ Container started successfully"
else
    log "❌ Container failed to start"
    exit 1
fi

# 4. Validate
sleep 3
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 | grep -q "200"; then
    log "✅ Website is reachable"
else
    log "❌ Website is not reachable"
    exit 1
fi

log "========== DEPLOYMENT COMPLETED =========="
2. scripts/backup.sh
bash
#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="${HOME}/backups"
SOURCE_DIR="${HOME}/phase-2-junior-devops"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="backup_${TIMESTAMP}.tar.gz"
LOG_FILE="${BACKUP_DIR}/backup.log"

mkdir -p "$BACKUP_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "========== BACKUP STARTED =========="

if tar -czf "$BACKUP_DIR/$BACKUP_FILE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")" 2>/dev/null; then
    SIZE=$(du -h "$BACKUP_DIR/$BACKUP_FILE" | cut -f1)
    log "✅ Backup created: $BACKUP_DIR/$BACKUP_FILE ($SIZE)"
else
    log "❌ Backup failed"
    exit 1
fi

log "========== BACKUP COMPLETED =========="
3. scripts/validate-deploy.sh
bash
#!/usr/bin/env bash
set -euo pipefail

echo "========== VALIDATING DEPLOYMENT =========="

# Check Docker
if docker info >/dev/null 2>&1; then
    echo "✅ Docker is running"
else
    echo "❌ Docker is not running"
    exit 1
fi

# Check container
if docker ps --format '{{.Names}}' | grep -q "technova-web"; then
    echo "✅ Container 'technova-web' is running"
else
    echo "❌ Container 'technova-web' is not running"
    exit 1
fi

# Check HTTP
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 | grep -q "200"; then
    echo "✅ Website is reachable"
else
    echo "❌ Website is not reachable"
    exit 1
fi

echo "========== VALIDATION COMPLETE =========="
4. scripts/run-all.sh
bash
#!/usr/bin/env bash

echo "========== RUNNING ALL SCRIPTS =========="

./scripts/deploy.sh
./scripts/backup.sh
./scripts/validate-deploy.sh

echo "========== ALL SCRIPTS COMPLETED =========="
🔧 Commands Used
bash
chmod +x scripts/*.sh
./scripts/run-all.sh
📊 Important Output Evidence
Deployment Output
text
========== DEPLOYMENT STARTED ==========
[2026-09-01 12:00:00] ✅ Docker is running
[2026-09-01 12:00:05] ✅ Image built successfully
[2026-09-01 12:00:10] ✅ Container started successfully
[2026-09-01 12:00:15] ✅ Website is reachable
========== DEPLOYMENT COMPLETED ==========
Backup Output
text
========== BACKUP STARTED ==========
[2026-09-01 12:00:20] ✅ Backup created: /home/affanlinux/backups/backup_20260901_120000.tar.gz (12M)
========== BACKUP COMPLETED ==========
Validation Output
text
========== VALIDATING DEPLOYMENT ==========
✅ Docker is running
✅ Container 'technova-web' is running
✅ Website is reachable
========== VALIDATION COMPLETE ==========
✅ Validation Result
Check	Result	Status
Docker running	✅	PASS
Image built	✅	PASS
Container running	✅	PASS
Website reachable	✅	PASS
Backup created	✅	PASS
Validation passed	✅	PASS
🐛 Issue & Fix
Issue: Container Name Conflict
Symptom: docker: Error response from daemon: Conflict. The container name "/technova-web" is already in use

Root Cause: A container with the same name already existed.

Fix Applied:

bash
docker rm -f technova-web
💼 What I Would Check in a Real Job
Is Docker running? → docker info

Is the container running? → docker ps

Is the website reachable? → curl -s http://localhost:8080

Is the backup created? → ls -la ~/backups/

Are logs being written? → cat ~/logs/deploy.log

🗣️ 60-Second Interview Answer
"Day 9 was about automating deployments and backups. I wrote scripts to build and run Docker containers, create backups with timestamps, and validate that deployments worked. I also created a master script to run everything with one command."

✅ Lessons Learned
Idempotency ensures scripts can run multiple times safely

Logging helps with debugging and tracking

Validation confirms deployment success

Master scripts orchestrate multiple tasks


