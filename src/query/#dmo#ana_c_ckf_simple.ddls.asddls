/*
This query shows how formulas on measures are handled. Notice that the data is first 
aggreated and afterward the formula is calculation on the aggregated operands
This is special for the analytical query. In plain SQL the formula is calculated on row level and 
then aggregated. What it means can be observed best for fields "OccupationRate" and "FreeSeatsRate"
*/  
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Simple Formulas'
@ObjectModel: {
  supportedCapabilities: [ #ANALYTICAL_QUERY ],
  modelingPattern: #ANALYTICAL_QUERY
}
define transient view entity /DMO/ANA_C_CKF_SIMPLE
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
  ConnectionID,
   
// Measures  
  @AnalyticsDetails.query.axis: #COLUMNS
  MaximumSeats,
  @AnalyticsDetails.query.axis: #COLUMNS
  OccupiedSeats,
  @Aggregation.default: #FORMULA
  @EndUserText.label: 'Free Seats'
  $projection.maximumseats - $projection.occupiedseats as FreeSeats,
  
  @Aggregation.default: #FORMULA
  @EndUserText.label: 'Occupation Rate'
  $projection.occupiedseats / $projection.maximumseats as OccupationRate,  

  @Aggregation.default: #FORMULA
  @EndUserText.label: 'Free Seats Rate'
  // $projection is needed for referencing element-alias defined in the query
  // measures of the cube can be referenced just by their names
  $projection.FreeSeats / MaximumSeats as FreeSeatsRate      
}
where AirlineID between 'AA' and 'LH'
