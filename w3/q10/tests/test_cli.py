import sys

import pytest

from greetlab.cli import main


@pytest.mark.parametrize("blank", [" ", "   ", "\t"])
def test_blank_name_exits_with_code_2(monkeypatch, blank):
    monkeypatch.setattr(sys, "argv", ["sdt-greet", "--name", blank])
    with pytest.raises(SystemExit) as excinfo:
        main()
    assert excinfo.value.code == 2
