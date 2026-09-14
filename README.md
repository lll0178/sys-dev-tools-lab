# 系统开发工具基础 · 每周课上实验检查题（第 1—16 题）

实验内容整理在 `w1/`（第 1—4 题）、`w2/`（第 5—8 题）、`w3/`（第 9—12 题）与 `w4/`（第 13—16 题）目录下。

## w1 · 第 1—4 题

- `w1/q01` 含空格文件名的批量整理（Shell 基础与文件系统）
- `w1/q02` 随机访问日志统计（Shell 管道与文本处理）
- `w1/q03` 制造、解决并解释一次合并冲突（Git）
- `w1/q04` 修复并构建一页技术说明（LaTeX）
- `w1/实验报告/` 完整实验报告（PDF / LaTeX 源码 / Markdown）与四题脚本 `scripts/`
- `w1/实验报告/run/` 脚本实际运行目录与产物副本

## w2 · 第 5—8 题

- `w2/q05` 控制一个可清理的后台任务（进程、信号与任务控制）
- `w2/q06` 语义重构与本地开发反馈（语言服务器 / ruff / pytest）
- `w2/q07` 用调试器定位归并排序缺陷（Debugging / pdb / pytest）
- `w2/q08` 先测量，再优化慢速词频程序（Profiling / cProfile）

操作步骤、原理说明与实测结果见 [`w2/README.md`](w2/README.md)；实验报告见 `w2/实验报告/`。

## w3 · 第 9—12 题

- `w3/q09` 从源码构建并在干净环境安装 Wheel（Packaging / python -m build / venv）
- `w3/q10` 让编程智能体进入可验证的修复循环（TDD + AI agent + ai_log）
- `w3/q11` 把"无法处理"的协作材料改成可执行信息（communication.md）
- `w3/q12` 修复一个可复现的线性回归训练循环（Python + PyTorch CPU）

操作步骤、原理说明与实测结果见 [`w3/README.md`](w3/README.md)；实验报告见 `w3/实验报告/`。

## w4 · 第 13—16 题

- `w4/q13` 建立可执行的本地质量门禁（ruff format/check + pytest + check.sh）
- `w4/q14` 让 Make 只重建真正受影响的产物（依赖与 .PHONY）
- `w4/q15` 把本地 API 数据转换为可读报告（http.server + curl + jq -> summary.md）
- `w4/q16` 修复并交付一个陌生的小型工具仓库（Makefile check/build/clean + wheel SHA-256）

操作步骤、原理说明与实测结果见 [`w4/README.md`](w4/README.md)。

## 环境

Windows 11 + WSL2（Ubuntu 26.04 LTS），bash + GNU coreutils，git，TeX Live（latexmk/xelatex），Python 3.14 + pytest + ruff + PyTorch 2.9.1（CPU），GNU Make，jq。
