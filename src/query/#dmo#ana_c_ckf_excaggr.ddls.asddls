/*
This query shows the feature of "exception aggregation" - see field "CorrectNumber".
Field "NumberOfPoorUtilizedFlights" is based on the same formula but it is calculated without 
exception aggregation.
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Formulas with Exception Aggregation'
@ObjectModel: {
  supportedCapabilities: [ #ANALYTICAL_QUERY ],
  modelingPattern: #ANALYTICAL_QUERY
}
define transient view entity /DMO/ANA_C_CKF_EXCAGGR
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

  @AnalyticsDetails.query: { 
    totals: #SHOW
  }       
  FlightDate,
    
// Measures 
  @AnalyticsDetails.query.axis: #COLUMNS
  MaximumSeats,
  @AnalyticsDetails.query.axis: #COLUMNS
  OccupiedSeats,
  abap.unit'%' as Percent,
  @Aggregation.default: #FORMULA
  @AnalyticsDetails.query.axis: #COLUMNS
  @EndUserText.label: 'Occupation Rate'
  @Semantics.quantity.unitOfMeasure: 'Percent'
  ratio_of( portion => OccupiedSeats,
            total   => MaximumSeats ) *100 as OccupationRate,
  @Aggregation.default: #FORMULA
  @EndUserText.label:  '# poorly occupied flights'
  @AnalyticsDetails.query.axis: #COLUMNS
  case when $projection.OccupationRate <= abap.decfloat34'66' then NumberOfFlights else 0 end as NumberOfPoorUtilizedFlights,
  
  @Aggregation.default: #FORMULA
  @EndUserText.label: 'Correct # poorly occupied flights'
  @AnalyticsDetails.query.axis: #COLUMNS  
  // "Exception aggregation" means that logically, data is read on the level of the exception aggregation elements
  // (in this case AirlineID, ConnectionID and FlightDate) plus the elements on rows and columns in the query result.
  // On this level the formula is calculated and then the data is aggregated with exception aggregation behavior (here SUM) to the 
  // level of the query result.
  @AnalyticsDetails.exceptionAggregationSteps: [{ exceptionAggregationBehavior: #SUM,
                                                  exceptionAggregationElements: [ 'AirlineID' , 'ConnectionID', 'FlightDate' ] }]
  $projection.NumberOfPoorUtilizedFlights as CorrectNumber,
  
  NumberOfFlights                   
      
}
where AirlineID between 'AA' and 'LH'
