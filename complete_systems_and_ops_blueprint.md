
# 🚀 Complete Systems & Ops Blueprint

## 📁 Repository & Folder Structures

### 1. Dotfiles Repository (`~/Projects/Personal/dotfiles`)

```text
~/Projects/Personal/dotfiles/
├── bash/
│   └── .bashrc                 # Custom functions, dot* and gen* helpers
├── vim/
│   └── .vimrc                  # Lean, portable Vim configuration
├── git/
│   ├── .gitconfig              # Universal Git config
│   └── .gitignore              # Global git ignore rules
├── tmux/
│   └── .config/tmux/tmux.conf  # Portable Tmux layout and hotkeys
└── DevOps/
    ├── README.md               # Infrastructure & SSH setup guide
    ├── AWS_Keypair_Runbook.md  # Manual AWS SSH Key import runbook
    └── terraform/
        └── main.tf             # Generic multi-profile EC2 Terraform code

```

### 2. Obsidian Vault Repository (`~/Projects/Personal/My_Unified_Vault`)

```text
~/Projects/Personal/My_Unified_Vault/
├── 00_Private_Notes            # Symbolic link to private repository for private laptop
├── 01_General                  # General non-sensitive Obsidian notes
    └── .obsidian                   # Obsidian config files
    ├── .gitignore                  # Embedded Git repository
    ├── 1_Inbox/                    # Templates, asset attachments, internal scripts
    ├── 2_Input/                    # Unprocessed ideas and raw notes
    ├── 3_Journal/                  # Atomic Zettelkasten knowledge base
    ├── 4_Output/                   # Output of 
    ├── 5_Zettelkasten/             # Atomic Zettelkasten knowledge base
    ├── 6_Publish/                  # Public-facing Markdown articles mirrored to Quartz
        └── index.md                # Homepage for your blog
```

---

## 🛠️ Step 1: Shell Configuration & Helper Functions

Add the following block to `~/Projects/Personal/dotfiles/bash/.bashrc` to manage both repos with safe rebasing and directory protection:

```bash
# ==============================================================================
# 1. Dotfiles Git Management Shortcuts
# ==============================================================================
alias dotgit="git --git-dir=$HOME/Projects/Personal/dotfiles/.git --work-tree=$HOME/Projects/Personal/dotfiles"
alias dotcd="cd $HOME/Projects/Personal/dotfiles"
alias back="cd -"
alias dotst="dotgit status"
alias dotpull="dotgit pull --rebase --autostash origin main"

dotpush() {
    local msg="${1:-Update dotfiles}"
    echo "--> Checking remote updates..."
    dotgit pull --rebase --autostash origin main || { echo "Pull failed. Fix conflicts first."; return 1; }
    echo "--> Staging changes..."
    dotgit add -A
    if dotgit diff-index --quiet HEAD --; then
        echo "--> No changes to commit."
    else
        echo "--> Committing: '$msg'"
        dotgit commit -m "$msg"
    fi
    echo "--> Pushing to personal GitHub..."
    dotgit push
}

dotedit() {
    pushd $HOME/Projects/Personal/dotfiles > /dev/null || return
    if [ -z "$1" ]; then vim .; else vim "$1"; fi
    popd > /dev/null || return
}

# ==============================================================================
# 2. Obsidian Vault Git Management Shortcuts
# ==============================================================================
alias gengit="git --git-dir=$HOME/Projects/Personal/My_Unified_Vault/.git --work-tree=$HOME/Projects/Personal/My_Unified_Vault"
alias gencd="cd $HOME/Projects/Personal/My_Unified_Vault"
alias genst="gengit status"
alias genpull="gengit pull --rebase --autostash origin main"

genpush() {
    local msg="${1:-Update vault}"
    echo "--> Checking remote updates..."
    gengit pull --rebase --autostash origin main || { echo "Pull failed. Fix conflicts first."; return 1; }
    echo "--> Staging changes..."
    gengit add -A
    if gengit diff-index --quiet HEAD --; then
        echo "--> No changes to commit."
    else
        echo "--> Committing: '$msg'"
        gengit commit -m "$msg"
    fi
    echo "--> Pushing to personal GitHub..."
    gengit push
}

genedit() {
    pushd $HOME/Projects/Personal/My_Unified_Vault > /dev/null || return
    if [ -z "$1" ]; then vim .; else vim "$1"; fi
    popd > /dev/null || return
}

```

