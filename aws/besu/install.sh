#!/bin/sh
entryDir=$(pwd)
rootDir=${1:-/home/ec2-user}
workDir="$rootDir/tmp"

# install requirements
#yum install -y git java
#git clone https://github.com/hyperledger/besu
#cd besu
#./gradlew install

# configure besu
mkdir -p $workDir
cd $workDir
besuServiceFile=https://raw.githubusercontent.com/abdelhamidbakhta/tommygun-infra/main/aws/besu/besu.service
besuConfigFile=https://raw.githubusercontent.com/abdelhamidbakhta/tommygun-infra/main/aws/besu/config.toml
besuGenesisFile=https://raw.githubusercontent.com/abdelhamidbakhta/tommygun-infra/main/aws/besu/genesis.json
wget $besuServiceFile $besuConfigFile $besuGenesisFile > /dev/null 2>&1
cp $besuServiceFile /etc/systemd/system/besu.service
cp $besuConfigFile /home/ec2-user/config/config.toml
cp $besuGenesisFile /home/ec2-user/config/genesis.json
mkdir -p /home/ec2-user/data
rm -Rf $workDir
cd $entryDir