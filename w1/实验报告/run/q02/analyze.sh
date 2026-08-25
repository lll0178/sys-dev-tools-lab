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
