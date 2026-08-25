#!/bin/bash
# ============ 第 2 题 随机访问日志统计 ============
# 运行方式：在 WSL 中于干净目录执行  bash q02.sh
mkdir -p q02
cd q02

# ============ 1. 创建 access.csv ============
cat > access.csv <<'EOF'
timestamp,user,path,status,latency_ms
09:00:01,alice,/api/users,200,120
09:00:02,bob,/api/orders,500,310
09:00:03,alice,/api/users,503,180
09:00:04,carol,/login,500,90
09:00:05,bob,/api/orders,502,260
09:00:06,dave,/health,200,20
09:00:07,alice,/api/orders,500,420
09:00:08,carol,/api/users,500,150
EOF
echo "access.csv 行数（应为 9）："
wc -l access.csv

# ============ 2. 编写 analyze.sh ============
cat > analyze.sh <<'EOF'
#!/bin/bash
# 用法: ./analyze.sh <csv文件>

# 校验参数个数
if [ $# -ne 1 ]; then
    echo "用法: $0 <csv文件>" >&2
    exit 2
fi
csv="$1"

# 文件不存在：错误写入 stderr，返回非零退出码
if [ ! -f "$csv" ]; then
    echo "错误: 文件 $csv 不存在" >&2
    exit 1
fi

# 1) 5xx 数量最多的前 2 个 path（次数降序，次数相同按字典序）
tail -n +2 "$csv" | awk -F, '$4 >= 500 && $4 < 600 {print $3}' \
    | sort | uniq -c | sort -k1,1nr -k2,2 | head -n 2

# 2) 全部数据行的平均 latency_ms（表头不计入），保留两位小数
tail -n +2 "$csv" | awk -F, '{sum += $5; n++} END {printf "平均 latency: %.2f\n", sum/n}'
EOF
chmod +x analyze.sh

# ============ 3. 运行：正常文件 ============
echo "===== ./analyze.sh access.csv ====="
./analyze.sh access.csv

# ============ 4. 运行：不存在的文件 ============
echo "===== ./analyze.sh missing.csv ====="
./analyze.sh missing.csv
echo "exit=$?"
