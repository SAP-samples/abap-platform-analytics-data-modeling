/*
This query shows how to specify dynamic and static default values for a parameter
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Parameter with derivation'
@ObjectModel: {
  supportedCapabilities: [ #ANALYTICAL_QUERY ],
  modelingPattern: #ANALYTICAL_QUERY
}
define transient view entity /DMO/ANA_C_PAR_DERIVATION
  provider contract analytical_query
  with parameters
    // static default value
    // Note that you can also use @Environment.systemField: #USER_DATE instead of a fixed date
    @AnalyticsDetails.variable.defaultValue: '20240909'
    P_FlightDate : /dmo/flight_date,
    // dynamic default value: derived by selecting from field FirstDayOfMonthDate from I_CalendarDate
    // with a WHERE clause derived from binding
    // in this case the derivation selects the first day of the month the value of 
    // parameter P_FlightDate belongs to 
    @Consumption.derivation: {
      lookupEntity: 'I_CalendarDate',
      resultElement: 'FirstDayOfMonthDate',
      binding: [
        { targetElement: 'CalendarDate' , type: #PARAMETER , value: 'P_FlightDate' }
      ]  
    }
    // Parameter is hidden (there is not prompt for the parameter
    // the derivation is performed after the use changes the value of parameter P_FlightDate
    @Consumption.hidden: true
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
