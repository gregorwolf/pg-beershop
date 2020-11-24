using { csw } from '../db/schema';
// Workaround for the pop-up during creation
annotate csw.Brewery with {
  ID @Core.Computed;
}

annotate csw.Beers with @(
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

annotate csw.Brewery with @(
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

annotate csw.TypeChecks with @(
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
annotate csw.TypeChecks with {
    ID @Core.Computed;
}