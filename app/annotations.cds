using ReviewService from '../srv/review-service';

annotate ReviewService.Orders with @(
  UI: {
    HeaderInfo: {
      TypeName: 'Order',
      TypeNamePlural: 'Orders',
      Title: {
        Value: ID
      },
      Description: {
        Value: status
      }
    },

    Identification: [
      {
        $Type: 'UI.DataField',
        Value: ID,
        Label: 'Order ID'
      },
      {
        $Type: 'UI.DataField',
        Value: status,
        Label: 'Status'
      }
    ],

    Facets: [
      {
        $Type: 'UI.ReferenceFacet',
        Label: 'General Information',
        Target: '@UI.Identification'
      },
      {
        $Type: 'UI.ReferenceFacet',
        Label: 'items',
        Target: 'items/@UI.LineItem'
      }
    ]
  }
);

annotate ReviewService.Orders.items with @(
  UI: {
    LineItem: [
      {
        $Type: 'UI.DataField',
        Value: name,
        Label: 'Item Name'
      },
      {
        $Type: 'UI.DataField',
        Value: quantity,
        Label: 'Quantity'
      },
      {
        $Type: 'UI.DataField',
        Value: price,
        Label: 'Price'
      }
    ]
  },
);
