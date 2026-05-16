# 🚀 Launching a Free Tier AWS EC2 Instance

Follow either **Method 1** to spin up an instance using the point-and-click AWS Web Console, or **Method 2** to automate it using Terraform.

---

## 🖥️ Method 1: Via the AWS Web Console

### Step 1: Navigate to EC2
1. Log into your [AWS Management Console](https://aws.amazon.com/console/).
2. In the top search bar, type **EC2** and select the EC2 service.
3. Click the orange **"Launch instance"** button.

### Step 2: Name and Operating System
1. **Name:** Give your server a name (e.g., `my-cloud-terminal`).
2. **Application and OS Images (AMI):** Click on **Ubuntu**. 
3. Ensure the dropdown says **Ubuntu Server 24.04 LTS (HVM), SSD Volume Type** and has the sub-text **"Free tier eligible"**.

### Step 3: Instance Type & Key Pair
1. **Instance type:** Select **`t2.micro`** (or `t3.micro` if you are in a region like Ohio/N. Virginia where t3 is the Free Tier standard). Look for the **"Free tier eligible"** green text.
2. **Key pair (login):** Click **"Create new key pair"**.
   * **Key pair name:** `my-ec2-key`
   * **Key pair type:** RSA
   * **Private key file format:** `.pem`
   * Click **Create key pair**. *Your browser will automatically download `my-ec2-key.pem`. Keep this safe!*

### Step 4: Network & Firewall Settings
1. Under **Network settings**, make sure **"Create security group"** is selected.
2. Ensure **"Allow SSH traffic from"** is checked.
3. Change the dropdown next to SSH from `Anywhere (0.0.0.0/0)` to **`My IP`**. *(This locks down your instance so only your laptop can access it, which is highly recommended for security).*

### Step 5: Launch!
1. Leave the storage defaults at 1x 8GiB gp3 volume (Free tier allows up to 30GiB).
2. Click **"Launch instance"** on the right side panel.
3. Wait about 1-2 minutes, go to your **Instances** list, and find your instance's **Public IPv4 address**.

---

## 🛠️ Method 2: Via Terraform (Infrastructure as Code)

If you prefer to automate your infrastructure, you can use Terraform. This script will automatically find the latest Ubuntu Free Tier AMI, generate a security group that allows SSH from anywhere (or your IP), and create the server.

### Step 1: Initialize your Configuration Folder
Create a clean directory on your local machine and create a file named `main.tf`:

```hcl
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

```

### Step 2: Deploy with Terraform Commands

1. **Pre-requisite:** You must create your keypair (`my-ec2-key`) in the AWS Web Console first so AWS has it on file, then place it in your local `~/.ssh/` directory as detailed in the previous guide.
2. Initialize the folder to download the AWS provider:
```bash
terraform init

```


3. Preview what Terraform will build:
```bash
terraform plan

```


4. Build the infrastructure:
```bash
terraform apply

```


*(Type `yes` when prompted).*

Once the command finishes, Terraform will print out your `instance_public_ip` directly in the terminal window. You are now ready to establish your `.pem` file permissions and copy your dotfiles over!

```

***

Both methods result in the exact same outcome: a fresh, clean Ubuntu machine running in the AWS cloud. For your very first setup, doing it via the **Console** is highly recommended so you can physically see how the components (VPC, Security Groups, Key Pairs) snap together!

```
