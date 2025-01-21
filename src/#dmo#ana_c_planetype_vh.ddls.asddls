@ObjectModel: {
  dataCategory: #VALUE_HELP,
  supportedCapabilities: [ #VALUE_HELP_PROVIDER ],
  modelingPattern: #VALUE_HELP_PROVIDER
}
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Planetype (simple ValueHelp)'

define view entity /DMO/ANA_C_PLANETYPE_VH 
as select from /dmo/flight
{
  plane_type_id as PlaneType
}
group by plane_type_id
