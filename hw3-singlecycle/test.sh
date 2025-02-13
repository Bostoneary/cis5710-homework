#!/bin/bash

usage() {
    echo "How to use this:"
    echo "  $0 [arguments]"
    echo "Available options:"
    echo "-C     Check your code"
    echo "-R           Run regFile test"
    echo "-P     Run processor test (optionally specify a test filter)"
    echo "-A             Run test for milestone A"
    echo "Example:"
    echo "  $0 -A"
    echo "  $0 -C specific_test_name"
}

# Check if the argument is valid
if [ -z "$1" ]; then
    usage
    exit 1
fi

case "$1" in
  -C)
    make codecheck
    ;;
  -R)
    pytest --exitfirst --capture=no -k runCocotbTestsRegisterFile testbench.py
    ;;
  -P)
    if [ -n "$2" ]; then
      pytest --exitfirst --capture=no -k runCocotbTestsProcessor testbench.py --tests "$2"
    else
      pytest --exitfirst --capture=no -k runCocotbTestsProcessor testbench.py
    fi
    ;;
  -A)
    RVTEST_ALUBR=1 pytest --exitfirst --capture=no testbench.py
    ;;
  -B)
    pytest --exitfirst --capture=no testbench.py
    ;;
  *)
    echo "Invalid argument: $1"
    usage
    exit 1
    ;;
esac
