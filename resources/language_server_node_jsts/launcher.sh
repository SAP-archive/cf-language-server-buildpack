#!/bin/bash

echo 'Installing dependencies ...' > ~/tmp/ls_jsts_launcher.log
for file in $(find $1 -name 'package.json'); do 
    if [[ $file != *"node_modules"* ]]; 
        then
            echo "==== Installing dependencies for " $file
            npm install $(dirname "$file")
    fi
done

echo 'Starting server.js using node...' >> ~/tmp/ls_jsts_launcher.log
exec ../node_js/bin/node ./main.js
