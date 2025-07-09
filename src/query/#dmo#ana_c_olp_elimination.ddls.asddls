/*
This query shows how the feature "elimination of inter business volume". This feature requires a cube with pairs of fields
with a foreign key associations to the same dimension. Usually this dimension supports hierarchies.
In this example the fields are DepartureAirportID and DestinationAirportID.
A flight for a hierarchy node on departure airport is called "inner", if the destination airport is a decendent of that node. 
So it can happen that for one node the flight is not "inner" but for another node it is "inner". If a flight is "inner", then
data is ignored in the result.
This feature is used to get the number of seats which leave the country/region (element OccSeatsExternal) or which are from an 
airport to an airport which are both in that country/region (element OccSeatsInternal).
With annotation AnalyticsDetails.elimination the pairs for elimination are defined. Multiple pairs can be defined. 
In addition a rule can be set, if "inner" is applied if one pair fulfills the "inner" rule or if all pairs must fulfill the
"inner" rule.  
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Elimination: External/Internal flights'
@ObjectModel.modelingPattern: #ANALYTICAL_QUERY
@ObjectModel.supportedCapabilities: [#ANALYTICAL_QUERY]
define transient view entity /DMO/ANA_C_OLP_ELIMINATION
provider contract analytical_query
as projection on /DMO/ANA_I_FlightCube
{
  _DestinationAirport._Hier( p_hierarchyID : 'GEO' ) as _DestAirportHier,
  @Consumption.hidden: true
  _DestinationAirport.AirportID as DummyDestAirport,  
  _DepartureAirport._Hier( p_hierarchyID : 'GEO' ) as _DepAirportHier,
  @Consumption.hidden: true
  _DepartureAirport.AirportID as DummyDepAirport,
  
  @AnalyticsDetails.query: {
    axis: #ROWS,
    displayHierarchy: #ON,
    hierarchyAssociation: '_DepAirportHier'
  }
  @UI.textArrangement: #TEXT_ONLY
  DepartureAirportID,
  
  @AnalyticsDetails.query: {
    axis: #ROWS,
    displayHierarchy: #ON,
    hierarchyAssociation: '_DestAirportHier'
  }
  @UI.textArrangement: #TEXT_ONLY  
  DestinationAirportID,
  
  OccupiedSeats,
  @EndUserText.label: 'Occupied Seats (only External)'
  @AnalyticsDetails.elimination: { pair: [{ dimension1 : 'DepartureAirportID' , dimension2: 'DestinationAirportID' }] }
  OccupiedSeats as OccSeatsExternal,
  
  @Aggregation.default: #FORMULA
  @EndUserText.label: 'Occupied Seats (only Internal)'
  OccupiedSeats - $projection.OccSeatsExternal as OccSeatsInternal
}
