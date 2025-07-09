/*
This query includes a formula which references the next subtotals of a measure.
The function ROW_TOTTAL adress the next subtotal level for the dimensions on rows and COLUMN_TOTAL the next subtotal level
on columns. 
CURRENT_TOTAL references the next subtotal level of the axis the dimensions are assigned to - if dimensions are assigned to 
both axis, the function doesn't return a result. 
*/

@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Reference to Subtotal Numbers (on rows)'
@ObjectModel.modelingPattern: #ANALYTICAL_QUERY
@ObjectModel.supportedCapabilities: [#ANALYTICAL_QUERY]
define transient view entity /DMO/ANA_C_OLP_TOTAL_ROWS
provider contract analytical_query
as projection on /DMO/ANA_I_FlightCube
{
  @AnalyticsDetails.query: {
    axis: #ROWS,
    totals: #SHOW
  }
  AirlineID,
  @AnalyticsDetails.query: {
    axis: #ROWS,
    totals: #SHOW
  }
  ConnectionID,
 
  @AnalyticsDetails.query: {
    axis: #ROWS,
    totals: #SHOW
  }
  PlaneType,
  
  virtual currUSD1 : abap.cuky,  
  
  @Aggregation.default: #FORMULA
  @EndUserText.label: 'SalesAmount'
  @Semantics.amount.currencyCode: 'currUSD1'
  currency_conversion( amount             => curr_to_decfloat_amount( SalesAmount ),
                       source_currency    => CurrencyCode,
                       target_currency    => abap.cuky'USD',
                       exchange_rate_date => $session.user_date,
                       exchange_rate_type => 'M' ) as SalesAmountInUSD,
  
  virtual currUSD2 : abap.cuky, 
  
  @Aggregation.default: #FORMULA
  @EndUserText.label: 'total SalesAmount'
  @Semantics.amount.currencyCode: 'currUSD2'  
  row_total( measure => $projection.SalesAmountInUSD ) as TotalSalesAmountInUSD,
  
  abap.unit'%' as UnitPercent,
  
  @Aggregation.default: #FORMULA
  @Semantics.quantity.unitOfMeasure: 'UnitPercent'
  @EndUserText.label: 'Ratio SalesAmount on total SalesAmount'
  ratio_of( portion => $projection.SalesAmountInUSD, total => $projection.TotalSalesAmountInUSD ) * 100 as ratioOccSeats  
  
}
