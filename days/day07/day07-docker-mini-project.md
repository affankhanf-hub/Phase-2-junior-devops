# Day 7 – Docker Mini Project

## 📋 Objective
Containerize the TechNova website using Docker and Docker Compose.

---

## 📚 Textbook Chapters Studied
- Chapter 2 – Docker Foundations
- Chapter 3 – Docker Storage, Networks, and Registries
- Chapter 4 – Docker Compose and Local Application Stacks

---

## 🎯 Theory Summary (In My Own Words)
I containerized a static website using Docker. The image is built from an Alpine-based Nginx image. Docker Compose is used to run the container with port mapping, volume mounting, and environment variables.

---

## 🔧 Lab Environment
- OS: Ubuntu 22.04 (WSL2)
- Docker Engine: 29.1.3
- Shell: Bash

---

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
Root Cause: Another container was using the same port
Fix: Stopped the conflicting container or changed the port to 8081

💼 What I Would Check in a Real Job
Is Docker running?

Is the port correctly mapped?

Are the logs clean?

Is the container healthy?

🗣️ Interview Answer
"I containerized the TechNova website using Docker. The image includes health checks, and Compose manages the container with volume mounting for live updates."

✅ Daily Quiz Answers
What is the difference between an image and a container?
Answer: An image is a template; a container is a running instance.

What does COPY do in a Dockerfile?
Answer: It copies files from the host into the image.

Why use volumes?
Answer: To persist data and enable live updates.

What is the purpose of HEALTHCHECK?
Answer: To monitor if the container is running properly.

What would break if the wrong port was used?
Answer: The website would not be accessible.

✅ Lessons Learned
Volumes allow live updates without rebuilding

Port mapping is critical for accessibility

Health checks help monitor container status

📂 Files Created Today
File	Location
Dockerfile	docker/Dockerfile
compose.yaml	docker/compose.yaml
index.html	docker/site/index.html
docker-runbook.md	docs/docker-runbook.md
docker-troubleshooting.md	docs/docker-troubleshooting.md
day07-docker-mini-project.md	days/day07/
