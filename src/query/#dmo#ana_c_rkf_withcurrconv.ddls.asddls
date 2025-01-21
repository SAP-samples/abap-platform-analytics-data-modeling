/*
This query shows a measure of type amount with currency conversion (see field SalesAmountInAugInEUR ). 
For simplicity all the parameters of the currency converison are static.
Parameters or session variables (e.g. $Session.user_date) can be used
Notice that the conversion isn't performed in your system. Then make sure that the
conversion rates are available for 08-August-2024 or choose another exchange rate date.
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Restr. Measure with Currency Conversion'
@ObjectModel: {
  supportedCapabilities: [ #ANALYTICAL_QUERY ],
  modelingPattern: #ANALYTICAL_QUERY
}
define transient view entity /DMO/ANA_C_RKF_WITHCURRCONV
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
  virtual currInAug: abap.cuky,
  
  @Semantics.amount.currencyCode: 'currInAug'
  @EndUserText.label: 'Sales in August'
  case when FlightMonth = '08' then curr_to_decfloat_amount(SalesAmount) else null end as SalesAmountInAug,
  
  virtual CurrEUR: abap.cuky,
  @Aggregation.default: #FORMULA 
  @AnalyticsDetails.query.axis: #COLUMNS
  @Semantics.amount.currencyCode: 'CurrEUR'
  @EndUserText.label: 'Sales (EUR) in August'
  case when FlightMonth = '08' then 
    currency_conversion( amount             => curr_to_decfloat_amount(SalesAmount),
                         source_currency    => CurrencyCode,
                         target_currency    => abap.cuky'EUR',
                         exchange_rate_date => abap.dats'20240808',
                         exchange_rate_type => 'M'
                       ) else null end as SalesAmountInAugInEUR    
}
where FlightYear = '2024'
