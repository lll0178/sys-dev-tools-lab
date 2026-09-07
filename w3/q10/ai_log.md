# ai_log（第 10 题：智能体修复循环，不超过 5 行）

1. 核心提示：`sdt-greet --name " "`（纯空白）当前仍输出问候语；目标=main 以 SystemExit(2) 结束；约束=不改 CLI 语法、不引入依赖；验证命令=`python3 -m pytest -q`。
2. 智能体改动：仅改 `src/greetlab/cli.py`——print 前加 `if not a.name.strip(): p.error(...)`（一行校验），未触碰其它文件。
3. 测试演进：修复前 3 个参数化用例全部失败（空白名正常打印退出）；修复后 `3 passed`（红→绿）。
4. 人工验证：`git diff` 确认仅 cli.py 新增 3 行、无无关修改；pytest 复跑通过；退出码由 pytest.raises(SystemExit).code == 2 断言覆盖。
