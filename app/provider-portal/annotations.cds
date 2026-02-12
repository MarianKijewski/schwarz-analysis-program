using ProviderService as service from '../../srv/main-service';

annotate service.MyRequests with @(
    UI.SelectionFields : [ requestNumber, status, requestDate ], 
    UI.LineItem : [
        { $Type : 'UI.DataField', Value : requestNumber, Label : 'Request Number' },
        { $Type : 'UI.DataField', Value : supplierName, Label : 'Supplier Name' }, 
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
        Description : { Value : supplierName }
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
            { Value : requestNumber, Label : 'Request Number' },
            { Value : status, Label : 'Status' },
            { Value : supplierName, Label : 'Supplier Name' },
            { Value : supplierEmail, Label : 'Supplier Email' },
            { Value : supplierPhone, Label : 'Supplier Phone' },
            { Value : description, Label : 'Description' },
            { Value : pageCount, Label : 'Page Count' },
            { Value : extractionConfidence, Label : 'Extraction Confidence (%)' }
        ]
    }
);

annotate service.ExtractedData with @(
     UI.LineItem : [ 
        { 
            Value : fieldName, Label : 'Product / Field' },
             { Value : fieldValue, Label : 'Value / Quantity' }, 
             { Value : confidence, Label : 'Confidence Score' } 
             ] 
             );