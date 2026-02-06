using MessengerService as service from '../srv/messenger-service';

annotate service.S_Orders with @(
    UI.LineItem : [
        { Value : producer, Label : 'Supplier Name' },
        { Value : customerEmail, Label : 'Email' },
        { Value : status, Label : 'Onboarding Status' }
    ],
    UI.HeaderInfo : {
        TypeName : 'Order',
        TypeNamePlural : 'Orders',
        Title : { Value : producer }
    },
    UI.Facets : [
        {  $Type : 'UI.ReferenceFacet', Target : '@UI.FieldGroup#Details', Label : 'Supplier Details' },
        {  $Type : 'UI.ReferenceFacet', Target : 'items/@UI.LineItem', Label : 'Order Items' }
    ],
    UI.FieldGroup #Details : {
        Data : [
            { Value : producer },
            { Value : customerEmail },
            { Value : vatNumber, Label : 'VAT Number' },
            { Value : address, Label : 'Business Address' },
            { Value : status, Label : 'Status' }
        ]
    }
);

annotate service.S_OrderItems with @(
    UI.LineItem : [
        { Value : product, Label : 'Product' },
        { Value : quantity, Label : 'Quantity' }
    ]
);