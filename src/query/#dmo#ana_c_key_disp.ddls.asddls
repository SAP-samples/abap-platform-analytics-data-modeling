// The query shows how to display coumpounded key for Dimension using @AnalyticsDetails.query.keyDisplay settings (It can be use for hierarchy nodes too) - available from 2508
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Key Display'
@ObjectModel.modelingPattern: #ANALYTICAL_QUERY
@ObjectModel.supportedCapabilities: [#ANALYTICAL_QUERY]
define transient view entity /DMO/ANA_C_KEY_DISP
provider contract analytical_query
as projection on /DMO/ANA_I_FlightCube
{
  @AnalyticsDetails.query: {
    axis: #ROWS
  }
  AirlineID,
  @AnalyticsDetails.query: {
     axis: #ROWS,
     totals: #SHOW,
     keyDisplay : #COMPOUND
    
  }
  ConnectionID,

  CurrencyCode,
  SalesAmount
}
 