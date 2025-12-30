.PHONY: help build build-basic build-optimized run run-basic run-optimized \
        stop test clean push images size compare

# 默认帮助信息
help:
	@echo "可用命令:"
	@echo "  make build-basic     构建基础镜像"
	@echo "  make build-optimized 构建优化镜像"
	@echo "  make build-all       构建所有镜像"
	@echo "  make run-basic       运行基础容器"
	@echo "  make run-optimized   运行优化容器"
	@echo "  make compose-up      使用Docker Compose启动"
	@echo "  make stop            停止所有容器"
	@echo "  make test            运行测试"
	@echo "  make clean           清理"
	@echo "  make images          显示镜像信息"
	@echo "  make size            显示镜像大小"
	@echo "  make compare         比较镜像大小"

# 变量定义
IMAGE_NAME = myapp
BASIC_TAG = basic-v1.0
OPTIMIZED_TAG = optimized-v2.0

# 构建基础镜像
build-basic:
	@echo "构建基础镜像..."
	docker build -f Dockerfile-basic -t $(IMAGE_NAME):$(BASIC_TAG) .
	@echo "基础镜像构建完成"

# 构建优化镜像
build-optimized:
	@echo "构建优化镜像..."
	docker build -f Dockerfile-optimized -t $(IMAGE_NAME):$(OPTIMIZED_TAG) .
	@echo "优化镜像构建完成"

# 构建所有镜像
build-all: build-basic build-optimized

# 运行基础容器
run-basic:
	@echo "运行基础容器..."
	docker run -d \
		--name myapp-basic \
		-p 8081:8080 \
		-e APP_NAME="Basic Container" \
		-e APP_VERSION="1.0" \
		-v $(PWD)/logs:/app/logs \
		$(IMAGE_NAME):$(BASIC_TAG)

# 运行优化容器
run-optimized:
	@echo "运行优化容器..."
	docker run -d \
		--name myapp-optimized \
		-p 8082:8080 \
		-e APP_NAME="Optimized Container" \
		-e APP_VERSION="2.0" \
		-v $(PWD)/config:/app/config:ro \
		-v app-data:/data \
		$(IMAGE_NAME):$(OPTIMIZED_TAG)

# 使用Docker Compose启动
compose-up:
	@echo "使用Docker Compose启动服务..."
	docker-compose up -d

# 停止所有容器
stop:
	@echo "停止容器..."
	-docker stop myapp-basic myapp-optimized
	-docker-compose down
	@echo "清理容器..."
	-docker rm myapp-basic myapp-optimized

# 运行测试
test:
	@echo "运行测试..."
	@echo "1. 测试基础容器..."
	@if curl -s http://localhost:8081/health | grep -q healthy; then \
		echo "✓ 基础容器健康检查通过"; \
	else \
		echo "✗ 基础容器健康检查失败"; \
	fi
	@echo ""
	@echo "2. 测试优化容器..."
	@if curl -s http://localhost:8082/health | grep -q healthy; then \
		echo "✓ 优化容器健康检查通过"; \
	else \
		echo "✗ 优化容器健康检查失败"; \
	fi

# 清理
clean:
	@echo "清理..."
	docker system prune -f
	rm -rf logs/*

# 显示镜像信息
images:
	@echo "镜像列表:"
	docker images $(IMAGE_NAME):*

# 显示镜像大小
size:
	@echo "镜像大小比较:"
	@echo "基础镜像:"
	@docker images --format "{{.Repository}}:{{.Tag}} {{.Size}}" | grep $(IMAGE_NAME):$(BASIC_TAG) || true
	@echo "优化镜像:"
	@docker images --format "{{.Repository}}:{{.Tag}} {{.Size}}" | grep $(IMAGE_NAME):$(OPTIMIZED_TAG) || true

# 比较镜像大小
compare: build-all
	@echo "=== 镜像大小对比 ==="
	@BASIC_SIZE=$$(docker images --format "{{.Size}}" $(IMAGE_NAME):$(BASIC_TAG) | sed 's/[^0-9.]//g'); \
	OPTIMIZED_SIZE=$$(docker images --format "{{.Size}}" $(IMAGE_NAME):$(OPTIMIZED_TAG) | sed 's/[^0-9.]//g'); \
	echo "基础镜像大小: $$BASIC_SIZE MB"; \
	echo "优化镜像大小: $$OPTIMIZED_SIZE MB"; \
	SIZE_REDUCTION=$$(echo "scale=2; ($$BASIC_SIZE - $$OPTIMIZED_SIZE) / $$BASIC_SIZE * 100" | bc); \
	echo "镜像瘦身: $$SIZE_REDUCTION%"; \
	echo "====================="
