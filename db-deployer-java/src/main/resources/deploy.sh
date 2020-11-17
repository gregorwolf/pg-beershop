#!/bin/bash
set -x #echo on
# Add tag database to VCAP_SERVICES - not needed when user provided service is created with cf command line
# export VCAP_SERVICES=`echo $VCAP_SERVICES | jq '."user-provided"[0].tags[0] |= .+ "database"'`
export JAVA_HOME=/home/vcap/app/.java-buildpack/open_jdk_jre
export PATH=$PATH:/home/vcap/deps/0/bin
# Until we use the node package for cds-dbm we need to install the dev dependencies
export NODE_ENV=development
# Save Certificate from Environment where liquibase expects it
mkdir -p /home/vcap/.postgresql
export POSTGRESQL_ROOT_CERT="/home/vcap/.postgresql/root.crt"
echo $VCAP_SERVICES | jq --raw-output '."user-provided"[0].credentials.sslrootcert' > $POSTGRESQL_ROOT_CERT
sed -i 's/BEGIN CERTIFICATE-----/BEGIN CERTIFICATE-----\n/g' $POSTGRESQL_ROOT_CERT
sed -i 's/-----END/\n-----END/g' $POSTGRESQL_ROOT_CERT
# Install dependencies
npm i
# env
npx cds-dbm deploy
