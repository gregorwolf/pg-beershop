using { csw } from '../db/schema';

service BeershopService {

  entity Beers as projection on csw.Beers;

}