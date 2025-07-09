/*
This query contains exception cells which overwrite existing cells in the grid (e.g. ShareOccupied) 
or which are relevant for calculations but not for the resultset (e.g. Max2024). 
Furthermore, it shows how to use the value of cells in the grid with scalar function
GET_CELL_REFERENCE_VALUE
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Exception Cell (with reference)'
@ObjectModel.modelingPattern: #ANALYTICAL_QUERY
@ObjectModel.supportedCapabilities: [#ANALYTICAL_QUERY]
define transient view entity /DMO/ANA_C_STR_CELL_REF
provider contract analytical_query
as projection on /DMO/ANA_I_FlightCube
{
  // Measure Structure
  @AnalyticsDetails.query.axis: #ROWS
  MaximumSeats,
  
  @AnalyticsDetails.query.axis: #ROWS
  OccupiedSeats,
  
  @Aggregation.default: #FORMULA
  @AnalyticsDetails.query.axis: #ROWS
  @EndUserText.label: 'Available Seats'
  MaximumSeats - OccupiedSeats as FreeSeats,
  
  // Characteristic Structure
  @AnalyticsDetails.query.axis: #COLUMNS
  @EndUserText.label: '2024'
  @AnalyticsDetails.query.onCharacteristicStructure: true
  case when FlightYear = '2024' then 1 else null end   as Year2024,
  
  // dummy element to get space in the grid for exception cells
  @AnalyticsDetails.query.axis: #COLUMNS
  @EndUserText.label: '% on Max Seats'
  @AnalyticsDetails.query.onCharacteristicStructure: true          
  case when FlightYear = '0000' then 1 else null end as Dummy,  

 // exception cells (in cells of column 'dummy')
  // hidden cell for later reuse
  @Aggregation.default: #FORMULA
  @Consumption.hidden: true
  @AnalyticsDetails.query.isCell : true  
  GET_CELL_REFERENCE_VALUE( measure_struc_element => $projection.maximumseats , characteristic_struc_element => $projection.Year2024 ) as Max2024, 
 
  @AnalyticsDetails.query.isCell: true
  abap.unit'%' as unitPercent,
  
  
  @Aggregation.default: #FORMULA
  @AnalyticsDetails.query: { 
    isCell : true,
    cellReference : {
      measureStructureElement : 'OccupiedSeats',
      characteristicStructureElement : 'Dummy'
    }
  }
  @AnalyticsDetails.query.decimals: 2
  @Semantics.quantity.unitOfMeasure: 'unitPercent'
  ratio_of( portion => GET_CELL_REFERENCE_VALUE( measure_struc_element => $projection.occupiedseats , 
                                                 characteristic_struc_element => $projection.Year2024 ), 
            total   => $projection.Max2024 ) * 100 as ShareOccupied,
             
  @Aggregation.default: #FORMULA
  @AnalyticsDetails.query: { 
    isCell : true,
    cellReference : {
      measureStructureElement : 'FreeSeats',
     characteristicStructureElement : 'Dummy'
    }
  }
  @AnalyticsDetails.query.decimals: 2
  @Semantics.quantity.unitOfMeasure: 'unitPercent'
  ratio_of( portion => GET_CELL_REFERENCE_VALUE( measure_struc_element => $projection.FreeSeats , 
                                                 characteristic_struc_element => $projection.Year2024 ),
            total   => $projection.Max2024 ) * 100 as ShareFree             
}
