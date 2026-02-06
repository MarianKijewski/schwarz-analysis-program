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
  requests    : Association to many DocumentRequests on requests.supplier = $self;
}

// Provider entity
entity Providers : cuid, managed {
  name        : String(100) @mandatory;
  email       : String(100) @mandatory;
  phone       : String(20);
  company     : String(100);
  status      : String(20) default 'Active';
  emails      : Association to many Emails on emails.provider = $self;
  requests    : Association to many DocumentRequests on requests.provider = $self;
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
  request     : Association to DocumentRequests;
}

// Document Request entity (Renamed from Orders)
entity DocumentRequests : cuid, managed {
  requestNumber : String(50) @mandatory;
  description   : String(500);
  pageCount     : Integer;
  extractionConfidence : Decimal(5,2);
  requestDate   : DateTime @mandatory;
  status        : String(20) default 'Pending'; // Pending, Processed, Confirmed, Rejected
  supplier      : Association to Suppliers;
  provider      : Association to Providers;
  emails        : Association to many Emails on emails.request = $self;
  confirmation  : Association to ExtractionConfirmations on confirmation.request = $self;
  extractedData : Association to many ExtractedData on extractedData.request = $self;
}

// Extracted Data entity (Renamed from OrderItems)
entity ExtractedData : cuid {
  request     : Association to DocumentRequests;
  fieldName   : String(100);
  fieldValue  : String(500);
  confidence  : Decimal(5,2);
}

// Confirmation entity (Renamed from OrderConfirmations)
entity ExtractionConfirmations : cuid, managed {
  request       : Association to DocumentRequests;
  confirmedBy   : String(100);
  confirmedDate : DateTime;
  status        : String(20) default 'Pending';
  notes         : String(1000);
}