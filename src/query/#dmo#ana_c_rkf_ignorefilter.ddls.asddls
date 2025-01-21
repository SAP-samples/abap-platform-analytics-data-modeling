/*
This query shows restricted measures: OccupiedSeatsAll, OccupiedSeatsConnection 
This feature is usefull, if you want to compare the number to a bigger group 
With the drill down of AirlineID and DepartureAirportID,
OccupiedSeats shows the number of occupied seats per airline and departure airport
OccupiedSeatsConnection shows the number of occupied seats per airline
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Restricted Measure: Ignore Filter'
@ObjectModel: {
  supportedCapabilities: [ #ANALYTICAL_QUERY ],
  modelingPattern: #ANALYTICAL_QUERY
}
define transient view entity /DMO/ANA_C_RKF_IGNOREFILTER
  provider contract analytical_query
  as projection on /DMO/ANA_I_FlightCube
{
// Dimensions
  @AnalyticsDetails.query: { 
    axis: #ROWS,
    totals: #SHOW
  }
  AirlineID,
  @AnalyticsDetails.query: { 
    axis: #ROWS,
    totals: #SHOW
  }
  DepartureAirportID,
  
// Measures  
  @AnalyticsDetails.query.axis: #COLUMNS
  OccupiedSeats,
  // all filters for all dimensions are ignored this includes
  // - the static filter (WHERE), 
  // - the filters set at runtime,
  // - and the specific row or column in the query result
  @EndUserText.label: 'All Occupied Seats'
  @AnalyticsDetails.query.ignoreFurtherFilter.forAllElements: true
  @AnalyticsDetails.query.axis: #COLUMNS
  OccupiedSeats as OccupiedSeatsAll,
  // all filters for dimension DepartureAirportID are ignored this includes
  // - the static filter (here not availabler),
  // - the filters set at runtime for DepartureAirportID,
  // - and the specific row or column (for DepartureAirportID) in the query result  
  @EndUserText.label: 'Occupied Seats (DepAirport independent)'
  @AnalyticsDetails.query.ignoreFurtherFilter.forElement: [ 'DepartureAirportID' ]
  @AnalyticsDetails.query.axis: #COLUMNS
  OccupiedSeats as OccupiedSeatsConnection
    
}
where AirlineID between 'AA' and 'LH'

