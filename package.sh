#!/bin/bash

## Script for creating local git repository with the relevant buildpack content, and pack it as the build artifact
## This script is running from pom.xml in context of target folder as current directory
## When running manually - use cd target before running the script

# Create local git repository LSP-buildpack.git inside current directory
echo "Create local git repo"
git init --bare cf-language-server-buildpack.git
# Setup for controlling the memory used by git
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

# Push changes to local git
git add *
git commit -m "initial"
git push
popd
