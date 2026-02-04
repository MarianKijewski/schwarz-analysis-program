using { cuid, managed } from '@sap/cds/common';
namespace forty.two.transfer;

entity Actor : cuid {
  email : String;
}

entity Email : cuid, managed {
  sender    : Association to Actor;
  recipient : Association to Actor;
  link      : String;
}
