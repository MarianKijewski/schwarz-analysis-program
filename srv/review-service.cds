using { sap.cap.orders as db } from '../db/schema';

service ReviewService {
  entity Orders as projection on db.Orders;
  entity Items as projection on db.Orders.Items;
}
