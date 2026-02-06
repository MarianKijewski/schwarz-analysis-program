using SupplierService as service from '../../srv/main-service';

annotate service.MyRequests with @(
    // 1. The Table Columns (Button + Data)
    UI.LineItem : [
        // The Button comes first!
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'SupplierService.confirmExtraction',
            Label : 'Confirm Extraction',
            Criticality : #Positive
        },
        // Now the normal columns
        {
            $Type : 'UI.DataField',
            Label : 'Request Number',
            Value : requestNumber,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Description',
            Value : description,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Page Count',
            Value : pageCount,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Confidence',
            Value : extractionConfidence,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Date',
            Value : requestDate,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Status',
            Value : status,
            Criticality : #Positive 
        },
    ],

    // 2. The Detail Page (When you click a row)
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'Request Number',
                Value : requestNumber,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Description',
                Value : description,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Page Count',
                Value : pageCount,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Confidence',
                Value : extractionConfidence,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Date',
                Value : requestDate,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Status',
                Value : status,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
    ]
);

// 3. The Dropdown Logic (Value Help)
annotate service.MyRequests with {
    supplier @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'Suppliers',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : supplier_ID,
                ValueListProperty : 'ID',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'name',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'email',
            },
        ],
    }
};