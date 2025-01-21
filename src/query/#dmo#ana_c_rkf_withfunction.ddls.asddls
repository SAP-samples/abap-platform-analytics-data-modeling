/*
This query shows how to use functions in restricted measures
Allowed functions for a filter in a restricted measure on the right sight are:
- CALENDAR_SHIFT,
- CALENDAR_OPERATION,
- FISCAL_CALENDAR_SHIFT,
- FISCAL_CALENDAR_OPERATION,
- DATS_ADD_DAYS, DATN_ADD_DAYS
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Restricted Measure with function'
@ObjectModel: {
  supportedCapabilities: [ #ANALYTICAL_QUERY ],
  modelingPattern: #ANALYTICAL_QUERY
}
define transient view entity /DMO/ANA_C_RKF_WITHFUNCTION
  provider contract analytical_query
  with parameters
    @EndUserText.label: 'Year Month'
    @Consumption.defaultValue: '202403'
    @Consumption.hidden: true
    p_YearMonth : abap.numc( 6 )
  as projection on /DMO/ANA_I_FlightCube
{
// Dimensions
  @AnalyticsDetails.query: { 
    axis: #ROWS,
    totals: #SHOW
  }
  AirlineID,
  FlightYearMonth,
  
// Measures  
  @AnalyticsDetails.query.axis: #COLUMNS
  @Consumption.dynamicLabel: {
    label: 'Occupied Seats in &1',
    binding: [{ index : 1 , element: 'FlightYearMonth' , format: #TEXT }]
  }
  case when FlightYearMonth = $parameters.p_YearMonth then OccupiedSeats else null end as OccupiedSeatsMonth,
  
  @AnalyticsDetails.query.axis: #COLUMNS
  @Consumption.dynamicLabel: {
    label: 'Occupied Seats in &1',
    binding: [{ index : 1 , element: 'FlightYearMonth' , format: #TEXT }]
  }  
  // previous month / month before parameter
  case when FlightYearMonth = calendar_shift( base        => $parameters.p_YearMonth,
                                              base_level  => calendar_date_level.#month,
                                              shift       => abap.int2'-1',
                                              shift_level => calendar_date_level.#month )
       then OccupiedSeats else null end as OccupiedSeatsPrevMonth,

  @AnalyticsDetails.query.axis: #COLUMNS
  @Consumption.dynamicLabel: {
    label: 'Occupied Seats from &1 to &2',
    binding: [{ index : 1 , element: 'FlightYearMonth' , replaceWith: #LOW,  format: #TEXT },
              { index : 2 , element: 'FlightYearMonth' , replaceWith: #HIGH, format: #TEXT }]
  }
  // from first month in year (of the year the parameter belongs to) to parameter-value  
  case when FlightYearMonth between calendar_operation( base            => $parameters.p_YearMonth,
                                                        base_level      => calendar_date_level.#month,
                                                        operation       => calendar_date_operation.#first,
                                                        operation_level => calendar_date_level.#year )
                                and $parameters.p_YearMonth
       then OccupiedSeats else null end as OccupiedSeatsYTD    
}
