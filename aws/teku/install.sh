#!/bin/sh
entryDir=$(pwd)
rootDir=${1:-/home/ec2-user}
workDir="$rootDir/tmp"
configDir=/home/ec2-user/config
dataDir=/home/ec2-user/data
logDir=/var/log/teku

# install requirements
yum install -y git java
git clone https://github.com/ConsenSys/teku
cd teku
./gradlew install

# configure besu
mkdir -p $workDir $configDir $dataDir $logDir
cd $workDir

tekuBeaconServiceFileURL=https://raw.githubusercontent.com/abdelhamidbakhta/tommygun-infra/main/aws/teku/teku-beacon.service
tekuValidatorServiceFileURL=https://raw.githubusercontent.com/abdelhamidbakhta/tommygun-infra/main/aws/teku/teku-validator.service
tekuBeaconScriptURL=https://raw.githubusercontent.com/abdelhamidbakhta/tommygun-infra/main/aws/teku/teku-beacon.sh
tekuValidatorScriptURL=https://raw.githubusercontent.com/abdelhamidbakhta/tommygun-infra/main/aws/teku/teku-validator.sh

wget $tekuBeaconServiceFileURL $tekuValidatorServiceFileURL  > /dev/null 2>&1
cp teku-beacon.service /etc/systemd/system/teku-beacon.service
cp teku-validator.service /etc/systemd/system/teku-validator.service
wget $tekuBeaconScriptURL $tekuValidatorScriptURL > /dev/null 2>&1
cp teku-beacon.sh $rootDir
cp teku-validator.sh $rootDir

chmod +x $rootDir/*.sh
rm -Rf $workDir
cd $entryDir

systemctl daemon-reload
chown -R ec2-user:ec2-user $configDir $dataDir $logDir
