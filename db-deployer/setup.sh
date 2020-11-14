#!/bin/bash
# Add tag database to VCAP_SERVICES
export VCAP_SERVICES=`echo $VCAP_SERVICES | jq '."user-provided"[0].tags[0] |= .+ "database"'`
# Save Certificate from Environment where liquibase expects it
mkdir -p /home/vcap/.postgresql
echo $VCAP_SERVICES | jq --raw-output '."user-provided"[0].credentials.sslrootcert' > /home/vcap/.postgresql/root.crt
# Install SAP Machine
cd ..
wget https://github.com/SAP/SapMachine/releases/download/sapmachine-11.0.9.1/sapmachine-jdk-11.0.9.1_linux-x64_bin.tar.gz
tar xfz sapmachine-jdk-11.0.9.1_linux-x64_bin.tar.gz
export JAVA_HOME=/home/vcap/sapmachine-jdk-11.0.9.1
export PATH=$PATH:/home/vcap/deps/0/bin
# Install forked cds-dbm version
git clone https://github.com/gregorwolf/cds-dbm.git
cd cds-dbm/
git checkout adjust-for-sapcp-postgresql-hyperscaler
npm i
npm run build
#
cd ../app
# npm i 
cp package-local-cds-dbm.json package.json
# Replace cds-dbm version with ../cds-dbm to point to the local installation
rm -rf node_modules
npm i
npm run start:deploy