---

## 🔐 Step 2: Machine Key Pairs - AWS & Github Setup

### 1. Prerequisites & Base System Setup

Install base developer utilities and create required configuration directories:

```bash
# --- Install Xcode Command Line Tools, Homebrew, and AWS CLI v2 ---
xcode-select --install

/bin/bash -c "$(curl -fsSL [https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh](https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh))"

# Add Homebrew to PATH for the current session (Apple Silicon Mac)
eval "$(/opt/homebrew/bin/brew shellenv)"

brew install awscli
aws --version

# --- Create required configuration directories ---
mkdir -p ~/.ssh
mkdir -p ~/.aws
chmod 700 ~/.ssh

```

---

### 2. Configure AWS SSO Profiles (`~/.aws/config`)

Populate `~/.aws/config` to establish isolated session boundaries for Cloudera and Personal AWS accounts, after adjusting `sso_account_id` for each profile:

```ini
# ==============================================================================
# CLOUDERA WORK ENVIRONMENT
# ==============================================================================
[sso-session cloudera-sso]
sso_start_url = [https://d-lllllllll.awsapps.com/start#/](https://d-lllllllll.awsapps.com/start#/)
sso_region = us-east-1
sso_registration_scopes = sso:account:access

[profile login]
sso_session = cloudera-sso
sso_account_id = xxxxxxxx
sso_role_name = cldr_poweruser
region = us-east-1

[profile sso-sandbox]
sso_session = cloudera-sso
sso_account_id = yyyyyyyyyy
sso_role_name = cldr_poweruser
region = us-east-1

[profile marketing-emea1]
sso_session = cloudera-sso
sso_account_id = 9999999999999
sso_role_name = cldr_poweruser
region = us-east-1

# ==============================================================================
# PERSONAL ENVIRONMENT
# ==============================================================================
[sso-session personal-sso]
sso_start_url = [https://d-xxxxxxxxxx.awsapps.com/start#/](https://d-xxxxxxxxxx.awsapps.com/start#/)
sso_region = eu-central-1
sso_registration_scopes = sso:account:access

[profile personal-admin]
sso_session = personal-sso
sso_account_id = zzzzzzzzzzzz
sso_role_name = AdministratorAccess
region = eu-central-1

# ==============================================================================
# GLOBAL FALLBACK
# ==============================================================================
[default]
region = eu-central-1

```

Authenticate your personal AWS SSO session:

```bash
# Log into personal AWS SSO session
aws sso login --profile personal-admin

# Verify active identity
aws sts get-caller-identity --profile personal-admin

```

Authenticate your Cloudera AWS SSO session:

```bash
# Log into Cloudera AWS SSO session
aws sso login --profile sso-sandbox

# Verify active identity
aws sts get-caller-identity --profile sso-sandbox

```

---

### 3. Generate Machine Ed25519 Key Pairs

Run once per physical machine to generate unique, secure Ed25519 identity keys for AWS and GitHub access:

```bash
# --- Personal AWS Key ---
# On Mac:
ssh-keygen -t ed25519 -C "macbook-personal-aws" -f ~/.ssh/id_ed25519_aws_personal
ssh-keygen -t ed25519 -C "macbook-cloudera-aws" -f ~/.ssh/id_ed25519_aws_work

# On Ubuntu:
ssh-keygen -t ed25519 -C "ubuntu-personal-aws" -f ~/.ssh/id_ed25519_aws_personal

# --- Personal GitHub Key ---
ssh-keygen -t ed25519 -C "macbook-personal-github" -f ~/.ssh/id_ed25519_personal

# --- Work GitHub Key (Cloudera) ---
ssh-keygen -t ed25519 -C "macbook-work-github" -f ~/.ssh/id_ed25519_work

```

---

### 4. Import Public Keys to AWS

Import your local public key into your personal AWS account via the CLI:

