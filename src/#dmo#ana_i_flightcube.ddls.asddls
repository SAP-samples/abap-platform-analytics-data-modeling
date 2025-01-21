@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Flight Cube'
@Search.searchable: true
@Analytics: {
  dataCategory: #CUBE,
  internalName: #LOCAL
}
@ObjectModel: {
  supportedCapabilities: [ #ANALYTICAL_PROVIDER ],
  modelingPattern: #ANALYTICAL_CUBE
}

define view entity /DMO/ANA_I_FlightCube
  as select from /DMO/ANA_P_Flight

  association [1..1] to /DMO/ANA_I_Carrier    as _Airline            on  _Airline.AirlineID = $projection.AirlineID

  association [1..1] to /DMO/ANA_I_Connection as _Connection         on  _Connection.ConnectionID = $projection.ConnectionID
                                                                     and _Connection.AirlineID    = $projection.AirlineID

  association [1..1] to /DMO/ANA_I_Airport    as _DepartureAirport   on  _DepartureAirport.AirportID = $projection.DepartureAirportID

  association [1..1] to /DMO/ANA_I_Airport    as _DestinationAirport on  _DestinationAirport.AirportID = $projection.DestinationAirportID

  association [1..1] to I_CalendarDate        as _FlightDate         on  _FlightDate.CalendarDate = $projection.FlightDate
{
      /* Dimension */
      @Search.defaultSearchElement: true
      @ObjectModel.foreignKey.association: '_Airline'
  key carrier_id                       as AirlineID,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.foreignKey.association: '_Connection'
  key connection_id                    as ConnectionID,

      @Search.defaultSearchElement: true
  key flight_date                      as FlightDate,

      @Semantics.calendar.year: true
      @ObjectModel.value.derivedFrom: [ 'FlightDate' ]
      @EndUserText.label: 'Flight Year'
      _FlightDate.CalendarYear         as FlightYear,

      @Semantics.calendar.yearQuarter: true
      @ObjectModel.value.derivedFrom: [ 'FlightDate' ]
      @EndUserText.label: 'Flight Year Quarter'
      _FlightDate.YearQuarter          as FlightYearQuarter,

      @Semantics.calendar.quarter: true
      @ObjectModel.value.derivedFrom: [ 'FlightDate' ]
      @EndUserText.label: 'Flight Quarter'
      _FlightDate.CalendarQuarter      as FlightQuarter,

      @Semantics.calendar.yearMonth: true
      @ObjectModel.value.derivedFrom: [ 'FlightDate' ]
      @EndUserText.label: 'Flight Year Month'
      _FlightDate.YearMonth            as FlightYearMonth,

      @Semantics.calendar.month: true
      @ObjectModel.value.derivedFrom: [ 'FlightDate' ]
      @EndUserText.label: 'Flight Month'
      _FlightDate.CalendarMonth        as FlightMonth,

      @ObjectModel.foreignKey.association: '_DepartureAirport'
      _Connection.DepartureAirportID   as DepartureAirportID,

      @ObjectModel.foreignKey.association: '_DestinationAirport'
      _Connection.DestinationAirportID as DestinationAirportID,

      plane_type_id                    as PlaneType,

      /* Measures and Units/Currencies */
      currency_code                    as CurrencyCode,

      
      @Semantics.amount.currencyCode: 'CurrencyCode'
      @Aggregation.default: #SUM
      SalesAmount,
      
      @Semantics.quantity.unitOfMeasure: 'DistanceUnit'
      @Aggregation.default: #SUM
      _Connection.Distance             as Distance,

      _Connection.DistanceUnit         as DistanceUnit,

      @Aggregation.default: #SUM
      seats_max                        as MaximumSeats,
      @Aggregation.default: #SUM
      seats_occupied                   as OccupiedSeats,

      @Aggregation.default: #SUM
      @EndUserText.label: 'Number of Flights'
      abap.int8'1'                     as NumberOfFlights,

      /* Associations */
      _Airline,
      _Connection,
      _DepartureAirport,
      _DestinationAirport,

      _FlightDate._CalendarQuarter     as _CalendarQuarter,
      _FlightDate._CalendarMonth       as _CalendarMonth,
      _FlightDate._YearMonth           as _YearMonth,
      _FlightDate._CalendarYear        as _CalendarYear

}
