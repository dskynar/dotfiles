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
### 2. Back Up Existing Configs
Before touching your active environment, use cp to create an exact copy of the working files right inside your home directory for safety. This leaves your original files untouched while you configure the shortcuts:
```bash
cp ~/.bashrc ~/.bashrc.orig
cp ~/.vimrc ~/.vimrc.orig


