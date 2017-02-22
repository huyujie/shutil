#!/usr/bin/env bash

# open debug
set -x

# exit if command execute doesn't return 0,don't open it
# set -e 

# zsh plugin install and config file place
CUSTOM_PLUGINS="/root/.oh-my-zsh/custom/plugins"
ZSHRC="/root/.zshrc"

YUM_REPO_BACKUP="/etc/yum.repos.d/CentOS-Base.repo.backup"
YUM_EPEL="/etc/yum.repos.d/epel.repo"

if [ ! -f "$YUM_REPO_BACKUP" ]; then
	mv /etc/yum.repos.d/CentOS-Base.repo{,.backup}
	wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
fi

if [ ! -f "$YUM_EPEL" ]; then
	wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
else
	mv /etc/yum.repos.d/epel.repo{,.backup}
	wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
fi

yum clean all && yum makecache -y
# yum update -y

yum install zsh git -y
# yum install vim jq -y

# install oh-my-zsh
# sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

# install useful plugins for zsh.
git clone https://github.com/zsh-users/zsh-completions.git ${CUSTOM_PLUGINS}/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${CUSTOM_PLUGINS}/zsh-syntax-highlighting

sed -i -r -e 's|.*export ZSH|export ZSH|' \
          -e 's|.*ZSH_THEME.*|ZSH_THEME="agnoster"|' \
          -e 's|.*COMPLETION_WAITING_DOTS|COMPLETION_WAITING_DOTS|' \
          -e 's|.*HIST_STAMPS.*|HIST_STAMPS="yyyy-mm-dd"|' \
          -e 's|^plugins.*|plugins=(zsh-completions zsh-syntax-highlighting z httpie git autojump)|' \
          ${ZSHRC}

echo 'alias jq="jq --indent 4"' >> ${ZSHRC}
echo 'alias vi="vim"' >> ${ZSHRC}

source ${ZSHRC} > /dev/null 2>&1

# or chsh -s /bin/zsh
zsh

# view current bash
# ps | grep $$ | awk '{print $4}'
