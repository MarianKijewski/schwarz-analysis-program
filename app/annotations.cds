using ReviewService from '../srv/review-service';

annotate ReviewService.OrderItems with @(
  UI.LineItem: [
    { Value: product, Label: 'Product' },
    { Value: quantity, Label: 'Quantity' }
  ],
  UI.Identification: [
    { Value: product }
  ]
);