/*
This query uses hierarchies, which are only valid in a certain period in time (the hierarchy directory has a validity interval). In this case a key-date (here a parameter)
is needed for specifing a hierarchy
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Tim-dep hier directory with key date'
@ObjectModel.modelingPattern: #ANALYTICAL_QUERY
@ObjectModel.supportedCapabilities: [#ANALYTICAL_QUERY]
define transient view entity /DMO/ANA_C_HIE_DIR_KEYDATE
provider contract analytical_query
with parameters
  @EndUserText.label: 'Hierarchy Date'
  @Semantics.businessDate.at: true   
  p_KeyDate : /dmo/ana_date_from
  
as projection on /DMO/ANA_I_FlightCube
{
  _Airline._hier_dtd( p_HierarchyID : 'ALLIANCE' , p_KeyDate : $parameters.p_KeyDate ) as _AirlineHier,
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
  currency_conversion( amount             => SalesAmount,
                       source_currency    => CurrencyCode,
                       target_currency    => abap.cuky'EUR',
                       exchange_rate_date => $session.user_date,
                       exchange_rate_type => 'M' ) as SalesAmountInEUR
                       
}
