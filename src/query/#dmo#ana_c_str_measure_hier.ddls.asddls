/*
This query shows multiple measures which are displayed in a hierarchical way
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Measure Structure with Hierarchy'
@ObjectModel: {
  supportedCapabilities: [ #ANALYTICAL_QUERY ],
  modelingPattern: #ANALYTICAL_QUERY
}
define transient view entity /DMO/ANA_C_STR_MEASURE_HIER
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
  @AnalyticsDetails.query.elementHierarchy.initiallyCollapsed: true
  $projection.MaxSeatsCurrent - $projection.MaxSeatsPrevious as MaxSeatsDiff,
  
  @AnalyticsDetails.query.axis: #COLUMNS
  @EndUserText.label: 'Available Seats Jul 2024' 
  @AnalyticsDetails.query.elementHierarchy.parent: 'MaxSeatsDiff'
  case when FlightYearMonth = '202407' then MaximumSeats else null end as MaxSeatsCurrent,
    
  @AnalyticsDetails.query.axis: #COLUMNS
  @EndUserText.label: 'Available Seats Jun 2024' 
  @AnalyticsDetails.query.elementHierarchy.parent: 'MaxSeatsDiff'
  case when FlightYearMonth = '202406' then MaximumSeats else null end as MaxSeatsPrevious,

  @AnalyticsDetails.query.axis: #COLUMNS
  @Aggregation.default: #FORMULA
  @EndUserText.label: 'Difference Number Flights' 
  @AnalyticsDetails.query.elementHierarchy.parent: 'MaxSeatsDiff'
  @AnalyticsDetails.query.elementHierarchy.initiallyCollapsed: true
  $projection.NoFlightsCurrent - $projection.NoFlightsPrevious as NoFlightsDiff,
  
  @AnalyticsDetails.query.axis: #COLUMNS
  @EndUserText.label: 'Number Flights Jul 2024' 
  @AnalyticsDetails.query.elementHierarchy.parent: 'NoFlightsDiff'
  case when FlightYearMonth = '202407' then NumberOfFlights else null end as NoFlightsCurrent,
    
  @AnalyticsDetails.query.axis: #COLUMNS
  @EndUserText.label: 'Number Flights Jun 2024' 
  @AnalyticsDetails.query.elementHierarchy.parent: 'NoFlightsDiff'
  case when FlightYearMonth = '202406' then NumberOfFlights else null end as NoFlightsPrevious,
  
  @AnalyticsDetails.query.axis: #COLUMNS
  @Aggregation.default: #FORMULA
  @EndUserText.label: 'Difference Occupied Seats'
  @AnalyticsDetails.query.elementHierarchy.initiallyCollapsed: true    
  $projection.OccSeatsCurrent - $projection.OccSeatsPrevious as OccSeatsDiff,   
  
  @AnalyticsDetails.query.axis: #COLUMNS
  @EndUserText.label: 'Occupied Seats Jul 2024'
  @AnalyticsDetails.query.elementHierarchy.parent: 'OccSeatsDiff'  
  case when FlightYearMonth = '202407' then OccupiedSeats else null end as OccSeatsCurrent,
  
  @AnalyticsDetails.query.axis: #COLUMNS
  @EndUserText.label: 'Occupied Seats Jun 2024'
  @AnalyticsDetails.query.elementHierarchy.parent: 'OccSeatsDiff' 
  case when FlightYearMonth = '202406' then OccupiedSeats else null end as OccSeatsPrevious
   
}
