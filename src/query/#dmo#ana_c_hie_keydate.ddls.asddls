/*
This query uses hierarchies, which structures depend on validity intervals. The hierarchy view has a datefrom and dateto parameter. 
Both parameters must be filled with the same value. Allowed are parameters, $session.user_date or system_date, or a fixed date (literal). 
The hierarchy structure is determined by intersecting the validity intervals with the date (available at runtime).
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Timedependent hierarchy with key date'
@ObjectModel.modelingPattern: #ANALYTICAL_QUERY
@ObjectModel.supportedCapabilities: [#ANALYTICAL_QUERY]
define transient view entity /DMO/ANA_C_HIE_KEYDATE
provider contract analytical_query
with parameters
  @EndUserText.label: 'Hierarchy Date'
  @Semantics.businessDate.at: true   
  p_KeyDate : /dmo/ana_date_from
  
as projection on /DMO/ANA_I_FlightCube
{
  _Airline._hier_std( p_HierarchyID : 'ALLIANCE' , p_DateFrom : $parameters.p_KeyDate , p_DateTo : $parameters.p_KeyDate ) as _AirlineHier,
  @Consumption.hidden: true
  _Airline.AirlineID as AirlineDummy,
  
  @AnalyticsDetails.query: {
    axis: #ROWS,
    displayHierarchy: #ON,
    hierarchyAssociation: '_AirlineHier'
  }
  @UI.textArrangement: #TEXT_ONLY
  AirlineID,
  
  virtual CurrEUR : abap.cuky,
  
  @Semantics.amount.currencyCode: 'CurrEUR'
  @Aggregation.default: #FORMULA
  currency_conversion( amount => SalesAmount,
                       source_currency => CurrencyCode,
                       target_currency => abap.cuky'EUR',
                       exchange_rate_date => $session.user_date,
                       exchange_rate_type => 'M' ) as SalesAmountInEUR
                       
}
