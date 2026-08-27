# TechNova Website – Docker Runbook

## Prerequisites
- Docker installed
- Docker Compose installed

## Steps to Run

### Step 1 – Go to the project folder
```bash
cd ~/phase-2-junior-devops/docker

Step 2 – Build the Docker image
bash
docker-compose -f compose.yaml build
Step 3 – Start the containers
bash
docker-compose -f compose.yaml up -d
Step 4 – Check if everything is running
bash
docker-compose -f compose.yaml ps
Step 5 – Open the website
Open your browser and go to:

text
http://localhost:8080
Step 6 – Stop the containers (when done)
bash
docker-compose -f compose.yaml down
Logs (if something goes wrong)
bash
docker logs technova-web --tail 20
text

### Step 3 – Save and Exit

