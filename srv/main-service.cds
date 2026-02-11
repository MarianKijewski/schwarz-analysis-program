using { com.schwarz.app as db } from '../db/schema';

// === 1. Service for Suppliers (Portal Προμηθευτών) ===
service SupplierService @(path: '/supplier') {
  @readonly entity Suppliers as projection on db.Suppliers;
  
  entity MyRequests as projection on db.DocumentRequests {
      ID,
      *,
      case 
        when status = 'Pending' then 2
        when status = 'Recived' then 2
        when status = 'Confirmed' then 3
        when status = 'Rejected' then 1
        else 0 
      end as statusControl : Integer,
      supplier.name as supplierName,
      extractedData : redirected to ExtractedData
  } actions {
      action confirmExtraction() returns MyConfirmations;
      action markAsReceived() returns MyRequests;
      action confirmRequest() returns MyRequests;
      action rejectRequest() returns MyRequests;
  };
  
  entity ExtractedData as projection on db.ExtractedData;
  entity MyConfirmations as projection on db.ExtractionConfirmations;

}

annotate SupplierService.MyRequests with @odata.draft.enabled;
// === 2. Service for Providers (Portal Εταιρείας / Admin) ===
service ProviderService @(path: '/provider') {
  @readonly 
  entity Providers as projection on db.Providers;
  
  entity MyRequests as projection on db.DocumentRequests {
      ID,
      *,
      supplier.name  as supplierName, 
      supplier.email as supplierEmail, 
      supplier.phone as supplierPhone,
      case 
        when status = 'Pending'   then 2
        when status = 'Confirmed' then 3
        when status = 'Rejected'  then 1
        else 0 
      end as statusControl : Integer,
      supplier, 
      extractedData
  } actions {
      action confirmExtraction() returns MyConfirmations;
  };

  entity MyConfirmations as projection on db.ExtractionConfirmations; 
  entity ExtractedData as projection on db.ExtractedData;
  entity Suppliers as projection on db.Suppliers;
}

// === 3. Draft & Field Control ===

// Κλείδωμα πεδίων κεφαλίδας για να επιτρέπεται η επεξεργασία μόνο στα Extracted Data
annotate SupplierService.MyRequests with {
    requestNumber @readonly;
    status        @readonly;
    requestDate   @readonly;
};