using { com.schwarz.app as db } from '../db/schema';

service InternalService {
  entity Documents as projection on db.Documents;
  @readonly
  entity Recipients as projection on db.Users;

  action sendEmail();
}
annotate InternalService.Documents with @odata.draft.enabled; 
