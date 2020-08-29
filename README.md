# CAP Beershop using PostgreSQL for persistence

[![Build Status](https://dev.azure.com/gregorwolf/gregorwolf/_apis/build/status/gregorwolf.pg-beershop?branchName=master)](https://dev.azure.com/gregorwolf/gregorwolf/_build/latest?definitionId=2&branchName=master)

## Local execution

### Prerequisites

To get started quickly you need docker and docker-compose.

### Setup

To run the example with a local PostgreSQL DB in docker create a `default-env.json` file with the following content:

```JSON
{
  "VCAP_SERVICES": {
    "postgres": [
      {
        "name": "postgres",
        "label": "postgres",
        "tags": [
          "PostgreSQL"
        ],
        "credentials": {
          "host": "localhost",
          "port": "5432",
          "database": "beershop",
          "user": "postgres",
          "password": "postgres"
        }
      }
    ]
  }
}
```

Start the PostgreSQL database and [Adminer](https://www.adminer.org/) using:

`npm run start:docker`

Then open [http://localhost:8080/](http://localhost:8080/) and login by selecting System *PostgreSQL*, Username *postgres* and Password *postgres*. Create a new database *beershop* using the *Create database* link. Then execute the SQL commands you find in *beershop.sql*.

Now you can start the CAP application by using:

`cds run`

Then open <http://localhost:4004/beershop/Beers> in the browser and you should see:

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
    }
  ]
}
```

## Run on SAP Cloud Platform

Until [SAP will provide a fully managed PostgreSQL DB](https://blogs.sap.com/2020/02/11/consuming-hyper-scaler-backing-services-on-sap-cloud-platform-an-update/) you need to provide your on PostgreSQL DB. One way is to install a [Open Service Broker](https://www.openservicebrokerapi.org/). The page [Compliant Service Brokers](https://www.openservicebrokerapi.org/compliant-service-brokers) lists brokers supporting AWS, Azure and GCP. The SAP Developers Tutorial Mission [Use Microsoft Azure Services in SAP Cloud Platform](https://developers.sap.com/mission.cp-azure-services.html) describes in great detail how to setup the Service Broker for Azure. When you finished this setup you can run:

`npm run create-service:pg:dbms`

to instanciate a PostgreSQL DBMS. Then run:

`npm run create-service:pg:db`

to create a the beershop database in the DBMS. With that opreperation done you can build the MTA by running:

`npm run build:mta`

That MTA can be deployed using:

`npm run deploy:cf`

The created database is empty. As currently no deploy script is available the needed tables and views for the CAP application need to be created before you can run the application. The easiest way to create the tables and views is to use Adminer as for the local deployment. You can get the credentials by opening the pg-beershop-srv application via the SAP Cloud Platform Cockpit. Navigate to the Service Bindings and click on "Show sensitive data". Enter the data in the corresponsing fields of the Adminer login screen. Execute the SQL commands you find in *beershop.sql*. To fill the database with data also execute the ones in *beershop-data.sql*. Now try out the URL you find in the Overview of the pg-beershop-srv application.

## Run on Microsoft Azure

Install [Azure CLI](https://docs.microsoft.com/cli/azure/) for your resprective OS. With the comand:

`az account list-locations -o table`

you can retrieve the list of locations and select the one fitting your needs best. To deploy a PostgreSQL the extension db-up needs to be installed:

`az extension add --name db-up`

Set the environment variables:

```bash
export postgreservername=<yourServerName>
export adminpassword=<yourAdminPassword>
```

Then the PostgreSQL server and database can be created:

`az postgres up --resource-group beershop --location germanywestcentral --sku-name B_Gen5_1 --server-name $postgreservername --database-name beershop --admin-user beershop --admin-password $adminpassword --ssl-enforcement Enabled`

Store the DB connection information in *default-env.json*. It must contain the certificate for the TLS connection documented in [Configure TLS connectivity in Azure Database for PostgreSQL - Single Server](https://docs.microsoft.com/de-de/azure/postgresql/concepts-ssl-connection-security). The format must be the following:

```json
{
  "VCAP_SERVICES": {
    "postgres": [
      {
        "label": "azure-postgresql-database",
        "provider": null,
        "plan": "database",
        "name": "beershop-database",
        "tags": [
          "PostgreSQL"
        ],
        "instance_name": "beershop-database",
        "binding_name": null,
        "credentials": {
          "host": "<yourServerName>.postgres.database.azure.com",
          "port": 5432,
          "database": "beershop",
          "password": "<yourAdminPassword>",
          "username": "beershop@<yourServerName>",
          "ssl":  {
            "rejectUnauthorized": false,
            "ca": "-----BEGIN CERTIFICATE-----MIIDdzCCAl+gAwIBAgIEAgAAuTANBgkqhkiG9w0BAQUFADBaMQswCQYDVQQGEwJJRTESMBAGA1UEChMJQmFsdGltb3JlMRMwEQYDVQQLEwpDeWJlclRydXN0MSIwIAYDVQQDExlCYWx0aW1vcmUgQ3liZXJUcnVzdCBSb290MB4XDTAwMDUxMjE4NDYwMFoXDTI1MDUxMjIzNTkwMFowWjELMAkGA1UEBhMCSUUxEjAQBgNVBAoTCUJhbHRpbW9yZTETMBEGA1UECxMKQ3liZXJUcnVzdDEiMCAGA1UEAxMZQmFsdGltb3JlIEN5YmVyVHJ1c3QgUm9vdDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKMEuyKrmD1X6CZymrV51Cni4eiVgLGw41uOKymaZN+hXe2wCQVt2yguzmKiYv60iNoS6zjrIZ3AQSsBUnuId9Mcj8e6uYi1agnnc+gRQKfRzMpijS3ljwumUNKoUMMo6vWrJYeKmpYcqWe4PwzV9/lSEy/CG9VwcPCPwBLKBsua4dnKM3p31vjsufFoREJIE9LAwqSuXmD+tqYF/LTdB1kC1FkYmGP1pWPgkAx9XbIGevOF6uvUA65ehD5f/xXtabz5OTZydc93Uk3zyZAsuT3lySNTPx8kmCFcB5kpvcY67Oduhjprl3RjM71oGDHweI12v/yejl0qhqdNkNwnGjkCAwEAAaNFMEMwHQYDVR0OBBYEFOWdWTCCR1jMrPoIVDaGezq1BE3wMBIGA1UdEwEB/wQIMAYBAf8CAQMwDgYDVR0PAQH/BAQDAgEGMA0GCSqGSIb3DQEBBQUAA4IBAQCFDF2O5G9RaEIFoN27TyclhAO992T9Ldcw46QQF+vaKSm2eT929hkTI7gQCvlYpNRhcL0EYWoSihfVCr3FvDB81ukMJY2GQE/szKN+OMY3EU/t3WgxjkzSswF07r51XgdIGn9w/xZchMB5hbgF/X++ZRGjD8ACtPhSNzkE1akxehi/oCr0Epn3o0WC4zxe9Z2etciefC7IpJ5OCBRLbf1wbWsaY71k5h+3zvDyny67G7fyUIhzksLi4xaNmjICq44Y3ekQEe5+NauQrz4wlHrQMz2nZQ/1/I6eYs9HRCwBXbsdtTLSR9I4LtD+gdwyah617jzV/OeBHRnDJELqYzmp-----END CERTIFICATE-----"
          },
          "sslRequired": true,
          "tags": [
            "postgresql"
          ]
        },
        "syslog_drain_url": null,
        "volume_mounts": []
      }
    ]
  }
}
```

Connect to the database as described in the last paragraph of *Run on SAP Cloud Platform*.

Store the file content in the environment variable VCAP_SERVICES (jq must be installed):

`export VCAP_SERVICES="$(cat default-env.json | jq .VCAP_SERVICES)"`

Now create the app service plan:

`az appservice plan create --name beershop --resource-group beershop --sku F1 --is-linux`

Check out what Node.JS runtimes are available:

`az webapp list-runtimes --linux`

Then create the web app:

`az webapp create --resource-group beershop --plan beershop --name beershop --runtime "NODE|12.9"`

Configure an environment variable the variable created before:

`az webapp config appsettings set --name beershop --resource-group beershop --settings VCAP_SERVICES="$VCAP_SERVICES"`

Now you can publish the app using the Azure DevOps Pipeline.

## Run on Google Cloud Platform (GCP)

Install [Google Cloud SDK](https://cloud.google.com/sdk/docs/downloads-interactive) for your resprective OS. Then work through the [Quickstart for Node.js in the standard environment](https://cloud.google.com/appengine/docs/standard/nodejs/quickstart) to deploy

`gcloud app create`

## Features

### Convert SQL generated from cds compile to PostgreSQL

When you run:

`npm run compile:tosql`

the CDS model will be compiled to the *beershop-cds.sql* file. Using the script *cdssql2pgsql.js* this SQL is converted to support PostgreSQL. Currently only the datatype NVARCHAR must be replaced with VARCHAR.

### Import CDS files from db/data into the beershop database

The path db/data is mounted to the docker container at /tmp/data. That allows to run the COPY commands generated at the end of *beershop.sql*.

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

### Schema Migrations

- <https://flywaydb.org/>
- <https://www.liquibase.org/>
