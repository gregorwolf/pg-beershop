# CAP Beershop using PostgreSQL for persistence

## Prerequisites

For the quickest start docker and docker-compose are needed.

## Setup

To run the example with a local PostgreSQL DB in docker create a `default-env.json` file with the following content:

```JSON
{
  "VCAP_SERVICES": {
    "postgres": [
      {
        "name": "postgres",
        "label": "postgres",
        "tags": [
          "postgres"
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

Then open [http://localhost:8080/](http://localhost:8080/) and login by selecting System *PostgreSQL*, Username *postgres* and Password *postgres*. Create a new database *beershop* using the *Create database* link. Then execute the SQL commands you find in beershop.sql.

Now you can start the CAP application by using:

`cds run`

# Ideas

## Schema Migrations

- https://flywaydb.org/
- https://www.liquibase.org/