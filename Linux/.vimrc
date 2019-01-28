" show incomplete commands
set showcmd
" Auto indent
set ai
" Auto complete matching names
set wildmenu
" Incremental Search
set hlsearch
set incsearch
set ruler
set tabstop=4
set shiftwidth=4
set expandtab
set background=dark
set autoindent
set splitright
:hi TabLineFill ctermfg=LightGreen ctermbg=DarkGreen
:hi TabLine ctermfg=White ctermbg=LightGreen
:hi TabLineSel ctermfg=Red ctermbg=black
set cursorline
:hi CursorLine cterm=NONE ctermbg=darkblue ctermfg=white
map <C-C> :s:^:#<CR>
map <C-X> :s:^#<CR>
map <C-T> :TlistOpen<CR>
autocmd bufnewfile *.py 0r /users/vegorant/public_html/templates/cli.silo.py
autocmd bufnewfile *.pl 0r /users/vegorant/public_html/templates/cli.tpl
"autocmd bufnewfile *.py 0r /users/vegorant/public_html/templates/cli.tpy
autocmd FileType python setlocal foldmethod=indent
autocmd FileType css setlocal foldmethod=indent shiftwidth=2 tabstop=2 expandtab
:nmap  :set number!<CR>
:set pastetoggle=<f5>
" set runtimepath+=~/.vim/bundle/nerdtree


" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'scrooloose/nerdtree'
Plugin 'Valloric/YouCompleteMe'
