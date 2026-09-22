provider "aws" {
  region = "eu-north-1"
}

resource "aws_security_group" "shopeasy_sg" {
  name        = "shopeasy-sg"
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

resource "aws_instance" "shopeasy" {
  ami                    = "ami-0aba19e56f3eaec05"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.shopeasy_sg.id]

  tags = {
    Name = "ShopEasy-Capstone"
  }
}

output "instance_ip" {
  value = aws_instance.shopeasy.public_ip
}
