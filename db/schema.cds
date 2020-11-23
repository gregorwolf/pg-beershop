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
  type_Boolean     : Boolean @( title: '{i18n>type_Boolean}' );
  type_Int32       : Integer @( title: '{i18n>type_Int32}' );
  type_Int64       : Integer64 @( title: '{i18n>type_Int64}' );
  type_Decimal     : Decimal(2, 1) @( title: '{i18n>type_Decimal}' );
  type_Double      : Double @( title: '{i18n>type_Double}' );
  type_Date        : Date @( title: '{i18n>type_Date}' );
  type_Time        : Time @( title: '{i18n>type_Time}' );
  type_DateTime    : DateTime @( title: '{i18n>type_DateTime}' );
  type_Timestamp   : Timestamp @( title: '{i18n>type_Timestamp}' );
  type_String      : String @( title: '{i18n>type_String}' );
  type_Binary      : Binary(100) @( title: '{i18n>type_Binary}' );
  type_LargeBinary : LargeBinary @( title: '{i18n>type_LargeBinary}' );
  type_LargeString : LargeString @( title: '{i18n>type_LargeString}' );
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

annotate TypeChecks with @(
  UI: {
    SelectionFields: [ type_String, type_Date ],
    LineItem: [
      {Value: ID},
      {Value: type_Boolean},
      {Value: type_Int32},
      {Value: type_Date}
    ],
    HeaderInfo: {
      TypeName: '{i18n>TypeCheck}', TypeNamePlural: '{i18n>TypeChecks}',
      Title: { Value: type_String },
      Description: { Value: type_String }
    },
    Facets: [
      {$Type: 'UI.ReferenceFacet', Label: '{i18n>Details}', Target: '@UI.FieldGroup#Details'},
    ],
    FieldGroup#Details: {
      Data: [
      {Value: ID},
      {Value: type_Boolean},
      {Value: type_Int32},
      {Value: type_Int64},
      {Value: type_Decimal},
      {Value: type_Double},
      {Value: type_Date},
      {Value: type_Time},
      {Value: type_DateTime},
      {Value: type_Timestamp},
      {Value: type_String},
      {Value: type_LargeString}
      ]
    }
  },
);
// Workaround for Pop-Up
annotate TypeChecks with {
    ID @Core.Computed;
}