" ================== Formatting ==================

filetype plugin on " load filetype specific plugins
filetype indent on " load filetype specific indentations
set autoindent     " auto indentation
set smarttab       " better blank insertion

" ====================== UI ======================

syntax enable         " syntax highlighting
set number            " display line numbers
set display+=lastline " do not truncate long last line
set scrolloff=5       " number of lines to show above/below cursor
set showcmd           " show command in the last line of the screen
set laststatus=2      " always show status line

" ================== Behaviour ===================

let mapleader=','                    " more accessible leader key
set backspace=indent,eol,start       " allow backspacing in Insert mode
set listchars=tab:>\ ,trail:-,nbsp:+ " characters used in list mode
set splitbelow                       " open horizontal split below
set splitright                       " open vertical split to the right
set wildmenu                         " enhanced command completion
set incsearch                        " highlight searched pattern
set autoread                         " re-read files changed outside of Vim
packadd! matchit                     " improve % command

augroup vimrc
  autocmd!

  " YAML filetype
  autocmd FileType yaml setlocal indentkeys-=<:> " do not reindent upon typing a colon
  autocmd FileType yaml setlocal shiftwidth=2    " indent by 2 spaces

  " always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif

augroup END

" ================== Appearance ==================

colorscheme solarized " Solarized color scheme
set background=dark   " dark background

" ============ Plugin customizations =============

so ~/.vim/settings.vim
