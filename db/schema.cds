namespace csw;
using { cuid } from '@sap/cds/common';

entity Beers : cuid {
  name    : String(100) @( title: '{i18n>BeerName}' );
  abv     : Decimal(3, 1) @( title: '{i18n>abv}' );
  ibu     : Integer @( title: '{i18n>ibu}', description : '{i18n>ibuDescription}' );
  brewery : Association to one Brewery;
}

entity Brewery : cuid {
  name  : String(150) @( title: '{i18n>BreweryName}' );
  beers : Association to many Beers on beers.brewery = $self;
}

// Workaround for the pop-up during creation
annotate Brewery with {
  ID @Core.Computed;
}

entity TypeChecks : cuid {
  type_Boolean     : Boolean;
  type_Int32       : Integer;
  type_Int64       : Integer64;
  type_Decimal     : Decimal(2, 1);
  type_Double      : Double;
  type_Date        : Date;
  type_Time        : Time;
  type_DateTime    : DateTime;
  type_Timestamp   : Timestamp;
  type_String      : String;
  type_Binary      : Binary(100);
  type_LargeBinary : LargeBinary;
  type_LargeString : LargeString;
}

annotate Beers with @(
  UI: {
    SelectionFields: [ name, abv, ibu ],
    LineItem: [
      {Value: name},
      {Value: abv},
      {Value: ibu},
    ],
    HeaderInfo: {
      TypeName: '{i18n>Beer}', TypeNamePlural: '{i18n>Beers}',
      Title: { Value: name },
      Description: { Value: brewery.name }
    },
    Facets: [
      {$Type: 'UI.ReferenceFacet', Label: '{i18n>Details}', Target: '@UI.FieldGroup#Details'},
    ],
    FieldGroup#Details: {
      Data: [
        {Value: name},
        {Value: brewery.name},
        {Value: abv},
        {Value: ibu},
      ]
    }
  }
);

annotate Brewery with @(
  UI: {
    SelectionFields: [ name ],
    LineItem: [
      {Value: name}
    ],
    HeaderInfo: {
      TypeName: '{i18n>Brewery}', TypeNamePlural: '{i18n>Breweries}',
      Title: { Value: name },
      Description: { Value: name }
    },
    Facets: [
      {$Type: 'UI.ReferenceFacet', Label: '{i18n>Details}', Target: '@UI.FieldGroup#Details'},
      {$Type: 'UI.ReferenceFacet', Label: '{i18n>Beers}', Target: 'beers/@UI.LineItem'},
    ],
    FieldGroup#Details: {
      Data: [
        {Value: name},
      ]
    }
  },
);
