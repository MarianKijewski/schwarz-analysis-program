namespace com.schwarz.app;

using { cuid, managed } from '@sap/cds/common';

entity Users : cuid {
  name        : String;
  email       : String;
  documents   : Association to many Documents on documents.recipient = $self;
}

entity Documents : cuid, managed {
  recipient : Association to Users;
  @readonly status    : Status default 'Draft';
  Records   : Composition of many DocumentRecords on Records.parent = $self;
}

entity DocumentRecords : cuid {
  key parent  : Association to Documents;
  name        : String;
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
