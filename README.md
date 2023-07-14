# CAP Beershop using PostgreSQL for persistence

[![Build Status](https://dev.azure.com/gregorwolf/gregorwolf/_apis/build/status/gregorwolf.pg-beershop?branchName=main)](https://dev.azure.com/gregorwolf/gregorwolf/_build/latest?definitionId=2&branchName=main)

## Local execution

### Prerequisites

To get started quickly you need docker and docker-compose.

### Setup

Before you start please install all required dependencies using:

```
npm ci
```

Start the PostgreSQL database and [Adminer](https://www.adminer.org/) using:

```
npm run docker:start:pg
```

It will use the latest available PostgreSQL Docker container. If you want to test with PostgreSQL 11 then run:

```
npm run docker:start:pg:11
```

Now deploy the database schema using [cds-dbm](https://github.com/mikezaschka/cds-dbm) with the command:

```
npm run deploy:pg
```

The deploy will automatically load any data which is made available via local CSV files.

Then open [http://localhost:8080/](http://localhost:8080/) and login by selecting System _PostgreSQL_, Server: _beershop-postgresql_, Username _postgres_ and Password _postgres_. The database _postgres_ should already exist as you've just deployed it and the tables should contain data.

Now you can start the CAP application by using:

```
cds watch --profile pg
```

Then open <http://localhost:4004/odata/v4/beershop/Beers> in the browser and you should see an ODATA response with 11 beers:

```JSON
{
  "@odata.context": "$metadata#Beers",
  "value": [
    {
      "ID": "b8c3fc14-22e2-4f42-837a-e6134775a186",
      "name": "Lagerbier Hell",
      "abv": 5.2,
      "ibu": 12,
      "brewery_ID": "9c937100-d459-491f-a72d-81b2929af10f"
    },
    {
      "ID": "9e1704e3-6fd0-4a5d-bfb1-13ac47f7976b",
      "name": "Schönramer Hell",
      "abv": 5,
      "ibu": 20,
      "brewery_ID": "fa6b959e-3a01-40ef-872e-6030ee4de4e5"
    },
    ...
  ]
}
```

To stop the docker containers run either

```
npm run docker:stop:pg
```

or `npm run docker:stop:pg:11`.

## Run on SAP Business Technology Platform - Cloud Foundry Environment with Hyperscaler Option

We're using the mbt build to create a mtar that can be deployed to the SAP CP Cloud Foundry. The build ist started with:

```
npm run build:cf
```

login to Cloud Foundry with:

```
cf login --sso
```

then you can deploy with:

```
npm run deploy:cf
```

## Run on SAP Business Technology Platform - Cloud Foundry Environment with Service Broker

Until [SAP will provide a fully managed PostgreSQL DB](https://blogs.sap.com/2020/02/11/consuming-hyper-scaler-backing-services-on-sap-cloud-platform-an-update/) you need to provide your on PostgreSQL DB. One way is to install a [Open Service Broker](https://www.openservicebrokerapi.org/). The page [Compliant Service Brokers](https://www.openservicebrokerapi.org/compliant-service-brokers) lists brokers supporting AWS, Azure and GCP. The SAP Developers Tutorial Mission [Use Microsoft Azure Services in SAP Cloud Platform](https://developers.sap.com/mission.cp-azure-services.html) describes in great detail how to setup the Service Broker for Azure. When you finished this setup you can run:

```
npm run create-service:pg:dbms
```

to instanciate a PostgreSQL DBMS. Then run:

```
npm run create-service:pg:db
```

to create a the beershop database in the DBMS. With that opreperation done you can build the MTA by running:

```
npm run build:cf
```

That MTA can be deployed using:

```
npm run deploy:cf
```

The created database is empty. As currently no deploy script is available the needed tables and views for the CAP application need to be created before you can run the application. The easiest way to create the tables and views is to use Adminer as for the local deployment. You can get the credentials by opening the pg-beershop-srv application via the SAP Business Technology Platform Cockpit. Navigate to the Service Bindings and click on "Show sensitive data". Enter the data in the corresponsing fields of the Adminer login screen. Execute the SQL commands you find in _beershop.sql_. To fill the database with data also execute the ones in _beershop-data.sql_. Now try out the URL you find in the Overview of the pg-beershop-srv application.

## Run on SAP Business Technology Platform - Kyma Environment

### Create Docker Image

If you want to build your own docker image replace _gregorwolf_ in _package.json_ and _deployment/beershop.yaml_ with your own hub.docker.com account. Then run:

```
npm run build:docker
```

To test the image locally you have to create a _.env_ file that provides the environment variable VCAP_SERVICES which contains the connection information. Fill it with the following content:

`VCAP_SERVICES={"docker-postgres":[{"name":"postgres","label":"postgres","tags":["plain", "db", "relational", "database"],"credentials":{"host":"beershop-postgresql","port":"5432","database":"beershop","user":"postgres","password":"postgres"}}]}`

Then run:

```
npm run docker:run:srv
```

If you stopped this docker container you can start it again with

```
npm run docker:start:srv
```

to start the image _gregorwolf/pg-beershop:latest_ from hub.docker.com. If you want to run your own image run che command you find in _package.json_ with your image. Finally publish the created image with:

```
npm run push:docker
```

### Deploy to Kyma

Download the kubeconfig from your Kyma instance via the download icon in the cluster overview. Save it in _~/.kube/kubeconfig-kyma.yml_. Then run:

```
export KUBECONFIG=~/.kube/kubeconfig-kyma.yml
```

Please note that the token in the kubeconfig is [only valid for 8 hours](https://kyma-project.io/docs/components/security#details-iam-kubeconfig-service). So you might have to redo the download whenever you want to run the commands again.

To keep this project separate from your other deployments I would suggest to create a namespace:

```
kubectl create namespace pg-beershop
```

To avoid `-n pg-beershop` with each kubectl command you can run:

```
kubectl config set-context --current --namespace=pg-beershop
```

Deploy the configuration:

```
kubectl -n pg-beershop apply -f deployment/beershop.yaml
```

To create the beershop database a Job is used that starts once when you run the apply. Afterward you can delete the job with:

```
kubectl -n pg-beershop delete job beershop-db-init
```

For troubleshooting you can SSH into the CAP container:

```
kubectl -n pg-beershop exec $(kubectl -n pg-beershop get pods -l tier=frontend -o jsonpath='{.items[0].metadata.name}') -t -i /bin/bash
```

Before you can update the container you have to delete the beershop-db-init.

```
kubectl -n pg-beershop delete job beershop-db-init
```

Then you can run:

```
kubectl -n pg-beershop rollout restart deployment/beershop
```

If you want to delete the deployment, then run:

```
kubectl -n pg-beershop delete -f deployment/beershop.yaml
```

## Run on Microsoft Azure

Install [Azure CLI](https://docs.microsoft.com/cli/azure/) for your resprective OS.

Before you can use the CLI you have to login:

```
az login
```

If you have multiple account you have to list them:

```
az account list
```

and then set the one you want to use:

```
az account set --subscription <Your-Subscription-ID>
```

With the comand:

```
az account list-locations -o table
```

you can retrieve the list of locations and select the one fitting your needs best. You can configure the default settings for location and groups:

```
az config set defaults.location=germanywestcentral defaults.group=beershop
```

To deploy a PostgreSQL the extension db-up needs to be installed:

```
az extension add --name db-up
```

Set the environment variables:

```bash
export postgreservername=<yourServerName>
export adminpassword=<yourAdminPassword>
```

Then the PostgreSQL server and database can be created:

```
az postgres up --resource-group beershop --location germanywestcentral --sku-name B_Gen5_1 --server-name $postgreservername --database-name beershop --admin-user beershop --admin-password $adminpassword --ssl-enforcement Enabled --version 11
```

If you want to use this database from your own location or from SAP Business Technology Platform Trial in eu10 then you have to add a firewall rule. Based on the information found in [SAP Business Technology Platform Connectivity - Network](https://help.sap.com/viewer/cca91383641e40ffbe03bdc78f00f681/Cloud/en-US/e23f776e4d594fdbaeeb1196d47bbcc0.html#loioe23f776e4d594fdbaeeb1196d47bbcc0__trial) I add the following rule:

```
az postgres server firewall-rule create -g beershop -s $postgreservername -n cfeu10 --start-ip-address 3.122.0.0 --end-ip-address 3.124.255.255
```

Store the DB connection information in _default-env.json_. It must contain the certificate for the TLS connection documented in [Configure TLS connectivity in Azure Database for PostgreSQL - Single Server](https://docs.microsoft.com/de-de/azure/postgresql/concepts-ssl-connection-security). The format must be the following:

```json
{
  "VCAP_SERVICES": {
    "postgres": [
      {
        "label": "azure-postgresql-database",
        "provider": null,
        "plan": "database",
        "name": "beershop-database",
        "tags": ["PostgreSQL"],
        "instance_name": "beershop-database",
        "binding_name": null,
        "credentials": {
          "host": "<yourServerName>.postgres.database.azure.com",
          "port": 5432,
          "database": "beershop",
          "password": "<yourAdminPassword>",
          "username": "beershop@<yourServerName>",
          "ssl": {
            "rejectUnauthorized": false,
            "ca": "-----BEGIN CERTIFICATE-----MIIDdzCCAl+gAwIBAgIEAgAAuTANBgkqhkiG9w0BAQUFADBaMQswCQYDVQQGEwJJRTESMBAGA1UEChMJQmFsdGltb3JlMRMwEQYDVQQLEwpDeWJlclRydXN0MSIwIAYDVQQDExlCYWx0aW1vcmUgQ3liZXJUcnVzdCBSb290MB4XDTAwMDUxMjE4NDYwMFoXDTI1MDUxMjIzNTkwMFowWjELMAkGA1UEBhMCSUUxEjAQBgNVBAoTCUJhbHRpbW9yZTETMBEGA1UECxMKQ3liZXJUcnVzdDEiMCAGA1UEAxMZQmFsdGltb3JlIEN5YmVyVHJ1c3QgUm9vdDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKMEuyKrmD1X6CZymrV51Cni4eiVgLGw41uOKymaZN+hXe2wCQVt2yguzmKiYv60iNoS6zjrIZ3AQSsBUnuId9Mcj8e6uYi1agnnc+gRQKfRzMpijS3ljwumUNKoUMMo6vWrJYeKmpYcqWe4PwzV9/lSEy/CG9VwcPCPwBLKBsua4dnKM3p31vjsufFoREJIE9LAwqSuXmD+tqYF/LTdB1kC1FkYmGP1pWPgkAx9XbIGevOF6uvUA65ehD5f/xXtabz5OTZydc93Uk3zyZAsuT3lySNTPx8kmCFcB5kpvcY67Oduhjprl3RjM71oGDHweI12v/yejl0qhqdNkNwnGjkCAwEAAaNFMEMwHQYDVR0OBBYEFOWdWTCCR1jMrPoIVDaGezq1BE3wMBIGA1UdEwEB/wQIMAYBAf8CAQMwDgYDVR0PAQH/BAQDAgEGMA0GCSqGSIb3DQEBBQUAA4IBAQCFDF2O5G9RaEIFoN27TyclhAO992T9Ldcw46QQF+vaKSm2eT929hkTI7gQCvlYpNRhcL0EYWoSihfVCr3FvDB81ukMJY2GQE/szKN+OMY3EU/t3WgxjkzSswF07r51XgdIGn9w/xZchMB5hbgF/X++ZRGjD8ACtPhSNzkE1akxehi/oCr0Epn3o0WC4zxe9Z2etciefC7IpJ5OCBRLbf1wbWsaY71k5h+3zvDyny67G7fyUIhzksLi4xaNmjICq44Y3ekQEe5+NauQrz4wlHrQMz2nZQ/1/I6eYs9HRCwBXbsdtTLSR9I4LtD+gdwyah617jzV/OeBHRnDJELqYzmp-----END CERTIFICATE-----"
          },
          "sslRequired": true,
          "tags": ["postgresql"]
        },
        "syslog_drain_url": null,
        "volume_mounts": []
      }
    ]
  }
}
```

Connect to the database as described in the last paragraph of _Run on SAP Business Technology Platform_.

Store the file content in the environment variable VCAP_SERVICES (jq must be installed):

```
export VCAP_SERVICES="$(cat default-env.json | jq .VCAP_SERVICES)"
```

Now create the app service plan:

```
az appservice plan create --name beershop --resource-group beershop --sku F1 --is-linux
```

Check out what Node.JS runtimes are available:

```
az webapp list-runtimes --linux
```

Then create the web app:

```
az webapp create --resource-group beershop --plan beershop --name beershop --runtime "NODE:16-lts"
```

Configure an environment variable the variable created before:

```
az webapp config appsettings set --name beershop --resource-group beershop --settings VCAP_SERVICES="$VCAP_SERVICES"
```

Now you can publish the app using the Azure DevOps Pipeline.

To delete the database you can run:

```
az postgres server delete --resource-group beershop --name beershop
```

You have to confirm the execution with _y_.

## Run on Google Cloud Platform (GCP)

Install [Google Cloud SDK](https://cloud.google.com/sdk/docs/downloads-interactive) for your resprective OS. Then work through the [Quickstart for Node.js in the standard environment](https://cloud.google.com/appengine/docs/standard/nodejs/quickstart) to deploy

```
gcloud app create
```

Store the environment variable in _env_variables.yaml_:

```YAML
env_variables:
    VCAP_SERVICES: '{}'
```

This file is included in _app.yaml_.

## Run on HEROKU

Install [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli) for your respective OS. Then follow the instruction provided in the [Deploying with Git](https://devcenter.heroku.com/articles/git) guide to deploy from this repository.

You can also create a new pipeline or application from the Heroku website and bound it to an existing git repository. This should enable you to deploy directly from your repository on every completed pull requests on the main branch.

### Create a new app

Start by creating a new app and remote repository on heroku by issuing this command:

```
heroku create -a pg-beershop
```

### Setup the HEROKU POSTGRES Service

[Heroku Postgres](https://devcenter.heroku.com/articles/heroku-postgresql) is a managed SQL database service provided directly by Heroku. You can access a Heroku Postgres database from any language with a PostgreSQL driver, including all languages officially supported by Heroku.

In order to provision your application with an Heroku Postgres db you have to run the following command from the CLI

```
heroku addons:create heroku-postgresql:<your_plan>
```

For the first test use

```
heroku addons:create heroku-postgresql:hobby-dev
```

When correctly issued this command logs the name of the newly created db instance in the console.

You can find information about plans and pricing at [this link](https://devcenter.heroku.com/articles/heroku-postgres-plans).

The best way to deploy the database schema to your heroku app db is to create it locally, using the procedure provided in the local setup section of this guide, and then push it on the remote db using the following commands:

```
PGHOST=localhost PGUSER=postgres PGPASSWORD=postgres heroku pg:push beershop <remote_db_name>;
```

In order for this method to work you need to install psql locally. You can find more informations on this topic following you'll need to setup the psql command line as stated in [this link](https://devcenter.heroku.com/articles/heroku-postgresql#local-setup).

Note that you don't need a running pgsql instance on your machine for this to work. You can use the psql client with the dockerized instance provided in this repository.

### Configure app for running on Heroku

The entry point of every heroku application is the Procfile. Through this file you can specify the starting script of your application.

Credentials for Heroku Postgres are periodically rotated by the system. An environment variable, called DATABASE_URL is provided to your application and is automatically updated on each credentials change. For this reason, you cannot use the static xml configuration provided in the package.json file, but you need to inject the connection string at runtime through the Procfile start command.

```
web: export cds_requires_database_credentials_connectionString=$DATABASE_URL && cds run --profile heroku
```

We used the [profile feature](https://cap.cloud.sap/docs/node.js/cds-env#profiles) in order to provide specific information for the heroku environment and suppress unwanted features from the package.json file (eg. xsuaa).

We also created a heroku-postbuild script to override the default build command when deployed to heroku (not required in this version).

```json
      "database": {
        "dialect": "plain",
        "impl": "cds-pg",
        "model": [
          "srv"
        ],
        "credentials": {
          "[heroku]": {
            "ssl": {
              "rejectUnauthorized": false
            }
          }
        }
      },
```

```json
    "heroku-postbuild": "echo heroku postbuild skipped"
```

### Authentication

In this example, we used a [custom handler](https://cap.cloud.sap/docs/node.js/authentication#custom) to mock the user authentication in the heroku environment. You can follow the guides regarding authentication on the capire website to implement your own method, or reuse the built-in jwt or basic authentication.

```javascript
// XSUAA doesn't work in heroku environment, so you should provide your own authentication handler and strategy
// in this example, no auth method is provided
module.exports = (req, res, next) => {
  req.user = new cds.User.Privileged();
  return next();
};
```

### Deploy the application

To deploy the application on heroku run the command:

```
git push heroku main
```

You should now be able to open the beershop example from the heroku website.

### Open points

Right now, due to limitations in the current cds-dbm library, is not possible to use the [heroku release phase](https://devcenter.heroku.com/articles/release-phase) to automatically update the database schema on release. Will fix this when the new version of the deployer library is released.

## Features

### Convert SQL generated from cds compile to PostgreSQL

When you run:

```
npm run compile:tosql
```

the CDS model will be compiled to the _beershop-cds.sql_ file. Using the script _cdssql2pgsql.js_ this SQL is converted to support PostgreSQL. Currently only the datatype NVARCHAR must be replaced with VARCHAR.

### Import CDS files from db/data into the beershop database

The path db/data is mounted to the docker container at /tmp/data. That allows to run the COPY commands generated at the end of _beershop.sql_.

## Limitations

### jest tests not working yet

Running the jest test with `npm test` currently fails with:

```bash
    Failed: Object {
      "code": -20005,
      "message": "Failed to load DBCAPI.",
      "sqlState": "HY000",
      "stack": "Error: Failed to load DBCAPI.
```

when running the standalone script `node test/test-db.js` that uses the same way to connect everything is OK.

## Ideas

### Use Init Containers to deploy schema in Kyma

Right now for the Kyma deployment the schema must be updated manually. [Using Liquibase in Kubernetes](https://www.liquibase.org/blog/using-liquibase-in-kubernetes) describes the use of Init Containers in K8n. I think the Docker image [timbru31/java-node:11-erbium](https://hub.docker.com/r/timbru31/java-node) shoul be a good basis.
