#!/bin/bash

set -e #fail script for every error

rm -rf buildpack
mkdir buildpack
mkdir buildpack/target

baseUrl="http://nexusrel.wdf.sap.corp:8081/nexus/service/local/repositories/deploy.releases/content/com/sap/devx/cf/language/server/buildpack/sap-devx-language-server-buildpack/"
version=$BUILDPACK_VERSION
bpArtifactPrefix="/sap-devx-language-server-buildpack-"
gitZipPrefix="-git.zip"

INSTANCES=2

completeBPUrl=$baseUrl$version$bpArtifactPrefix$version$gitZipPrefix

# Get buildpack from nexus
echo "Get buildpack from nexus:"
echo $completeBPUrl
if wget $completeBPUrl -O buildpack/target/ls-buildpack.git.zip
then
	echo "Buildpack git artifact fetched from nexus"
else
    echo "Buildpack git artifact couldn't fetch correctly from nexus"
    exit 1
fi


unzip buildpack/target/ls-buildpack.git.zip -d buildpack/target/ls-buildpack.git
rm buildpack/target/ls-buildpack.git.zip

# Set buildpack permissions
echo "Set buildpack permissions"
chmod -R +w buildpack/target/ls-buildpack.git/

# Get gitserver from nexus
gitserverUrl="http://nexus.wdf.sap.corp:8081/nexus/content/repositories/deploy.releases/com/sap/golang/cp/devx/gitserver/devx-git-server/0.0.4/devx-git-server-0.0.4.tar.gz"
echo "Get devx gitserver from nexus:"
echo $gitserverUrl
if wget $gitserverUrl -O buildpack/target/gitserver.tar.gz
then
	echo "DevX git server artifact fetched from nexus"
else
    echo "DevX git server artifact couldn't fetch correctly from nexus"
    exit 1
fi

tar -xvzf buildpack/target/gitserver.tar.gz -C buildpack/target
rm buildpack/target/gitserver.tar.gz

#Getting the version number without the . as the cf omits them in the url
re='^[0-9]+$'
dashedVersion=""
for((i=0;i<6;i++));do
	if [[ ${version:$i:1} =~ $re ]] ; 
    then
   		dashedVersion+=${version:$i:1}
    elif  [ ${version:$i:1} = '.' ] ;
        then
        	dashedVersion+="-"
    else
    	if  ![ ${version:$i:1} = '.' ] ;
        then
        	echo "Worng version format"
    		exit 1
        fi
	fi
done
APPNAME=$APP_NAME"-"$dashedVersion
# Push java buildpack app to CF on defined landscape
cd buildpack
cf login -a $API_ENDPOINT -u $USERNAME -p $PASSWORD -o $ORG -s $SPACE; 
cf push $APPNAME -c './target/gitserver' -b https://github.com/cloudfoundry/binary-buildpack.git -k 2G -m 512M
cf scale $APPNAME -i $INSTANCES
