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

# Dotfiles Git Management Shortcuts
alias dotgit="git --git-dir=$HOME/dotfiles/.git --work-tree=$HOME/dotfiles"
alias dotpush="dotgit add -A && dotgit commit -m 'Update dotfiles' && dotgit push"


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
