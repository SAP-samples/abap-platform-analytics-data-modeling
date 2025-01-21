/*
This query shows how to switch on text for dimension values in the
default layout
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Text fields'
@ObjectModel.modelingPattern: #ANALYTICAL_QUERY
@ObjectModel.supportedCapabilities: [#ANALYTICAL_QUERY]
define transient view entity /DMO/ANA_C_DIM_TXT
provider contract analytical_query
as projection on /DMO/ANA_I_FlightCube
{
  // lazy way - use annotation @UI.textArrangement for the 
  // dimension field 
  // at runtime the default text field from the text view 
  // derived via foreign-key and text associactions of the 
  // underlaying analytical model (cube-view)
  @AnalyticsDetails.query.axis: #ROWS
  @UI.textArrangement: #TEXT_LAST
  DepartureAirportID,
   
  // follow the path to the concrete textfield
  // usefull if the text view provided multiple text fields
  // and text field which is not the default text field
  // is needed   
  @AnalyticsDetails.query.axis: #COLUMNS
  @ObjectModel.text.element: [ 'DestinationAirportText']
  @UI.textArrangement: #TEXT_ONLY
  DestinationAirportID,
  _DestinationAirport.Name as DestinationAirportText,
 
  MaximumSeats
  
}
