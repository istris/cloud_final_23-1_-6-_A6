# Docker镜像构建实验项目

##  实验目标
完成Docker镜像构建实验，包含：
1. Dockerfile编写（基础版和优化版）
2. 多阶段构建实现镜像瘦身
3. 端口映射、卷挂载、环境变量演示
4. 镜像瘦身量化对比

##  实验要求完成情况

###  必须完成
-  可复现：提供完整的一键部署脚本
-  可验证：包含详细的测试用例和验证方法
-  可解释：每个步骤都有清晰的技术说明

###  最低要求
-  Dockerfile编写：基础版和优化版
-  运行演示：
  - 端口映射：8081:8080, 8082:8080
  - 卷挂载：./logs目录, ./config目录
  - 环境变量：APP_NAME, APP_VERSION
-  版本管理：制定标签命名规则

###  加分点
-  镜像瘦身：多阶段构建，体积减少80%+
-  安全增强：非root用户运行
-  自动化：Makefile统一管理
-  健康检查：容器健康监控

## 运行此项目步骤 

### 环境要求
- **操作系统**：Ubuntu 18.04+ 或任何支持Docker的系统
- **必需软件**：Git、Docker、Make、curl
- **硬件**：2GB+ 内存，10GB+ 磁盘空间

### 运行步骤
```bash
# 1. 克隆项目
git clone https://github.com/istris/cloud_final_23-1_-6-_A6.git
cd cloud_final_23-1_-6-_A6

# 2. 安装Docker（如未安装）
sudo apt update && sudo apt install -y docker.io
sudo systemctl start docker
sudo usermod -aG docker $USER
newgrp docker

# 3. 一键构建和运行
make build-all        # 构建基础镜像和优化镜像
make compose-up       # 启动所有容器服务
# 或如果compose有问题，用：
make run-basic && make run-optimized

# 4. 等待10秒后验证
sleep 10
curl http://localhost:8081/      # 测试基础容器
curl http://localhost:8082/health # 测试优化容器健康检查

# 5. 运行完整测试脚本
./verify-experiment.sh
