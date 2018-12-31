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
    apt-get install zsh jq
fi

# install oh-my-zsh
# sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

# install useful plugins for zsh.
git clone https://github.com/zsh-users/zsh-completions.git ${CUSTOM_PLUGINS}/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${CUSTOM_PLUGINS}/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${CUSTOM_PLUGINS}/zsh-syntax-highlighting

sed -i -r -e 's|.*export ZSH|export ZSH|' \
          -e 's|.*ZSH_THEME.*|ZSH_THEME="ys"|' \
          -e 's|.*COMPLETION_WAITING_DOTS|COMPLETION_WAITING_DOTS|' \
          -e 's|.*HIST_STAMPS.*|HIST_STAMPS="yyyy-mm-dd"|' \
          -e 's|^plugins.*|plugins=(git python golang zsh-completions zsh-autosuggestions zsh-syntax-highlighting|' \
          ${ZSHRC}

echo 'alias jq="jq --indent 4"' >> ${ZSHRC}
echo 'alias vi="vim"' >> ${ZSHRC}

# if use vim-go plugin
    cat <<EOF | sudo tee  -a "/etc/profile"
export GOPATH=/usr/local/share/golang/gopath
export GOLANG_ROOT_DIR=/usr/local/go
export PATH=$PATH:$GOLANG_ROOT_DIR/bin:$GOPATH/bin
EOF
# echo 'export PATH=$PATH:$GOPATH/bin' >> ${ZSHRC}


source ${ZSHRC} > /dev/null 2>&1

chsh -s /bin/zsh

# view current bash
# ps | grep $$ | awk '{print $4}'
