using SupplierService as service from '../../srv/main-service';

// === 1. List Report Configuration (Main Table) ===
annotate service.MyRequests with @(
    UI.SelectionFields : [ requestNumber, status, requestDate ], 
    UI.LineItem : [
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'SupplierService.confirmExtraction',
            Label : 'Confirm Extraction',
            Criticality : #Positive
        },
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

// === 2. Object Page Configuration (Details) ===
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
            { Value : extractionConfidence, Label : 'Extraction Confidence (%)' },
            { Value : supplier.email, Label : 'Supplier Email' },
            { Value : supplier.phone, Label : 'Supplier Phone' }
        ]
    }
);

// === 3. Nested List Configuration (Extracted Items) ===
annotate service.ExtractedData with @(
    UI.LineItem : [
        { Value : fieldName, Label : 'Product / Field' },
        { Value : fieldValue, Label : 'Value / Quantity' },
        { Value : confidence, Label : 'Confidence Score' }
    ]
);

// === 4. Field Level Annotations ===
annotate service.MyRequests with {
    status @(
        Common.Label : 'Status',
        Criticality : statusControl
    )
};