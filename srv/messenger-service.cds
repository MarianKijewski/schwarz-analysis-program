using { Orders, OrderItems } from '../db/schema';

service MessengerService { 
    @odata.draft.enabled
    entity S_Orders as projection on Orders;
    
    entity S_OrderItems as projection on OrderItems;

    action submitOrder(orderID: UUID) returns String;
}