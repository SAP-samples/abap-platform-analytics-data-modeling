/*
This query shows how to add a display hierarchy to the default layout
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Display Hierarchy'
@ObjectModel.modelingPattern: #ANALYTICAL_QUERY
@ObjectModel.supportedCapabilities: [#ANALYTICAL_QUERY]
define transient view entity /DMO/ANA_C_DIM_HIER
provider contract analytical_query
with parameters
  @AnalyticsDetails.variable.mandatory: false
  p_hierarchyID : /dmo/ana_airport_hieid
as projection on /DMO/ANA_I_FlightCube
{ 
  // _DepartureAirport is from cube to airport dimension view 
  // and _Hier is the path from the airport dimension to its hierarchy view
  // Since the parameter of the hierarchy view is bound to a parameter of the
  // query view, the user can choose a concrete hierarchy instance at runtime
  _DepartureAirport._Hier( p_hierarchyID: $parameters.p_hierarchyID ) as _DepartureAirportHier,
  // this field is only for CDS consistency reasons and should always be hidden
  // an alias name which is not in conflict with any other fieldname is usefull
  @Consumption.hidden: true
  _DepartureAirport.AirportID as dummyDepAirport,
  
  @AnalyticsDetails.query: {
    axis: #ROWS,
    displayHierarchy: #ON,
    // this annotation adds the association to the airport hierarchy view to 
    // the field DepartureAirportID 
    hierarchyAssociation: '_DepartureAirportHier'
  }  
  @UI.textArrangement: #TEXT_ONLY  
  DepartureAirportID,
  
  @AnalyticsDetails.query.axis: #COLUMNS
  MaximumSeats,
  @AnalyticsDetails.query.axis: #COLUMNS
  OccupiedSeats
}
