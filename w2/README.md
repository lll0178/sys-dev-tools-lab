# 第 5—8 题（w2）

## 第 5 题 控制一个可清理的后台任务（q05）

**文件**：`q05/worker.sh`（trap TERM/INT 时写入 cleanup.log 并干净退出）

**课堂交互演示步骤**：

```bash
cd q05
chmod +x worker.sh
./worker.sh > stdout.log 2> stderr.log   # 1. 前台启动，stdout/stderr 分离写入
# 2. 按 Ctrl-Z 挂起任务（前台 -> 停止）
bg                                     # 3. 转入后台继续运行
jobs                                   # 4. 确认状态：[1]+ Running
pid=$(jobs -p)                         # 5. 用 jobs -p 取得 PID（不手工抄写）
kill -TERM "$pid"                      # 6. 发送 SIGTERM（禁止 kill -9）
wait                                   # 7. 等待任务结束
cat cleanup.log                        # 8. 应看到 CLEAN_EXIT
```

**实测结果**：`cleanup.log` 含 `CLEAN_EXIT`；`stdout.log` 73 行（数字 0–72）；`stderr.log` 为空。

**为什么这么做**：

- `trap '...' TERM INT` 定义"信号处理函数"：收到 SIGTERM/SIGINT 时先执行清理（写日志）再退出，这叫**优雅退出**；`kill -9` 直接强杀进程，信号不可捕获，清理代码永远不会执行。
- 前台（Ctrl-Z）→ 后台（bg）→ 查状态（jobs）是 Shell **任务控制**的三板斧；`jobs -p` 由 Shell 负责管理 PID，避免手工抄写错。

## 第 6 题 语义重构与本地开发反馈（q06）

**文件**：`q06/math_utils.py`、`q06/app.py`、`q06/test_math_utils.py`
（已通过语言服务器把 `total_price` 重命名为 `calculate_total`，定义与全部引用同步）

**编辑器（VS Code + Pylance，或 VS + Python 扩展）演示步骤**：

1. **跳转到定义**：在 `app.py` 的 `calculate_total(...)` 上按 `F12`
2. **查找引用**：`Shift+F12`，列出定义与所有使用位置
3. **重命名符号**：`F2` 输入新名字，语言服务器同步改定义和所有引用（本项目 3 处）
4. **ruff 反馈**：临时在 `app.py` 加一行 `import os` → `ruff check .` 报 `F401 unused import` → 删除该行 → 再跑通过
5. **验证**：

```bash
cd q06
ruff check .
python3 -m pytest -q     # 1 passed
```

**为什么这么做**：

- 语言服务器做的是**语义级重命名**（按符号身份定位，而不是文本替换），不会漏改、也不会误改同名注释或字符串。
- ruff 是静态检查工具（linter），能在运行前发现未使用导入、未定义变量等"代码异味"，是本地开发反馈闭环的一部分（编辑器 -> 语言服务器 -> 检查器 -> 测试）。

## 第 7 题 用调试器定位归并排序缺陷（q07）

**文件**：`q07/merge_sort_buggy.py`（原始缺陷版）、`q07/merge_sort.py`（修复版）、`q07/test_merge_sort.py`

**缺陷定位**：

- 复现：`python3 merge_sort_buggy.py` 输出 `[1, 5, 4, 3, 4, 5, 6, 9]`（正确应为 `[1, 1, 2, 3, 4, 5, 6, 9]`）
- 根因：`merge` 的 else 分支写成 `result.append(right[i])`，**用左指针 `i` 去索引右列表**，应为 `right[j]`
- 调试：在 else 行设置断点（`python3 -m pdb merge_sort_buggy.py`，或 IDE 断点），单步观察 `i`、`j`、`left[i]`、`right[j]`，发现 `right[i]` 取值错乱
- 修复：`right[i] -> right[j]`（一行最小修复，未重写算法）

**验证**：

```bash
cd q07
python3 merge_sort.py    # [1, 1, 2, 3, 4, 5, 6, 9]
python3 -m pytest -q     # 2 passed（给定输入 + 含重复元素列表）
```

**为什么这么做**：

- 先运行确认"输出错误"，再用调试器（而非到处 print）定点观察指针变量，直接看到 `i/j` 混用；
- **最小修复原则**：只改出错的那一处，不换实现（题目禁止用 sorted 替代），改完用测试覆盖回归。

## 第 8 题 先测量，再优化慢速词频程序（q08）

**文件**：`q08/generate_words.py`、`q08/wordfreq.py`（原版）、`q08/wordfreq_fast.py`（优化版）、`q08/words.txt`（生成的数据）

**步骤与实测**：

```bash
cd q08
python3 generate_words.py              # 生成 words.txt（30000 词，固定 seed 可重复）
time python3 wordfreq.py               # 原版 run1 / run2
python3 -m cProfile -s cumulative wordfreq.py   # 热点分析
time python3 wordfreq_fast.py          # 优化版 run1 / run2
```

cProfile 结果：热点集中在 `wordfreq.py:1` 的去重循环（list 的 `in` 成员判断，O(n^2)）。

| 版本 | run1 | run2 | 中位数 |
| --- | --- | --- | --- |
| 原版（list + in） | 0.099s | 0.093s | 0.096s |
| 优化版（set 去重） | 0.026s | 0.019s | 0.023s |

**加速比 ≈ 0.096 / 0.023 ≈ 4.3 倍**，最终 count 保持 1000 不变（未写死词表大小）。

**为什么这么做**：

- **先测量再优化**：用 cProfile 确认热点是"list 成员判断"，而不是文件读取或分词（避免优化错地方）；
- `list` 的 `in` 是线性扫描（O(n) 每次，整体 O(n^2)），`set` 基于哈希表（O(1) 每次，整体 O(n)）；
- 各跑 2 次取**中位数**而不是单次，抵消系统噪声；用**相同输入**保证对比公平。
