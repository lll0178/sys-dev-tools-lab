#!/usr/bin/env bash
# 本地质量门禁：格式检查 -> 静态检查 -> 测试，任一环节失败即返回非 0
set -euo pipefail
cd "$(dirname "$0")"

echo "== 1/3 ruff format --check =="
ruff format --check .

echo "== 2/3 ruff check =="
ruff check .

echo "== 3/3 pytest =="
python3 -m pytest

echo "全部通过（exit 0）"
