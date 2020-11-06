# DB Deployment using cds-dbm

This folder contains the experiments for the database deployment using cds-dbm. To be able to debug I've added a express server instance serving a static website. This module can be deployed using:

`cf push`

When you then enable ssh using

`cf enable-ssh pg-beershop-db-deployer`

and run

`cf restage pg-beershop-db-deployer`

you can SSH into the running application. There I've executed:

```bash
wget https://github.com/SAP/SapMachine/releases/download/sapmachine-11.0.9.1/sapmachine-jdk-11.0.9.1_linux-x64_bin.tar.gz
tar xfz sapmachine-jdk-11.0.9.1_linux-x64_bin.tar.gz
export JAVA_HOME=/home/vcap/sapmachine-jdk-11.0.9.1
export PATH=$PATH:/home/vcap/deps/0/bin
cd app
npm run start:deploy
```

the last command currently fails with this error message:

```
TypeError: Cannot read property 'user' of undefined
    at PostgresAdapter._synchronizeCloneDatabase (/home/vcap/app/node_modules/cds-dbm/dist/adapter/PostgresAdapter.js:116:31)
    at PostgresAdapter.deploy (/home/vcap/app/node_modules/cds-dbm/dist/adapter/BaseAdapter.js:139:20)
    at async Object.exports.handler (/home/vcap/app/node_modules/cds-dbm/dist/cli/deploy.js:34:9)
```

I think that's because VCAP_SERVICES is filled with:

```JSON
{
  "VCAP_SERVICES": {
    "postgresql-db": [
      {
        "label": "postgresql-db",
        "provider": null,
        "plan": "trial",
        "name": "pg-beershop-database",
        "tags": [
          "relational",
          "database"
        ],
        "instance_name": "pg-beershop-database",
        "binding_name": null,
        "credentials": {
          "username": "postgres",
          "password": "postgres",
          "hostname": "postgres-server.amazonaws.com",
          "dbname": "beershop",
          "port": "1237",
          "uri": "postgres://postgres-server.amazonaws.com:1237/beershop",
          "sslcert": "",
          "sslrootcert": "",
        },
        "syslog_drain_url": null,
        "volume_mounts": []
      }
    ]
  }
}
```

after deploying this service:

```YAML
  - name: pg-beershop-database
    type: org.cloudfoundry.managed-service
    parameters:
      service: postgresql-db
      service-plan: trial
```

So to make it work we have to map hostname, dbname and username to the connect in cds-pg or cds-dbm.