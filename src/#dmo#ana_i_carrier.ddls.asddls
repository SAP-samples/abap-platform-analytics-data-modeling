@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@EndUserText.label: 'Carrier'
@Analytics.dataCategory: #DIMENSION
@ObjectModel.representativeKey: 'AirlineID'
@ObjectModel: {
  supportedCapabilities: [ #ANALYTICAL_DIMENSION ],
  modelingPattern: #ANALYTICAL_DIMENSION
}
@Consumption.valueHelpDefinition: [ { entity.name: '/DMO/I_Carrier_StdVH'  } ]
define view entity /DMO/ANA_I_Carrier
  as select from /dmo/carrier
{
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: ['Name']
  key carrier_id       as AirlineID,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @Semantics.text: true
      name             as Name,

      currency_code    as CurrencyCode,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at  as LastChangedAt,

      @Semantics.systemDateTime.createdAt: true
      local_created_at as LocalCreatedAt
}
