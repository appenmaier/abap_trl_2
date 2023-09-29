@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer'
define view entity ZI_DA2309_Customer
  as select from /dmo/customer
{
  key customer_id  as CustomerId,
      first_name   as FirstName,
      last_name    as LastName,
      title        as Title,
      street       as Street,
      postal_code  as PostalCode,
      city         as City,
      country_code as CountryCode
}
