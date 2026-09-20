📋 Objective
Learn Infrastructure as Code with Terraform and create AWS resources automatically.

📚 Textbook Chapters Studied
Chapter 11 – Terraform Infrastructure as Code

🎯 Theory Summary (In My Own Words)
Terraform is Infrastructure as Code. Instead of clicking in AWS Console, I write a file and Terraform creates everything. One command creates the server, and one command destroys it.

🔧 Lab Environment
OS: Ubuntu 22.04 (WSL2)

Terraform Version: 1.9.x

AWS Region: eu-north-1 (Stockholm)

📁 Files Created
terraform/main.tf
hcl
provider "aws" {
  region = "eu-north-1"
}

resource "aws_security_group" "web_sg" {
  name        = "terraform-web-sg"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0aba19e56f3eaec05"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "Terraform-Web-Server"
  }
}

output "instance_ip" {
  value = aws_instance.web.public_ip
}
🔧 Commands Used
bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform output
terraform destroy
📊 Important Output Evidence
Terraform Apply Output
text
Plan: 2 to add, 0 to change, 0 to destroy.
aws_instance.web: Creating...
aws_instance.web: Creation complete after 21s

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:
instance_ip = "51.20.190.26"
Browser Test
text
http://51.20.190.26 → "This site can't be reached"
✅ Expected — server is empty (no software installed yet)

AWS Console Verification
text
Name: Terraform-Web-Server
Instance ID: i-094e45abfe4de5456
State: Running
Instance type: t3.micro
Status check: 3/3 passed
✅ Validation Result
Check	Result	Status
Terraform installed	✅	PASS
main.tf created	✅	PASS
terraform init	✅	PASS
terraform plan	✅	PASS
terraform apply	✅	PASS
EC2 created	✅	PASS
terraform destroy	✅	PASS
🐛 Issues Encountered
Issue 1: Invalid AWS Credentials
Symptom: InvalidClientTokenId: The security token included in the request is invalid
Root Cause: AWS credentials not configured or incorrect.
Fix: Created IAM user, generated access key, ran aws configure.

Issue 2: SignatureDoesNotMatch
Symptom: SignatureDoesNotMatch: The request signature we calculated does not match
Root Cause: Wrong secret key paired with access key.
Fix: Created new access key with matching secret.

💼 What I Would Check in a Real Job
Are AWS credentials valid? → aws sts get-caller-identity

Is Terraform initialized? → terraform init

Is the plan correct? → terraform plan

Are resources created? → AWS Console or terraform state list

Cleanup done? → terraform destroy

🗣️ 60-Second Interview Answer
"I use Terraform to create AWS infrastructure as code. I write main.tf to define resources like EC2 and Security Groups, then run terraform plan to preview and terraform apply to create them. When done, I run terraform destroy to clean up."

✅ Lessons Learned
Terraform creates infrastructure from code

Always use terraform plan before apply

terraform destroy removes everything

Terraform only creates servers — doesn't install software

Idempotency: running apply again doesn't duplicate resources
