/* 
This query shows how to define restrictions relativ to the values of a time-dimension in drill-down. The value is sometimes called "current member". 
Therefore, we call this a current member feature. 
The key modelling is an association to the cube itself with an on-condition on the dimension in drill down. On the other side there is a single value
defined relative to the current member. Typically the functions CALENDAR_OPERATION or CALENDAR_SHIFT are used (for fiscal times FISCAL_CALENDAR_OPERATION, FISCAL_CALENDAR_SHIFT).
The association can be used for any measure of the cube.
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Current Member (Single)'
@ObjectModel.modelingPattern: #ANALYTICAL_QUERY
@ObjectModel.supportedCapabilities: [#ANALYTICAL_QUERY]
define transient view entity /DMO/ANA_C_OLP_CURMEM_SNG
provider contract analytical_query
as projection on /DMO/ANA_I_FlightCube
  // calendar_shift with this parameterisation returns the previous month of the current member month
  association [*] to /DMO/ANA_I_FlightCube as _previousMonth 
    on _previousMonth.FlightYearMonth = calendar_shift( base        => $projection.FlightYearMonth,
                                                        base_level  => calendar_date_level.#month,
                                                        shift       => abap.int2'-1',
                                                        shift_level => calendar_date_level.#month  )
   // calendar_shift with this parameterisation returns the month in the previous quarter
   association [*] to /DMO/ANA_I_FlightCube as _MonthPrevQuarter 
    on _MonthPrevQuarter.FlightYearMonth = calendar_shift( base        => $projection.FlightYearMonth,
                                                           base_level  => calendar_date_level.#month,
                                                           shift       => abap.int2'-1',
                                                           shift_level => calendar_date_level.#quarter )                                                       

{   
   @AnalyticsDetails.query: {
     axis: #ROWS
   }
   FlightYearMonth,
   
   @EndUserText.label: 'Month'
   OccupiedSeats,
   
   @EndUserText.label: 'previous Month'
   // here the "current member" association is used
   _previousMonth.OccupiedSeats as PrevMonthOccupiedSeats,
   
   @Aggregation.default: #FORMULA
   @EndUserText.label: 'Delta to previous Month'
   $projection.occupiedseats - $projection.PrevMonthOccupiedSeats as DeltaPrevMonth,
   
   @EndUserText.label: 'Month in Previous Quarter'
   // here the "current member" association is used
   _MonthPrevQuarter.OccupiedSeats as MonthPrevQuarterSeats,
   
   @Aggregation.default: #FORMULA
   @EndUserText.label: 'Delta to Month in Previous Quarter'
   $projection.occupiedseats - $projection.MonthPrevQuarterSeats as DeltaMonthPrevQuarterSeats  
       
}