```bash
# On Mac:
aws ec2 import-key-pair \
  --key-name "macbook-personal-key" \
  --public-key-material fileb://~/.ssh/id_ed25519_aws_personal.pub \
  --profile personal-admin \
  --region eu-central-1

# On Ubuntu:
aws ec2 import-key-pair \
  --key-name "ubuntu-personal-key" \
  --public-key-material fileb://~/.ssh/id_ed25519_aws_personal.pub \
  --profile personal-admin \
  --region eu-central-1

```

---

### 5. Register Public Keys with GitHub

Print the public keys and copy/paste them into the corresponding GitHub web interfaces:

#### Personal GitHub (`github.com`)

1. Output public key content:
```bash
cat ~/.ssh/id_ed25519_personal.pub

```


2. Navigate to **GitHub.com $\rightarrow$ Settings $\rightarrow$ SSH and GPG keys $\rightarrow$ New SSH key**.
3. Name it descriptively (e.g., `MacBook Personal Key`) and paste the key.

#### Work GitHub (`github.infra.cloudera.com`)

1. Output public key content:
```bash
cat ~/.ssh/id_ed25519_work.pub

```


2. Navigate to **Cloudera Enterprise GitHub $\rightarrow$ Settings $\rightarrow$ SSH and GPG keys $\rightarrow$ New SSH key**.
3. Name it descriptively (e.g., `Cloudera MacBook Work Key`) and paste the key.

---

### 6. Configure Local SSH Host Mappings (`~/.ssh/config`)

Create and populate `~/.ssh/config` to automate key selection and host alias mapping:

```ssh
# Personal GitHub account
Host github-personal
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_personal
  IdentitiesOnly yes

# Work GitHub account
Host github-work
  HostName github.infra.cloudera.com
  User git
  IdentityFile ~/.ssh/id_ed25519_work
  IdentitiesOnly yes

# Connect to EC2 instances (Cloudera Sandbox)
Host sand-hol*
  User ec2-user
  IdentityFile ~/.ssh/dskynar-sandbox-eu-west-xxxx.pem
  IdentitiesOnly yes

# Connect to EC2 instances (Cloudera EMEA Marketing)
Host mark-hol*
  User ec2-user
  IdentityFile ~/.ssh/sky-hol-aws-key-pair-marketing-emea1-xxx.pem
  IdentitiesOnly yes

```

---

### 7. Set File Permissions, Load Keys, and Verify Connections

Secure permissions, store key passphrases in the macOS Keychain, and verify host connections:

```bash
# Secure SSH directory and config permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/id_ed25519*

# Add keys to macOS Keychain (run on Mac)
ssh-add --apple-use-keychain ~/.ssh/id_ed25519_personal
ssh-add --apple-use-keychain ~/.ssh/id_ed25519_work
ssh-add --apple-use-keychain ~/.ssh/id_ed25519_aws_personal
ssh-add --apple-use-keychain ~/.ssh/id_ed25519_aws_work

# --- Verify SSH Connections via defined host aliases ---
ssh -T git@github-personal
ssh -T git@github-work

```
---

## ⚡ Step 3: Generic Infrastructure Provisioning (`main.tf`)

Save this complete file to `~/Projects/Personal/dotfiles/DevOps/terraform/main.tf`:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "aws_profile" {
  type        = string
  description = "AWS CLI SSO Profile name"
}

variable "aws_region" {
  type        = string
  default     = "eu-central-1"
  description = "Target AWS Region"
}

variable "my_ip" {
  type        = string
  description = "Local IP address with CIDR mask (e.g., 192.0.2.1/32)"
}

variable "key_name" {
  type        = string
  description = "Target AWS Key Pair name"
}

variable "instance_name" {
  type        = string
  default     = "cloud-terminal"
  description = "EC2 Instance Tag Name"
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

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
  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "allow_ssh" {
  name        = "${var.instance_name}-allow-ssh"
  description = "Allow inbound SSH access from restricted local IP"

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = var.instance_name
  }
}

output "instance_public_ip" {
  value       = aws_instance.my_server.public_ip
  description = "Public IP address of the newly provisioned instance"
}

```

### Execution Command:

```bash
MY_PUBLIC_IP="$(curl -s https://checkip.amazonaws.com)/32"

aws sso login --profile AdministratorAccess-101260246565

