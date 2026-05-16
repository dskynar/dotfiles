# main.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# 1. Configure the AWS Provider (Change region if needed)
provider "aws" {
  region = "us-east-1" 
}

# 2. Automatically look up the latest Ubuntu Free-Tier AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-noble-24.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical (Ubuntu owner ID)
}

# 3. Create a Security Group to allow SSH traffic
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh_traffic"
  description = "Allow inbound SSH traffic"

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Change to ["YOUR_IP/32"] for better security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 4. Deploy the Free-Tier EC2 Instance
resource "aws_instance" "my_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro" # Free Tier Eligible

  # Link the .pem key you generated manually in the console
  key_name      = "my-ec2-key" 

  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "my-cloud-terminal"
  }
}

# 5. Output the Public IP address automatically when done
output "instance_public_ip" {
  value       = aws_instance.my_server.public_ip
  description = "The public IP address of your new cloud server"
}

