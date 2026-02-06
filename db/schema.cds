namespace com.schwarz.app;

using { cuid, managed } from '@sap/cds/common';

// Supplier entity
entity Suppliers : cuid, managed {
  name        : String(100) @mandatory;
  email       : String(100) @mandatory;
  phone       : String(20);
  company     : String(100);
  status      : String(20) default 'Active';
  emails      : Association to many Emails on emails.supplier = $self;
  orders      : Association to many Orders on orders.supplier = $self;
}

// Provider entity
entity Providers : cuid, managed {
  name        : String(100) @mandatory;
  email       : String(100) @mandatory;
  phone       : String(20);
  company     : String(100);
  status      : String(20) default 'Active';
  emails      : Association to many Emails on emails.provider = $self;
  orders      : Association to many Orders on orders.provider = $self;
}

// Email tracking entity
entity Emails : cuid, managed {
  subject     : String(200) @mandatory;
  body        : String(5000);
  sentDate    : DateTime @mandatory;
  status      : String(20) default 'Sent'; // Sent, Delivered, Read, Failed
  recipient   : String(100) @mandatory;
  sender      : String(100);
  supplier    : Association to Suppliers;
  provider    : Association to Providers;
  order       : Association to Orders;
}

// Order entity
entity Orders : cuid, managed {
  orderNumber : String(50) @mandatory;
  description : String(500);
  quantity    : Integer;
  amount      : Decimal(15,2);
  orderDate   : DateTime @mandatory;
  status      : String(20) default 'Draft'; // Draft, Pending, Confirmed, Cancelled
  supplier    : Association to Suppliers;
  provider    : Association to Providers;
  emails      : Association to many Emails on emails.order = $self;
  confirmation: Association to OrderConfirmations on confirmation.order = $self;
  items       : Association to many OrderItems on items.order = $self;
}

// Order items for detailed line items
entity OrderItems : cuid {
  order       : Association to Orders;
  lineNumber  : Integer;
  product     : String(100);
  description : String(500);
  quantity    : Integer;
  unitPrice   : Decimal(15,2);
  totalPrice  : Decimal(15,2);
}

// Order confirmation entity
entity OrderConfirmations : cuid, managed {
  order         : Association to Orders;
  confirmedBy   : String(100);
  confirmedDate : DateTime;
  status        : String(20) default 'Pending'; // Pending, Confirmed, Rejected
  notes         : String(1000);
}
