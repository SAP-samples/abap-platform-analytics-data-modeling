/*
This query shows a comparison of a measure for different month. 
The feature behind is called restricted measure and in CDS the pattern is
CASE WHEN <filter on dimensions> THEN <measure> ELSE NULL END AS <fieldAlias>
The measure can be used together with one of the functions CURR_TO_DECFLOAT_AMOUNT, CURRENCY_CONVERSION, UNIT_CONVERSION
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Simple restricted measure'
@ObjectModel: {
  supportedCapabilities: [ #ANALYTICAL_QUERY ],
  modelingPattern: #ANALYTICAL_QUERY
}
define transient view entity /DMO/ANA_C_RKF_SIMPLE
  provider contract analytical_query
  as projection on /DMO/ANA_I_FlightCube
{
// Dimensions
  @AnalyticsDetails.query: { 
    axis: #ROWS,
    totals: #SHOW
  }
  AirlineID,
  
// Measures 
  virtual CurrencySalesAmountAll : abap.cuky,
  @AnalyticsDetails.query.axis: #COLUMNS
  @Semantics.amount.currencyCode: 'CurrencySalesAmountAll'  
  curr_to_decfloat_amount(SalesAmount) as SalesAmountAll,

  virtual CurrencySalesAmountCurrent : abap.cuky,  
  @AnalyticsDetails.query.axis: #COLUMNS
  @Semantics.amount.currencyCode: 'CurrencySalesAmountCurrent'
  @EndUserText.label: 'Sales Jul 2024'
  case when FlightYearMonth = '202407' then curr_to_decfloat_amount(SalesAmount) else null end as SalesAmountCurrent,
  
  virtual CurrencySalesAmountPrev : abap.cuky,  
  @AnalyticsDetails.query.axis: #COLUMNS
  @Semantics.amount.currencyCode: 'CurrencySalesAmountCurrent'
  @EndUserText.label: 'Sales Jun 2024'
  case when FlightYearMonth = '202406' then curr_to_decfloat_amount(SalesAmount) else null end as SalesAmountPrev  
   
}
