# Day 3 - Docker Ports, Logs, and Debugging

## 📋 Objective
Learn to troubleshoot Docker containers by checking status, logs, ports, and health. Practice debugging a broken container step by step.

---

## 📚 Textbook Chapters Studied
- Chapter 2 - Docker Foundations (Pages 21-23)
  - Section 2.6: Logs and Troubleshooting
  - Section 2.7: Port Mapping

---

## 🎯 Theory Summary (In My Own Words)

### What is Port Mapping?
Port mapping connects a port on your computer to a port inside the container.

```bash
docker run -p 8080:80 nginx
#              ↑      ↑
#         Your PC   Container
Part	Meaning
-p 8080:80	Forward traffic from host port 8080 to container port 80
localhost:8080	Access the app in your browser
What are Container Logs?
Logs are everything the container prints to the screen — errors, warnings, startup messages.

bash
docker logs container-name
5-Step Debugging Process
When a container isn't working:

Step	Command	What It Checks
1	docker ps	Is the container running?
2	docker logs <container>	What does the output say?
3	docker port <container>	Is the port mapped correctly?
4	curl localhost:port	Can I reach the app?
5	docker exec -it <container> sh	What's happening inside?
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
    <title>Day 3 - Debugging</title>
</head>
<body>
    <h1>Debugging Test</h1>
    <p>If you see this, the container is working!</p>
</body>
</html>
2. Dockerfile
dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

Lab Commands Used

affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops$ cd day3
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/day3$ ls
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/day3$ mkdir -p docker/debug-site
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/day3$ cd docker/debug-site
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/day3/docker/debug-site$ nano index.html
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/day3/docker/debug-site$ nano Dockerfile
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/day3/docker/debug-site$
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/day3/docker/debug-site$ docker build -t debug-site:1.0 .
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon   2.56kB
Error response from daemon: the Dockerfile (Dockerfile) cannot be empty
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/day3/docker/debug-site$ docker run -d --name debug -p 8080:80 debug-site:1.0
Unable to find image 'debug-site:1.0' locally
docker: Error response from daemon: pull access denied for debug-site, repository does not exist or may require 'docker login'

Run 'docker run --help' for more information
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/day3/docker/debug-site$ nano Dockerfile
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/day3/docker/debug-site$ cat Dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/day3/docker/debug-site$ nano index.html
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/day3/docker/debug-site$ docker build -t debug-site:1.0 .
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/day3/docker/debug-site$ git pull origin main --allow-unrelated-historiesing build context to Docker daemon  3.072kB
Step 1/4 : FROM nginx:alpine
 ---> feb6f75a08aa
Step 2/4 : COPY index.html /usr/share/nginx/html/index.html
 ---> b62640abd88f
Step 3/4 : EXPOSE 80
 ---> Running in c7058d1982ed
 ---> Removed intermediate container c7058d1982ed
 ---> 9ad7efb53b83
Step 4/4 : CMD ["nginx", "-g", "daemon off;"]
 ---> Running in 065c69354d11
 ---> Removed intermediate container 065c69354d11
 ---> 5ede8894ef40
 ---> 5ede8894ef40
Successfully built 5ede8894ef40
Successfully tagged debug-site:1.0
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/day3/docker/debug-site$ docker run -d --name debug -p 8080:80 debug-site:1.0
89e24ae2352467372f9ce7e7ca96d658521190338b89a863eb605533863363d1
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/day3/docker/debug-site$ docker ps | grep debug
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost:8080
docker logs debug --tail 589e24ae23524   debug-site:1.0   "/docker-entrypoint.…"   11 seconds ago   Up 10 seconds   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   debug
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/day3/docker/debug-site$ curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost:8080
HTTP Status: 200
a

Important Output Evidence
1. Check if Container is Running

affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/day3/docker/debug-site$ docker ps
CONTAINER ID   IMAGE            COMMAND                  CREATED         STATUS         PORTS                                     NAMES
89e24ae23524   debug-site:1.0   "/docker-entrypoint.…"   6 minutes ago   Up 6 minutes   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   debug

2. Check Logs
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/day3/docker/debug-site$ docker logs debug
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Sourcing /docker-entrypoint.d/15-local-resolvers.envsh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2026/07/08 12:26:14 [notice] 1#1: using the "epoll" event method
2026/07/08 12:26:14 [notice] 1#1: nginx/1.31.0
2026/07/08 12:26:14 [notice] 1#1: built by gcc 15.2.0 (Alpine 15.2.0)
2026/07/08 12:26:14 [notice] 1#1: OS: Linux 6.18.33.2-microsoft-standard-WSL2
2026/07/08 12:26:14 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1024:1048576
2026/07/08 12:26:14 [notice] 1#1: start worker processes
2026/07/08 12:26:14 [notice] 1#1: start worker process 30
2026/07/08 12:26:14 [notice] 1#1: start worker process 31
2026/07/08 12:26:14 [notice] 1#1: start worker process 32
2026/07/08 12:26:14 [notice] 1#1: start worker process 33
172.17.0.1 - - [08/Jul/2026:12:26:25 +0000] "GET / HTTP/1.1" 200 180 "-" "curl/8.5.0" "-"

3. Check Port Mapping

affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/day3/docker/debug-site$ docker port debug
80/tcp -> 0.0.0.0:8080
80/tcp -> [::]:8080

4. Test Access with curl

affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/day3/docker/debug-site$ curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost:8080
HTTP Status: 200

5. Test with Verbose curl

affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/day3/docker/debug-site$ curl -v http://localhost:8080
* Host localhost:8080 was resolved.
* IPv6: ::1
* IPv4: 127.0.0.1
*   Trying [::1]:8080...
* Connected to localhost (::1) port 8080
> GET / HTTP/1.1
> Host: localhost:8080
> User-Agent: curl/8.5.0
> Accept: */*
>
< HTTP/1.1 200 OK
< Server: nginx/1.31.0
< Date: Wed, 08 Jul 2026 12:39:21 GMT
< Content-Type: text/html
< Content-Length: 180
< Last-Modified: Wed, 08 Jul 2026 12:25:19 GMT
< Connection: keep-alive
< ETag: "6a4e41af-b4"
< Accept-Ranges: bytes
<
<!DOCTYPE html>
<html>
<head>
    <title>Day 3 - Debugging</title>
</head>
<body>
    <h1>Debugging Test</h1>
    <p>If you see this, the container is working!</p>
</body>
</html>
* Connection #0 to host localhost left intact
a

6. Go Inside the Container

affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/day3/docker/debug-site$ 1 root      0:00 nginx: master process nginx -g daemon off;
1: command not found
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/day3/docker/debug-site$ 30 nginx    0:00 nginx: worker process
30: command not found
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/day3/docker/debug-site$ 31 nginx    0:00 nginx: worker process
31: command not found
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/day3/docker/debug-site$
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/day3/docker/debug-site$  docker exec -it debug sh
/ #  cat /usr/share/nginx/html/index.html
ging Test</h1>
    <p>If you see this, the container is wo<!DOCTYPE html>
<html>
<head>
    <title>Day 3 - Debugging</title>
</head>
<body>
    <h1>Debugging Test</h1>
    <p>If you see this, the container is working!</p>
</body>
</html>
rking!</p>
</body>
</html>/ # <!DOCTYPE html>
sh: syntax error: unexpected newline
/ # <html>
sh: syntax error: unexpected newline
/ # <head>
sh: syntax error: unexpected newline
/ #     <title>Day 3 - Debugging</title>
sh: syntax error: unexpected newline
/ # </head>
sh: syntax error: unexpected newline
/ # <body>
sh: syntax error: unexpected newline
/ #     <h1>Debugging Test</h1>
sh: syntax error: unexpected newline
/ #     <p>If you see this, the container is working!</p>
sh: syntax error: unexpected newline
/ # </body>
sh: syntax error: unexpected newline
/ # </html>
sh: syntax error: unexpected newline
/ # ^C

/ # ^C

/ # ^C

/ #
/ # exit
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/day3/docker/debug-site$ ps aux | grep nginx
root         310  0.0  0.0  11172  1836 ?        Ss   14:11   0:00 nginx: master process /usr/sbin/nginx -g daemon on; master_process on;
www-data     311  0.0  0.1  12908  4544 ?        S    14:11   0:00 nginx: worker process
www-data     312  0.0  0.1  12908  4544 ?        S    14:11   0:00 nginx: worker process
www-data     313  0.0  0.1  12908  4544 ?        S    14:11   0:00 nginx: worker process
www-data     314  0.0  0.1  12908  4480 ?        S    14:11   0:00 nginx: worker process
root        1068  0.0  0.1  10372  4124 ?        Ss   14:25   0:00 nginx: master process nginx -g daemon off;
message+    1139  0.0  0.0  10836  3052 ?        S    14:25   0:00 nginx: worker process
message+    1140  0.0  0.0  10836  3168 ?        S    14:25   0:00 nginx: worker process
message+    1141  0.0  0.0  10836  3172 ?        S    14:25   0:00 nginx: worker process
message+    1142  0.0  0.0  10836  2800 ?        S    14:25   0:00 nginx: worker process
affanli+    1870  0.0  0.0   4096  2100 pts/2    S+   14:44   0:00 grep --color=auto nginx
affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/day3/docker/debug-site$


7. Check Container Details

affanlinux@DESKTOP-INM25AC:~/phase-2-junior-devops/day3/docker/debug-site$ docker inspect debug | grep -A5 "State"
        "State": {
            "Status": "running",
            "Running": true,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
a


✅ Validation Results
Validation Check	Command	Result	Status
Image built	docker images | grep debug-site	✅ Image exists	PASS
Container running	docker ps | grep debug	✅ Up (healthy)	PASS
Port mapping	docker port debug	✅ 8080→80	PASS
HTTP response	curl -s -o /dev/null -w "%{http_code}"	✅ 200	PASS
Logs clean	docker logs debug --tail 10	✅ No errors	PASS
Inside container	docker exec debug cat /usr/share/nginx/html/index.html	✅ File exists	PASS
Nginx running	docker exec debug ps aux | grep nginx	✅ Running	PASS
🐛 Issues Encountered
Issue 1: Directory Not Found
Symptom:

bash
$ cd ~/phase-2-junior-devops/docker/debug-site
-bash: cd: /home/affanlinux/phase-2-junior-devops/docker/debug-site: No such file or directory
Root Cause: The directory was not created before trying to navigate to it.

Fix Applied:

bash
mkdir -p ~/phase-2-junior-devops/docker/debug-site
Issue 2: Image Not Found
Symptom:

bash
$ docker run -d --name debug -p 8080:80 debug-site:1.0
Unable to find image 'debug-site:1.0' locally
docker: Error response from daemon: pull access denied for debug-site
Root Cause: Trying to run a container from an image that hasn't been built yet.

Fix Applied:

bash
docker build -t debug-site:1.0 .
docker run -d --name debug -p 8080:80 debug-site:1.0
Issue 3: Port Already in Use (Potential)
Symptom:

text
docker: Error response from daemon: Bind for 0.0.0.0:8080 failed: port is already allocated.
Root Cause: Another container is already using port 8080.

Fix Applied:

bash
# Option 1: Use a different port
docker run -d --name debug -p 8081:80 debug-site:1.0

# Option 2: Stop the conflicting container
docker ps | grep 8080
docker stop <conflicting-container>
docker run -d --name debug -p 8080:80 debug-site:1.0
🔍 Root Cause Analysis
Issue 1: Directory Not Found
Technical Explanation: In Linux, you cannot cd into a directory that doesn't exist. You must create it first with mkdir -p.

Issue 2: Image Not Found
Technical Explanation: docker run requires an existing image. The image must be built with docker build before you can run it.

Issue 3: Port Already in Use
Technical Explanation: A host port can only be mapped to one container at a time. If another container is using port 8080, Docker cannot map another container to the same port.

💼 What I Would Check in a Real Job
If Container Not Running:
docker ps -a - Check if container exists

docker logs <container> - Check error messages

docker inspect <container> - Check container details

If App Not Reachable:
docker ps - Is container running?

docker port <container> - Is port mapping correct?

curl -v localhost:port - What error does it give?

docker exec <container> curl localhost - Can app be reached internally?

If Health Check Failing:
docker inspect <container> --format='{{.State.Health.Status}}' - Check status

docker inspect <container> --format='{{.State.Health.Log}}' - Check health logs

Verify the health check command works inside the container

🗣️ 60-Second Interview Answer
"When I debug a container, I follow a systematic 5-step process:

docker ps - Is the container running?

docker logs - What does the output say?

docker port - Is the port mapped correctly?

curl - Can I reach the app?

docker exec - What's happening inside?

Most issues are either the container isn't running, logs show an error, or the port mapping is wrong. This process always helps me find the problem quickly."

✅ Daily Quiz Answers
1. What does -p 8080:80 do?
Answer: Maps host port 8080 to container port 80. Traffic to localhost:8080 goes to the container's port 80.

2. How do you view container logs?
Answer: docker logs <container-name> shows all output from the container.

3. A container is running but you can't access it. What do you check?
Answer:

docker port <container> - Check port mapping

curl -v localhost:port - Check connection

docker logs <container> - Check for errors

docker exec <container> curl localhost - Check internal access

4. What is the purpose of docker exec?
Answer: docker exec lets you run commands inside a running container, useful for debugging.

5. What causes "port is already allocated" error?
Answer: Another container is already using the same host port. You need to stop that container or use a different port.

✅ Lessons Learned
docker logs is your best friend for debugging

Always check port mapping with docker port

docker exec lets you explore inside the container

Be systematic when troubleshooting

Port conflicts are common - use different ports

Build images before trying to run them

📂 Files Created Today
File	Location
index.html	docker/debug-site/index.html
Dockerfile	docker/debug-site/Dockerfile
Day 3 Report	days/day03/day03-ports-logs-debugging.md

