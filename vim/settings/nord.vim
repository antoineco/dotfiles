" ensure nord's lightline color scheme is autoloaded _before_ lightline's
" built-in nord scheme
set runtimepath^=~/.vim/pack/ui/opt/nord-vim

augroup nord_theme_overrides
  autocmd!
  " highlight NERDTree's openable handles as nord4
  autocmd ColorScheme nord hi NERDTreeOpenable ctermfg=NONE guifg=#D8DEE9
augroup END
