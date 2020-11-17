# DB Deployment using cds-dbm with combined NodeJS and Java buildpacks

Until cds-dbm supports provisioning with the generated *csn.json* you have to copy the content of your db and srv folder *db-deployer-java/src/main/resources*. Until I find a way to execute the maven build via the mta.yaml you have to execute:

```
mvn clean package
```

in the *db-deployer-java* folder.
