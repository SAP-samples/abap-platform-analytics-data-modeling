/*
This query uses parameters in the where clause. This means the end user can
choose concreate values which should be used as filters.
The input help (F4) is derived from foreign key associaitons of the
underlying analytical model (cube view).
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Parameter with special value help'
@ObjectModel.modelingPattern: #ANALYTICAL_QUERY
@ObjectModel.supportedCapabilities: [#ANALYTICAL_QUERY]
define transient view entity /DMO/ANA_C_PAR_1
provider contract analytical_query
  with parameters
    P_Airline : /dmo/carrier_id,
    // By default parameters become prompts with mandatory input
    // With this annotation the prompt becomes optional and user
    // needs not to enter a value for the prompt. 
    @AnalyticsDetails.variable.mandatory: false
    p_Planetype : /dmo/plane_type_id
as projection on /DMO/ANA_I_FlightCube {
  @AnalyticsDetails.query.axis: #ROWS
  AirlineID,
  MaximumSeats
} where AirlineID = $parameters.P_Airline
     and  PlaneType = $parameters.p_Planetype
