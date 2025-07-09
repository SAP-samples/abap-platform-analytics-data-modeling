@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'City'
@Analytics.dataCategory: #DIMENSION
@ObjectModel.representativeKey: 'City'
@ObjectModel: {
  supportedCapabilities: [ #ANALYTICAL_DIMENSION ],
  modelingPattern: #ANALYTICAL_DIMENSION
}

define view entity /DMO/ANA_I_City
  as select from /dmo/ana_city
  association [1..1] to I_Country as _Country on _Country.Country = $projection.country
{
      @ObjectModel.foreignKey.association: '_Country'
  key country,
  key city,
      @Analytics.hidden: true
      latitude,
      @Analytics.hidden: true
      longitude,
      
      @Semantics.spatialData: {
        srid.value : '3857',  // SRID = 3857: Pseudo-Mercator Coordinates
        type : [#POINT]
      }
      geopoint,

      _Country
}
