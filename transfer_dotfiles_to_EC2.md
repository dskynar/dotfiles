# ☁️ Deploying Dotfiles to an AWS EC2 Instance via SSH

Follow these instructions to securely copy your dotfiles from your local machine to a remote AWS EC2 instance and activate your environment.

### Prerequisites
* You must have your AWS EC2 private key file (`.pem` or `.cer`).
* You need the Public IP address (or Public DNS) of your EC2 instance.
* Your EC2 security group must allow inbound traffic on **Port 22 (SSH)** from your IP address.

---

### Step 1: Secure Your EC2 Private Key
Before using your AWS private key, the local system requires you to restrict its permissions, or the SSH connection will be rejected for security reasons.
```bash
chmod 400 /path/to/your-key.pem

```

### Step 2: Copy the Dotfiles Folder via `scp`

Use `scp` to recursively copy your entire `~/dotfiles` directory from your local laptop up to the default home directory of your remote EC2 user.

Replace `ubuntu` with the default username of your EC2 operating system image if you aren't using Ubuntu (e.g., `ec2-user` for Amazon Linux, `admin` for Debian).

```bash
scp -i /path/to/your-key.pem -r ~/dotfiles ubuntu@YOUR_EC2_PUBLIC_IP:~/dotfiles

```
or better
```bash
rsync -avz -e "ssh -i /path/to/your-key.pem" --exclude='.git' ~/dotfiles/ ubuntu@YOUR_EC2_PUBLIC_IP:~/dotfiles

```

### Step 3: SSH into your EC2 Instance

Log into your remote server to finalize the configuration:

```bash
ssh -i /path/to/your-key.pem ubuntu@YOUR_EC2_PUBLIC_IP

```
check the diff between them:
```bash
sdiff -s ~/dotfiles/.bashrc ~/.bashrc

```
### Step 4: Back Up and Symlink on the EC2 Instance

Once inside the EC2 instance terminal, execute your backup and linking routine exactly like a normal Linux laptop setup, see [README.md](https://github.com/dskynar/dotfiles/blob/main/README.md)


This covers both bases—pushing files physically from your computer via `scp`, or pulling them down via Git once you are connected to the cloud server!

```
