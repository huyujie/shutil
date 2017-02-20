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
# export GOPATH=/usr/local/share/applications/golangdir
# EOF

# network-bridge
#!/bin/bash
# Simple script to create ifcfg scripts in /etc/sysconfig/network-scripts in CentOS from a static IP

echo "Enter desired gateway (i.e: 192.168.128.1):"
read gateway
echo "Enter desired netmask (i.e: 255.255.240.0):"
read netmask
echo "Enter interface (i.e: eth0, ens3):"
read interface
echo "Enter IP without the main server IP(i.e: 192.168.138.134):"
read ip

OLD_INTERFACE=/etc/sysconfig/network-scripts/ifcfg-$interface
mv $OLD_INTERFACE $OLD_INTERFACE.bak

# sudo tee -a it means >>,sudo tee means >
	cat <<EOF | sudo tee /etc/sysconfig/network-scripts/ifcfg-$interface
DEVICE=$interface
TYPE=Ethernet
BOOTPROTO=static
ONBOOT=yes
DNS1=114.114.114.114
IPADDR=$ip
GATEWAY=$gateway
NETMASK=$netmask
EOF

systemctl restart NetworkManager.service

printf "If you install golang,please manual \"source /etc/profile\" make env become effective\n"
