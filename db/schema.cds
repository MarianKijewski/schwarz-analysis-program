namespace com.schwarz.app;
using { managed } from '@sap/cds/common';

// 1. Supplier (Changed ID to String to match '101')
entity Suppliers : managed {
  key ID      : String; // <--- THIS IS THE FIX
  name        : String(100);
  email       : String(100);
  phone       : String(20);
  company     : String(100);
  status      : String(20) default 'Active';
  emails      : Association to many Emails on emails.supplier = $self;
  requests    : Association to many DocumentRequests on requests.supplier = $self;
}

// 2. Retailer (Changed ID to String)
entity Retailers : managed {
  key ID      : String; // <--- THIS IS THE FIX
  name        : String(100);
  email       : String(100);
  phone       : String(20);
  company     : String(100);
  status      : String(20) default 'Active';
  emails      : Association to many Emails on emails.retailer = $self;
  requests    : Association to many DocumentRequests on requests.retailer = $self;
}

// 3. DocumentRequests (Changed ID to String)
entity DocumentRequests : managed {
  key ID        : String; // <--- THIS IS THE FIX
  requestNumber : String(50);
  description   : String(500);
  pageCount     : Integer;
  extractionConfidence : Decimal(5,2);
  requestDate   : DateTime;
  status        : String(20) default 'Pending'; 
  supplier      : Association to Suppliers;
  retailer      : Association to Retailers;
  emails        : Association to many Emails on emails.request = $self;
  confirmation  : Association to ExtractionConfirmations on confirmation.request = $self;
  extractedData : Association to many ExtractedData on extractedData.request = $self;
}

// Helpers
entity Emails : managed {
  key ID : String;
  subject : String(200);
  body : String(5000);
  sentDate : DateTime;
  status : String(20); 
  recipient : String(100);
  sender : String(100);
  supplier : Association to Suppliers;
  retailer : Association to Retailers;
  request : Association to DocumentRequests;
}

entity ExtractedData : managed {
  key ID : String;
  request : Association to DocumentRequests;
  fieldName : String(100);
  fieldValue : String(500);
  confidence : Decimal(5,2);
}

entity ExtractionConfirmations : managed {
  key ID : String;
  request : Association to DocumentRequests;
  confirmedBy : String(100);
  confirmedDate : DateTime;
  status : String(20);
  notes : String(1000);
}