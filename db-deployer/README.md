# DB Deployment using cds-dbm

This folder contains the experiments for the database deployment using [cds-dbm](https://github.com/mikezaschka/cds-dbm). To be able to debug I've added a express server instance serving a static website. Before you deploy thismodule you have to copy the db and srv folder of the main project into this folder. The models are needed for cds-dbm. You can achieve that by running:

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
cd app
./setup.sh
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

Actually the problem is caused by an issue in the SAP Cloud Platform trial. Check out the Q&A Post: [Can't connect to PostgreSQL on SAP CP Trial, Hyperscaler Option](https://answers.sap.com/questions/13182819/cant-connect-to-postgresql-on-sap-cp-trial-hypersc.html).

## Azure

Until this issue is solved I've continued with my PostgreSQL Database on Azure. But here I run into the following error when running `npm run start:deploy`:

```
Error: Command failed: /home/vcap/cds-dbm/liquibase/liquibase --username=beershop@beershop --password=xxx --url=jdbc:postgresql://beershop.postgres.database.azure.com:5432/beershop?ssl=true --classpath=/home/vcap/cds-dbm/dist/adapter/../../drivers/postgresql-42.2.8.jar --driver=org.postgresql.Driver --defaultSchemaName=_cdsdbm_clone --changeLogFile=tmp/_autodeploy.json update 
```

when executing this command standalone I get this error message:

```
Starting Liquibase at 16:49:46 (version 4.1.0 #3 built at 2020-09-28 21:02+0000)
Unexpected error running Liquibase: Migration failed for change set tmp/_autodeploy.json::1605372539728-1::vcap (generated):
     Reason: liquibase.exception.DatabaseException: ERROR: function pg_buffercache_pages() does not exist
  Hint: No function matches the given name and argument types. You might need to add explicit type casts.
  Position: 230 [Failed SQL: (0) CREATE VIEW _cdsdbm_clone.pg_buffercache AS SELECT p.bufferid,
    p.relfilenode,
    p.reltablespace,
    p.reldatabase,
    p.relforknumber,
    p.relblocknumber,
    p.isdirty,
    p.usagecount,
    p.pinning_backends
   FROM pg_buffercache_pages() p(bufferid integer, relfilenode oid, reltablespace oid, reldatabase oid, relforknumber smallint, relblocknumber bigint, isdirty boolean, usagecount smallint, pinning_backends integer);]
For more information, please use the --logLevel flag
```

When running with the --logLevel=debug I see:

```
Unexpected error running Liquibase: Migration failed for change set tmp/_autodeploy.json::1605372539728-1::vcap (generated):
     Reason: liquibase.exception.DatabaseException: ERROR: function pg_buffercache_pages() does not exist
  Hint: No function matches the given name and argument types. You might need to add explicit type casts.
  Position: 230 [Failed SQL: (0) CREATE VIEW _cdsdbm_clone.pg_buffercache AS SELECT p.bufferid,
    p.relfilenode,
    p.reltablespace,
    p.reldatabase,
    p.relforknumber,
    p.relblocknumber,
    p.isdirty,
    p.usagecount,
    p.pinning_backends
   FROM pg_buffercache_pages() p(bufferid integer, relfilenode oid, reltablespace oid, reldatabase oid, relforknumber smallint, relblocknumber bigint, isdirty boolean, usagecount smallint, pinning_backends integer);]
For more information, please use the --logLevel flag
[2020-11-14 16:52:16] SEVERE [liquibase.integration] Unexpected error running Liquibase: Migration failed for change set tmp/_autodeploy.json::1605372539728-1::vcap (generated):
     Reason: liquibase.exception.DatabaseException: ERROR: function pg_buffercache_pages() does not exist
  Hint: No function matches the given name and argument types. You might need to add explicit type casts.
  Position: 230 [Failed SQL: (0) CREATE VIEW _cdsdbm_clone.pg_buffercache AS SELECT p.bufferid,
    p.relfilenode,
    p.reltablespace,
    p.reldatabase,
    p.relforknumber,
    p.relblocknumber,
    p.isdirty,
    p.usagecount,
    p.pinning_backends
   FROM pg_buffercache_pages() p(bufferid integer, relfilenode oid, reltablespace oid, reldatabase oid, relforknumber smallint, relblocknumber bigint, isdirty boolean, usagecount smallint, pinning_backends integer);]
liquibase.exception.LiquibaseException: liquibase.exception.MigrationFailedException: Migration failed for change set tmp/_autodeploy.json::1605372539728-1::vcap (generated):
     Reason: liquibase.exception.DatabaseException: ERROR: function pg_buffercache_pages() does not exist
  Hint: No function matches the given name and argument types. You might need to add explicit type casts.
  Position: 230 [Failed SQL: (0) CREATE VIEW _cdsdbm_clone.pg_buffercache AS SELECT p.bufferid,
    p.relfilenode,
    p.reltablespace,
    p.reldatabase,
    p.relforknumber,
    p.relblocknumber,
    p.isdirty,
    p.usagecount,
    p.pinning_backends
   FROM pg_buffercache_pages() p(bufferid integer, relfilenode oid, reltablespace oid, reldatabase oid, relforknumber smallint, relblocknumber bigint, isdirty boolean, usagecount smallint, pinning_backends integer);]
	at liquibase.changelog.ChangeLogIterator.run(ChangeLogIterator.java:124)
	at liquibase.Liquibase.lambda$null$0(Liquibase.java:275)
	at liquibase.Scope.lambda$child$0(Scope.java:160)
	at liquibase.Scope.child(Scope.java:169)
	at liquibase.Scope.child(Scope.java:159)
	at liquibase.Scope.child(Scope.java:138)
	at liquibase.Scope.child(Scope.java:222)
	at liquibase.Liquibase.lambda$update$1(Liquibase.java:274)
	at liquibase.Scope.lambda$child$0(Scope.java:160)
	at liquibase.Scope.child(Scope.java:169)
	at liquibase.Scope.child(Scope.java:159)
	at liquibase.Scope.child(Scope.java:138)
	at liquibase.Liquibase.runInScope(Liquibase.java:2277)
	at liquibase.Liquibase.update(Liquibase.java:215)
	at liquibase.Liquibase.update(Liquibase.java:201)
	at liquibase.integration.commandline.Main.doMigration(Main.java:1760)
	at liquibase.integration.commandline.Main$1.lambda$run$0(Main.java:361)
	at liquibase.Scope.lambda$child$0(Scope.java:160)
	at liquibase.Scope.child(Scope.java:169)
	at liquibase.Scope.child(Scope.java:159)
	at liquibase.Scope.child(Scope.java:138)
	at liquibase.Scope.child(Scope.java:222)
	at liquibase.Scope.child(Scope.java:226)
	at liquibase.integration.commandline.Main$1.run(Main.java:360)
	at liquibase.integration.commandline.Main$1.run(Main.java:193)
	at liquibase.Scope.child(Scope.java:169)
	at liquibase.Scope.child(Scope.java:145)
	at liquibase.integration.commandline.Main.run(Main.java:193)
	at liquibase.integration.commandline.Main.main(Main.java:156)
Caused by: liquibase.exception.MigrationFailedException: Migration failed for change set tmp/_autodeploy.json::1605372539728-1::vcap (generated):
     Reason: liquibase.exception.DatabaseException: ERROR: function pg_buffercache_pages() does not exist
  Hint: No function matches the given name and argument types. You might need to add explicit type casts.
  Position: 230 [Failed SQL: (0) CREATE VIEW _cdsdbm_clone.pg_buffercache AS SELECT p.bufferid,
    p.relfilenode,
    p.reltablespace,
    p.reldatabase,
    p.relforknumber,
    p.relblocknumber,
    p.isdirty,
    p.usagecount,
    p.pinning_backends
   FROM pg_buffercache_pages() p(bufferid integer, relfilenode oid, reltablespace oid, reldatabase oid, relforknumber smallint, relblocknumber bigint, isdirty boolean, usagecount smallint, pinning_backends integer);]
	at liquibase.changelog.ChangeSet.execute(ChangeSet.java:670)
	at liquibase.changelog.visitor.UpdateVisitor.visit(UpdateVisitor.java:49)
	at liquibase.changelog.ChangeLogIterator$2.lambda$null$0(ChangeLogIterator.java:111)
	at liquibase.Scope.lambda$child$0(Scope.java:160)
	at liquibase.Scope.child(Scope.java:169)
	at liquibase.Scope.child(Scope.java:159)
	at liquibase.Scope.child(Scope.java:138)
	at liquibase.changelog.ChangeLogIterator$2.lambda$run$1(ChangeLogIterator.java:110)
	at liquibase.Scope.lambda$child$0(Scope.java:160)
	at liquibase.Scope.child(Scope.java:169)
	at liquibase.Scope.child(Scope.java:159)
	at liquibase.Scope.child(Scope.java:138)
	at liquibase.Scope.child(Scope.java:222)
	at liquibase.changelog.ChangeLogIterator$2.run(ChangeLogIterator.java:94)
	at liquibase.Scope.lambda$child$0(Scope.java:160)
	at liquibase.Scope.child(Scope.java:169)
	at liquibase.Scope.child(Scope.java:159)
	at liquibase.Scope.child(Scope.java:138)
	at liquibase.Scope.child(Scope.java:222)
	at liquibase.Scope.child(Scope.java:226)
	at liquibase.changelog.ChangeLogIterator.run(ChangeLogIterator.java:66)
	... 28 more
Caused by: liquibase.exception.DatabaseException: ERROR: function pg_buffercache_pages() does not exist
  Hint: No function matches the given name and argument types. You might need to add explicit type casts.
  Position: 230 [Failed SQL: (0) CREATE VIEW _cdsdbm_clone.pg_buffercache AS SELECT p.bufferid,
    p.relfilenode,
    p.reltablespace,
    p.reldatabase,
    p.relforknumber,
    p.relblocknumber,
    p.isdirty,
    p.usagecount,
    p.pinning_backends
   FROM pg_buffercache_pages() p(bufferid integer, relfilenode oid, reltablespace oid, reldatabase oid, relforknumber smallint, relblocknumber bigint, isdirty boolean, usagecount smallint, pinning_backends integer);]
	at liquibase.executor.jvm.JdbcExecutor$ExecuteStatementCallback.doInStatement(JdbcExecutor.java:398)
	at liquibase.executor.jvm.JdbcExecutor.execute(JdbcExecutor.java:82)
	at liquibase.executor.jvm.JdbcExecutor.execute(JdbcExecutor.java:154)
	at liquibase.database.AbstractJdbcDatabase.execute(AbstractJdbcDatabase.java:1272)
	at liquibase.database.AbstractJdbcDatabase.executeStatements(AbstractJdbcDatabase.java:1254)
	at liquibase.changelog.ChangeSet.execute(ChangeSet.java:635)
	... 48 more
Caused by: org.postgresql.util.PSQLException: ERROR: function pg_buffercache_pages() does not exist
  Hint: No function matches the given name and argument types. You might need to add explicit type casts.
  Position: 230
	at org.postgresql.core.v3.QueryExecutorImpl.receiveErrorResponse(QueryExecutorImpl.java:2497)
	at org.postgresql.core.v3.QueryExecutorImpl.processResults(QueryExecutorImpl.java:2233)
	at org.postgresql.core.v3.QueryExecutorImpl.execute(QueryExecutorImpl.java:310)
	at org.postgresql.jdbc.PgStatement.executeInternal(PgStatement.java:446)
	at org.postgresql.jdbc.PgStatement.execute(PgStatement.java:370)
	at org.postgresql.jdbc.PgStatement.executeWithFlags(PgStatement.java:311)
	at org.postgresql.jdbc.PgStatement.executeCachedSql(PgStatement.java:297)
	at org.postgresql.jdbc.PgStatement.executeWithFlags(PgStatement.java:274)
	at org.postgresql.jdbc.PgStatement.execute(PgStatement.java:269)
	at liquibase.executor.jvm.JdbcExecutor$ExecuteStatementCallback.doInStatement(JdbcExecutor.java:394)
	... 53 more
```

I've checked that the PostgreSQL extension [pg_buffercache](https://www.postgresql.org/docs/11/pgbuffercache.html) is active by running this commands via psql:

```
beershop=> CREATE EXTENSION IF NOT EXISTS pg_buffercache;
NOTICE:  extension "pg_buffercache" already exists, skipping
CREATE EXTENSION
beershop=> SELECT * FROM pg_extension;
      extname       | extowner | extnamespace | extrelocatable | extversion | extconfig | extcondition 
--------------------+----------+--------------+----------------+------------+-----------+--------------
 plpgsql            |       10 |           11 | f              | 1.0        |           | 
 pg_stat_statements |       10 |         2200 | t              | 1.6        |           | 
 pg_buffercache     |       10 |         2200 | t              | 1.3        |           | 
(3 rows)
```

## AWS

This is the first working deploy.