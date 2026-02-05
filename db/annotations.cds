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
        {  $Type : 'UI.ReferenceFacet', Target : '@UI.FieldGroup#Details', Label : 'Supplier Details' }
    ],
    UI.FieldGroup #Details : {
        Data : [
            { Value : producer },
            { Value : customerEmail },
            { Value : vatNumber, Label : 'VAT Number' },
            { Value : address, Label : 'Business Address' }
        ]
    }
);