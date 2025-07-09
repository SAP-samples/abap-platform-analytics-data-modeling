/*
In SAP systems amounts are stored with 2 decimals if the field of type CURR.
This is independent of the true number of decimals of the currency.
The function CURR_TO_DECFLOAT_AMOUNT casts the value from CURR to DECFLOAT and 
does the correct decimal shift.
The function is needed when CURR fields should be used in formulas. But it is not allowed
at all places in a formula. Therefore the recommandation is to apply the function for all CURR-fields
from the query. There are some exceptions, like get_numeric_value, .... 
In this query CURR_TO_DECFLOAT_AMOUNT is applied to field "SalesAmount", such that it can be generally used in formulas.
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Simple Formulas with Amount fields'
@ObjectModel: {
  supportedCapabilities: [ #ANALYTICAL_QUERY ],
  modelingPattern: #ANALYTICAL_QUERY
}
define transient view entity /DMO/ANA_C_CKF_Amount
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
  @Semantics.amount.currencyCode: 'CurrencyCode'
  @AnalyticsDetails.query.axis: #COLUMNS
  curr_to_decfloat_amount(SalesAmount) as SalesAmount,
  
  @AnalyticsDetails.query.axis: #COLUMNS
  Distance,
  
  virtual CalcUnitPrice: dd_cds_calculated_unit,
  @AnalyticsDetails.query.axis: #COLUMNS
  @Aggregation.default: #FORMULA
  @EndUserText.label: 'Price'
  @Semantics.quantity.unitOfMeasure: 'CalcUnitPrice'
  curr_to_decfloat_amount(SalesAmount) / $projection.distance as Price
}
