using InternalService as service from '../../srv/internal-service';
using from '../../db/schema';

annotate service.Documents with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : '{i18n>Status}',
                Value : status,
            },
            {
                $Type : 'UI.DataField',
                Value : createdAt,
                Label : '{i18n>DateOfIssue}',
            },
            {
                $Type : 'UI.DataField',
                Value : deliveryDate,
                Label : '{i18n>DeliveryDate}',
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
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Records',
            ID : 'Records',
            Target : 'Records/@UI.LineItem#Records',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : recipient.name,
            Label : '{i18n>CompanyName}',
        },
        {
            $Type : 'UI.DataField',
            Value : status,
            Label : 'Status',
        },
    ],
);

annotate service.Documents with {
    recipient @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'Recipients',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : recipient_ID,
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

annotate service.DocumentRecords with @(
    UI.LineItem #Records : [
        {
            $Type : 'UI.DataField',
            Value : name,
            Label : '{i18n>Name}',
        },
        {
            $Type : 'UI.DataField',
            Value : quantity,
            Label : '{i18n>Quantity}',
        },
    ]
);

