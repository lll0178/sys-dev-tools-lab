#!/bin/bash
# ============ 第 3 题 制造、解决并解释一次合并冲突 ============
# 运行方式：在 WSL 中于干净目录执行  bash q03.sh
set -e

mkdir -p q03 && cd q03

# ============ 1. 初始化仓库 ============
git init
git branch -m main 2>/dev/null || true   # 若默认分支为 master 则改名为 main
git config user.name  "Student"          # 新环境未配置身份时提交会失败，先设置
git config user.email "student@example.com"

echo 'mode=normal' > config.txt
git add config.txt
git commit -m "init: mode=normal"

# ============ 2. 分支 feature-a：mode=safe ============
git checkout -b feature-a
echo 'mode=safe' > config.txt
git commit -am "feature-a: set mode=safe"

# ============ 3. 从初始 main 分支 feature-b：mode=fast ============
git checkout main
git checkout -b feature-b
echo 'mode=fast' > config.txt
git commit -am "feature-b: set mode=fast"

# ============ 4. 回 main，先合并 feature-a（快进），再合并 feature-b（冲突） ============
git checkout main
git merge feature-a          # 快进合并，无冲突
git merge feature-b || true  # 两边修改同一行 → 冲突，git 返回非零

echo "---- 冲突中的 config.txt ----"
cat config.txt

# ============ 5. 解决冲突：保留 mode=safe，另加 note=reviewed ============
printf 'mode=safe\nnote=reviewed\n' > config.txt
git add config.txt
git commit -m "merge feature-b: keep mode=safe, add note=reviewed"

# ============ 6. 验证 ============
echo "---- git status（工作区应干净） ----"
git status
echo "---- 最终 config.txt ----"
cat config.txt
echo "---- git log --all --graph --decorate --oneline ----"
git log --all --graph --decorate --oneline
