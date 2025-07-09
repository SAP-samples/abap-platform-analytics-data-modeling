/*
This query uses hierarchies, which structures depend on validity intervals. The hierarchy view has a datefrom and dateto parameter.
The data of the cube should be assigned to the leaves which was valid at the time of the data record (temporal join).
In this case the datefrom parameter of the hierarchy view must be filled with the initial date and the dateto parameter with the max date.
In addition a rule is needed how to derive a date from the data of the cube. This rule is defined by using the annotation AnalyticsDetails.query.temporalJoin.
This query derives the first day of the time element FlightYearMonth of the cube.
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Time-Dep Hierarchy with temporal Join'
@ObjectModel.modelingPattern: #ANALYTICAL_QUERY
@ObjectModel.supportedCapabilities: [#ANALYTICAL_QUERY]
define transient view entity /DMO/ANA_C_HIE_TEMPJOIN
provider contract analytical_query
as projection on /DMO/ANA_I_FlightCube
{
  @AnalyticsDetails.query.temporalJoin: {
    derivationType: #FIRST_DAY,
    timeElement: 'FlightYearMonth'
  }
  _Airline._hier_std( p_HierarchyID : 'ALLIANCE' , p_DateFrom : '00000000' , p_DateTo : '99991231') as _AirlineHier,
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
