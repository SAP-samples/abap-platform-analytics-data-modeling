@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Display Attributes'
@ObjectModel.modelingPattern: #ANALYTICAL_QUERY
@ObjectModel.supportedCapabilities: [#ANALYTICAL_QUERY]
define transient view entity /DMO/ANA_C_DIM_ATTR
provider contract analytical_query
as projection on /DMO/ANA_I_FlightCube
{
  @AnalyticsDetails.query: {
    axis: #ROWS
  }
  AirlineID,
  @AnalyticsDetails.query: {
     axis: #ROWS,
     totals: #SHOW
  }
  ConnectionID,
  //@Consumption.groupWithElement: 'ConnectionID'
  _Connection.DepartureTime,
  //@Consumption.groupWithElement: 'ConnectionID'
  _Connection.ArrivalTime,
  
  CurrencyCode,
  SalesAmount
}
