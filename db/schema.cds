// namespace SendMessage;

using { managed } from '@sap/cds/common';

entity Orders : managed {
    key ID          : UUID;
    producer        : String;
    customerEmail   : String;
    vatNumber       : String; 
    address         : String; 
    status          : String default 'Pending'; 
    items           : Composition of many OrderItems on items.parent = $self;
}

entity OrderItems {
    key ID   : UUID;
    parent   : Association to Orders;
    product  : String;
    quantity : Integer;
}