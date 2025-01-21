/*
This query shows how to define a formula with an condition. See field "NumberOfPoorUtilizedFlights". Notice that the 
Condition is calculated after aggregation. This means that the label is not '# poorly occupied flights' is not
100% correct. More precisly the field shows the number of flights in case the ocupation rate on aggregated level is poor.
If you want the number of poorly occupied flights, you have to use the exception aggregation (see for example query 
/DMO/ANA_C_CKF_EXCAGGR.

Furthermore, field "OccupationRate" shows how to deal with percentage numbers 
*/

@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Formula with Boolean'
@ObjectModel: {
  supportedCapabilities: [ #ANALYTICAL_QUERY ],
  modelingPattern: #ANALYTICAL_QUERY
}
define transient view entity /DMO/ANA_C_CKF_BOOLEAN
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
  // when the result of a calculation is a number without reference, then the Semantics
  // annotation can be added which points to a field which is set to "%"
  @Semantics.quantity.unitOfMeasure: 'Percent'
  ratio_of( portion => OccupiedSeats,
            total   => MaximumSeats ) * 100 as OccupationRate,
  @Aggregation.default: #FORMULA
  @EndUserText.label: '# poorly occupied flights'
  @AnalyticsDetails.query.axis: #COLUMNS
  case when $projection.OccupationRate <= abap.decfloat34'66' then NumberOfFlights else 0 end as NumberOfPoorUtilizedFlights,
  
  NumberOfFlights                   
      
}
where AirlineID between 'AA' and 'LH'
