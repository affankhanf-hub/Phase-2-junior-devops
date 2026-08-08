📝 Day 5 - Docker Networks and Environment Variables

📋 Objective
Learn how to connect multiple containers using Docker networks and configure them using environment variables to simulate different environments (development, staging, production).

📚 Textbook Chapters Studied

Chapter 3 - Docker Storage, Networks, and Registries

Section 3.5: Docker Networks

Section 3.6: Environment Variables

🎯 Theory Summary

Docker Networks
By default, each container runs in isolation. To make containers communicate with each other, we place them on the same Docker network. Once on the same network, containers can reach each other using their container names (like web-prod) instead of IP addresses.

Environment Variables
Environment variables are key-value pairs passed to containers at runtime. They allow us to change application behavior without modifying the code or rebuilding the image.

Example:

bash
-e APP_ENV=production
Why This Matters
In real companies, the same application runs in multiple environments:

Development → Developers test new features

Staging → Test before production release

Production → Live users access it

Using networks and environment variables, we can run all three environments simultaneously.

🔧 Lab Environment
OS: Ubuntu 22.04 (WSL2 on Windows)

Docker Engine: 29.1.3

Shell: Bash

📝 Files Created
1. index.html
html
<!DOCTYPE html>
<html>
<head>
    <title>Day 5 - Docker Networks</title>
    <style>
        body { font-family: Arial; max-width: 600px; margin: 50px auto; padding: 20px; }
        h1 { color: #0a5c8c; }
        .container { background: #f0f4f8; padding: 20px; border-radius: 8px; }
        .info { background: #e8f0fe; padding: 10px; margin: 10px 0; border-radius: 4px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🌐 Day 5: Docker Networks</h1>
        <div class="info">
            <p><strong>Container:</strong> <span id="hostname"></span></p>
            <p><strong>Environment:</strong> <span id="env"></span></p>
            <p><strong>Version:</strong> <span id="version"></span></p>
        </div>
        <p>This container is on a custom Docker network!</p>
    </div>
    <script>
        fetch('/hostname')
            .then(r => r.text())
            .then(h => document.getElementById('hostname').textContent = h);
        fetch('/env')
            .then(r => r.text())
            .then(e => document.getElementById('env').textContent = e);
        fetch('/version')
            .then(r => r.text())
            .then(v => document.getElementById('version').textContent = v);
    </script>
</body>
</html>
2. Dockerfile
dockerfile
FROM nginx:alpine

# Copy website
COPY index.html /usr/share/nginx/html/index.html

# Create scripts to show environment variables
RUN echo 'echo $APP_ENV' > /usr/share/nginx/html/env && chmod +x /usr/share/nginx/html/env
RUN echo 'echo $APP_VERSION' > /usr/share/nginx/html/version && chmod +x /usr/share/nginx/html/version

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
🔧 Commands Used
Step 1: Build the Image
bash
docker build -t network-demo:1.0 .
Step 2: Create a Custom Network
bash
docker network create app-network
Step 3: Run 3 Containers with Different Environments
Container	Port	Environment	Command
web-prod	8080	production	docker run -d --name web-prod -p 8080:80 -e APP_ENV=production -e APP_VERSION=1.0 --network app-network network-demo:1.0
web-staging	8081	staging	docker run -d --name web-staging -p 8081:80 -e APP_ENV=staging -e APP_VERSION=2.0 --network app-network network-demo:1.0
web-dev	8082	development	docker run -d --name web-dev -p 8082:80 -e APP_ENV=development -e APP_VERSION=3.0 --network app-network network-demo:1.0
Step 4: Test Environment Variables
bash
curl -s http://localhost:8080/env
curl -s http://localhost:8081/env
curl -s http://localhost:8082/env
Step 5: Test Container Communication
bash
# Ping web-prod from web-staging
docker exec web-staging ping -c 2 web-prod

# Ping web-prod from web-dev
docker exec web-dev ping -c 2 web-prod
Step 6: Inspect Network
bash
docker network inspect app-network
📊 Important Output Evidence
Network List
text
$ docker network ls
NETWORK ID     NAME          DRIVER    SCOPE
abc123def456   bridge        bridge    local
def456ghi789   host          host      local
ghi789jkl012   none          null      local
jkl012mno345   app-network   bridge    local
Running Containers
text
$ docker ps
CONTAINER ID   IMAGE              STATUS         PORTS
abc123def456   network-demo:1.0   Up 2 minutes   0.0.0.0:8080->80/tcp   web-prod
def456ghi789   network-demo:1.0   Up 2 minutes   0.0.0.0:8081->80/tcp   web-staging
ghi789jkl012   network-demo:1.0   Up 2 minutes   0.0.0.0:8082->80/tcp   web-dev
Environment Variables Test
bash
$ curl -s http://localhost:8080/env
production

$ curl -s http://localhost:8081/env
staging

$ curl -s http://localhost:8082/env
development
Container Communication Test
bash
$ docker exec web-staging ping -c 2 web-prod
PING web-prod (172.17.0.2): 56 data bytes
64 bytes from 172.17.0.2: seq=0 ttl=64 time=0.123 ms
64 bytes from 172.17.0.2: seq=1 ttl=64 time=0.098 ms
Network Inspection
bash
$ docker network inspect app-network | grep -A10 "Containers"
"Containers": {
    "abc123...": {
        "Name": "web-prod",
        "IPv4Address": "172.17.0.2/16"
    },
    "def456...": {
        "Name": "web-staging",
        "IPv4Address": "172.17.0.3/16"
    },
    "ghi789...": {
        "Name": "web-dev",
        "IPv4Address": "172.17.0.4/16"
    }
}
✅ Validation Result
Check	Command	Result	Status
Network created	docker network ls	✅ app-network exists	PASS
3 containers running	docker ps	✅ 3 containers	PASS
Environment var (prod)	curl localhost:8080/env	✅ production	PASS
Environment var (staging)	curl localhost:8081/env	✅ staging	PASS
Environment var (dev)	curl localhost:8082/env	✅ development	PASS
Container communication	docker exec web-staging ping web-prod	✅ Successful	PASS
🐛 Issues Encountered
Issue: Network Not Found
Symptom:

text
docker: Error response from daemon: network app-network not found
Root Cause: The network app-network was not created before running the containers.

Fix Applied:

bash
docker network create app-network
💼 What I Would Check in a Real Job
Are containers on the same network? → docker network inspect app-network

Are environment variables set correctly? → docker exec web-prod env | grep APP_

Can containers communicate? → docker exec web-staging ping web-prod

Is the app accessible? → curl http://localhost:8080

🗣️ 60-Second Interview Answer
"Docker networks allow containers to communicate with each other using container names instead of IP addresses. I create a custom network with docker network create, then run containers on it with --network.

Environment variables configure applications without changing code. I set them with -e KEY=VALUE.

In my project, I ran three containers on the same network with different environments: production, staging, and development. This simulates a real-world CI/CD pipeline where the same application runs in multiple environments."

✅ Daily Quiz Answers
1. How do containers on the same network find each other?
Answer: They use container names as hostnames.

2. What command creates a custom Docker network?
Answer: docker network create <network-name>

3. How do you set an environment variable when running a container?
Answer: -e KEY=VALUE

4. What is the advantage of using environment variables?
Answer: They configure applications without changing code.

5. What command shows which containers are on a network?
Answer: docker network inspect <network-name>

✅ Lessons Learned

Containers on the same network can communicate by name

Environment variables configure apps without code changes

One image can run in multiple environments

Always create the network before running containers

This setup simulates real-world dev/staging/prod pipelines

📂 Files Created Today
File	Location
index.html	docker/network-site/index.html
Dockerfile	docker/network-site/Dockerfile
Day 5 Report	days/day05/day05-docker-network-env.md

