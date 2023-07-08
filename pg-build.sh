#!/bin/bash
mkdir -p gen/pg/srv
cp -r db/data gen/pg/srv
cds compile '*' > gen/pg/srv/csn.json
cp pg-package.json gen/pg/package.json
