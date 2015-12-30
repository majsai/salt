#!/bin/bash

screen -ls minecraft >/dev/null 2>&1
screen_not_exists=$?

if [ $screen_not_exists -ne 0 ]; then
  screen -dmS minecraft
  screen -S minecraft -X stuff $'cd /srv/minecraft\n'
  screen -S minecraft -X stuff $'java -Xmx1024M -Xms1024M -jar server.jar nogui\n'
fi

screen -r minecraft
