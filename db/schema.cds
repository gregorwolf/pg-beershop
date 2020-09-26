namespace csw;
using { cuid } from '@sap/cds/common';

entity Beers : cuid {
  name: String(100) @( title: '{i18n>BeerName}' );
  abv: Decimal(3, 1) @( title: '{i18n>abv}' );
  ibu: Integer @( title: '{i18n>ibu}', description : '{i18n>ibuDescription}' );
  brewery: Association to one Brewery;
}

entity Brewery : cuid {
  name:  String(150) @( title: '{i18n>BreweryName}' );
  beers: Association to many Beers on beers.brewery = $self;
}

annotate Beers with @(
  UI: {
    SelectionFields: [ name, abv, ibu ],
    LineItem: [
      {Value: name},
      {Value: abv},
      {Value: ibu},
    ],
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
