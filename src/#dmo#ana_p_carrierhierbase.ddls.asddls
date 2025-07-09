@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Base View for Carrier Hier (tim-dep)'
define view entity /DMO/ANA_P_CarrierHierBase
  as select from /dmo/ana_cr_s_h

  association [0..1] to /DMO/ANA_I_CARRIERHIERDIR  as _Dir     on  _Dir.HierarchyID = $projection.HierarchyID

  association [0..1] to /DMO/ANA_I_CARRHIERNODE_TD as _Node    on  _Node.HierarchyID = $projection.HierarchyID
                                                               and _Node.NodeName    = $projection.NodeName

  association [0..1] to /DMO/ANA_P_CarrierHierBase as _Parent  on  _Parent.HierarchyID = $projection.HierarchyID
                                                               and _Parent.NodeID      = $projection.ParentNodeID
                                                               
  association [0..1] to /DMO/ANA_I_Carrier          as _Carrier on _Carrier.AirlineID  = $projection.AirlineID                                                               
{
      @ObjectModel.foreignKey.association: '_Dir'
  key hierarchy_id    as HierarchyID,
  key node_id         as NodeID,
      @Semantics.businessDate.to: true
  key date_to         as DateTo,
      @Semantics.businessDate.from: true
      date_from       as DateFrom,
      parent_node_id  as ParentNodeID,
      
      @ObjectModel.foreignKey.association: '_Carrier'
      carrier_id      as AirlineID,

      @ObjectModel.foreignKey.association: '_Node'      
      @EndUserText.label: 'Hierarchy Node'
      nodename        as NodeName,
      case when carrier_id is not initial
           then 'AIRLINEID'
           else 'NODENAME'
      end             as NodeType,
      sequence_number as SequenceNumber,


      _Carrier,
      _Node,
      _Dir,
      _Parent
}
