/*
This query contains a set of calculated and restricted measures. In the preview you can see that all these objects are assigned to a 'measure structure'
The 'measure structure' behaves like a dimension at runtime: It can be assigned to rows- or columns-axis (but not free-axis) and filters can be set
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Measure Structure'
@ObjectModel: {
  supportedCapabilities: [ #ANALYTICAL_QUERY ],
  modelingPattern: #ANALYTICAL_QUERY
}
define transient view entity /DMO/ANA_C_STR_MEASURE
  provider contract analytical_query
  as projection on /DMO/ANA_I_FlightCube
{
// Dimensions
  @AnalyticsDetails.query: { 
    axis: #ROWS,
    totals: #SHOW
  }
  AirlineID,
  
// Measures 
  @AnalyticsDetails.query.axis: #COLUMNS
  @Aggregation.default: #FORMULA
  @EndUserText.label: 'Difference Available Seats' 
  $projection.MaxSeatsCurrent - $projection.MaxSeatsPrevious as MaxSeatsDiff,
  
  @AnalyticsDetails.query.axis: #COLUMNS
  @EndUserText.label: 'Available Seats Jul 2024' 
  case when FlightYearMonth = '202407' then MaximumSeats else null end as MaxSeatsCurrent,
    
  @AnalyticsDetails.query.axis: #COLUMNS
  @EndUserText.label: 'Available Seats Jun 2024' 
  case when FlightYearMonth = '202406' then MaximumSeats else null end as MaxSeatsPrevious,

  @AnalyticsDetails.query.axis: #COLUMNS
  @Aggregation.default: #FORMULA
  @EndUserText.label: 'Difference Number Flights' 
  $projection.NoFlightsCurrent - $projection.NoFlightsPrevious as NoFlightsDiff,
  
  @AnalyticsDetails.query.axis: #COLUMNS
  @EndUserText.label: 'Number Flights Jul 2024' 
  case when FlightYearMonth = '202407' then NumberOfFlights else null end as NoFlightsCurrent,
    
  @AnalyticsDetails.query.axis: #COLUMNS
  @EndUserText.label: 'Number Flights Jun 2024' 
  case when FlightYearMonth = '202406' then NumberOfFlights else null end as NoFlightsPrevious,
  
  @AnalyticsDetails.query.axis: #COLUMNS
  @Aggregation.default: #FORMULA
  @EndUserText.label: 'Difference Occupied Seats'    
  $projection.OccSeatsCurrent - $projection.OccSeatsPrevious as OccSeatsDiff,   
  
  @AnalyticsDetails.query.axis: #COLUMNS
  @EndUserText.label: 'Occupied Seats Jul 2024'  
  case when FlightYearMonth = '202407' then OccupiedSeats else null end as OccSeatsCurrent,
  
  @AnalyticsDetails.query.axis: #COLUMNS
  @EndUserText.label: 'Occupied Seats Jun 2024'
  case when FlightYearMonth = '202406' then OccupiedSeats else null end as OccSeatsPrevious
   
}
