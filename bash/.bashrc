# ==============================================================================
# UNIVERSAL SETTINGS & ALIASES (Runs on BOTH Mac and Linux)
# ==============================================================================
# Sane History Settings
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

# Check window size after each command
shopt -s checkwinsize

# Quick Global Aliases
alias g='git'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Force language to English (US)
export LANG="en_US.UTF-8"
export LANGUAGE="en_US:en"

# Git Management Shortcuts
# For git difftool with vimdiff tool

# Compare working directory against the last commit
alias gd='git difftool'

# Compare staged (indexed) changes against HEAD
alias gds='git difftool --staged'

# Compare working directory against the commit prior to HEAD (HEAD~1)
alias gdp='git difftool HEAD~1'

# Open ALL modified files at once in a directory-tree diff
alias gdd='git difftool --dir-diff'

# Compare changes between two branches (e.g., gdb main feature-branch)
alias gdb='git difftool'


# Core bare/work-tree mapping for dotfiles
alias dotgit="git --git-dir=$HOME/Projects/Personal/dotfiles/.git --work-tree=$HOME/Projects/Personal/dotfiles"

# Jump to dotfiles directory
alias dotcd="cd $HOME/Projects/Personal/dotfiles"

# Quick return to previous directory
alias back="cd -
"
# Status check
alias dotst="dotgit status"

# Safe Pull (Rebase + Autostash untracked files)
alias dotpull="dotgit pull --rebase --autostash origin main"

# Safe Push Function
dotpush() {
    local msg="${1:-Update dotfiles}"

    echo "--> Checking remote updates..."
    dotgit pull --rebase --autostash origin main || { echo "Pull failed. Fix conflicts first."; return 1; }

    echo "--> Staging changes..."
    dotgit add -A

    if dotgit diff-index --quiet HEAD --; then
        echo "--> No changes to commit."
    else
        echo "--> Committing changes: '$msg'"
        dotgit commit -m "$msg"
    fi

    echo "--> Pushing to personal GitHub..."
    dotgit push
}
# Edit a dotfile and automatically return to original directory
dotedit() {
    pushd $HOME/Projects/Personal/dotfiles > /dev/null || return
    if [ -z "$1" ]; then
        vim .
    else
        vim "$1"
    fi
    popd > /dev/null || return
}

# Core bare/work-tree mapping for the general part of my Obsidian Vault
alias gengit="git --git-dir=$HOME/Projects/Personal/My_Unified_Vault/.git --work-tree=$HOME/Projects/Personal/My_Unified_Vault"

# Jump to Obsidian Vault directory
alias gencd="cd $HOME/Projects/Personal/My_Unified_Vault"

# Status check
alias genst="gengit status"

# Safe Pull (Rebase + Autostash untracked files)
alias genpull="gengit pull --rebase --autostash origin main"

# Safe Push Function
genpush() {
    local msg="${1:-Update vault}"

    echo "--> Checking remote updates..."
    gengit pull --rebase --autostash origin main || { echo "Pull failed. Fix conflicts first."; return 1; }

    echo "--> Staging changes..."
    gengit add -A

    if gengit diff-index --quiet HEAD --; then
        echo "--> No changes to commit."
    else
        echo "--> Committing changes: '$msg'"
        gengit commit -m "$msg"
    fi

    echo "--> Pushing to personal GitHub..."
    gengit push
}

# Edit an Obsidian note and automatically return to original directory
genedit() {
    pushd $HOME/Projects/Personal/My_Unified_Vault > /dev/null || return
    if [ -z "$1" ]; then
        vim .
    else
        vim "$1"
    fi
    popd > /dev/null || return
}
# Core bare/work-tree mapping for Obsidian Vault
# Core bare/work-tree mapping for the private part of my Obsidian Vault. 
# To used on personal laptop only. 
alias prigit="git --git-dir=$HOME/Projects/Personal/My_Unified_Vault/.git --work-tree=$HOME/Projects/Personal/My_Unified_Vault"

# Jump to Obsidian Vault directory
alias pricd="cd $HOME/Projects/Personal/My_Unified_Vault"

# Status check
alias prist="prigit status"

# Safe Pull (Rebase + Autostash untracked files)
alias pripull="prigit pull --rebase --autostash origin main"

# Safe Push Function
pripush() {
    local msg="${1:-Update vault}"

    echo "--> Checking remote updates..."
    prigit pull --rebase --autostash origin main || { echo "Pull failed. Fix conflicts first."; return 1; }

    echo "--> Staging changes..."
    prigit add -A

    if prigit diff-index --quiet HEAD --; then
        echo "--> No changes to commit."
    else
        echo "--> Committing changes: '$msg'"
        prigit commit -m "$msg"
    fi

    echo "--> Pushing to personal GitHub..."
    prigit push
}

# Edit an Obsidian note and automatically return to original directory
priedit() {
    pushd $HOME/Projects/Personal/My_Unified_Vault > /dev/null || return
    if [ -z "$1" ]; then
        vim .
    else
        vim "$1"
    fi
    popd > /dev/null || return
}
# ==============================================================================
# MACOS SPECIFIC SETTINGS
# ==============================================================================
if [[ "$OSTYPE" == "darwin"* ]]; then

    # Enable reverse search using up/down arrow with prefix
    bind '"\e[A": history-search-backward'
    bind '"\e[B": history-search-forward'

    # Homebrew Bash Completion
    if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
        . "$(brew --prefix)/etc/bash_completion"
    fi

    # Kubernetes (kubectl) Configuration
    alias k='kubectl'
    source <(kubectl completion bash)
    complete -o default -F __start_kubectl k

    # Rancher Desktop Path
    export PATH="/Users/davidskynar/.rd/bin:$PATH"


# ==============================================================================
# LINUX SPECIFIC SETTINGS (Ubuntu Standard Template)
# ==============================================================================
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then

    # If not running interactively, don't do anything else
    case $- in
        *i*) ;;
        *) return;;
    esac

    # Set variable identifying the chroot you work in
    if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
        debian_chroot=$(cat /etc/debian_chroot)
    fi

    # Colored prompt settings
    case "$TERM" in
        xterm-color|*-256color) color_prompt=yes;;
    esac

    if [ "$color_prompt" = yes ]; then
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    else
        PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    fi
    unset color_prompt

    # Enable color support of ls and add handy aliases
    if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
    fi

    # Ubuntu Alert alias for long running commands
    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

    # Load local bash aliases if they exist
    if [ -f ~/.bash_aliases ]; then
        . ~/.bash_aliases
    fi

    # Enable programmable completion features
    if ! shopt -oq posix; then
      if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
      elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
      fi
    fi

    # Linux Homebrew & AWS Profile Environment
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
    export AWS_PROFILE="AdministratorAccess-101260246565"
    # Linux Homebrew & AWS Profile Environment (Only runs if Homebrew is installed, uncoment to adjust on EC2)
    #if [ -d "/home/linuxbrew/.linuxbrew" ]; then
    #  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    #  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
    #fi
    #export AWS_PROFILE="AdministratorAccess-101260246565"


fi
. "$HOME/.local/bin/env"
