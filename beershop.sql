CREATE TABLE "csw_Beers" (
  "ID" CHAR(36) NOT NULL,
  "name" CHAR(100),
  PRIMARY KEY("ID")
);

CREATE VIEW "BeershopService_Beers" AS SELECT
  Beers_0."ID",
  Beers_0."name"
FROM "csw_Beers" AS Beers_0;

INSERT INTO "csw_Beers" ("ID", "name")
VALUES ('b8c3fc14-22e2-4f42-837a-e6134775a186','Augustiner Hell');

SELECT "ID", "name" FROM "BeershopService_Beers" AS "Beers";