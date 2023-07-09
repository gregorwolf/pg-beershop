#!/bin/bash
mkdir -p gen/pg/srv
# Works only the first time until https://github.com/cap-js/cds-dbs/issues/100 is fixed
# cp -r db/data gen/pg/srv
cds compile '*' > gen/pg/srv/csn.json
cp pg-package.json gen/pg/package.json
cp package-lock.json gen/pg/package-lock.json
