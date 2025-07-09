@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Directory for Carrier Hier (tim-dep)'
@Analytics.dataCategory: #DIMENSION
@ObjectModel.representativeKey: 'HierarchyID'
@ObjectModel: {
  supportedCapabilities: [ #ANALYTICAL_DIMENSION ],
  modelingPattern: #ANALYTICAL_DIMENSION
}
define view entity /DMO/ANA_I_CARRIERHIERDIR_TD
  as select from /dmo/ana_cr_t_hd
{
      @ObjectModel.text.element: [ 'Name' ]
  key hierarchy_id    as HierarchyID,
      @Semantics.businessDate.to: true
  key date_to         as DateTo,
      @Semantics.businessDate.from: true
      date_from       as DateFrom,
      @Semantics.text: true
      name            as Name,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt
}
