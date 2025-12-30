# 实验环境说明

## 硬件环境
- 虚拟机：VMware Workstation
- 操作系统：Ubuntu 19.04
- CPU：8核
- 内存：29.28GB
- 存储：50GB

## 软件环境
- Docker版本：18.09.7
- Docker Compose版本：1.21.0
- Python版本：3.7.3
- Git版本：2.20.1

## 网络配置
- 网络模式：NAT
- 主机访问：通过端口映射
- 容器网络：bridge网络

## 镜像来源
- 基础镜像：alpine:3.16 (Docker Hub)
- Python镜像：python:3.9-slim (Docker Hub)
- 自定义镜像：myapp:*

## 依赖安装
```bash
# Docker安装
sudo apt install -y docker.io
sudo systemctl start docker
sudo usermod -aG docker $USER

# 工具安装
sudo apt install -y curl git make docker-compose
