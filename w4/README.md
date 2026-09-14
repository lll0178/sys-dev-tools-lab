# 第 13—16 题（w4）

## 第 13 题 建立可执行的本地质量门禁（q13）

**文件**：复制自 q10 的 greetlab 包 + `pyproject.toml`（新增 ruff / pytest 配置）+ `tests/test_cli.py`（4 个用例）+ `check.sh`

**pyproject.toml 最小配置**：

```toml
[tool.ruff]
line-length = 88
src = ["src", "tests"]

[tool.pytest.ini_options]
testpaths = ["tests"]
```

**测试**（每个都带有效断言）：

```python
def test_greet_normal_name(monkeypatch, capsys):
    monkeypatch.setattr(sys, "argv", ["sdt-greet", "--name", "25030021043"])
    main()
    assert capsys.readouterr().out == "Hello, 25030021043!\n"     # 正常姓名：断言输出内容

@pytest.mark.parametrize("blank", [" ", "   ", "\t"])
def test_blank_name_exits_with_code_2(monkeypatch, capsys, blank):
    ...
    assert excinfo.value.code == 2                                 # 空白姓名：断言退出码
    assert capsys.readouterr().out == ""                           # 且不应有问候输出
```

**check.sh**（顺序执行三项检查，任一失败即非 0）：

```bash
set -euo pipefail
ruff format --check .
ruff check .
python3 -m pytest
```

**运行结果**：

```text
== 1/3 ruff format --check ==   4 files already formatted
== 2/3 ruff check ==            All checks passed!
== 3/3 pytest ==                4 passed in 0.26s
全部通过（exit 0）
```

**为什么**：门禁把"格式 + 静态检查 + 测试"固化成一条命令，本地与 CI 用同一标准；pyproject 里只写最小配置、不全局忽略规则（如 `ignore = [...]`），否则等于把规则悄悄关掉，门禁形同虚设。

## 第 14 题 让 Make 只重建真正受影响的产物（q14）

**文件**：`data.csv`、`stats.py`、`build_report.py`、`report.md`、`Makefile`

**Makefile**：

```make
.PHONY: all clean

all: stats.txt report.txt

stats.txt: data.csv stats.py
	python3 stats.py

report.txt: report.md stats.txt build_report.py
	python3 build_report.py

clean:
	rm -f stats.txt report.txt
```

**验证结果**：

| 操作 | 现象 |
| --- | --- |
| 首次 `make` | 依次执行 `python3 stats.py`、`python3 build_report.py`，生成 stats.txt=10、report.txt |
| 无改动再 `make` | `make: Nothing to be done for 'all'.`（不执行任何配方） |
| `touch data.csv` 后 `make` | 两个配方都执行（data.csv 变新 -> stats.txt 重建 -> 进而 report.txt 重建） |
| 只 `touch report.md` 后 `make` | **只执行 `python3 build_report.py`**（依赖精准，不牵连上游） |
| `make clean` | 只删除 stats.txt、report.txt，源文件保留 |

**为什么**：Make 依据"目标 vs 依赖的时间戳"决定是否重建。所以依赖必须列全且精确：`stats.txt` 依赖 `data.csv` 与 `stats.py`，`report.txt` 依赖 `report.md`、`stats.txt`、`build_report.py`——漏列会漏建，多列会白建。`all`/`clean` 不是真实文件，必须声明 `.PHONY`，否则一旦存在同名文件就会被"时间戳判定"跳过。

## 第 15 题 把本地 API 数据转换为可读报告（q15）

**文件**：`packages.json`、`api_report.sh`（`demo.sh` 为可选的一键演示：起服务 -> 生成 -> 收尾）

**关键命令**：

```bash
python3 -m http.server 8000 &     # 在 q15 目录起本地服务
curl -fsS http://127.0.0.1:8000/packages.json
jq -r '[.[] | select(.status == "active" and .downloads >= 100)]
       | sort_by(-.downloads, .name)
       | map("| \(.name) | \(.version) | \(.downloads) |")'
./api_report.sh                    # 生成 summary.md
```

**summary.md 实际内容**：

```markdown
# Package Summary

数据来源：http://127.0.0.1:8000/packages.json；筛选条件：status=active 且 downloads >= 100；排序：downloads 降序，name 升序。

| name | version | downloads |
| --- | --- | --- |
| delta | 0.9.0 | 450 |
| gamma | 1.5.1 | 450 |
| alpha | 1.2.0 | 120 |
```

（beta 因 inactive、epsilon 因 downloads=80 被过滤；delta 与 gamma 同为 450，按 name 升序 delta 在前。）

**为什么**：`curl -fsS` 中 `-f` 让 HTTP 错误也返回非零（`set -e` 下能及时中止）、`-s` 静默进度、`-S` 保留错误信息，这是脚本里调用 HTTP 的稳妥组合；jq 的 `select` + `sort_by(-.downloads, .name)` 用一条表达式完成"筛选 + 多键排序"，避免用 shell 循环手工处理 JSON。

## 第 16 题 修复并交付一个陌生的小型工具仓库（q16）

**文件**：复制自 q13 的完整项目 + `Makefile`（check / build / clean）

**Makefile**：

```make
.PHONY: check build clean

check:
	./check.sh

build:
	python3 -m build

clean:
	rm -rf build dist src/*.egg-info
```

**综合检查过程**：

1. 基线 `make check`：`4 passed`；
2. 把问候语临时改成字面量 `print("Hello, name!")`；
3. 再 `make check` —— **门禁拦住**：

```text
E  AssertionError: assert 'Hello, name!\n' == 'Hello, 25030021043!\n'
FAILED tests/test_cli.py::test_greet_normal_name
1 failed, 3 passed in 0.21s
make: *** [Makefile:4: check] Error 1
```

4. 定位并修复：恢复 `print(f"Hello, {a.name}!")`，`make check` 重新 `4 passed`；
5. `make build` 生成 wheel，计算 SHA-256：

```text
09f86db07ed755d4dbb0e73f8746527a843a7950c22504969812ed05335ff8e3  dist/greetlab_25030021043-0.1.0-py3-none-any.whl
```

6. 最终改动以一个内容聚焦的 Git 提交入库（见仓库历史 `w4/q16` 相关提交）。

**为什么**：一个"陌生仓库"能不能放心改，取决于**是否有可执行的质量门禁**——测试失败即 make 失败，说明门禁真的在起作用；修复后用同一条命令复验，再产出可校验的产物（wheel + SHA-256），才能称为"可交付"。

## 环境

Python 3.14 + ruff 0.16 + pytest 9.1 + GNU Make 4.4.1 + jq 1.8.1（`apt install make jq`）。
