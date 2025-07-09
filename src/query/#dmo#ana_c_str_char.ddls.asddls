/*
This query shows a second structure, which is called "characteristic structure". 
Annotation @AnalyticsDetails.query.onCharacteristicStructure: true assigned an element to 
that structure
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Characteristic Structure'
@ObjectModel.modelingPattern: #ANALYTICAL_QUERY
@ObjectModel.supportedCapabilities: [#ANALYTICAL_QUERY]
define transient view entity /DMO/ANA_C_STR_CHAR
provider contract analytical_query
as projection on /DMO/ANA_I_FlightCube
{
  AirlineID,
  
  // Measure Structure
  @AnalyticsDetails.query.axis: #COLUMNS
  MaximumSeats,
  
  @AnalyticsDetails.query.axis: #COLUMNS 
  OccupiedSeats,
  
  @AnalyticsDetails.query.axis: #COLUMNS
  
  abap.unit'%' as Percent1,
   
  @AnalyticsDetails.query.axis: #COLUMNS 
  @Aggregation.default: #FORMULA
  @EndUserText.label: 'Utilization' 
  @Semantics.quantity.unitOfMeasure: 'Percent1' 
  @AnalyticsDetails.query.decimals: 2 
  ratio_of( portion => OccupiedSeats , total => MaximumSeats ) * 100 as OccupationRate,
  
  // Characteristic Structure
  @AnalyticsDetails.query: {
    axis: #ROWS,
    onCharacteristicStructure: true
  }
  @EndUserText.label: 'Jul 2024'
  case when FlightYearMonth = '202407' then 1 else null end as Jul2024,
  @AnalyticsDetails.query: {
    axis: #ROWS,
    onCharacteristicStructure: true
  }
  @EndUserText.label: 'Jun 2024'  
  case when FlightYearMonth = '202406' then 1 else null end as Jun2024
  
}
