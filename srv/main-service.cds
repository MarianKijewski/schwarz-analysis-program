using { com.schwarz.app as db } from '../db/schema';

// Service for Suppliers
service SupplierService @(path: '/supplier') {
  @readonly entity Suppliers as projection on db.Suppliers;
  
  entity MyEmails as projection on db.Emails 
    where supplier.ID = $user.id;

  // Supplier Requests with Bound Action
  entity MyRequests as projection on db.DocumentRequests 
    // where supplier.ID = $user.id  <-- Keep commented out for easy testing
  actions {
      action confirmExtraction() returns MyConfirmations;
  };
  
  entity MyConfirmations as projection on db.ExtractionConfirmations;
  entity ExtractedData as projection on db.ExtractedData;
  
  action updateRequest(requestID: UUID, updates: String) returns MyRequests;
}

// Service for Providers (FIXED)
service ProviderService @(path: '/provider') {
  @readonly entity Providers as projection on db.Providers;
  
  entity MyEmails as projection on db.Emails 
    where provider.ID = $user.id;
    
  // Provider Requests with Bound Action (Moved Inside!)
  entity MyRequests as projection on db.DocumentRequests 
    // where provider.ID = $user.id <-- Keep commented out for easy testing
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
  entity Providers as projection on db.Providers;
  entity Emails as projection on db.Emails;
  entity DocumentRequests as projection on db.DocumentRequests;
  entity ExtractionConfirmations as projection on db.ExtractionConfirmations;
  entity ExtractedData as projection on db.ExtractedData;
}