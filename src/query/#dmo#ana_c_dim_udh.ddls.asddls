/*
This query shows how to switch on the row-property to show the data
in a hierarchical (sometimes it is called "compact") way by
default. 
The levels of the hierarchy are defined by the order of dimensions 
assigned to the rows-axis.
The feature with a similar annotation is available for the column-axis.
Note that by default the totals position is at the bottom. This means the hierachy nodes expand upwards (on row level).
The position of the totals can be changed with annotation @Analytis.settings.rows.totalsLocation or @Analytis.settings.columns.totalsLocation.
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Universal display hierarchy'
@ObjectModel.modelingPattern: #ANALYTICAL_QUERY
@ObjectModel.supportedCapabilities: [#ANALYTICAL_QUERY]
// 
@Analytics.settings.rows: {
   hierarchicalDisplay: {
      active : true,
      expandTo: 'FlightYearQuarter'
   }
}

define transient view entity /DMO/ANA_C_DIM_UDH
provider contract analytical_query
as projection on /DMO/ANA_I_FlightCube
{
  @AnalyticsDetails.query: {
    axis: #ROWS,
    totals: #SHOW
  } 
  FlightYear,
  @AnalyticsDetails.query: {
    axis: #ROWS,
    totals: #SHOW
  }  
  FlightYearQuarter,
  @AnalyticsDetails.query: {
    axis: #ROWS,
    totals: #SHOW
  }  
  FlightYearMonth,
  @AnalyticsDetails.query: {
    axis: #ROWS,
    totals: #SHOW
  }  
  FlightDate,
  
  CurrencyCode,
  DistanceUnit,
    
  @AnalyticsDetails.query.axis: #COLUMNS  
  SalesAmount,
  @AnalyticsDetails.query.axis: #COLUMNS
  Distance,
  @AnalyticsDetails.query.axis: #COLUMNS
  MaximumSeats,
  @AnalyticsDetails.query.axis: #COLUMNS
  OccupiedSeats,
  @AnalyticsDetails.query.axis: #COLUMNS
  NumberOfFlights
 
}
