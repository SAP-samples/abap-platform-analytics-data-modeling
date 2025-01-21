@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Connection'
@Search.searchable: true
@Analytics.dataCategory: #DIMENSION
@ObjectModel.representativeKey: 'ConnectionID'
@ObjectModel: {
  supportedCapabilities: [ #ANALYTICAL_DIMENSION ],
  modelingPattern: #ANALYTICAL_DIMENSION
}
define view entity /DMO/ANA_I_Connection
  as select from /dmo/connection as Connection

  association [1..1] to /DMO/ANA_I_Carrier as _Carrier            on _Carrier.AirlineID = $projection.AirlineID
  association [1..1] to /DMO/ANA_I_Airport as _DepartureAirport   on _DepartureAirport.AirportID = $projection.DepartureAirportID
  association [1..1] to /DMO/ANA_I_Airport as _DestinationAirport on _DestinationAirport.AirportID = $projection.DestinationAirportID

{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.foreignKey.association: '_Carrier'
  key Connection.carrier_id      as AirlineID,

      @Search.defaultSearchElement: true
  key Connection.connection_id   as ConnectionID,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.foreignKey.association: '_DepartureAirport'
      Connection.airport_from_id as DepartureAirportID,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.foreignKey.association: '_DestinationAirport'
      Connection.airport_to_id   as DestinationAirportID,

      Connection.departure_time  as DepartureTime,

      Connection.arrival_time    as ArrivalTime,

      @Semantics.quantity.unitOfMeasure: 'DistanceUnit'
      Connection.distance        as Distance,

      Connection.distance_unit   as DistanceUnit,

      /* Associations */
      _Carrier,
      _DepartureAirport,
      _DestinationAirport
}
