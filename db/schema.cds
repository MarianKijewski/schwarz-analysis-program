using { cuid, managed } from '@sap/cds/common';
namespace sap.cap.orders;

entity Orders : cuid, managed {
  items : Composition of many {
    key name        : String;
    quantity    : Integer;
    price       : Price;
  }
  status  : Status
}

type Status : String enum {
    Pending;
    Received;
    Rejected;
    Accepted;
    Expired;
}

type Price : Decimal(9,2);
