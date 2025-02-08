#!/bin/bash

usage() {
    echo "How to use this:"
    echo "  $0 [arguments]"
    echo "Available options:"
    echo "-codecheck     Check your code"
    echo "-reg           Run regFile test"
    echo "-processor     Run processor test (optionally specify a test filter)"
    echo "-A             Run test for milestone A"
    echo "Example:"
    echo "  $0 -A"
    echo "  $0 -processor specific_test_name"
}

# Check if the argument is valid
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
    if [ -n "$2" ]; then
      pytest --exitfirst --capture=no -k runCocotbTestsProcessor testbench.py --tests "$2"
    else
      pytest --exitfirst --capture=no -k runCocotbTestsProcessor testbench.py
    fi
    ;;
  -A)
    RVTEST_ALUBR=1 pytest --exitfirst --capture=no testbench.py
    ;;
  *)
    echo "Invalid argument: $1"
    usage
    exit 1
    ;;
esac
