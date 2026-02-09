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

// RETAILER entity (Formerly Provider)
entity Retailers : cuid, managed {
  name        : String(100) @mandatory;
  email       : String(100) @mandatory;
  phone       : String(20);
  company     : String(100);
  status      : String(20) default 'Active';
  emails      : Association to many Emails on emails.retailer = $self;
  requests    : Association to many DocumentRequests on requests.retailer = $self;
}

// Email tracking
entity Emails : cuid, managed {
  subject     : String(200) @mandatory;
  body        : String(5000);
  sentDate    : DateTime @mandatory;
  status      : String(20) default 'Sent'; 
  recipient   : String(100) @mandatory;
  sender      : String(100);
  supplier    : Association to Suppliers;
  retailer    : Association to Retailers; // Renamed
  request     : Association to DocumentRequests;
}

// Document Requests
entity DocumentRequests : cuid, managed {
  requestNumber : String(50) @mandatory;
  description   : String(500);
  pageCount     : Integer;
  extractionConfidence : Decimal(5,2);
  requestDate   : DateTime @mandatory;
  status        : String(20) default 'Pending'; 
  supplier      : Association to Suppliers;
  retailer      : Association to Retailers; // Renamed
  emails        : Association to many Emails on emails.request = $self;
  confirmation  : Association to ExtractionConfirmations on confirmation.request = $self;
  extractedData : Association to many ExtractedData on extractedData.request = $self;
}

entity ExtractedData : cuid {
  request     : Association to DocumentRequests;
  fieldName   : String(100);
  fieldValue  : String(500);
  confidence  : Decimal(5,2);
}

entity ExtractionConfirmations : cuid, managed {
  request       : Association to DocumentRequests;
  confirmedBy   : String(100);
  confirmedDate : DateTime;
  status        : String(20) default 'Pending';
  notes         : String(1000);
}