@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Text'
define view entity ZI_DA2309_CustomerText
  as select from /dmo/customer
{
  key customer_id                                 as CustomerId,
      concat_with_space(first_name, last_name, 1) as CustomerName
}
