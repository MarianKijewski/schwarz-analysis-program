using DataExchangeService from './service';

// Business Partners Annotations
annotate DataExchangeService.BusinessPartners with @(
    UI.LineItem: [
        {
            Value: name,
            Label: 'Name'
        },
        {
            Value: email,
            Label: 'Email'
        },
        {
            Value: phone,
            Label: 'Phone'
        },
        {
            Value: partnerType,
            Label: 'Type'
        },
        {
            Value: isActive,
            Label: 'Active',
            Criticality: isActive
        }
    ],
    UI.HeaderInfo: {
        TypeName: 'Business Partner',
        TypeNamePlural: 'Business Partners',
        Title: {Value: name},
        Description: {Value: email}
    },
    UI.FieldGroup #Details: {
        Data: [
            {Value: name},
            {Value: email},
            {Value: phone},
            {Value: address},
            {Value: partnerType},
            {Value: isActive}
        ]
    },
    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            Label: 'Business Partner Details',
            Target: '@UI.FieldGroup#Details'
        }
    ]
);

// Data Assets Annotations
annotate DataExchangeService.DataAssets with @(
    UI.LineItem: [
        {
            Value: name,
            Label: 'Name'
        },
        {
            Value: category,
            Label: 'Category'
        },
        {
            Value: owner.name,
            Label: 'Owner'
        },
        {
            Value: format,
            Label: 'Format'
        },
        {
            Value: size,
            Label: 'Size (bytes)'
        },
        {
            Value: isPublic,
            Label: 'Public',
            Criticality: isPublic
        }
    ],
    UI.HeaderInfo: {
        TypeName: 'Data Asset',
        TypeNamePlural: 'Data Assets',
        Title: {Value: name},
        Description: {Value: description}
    },
    UI.FieldGroup #Details: {
        Data: [
            {Value: name},
            {Value: description},
            {Value: category},
            {Value: owner_ID},
            {Value: url},
            {Value: size},
            {Value: format},
            {Value: isPublic}
        ]
    },
    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            Label: 'Asset Details',
            Target: '@UI.FieldGroup#Details'
        }
    ]
);

// Data Exchanges Annotations
annotate DataExchangeService.DataExchanges with @(
    UI.LineItem: [
        {
            Value: asset.name,
            Label: 'Asset'
        },
        {
            Value: sender.name,
            Label: 'Sender'
        },
        {
            Value: receiver.name,
            Label: 'Receiver'
        },
        {
            Value: status,
            Label: 'Status',
            Criticality: status
        },
        {
            Value: initiatedAt,
            Label: 'Initiated'
        }
    ],
    UI.HeaderInfo: {
        TypeName: 'Data Exchange',
        TypeNamePlural: 'Data Exchanges',
        Title: {Value: asset.name},
        Description: {Value: status}
    },
    UI.FieldGroup #Details: {
        Data: [
            {Value: asset_ID},
            {Value: sender_ID},
            {Value: receiver_ID},
            {Value: status},
            {Value: initiatedAt},
            {Value: completedAt},
            {Value: comments}
        ]
    },
    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            Label: 'Exchange Details',
            Target: '@UI.FieldGroup#Details'
        }
    ]
);

// Field labels
annotate DataExchangeService.BusinessPartners with {
    name @title: 'Name';
    email @title: 'Email';
    phone @title: 'Phone';
    address @title: 'Address';
    partnerType @title: 'Partner Type';
    isActive @title: 'Active';
}

annotate DataExchangeService.DataAssets with {
    name @title: 'Name';
    description @title: 'Description';
    category @title: 'Category';
    url @title: 'URL';
    size @title: 'Size (bytes)';
    format @title: 'Format';
    isPublic @title: 'Public';
}

annotate DataExchangeService.DataExchanges with {
    status @title: 'Status';
    initiatedAt @title: 'Initiated At';
    completedAt @title: 'Completed At';
    comments @title: 'Comments';
}
