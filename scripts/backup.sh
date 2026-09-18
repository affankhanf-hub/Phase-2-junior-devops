#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="${HOME}/backups"
SOURCE_DIR="${HOME}/phase-2-junior-devops"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="backup_${TIMESTAMP}.tar.gz"

mkdir -p "$BACKUP_DIR"

echo "========== BACKUP =========="

if tar -czf "$BACKUP_DIR/$BACKUP_FILE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")" 2>/dev/null; then
    SIZE=$(du -h "$BACKUP_DIR/$BACKUP_FILE" | cut -f1)
    echo "✅ Backup created: $BACKUP_DIR/$BACKUP_FILE ($SIZE)"
else
    echo "❌ Backup failed"
    exit 1
fi

echo "=============================="
