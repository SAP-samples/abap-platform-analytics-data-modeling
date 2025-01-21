/*
This query shows how to define with hierarchy node variables.
The hierarchy specified by the association _DepartureAirportHier is used two times:
1) it is a display hierarchy
2) the query is filterd by a hierarchy node (set by the user)
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Parameter as hierarchy node'
@ObjectModel: {
  supportedCapabilities: [ #ANALYTICAL_QUERY ],
  modelingPattern: #ANALYTICAL_QUERY
}
define transient view entity /DMO/ANA_C_PAR_HIERNODE
  provider contract analytical_query
  with parameters
    P_HierarchyID : /dmo/ana_airport_hieid,
    // with this annotation the parameter is a hierarchy node variable at runtime
    @AnalyticsDetails.variable: {
      selectionType: #HIERARCHY_NODE,
      // the parameter can only be used in CASE WHEN and WHERE for field specified
      // with referenceElement
      referenceElement: 'DepartureAirportID',
      // a hierarchy node variable needs a referece to a hierarchy instance
      hierarchyAssociation: '_DepartureAirportHier'
   }    
    P_DepartureAirportHierNode : /dmo/airport_from_id

  as projection on /DMO/ANA_I_FlightCube
  
{  
  _DepartureAirport._Hier( p_hierarchyID: $parameters.P_HierarchyID ) as _DepartureAirportHier,
  @Consumption.hidden: true
  _DepartureAirport.AirportID as dummyDepAirport,
  
  @AnalyticsDetails.query: {
    axis: #ROWS,
    displayHierarchy: #ON,
    hierarchyAssociation: '_DepartureAirportHier'   
  }  
  @UI.textArrangement: #TEXT_ONLY  
  DepartureAirportID,
  
  @AnalyticsDetails.query.axis: #COLUMNS
  MaximumSeats,
  @AnalyticsDetails.query.axis: #COLUMNS
  OccupiedSeats
}
where DepartureAirportID = $parameters.P_DepartureAirportHierNode
