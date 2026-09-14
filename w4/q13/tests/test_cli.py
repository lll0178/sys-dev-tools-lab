import sys

import pytest

from greetlab.cli import main


def test_greet_normal_name(monkeypatch, capsys):
    monkeypatch.setattr(sys, "argv", ["sdt-greet", "--name", "25030021043"])
    main()
    captured = capsys.readouterr()
    assert captured.out == "Hello, 25030021043!\n"


@pytest.mark.parametrize("blank", [" ", "   ", "\t"])
def test_blank_name_exits_with_code_2(monkeypatch, capsys, blank):
    monkeypatch.setattr(sys, "argv", ["sdt-greet", "--name", blank])
    with pytest.raises(SystemExit) as excinfo:
        main()
    assert excinfo.value.code == 2
    assert capsys.readouterr().out == ""
