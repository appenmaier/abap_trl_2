CLASS zcm_da2310_travel DEFINITION PUBLIC
  INHERITING FROM cx_static_check FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    " Interfaces
    INTERFACES if_abap_behv_message.
    INTERFACES if_t100_message.
    INTERFACES if_t100_dyn_msg.

    " Message Constants
    CONSTANTS:
      BEGIN OF test_message,
        msgid TYPE symsgid      VALUE 'ZDA2309_TRAVEL',
        msgno TYPE symsgno      VALUE '001',
        attr1 TYPE scx_attrname VALUE 'USER_NAME',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF test_message.

    CONSTANTS:
      BEGIN OF travel_already_cancelled,
        msgid TYPE symsgid      VALUE 'ZDA2309_TRAVEL',
        msgno TYPE symsgno      VALUE '003',
        attr1 TYPE scx_attrname VALUE 'DESCRIPTION',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF travel_already_cancelled.

    CONSTANTS:
      BEGIN OF travel_cancelled_successfully,
        msgid TYPE symsgid      VALUE 'ZDA2309_TRAVEL',
        msgno TYPE symsgno      VALUE '002',
        attr1 TYPE scx_attrname VALUE 'DESCRIPTION',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF travel_cancelled_successfully.

    CONSTANTS:
      BEGIN OF no_agency_found,
        msgid TYPE symsgid      VALUE 'ZDA2309_TRAVEL',
        msgno TYPE symsgno      VALUE '004',
        attr1 TYPE scx_attrname VALUE 'AGENCY_ID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF no_agency_found.

    CONSTANTS:
      BEGIN OF no_customer_found,
        msgid TYPE symsgid      VALUE 'ZDA2309_TRAVEL',
        msgno TYPE symsgno      VALUE '005',
        attr1 TYPE scx_attrname VALUE 'CUSTOMER_ID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF no_customer_found.

    CONSTANTS:
      BEGIN OF invalid_dates,
        msgid TYPE symsgid      VALUE 'ZDA2309_TRAVEL',
        msgno TYPE symsgno      VALUE '006',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_dates.

    " Attributs
    DATA user_name   TYPE syuname.
    DATA description TYPE /dmo/description.
    DATA agency_id   TYPE /dmo/agency_id.
    DATA customer_id TYPE /dmo/customer_id.

    " Constructor
    METHODS constructor
      IMPORTING severity     TYPE if_abap_behv_message=>t_severity DEFAULT if_abap_behv_message=>severity-error
                textid       LIKE if_t100_message=>t100key         DEFAULT if_t100_message=>default_textid
                !previous    LIKE previous                         OPTIONAL
                user_name    TYPE syuname                          OPTIONAL
                !description TYPE /dmo/description                 OPTIONAL
                agency_id    TYPE /dmo/agency_id                   OPTIONAL
                customer_id  TYPE /dmo/customer_id                 OPTIONAL.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS ZCM_DA2310_TRAVEL IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( previous = previous ).

    if_t100_message~t100key = textid.
    if_abap_behv_message~m_severity = severity.
    me->user_name   = user_name.
    me->description = description.
    me->agency_id   = agency_id.
    me->customer_id = customer_id.
  ENDMETHOD.
ENDCLASS.
