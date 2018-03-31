#!/usr/bin/env bash

# open debug
set -x

# exit if command execute doesn't return 0,don't open it
set -e 

# zsh plugin install and config file place
CUSTOM_PLUGINS="~/.oh-my-zsh/custom/plugins"
ZSHRC="~/.zshrc"


if grep -Eq "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
    yum install zsh git vim jq -y
elif grep -Eq "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
    apt-get install zsh git vim jq
fi

# install oh-my-zsh
# sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

# install useful plugins for zsh.
git clone https://github.com/zsh-users/zsh-completions.git ${CUSTOM_PLUGINS}/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${CUSTOM_PLUGINS}/zsh-syntax-highlighting

mv flybean-agnoster.zsh-theme /root/.oh-my-zsh/themes

sed -i -r -e 's|.*export ZSH|export ZSH|' \
          -e 's|.*ZSH_THEME.*|ZSH_THEME="flybean-agnoster"|' \
          -e 's|.*COMPLETION_WAITING_DOTS|COMPLETION_WAITING_DOTS|' \
          -e 's|.*HIST_STAMPS.*|HIST_STAMPS="yyyy-mm-dd"|' \
          -e 's|^plugins.*|plugins=(zsh-completions zsh-syntax-highlighting z httpie git autojump)|' \
          ${ZSHRC}

echo 'alias jq="jq --indent 4"' >> ${ZSHRC}
echo 'alias vi="vim"' >> ${ZSHRC}

# if use vim-go plugin
# echo 'export PATH=$PATH:$GOPATH/bin' >> ${ZSHRC}


source ${ZSHRC} > /dev/null 2>&1

# or chsh -s /bin/zsh
zsh

# view current bash
# ps | grep $$ | awk '{print $4}'
