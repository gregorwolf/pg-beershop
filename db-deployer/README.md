# DB Deployment using cds-dbm

This folder contains the experiments for the database deployment using cds-dbm. To be able to debug I've added a express server instance serving a static website. Before you deploy thismodule you have to copy the db and srv folder of the main project into this folder. The models are needed for cds-dbm. You can achieve that by running:

```bash
npm run copycds
```

This module can be deployed using:

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
npm i -g tsc
git clone https://github.com/gregorwolf/cds-dbm.git
cd cds-dbm/
git checkout adjust-for-sapcp-postgresql-hyperscaler
npm i
npm run build
cd ../app
vi package.json 
# Replace cds-dbm version with ../cds-dbm to point to the local installation
rm -rf node_modules
npm i
npm run start:deploy
```

the last command currently fails with this error message:

```
Error: connect ETIMEDOUT 10.16.47.76:1267
    at TCPConnectWrap.afterConnect [as oncomplete] (net.js:1141:16) {
  errno: 'ETIMEDOUT',
  code: 'ETIMEDOUT',
  syscall: 'connect',
  address: '10.16.47.76',
  port: 1267
}
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
          "sslcert": "-----BEGIN CERTIFICATE-----...",
          "sslrootcert": "-----BEGIN CERTIFICATE-----...",
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

According to the node-postgres documentation for connecting via [ssl](https://node-postgres.com/features/ssl) the credentials must look like that:

```JSON
{
  "database": "database-name",
  "host": "host-or-ip",
  "ssl": {
    "rejectUnauthorized": false,
    "ca": "-----BEGIN CERTIFICATE-----..."
  }
}
```

For Liquibase it seems that `&ssl=true` must be added to the connection string.