@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Airport'
@Search.searchable: true
@Analytics.dataCategory: #DIMENSION
@ObjectModel.representativeKey: 'AirportID'
@ObjectModel: {
  supportedCapabilities: [ #ANALYTICAL_DIMENSION ],
  modelingPattern: #ANALYTICAL_DIMENSION
}
define view entity /DMO/ANA_I_Airport
  as select from /dmo/airport

  association [0..1] to I_Country              as _Country on  _Country.Country = $projection.Country

  association [0..1] to /DMO/ANA_I_City        as _City    on  _City.country = $projection.Country
                                                           and _City.city    = $projection.City

  association [0..*] to /DMO/ANA_I_AirportHier as _Hier    on  _Hier.AirportID = $projection.AirportID

{
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: ['Name']
  key airport_id     as AirportID,

      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      name           as Name,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.foreignKey.association: '_Country'
      country        as Country,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.foreignKey.association: '_City'
      city           as City,

/*
      @Semantics.spatialData: {
        srid.value : '3857',
        type : [#POINT]
      }
      _City.geopoint as Geopoint,
*/

      /* Associations */
      _Country,
      _City,

      @ObjectModel.association.toHierarchy: true
      _Hier

}
