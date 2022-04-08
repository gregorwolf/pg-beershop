namespace csw;

using {cuid} from '@sap/cds/common';

entity Beers : cuid {
  name    : String(100)   @(title : '{i18n>BeerName}');
  abv     : Decimal(3, 1) @(title : '{i18n>abv}');
  ibu     : Integer       @(
    title       : '{i18n>ibu}',
    description : '{i18n>ibuDescription}'
  );
  brewery : Association to one Brewery;
};

entity Brewery : cuid {
  name  : String(150) @(title : '{i18n>BreweryName}');
  beers : Association to many Beers
            on beers.brewery = $self;
};

@Aggregation.ApplySupported.PropertyRestrictions : true
entity BreweryAnalytics as projection on Brewery {
  ID,
  @Analytics.Dimension : true
  name       as breweryname,
  @Analytics.Dimension : true
  beers.name as beername,
  @Analytics.Measure   : true
  @Aggregation.default : #SUM
  1          as lines : Integer
};

entity TypeChecks : cuid {
  type_Boolean     : Boolean       @(title : '{i18n>type_Boolean}');
  type_Int32       : Integer       @(title : '{i18n>type_Int32}');
  type_Int64       : Integer64     @(title : '{i18n>type_Int64}');
  type_Decimal     : Decimal(2, 1) @(title : '{i18n>type_Decimal}');
  type_Double      : Double        @(title : '{i18n>type_Double}');
  type_Date        : Date          @(title : '{i18n>type_Date}');
  type_Time        : Time          @(title : '{i18n>type_Time}');
  type_DateTime    : DateTime      @(title : '{i18n>type_DateTime}');
  type_Timestamp   : Timestamp     @(title : '{i18n>type_Timestamp}');
  type_String      : String        @(title : '{i18n>type_String}');
  type_Binary      : Binary(100)   @(title : '{i18n>type_Binary}');
  type_LargeBinary : LargeBinary   @(title : '{i18n>type_LargeBinary}');
  type_LargeString : LargeString   @(title : '{i18n>type_LargeString}');
  kyma_1           : Integer;
};
