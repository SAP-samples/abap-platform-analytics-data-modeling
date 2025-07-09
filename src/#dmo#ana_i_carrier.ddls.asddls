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
  
  association [*] to /DMO/ANA_I_CarrierHier    as _hier_std on _hier_std.AirlineID = $projection.AirlineID
  association [*] to /DMO/ANA_I_CARRIERHIER_TD as _hier_dtd on _hier_dtd.AirlineID = $projection.AirlineID
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
      local_created_at as LocalCreatedAt,
      
      // Hierarchy Structure depends on time
      @ObjectModel.association.toHierarchy
      _hier_std,
      
      // Hierarchy directory depends on time
      @ObjectModel.association.toHierarchy
      _hier_dtd      
}
