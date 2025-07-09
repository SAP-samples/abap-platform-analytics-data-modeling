@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Airport Capacity'
@ObjectModel: {
  supportedCapabilities: [ #ANALYTICAL_QUERY, #KEY_USER_COPYING_TEMPLATE ],
  modelingPattern: #ANALYTICAL_QUERY
}
define transient view entity /DMO/ANA_C_AirportCapaQry
  provider contract analytical_query
  as projection on /DMO/ANA_I_FlightCube
{
  @AnalyticsDetails.query.axis: #ROWS
  @AnalyticsDetails.query.totals: #SHOW
  @UI.textArrangement: #TEXT_ONLY
  DepartureAirportID,

  @AnalyticsDetails.query.axis: #ROWS
  @AnalyticsDetails.query.totals: #HIDE
  FlightDate,

  MaximumSeats,

  OccupiedSeats,

  cast( '%' as abap.unit )                                           as UnitPercent,

  @Aggregation.default: #FORMULA
  @EndUserText.label: 'Utilization'
  @Semantics.quantity.unitOfMeasure: 'UnitPercent'
  ratio_of( portion => OccupiedSeats , total => MaximumSeats ) * 100 as Utlilization,

  @Aggregation.default: #FORMULA
  @EndUserText.label: 'Free Capacity'
  MaximumSeats - OccupiedSeats                                       as FreeCapacity

}
