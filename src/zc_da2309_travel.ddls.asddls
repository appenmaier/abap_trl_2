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
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Agency_StdVH', element: 'AgencyID' } }]
      AgencyId,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_DA2309_CustomerVH', element: 'CustomerId' } }]
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

      /* TransientData */
      CustomerName,
      StatusCriticality,
      BeginDateCriticality,
      SystemDate,

      /* Associations */
      _Bookings : redirected to composition child ZC_DA2309_Booking
}