terraform init
terraform apply \
  -var="aws_profile=AdministratorAccess-101260246565" \
  -var="aws_region=eu-central-1" \
  -var="my_ip=$MY_PUBLIC_IP" \
  -var="key_name=macbook-personal-key" \
  -var="instance_name=personal-cloud-terminal"

```

---

## 🌐 Step 4: Host Isolation & SSH Agent Forwarding

### 1. Local Machine (`~/.ssh/config`)

Configure agent forwarding locally so your private keys stay on hardware while enabling remote GitHub authentication:

```ssh
# Personal EC2 Instance
Host personal-ec2
  HostName <PERSONAL_EC2_PUBLIC_IP>
  User ubuntu
  IdentityFile ~/.ssh/id_ed25519_aws_personal
  ForwardAgent yes
  IdentitiesOnly yes

# Cloudera EC2 Instance
Host sky-hol*
  User ec2-user
  IdentityFile ~/.ssh/dskynar-sandbox-eu-west-xxx.pem
  ForwardAgent yes
  IdentitiesOnly yes

```

### 2. Isolated Remote SSH Configurations

#### On Personal EC2 (`~/.ssh/config`):

```ssh
Host github-personal
  HostName github.com
  User git
  StrictHostKeyChecking no

```

#### On Cloudera EC2 (`~/.ssh/config`):

```ssh
Host github-work
  HostName github.infra.cloudera.com
  User git
  StrictHostKeyChecking no

```

---

## 📰 Step 5: Quartz & GitHub Pages Automated Publishing Pipeline

Publishing automatically builds your Markdown files whenever `genpush` pushes changes to GitHub.

### 1. Fork & Prepare Quartz

1. Go to **[jackyzha0/quartz](https://github.com/jackyzha0/quartz)** on GitHub and click **Fork**.
2. Name the forked repository `quartz-blog` in your personal GitHub account.
3. In GitHub, go to your repository **Settings** $\rightarrow$ **Pages** $\rightarrow$ under **Source**, select **GitHub Actions**.

### 2. Configure Obsidian Vault Directory Structure

Inside your local vault (`~/Projects/Personal/My_Unified_Vault`), create a designated publication folder:

```bash
mkdir -p ~/Projects/Personal/My_Unified_Vault/30-Publish

```

Create an entry page at `~/Projects/Personal/My_Unified_Vault/30-Publish/index.md`:

```markdown
---
title: Welcome to My Technical Garden
---

# Technical Notes & Engineering Log

Welcome! This site hosts my synthesized Zettelkasten notes on Cloud Engineering, Infrastructure-as-Code, and Systems Security.

## Featured Notes
* [[Securing Cloud Workspaces with SSH Agent Forwarding]]

```

### 3. Setup Automated GitHub Action Sync

In your **`quartz-blog`** GitHub repository, add or replace `.github/workflows/deploy.yml` with this workflow:

```yaml
name: Deploy Quartz Site to GitHub Pages

on:
  push:
    branches:
      - main

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Quartz Engine
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Checkout Vault Content
        uses: actions/checkout@v4
        with:
          repository: 'dskynar/My_Unified_Vault'
          path: 'content'
          token: ${{ secrets.GH_PAT }}

      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: 20

      - name: Install Dependencies
        run: npm ci

      - name: Build Quartz Site
        run: npx quartz build -d content/30-Publish

      - name: Upload Artifacts
        uses: actions/upload-pages-artifact@v3
        with:
          path: public

  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4

```

*(Note: Add a Personal Access Token with repository read scope to your `quartz-blog` repository secrets as `GH_PAT` so GitHub Actions can pull your private vault content).*

---

## 🔄 Step 6: Daily Production Workflow Loop

```text
1. Start Working Session:
   $ dotst && dotpull
   $ genst && genpull

2. Create/Refine Content:
   - Edit system scripts using `dotedit` or `genedit` in Tmux/Vim.
   - Write articles/notes in Obsidian under `30-Publish/`.

3. Synchronize Everything:
   $ dotpush "Updated DevOps runbooks"
   $ genpush "Published article on AWS SSH boundaries"

4. Automated Result:
   - Dotfiles update instantly across local and EC2 instances.
   - GitHub Actions picks up vault changes and deploys the new blog post live to GitHub Pages within 60 seconds.

```
