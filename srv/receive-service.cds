using { forty.two.transfer as my } from '../db/schema';

service ReceiveService {
  @readonly entity Email as select from my.Email {
    *, sender.email as sender
  } excluding { createdBy, modifiedBy };
}
