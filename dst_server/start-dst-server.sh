#!/bin/bash

screen -ls dst >/dev/null 2>&1
screen_not_exists=$?

if [ $screen_not_exists -ne 0 ]; then
  screen -dmS dst
  screen -S dst -X stuff $'su - steam\n'
  screen -S dst -X stuff $'cd /home/steam/steamapps/DST/bin\n'
  screen -S dst -X stuff $'./dontstarve_dedicated_server_nullrenderer\n'
fi

screen -r dst
