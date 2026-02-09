using { com.schwarz.app as db } from '../db/schema';

// 1. SUPPLIER SERVICE (Restricted to 'Supplier' Role)
service SupplierService @(path: '/supplier', requires: 'Supplier') {
  
  @readonly entity Suppliers as projection on db.Suppliers;
  
  entity MyEmails as projection on db.Emails 
    where supplier.ID = $user.id;

  entity MyRequests as projection on db.DocumentRequests 
    where supplier.ID = $user.id
  actions {
      action confirmExtraction() returns MyConfirmations;
  };
  
  entity MyConfirmations as projection on db.ExtractionConfirmations;
  entity ExtractedData as projection on db.ExtractedData;
  
  action updateRequest(requestID: UUID, updates: String) returns MyRequests;
}

// 2. RETAILER SERVICE (Restricted to 'Retailer' Role)
service RetailerService @(path: '/retailer', requires: 'Retailer') {
  
  @readonly entity Retailers as projection on db.Retailers;
  
  entity MyEmails as projection on db.Emails;
    
  // Retailer sees ALL requests
  entity MyRequests as projection on db.DocumentRequests 
  actions {
      action confirmExtraction() returns MyConfirmations;
  };
  
  entity MyConfirmations as projection on db.ExtractionConfirmations;
  entity ExtractedData as projection on db.ExtractedData;
  
  action updateRequest(requestID: UUID, updates: String) returns MyRequests;
}

// 3. ADMIN SERVICE
service AdminService @(path: '/admin') {
  entity Suppliers as projection on db.Suppliers;
  entity Retailers as projection on db.Retailers;
  entity Emails as projection on db.Emails;
  entity DocumentRequests as projection on db.DocumentRequests;
  entity ExtractionConfirmations as projection on db.ExtractionConfirmations;
  entity ExtractedData as projection on db.ExtractedData;
}