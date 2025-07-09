/* 
This query shows the usage of two structures (measure- and characteristic- structure)
Measure structure -> all measures, restricted measures or formulas containing restricted measures form a structure 
Memebers of the characteristic are either restrictions following the CDS pattern
CASE WHEN <filter on dimensions> THEN 1 ELSE NULL END AS <fieldAlias>
or they can be formulas using fields of the characteristic structure
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'characteristic structure'
@ObjectModel: {
  supportedCapabilities: [ #ANALYTICAL_QUERY ],
  modelingPattern: #ANALYTICAL_QUERY
}
define transient view entity /DMO/ANA_C_2ST_SIMPLE
  provider contract analytical_query
  as projection on /DMO/ANA_I_FlightCube
{
// measure structure
   @AnalyticsDetails.query.axis: #ROWS
   OccupiedSeats,
   @AnalyticsDetails.query.axis: #ROWS
   MaximumSeats,
   @AnalyticsDetails.query.axis: #ROWS
   @Aggregation.default: #FORMULA
   @EndUserText.label: 'Available Seats'
   MaximumSeats - OccupiedSeats as FreeSeats,
   
   abap.unit'%' as UnitPercent,
   
   @AnalyticsDetails.query: { 
     axis: #ROWS,
     decimals: 2  // show result with 2 decimal places
   }
   @Aggregation.default: #FORMULA
   @EndUserText.label: 'Occupied Rate'
   @Semantics.quantity.unitOfMeasure: 'UnitPercent'
   ratio_of( portion => OccupiedSeats, total => MaximumSeats ) * 100 as OccupationRate,
   
// characteristic structure
   @AnalyticsDetails.query: {
     axis: #COLUMNS,
     onCharacteristicStructure: true
   }
   @EndUserText.label: 'Year 2025'
   case when FlightYear = '2025' then 1 else null end as Year2025,
   
   @AnalyticsDetails.query: {
     axis: #COLUMNS,
     onCharacteristicStructure: true
   }   
   @EndUserText.label: 'Year 2024'
   case when FlightYear = '2024' then 1 else null end as Year2024, 
   
   @AnalyticsDetails.query: {
     axis: #COLUMNS,
     onCharacteristicStructure: true
   } 
   @EndUserText.label: 'Year 2025 - Year 2024' 
   @Aggregation.default: #FORMULA
   $projection.Year2025 - $projection.Year2024 as YearDifference     
      
}
