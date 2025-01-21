@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Base View for Airport Hierarchy'

define view entity /DMO/ANA_P_AirportHierBase
  as select from /dmo/ana_ap_h

  association [0..1] to /DMO/ANA_I_Airport         as _Airport on  _Airport.AirportID = $projection.AirportID

  association [0..1] to /DMO/ANA_I_City            as _City    on  _City.country = $projection.Country
                                                               and _City.city    = $projection.City

  association [0..1] to I_Country                  as _Country on  _Country.Country = $projection.Country

  association [0..1] to /DMO/ANA_I_AirportHierDir  as _Dir     on  _Dir.HierarchyID = $projection.HierarchyID

  association [0..1] to /DMO/ANA_I_AirportHierNode as _Node    on  _Node.HierarchyID = $projection.HierarchyID
                                                               and _Node.NodeName    = $projection.NodeName

  association [0..1] to /DMO/ANA_P_AirportHierBase as _Parent  on  _Parent.HierarchyID = $projection.HierarchyID
                                                               and _Parent.NodeID      = $projection.ParentNodeID
{
      @ObjectModel.foreignKey.association: '_Dir'
  key hierarchy_id    as HierarchyID,
  key node_id         as NodeID,
      parent_node_id  as ParentNodeID,
      @ObjectModel.foreignKey.association: '_Airport'
      airport         as AirportID,
      @ObjectModel.foreignKey.association: '_City'
      city            as City,
      @ObjectModel.foreignKey.association: '_Country'
      country         as Country,
      @ObjectModel.foreignKey.association: '_Node'
      @EndUserText.label: 'Hierarchy Node'
      nodename        as NodeName,
      case when nodetype = 'AIRPORT'
           then 'AIRPORTID'
           else nodetype
      end             as NodeType,
      sequence_number as SequenceNumber,

      _Airport,
      _City,
      _Country,

      _Node,
      _Dir,
      _Parent
}
