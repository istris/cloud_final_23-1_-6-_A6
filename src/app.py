#!/usr/bin/env python3
"""
简单Flask Web应用
展示Docker环境变量和健康检查功能
"""

import os
import socket
from flask import Flask, jsonify

app = Flask(__name__)

# 从环境变量读取配置，有默认值
APP_NAME = os.getenv('APP_NAME', 'Docker Demo App')
VERSION = os.getenv('APP_VERSION', '1.0.0')
DEBUG = os.getenv('DEBUG', 'false').lower() == 'true'
HOST = os.getenv('HOST', '0.0.0.0')
PORT = int(os.getenv('PORT', '8080'))

@app.route('/')
def home():
    """主页"""
    return jsonify({
        'app': APP_NAME,
        'version': VERSION,
        'hostname': socket.gethostname(),
        'endpoints': {
            '/': '本页面',
            '/health': '健康检查',
            '/env': '环境变量',
            '/status': '系统状态'
        }
    })

@app.route('/health')
def health():
    """健康检查端点"""
    return jsonify({
        'status': 'healthy',
        'service': APP_NAME
    })

@app.route('/env')
def show_env():
    """显示相关环境变量"""
    return jsonify({
        'app_name': APP_NAME,
        'version': VERSION,
        'debug': DEBUG,
        'host': HOST,
        'port': PORT,
        'hostname': socket.gethostname()
    })

@app.route('/status')
def status():
    """系统状态"""
    import psutil
    return jsonify({
        'cpu_percent': psutil.cpu_percent(),
        'memory_percent': psutil.virtual_memory().percent,
        'disk_usage': psutil.disk_usage('/').percent
    })

if __name__ == '__main__':
    app.run(host=HOST, port=PORT, debug=DEBUG)
