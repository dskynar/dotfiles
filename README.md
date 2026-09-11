# 💻 Dotfiles Startup Kit

A unified environment setup for managing configurations smoothly across **macOS**, **Linux (Ubuntu)**, and **AWS EC2 instances**. 

This repository centralizes configuration files (`.bashrc`, `.vimrc`, `.tmux.conf`, `.gitconfig`) in one place using Git, relying on symbolic links (symlinks) to hook them into your home (`~/`) directory.

---

## 🚀 First-Time Setup on a New Machine

When setting up a brand-new laptop or dropping into a fresh EC2 instance, follow these steps to deploy your environment.

### 1. Install Prerequisites & Set Default Shell

On macOS, switch your shell to Bash:
```bash
chsh -s /bin/bash

```

Ensure **`tmux`** and **`vim`** are installed:

```bash
# On macOS (via Homebrew)
brew install tmux vim

# On Ubuntu / Debian / EC2
sudo apt update && sudo apt install tmux vim -y

```

### 2. Clone the Repository

Clone the repo into your personal projects folder:

```bash
git clone git@github-personal:dskynar/dotfiles.git ~/Projects/Personal/dotfiles

```

### 3. Back Up Existing Configs (Recommended)

Create copies of active environment files for safety before linking:

```bash
cp ~/.bashrc ~/.bashrc.orig 2>/dev/null || true
cp ~/.vimrc ~/.vimrc.orig 2>/dev/null || true
cp ~/.tmux.conf ~/.tmux.conf.orig 2>/dev/null || true

```

### 4. Create the Symbolic Links

Ensure target directories exist, then create symlinks forcing overwrites:

```bash
# Create target config folder for modern Tmux
mkdir -p ~/.config/tmux

# Apply symbolic links
ln -sf ~/Projects/Personal/dotfiles/bash/.bashrc ~/.bashrc
ln -sf ~/Projects/Personal/dotfiles/vim/.vimrc ~/.vimrc
ln -sf ~/Projects/Personal/dotfiles/git/.gitconfig ~/.gitconfig
ln -sf ~/Projects/Personal/dotfiles/git/.gitignore ~/.gitignore
ln -sf ~/Projects/Personal/dotfiles/tmux/.config/tmux/tmux.conf ~/.config/tmux/tmux.conf

```

### 5. Configure macOS & Linux Login Shells (`.bash_profile`)

macOS Terminal runs every new tab as a *login shell* (looking for `~/.bash_profile`), while Ubuntu uses `~/.profile`.

Create a unified `~/.bash_profile` to handle both environments cleanly:

```bash
cat << 'EOF' > ~/.bash_profile
# Hide macOS Zsh deprecation warning
export BASH_SILENCE_DEPRECATION_WARNING=1

# Load Ubuntu system defaults if present
if [ -f ~/.profile ]; then
    . ~/.profile
fi

# Load shared dotfiles configuration
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
EOF

```

### 6. Verify and Activate Environment

Verify that all symlinks point to the target path:

```bash
ls -la ~ | grep '\->'

```

Activate the environment in your current terminal:

```bash
source ~/.bashrc

```

---

## 🖥️ Tmux Integration & Cheat Sheet

Tmux maintains terminal state across SSH disconnects and allows split terminal panes.

### Starting and Attaching

* **Start a named session:** `tmux new -s work`
* **Detach from session:** Press `Ctrl+b`, then `d`
* **List active sessions:** `tmux ls`
* **Re-attach to session (e.g., after SSH drop):** `tmux attach -t work`

### Essential Keybindings (Default Prefix: `Ctrl+b`)

* **Horizontal Split:** `Ctrl+b` then `"`
* **Vertical Split:** `Ctrl+b` then `%`
* **Switch Panes:** `Ctrl+b` then `Arrow Keys`
* **Toggle Pane Fullscreen:** `Ctrl+b` then `z`
* **Copy Mode (Scroll history):** `Ctrl+b` then `[` (Use `q` to exit)
* **More Commands:  [tmuxcheatsheet](https://tmuxcheatsheet.com)
---

## 🛠️ Modifying & Syncing Changes

You don't need to navigate away from your working directories to update your dotfiles. Custom commands in `.bashrc` handle navigation and repository operations globally:

### Navigation & Helper Aliases

* **`dotcd`**: Jump directly to `~/Projects/Personal/dotfiles`
* **`back`**: Return to your previous working directory (`cd -`)
* **`dotedit <file>`**: Opens a specific dotfile in Vim and returns you to your current working directory upon exiting.

### Remote Synchronization

To pull updates, stage changes, commit, and push in a single safe workflow (including autostashing local changes), run:

```bash
dotpush "Optional commit message"

```

To run individual Git operations on the repository without leaving your current folder:

```bash
dotst     # Runs git status
dotpull   # Runs git pull --rebase --autostash
dotgit    # Alias for running custom git operations (e.g., dotgit diff)

```

---

## 🆘 Troubleshooting

### 📋 Remote Clipboard Copying inside Tmux

If yanked text inside `tmux` or Vim over SSH does not paste into your laptop's clipboard, verify that `set -s set-clipboard on` is present in `~/.config/tmux/tmux.conf`, and ensure your terminal emulator supports **OSC 52** clipboard passthrough.

### 🐧 Missing Vim Syntax Highlighting on Ubuntu

Ubuntu ships with `vim-tiny` by default. Upgrade to full Vim to resolve syntax errors:

```bash
sudo apt update && sudo apt install vim -y

```

### 🔄 Emergency Restore to Defaults

To restore original operating system configuration files:

1. Remove all active symlinks

```bash
rm -f ~/.bashrc ~/.vimrc ~/.tmux.conf ~/.bash_profile

```
2. Restore .bashrc from Ubuntu skeleton or macOS template

```bash
cp /etc/skel/.bashrc ~/.bashrc 2>/dev/null || cp /etc/bashrc ~/.bashrc

```
3. Restore .vimrc from system templates

```bash
cp /usr/share/vim/vim*/vimrc ~/.vimrc 2>/dev/null || cp /usr/share/vim/vimrc ~/.vimrc

```
4. Generate clean, empty placeholder files for .tmux.conf and .bash_profile

```bash
touch ~/.tmux.conf ~/.bash_profile
```

