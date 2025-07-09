/*
This queries has a measure-, a characteristic- structure and exception cells. 
In this example, the exception cell emptyCell overwrites a cell spanned by the measure and characteristic structure
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Exception Cell'
@ObjectModel.modelingPattern: #ANALYTICAL_QUERY
@ObjectModel.supportedCapabilities: [#ANALYTICAL_QUERY]
define transient view entity /DMO/ANA_C_STR_CELL
provider contract analytical_query
as projection on /DMO/ANA_I_FlightCube
{
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
  case when FlightYearMonth = '202406' then 1 else null end as Jun2024,
   
  @AnalyticsDetails.query: {
    axis: #ROWS,
    onCharacteristicStructure: true
  }
  @Aggregation.default: #FORMULA
  @EndUserText.label: 'Difference' 
  $projection.Jul2024 - $projection.Jun2024 as MonthDiff, 
  
   // Exception cell (overwrite the formula collision)
  
   @AnalyticsDetails.query: {
     isCell: true,
     cellReference: {
       measureStructureElement:        'OccupationRate' ,
       characteristicStructureElement: 'MonthDiff'
     }
   }
   case when FlightYear = '0000' then MaximumSeats else null end as emptyCell
  
}
