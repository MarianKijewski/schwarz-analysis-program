using { com.schwarz.app as db } from '../db/schema';

// Service for Suppliers
service SupplierService @(path: '/supplier') {
  @readonly entity Suppliers as projection on db.Suppliers;
  
  entity MyRequests as projection on db.DocumentRequests {
      *,
      case 
        when status = 'Pending' then 2
        when status = 'Confirmed' then 3
        when status = 'Rejected' then 1
        else 0 
      end as statusControl : Integer,
      supplier.name as supplierName,
      extractedData 
  } actions {
      action confirmExtraction() returns MyConfirmations;
  };
  
  entity MyConfirmations as projection on db.ExtractionConfirmations;
  entity ExtractedData as projection on db.ExtractedData;
}

// Service for Providers (Εσύ - Η Εταιρεία)
service ProviderService @(path: '/provider') {
  @readonly entity Providers as projection on db.Providers;
  
  entity MyRequests as projection on db.DocumentRequests {
      *,
      case 
        when status = 'Pending' then 2
        when status = 'Confirmed' then 3
        when status = 'Rejected' then 1
        else 0 
      end as statusControl : Integer,
      supplier, 
      extractedData
  } actions {
      action confirmExtraction() returns MyConfirmations;
  };
  
  // ΠΡΟΣΘΗΚΗ: Χρειάζεται και εδώ για να το βρίσκει το action confirmExtraction
  entity MyConfirmations as projection on db.ExtractionConfirmations; 
  
  entity ExtractedData as projection on db.ExtractedData;
  entity Suppliers as projection on db.Suppliers;
}