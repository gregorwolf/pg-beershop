#!/bin/bash
set -x #echo on
export JAVA_HOME=/home/vcap/app/.java-buildpack/open_jdk_jre
export PATH=$PATH:/home/vcap/deps/0/bin
# Save Certificate from Environment where liquibase expects it
mkdir -p /home/vcap/.postgresql
export POSTGRESQL_ROOT_CERT="/home/vcap/.postgresql/root.crt"
echo $VCAP_SERVICES | jq --raw-output '."postgresql-db"[0].credentials.sslrootcert' > $POSTGRESQL_ROOT_CERT
# Install dependencies
npm i
# env
npx cds-dbm deploy
