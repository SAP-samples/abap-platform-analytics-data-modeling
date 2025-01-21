/*
In difference of this query view to query view /DMO/ANA_C_PAR_DERIVATION is, that the parameter
P_FirstDayOfMonth is not hidden. Therefore, the derivation is only performed before the
prompts are displayed and the prompt is prefilled with the result of the derivation.
For performing the derivation the default value of P_FlightDate is used.
Tthe user can overwrite the result. But the derivation is not performed again after user 
changes the value of P_FlightDate
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'characteristic structure'
@ObjectModel: {
  supportedCapabilities: [ #ANALYTICAL_QUERY ],
  modelingPattern: #ANALYTICAL_QUERY
}
define transient view entity /DMO/ANA_C_PAR_DERIVATION_1
  provider contract analytical_query
  with parameters
    @AnalyticsDetails.variable.defaultValue: '20240909'
    P_FlightDate : /dmo/flight_date,
    @Consumption.derivation: {
      lookupEntity: 'I_CalendarDate',
      resultElement: 'FirstDayOfMonthDate',
      binding: [
        { targetElement: 'CalendarDate' , type: #PARAMETER , value: 'P_FlightDate' }
      ]  
    }
    @EndUserText.label: 'First Day'
    P_FirstDayOfMonth : /dmo/flight_date

  as projection on /DMO/ANA_I_FlightCube
{  
   @AnalyticsDetails.query: { axis: #ROWS, totals: #SHOW }
   FlightDate,
   MaximumSeats
}
where FlightDate >= $parameters.P_FirstDayOfMonth
  and FlightDate <= $parameters.P_FlightDate
