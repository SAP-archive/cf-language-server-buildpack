#!/bin/bash

## Script for creating local git repository with the relevant buildpack content, and pack it as the build artifact
## This script is running from pom.xml in context of target folder as current directory
## When running manually - use cd target before running the script

# Create local git repository java-buildpack.git inside current directory
echo "Create local git repo"
git init --bare cf-language-server-buildpack.git
# Setup for controlling the memory used by git (so far not successful) -TODO
pushd cf-language-server-buildpack.git
git config core.packedGitWindowSize 32m
git config core.packedGitLimit 128m
git config pack.windowMemory 10m
git config pack.packSizeLimit 10m
git config pack.thread 1
git config pack.deltaCacheSize 1m
git config core.bigFileThreshold 10m
git config http.receivepack false
popd
printf '*.zip -delta' > ./cf-language-server-buildpack.git/info/attributes

git clone ./cf-language-server-buildpack.git ./lsbuildpack
cp -R ../* ./lsbuildpack
pushd ./lsbuildpack
# Set permissions
git update-index --add --chmod=+x ./bin/compile
git update-index --add --chmod=+x ./bin/detect
git update-index --add --chmod=+x ./bin/release
git update-index --add --chmod=+x ./bin/runtime
git update-index --add --chmod=+x ./resources/cache/appcontroller/appcontroller
# Push changes to local git
git add *
git commit -m "initial"
git push
popd

# Make the ./java-buildpack.git repository exposed within a git server app
# TODO:
#to make the /java-buildpack.git available in CF, you need to make it accessible somehow. 
#I used go-git-http-backend:
# cd ~/go/src/go-git-http-backend
# ./make.sh
#cf push devxbp -c './target/javabuildpack/gitserver' -b https://github.com/cloudfoundry/binary-buildpack.git


#todo
# fix cfwizz to not have the jar names hard coded (or use constant jar names and rename them in this script)
# find solution to expose in CF