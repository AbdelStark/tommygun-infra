#!/bin/sh
entryDir=$(pwd)
rootDir=${1:-/home/ec2-user}
workDir="$rootDir/tmp"
configDir=/home/ec2-user/config
dataDir=/data
logDir=/var/log/besu

# install requirements
yum install -y git java
git clone https://github.com/hyperledger/besu
cd besu
./gradlew install

# configure besu
mkdir -p $workDir $configDir $dataDir $logDir
cd $workDir
besuServiceFile=besu.service
besuConfigFile=config.toml
besuGenesisFile=genesis.json
besuServiceFileURL=https://raw.githubusercontent.com/abdelhamidbakhta/tommygun-infra/main/aws/besu/besu.service
besuConfigFileURL=https://raw.githubusercontent.com/abdelhamidbakhta/tommygun-infra/main/aws/besu/config.toml
besuGenesisFileURL=https://raw.githubusercontent.com/abdelhamidbakhta/tommygun-infra/main/aws/besu/genesis.json
wget $besuServiceFileURL $besuConfigFileURL $besuGenesisFileURL > /dev/null 2>&1
cp $besuServiceFile /etc/systemd/system/besu.service
cp $besuConfigFile "$configDir/$besuConfigFile"
cp $besuGenesisFile "$configDir/$besuGenesisFile"

rm -Rf $workDir
cd $entryDir

sudo systemctl daemon-reload
sudo chown -R ec2-user:ec2-user $configDir $dataDir $logDir
