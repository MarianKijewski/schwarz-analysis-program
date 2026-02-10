namespace com.schwarz.app;

using { cuid, managed } from '@sap/cds/common';

// 1. Suppliers: Οι συνεργάτες σου
entity Suppliers : cuid, managed {
  name        : String(100) @mandatory;
  email       : String(100) @mandatory;
  phone       : String(20);
  status      : String(20) default 'Active';
  provider    : String(100);
  // Σύνδεση με παραγγελίες
  requests    : Association to many DocumentRequests on requests.supplier = $self;
}

// 2. Providers: Εσύ (Η Εταιρεία)
entity Providers : cuid, managed {
  name        : String(100) @mandatory;
  email       : String(100) @mandatory;
  phone       : String(20);
  status      : String(20) default 'Active';
  // Ο Provider βλέπει όλες τις παραγγελίες
  allRequests : Association to many DocumentRequests on allRequests.provider = $self;
}

// 3. DocumentRequests: Οι Παραγγελίες (Εδώ διορθώθηκαν τα πεδία που έλειπαν)
entity DocumentRequests : cuid, managed {
  requestNumber        : String(50) @mandatory;
  description          : String(500);
  requestDate          : DateTime;   
  status               : Status default 'Draft';
  // Associations
  supplier             : Association to Suppliers; 
  provider             : Association to Providers; 
  extractedData        : Composition of many ExtractedData on extractedData.request = $self;
}

// 4. ExtractedData: Τα "Προϊόντα" μέσα στην παραγγελία
entity ExtractedData : cuid {
  request     : Association to DocumentRequests;
  fieldName   : String(100); // Όνομα προϊόντος/πεδίου
  fieldValue  : String(500); // Τιμή/Ποσότητα
}

entity ExtractionConfirmations : cuid, managed {
  request       : Association to DocumentRequests;
  confirmedBy   : String(100);
  confirmedDate : DateTime;
  status        : Status default 'Draft';
  notes         : String(1000);
}

type Status: String enum {
  Draft;
  Pending;
  Received;
  Rejected;
  Accepted;
  Expired;
  Edited;
}