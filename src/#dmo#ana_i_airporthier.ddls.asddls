@ObjectModel: {
  supportedCapabilities: [ #ANALYTICAL_PARENT_CHILD_HIERARCHY_NODE ],
  modelingPattern: #ANALYTICAL_PARENT_CHILD_HIERARCHY_NODE
}
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Airport Hierarchy'
define hierarchy /DMO/ANA_I_AirportHier
  with parameters
    p_HierarchyID : /dmo/ana_airport_hieid
  as parent child hierarchy(
    source /DMO/ANA_P_AirportHierBase
    child to parent association _Parent
    directory _Dir filter by
      HierarchyID = $parameters.p_HierarchyID
    start where
      ParentNodeID is initial
    siblings order by
      SequenceNumber
    nodetype NodeType
  )

{
  key HierarchyID,
  key NodeID,
      ParentNodeID,
      AirportID,
      City,
      Country,
      NodeName,
      NodeType,

      _Dir,
      _Parent,
      _Airport,
      _City,
      _Country,
      _Node

}
