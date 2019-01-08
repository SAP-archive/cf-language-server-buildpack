#!/bin/bash

if [[ -n "$2" ]]; then
    if [[ -n "$3" ]]; then
        moduleWs="$2/$3"
    else
        moduleWs="$2"
    fi
else
    moduleWs="___fallback"
fi

wsPath="$HOME/app/di_ws_root/$moduleWs/___jdt_ws_root"

mkdir -p ${wsPath}

exec ${JAVA_HOME}/bin/java -Declipse.application=org.eclipse.jdt.ls.core.id1 \
    -Dosgi.bundles.defaultStartLevel=4 -Declipse.product=org.eclipse.jdt.ls.core.product \
    -Dlog.protocol=true -Dlog.level=ALL -Duser.home=$HOME -noverify -javaagent:./lombok.jar \
    -Xbootclasspath/a:./lombok.jar -Xmx250M -XX:+UseG1GC -XX:+UseStringDeduplication \
    -jar ./plugins/org.eclipse.equinox.launcher_1.5.100.v20180827-1352.jar \
    -configuration ./config_linux -data ${wsPath}

