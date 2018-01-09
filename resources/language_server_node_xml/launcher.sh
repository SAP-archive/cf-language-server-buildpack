#!/bin/bash

exec ../nodejs/bin/node ./out/xmlServerMain.js --stdio --max_old_space_size=70 --expose_gc
