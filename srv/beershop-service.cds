using {csw} from '../db/schema';

service BeershopAdminService @(requires : 'admin') {
  entity Beers               as projection on csw.Beers;

  @odata.draft.enabled
  entity Breweries           as projection on csw.Brewery;

  entity TypeChecks          as projection on csw.TypeChecks;

  @odata.draft.enabled
  entity TypeChecksWithDraft as projection on csw.TypeChecks;
}

@(requires : 'authenticated-user')
service BeershopService {
  @readonly
  entity Beers                                      as projection on csw.Beers;

  @readonly
  entity Breweries @(cds.redirection.target : true) as projection on csw.Brewery;

  @readonly
  entity BreweryAnalytics                           as projection on csw.BreweryAnalytics;

  @readonly
  entity TypeChecks                                 as projection on csw.TypeChecks;

  @readonly
  entity UserScopes {
    key username : String;
        is_admin : Boolean;
  };
}
