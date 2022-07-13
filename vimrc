" ================== Formatting ==================

filetype plugin on " load filetype specific plugins
filetype indent on " load filetype specific indentations
set autoindent     " auto indentation
set smarttab       " better blank insertion
set nojoinspaces   " single space after punctuation

" ====================== UI ======================

syntax enable         " syntax highlighting
set number            " display line numbers
set display+=lastline " do not truncate long last line
set scrolloff=5       " number of lines to show above/below cursor
set showcmd           " show command in the last line of the screen
set laststatus=2      " always show status line
set colorcolumn=+1    " highlight textwidth column

" ================== Behaviour ===================

let mapleader=','                    " more accessible leader key
set backspace=indent,eol,start       " allow backspacing in Insert mode
set listchars=tab:>\ ,trail:-,nbsp:+ " characters used in list mode
set splitbelow                       " open horizontal split below
set splitright                       " open vertical split to the right
set wildmenu                         " enhanced command completion
set wildmode=list:longest,list:full  " 1st Tab completes till longest common string, 2nd opens wildmenu
set incsearch                        " highlight searched pattern while typing
set hlsearch                         " keep matches from previous search highlighted
set smartcase                        " make search case sensitive when pattern contains uppercase chars
set ignorecase                       " required by smartcase
set autoread                         " re-read files changed outside of Vim
set ttimeout                         " wait for character after Esc
set ttimeoutlen=50                   " shorten wait for key sequence after Esc
set mouse=                           " disable mouse support
set autowrite                        " automatically write buffer on commands like :next
packadd! matchit                     " improve % command

" start new undo sequence after a newline or C-U in insert mode
inoremap <CR> <C-G>u<CR>
inoremap <C-U> <C-G>u<C-U>

" use Space to toggle/create folds
nnoremap <silent> <expr> <Space> foldlevel('.')?'za':'<Space>'
vnoremap <Space> zf

augroup vimrc
  autocmd!

  " always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif

augroup END

" enforce bracketed paste support in tmux (see ':h xterm-bracketed-paste')
if &term =~ "tmux"
  let &t_BE = "\e[?2004h"
  let &t_BD = "\e[?2004l"
  exec "set t_PS=\e[200~"
  exec "set t_PE=\e[201~"
endif

" ================== Appearance ==================

if ($TERM_PROGRAM != 'Apple_Terminal')
  set termguicolors " enable 24-bit true color

  " enforce 24-bit true color support in tmux (see ':h xterm-true-color')
  if &term =~ "tmux"
    let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
    let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
  endif
endif

" Base16 color scheme
if exists('$BASE16_THEME')
  \ && (!exists('g:colors_name')
  \ || g:colors_name != 'base16-$BASE16_THEME')

  if ($TERM_PROGRAM == 'Apple_Terminal')
    let base16colorspace=256    " take into account that the shell's colorspace was modified by base16-shell
  endif

  colorscheme base16-$BASE16_THEME
endif

" ============ Plugin customizations =============

so ~/.vim/settings.vim
