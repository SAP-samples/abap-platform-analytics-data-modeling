@AbapCatalog.sqlViewName: '/DMO/ANAFLIGHT'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Preparation View for FlightCube'
define view /DMO/ANA_P_Flight
  as select from /dmo/flight
{
  key carrier_id,
  key connection_id,
  key flight_date,
      price,
      currency_code,
      plane_type_id,
      seats_max,
      seats_occupied,
      @Semantics.amount.currencyCode: 'currency_code'
      @EndUserText.label: 'Sales Amount'
      price * seats_occupied as SalesAmount
}
