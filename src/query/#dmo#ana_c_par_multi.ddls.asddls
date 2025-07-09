/*
This query shows the usage of parameters in different contexts
It also shows how the labels of restricted measures fields SalesAmountInTargetCurr, SalesAmountInYear
such that the label reflects the input for the variables
*/
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Many Parameters'
@ObjectModel: {
  supportedCapabilities: [ #ANALYTICAL_QUERY ],
  modelingPattern: #ANALYTICAL_QUERY
}
define transient view entity /DMO/ANA_C_PAR_Multi
  provider contract analytical_query
  with parameters
    P_HierarchyID : /dmo/ana_airport_hieid,
    @AnalyticsDetails.variable: {
      selectionType: #HIERARCHY_NODE,
      referenceElement: 'DepartureAirportID',
      hierarchyAssociation: '_DepartureAirportHier'
   }    
    P_DepartureAirportHierNode : /dmo/airport_from_id,

    P_TargetCurrency : abap.cuky,
    
    P_ExchangeRateType : kurst_curr,
    
    @AnalyticsDetails.variable.selectionType: #INTERVAL
    P_FlightYear : calendaryear,
   
    @AnalyticsDetails.variable.mandatory: false
    P_PlaneType : /dmo/plane_type_id,
     
    @EndUserText.label: 'Increase %'
    P_Simulation : abap.int4
  as projection on /DMO/ANA_I_FlightCube
  
{  
  _DepartureAirport._Hier( p_hierarchyID: $parameters.P_HierarchyID ) as _DepartureAirportHier,
  @Consumption.hidden: true
  _DepartureAirport.AirportID as dummyDepAirport,
  
  @AnalyticsDetails.query: {
    axis: #ROWS,
    displayHierarchy: #ON,
    hierarchyAssociation: '_DepartureAirportHier'
  }  
  @UI.textArrangement: #TEXT_ONLY  
  DepartureAirportID,
  
  CurrencyCode,
  
  @AnalyticsDetails.query.axis: #COLUMNS
  @Semantics.amount.currencyCode: 'CurrencyCode'
  curr_to_decfloat_amount( SalesAmount ) as SalesAmount,
  
  virtual TargetCurrency : abap.cuky,
  
  @AnalyticsDetails.query.axis: #COLUMNS
  @Aggregation.default: #FORMULA
  @Consumption.dynamicLabel: {
    label: 'SalesAmount in &1 and ExchangeRate &2',
    binding: [ { index: 1 , parameter: 'P_TargetCurrency' },
               { index: 2 , parameter: 'P_ExchangeRateType' } ]
  }
  @Semantics.amount.currencyCode: 'TargetCurrency'
  currency_conversion( amount => SalesAmount,
                       source_currency => CurrencyCode,
                       target_currency => $parameters.P_TargetCurrency,
                       exchange_rate_date => '20241111',
                       exchange_rate_type => $parameters.P_ExchangeRateType )
                     as SalesAmountInTargetCurr,
     
  virtual CurrencyInYear : abap.cuky,
  
  @AnalyticsDetails.query.axis: #COLUMNS
  @Consumption.dynamicLabel: {
    label: 'SalesAmount from &1 to &2',
    binding: [{ index: 1 , parameter: 'P_FlightYear' , replaceWith: #LOW },  
              { index: 2 , parameter: 'P_FlightYear' , replaceWith: #HIGH }]
  }
  @Semantics.amount.currencyCode: 'CurrencyInYear'                   
  case when FlightYear = $parameters.P_FlightYear then SalesAmount else null end as SalesAmountInYear,                     
                                                                
  @AnalyticsDetails.query.axis: #COLUMNS
  @Aggregation.default: #FORMULA
  @EndUserText.label: 'Simulated SalesAmount'
  @Semantics.amount.currencyCode: 'CurrencyCode'
  ( 1 + $parameters.P_Simulation / 100 ) * $projection.SalesAmount  as SimulatedSalesAmount
  
}
where DepartureAirportID = $parameters.P_DepartureAirportHierNode
  and PlaneType = $parameters.P_PlaneType
