📋 Objective
Learn how to persist data in Docker containers using volumes and bind mounts so your data survives container restarts and deletions.

📚 Textbook Chapters Studied
Chapter 3 - Docker Storage, Networks, and Registries

Section 3.2: Container Filesystem

Section 3.3: Volumes

Section 3.4: Bind Mounts

🎯 Theory Summary (In My Own Words)
The Problem:
Containers are ephemeral — when you delete a container, ALL data inside it is LOST forever. This is a problem for:

Databases (MySQL, PostgreSQL)

Uploaded files (user photos, documents)

Application logs

Configuration files

The Solution: Volumes & Bind Mounts
Concept	What It Does	When to Use
Volume	Docker-managed storage (lives in /var/lib/docker/volumes/)	Production data, databases
Bind Mount	Maps a host folder directly to container	Development, hot-reloading code


Lab: Docker Volumes & Bind Mounts

Step 1: Create Project Directory
bash
cd ~/phase-2-junior-devops
mkdir -p docker/volume-site
mkdir -p days/day04
cd docker/volume-site

Step 2: Create a Simple HTML Page

cat > index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Volume Demo</title>
    <style>
        body { font-family: Arial; max-width: 600px; margin: 50px auto; padding: 20px; }
        h1 { color: #0a5c8c; }
        .container { background: #f0f4f8; padding: 20px; border-radius: 8px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>📦 Docker Volume Demo</h1>
        <p>This data is stored in a volume!</p>
        <p>It will survive container deletion.</p>
        <p><small>Container ID: <span id="hostname"></span></small></p>
    </div>
    <script>
        fetch('/hostname')
            .then(r => r.text())
            .then(h => document.getElementById('hostname').textContent = h);
    </script>
</body>
</html>
EOF

Step 3: Create Dockerfile

cat > Dockerfile << 'EOF'
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF

Step 4: Build the Image

docker build -t volume-demo:1.0 .

Output

DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon  3.584kB
Step 1/4 : FROM nginx:alpine
 ---> feb6f75a08aa
Step 2/4 : COPY index.html /usr/share/nginx/html/index.html
 ---> debd2de49865
Step 3/4 : EXPOSE 80
 ---> Running in 465a4765649a
 ---> Removed intermediate container 465a4765649a
 ---> d1cd3e1d20f8
Step 4/4 : CMD ["nginx", "-g", "daemon off;"]
 ---> Running in 92d74ccbd019
 ---> Removed intermediate container 92d74ccbd019
 ---> fb0d35fd0c2f
Successfully built fb0d35fd0c2f
Successfully tagged volume-demo:1.0


Step 5: Run WITHOUT Volume (Data Will Be Lost!)

curl -s http://localhost:8080  # Connection refused ❌3fdf67ec4778dfd117a8aa37d108d8010697a099faf7d7d03163c8c0b48ca633
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/docker/volume-site$
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/docker/volume-site$ # Test it works
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/docker/volume-site$ curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost:8080
HTTP Status: 000
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/docker/volume-site$
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/docker/volume-site$ # Check the HTML content
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/docker/volume-site$ curl -s http://localhost:8080 | grep "Volume Demo"
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/docker/volume-site$
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/docker/volume-site$ # Stop and remove container
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/docker/volume-site$ docker stop no-volume
no-volume
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/docker/volume-site$ docker rm no-volume
no-volume
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/docker/volume-site$
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/docker/volume-site$ # Now try to access again (it's GONE!)
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/docker/volume-site$ curl -s http://localhost:8080  # Connection refused ❌
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/docker/volume-site$ curl -s http://localhost:8080
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/docker/volume-site$


Step 6: Create and Use a Docker Volume

# 1. Create a volume
docker volume create my_app_data

# 2. List volumes
docker volume ls

# 3. Inspect volume (shows where it's stored)
docker volume inspect my_app_data

Output
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/docker/volume-site$ docker volume inspect my_app_data
[
    {
        "CreatedAt": "2026-07-17T01:17:32+02:00",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/my_app_data/_data",
        "Name": "my_app_data",
        "Options": null,
        "Scope": "local"
    }
]

Step 7: Run Container WITH Volume

# Run container with volume mounted
docker run -d --name with-volume \
    -v my_app_data:/usr/share/nginx/html \
    -p 8081:80 \
    volume-demo:1.0

# Test it works
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost:8081

# Check the HTML
curl -s http://localhost:8081 | grep "Volume Demo"

Output

affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/docker/volume-site$ curl -s http://localhost:8081 | grep "Volume Demo"
    <title>Volume Demo</title>
        <h1>📦 Docker Volume Demo</h1>

Step 8: Update Data in the Volume

# Create a new HTML file
cat > new-index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Updated Volume Demo</title>
</head>
<body>
    <h1>🔄 DATA UPDATED!</h1>
    <p>This change is stored in the volume!</p>
    <p>It will survive container deletion.</p>
</body>
</html>
EOF

# Copy into container (overwrites the existing file)
docker cp new-index.html with-volume:/usr/share/nginx/html/index.html

# Test the updated page
curl -s http://localhost:8081 | grep "DATA UPDATED"

Output

affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/docker/volume-site$ curl -s http://localhost:8081 | grep "DATA UPDATED"
    <h1>🔄 DATA UPDATED!</h1>

Step 9: Verify Data Persistence

# Stop the container
docker stop with-volume

# Remove the container
docker rm with-volume

# Check container is gone
docker ps -a | grep with-volume

# Create a NEW container with the SAME volume
docker run -d --name new-container \
    -v my_app_data:/usr/share/nginx/html \
    -p 8081:80 \
    volume-demo:1.0

# Data is STILL THERE!
curl -s http://localhost:8081 | grep "DATA UPDATED"

Output

affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/docker/volume-site$ curl -s http://localhost:8081 | grep "DATA UPDATED"
    <h1>🔄 DATA UPDATED!</h1>

Step 10: Use Bind Mounts (Host Folder)

# 1. Create a folder on your host
mkdir -p ~/phase-2-junior-devops/docker/volume-site/host-data

# 2. Create an HTML file on your host
cat > ~/phase-2-junior-devops/docker/volume-site/host-data/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Bind Mount Demo</title>
</head>
<body>
    <h1>📂 BIND MOUNT DATA</h1>
    <p>This file is on your HOST machine!</p>
    <p>Edit it on your computer and refresh the browser!</p>
</body>
</html>
EOF

# 3. Run container with bind mount
docker run -d --name bind-demo \
    -v ~/phase-2-junior-devops/docker/volume-site/host-data:/usr/share/nginx/html \
    -p 8082:80 \
    nginx:alpine

# 4. Test
curl -s http://localhost:8082 | grep "BIND MOUNT"

# 5. Edit the file on your host
echo '<h1>🔥 I CHANGED THIS ON MY HOST!</h1>' > ~/phase-2-junior-devops/docker/volume-site/host-data/index.html

# 6. Test again - changes appear IMMEDIATELY!
curl -s http://localhost:8082 | grep "CHANGED"

Output

affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/docker/volume-site$ curl -s http://localhost:8082 | grep "CHANGED"
<h1>🔥 I CHANGED THIS ON MY HOST!</h1>

Important Output Evidence

$ docker volume ls
DRIVER    VOLUME NAME
local     my_app_data

affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/docker/volume-site$ docker volume inspect my_app_data
[
    {
        "CreatedAt": "2026-07-17T01:17:32+02:00",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/my_app_data/_data",
        "Name": "my_app_data",
        "Options": null,
        "Scope": "local"
    }
]

📊 Validation Results
✅ Volume data survived container deletion

✅ Bind mount changes appear instantly

🗣️ Interview Answer
"Docker containers are ephemeral. I use volumes for persistent data and bind mounts for development."

✅ Lessons Learned
Containers are temporary

Volumes are permanent

Bind mounts = instant updates

Always use volumes for databases

text

**Save:** `Ctrl+O` → `Enter` → `Ctrl+X`

---

## 🗑️ Cleanup (Optional)

```bash
# Stop all containers
docker stop no-volume new-container bind-demo
docker rm no-volume new-container bind-demo

# Remove volumes
docker volume rm my_app_data

# Remove images
docker rmi volume-demo:1.0

