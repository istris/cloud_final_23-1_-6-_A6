# Docker镜像构建实验项目

##  实验目标
完成Docker镜像构建实验，包含：
1. Dockerfile编写（基础版和优化版）
2. 多阶段构建实现镜像瘦身
3. 端口映射、卷挂载、环境变量演示
4. 镜像瘦身量化对比

##  实验要求完成情况

###  必须完成
- [x] 可复现：提供完整的一键部署脚本
- [x] 可验证：包含详细的测试用例和验证方法
- [x] 可解释：每个步骤都有清晰的技术说明

###  最低要求
- [x] Dockerfile编写：基础版和优化版
- [x] 运行演示：
  - 端口映射：8081:8080, 8082:8080
  - 卷挂载：./logs目录, ./config目录
  - 环境变量：APP_NAME, APP_VERSION
- [x] 版本管理：制定标签命名规则

###  加分点
- [x] 镜像瘦身：多阶段构建，体积减少80%+
- [x] 安全增强：非root用户运行
- [x] 自动化：Makefile统一管理
- [x] 健康检查：容器健康监控

##  快速开始

### 环境要求
- Ubuntu 18.04+ / 20.04 LTS
- Docker 18.09+
- Docker Compose 1.25+

### 安装Docker（如未安装）
```bash
# Ubuntu系统安装Docker
sudo apt update
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
newgrp docker
