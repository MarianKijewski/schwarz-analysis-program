using { cuid, managed } from '@sap/cds/common';
namespace sap.cap.orders;

entity Orders : cuid, managed {
  Items   : Composition of many OrderItems on Items.order = $self;
  status  : Status
}

entity OrderItems {
  key order   : Association to Orders;
  key name    : String;
  quantity    : Integer;
  price       : Price;
}

type Status : String enum {
    Pending;
    Received;
    Rejected;
    Accepted;
    Expired;
}

type Price : Decimal(9,2);
