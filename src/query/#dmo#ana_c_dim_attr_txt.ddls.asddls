/*
This query shows how to switch on display attributes in the default layout.
The text arrangment can be done in the standard way
Display attributes can't be used for slice&dice at runtime. These will be displayed
when the dimension field to which these belong are assigned to rows or
columns.
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Display Attributes'
@ObjectModel.modelingPattern: #ANALYTICAL_QUERY
@ObjectModel.supportedCapabilities: [#ANALYTICAL_QUERY]
define transient view entity /DMO/ANA_C_DIM_ATTR_TXT
provider contract analytical_query
as projection on /DMO/ANA_I_FlightCube
{
  @AnalyticsDetails.query: {
    axis: #ROWS
  }
  @UI.textArrangement: #TEXT_ONLY
  AirlineID,
  
  @AnalyticsDetails.query: {
     axis: #ROWS,
     totals: #SHOW
  }
  ConnectionID,
  @UI.textArrangement: #TEXT_LAST
  // _Connection is the foreign-key association from field ConnectionID to
  // the dimension view /DMO/ANA_I_Connection defined in the cube view
  _Connection.DepartureAirportID,
  
  CurrencyCode,
  SalesAmount
}
