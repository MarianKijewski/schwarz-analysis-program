using { com.schwarz.app as db } from '../db/schema';

// Service for Suppliers
service SupplierService @(path: '/supplier') {
  @readonly entity Suppliers as projection on db.Suppliers;
  
  entity MyEmails as projection on db.Emails 
    where supplier.ID = $user.id;

  entity MyRequests as projection on db.DocumentRequests 
    // where supplier.ID = $user.id  <-- Security disabled for testing
  actions {
      action confirmExtraction() returns MyConfirmations;
  };
  
  entity MyConfirmations as projection on db.ExtractionConfirmations;
  entity ExtractedData as projection on db.ExtractedData;
  
  action updateRequest(requestID: UUID, updates: String) returns MyRequests;
}

// Service for RETAILERS (Renamed)
service RetailerService @(path: '/retailer') {
  @readonly entity Retailers as projection on db.Retailers;
  
  entity MyEmails as projection on db.Emails 
    where retailer.ID = $user.id;
    
  entity MyRequests as projection on db.DocumentRequests 
    // where retailer.ID = $user.id <-- Security disabled for testing
  actions {
      action confirmExtraction() returns MyConfirmations;
  };
  
  entity MyConfirmations as projection on db.ExtractionConfirmations;
  entity ExtractedData as projection on db.ExtractedData;
  
  action updateRequest(requestID: UUID, updates: String) returns MyRequests;
}

// Admin service
service AdminService @(path: '/admin') {
  entity Suppliers as projection on db.Suppliers;
  entity Retailers as projection on db.Retailers; // Renamed
  entity Emails as projection on db.Emails;
  entity DocumentRequests as projection on db.DocumentRequests;
  entity ExtractionConfirmations as projection on db.ExtractionConfirmations;
  entity ExtractedData as projection on db.ExtractedData;
}