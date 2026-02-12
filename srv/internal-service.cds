using { com.schwarz.app as db } from '../db/schema';

service InternalService {
  entity Documents as projection on db.Documents;
  @readonly
  entity Recipients as projection on db.Users;
}
