/* 
This query shows how to "fill up" the drill down of a dimension with values from values from
the dimension which are not part of the query result
This is usefull for example:
- With special filters there is not data available for all month of a query but a chart is
  needed which shows all month
- The business user is interesed e.g. in products which were not soled
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Unbooked values'
@ObjectModel: {
  supportedCapabilities: [ #ANALYTICAL_QUERY ],
  modelingPattern: #ANALYTICAL_QUERY
}
define transient view entity /DMO/ANA_C_DIM_Unbooked
  provider contract analytical_query
  as projection on /DMO/ANA_I_FlightCube
{
   @AnalyticsDetails.query: {
     axis: #ROWS,
     totals: #SHOW,
     // this annotation switches on the unbooked feature 
     resultValuesSource: #DIMENSION
   }
   AirlineID,
   
   MaximumSeats
}
