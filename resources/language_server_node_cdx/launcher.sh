#!/bin/bash
echo 'Starting server.js using node...' >launcher.log
exec ./nodejs/bin/node ./src/server.js --stdio --strict-code-completion
