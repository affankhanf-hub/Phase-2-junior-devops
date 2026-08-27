# Day 7 – Docker Mini Project

## 📋 Objective
Containerize the TechNova website using Docker and Docker Compose.

## 🔧 Commands Used
```bash
docker-compose -f compose.yaml build
docker-compose -f compose.yaml up -d
curl http://localhost:8080
docker logs technova-web --tail 10
📊 Validation Results
Check	Result
Image built	✅
Container running	✅
Port published	✅
curl HTTP 200	✅
Logs clean	✅
🐛 Issue & Fix
Issue: Port 8080 was already in use
Fix: Changed to 8081 or stopped conflicting container

🗣️ Interview Answer
"I containerized the TechNova website using Docker. The image includes health checks, and Compose manages the container with volume mounting for live updates."



