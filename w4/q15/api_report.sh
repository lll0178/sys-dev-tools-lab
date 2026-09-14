#!/usr/bin/env bash
# 从本地 HTTP 服务拉取 packages.json，用 jq 筛选排序，生成 Markdown 报告 summary.md
# 用法：先在 q15 目录运行 python3 -m http.server 8000，再执行 ./api_report.sh
set -euo pipefail
cd "$(dirname "$0")"

url="${1:-http://127.0.0.1:8000/packages.json}"
tmp_json="$(mktemp)"
trap 'rm -f "$tmp_json"' EXIT

if ! curl -fsS "$url" -o "$tmp_json"; then
    echo "错误：无法从 $url 获取数据（请确认已在 q15 目录启动 python3 -m http.server 8000）" >&2
    exit 1
fi

{
    echo "# Package Summary"
    echo
    echo "数据来源：${url}；筛选条件：status=active 且 downloads >= 100；排序：downloads 降序，name 升序。"
    echo
    jq -r '["| name | version | downloads |", "| --- | --- | --- |"]
           + ([.[] | select(.status == "active" and .downloads >= 100)]
              | sort_by(-.downloads, .name)
              | map("| \(.name) | \(.version) | \(.downloads) |"))
           | .[]' "$tmp_json"
} > summary.md

cat summary.md
