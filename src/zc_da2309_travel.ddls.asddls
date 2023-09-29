@EndUserText.label: 'Travel'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZC_DA2309_Travel
  provider contract transactional_query
  as projection on ZR_DA2309_Travel
{
  key TravelUuid,
      TravelId,
      AgencyId,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_DA2309_CustomerVH', element: 'CustomerId' } }]
      @ObjectModel.text.element: [ 'CustomerName' ]
      CustomerId,
      BeginDate,
      EndDate,
      BookingFee,
      TotalPrice,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CurrencyStdVH', element: 'Currency' } }]
      CurrencyCode,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      Description,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_DA2309_StatusVH', element: 'Status' } }]
      Status,

      /* Admin Data */
      Createdby,
      Createdat,
      Lastchangedby,
      Lastchangedat,

      /* Transient Data */
      StatusCriticality,
      BeginDateCriticality,
      _CustomerText.CustomerName as CustomerName,

      /* Associations */
      _Bookings : redirected to composition child ZC_DA2309_Booking
}
