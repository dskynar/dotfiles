" ==============================================================================
" UNIVERSAL VIM CONFIGURATION (Works perfectly on Mac & Linux)
" ==============================================================================

" --- Core Features & Behavior ---
syntax on                       " Turn on syntax highlighting (from Mac)
filetype plugin on              " Ensure Vim uses filetype plugins (both)
filetype plugin indent on       " Enable filetype-specific plugins and indent rules (Linux)
filetype indent on              " Enable indentation (Mac)

" --- Sane Defaults & Intuitive Navigation ---
set autoindent                  " Copy indent from current line when starting a new one (both)
set smarttab                    " Make Tab key smarter at the start of a line (Linux)
set backspace=indent,eol,start  " Set backspace so it acts more intuitively (both)

" --- Global Indentation Defaults (2 Spaces) ---
set tabstop=2                   " Number of visual spaces per TAB (both)
set softtabstop=2               " Number of spaces a TAB counts for while editing (both)
set shiftwidth=2                " Number of spaces to use for each step of auto-indent (both)
set expandtab                   " Always use spaces instead of tabs (both)

" ==============================================================================
" SPECIAL FILETYPE & VISUAL RULES
" ==============================================================================

" --- Python Specific (4 Spaces) ---
" Recommended by PEP 8 (from Linux)
autocmd FileType python setlocal ts=4 sts=4 sw=4 expandtab

" --- YAML Specific (2 Spaces) ---
" Standard for Kubernetes, Ansible, and CloudFormation (from Linux)
autocmd FileType yaml   setlocal ts=2 sts=2 sw=2 expandtab

" --- Visual Alerts ---
" Highlight trailing whitespace in all files as an Error (from Mac)
autocmd BufRead,BufNewFile * match Error /\s\+$/
