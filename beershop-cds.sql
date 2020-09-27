
CREATE TABLE csw_Beers (
  ID NVARCHAR(36) NOT NULL,
  name NVARCHAR(100),
  abv DECIMAL(3, 1),
  ibu INTEGER,
  brewery_ID NVARCHAR(36),
  PRIMARY KEY(ID)
);

CREATE TABLE csw_Brewery (
  ID NVARCHAR(36) NOT NULL,
  name NVARCHAR(150),
  PRIMARY KEY(ID)
);

CREATE TABLE csw_TypeChecks (
  ID NVARCHAR(36) NOT NULL,
  type_Boolean BOOLEAN,
  type_Int32 INTEGER,
  type_Int64 BIGINT,
  type_Decimal DECIMAL(2, 1),
  type_Double DOUBLE,
  type_Date DATE,
  type_Time TIME,
  type_DateTime TIMESTAMP,
  type_Timestamp TIMESTAMP,
  type_String NVARCHAR(5000),
  type_Binary CHAR(100),
  type_LargeBinary BLOB,
  type_LargeString NCLOB,
  PRIMARY KEY(ID)
);

CREATE VIEW BeershopAdminService_Beers AS SELECT
  Beers_0.ID,
  Beers_0.name,
  Beers_0.abv,
  Beers_0.ibu,
  Beers_0.brewery_ID
FROM csw_Beers AS Beers_0;

CREATE VIEW BeershopAdminService_Breweries AS SELECT
  Brewery_0.ID,
  Brewery_0.name
FROM csw_Brewery AS Brewery_0;

CREATE VIEW BeershopAdminService_TypeChecks AS SELECT
  TypeChecks_0.ID,
  TypeChecks_0.type_Boolean,
  TypeChecks_0.type_Int32,
  TypeChecks_0.type_Int64,
  TypeChecks_0.type_Decimal,
  TypeChecks_0.type_Double,
  TypeChecks_0.type_Date,
  TypeChecks_0.type_Time,
  TypeChecks_0.type_DateTime,
  TypeChecks_0.type_Timestamp,
  TypeChecks_0.type_String,
  TypeChecks_0.type_Binary,
  TypeChecks_0.type_LargeBinary,
  TypeChecks_0.type_LargeString
FROM csw_TypeChecks AS TypeChecks_0;

CREATE VIEW BeershopService_Beers AS SELECT
  Beers_0.ID,
  Beers_0.name,
  Beers_0.abv,
  Beers_0.ibu,
  Beers_0.brewery_ID
FROM csw_Beers AS Beers_0;

CREATE VIEW BeershopService_Breweries AS SELECT
  Brewery_0.ID,
  Brewery_0.name
FROM csw_Brewery AS Brewery_0;

CREATE VIEW BeershopService_TypeChecks AS SELECT
  TypeChecks_0.ID,
  TypeChecks_0.type_Boolean,
  TypeChecks_0.type_Int32,
  TypeChecks_0.type_Int64,
  TypeChecks_0.type_Decimal,
  TypeChecks_0.type_Double,
  TypeChecks_0.type_Date,
  TypeChecks_0.type_Time,
  TypeChecks_0.type_DateTime,
  TypeChecks_0.type_Timestamp,
  TypeChecks_0.type_String,
  TypeChecks_0.type_Binary,
  TypeChecks_0.type_LargeBinary,
  TypeChecks_0.type_LargeString
FROM csw_TypeChecks AS TypeChecks_0;

