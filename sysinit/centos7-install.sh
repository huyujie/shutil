#!/usr/bin/env bash

# open debug
set -x

# exit if command execute doesn't return 0
set -e


# change source mirror
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

yum clean all && yum makecache -y

# upgrade just update package and update also update kernel
# yum upgrade -y
# yum update -y

systemctl stop firewalled.service
systemctl disable firewalled.service

# disable selinux
setenforce 0
sed -i -e 's|.*SELINUX=enforcing|SELINUX=disabled|' "/etc/selinux/config"

# ntp
yum install ntp ntpdate -y

ntpdate pool.ntp.org

systemctl restart ntpdate.service
systemctl restart ntpd.service
systemctl enable ntpdate.service
systemctl enable ntpd.service

# for python develop
yum install python-pip -y
pip install --upgrade pip
mkdir ~/.pip && touch ~/.pip/pip.conf

	cat <<EOF | sudo tee ~/.pip/pip.conf
[global]
index-url = http://mirrors.aliyun.com/pypi/simple/

[install]
trusted-host=mirrors.aliyun.com
EOF

# basic package
yum install openssh net-tools bridge-utils iproute lsof wget curl jq git -y

# install golang package if you need
# yum install golang -y
# touch /usr/local/share/applications/golangdir

# 	cat <<EOF | sudo tee  -a "/etc/profile"
# export GOLANG_ROOT_DIR=/usr
# export PATH=$PATH:$GOLANG_ROOT_DIR/bin
# export GOPATH=/usr/local/share/applications/golangdir
# EOF

# network-bridge


systemctl restart NetworkManager.service


printf "If you install golang,please manual \"source /etc/profile\" make env become effective\n"
