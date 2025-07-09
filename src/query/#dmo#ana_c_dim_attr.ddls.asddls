// The query shows how display attributess are handled. The attributes, in this case DepartureTime and ArrivalTime are only displayed together with the dimension (ConnectionID).
// Display attributes can neiter be used for grouping nor for filtering.
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
  // _Connection is the path to the according dimension view.
  _Connection.DepartureTime,
  _Connection.ArrivalTime,
  
  CurrencyCode,
  SalesAmount
}
