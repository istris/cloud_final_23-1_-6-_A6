#!/bin/bash

echo "=== Docker镜像构建实验测试脚本 ==="
echo "测试开始时间: $(date)"
echo ""

# 测试Docker安装
echo "1. 测试Docker安装..."
if docker --version > /dev/null 2>&1; then
    echo "✓ Docker已安装: $(docker --version | head -1)"
else
    echo "✗ Docker未安装"
    exit 1
fi

# 测试Docker Compose
echo -e "\n2. 测试Docker Compose..."
if docker-compose --version > /dev/null 2>&1; then
    echo "✓ Docker Compose已安装"
else
    echo "⚠ Docker Compose未安装，尝试安装..."
    sudo apt install -y docker-compose
fi

# 构建测试
echo -e "\n3. 测试镜像构建..."
echo "构建基础镜像..."
if make build-basic > /dev/null 2>&1; then
    echo "✓ 基础镜像构建成功"
else
    echo "✗ 基础镜像构建失败"
fi

echo "构建优化镜像..."
if make build-optimized > /dev/null 2>&1; then
    echo "✓ 优化镜像构建成功"
else
    echo "✗ 优化镜像构建失败"
fi

# 运行测试
echo -e "\n4. 测试容器运行..."
echo "启动容器..."
make compose-up > /dev/null 2>&1
sleep 10  # 等待容器启动

# 功能测试
echo -e "\n5. 功能验证..."
echo "测试端口映射..."
if curl -s http://localhost:8081/ > /dev/null; then
    echo "✓ 基础容器端口映射成功"
else
    echo "✗ 基础容器端口映射失败"
fi

if curl -s http://localhost:8082/ > /dev/null; then
    echo "✓ 优化容器端口映射成功"
else
    echo "✗ 优化容器端口映射失败"
fi

echo -e "\n测试环境变量..."
ENV_OUTPUT=$(curl -s http://localhost:8082/env)
if echo "$ENV_OUTPUT" | grep -q "app_name"; then
    echo "✓ 环境变量功能正常"
else
    echo "✗ 环境变量功能异常"
fi

echo -e "\n测试健康检查..."
HEALTH_OUTPUT=$(curl -s http://localhost:8082/health)
if echo "$HEALTH_OUTPUT" | grep -q "healthy"; then
    echo "✓ 健康检查功能正常"
else
    echo "✗ 健康检查功能异常"
fi

# 镜像大小对比
echo -e "\n6. 镜像大小对比..."
make size

echo -e "\n=== 测试完成 ==="
echo "测试结束时间: $(date)"
