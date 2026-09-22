# Day 20 – DevOps Capstone Build

## 📋 Objective
Build a complete automated DevOps pipeline for ShopEasy using Docker, Bash, Terraform, Ansible, and AWS EC2.

---

## 🔧 Tools Used
| Tool | Purpose |
|------|---------|
| Docker | Containerize the website |
| Docker Compose | Run multiple containers |
| Bash | Health check + backup scripts |
| Terraform | Create AWS infrastructure |
| Ansible | Configure the EC2 server |
| AWS EC2 | Cloud server |

---

## 📁 Architecture
User Browser
↓
http://51.21.249.213
↓
AWS Security Group (port 80)
↓
EC2 Instance (Ubuntu)
↓
Docker Engine
↓
nginx Container (ShopEasy website)

text

---

## 🔧 Commands Used

### Local Docker
```bash
cd docker
docker-compose -f compose.yaml build
docker-compose -f compose.yaml up -d
docker-compose -f compose.yaml ps
curl http://localhost:8080
Bash Scripts
bash
./scripts/healthcheck.sh
./scripts/backup.sh
Terraform
bash
cd terraform
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform output
Ansible
bash
cd ansible
ansible -i inventory.ini web -m ping
ansible-playbook -i inventory.ini playbook.yml
📊 Validation Results
Check	Result
ShopEasy website (local)	✅
3 containers running (web + db + cache)	✅
Health check script	✅
Backup script	✅
Terraform creates EC2	✅
Ansible ping works	✅
Ansible playbook runs	✅
Website live on AWS	✅
🐛 Issues Encountered
Issue 1: docker_container module failed
Symptom: Not supported URL scheme http+docker
Fix: Used shell: docker run instead of the docker_container module.

Issue 2: Default nginx page shown
Symptom: Browser showed "Welcome to nginx!" instead of ShopEasy
Fix: Copied index.html to EC2 and mounted it with -v.

Issue 3: Invalid AWS credentials
Symptom: InvalidClientTokenId
Fix: Created new IAM user and access keys, ran aws configure.

💼 What I Would Check in a Real Job
Is the website accessible? → curl http://<IP>

Is the container running? → docker ps

Is Terraform state clean? → terraform state list

Was cleanup done? → terraform destroy

🗣️ 60-Second Interview Answer
"I built a complete DevOps pipeline for ShopEasy. I containerized the website with Docker, wrote Bash scripts for health checks and backups, used Terraform to create the AWS EC2 server, and Ansible to install Docker and deploy the website. The site was live on AWS at the public IP. Finally, I cleaned up with terraform destroy."

✅ Lessons Learned
Terraform creates infrastructure

Ansible configures the server

Docker runs the application

Bash scripts automate monitoring

Combining tools creates full automation

Always clean up with terraform destroy


