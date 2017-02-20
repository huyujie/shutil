#!/usr/bin/env bash

# open debug
set -x

# exit if command execute doesn't return 0
set -e

CUSTOM_PATH="/root/.vimrc"
SYS_ENV="/etc/profile"

if [[ -f "$CUSTOM_PATH" ]]; then
	rm -rf $CUSTOM_PATH
fi

yum install vim git sudo -y

# just add,doessn't clear origin
	cat <<EOF | sudo tee -a $SYS_ENV
alias vi='vim'
EOF

# install pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# add solarized theme
cd ~/.vim/bundle && git clone git://github.com/altercation/vim-colors-solarized.git

# add NERDTree plugin.you can enter ctrl+w(w must enter twice) can switch
git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree

# add some python plugin.
cd ~/.vim/bundle/ && git clone --recursive https://github.com/davidhalter/jedi-vim.git

# add golang plugin if you need,and in vim execute ":GoInstallBinaries"
# Autocompletion is enabled by default via <C-x><C-o>
# git clone https://github.com/fatih/vim-go.git ~/.vim/bundle/vim-go

touch ~/.vim/vimrc

	cat <<EOF | sudo tee ~/.vim/vimrc
call pathogen#infect()
syntax on
filetype plugin indent on

set nocompatible

"syntax enable
set t_Co=256
let g:solarized_termcolors=256
"set background=dark
"colorscheme solarized

set nu
set expandtab
set tabstop=8
set shiftwidth=4
set softtabstop=4

"jedi config,1 is enable,0 is disable
"let g:jedi#auto_initialization = 1
EOF

printf "vim is now installed\n"
echo ''
printf "Please manual \"source /etc/profile\" make env become effective\n"
