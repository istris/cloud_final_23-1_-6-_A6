# 排错复盘报告

## 问题1：Docker构建时pip安装失败
**现象**: `make build-basic` 失败，显示"can't start new thread"
**定位**: Dockerfile中使用python:3.9-slim镜像，pip版本有线程问题
**根因**: Python 3.9-slim镜像中的pip版本存在线程安全问题
**解决**: 改用Alpine Linux基础镜像
\`\`\`dockerfile
# 修改前
FROM python:3.9-slim

# 修改后
FROM alpine:3.16
RUN apk add --no-cache python3 py3-pip
\`\`\`
**预防**: 使用更稳定的基础镜像，优先选择Alpine

## 问题2：Docker Compose版本不兼容
**现象**: `make compose-up` 失败，显示"unsupported version"
**定位**: 系统安装的docker-compose版本为1.21.0，不支持version: '3.8'
**根因**: Ubuntu 19.04仓库中的docker-compose版本过旧
**解决**: 修改docker-compose.yml使用兼容格式
\`\`\`yaml
# 修改前
version: '3.8'
services:
  app-basic:
    # ...

# 修改后（去掉version或使用'2.4'）
version: '2.4'
services:
  app-basic:
    # ...
\`\`\`
**预防**: 检查docker-compose版本，使用兼容的语法

## 问题3：容器健康检查失败
**现象**: 优化容器启动后健康检查立即失败
**定位**: 容器启动需要时间，但健康检查立即开始
**根因**: 健康检查的start-period设置不足
**解决**: 增加start-period参数
\`\`\`dockerfile
# 修改前
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

# 修改后
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1
\`\`\`
**预防**: 为健康检查设置合理的启动等待时间

## 问题4：非root用户权限问题
**现象**: 优化容器无法写入日志文件
**定位**: 使用非root用户appuser，但文件权限未正确设置
**根因**: 容器内文件所有权属于root
**解决**: 在Dockerfile中设置正确的文件权限
\`\`\`dockerfile
# 修改前
COPY src/app.py .
USER appuser

# 修改后
COPY src/app.py .
RUN chown -R appuser:appuser /app
USER appuser
\`\`\`
**预防**: 切换用户前确保文件权限正确

## 问题5：镜像瘦身效果不明显
**现象**: 优化镜像只比基础镜像小10%，预期应该更大
**定位**: 两个镜像都使用Alpine，基础已较精简
**根因**: 基础镜像本身已经比较小，优化空间有限
**解决**: 创建"胖"镜像用于对比展示更明显效果
\`\`\`dockerfile
# 创建胖镜像用于对比
FROM python:3.9
RUN apt-get update && apt-get install -y \
    gcc g++ make vim nano wget git
# ... 安装更多不必要的包
\`\`\`
**预防**: 设计实验时考虑对比的基准

## 总结与经验
1. **基础镜像选择**: Alpine比Ubuntu/Debian更稳定轻量
2. **版本兼容性**: 注意生产环境和开发环境的版本差异
3. **容器启动时序**: 健康检查需要考虑服务启动时间
4. **权限管理**: 非root用户需要正确配置文件权限
5. **实验设计**: 要有合适的对照组展示效果
