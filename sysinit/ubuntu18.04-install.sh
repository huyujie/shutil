
# ubuntu 18.04 aliyun mirror.
cp /etc/apt/sources.list /etc/apt/sources.list.backup

	cat <<EOF | sudo tee /etc/apt/sources.list
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
EOF

apt-get update -y && apt-get upgrade -y

# ntp
apt-get install ntp ntpdate -y
ntpdate pool.ntp.org

# for python develop
apt-get install python -y
apt-get install python-pip -y
pip install --upgrade pip
mkdir ~/.pip && touch ~/.pip/pip.conf

    cat <<EOF | sudo tee ~/.pip/pip.conf
[global]
index-url = http://mirrors.aliyun.com/pypi/simple/

[install]
trusted-host=mirrors.aliyun.com
EOF

pip install flake8

# for golang develop
wget https://studygolang.com/dl/golang/go1.11.linux-amd64.tar.gz
tar -zxvf go1.11.linux-amd64.tar.gz && rm -rf go1.11.linux-amd64.tar.gz && mv go/ /usr/local/

mkdir -p /usr/local/share/golang/gopath

    cat <<EOF | sudo tee  -a "/etc/profile"
export GOPATH=/usr/local/share/golang/gopath
export GOBIN=$GOPATH/bin
export GOLANG_ROOT_DIR=/usr/local/go
export PATH=$PATH:$GOLANG_ROOT_DIR/bin:$GOPATH/bin
EOF

printf "If you install golang,please manual \"source /etc/profile\" make env become effective\n"
