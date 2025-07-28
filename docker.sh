#!/bin/bash

set -e  # 遇到错误立即退出

echo "更新系统..."
sudo yum update -y

echo "卸载旧版本的 Docker..."
sudo yum remove -y docker docker-common docker-selinux docker-engine || true

echo "安装依赖包..."
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

echo "添加 Docker 官方仓库..."
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

echo "安装 Docker..."
sudo yum install -y docker-ce docker-ce-cli containerd.io

echo "启动并设置 Docker 开机自启..."
sudo systemctl start docker
sudo systemctl enable docker

echo "配置 Docker 镜像加速（可选）..."
sudo mkdir -p /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "registry-mirrors": ["https://registry.aliyuncs.com", "https://mirror.ccs.tencentyun.com"]
}
EOF

echo "重启 Docker..."
sudo systemctl daemon-reload
sudo systemctl restart docker

echo "Docker 版本信息："
docker --version

echo "安装完成！"
