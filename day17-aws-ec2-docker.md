📝 Day 17 – AWS EC2 Hands-On (Complete Report)
📋 Objective
Launch an EC2 instance, connect to it, install Docker, run a container, and deploy a live website.

📚 Textbook Chapters Studied
Chapter 10 – AWS EC2, Security Groups, and SSH

🎯 Theory Summary (In My Own Words)
What is AWS EC2?
EC2 (Elastic Compute Cloud) is a virtual machine in AWS. It allows you to rent a server in the cloud.

What I Used:
Item	Value
AMI	Ubuntu 26.04 LTS
Instance type	t3.micro (free tier eligible)
Region	Europe (Stockholm)
Security Group	Allow SSH (22) and HTTP (80)
🔧 Lab Environment
AWS Region: Europe (Stockholm) – eu-north-1

Instance Type: t3.micro

AMI: Ubuntu 26.04 LTS

Shell: Bash (via EC2 Instance Connect)

📝 Commands Used
Step 1: Install Docker
bash
sudo apt update -y
sudo apt install docker.io -y
Step 2: Start Docker
bash
sudo systemctl start docker
sudo systemctl enable docker
Step 3: Add user to docker group
bash
sudo usermod -aG docker ubuntu
Step 4: Run nginx container
bash
sudo docker run -d --name my-web -p 80:80 nginx
Step 5: Verify
bash
sudo docker ps
📊 Important Output Evidence
Docker Status
text
● docker.service - Docker Application Container Engine
     Active: active (running)
Running Container
text
CONTAINER ID   IMAGE   COMMAND                  STATUS         PORTS                  NAMES
08af2403dba3   nginx   "/docker-entrypoint.…"   Up 20 seconds  0.0.0.0:80->80/tcp     my-web
Browser Output
text
Welcome to nginx!

If you see this page, nginx is successfully installed and working.
✅ Validation Result
Check	Result	Status
EC2 instance launched	✅ Running	PASS
Connected to EC2	✅ Yes	PASS
Docker installed	✅ Yes	PASS
Docker running	✅ Active	PASS
nginx container running	✅ Up	PASS
Website accessible	✅ Yes	PASS
🐛 Issues Encountered
Issue 1: Could Not Connect via SSH (No .pem file)
Symptom: Permission denied (publickey)
Root Cause: The key pair .pem file was not downloaded when launching the instance.
Fix Applied: Used EC2 Instance Connect (browser-based) instead of SSH.

Issue 2: Website Not Reachable
Symptom: ERR_CONNECTION_TIMED_OUT
Root Cause: Security Group did not allow HTTP (port 80).
Fix Applied: Added inbound rule for HTTP (port 80) from 0.0.0.0/0.

💼 What I Would Check in a Real Job
Is the EC2 instance running? → EC2 Dashboard → Instances

Is Docker running? → sudo systemctl status docker

Is the container running? → sudo docker ps

Is port 80 open? → Security Group inbound rules

Is the website reachable? → curl http://<PUBLIC-IP>

🗣️ 60-Second Interview Answer
"I launched an EC2 instance on AWS, connected using EC2 Instance Connect, installed Docker, and ran an nginx container. The website is live at the public IP. I configured the Security Group to allow HTTP traffic."

✅ Lessons Learned
EC2 is a virtual machine in AWS

Security Groups act as firewalls

Docker can be installed on EC2

EC2 Instance Connect works without a .pem file

Port 80 must be opened in Security Group for web traffic


