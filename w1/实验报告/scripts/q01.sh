#!/bin/bash
# ============ 第 1 题 含空格文件名的批量整理 ============
# 运行方式：在 WSL 中于干净目录执行  bash q01.sh
set -e

SID=25030021043            # ← 改成你的学号

# ============ 准备 ============
mkdir -p q01/input/docs q01/input/tmp
cd q01

# ============ 1. 创建文件 ============
printf 'alpha\nbeta\n' > 'input/docs/notes one.txt'
echo 'hidden' > input/docs/.secret.txt
touch input/tmp/empty.txt
printf '2026-08-24 10:00:00 INFO start\n2026-08-24 10:01:00 INFO stop\n' > input/run.log

# ============ 2. 绝对路径 + 长格式列表（含隐藏文件） ============
pwd
ls -la input
# 如需看子目录内容：ls -laR input

# ============ 3. 复制所有 .txt 并保留相对目录结构 ============
mkdir -p "work/$SID"
(cd input && find . -type f -name '*.txt' -exec cp --parents {} "../work/$SID/" \;)

# ============ 4. 权限：目录 750，普通文件 640 ============
find "work/$SID" -type d -exec chmod 750 {} +
find "work/$SID" -type f -exec chmod 640 {} +

# ============ 5. 生成 inventory.txt（相对路径 + 字节数） ============
find "work/$SID" -type f -exec wc -c {} \; > inventory.txt

# ============ 验证 ============
ls -laR "work/$SID"     # 目录 drwxr-x---，文件 -rw-r-----（-a 显示隐藏文件）
cat inventory.txt
