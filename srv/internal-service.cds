using { com.schwarz.app as db } from '../db/schema';

service InternalService @(path: '/internal') {
  entity Documents as projection on db.Documents;
//   @readonly
//   entity Providers as projection on db.Providers;
//
//   entity MyRequests as projection on db.DocumentRequests {
//       ID,
//       *,
//       supplier.name  as supplierName,
//       supplier.email as supplierEmail,
//       supplier.phone as supplierPhone,
//       case
//         when status = 'Pending'   then 2
//         when status = 'Confirmed' then 3
//         when status = 'Rejected'  then 1
//         else 0
//       end as statusControl : Integer,
//       supplier,
//       extractedData
//   } actions {
//       action confirmExtraction() returns MyConfirmations;
//   };
//
//   entity MyConfirmations as projection on db.ExtractionConfirmations;
//   entity ExtractedData as projection on db.ExtractedData;
//   entity Suppliers as projection on db.Suppliers;
}

// // === 3. Draft & Field Control ===
//
// // Κλείδωμα πεδίων κεφαλίδας για να επιτρέπεται η επεξεργασία μόνο στα Extracted Data
// annotate SupplierService.MyRequests with {
//     requestNumber @readonly;
//     status        @readonly;
//     requestDate   @readonly;
// };