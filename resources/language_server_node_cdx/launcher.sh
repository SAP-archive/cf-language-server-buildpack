#!/bin/bash
echo 'Starting server.js using node...' > launcher.log
exec ../node_js/bin/node ./src/server.js --stdio --strict-code-completion
