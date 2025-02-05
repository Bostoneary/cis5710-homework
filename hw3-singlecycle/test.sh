#!/bin/bash

# 检查是否传入了参数
if [ -z "$1" ]; then
    echo "Usage: $0 {reg|processor|all}"
    exit 1
fi

case "$1" in
  reg)
    pytest --exitfirst --capture=no -k runCocotbTestsRegisterFile testbench.py
    ;;
  processor)
    pytest --exitfirst --capture=no -k runCocotbTestsProcessor testbench.py
    ;;
  all)
    RVTEST_ALUBR=1 pytest --exitfirst --capture=no testbench.py
    ;;
  *)
    echo "无效的参数: $1"
    echo "Usage: $0 {reg|processor|all}"
    exit 1
    ;;
esac
