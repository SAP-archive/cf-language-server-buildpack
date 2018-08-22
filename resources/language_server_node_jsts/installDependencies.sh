#!/bin/bash

#============== helper variables =================
OLDCWD=$(pwd)
nodeDir="$OLDCWD/../node_js/bin"
npm="$nodeDir/node $nodeDir/npm"
workspaceDir=~/app/di_ws_root


#============== helper functions =================
log() {
    echo $(date "+%Y/%m/%d %H:%M:%S ")$1
}

redirectNexus() {
    DMZ_REGISTRY="https://corporatenexus-w6a0ed0ee.dispatcher.int.sap.hana.ondemand.com/nexus/content/groups/build.milestones.npm/"
    $npm config set @sap:registry $DMZ_REGISTRY
    log "==> Redirecting Nexus finished with exit code $?"
}

redirectGithub() {
    DMZ_GITHUB=https://corporategithub-w6a0ed0ee.dispatcher.int.sap.hana.ondemand.com
    GITHUB=git://github.wdf.sap.corp
    git config --global url."$DMZ_GITHUB".insteadOf $GITHUB
    log "==> Redirecting Github finished with exit code $?"
}

redirectRepositories() {
    if [[ $INTERNAL == "true" ]]; 
        then
            log "==== Redirecting nexus and github repositories"  
            redirectNexus
            redirectGithub
    fi
}

installDependenciesRecursively() {
    log "==========================="
    log "Installing dependencies ..."
    log "==========================="
    for file in $(find $workspaceDir -name 'package.json'); do
        if [[ $file != *"node_modules"* ]];
            then
                log "==== Installing dependencies for $file"
                packageDir=$(dirname "$file")
                cd $packageDir
                $npm install $packageDir --ignore-scripts --no-bin-links --no-shrinkwrap --no-package-lock --only=prod --no-optional
                log "==> Installing finished with exit code $?"
        fi
    done
    cd $OLDCWD
}


#============== entry point =================
START_TIME=$SECONDS
redirectRepositories
installDependenciesRecursively
log "==========================="
echo "Installation of dependencies took $(($SECONDS - $START_TIME)) seconds."

exit 0
