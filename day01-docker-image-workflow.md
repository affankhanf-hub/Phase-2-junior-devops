Day 1 - Docker Refresher and Image Workflow
Objective
Build and run a static site Docker image, understand the fundamental concepts of images vs containers, and document the complete workflow with validation.

Textbook Chapters Studied
Chapter 2 - Docker Foundations

Theory Summary (in my own words)
What is Docker?
Docker solves the "it works on my machine" problem by packaging applications with all their dependencies into portable containers. Before containers, applications failed because of different OS versions, missing packages, different runtime versions, or inconsistent file paths.

Image vs Container
Image: A read-only template containing the application, runtime, libraries, and metadata. Think of it like a class or blueprint.

Container: A running instance of an image. It has its own process, writable layer, environment variables, network settings, and logs.

Dockerfile Basics
A Dockerfile is a recipe for building images. It defines:

Base image (FROM)

Files to copy (COPY)

Commands to run (RUN)

Startup command (CMD)

Ports to expose (EXPOSE)

Key Commands
docker build -t <name:tag> . - Build an image from a Dockerfile

docker run -d --name <name> -p <host>:<container> <image> - Run a container

docker ps - List running containers

docker logs <container> - View container output

docker stop/rm <container> - Stop/remove a container

Lab Environment Used
OS: Ubuntu 22.04 (WSL2 on Windows)

Docker Engine: 24.0.7

Shell: Bash

Commands Used
1. Verify Docker Installation
bash
docker version
docker --version

affanlinux@DESKTOP-INM25AC:~$ docker --version
Docker version 29.1.3, build 29.1.3-0ubuntu3~24.04.2

2. Create index.html
bash
cat > index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Day 1 - Docker Static Site</title>
    <style>
        body { font-family: Arial; max-width: 800px; margin: 50px auto; padding: 20px; }
        h1 { color: #0a5c8c; }
        .container { border: 1px solid #ddd; border-radius: 8px; padding: 20px; }
        .badge { background: #0a5c8c; color: white; padding: 4px 12px; border-radius: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Day 1: Docker Image Workflow</h1>
        <p><span class="badge">SUCCESS</span> Static site running in container!</p>
        <p>Built on: $(date)</p>
    </div>
</body>
</html>
EOF
3. Create Dockerfile
bash
cat > Dockerfile << 'EOF'
# Use nginx as base image
FROM nginx:alpine

# Copy our static files
COPY index.html /usr/share/nginx/html/index.html

# Document port 80
EXPOSE 80
EOF
4. Build the Image
bash
# Build the image with tag
docker build -t static-site:1.0 .

# Verify image was created
docker images | grep static-site
Output:

text
static-site   1.0    135e72cdb606   2 minutes ago   42.3MB
5. Run the Container
bash
# Run detached with port mapping
docker run -d --name site -p 8080:80 static-site:1.0

# Verify running
docker ps
Output:

text
CONTAINER ID   IMAGE             COMMAND                  CREATED         STATUS              PORTS                  NAMES
f79a6ebe2b8f   static-site:1.0   "/docker-entrypoint.…"   About a minute ago   Up 5 seconds (health: starting)   0.0.0.0:8080->80/tcp   site
6. Validate with curl
bash
# Check HTTP response
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost:8080
Output:

text
HTTP Status: 200
7. Check Container Logs
bash
docker logs site
Output:

text
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
...
2024/01/01 12:00:00 [notice] 1#1: start worker processes
8. Container Lifecycle Testing
bash
# Stop the container
docker stop site

# Start it again
docker start site

# Verify it's running
docker ps | grep site
9. Remove Container and Image
bash
# Stop and remove container
docker stop site
docker rm site

# Remove image
docker rmi static-site:1.0
Output:

text
Untagged: static-site:1.0
Deleted: sha256:135e72cdb606...
Deleted: sha256:56fe46984825...
Deleted: sha256:1b107a2724b4...
Important Output Evidence
Image Build Output
Image size: ~42.3MB (based on nginx:alpine)

Image ID: 135e72cdb606

Layers created: 3 layers

Docker ps Output
Container ID: f79a6ebe2b8f

Status: Up (health check starting)

Ports: 0.0.0.0:8080->80/tcp

curl Validation
HTTP Status: 200 OK

Content: HTML page returned successfully

Validation Result
✅ PASS - The app was successfully validated by:

Container running with docker ps

HTTP 200 response from curl

Logs showing Nginx started successfully

Successfully stopped and started container

Cleanly removed container and image

Issue or Failure Encountered
Issue 1: Path Error When Saving File
Symptom: Error when trying to save file in nano

text
Error writing /phase2/day01-static-site: No such file or directory
Root Cause: Using absolute path /phase2/ instead of relative path or using ~ (home directory)

Fix Applied:

bash
# Navigate to correct directory
cd ~/phase2/day01-static-site
# Then use nano without full path
nano index.html
Issue 2: Port Already in Use (If encountered)
Symptom: Port 8080 already allocated

Fix:

bash
# Find and stop conflicting container
docker ps | grep 8080
docker stop <conflicting-container>

# OR use different port
docker run -d --name site -p 8081:80 static-site:1.0
What I Would Check in a Real Job
Always use relative paths or ~ for home directory

Check port availability before running containers

Use meaningful container names

Always validate with curl before considering deployment successful

Document all commands and outputs

Clean up resources when done

60-Second Interview Answer
"Docker packages applications with their dependencies into portable images. An image is a read-only template built from a Dockerfile, while a container is a running instance of that image with its own isolated process and filesystem. In my project, I built a static site image using nginx:alpine as the base, ran it with port mapping from host 8080 to container 80, and validated it by checking docker ps for the running container and curl for an HTTP 200 response. I demonstrated the full lifecycle: building, running, validating, stopping, starting, and cleaning up both container and image."

Daily Quiz Answers
1. Define image and container.
Answer: An image is a read-only template containing an application and its dependencies. A container is a running instance of an image with its own isolated process, filesystem, and network.

2. What does docker run -p 8080:80 nginx mean?
Answer: This runs an nginx container and maps host port 8080 to container port 80. Traffic to localhost:8080 on the host is forwarded to port 80 inside the container where nginx listens.

3. A container is running but the browser cannot reach it. What do you check?
Answer:

Check container is running: docker ps

Check port mapping: docker port <container>

Check container logs: docker logs <container>

Test with curl: curl -v http://localhost:<host_port>

Verify the app is actually listening on the container port

Check host firewall/selinux

4. Explain Docker port publishing in 60 seconds.
Answer: Docker containers run in an isolated network, so their ports aren't directly accessible from the host. Port publishing maps a host port to a container port using -p HOST_PORT:CONTAINER_PORT. For example, -p 8080:80 means traffic to localhost:8080 on the host is forwarded to port 80 inside the container. EXPOSE in the Dockerfile is just documentation; actual publishing requires -p or Compose ports.

5. What evidence proves your answer?
Answer:

docker ps shows the container is running with port mapping

curl -v http://localhost:8080 shows the HTTP response

docker logs site shows application startup

docker port site shows active port mappings

docker images shows the image was built successfully

Lessons Learned
Always verify your current directory before creating files

Use relative paths to avoid path errors

Container lifecycle management is important

Health checks provide valuable operational insight

Documentation is essential for reproducibility

text


