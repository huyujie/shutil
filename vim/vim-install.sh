#!/usr/bin/env bash

# open debug
set -x

# exit if command execute doesn't return 0
set -e

CUSTOM_PATH="~/.vimrc"
SYS_ENV="/etc/profile"

if [[ -f "$CUSTOM_PATH" ]]; then
	rm -rf $CUSTOM_PATH
fi


if [[ -f "/etc/redhat-release" ]]; then
	MIRROR_SOURCE=yum
else
	MIRROR_SOURCE=apt-get
fi

$MIRROR_SOURCE install vim git sudo -y

# just add,doessn't clear origin
	cat <<EOF | sudo tee -a $SYS_ENV
alias vi='vim'
EOF

# install Vundle，you can launch vim and run ':PluginInstall' plugin
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# add solarized theme
# cd ~/.vim/bundle && git clone git://github.com/altercation/vim-colors-solarized.git

# add NERDTree plugin.you can enter ctrl+w(w must enter twice) can switch
cd ~/.vim/bundle && git clone https://github.com/scrooloose/nerdtree.git

# add status bar
cd ~/.vim/bundle && git clone https://github.com/vim-airline/vim-airline.git
cd ~/.vim/bundle && git clone https://github.com/vim-airline/vim-airline-themes.git

# flake8 inspect
cd ~/.vim/bundle && git clone https://github.com/w0rp/ale.git

# add some python plugin.
# cd ~/.vim/bundle/ && git clone --recursive https://github.com/davidhalter/jedi-vim.git

# add golang plugin if you need,and in vim execute ":GoInstallBinaries"
# Autocompletion is enabled by default via <C-x><C-o>
git clone https://github.com/fatih/vim-go.git ~/.vim/bundle/vim-go

touch ~/.vim/vimrc

	cat <<EOF | sudo tee ~/.vim/vimrc
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

"Plugin 'davidhalter/jedi-vim'
"jedi config,1 is enable,0 is disable
"let g:jedi#auto_initialization = 1

Plugin 'scrooloose/nerdtree'
nnoremap <silent> <F5> :NERDTree<CR>
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

"Plugin 'altercation/vim-colors-solarized'
syntax enable
set t_Co=256
"let g:solarized_termcolors=256
"set background=dark
"colorscheme solarized

"status bar
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'

"flake8 plugin,need install flake8
Plugin 'w0rp/ale'
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 1
let g:ale_sign_column_always = 1
let g:airline#extensions#ale#enabled = 1

"fzf
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'junegunn/fzf.vim'
"defalut <Leader> is '\'
nnoremap <silent> <Leader>f :Files<CR>
nnoremap <silent> <Leader>b :Buffers<CR>

"text search, need install silversearcher-ag pre
Plugin 'mileszs/ack.vim'
let g:ackprg = 'ag --nogroup --nocolor --column'
  
Plugin 'dyng/ctrlsf.vim'
let g:ctrlsf_ackprg = 'ag' 
nnoremap <leader>c :CtrlSF<space>

Plugin 'fatih/vim-go'
" vim-go settings
" let g:go_fmt_command = "goimports"

call vundle#end()            " required
filetype plugin indent on    " required

set nu
set expandtab
set tabstop=8
set shiftwidth=4
set softtabstop=4

map <F6> :call CompileRunGcc()<CR>
func! CompileRunGcc()
        exec "w"
        if &filetype == 'sh'
                :!time bash %
        elseif &filetype == 'python'
                exec "!clear"
                exec "!time python %"
        elseif &filetype == 'go'
                " exec "!go build %<"
                exec "!time go run %"
        endif
endfunc
EOF

printf "Please manual \"source /etc/profile\" make env become effective\n"
echo ''
printf "The end, you must execute 'PluginInstall' in vim."
