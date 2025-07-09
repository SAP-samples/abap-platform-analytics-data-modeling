/*
This query includes a formula which references the grand total of a measure. The grand total is to total is the aggregate on all dimensions. It takes all filters (static and dynamic)
into account. The function GRAND_TOTAL returns that value. 
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Reference to Totals Number'
@ObjectModel.modelingPattern: #ANALYTICAL_QUERY
@ObjectModel.supportedCapabilities: [#ANALYTICAL_QUERY]
define transient view entity /DMO/ANA_C_OLP_TOTAL_GRAND
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
  @EndUserText.label: 'Grand Total SalesAmount'
  @Semantics.amount.currencyCode: 'currUSD2'  
  grand_total( measure => $projection.SalesAmountInUSD ) as TotalGrandSalesAmountInUSD
 
}
where AirlineID between 'AA' and 'AZ'
  and ( PlaneType = '747-400' or PlaneType = '767-200' ) 
