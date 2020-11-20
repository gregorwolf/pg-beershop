using { csw } from '../db/schema';

service BeershopAdminService @(requires:'admin')  {
  entity Beers as projection on csw.Beers;
  @odata.draft.enabled
  entity Breweries as projection on csw.Brewery;
  entity TypeChecks as projection on csw.TypeChecks;
  @odata.draft.enabled
  entity TypeChecksWithDraft as projection on csw.TypeChecks;
}

service BeershopService {
  @readonly
  entity Beers as projection on csw.Beers;
  @readonly
  entity Breweries as projection on csw.Brewery;
  @readonly
  entity TypeChecks as projection on csw.TypeChecks;
}