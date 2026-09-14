#!/usr/bin/env bash
# 一键演示（可选辅助脚本）：启动本地 HTTP 服务 -> 运行 api_report.sh -> 停止服务
# 等价于手动执行：python3 -m http.server 8000（另开终端） + ./api_report.sh
set -euo pipefail
cd "$(dirname "$0")"

python3 -m http.server 8000 > /tmp/httpd.log 2>&1 &
server_pid=$!
trap 'kill "$server_pid" 2>/dev/null || true' EXIT

sleep 2
./api_report.sh
