# 第 9—12 题（w3）

## 第 9 题 从源码构建并在干净环境安装 Wheel（q09）

**文件**：`q09/src/greetlab/__init__.py`、`q09/src/greetlab/cli.py`、`q09/pyproject.toml`
（包名 `greetlab-25030021043`，控制台命令 `sdt-greet`）

**步骤与结果**：

```bash
cd q09
python3 -m build                       # 生成 wheel
# 产物：dist/greetlab_25030021043-0.1.0-py3-none-any.whl
python3 -m venv /tmp/greetenv          # 干净虚拟环境
/tmp/greetenv/bin/pip install dist/greetlab_25030021043-0.1.0-py3-none-any.whl
cd /tmp && /tmp/greetenv/bin/sdt-greet --name 25030021043
```

**输出**：`Hello, 25030021043!`（在 q09 目录之外运行成功）

**为什么**：pyproject.toml 声明构建后端（setuptools）与 `[project.scripts]` 入口点；`python -m build` 产出标准 wheel；**干净 venv + 只装 wheel** 验证打包内容完整、不依赖源码目录，模拟真实用户安装。

## 第 10 题 让编程智能体进入可验证的修复循环（q10）

**文件**：复制自 q09 的包 + `tests/test_cli.py`（参数化空白名测试）+ `conftest.py`（src 布局导入）+ `ai_log.md`

**过程**：
1. 新增测试：`--name` 只含空白（`" "` / `"   "` / `"\t"`）时 `main` 应以 `SystemExit(2)` 结束；
2. 先运行：`3 failed`（原实现仍打印 `Hello, !`）；
3. 修复：cli.py 在 print 前加 `if not a.name.strip(): p.error(...)`（argparse 的 error 以 SystemExit(2) 退出）；
4. 再运行：`3 passed`；人工检查 diff（仅 3 行、无无关修改）。

**ai_log.md**（≤5 行）记录了核心提示、智能体改动、红→绿过程与人工验证。

**为什么**：这是 **TDD + 智能体闭环**——先写失败测试定义"可验证的目标"，再让智能体改实现，用同一测试命令判定成功与否；人工 diff 检查防止智能体引入无关改动。

## 第 11 题 把"无法处理"的协作材料改成可执行信息（q11）

**文件**：`q11/communication.md`（全文 ≤400 字）

将三条低质量材料改写为：
- **Issue**：含环境、复现命令、期望结果、实际结果；未知信息标注"待确认"；
- **提交信息**：祈使语气标题 + 正文（问题与解决方案）；
- **评审意见**：具体行为 + 风险 + 建议动作，并标注级别（Suggestion）。

**为什么**："Windows 上运行不了"无法复现；"fix bug"没有信息量；"写得不好"没有可执行性。好的协作材料要让接手人能**直接照做**。

## 第 12 题 修复一个可复现的线性回归训练循环（q12）

**文件**：`q12/train.py`（补全 TODO）

```python
for _ in range(200):
    pred = model(x)
    loss = loss_fn(pred, y)
    opt.zero_grad()   # 清空梯度
    loss.backward()   # 反向传播
    opt.step()        # 更新参数

model.eval()                       # 评估模式
with torch.no_grad():
    final_loss = loss_fn(model(x), y)
```

**运行结果**：

```
final loss = 0.00000000
weight = 2.999997
bias = -1.000000
OK: final loss < 0.001
```

**为什么**：SGD 每轮必须 `zero_grad`（否则梯度累积）→ `backward` → `step`；`model.eval()` + `no_grad` 在评估时不追踪梯度、不做 dropout 等训练态行为；weight≈3、bias≈-1 是**训练收敛**的结果（种子固定可复现），不是硬编码赋值。

## 环境

Python 3.14 + setuptools（build）+ pytest + PyTorch 2.9.1（CPU，`apt install python3-torch`）。
