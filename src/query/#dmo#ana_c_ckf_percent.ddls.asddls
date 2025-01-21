/*
This query shows how to deal with percentage numbers.  
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Formula with Percent'
@ObjectModel: {
  supportedCapabilities: [ #ANALYTICAL_QUERY ],
  modelingPattern: #ANALYTICAL_QUERY
}
define transient view entity /DMO/ANA_C_CKF_PERCENT
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
  virtual CurrencySalesAmountCurrent : abap.cuky,  
  @AnalyticsDetails.query.axis: #COLUMNS
  @Semantics.amount.currencyCode: 'CurrencySalesAmountCurrent'
  @EndUserText.label: 'Sales Jul 2024'
  case when FlightYearMonth = '202407' then curr_to_decfloat_amount(SalesAmount) end as SalesAmountCurrent,
  
  virtual CurrencySalesAmountPrev : abap.cuky,  
  @AnalyticsDetails.query.axis: #COLUMNS
  @Semantics.amount.currencyCode: 'CurrencySalesAmountPrev'
  @EndUserText.label: 'Sales Jun 2024'
  case when FlightYearMonth = '202406' then curr_to_decfloat_amount(SalesAmount) end as SalesAmountPrev,  
  
  abap.unit'%' as Percent,
  @Aggregation.default: #FORMULA
  @AnalyticsDetails.query.axis: #COLUMNS
  @EndUserText.label: '% Deviation'
  // when the result of a calculation is a number without reference, then the Semantics
  // annotation can be added which points to an unit-field which is set to "%" 
  // notice that the result of deviation_ratio is of type DECFLOAT 
  // the number on the screen will look "50 %" 
  @Semantics.quantity.unitOfMeasure: 'Percent'
  deviation_ratio( portion => $projection.SalesAmountCurrent,
                   total   => $projection.SalesAmountPrev ) *100 as deviation
   
}
