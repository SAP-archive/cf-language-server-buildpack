#!/bin/bash
echo 'Starting server.js using node...' >launcher.log
./link_logs.sh &>/dev/null </dev/null &
exec ./nodejs/bin/node ./src/server.js --stdio --strict-code-completion
