# 关键命令与配置说明

## 1. 环境准备命令
\`\`\`bash
# 安装Docker
sudo apt update
sudo apt install -y docker.io
sudo systemctl start docker
sudo usermod -aG docker $USER
newgrp docker

# 验证安装
docker --version
docker run hello-world
\`\`\`

## 2. 镜像构建命令
\`\`\`bash
# 构建基础镜像
make build-basic
# 或
docker build -f Dockerfile-basic -t myapp:basic-v1.0 .

# 构建优化镜像
make build-optimized
# 或  
docker build -f Dockerfile-optimized -t myapp:optimized-v2.0 .

# 查看镜像
docker images myapp:*
make size
make compare
\`\`\`

## 3. 容器运行命令
\`\`\`bash
# 运行基础容器（演示功能）
docker run -d \
  --name myapp-basic \
  -p 8081:8080 \                    # 端口映射
  -e APP_NAME="Basic App" \        # 环境变量
  -e APP_VERSION="1.0" \           # 环境变量
  -v $(pwd)/logs:/app/logs \       # 卷挂载
  myapp:basic-v1.0

# 运行优化容器
docker run -d \
  --name myapp-optimized \
  -p 8082:8080 \
  -e APP_NAME="Optimized App" \
  -e APP_VERSION="2.0" \
  -v $(pwd)/config:/app/config:ro \ # 只读挂载
  myapp:optimized-v2.0
\`\`\`

## 4. 功能验证命令
\`\`\`bash
# 测试端口映射
curl http://localhost:8081/
curl http://localhost:8082/

# 测试环境变量
curl http://localhost:8082/env

# 测试健康检查
curl http://localhost:8082/health

# 测试卷挂载
ls -la logs/
ls -la config/

# 测试安全特性
docker exec myapp-optimized whoami  # 应该输出: appuser
\`\`\`

## 5. Dockerfile关键配置
\`\`\`dockerfile
# 端口映射配置
EXPOSE 8080

# 环境变量配置
ENV APP_NAME="Docker App"
ENV APP_VERSION="1.0"

# 卷挂载点
VOLUME ["/app/logs", "/app/config"]

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

# 多阶段构建（优化）
FROM alpine:3.16 as builder
# ... 构建阶段
FROM alpine:3.16
# ... 运行阶段（只复制必要文件）
\`\`\`
