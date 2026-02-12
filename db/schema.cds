namespace com.schwarz.app;

using { cuid, managed } from '@sap/cds/common';

entity Users : cuid, managed {
  name        : String @mandatory;
  email       : String @mandatory;
  documents   : Association to many Documents;
}

entity Documents : cuid, managed {
  status               : Status default 'Draft';
  extractedData        : Composition of many DocumentRecords;
}

entity DocumentRecords : cuid {
  name      : String;
  quantity  : Integer;
}

type Status: String enum {
  Draft;
  Pending;
  Received;
  Rejected;
  Accepted;
  Expired;
}
