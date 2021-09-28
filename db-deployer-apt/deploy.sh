#!/bin/bash
export JAVA_HOME=/home/vcap/deps/1/apt/usr/lib/jvm/sapmachine-11/
export PATH=$PATH:/home/vcap/deps/2/bin
# Save Certificate from Environment where liquibase expects it
mkdir -p /home/vcap/.postgresql
export POSTGRESQL_ROOT_CERT="/home/vcap/.postgresql/root.crt"
echo $VCAP_SERVICES | jq --raw-output '."postgresql-db"[0].credentials.sslrootcert' > $POSTGRESQL_ROOT_CERT
# env
npx cds-dbm deploy --load-via delta