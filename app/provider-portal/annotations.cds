using ProviderService as service from '../../srv/main-service';

annotate service.MyRequests with @(
    UI.SelectionFields : [ requestNumber, status, requestDate ], 
    UI.LineItem : [
        { $Type : 'UI.DataField', Value : requestNumber, Label : 'Request Number' },
        { $Type : 'UI.DataField', Value : supplier.name, Label : 'Supplier Name' }, 
        { $Type : 'UI.DataField', Value : requestDate, Label : 'Date' },
        { 
            $Type : 'UI.DataField', 
            Value : status, 
            Label : 'Status',
            Criticality : statusControl 
        }
    ]
);

annotate service.MyRequests with @(
    UI.HeaderInfo : {
        TypeName : 'Order',
        TypeNamePlural : 'Orders',
        Title : { Value : requestNumber },
        Description : { Value : supplier.name }
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'MainFacet',
            Label : 'General Information',
            Target : '@UI.FieldGroup#Details',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'ItemsFacet',
            Label : 'Products & Quantities',
            Target : 'extractedData/@UI.LineItem', 
        }
    ],
    UI.FieldGroup #Details : {
        $Type : 'UI.FieldGroupType',
        Data : [
            { Value : description, Label : 'Description' },
            { Value : pageCount, Label : 'Page Count' },
            { Value : extractionConfidence, Label : 'Extraction Confidence (%)' }
        ]
    }
);