using { com.schwarz.app as db } from '../db/schema';

// Service for Suppliers
service SupplierService @(path: '/supplier') {
  @readonly entity Suppliers as projection on db.Suppliers;
  
  entity MyEmails as projection on db.Emails 
    where supplier.ID = $user.id;

  // The Action is now INSIDE "actions { ... }"
  entity MyRequests as projection on db.DocumentRequests 
    where supplier.ID = $user.id
  actions {
      action confirmExtraction() returns MyConfirmations;
  };
  
  entity MyConfirmations as projection on db.ExtractionConfirmations;
  entity ExtractedData as projection on db.ExtractedData;
  
  action updateRequest(requestID: UUID, updates: String) returns MyRequests;
}

// Service for Providers
service ProviderService @(path: '/provider') {
  @readonly entity Providers as projection on db.Providers;
  
  entity MyEmails as projection on db.Emails 
    where provider.ID = $user.id;
    
  entity MyRequests as projection on db.DocumentRequests 
    where provider.ID = $user.id;
  
  entity MyConfirmations as projection on db.ExtractionConfirmations;
  entity ExtractedData as projection on db.ExtractedData;
  
  action updateRequest(requestID: UUID, updates: String) returns MyRequests;
  action confirmExtraction(requestID: UUID) returns MyConfirmations;
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