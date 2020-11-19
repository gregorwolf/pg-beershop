#!/bin/bash
set -x #echo on
# Add tag database to VCAP_SERVICES - not needed when user provided service is created with cf command line
# export VCAP_SERVICES=`echo $VCAP_SERVICES | jq '."user-provided"[0].tags[0] |= .+ "database"'`
export JAVA_HOME=/home/vcap/sapmachine-jdk-11.0.9.1
export PATH=$PATH:/home/vcap/deps/0/bin
# Until we use the node package for cds-dbm we need to install the dev dependencies
export NODE_ENV=development
# Save Certificate from Environment where liquibase expects it
mkdir -p /home/vcap/.postgresql
export POSTGRESQL_ROOT_CERT="/home/vcap/.postgresql/root.crt"
echo $VCAP_SERVICES | jq --raw-output '."postgresql-db"[0].credentials.sslrootcert' > $POSTGRESQL_ROOT_CERT
# Install SAP Machine
cd /home/vcap/
wget -q https://github.com/SAP/SapMachine/releases/download/sapmachine-11.0.9.1/sapmachine-jdk-11.0.9.1_linux-x64_bin.tar.gz
tar xfz sapmachine-jdk-11.0.9.1_linux-x64_bin.tar.gz
cd /home/vcap/app
# Install dependencies
npm i
# env
npx cds-dbm deploy
