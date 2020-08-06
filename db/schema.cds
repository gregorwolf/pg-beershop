namespace csw;
using { cuid } from '@sap/cds/common';

entity Beers : cuid {
  name: String(100)
}