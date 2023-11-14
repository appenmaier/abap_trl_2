@EndUserText.label: 'Booking Fee'
define abstract entity ZA_DA2309_BookingFee
{
  @Semantics.amount.currencyCode: 'CurrencyCode'
  BookingFee   : /dmo/booking_fee;
  @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CurrencyStdVH', element: 'Currency' } }]
  CurrencyCode : /dmo/currency_code;
}
