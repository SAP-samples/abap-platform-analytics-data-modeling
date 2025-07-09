/*
This query shows the feature of "exception aggregation" - see field "NumberOfAirplains". It is usefull
if something should be counted.
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Formulas with Counter'
@ObjectModel: {
  supportedCapabilities: [ #ANALYTICAL_QUERY ],
  modelingPattern: #ANALYTICAL_QUERY
}
define transient view entity /DMO/ANA_C_CKF_EXCAGGR_CNT
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
    totals: #SHOW
  }
  PlaneType,
  
  @AnalyticsDetails.query: { 
    totals: #SHOW
  }  
  DepartureAirportID,
    
// Measures    
  @Aggregation.default: #FORMULA
  @EndUserText.label: '# Planetypes'  
  // "Exception aggregation" means that logically, data is read on the level of the exception aggregation elements
  // (in this case PlaneType) plus the elements on rows and columns in the query result.
  // On this level the formula is calculated (in this case the result is 1) and then the data is aggregated with exception aggregation behavior (here SUM) to the 
  // level of the query result. With this you count the number of distinct "PlaneTypes" 
  @AnalyticsDetails.exceptionAggregationSteps: [{ exceptionAggregationBehavior: #SUM,
                                                  exceptionAggregationElements: [ 'PlaneType' ] }]
  abap.int4'1' as NumberOfAirplains
      
}
where AirlineID between 'AA' and 'LH'
