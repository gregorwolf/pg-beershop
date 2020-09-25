using { csw } from '../db/schema';

service BeershopAdminService @(requires:'admin')  {
  entity Beers as projection on csw.Beers;
  entity Breweries as projection on csw.Brewery;
}

service BeershopService {
  @readonly
  entity Beers as projection on csw.Beers;
  @readonly
  entity Breweries as projection on csw.Brewery;
}