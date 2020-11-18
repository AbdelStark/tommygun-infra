#!/bin/sh
entryDir=$(pwd)
rootDir=${1:-/home/ec2-user}
workDir="$rootDir/tmp"
logDir=/var/log/tommygun
configDir=/home/ec2-user/tommygun/config

# configure besu
mkdir -p $workDir $configDir $logDir
cd $workDir
serviceFile=tommygun.service
serviceFileURL=https://raw.githubusercontent.com/abdelhamidbakhta/tommygun-infra/main/aws/tommygun/tommygun.service
configFile=tommygun.properties
configFileURL=https://raw.githubusercontent.com/abdelhamidbakhta/tommygun-infra/main/aws/tommygun/tommygun.properties
wget $besuServiceFileURL $configFileURL > /dev/null 2>&1
cp $serviceFile "/etc/systemd/system/$serviceFile"
cp $configFile "$configDir/$configFile"

rm -Rf $workDir
cd $entryDir

sudo systemctl daemon-reload
sudo chown -R ec2-user:ec2-user $configDir $logDir
