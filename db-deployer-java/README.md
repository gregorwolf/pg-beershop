# DB Deployment using cds-dbm with combined NodeJS and Java buildpacks

Until cds-dbm supports provisioning with the generated *csn.json* you have to copy the content of your db and srv folder *db-deployer-java/src/main/resources*. Until I find a way to execute the maven build via the mta.yaml you have to execute:

```
mvn clean package
```

in the *db-deployer-java* folder.

## SAP Cloud Platform Trial, PostgreSQL Hyperscaler Option

Currently the deployment fails with this error:

```
Starting Liquibase at 20:59:47 (version 4.1.0 #3 built at 2020-09-28 21:02+0000)
Unexpected error running Liquibase: Migration failed for change set tmp/_autodeploy.json::1605646772955-1::vcap (generated):
     Reason: liquibase.exception.DatabaseException: ERROR: function pg_stat_statements(boolean) does not exist
  Hint: No function matches the given name and argument types. You might need to add explicit type casts.
  Position: 903 [Failed SQL: (0) CREATE VIEW _cdsdbm_clone.pg_stat_statements AS SELECT pg_stat_statements.userid,
    pg_stat_statements.dbid,
    pg_stat_statements.queryid,
    pg_stat_statements.query,
    pg_stat_statements.calls,
    pg_stat_statements.total_time,
    pg_stat_statements.min_time,
    pg_stat_statements.max_time,
    pg_stat_statements.mean_time,
    pg_stat_statements.stddev_time,
    pg_stat_statements.rows,
    pg_stat_statements.shared_blks_hit,
    pg_stat_statements.shared_blks_read,
    pg_stat_statements.shared_blks_dirtied,
    pg_stat_statements.shared_blks_written,
    pg_stat_statements.local_blks_hit,
    pg_stat_statements.local_blks_read,
    pg_stat_statements.local_blks_dirtied,
    pg_stat_statements.local_blks_written,
    pg_stat_statements.temp_blks_read,
    pg_stat_statements.temp_blks_written,
    pg_stat_statements.blk_read_time,
    pg_stat_statements.blk_write_time
   FROM pg_stat_statements(true) pg_stat_statements(userid, dbid, queryid, query, calls, total_time, min_time, max_time, mean_time, stddev_time, rows, shared_blks_hit, shared_blks_read, shared_blks_dirtied, shared_blks_written, local_blks_hit, local_blks_read, local_blks_dirtied, local_blks_written, temp_blks_read, temp_blks_written, blk_read_time, blk_write_time);]
For more information, please use the --logLevel flag
```