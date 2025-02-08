#!/bin/bash

# Check if the user provided an argument
if [ -z "$1" ]; then
  echo "Invalid argument."
  echo "Usage: $0 start|stop"
  exit 1
fi

# Handle "start" argument
if [ "$1" == "start" ]; then
  echo "Starting container MY-CIS5710..."
  docker start MY-CIS5710
  echo "Attaching to the container shell..."
  docker exec -it MY-CIS5710 /bin/bash
  exit 0
fi

# Handle "stop" argument
if [ "$1" == "stop" ]; then
  echo "Stopping container MY-CIS5710..."
  docker stop MY-CIS5710
  exit 0
fi

# Invalid argument case
echo "Invalid argument."
echo "Usage: $0 start|stop"
exit 1
