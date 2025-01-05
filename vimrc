" ================== Formatting ==================

filetype plugin on " load filetype specific plugins
filetype indent on " load filetype specific indentations
set autoindent     " auto indentation
set smarttab       " better blank insertion
set nojoinspaces   " single space after punctuation

" ====================== UI ======================

syntax enable                        " syntax highlighting
set number                           " display line numbers
set listchars=tab:>\ ,trail:-,nbsp:+ " characters used in list mode
set display+=lastline                " do not truncate long last line
set scrolloff=8                      " number of lines to show above/below cursor
set showcmd                          " show command in the last line of the screen
set laststatus=2                     " always show status line
set ruler                            " show cursor position in statusline
set colorcolumn=+1                   " highlight textwidth column

" ================== Behaviour ===================

nnoremap <Space> <Nop>
let mapleader = "\<Space>"           " more accessible leader key
set nostartofline                    " preserve cursor column after certain motions and commands
set backspace=indent,eol,start       " allow backspacing in Insert mode
set splitbelow                       " open horizontal split below
set splitright                       " open vertical split to the right
set wildmenu                         " enhanced command completion
set wildoptions=pum                  " display completion matches via popup menu
set wildmode=longest:full            " 1st Tab completes till longest common string, 2nd opens wildmenu
set complete-=i                      " exclude included files from completion results
set incsearch                        " highlight searched pattern while typing
set hlsearch                         " keep matches from previous search highlighted
set shortmess-=S                     " display results count while searching
set smartcase                        " make search case sensitive when pattern contains uppercase chars
set ignorecase                       " required by smartcase
set autoread                         " re-read files changed outside of Vim
set ttimeout                         " wait for character after Esc
set ttimeoutlen=50                   " shorten wait for key sequence after Esc
set hidden                           " allow navigating away from buffer without saving
set switchbuf=uselast                " quickfix entries jump to last used window
set mouse=                           " disable mouse support
set belloff=all                      " never ring the bell
packadd! matchit                     " improve % command

" ================== Appearance ==================

set background=dark

if has('termguicolors')
  set termguicolors
endif

colorscheme habamax
