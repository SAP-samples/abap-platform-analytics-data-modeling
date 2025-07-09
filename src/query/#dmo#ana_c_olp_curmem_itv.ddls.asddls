/* 
This query shows how to define restrictions relativ to the values of a time-dimension in drill-down. The value is sometimes called "current member". 
Therefore, we call this a current member feature. 
The key modelling is an association to the cube itself with an on-condition on the dimension in drill down. On the other side there is a interval 
which defines the range relative to the current member. Typically the functions CALENDAR_OPERATION or CALENDAR_SHIFT are used (for fiscal times FISCAL_CALENDAR_OPERATION, FISCAL_CALENDAR_SHIFT).
The association can be used for any measure of the cube.
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Current Member (Interval)'
@ObjectModel.modelingPattern: #ANALYTICAL_QUERY
@ObjectModel.supportedCapabilities: [#ANALYTICAL_QUERY]
define transient view entity /DMO/ANA_C_OLP_CURMEM_ITV
provider contract analytical_query
as projection on /DMO/ANA_I_FlightCube
  association [*] to /DMO/ANA_I_FlightCube as _QtD 
    // calendar_operation with this parameterisation returns the first month of the quarter of the current member month
    // So it defines the interval from first month of the quarter to the current month
    on _QtD.FlightYearMonth between calendar_operation( base            => $projection.FlightYearMonth,
                                                        base_level      => calendar_date_level.#month,
                                                        operation       => calendar_date_operation.#first,
                                                        operation_level => calendar_date_level.#quarter  )
                              and $projection.FlightYearMonth
                               
   association [*] to /DMO/ANA_I_FlightCube as _ThreeMonthWindow
    // calendar_shift with this parameterisation returns two month before the current member month  
    on _ThreeMonthWindow.FlightYearMonth between calendar_shift( base        => $projection.FlightYearMonth,
                                                                 base_level  => calendar_date_level.#month,
                                                                 shift       => abap.int2'-2',
                                                                 shift_level => calendar_date_level.#month )  
                                         and $projection.FlightYearMonth                                                     

{  @AnalyticsDetails.query: {
     axis: #ROWS,
     totals: #SHOW
   } 
   FlightYearQuarter,
   
   @AnalyticsDetails.query: {
     axis: #ROWS,
     totals: #SHOW
   }
   FlightYearMonth,
   
   @EndUserText.label: 'Month'
   OccupiedSeats,
   
   @EndUserText.label: 'Quarter to Date'
   // here the "current member" association is used
   _QtD.OccupiedSeats as QtD_OccupiedSeats,

   @EndUserText.label: 'last 3 Periods'
   // here the "current member" association is used
   _ThreeMonthWindow.OccupiedSeats as ThreeMonthWindow,
   
   @Aggregation.default: #FORMULA
   @EndUserText.label: 'AVG last 3 Periods'
   @AnalyticsDetails.exceptionAggregationSteps: [{ exceptionAggregationBehavior: #AVG , exceptionAggregationElements: [ 'FlightYearMonth' ] }]
   $projection.ThreeMonthWindow as AVGThreeMonthWindow
       
}
where FlightYear = '2024'
