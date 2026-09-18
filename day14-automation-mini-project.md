📝 Project 2 – Automation Mini Project (Complete Report)

📋 Objective

Build a complete automation pipeline using Bash, Ansible, and GitHub Actions.

📚 Textbook Chapters Studied
Chapter 5 – Bash Automation for DevOps

Chapter 7 – Ansible Configuration Management

Chapter 8 – GitHub Actions and CI/CD

🎯 Theory Summary 

Project 2 combines everything learned in Week 2. Bash scripts handle health checks and backups. Ansible configures the server (installs nginx + deploys website). GitHub Actions runs everything automatically when code is pushed. This is a real-world CI/CD pipeline.

🔧 Lab Environment
OS: Ubuntu 22.04 (WSL2)

Shell: Bash

Ansible Version: 2.14.x

GitHub Actions Runner: ubuntu-latest

📁 Files Created
1. scripts/healthcheck.sh
bash
#!/usr/bin/env bash
set -euo pipefail

echo "========== HEALTH CHECK =========="

if docker info >/dev/null 2>&1; then
    echo "✅ Docker is running"
else
    echo "❌ Docker is NOT running"
    exit 1
fi

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

echo "========== BACKUP =========="

if tar -czf "$BACKUP_DIR/$BACKUP_FILE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")" 2>/dev/null; then
    SIZE=$(du -h "$BACKUP_DIR/$BACKUP_FILE" | cut -f1)
    echo "✅ Backup created: $BACKUP_DIR/$BACKUP_FILE ($SIZE)"
else
    echo "❌ Backup failed"
    exit 1
fi

echo "=============================="
3. ansible/inventory.ini
ini
[local]
localhost ansible_connection=local
4. ansible/playbook.yml
yaml
---
- name: Setup web server
  hosts: local
  become: true

  tasks:
    - name: Install nginx
      apt:
        name: nginx
        state: present
        update_cache: yes

    - name: Start nginx
      service:
        name: nginx
        state: started
        enabled: true

    - name: Deploy website
      copy:
        content: |
          <h1>Deployed by Ansible!</h1>
          <p>This server was configured automatically.</p>
        dest: /var/www/html/index.html
5. .github/workflows/ci.yml
yaml
name: Automation CI

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  automation:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Run health check
        run: ./scripts/healthcheck.sh

      - name: Install Ansible
        run: |
          sudo apt update
          sudo apt install ansible -y

      - name: Run Ansible playbook
        run: ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
6. docs/automation-runbook.md
markdown
# Automation Runbook – Project 2

## Components
| Tool | File | Purpose |
|------|------|---------|
| Bash | `scripts/healthcheck.sh` | Health check |
| Bash | `scripts/backup.sh` | Backup |
| Ansible | `ansible/playbook.yml` | Server config |
| GitHub Actions | `.github/workflows/ci.yml` | CI/CD |

## How to Run Locally
```bash
./scripts/healthcheck.sh
./scripts/backup.sh
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml -K
How to Run in GitHub Actions
Push code → GitHub Actions runs automatically.

text

---

## 🔧 Commands Used

### Local Execution
```bash
./scripts/healthcheck.sh
./scripts/backup.sh
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml -K
GitHub Actions Execution
bash
git add .
git commit -m "Project 2: Automation Mini Project"
git push
📊 Important Output Evidence
Health Check Output
text
========== HEALTH CHECK ==========
✅ Docker is running
✅ HTTP localhost:8080 is reachable
❌ HTTP localhost:8081 is NOT reachable
==================================
Backup Output
text
========== BACKUP ==========
✅ Backup created: /home/affanlinux/backups/backup_20260919_011439.tar.gz (108K)
==============================
Ansible Playbook Output (Local)
text
PLAY [Setup web server] ****************************************************

TASK [Gathering Facts] *****************************************************
ok: [localhost]

TASK [Install nginx] *******************************************************
ok: [localhost]

TASK [Start nginx] *********************************************************
ok: [localhost]

TASK [Deploy website] ******************************************************
changed: [localhost]

PLAY RECAP *****************************************************************
localhost : ok=4    changed=1    unreachable=0    failed=0
GitHub Actions Output
text
✅ Checkout code
✅ Run health check
✅ Install Ansible
✅ Run Ansible playbook
   → nginx installed
   → website deployed
✅ Validation Result
Check	Local	GitHub Actions
Health check	✅ Pass	✅ Pass
Backup	✅ Pass	✅ Pass
Ansible playbook	✅ Pass	✅ Pass
Website deployed	✅ Pass	✅ Pass
🐛 Issue & Fix
Issue: Wrong Path to Playbook
Symptom: ERROR! the playbook: playbook.yml could not be found
Root Cause: Ran ansible-playbook playbook.yml from root folder.
Fix: Used full path: ansible-playbook -i ansible/inventory.ini ansible/playbook.yml -K

💼 What I Would Check in a Real Job
Is Docker running? → docker info

Is the website reachable? → curl http://localhost

Did the playbook run? → ansible-playbook --check

Did GitHub Actions succeed? → Actions tab

🗣️ 60-Second Interview Answer
"Project 2 combines Bash, Ansible, and GitHub Actions. Bash scripts handle health checks and backups. Ansible configures the server. GitHub Actions runs everything automatically on push. This is a complete CI/CD automation pipeline."

✅ Lessons Learned
Bash scripts automate repetitive tasks

Ansible configures servers idempotently

GitHub Actions runs everything on push

Combining tools creates a powerful pipeline

Always use correct paths

📂 Files Created
File	Location
healthcheck.sh	scripts/healthcheck.sh
backup.sh	scripts/backup.sh
inventory.ini	ansible/inventory.ini
playbook.yml	ansible/playbook.yml
ci.yml	.github/workflows/ci.yml
automation-runbook.md	docs/automation-runbook.md
day14-automation-mini-project.md	Project Report

