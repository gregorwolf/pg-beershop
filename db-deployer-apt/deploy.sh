#!/bin/bash
set -x #echo on
# Add tag database to VCAP_SERVICES - not needed when user provided service is created with cf command line
# export VCAP_SERVICES=`echo $VCAP_SERVICES | jq '."user-provided"[0].tags[0] |= .+ "database"'`
# export JAVA_HOME=/home/vcap/deps/0/apt/usr/lib/jvm/java-11-openjdk-amd64
export JAVA_HOME=/home/vcap/deps/0/apt/usr/lib/jvm/java-8-openjdk-amd64
export PATH=$PATH:/home/vcap/deps/1/bin
# Until we use the node package for cds-dbm we need to install the dev dependencies
export NODE_ENV=development
# Save Certificate from Environment where liquibase expects it
mkdir -p /home/vcap/.postgresql
export POSTGRESQL_ROOT_CERT="/home/vcap/.postgresql/root.crt"
echo $VCAP_SERVICES | jq --raw-output '."postgresql-db"[0].credentials.sslrootcert' > $POSTGRESQL_ROOT_CERT
# Install dependencies
npm i
# env
npx cds-dbm deploy --load-via delta
