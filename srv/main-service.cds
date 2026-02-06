using { com.schwarz.app as db } from '../db/schema';

// Service for Suppliers
service SupplierService @(path: '/supplier') {
  @readonly entity Suppliers as projection on db.Suppliers;
  
  entity MyEmails as projection on db.Emails 
    where supplier.ID = $user.id;
  
  entity MyOrders as projection on db.Orders 
    where supplier.ID = $user.id;
  
  entity MyOrderConfirmations as projection on db.OrderConfirmations;
  
  entity OrderItems as projection on db.OrderItems;
  
  // Action to update order before confirmation
  action updateOrder(orderID: UUID, updates: String) returns MyOrders;
  
  // Action to confirm order
  action confirmOrder(orderID: UUID) returns MyOrderConfirmations;
}

// Service for Providers
service ProviderService @(path: '/provider') {
  @readonly entity Providers as projection on db.Providers;
  
  entity MyEmails as projection on db.Emails 
    where provider.ID = $user.id;
  
  entity MyOrders as projection on db.Orders 
    where provider.ID = $user.id;
  
  entity MyOrderConfirmations as projection on db.OrderConfirmations;
  
  entity OrderItems as projection on db.OrderItems;
  
  // Action to update order before confirmation
  action updateOrder(orderID: UUID, updates: String) returns MyOrders;
  
  // Action to confirm order
  action confirmOrder(orderID: UUID) returns MyOrderConfirmations;
}

// Admin service for managing all entities
service AdminService @(path: '/admin') {
  entity Suppliers as projection on db.Suppliers;
  entity Providers as projection on db.Providers;
  entity Emails as projection on db.Emails;
  entity Orders as projection on db.Orders;
  entity OrderConfirmations as projection on db.OrderConfirmations;
  entity OrderItems as projection on db.OrderItems;
}
