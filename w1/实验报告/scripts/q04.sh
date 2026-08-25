#!/bin/bash
# ============ 第 4 题 修复并构建一页技术说明 ============
# 运行方式：在 WSL 中于干净目录执行  bash q04.sh
# 说明：本脚本使用纯英文内容（题目模板本身是英文），pdflatex 可直接编译；
#       如需中文内容，请改用 scripts/report-zh.tex + xelatex（见实验报告 5.4）。
set -e

# ============ 1. 安装依赖（首次需要 sudo；poppler-utils 提供 pdftotext） ============
sudo apt update
sudo apt install -y texlive-latex-base texlive-latex-recommended texlive-latex-extra latexmk poppler-utils

# ============ 2. 创建 report.tex（英文版，全部 ASCII，pdflatex 可直接编译） ============
mkdir -p q04
cd q04
cat > report.tex <<'EOF'
\documentclass{article}
\usepackage{amsmath}
\begin{document}
\title{Tool Report}
\author{Li Yunlong -- 25030021043}
\maketitle
\section{Result}

The mass--energy equivalence is given by Equation~\eqref{eq:einstein}:
\begin{equation}
    E = mc^2
    \label{eq:einstein}
\end{equation}

The sample data are listed in Table~\ref{tab:sample}.
\begin{table}[h]
    \centering
    \caption{Sample data}
    \label{tab:sample}
    \begin{tabular}{cc}
        \hline
        alpha & 2 \\
        beta  & 3 \\
        \hline
    \end{tabular}
\end{table}

\end{document}
EOF

# ============ 3. 构建 PDF（latexmk 自动重跑，保证交叉引用正确） ============
latexmk -pdf -halt-on-error report.tex
ls -l report.pdf

# ============ 4. 验证：PDF 中不应出现未解析引用 "??" ============
echo "---- 检查 PDF 中是否有 '??'（无输出即通过） ----"
if pdftotext report.pdf - | grep -n '??'; then
    echo "FAIL: PDF 中存在未解析引用 ??"
    exit 1
else
    echo "OK: PDF 中没有 ??，交叉引用已解析"
fi
echo "---- 检查编译日志中的 undefined 警告 ----"
if grep -n 'undefined' report.log; then
    echo "注意: 日志中有 undefined 警告"
else
    echo "OK: 日志中无 undefined references"
fi
