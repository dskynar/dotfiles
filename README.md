# 💻 Dotfiles Startup Kit

A unified environment setup for managing configurations smoothly across both **macOS** and **Linux (Ubuntu)**. 

This repository centralizes configuration files like `.bashrc` and `.vimrc` in one place using Git, then relies on symbolic links (symlinks) to hook them into the user's home (`~/`) directory.

---

## 🚀 First-Time Setup on a New Machine

When setting up a brand-new laptop or dropping into a fresh machine, follow these steps to instantly deploy your environment.

### 1. Clone the Repository
Clone this repository directly into your home folder:

```bash
git clone [https://github.com/YOUR_GITHUB_USERNAME/dotfiles.git](https://github.com/YOUR_GITHUB_USERNAME/dotfiles.git) ~/dotfiles

```

### 2. Back Up Existing Configs (Recommended)

Before touching your active environment, use `cp` to create an exact copy of the working files right inside your home directory for safety. This leaves your original files untouched while you configure the shortcuts:

```bash
cp ~/.bashrc ~/.bashrc.orig
cp ~/.vimrc ~/.vimrc.orig

```

### 3. Create the Symbolic Links

To apply your configurations, use `rm` to clear out the default files, followed immediately by `ln -s` to create a permanent filesystem shortcut link pointing to your repository folder:

```bash
rm ~/.bashrc && ln -s ~/dotfiles/bash/.bashrc ~/.bashrc
rm ~/.vimrc && ln -s ~/dotfiles/vim/.vimrc ~/.vimrc
rm ~/.gitconfig && ln -s ~/dotfiles/git/.gitconfig ~/.gitconfig
rm ~/.gitignore && ln -s ~/dotfiles/git/.gitignore ~/.gitignore

```
or simply:
```bash
ln -s ~/dotfiles/bash/.bashrc ~/.bashrc
ln -s ~/dotfiles/vim/.vimrc ~/.vimrc
ln -s ~/dotfiles/git/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/git/.gitignore ~/.gitignore

```

### 4. Verify the Links are Working

To double-check that the filesystem bridge was successfully built, run:

```bash
ls -la ~ | grep -E '\.(bashrc|vimrc)'

```

You should see output paths showing little arrows pointing back to your repository folder, like this:

```text
~/.bashrc -> /Users/YOUR_USER/dotfiles/.bashrc

```

### 5. Special Configuration for Modern Macs (Zsh Bridge)

Modern Macs use Zsh by default instead of Bash, meaning macOS looks for a `~/.zshrc` file upon startup instead of `.bashrc`.

To bridge your unified configuration to a Mac, create a standard `~/.zshrc` file (if it doesn't exist) and add this single line to the bottom of it to execute your shared repository file:

```bash
source ~/dotfiles/.bashrc

```

### 6. Activate the Environment

Reload your current shell session to pull in all your updated configurations, aliases, and functions without restarting the terminal:

```bash
source ~/.bashrc

```

---

## 🛠️ Modifying & Syncing Changes

You don't need to change directories to update your repository. Because your files are permanently symlinked, editing `~/.bashrc` or `~/.vimrc` updates the files inside your repository instantly.

This repository includes custom git shortcuts configured inside the `.bashrc`. To back up and push your changes to GitHub from anywhere in your terminal, simply run:

```bash
dotpush

```

### Manual Repository Control

If you want to run specific git commands (like checking a diff or status) without leaving your current working folder, use the `dotgit` shortcut:

```bash
dotgit status
dotgit diff

```

---

## 🆘 Troubleshooting & OS Dependencies

### 🐧 Missing Vim Syntax Highlighting on Ubuntu

Fresh installations of Ubuntu use a stripped-down package (`vim-tiny`) by default which does not support advanced features like `syntax on`, color templates, or code indentation rules.

If your terminal complains about `syntax on`, upgrade to full Vim by running:

```bash
sudo apt update && sudo apt install vim -y

```

### 🔄 Emergency Restore to Factory Defaults

If you ever need to break the repository symlinks and completely restore your machine back to its original operating system default state, run the following commands:

#### Option A: Restore from your local `.orig` backups

```bash
rm ~/.bashrc ~/.vimrc
mv ~/.bashrc.orig ~/.bashrc
mv ~/.vimrc.orig ~/.vimrc

```

#### Option B: Regenerate fresh from system skeleton templates

**On Ubuntu (Linux):**

```bash
rm ~/.bashrc ~/.vimrc
cp /etc/skel/.bashrc ~/.bashrc
cp /usr/share/vim/vim*/vimrc ~/.vimrc

```

**On macOS:**

```bash
rm ~/.bashrc ~/.vimrc
cp /etc/bashrc ~/.bashrc
cp /usr/share/vim/vimrc ~/.vimrc

```

```

```

