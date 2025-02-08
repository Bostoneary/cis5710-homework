#!/bin/bash

usage() {
    echo "How to use this："
    echo "  $0 [arguements]"
    echo "avaliable option："
    echo "-codecheck check you code"
    echo "-reg run regFile test"
    echo "-processor run processor test"
    echo "-A run test for milestone A "
    echo "Example："
    echo "  $0 -A"
}

# check if the arg is vaild
if [ -z "$1" ]; then
    usage
    exit 1
fi

case "$1" in
  -codecheck)
    make codecheck
    ;;
  -reg)
    pytest --exitfirst --capture=no -k runCocotbTestsRegisterFile testbench.py
    ;;
  -processor)
    pytest --exitfirst --capture=no -k runCocotbTestsProcessor testbench.py
    ;;
  -A)
    RVTEST_ALUBR=1 pytest --exitfirst --capture=no testbench.py
    ;;
  *)
    echo "invalid arg: $1"
    usage
    exit 1
    ;;
esac
