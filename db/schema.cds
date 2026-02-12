namespace com.schwarz.app;

using { cuid, managed } from '@sap/cds/common';

entity Users : cuid {
  name        : String @mandatory;
  email       : String @mandatory;
  documents   : Association to many Documents on documents.recipient = $self;
}

entity Documents : cuid, managed {
  recipient : Association to Users;
  status    : Status default 'Draft';
  Records   : Composition of many DocumentRecords on Records.parent = $self;
}

entity DocumentRecords : cuid {
  key parent  : Association to Documents;
  key name    : String;
  quantity    : Integer;
}

type Status: String enum {
  Draft;
  Pending;
  Received;
  Rejected;
  Accepted;
  Expired;
}
