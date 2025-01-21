/*
This query shows how to define a currency conversion - see field "SalesAmountInEUR"
To keep the example simple constants are used for the conversion parameters. Usually parameters
or session variables are used for these parameters
*/ 
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Formula with currency conversion'
@ObjectModel: {
  supportedCapabilities: [ #ANALYTICAL_QUERY ],
  modelingPattern: #ANALYTICAL_QUERY
}
define transient view entity /DMO/ANA_C_CKF_CURRCONV
  provider contract analytical_query
  as projection on /DMO/ANA_I_FlightCube
{
// Dimensions
  @AnalyticsDetails.query: { 
    axis: #ROWS,
    totals: #SHOW
  }
  AirlineID,
  
  CurrencyCode,
  DistanceUnit,
  
// Measures 
//  @Semantics.amount.currencyCode: 'CurrencyCode'
//  curr_to_decfloat_amount(SalesAmount) as SalesAmount1,
  virtual CurrEUR: abap.cuky,
  @Aggregation.default: #FORMULA 
  @AnalyticsDetails.query.axis: #COLUMNS
  @Semantics.amount.currencyCode: 'CurrEUR'
  currency_conversion( amount             => curr_to_decfloat_amount(SalesAmount),
                       source_currency    => CurrencyCode,
                       target_currency    => abap.cuky'EUR',
                       exchange_rate_date => abap.dats'20240707',
                       exchange_rate_type => 'M'
                     ) as SalesAmountInEUR,
    
  @AnalyticsDetails.query.axis: #COLUMNS
  Distance,
  
  virtual CalcUnitPrice: dd_cds_calculated_unit,
  @AnalyticsDetails.query.axis: #COLUMNS
  @Aggregation.default: #FORMULA
  @EndUserText.label: 'Price'
  @Semantics.quantity.unitOfMeasure: 'CalcUnitPrice'  
  $projection.SalesAmountInEUR / $projection.distance as Price    
}
