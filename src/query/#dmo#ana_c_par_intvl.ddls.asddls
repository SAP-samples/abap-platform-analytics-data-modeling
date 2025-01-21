/*
This query has a hidden parameter, which is a interval variable with low and high value 
filled with default values
The query is filtered by this parameter.
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'variable Interval filter'
@ObjectModel: {
  supportedCapabilities: [ #ANALYTICAL_QUERY ],
  modelingPattern: #ANALYTICAL_QUERY
}
define transient view entity /DMO/ANA_C_PAR_INTVL
  provider contract analytical_query
  with parameters
    @AnalyticsDetails.variable: {
      selectionType: #INTERVAL,
      defaultValue:     '202403',
      defaultValueHigh: '202408'
   }    
   @Consumption.hidden: true
    p_YearMonth : vdm_yearmonth

  as projection on /DMO/ANA_I_FlightCube
{  
   @AnalyticsDetails.query: {
     axis: #ROWS, totals: #SHOW
   }
   FlightYearMonth,
   MaximumSeats
}
where   FlightYearMonth = $parameters.p_YearMonth
// since interval parameter is hidden and is filled with static defaults,
// the usage of the parameter is not necessary and instead a static WHERE clause could
// be used:
// WHERE FlightYearMonth between '202403' and '202408'
