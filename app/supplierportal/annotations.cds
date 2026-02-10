using SupplierService as service from '../../srv/main-service';

annotate service.MyRequests with @(
    UI.SelectionFields : [ requestNumber, status ],
    UI.LineItem : [
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'SupplierService.confirmExtraction',
            Label : 'Confirm Extraction',
            Criticality : #Positive
        },
        { $Type : 'UI.DataField', Value : requestNumber, Label : 'Request Number' },
        { $Type : 'UI.DataField', Value : supplierName, Label : 'Supplier Name' },
        { $Type : 'UI.DataField', Value : requestDate, Label : 'Date' },
        { $Type : 'UI.DataField', Value : status, Label : 'Status', Criticality : statusControl }
    ]
);


annotate service.MyRequests with @(
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet', 
            ID : 'MainFacet', 
            Label : 'General Info', 
            Target : '@UI.FieldGroup#Details',
            // Dodajemy przycisk tutaj w UI.FieldGroup#Details jako DataFieldForAction
        },
        { 
            $Type : 'UI.ReferenceFacet', 
            ID : 'ItemsFacet', 
            Label : 'Products', 
            Target : 'extractedData/@UI.LineItem' 
        }
    ],
    UI.FieldGroup#Details : {
        $Type : 'UI.FieldGroupType',
        Data : [
            { 
                $Type: 'UI.DataFieldForAction', 
                Action: 'confirmRequest', 
                Label: 'Confirm', 
                Criticality: #Positive 
            },
            { 
                $Type: 'UI.DataFieldForAction', 
                Action: 'rejectRequest', 
                Label: 'Reject', 
                Criticality: #Negative 
            },
            { Value : requestNumber, Label : 'Request Number' },
            { Value : status, Label : 'Status' }
        ]
    }
);

// annotate service.MyRequests with @(
//     UI.Facets : [
//         { $Type : 'UI.ReferenceFacet', ID : 'MainFacet', Label : 'General Info', Target : '@UI.FieldGroup#Details' },
//         { $Type : 'UI.ReferenceFacet', ID : 'ItemsFacet', Label : 'Products', Target : 'extractedData/@UI.LineItem' }
//     ],
//     UI.FieldGroup #Details : {
//         $Type : 'UI.FieldGroupType',
//         Data : [
//             { Value : requestNumber, Label : 'Request Number' },
//             { Value : status, Label : 'Status' }
//         ]
//     }
// );

annotate service.ExtractedData with @(
    UI.LineItem : [
        { Value : fieldName, Label : 'Product / Field' },
        { Value : fieldValue, Label : 'Value / Quantity' }
    ]
);

annotate service.ExtractedData with {
    fieldName  @Common.FieldControl : #Mandatory;
    fieldValue @Common.FieldControl : #Optional;
};
