using { sap.cap.orders as db } from '../db/schema';

service OrdersService {

  entity Orders as projection on db.Orders {
    ID,
    status,
    Items : redirected to Items
  };

  entity Items as projection on db.OrderItems {
    order,
    name,
    quantity,
    price
  };
}
