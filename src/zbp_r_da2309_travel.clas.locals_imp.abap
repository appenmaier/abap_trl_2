CLASS lhc_ZR_DA2309_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS show_message FOR MODIFY
      IMPORTING keys FOR ACTION travel~show_message.

    METHODS cancel_travel FOR MODIFY
      IMPORTING keys FOR ACTION travel~cancel_travel RESULT result.

    METHODS maintain_booking_fee FOR MODIFY
      IMPORTING keys FOR ACTION travel~maintain_booking_fee RESULT result.

    METHODS validate_agency FOR VALIDATE ON SAVE
      IMPORTING keys FOR travel~validate_agency.

    METHODS validate_customer FOR VALIDATE ON SAVE
      IMPORTING keys FOR travel~validate_customer.

    METHODS validate_dates FOR VALIDATE ON SAVE
      IMPORTING keys FOR travel~validate_dates.

    METHODS determine_status FOR DETERMINE ON MODIFY
      IMPORTING keys FOR travel~determine_status.

    METHODS determine_travel_id FOR DETERMINE ON MODIFY
      IMPORTING keys FOR travel~determine_travel_id.
ENDCLASS.


CLASS lhc_ZR_DA2309_Travel IMPLEMENTATION.
  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD show_message.
    DATA message TYPE REF TO zcm_da2310_travel.

    message = NEW zcm_da2310_travel( textid    = zcm_da2310_travel=>test_message
                                     severity  = if_abap_behv_message=>severity-success
                                     user_name = sy-uname ).

    APPEND message TO reported-%other.
  ENDMETHOD.

  METHOD cancel_travel.
    DATA message TYPE REF TO zcm_da2310_travel.

    " Read Travels
    READ ENTITY IN LOCAL MODE ZR_DA2309_Travel
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(travels).

    " Process Travels
    LOOP AT travels REFERENCE INTO DATA(travel).

      " Validate Status and Create Error Message
      IF travel->Status = 'X'.
        message = NEW zcm_da2310_travel( textid      = zcm_da2310_travel=>travel_already_cancelled
                                         description = travel->Description ).
        APPEND VALUE #( %tky     = travel->%tky
                        %element = VALUE #( Status = if_abap_behv=>mk-on )
                        %msg     = message ) TO reported-travel.
        APPEND VALUE #( %tky = travel->%tky ) TO failed-travel.
        CONTINUE.
      ENDIF.

      " Set Status to Cancelled and Create Success Message
      travel->Status = 'X'.
      message = NEW zcm_da2310_travel( severity    = if_abap_behv_message=>severity-success
                                       textid      = zcm_da2310_travel=>travel_cancelled_successfully
                                       description = travel->Description ).
      APPEND VALUE #( %tky     = travel->%tky
                      %element = VALUE #( Status = if_abap_behv=>mk-on )
                      %msg     = message ) TO reported-travel.
    ENDLOOP.

    " Modify Travels
    MODIFY ENTITY IN LOCAL MODE ZR_DA2309_Travel
           UPDATE FIELDS ( Status )
           WITH VALUE #( FOR t IN travels
                         ( %tky = t-%tky Status = t-Status ) ).

    " Set Result
    result = VALUE #( FOR t IN travels
                      ( %tky   = t-%tky
                        %param = t ) ).
  ENDMETHOD.

  METHOD maintain_booking_fee.
    " Read Travels
    READ ENTITY IN LOCAL MODE ZR_DA2309_Travel
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(travels).

    " Process Travels
    LOOP AT travels REFERENCE INTO DATA(travel).

      " Set Booking Fee
      travel->BookingFee   = keys[ sy-tabix ]-%param-BookingFee.
      travel->CurrencyCode = keys[ sy-tabix ]-%param-CurrencyCode.

    ENDLOOP.

    " Modify Travels
    MODIFY ENTITY IN LOCAL MODE ZR_DA2309_Travel
           UPDATE FIELDS ( BookingFee CurrencyCode )
           WITH VALUE #( FOR t IN travels
                         ( %tky         = travel->%tky
                           BookingFee   = travel->BookingFee
                           CurrencyCode = travel->CurrencyCode ) ).

    " Set Result
    result = VALUE #( FOR t IN travels
                      ( %tky = t-%tky %param = t ) ).
  ENDMETHOD.

  METHOD validate_agency.
    DATA message TYPE REF TO zcm_da2310_travel.

    " Read Travels
    READ ENTITY IN LOCAL MODE ZR_DA2309_Travel
         FIELDS ( AgencyId )
         WITH CORRESPONDING #( keys )
         RESULT DATA(travels).

    " Process Travels
    LOOP AT travels INTO DATA(travel).

      " Validate Agency and Create Error Message
      SELECT SINGLE FROM /dmo/agency FIELDS @abap_true WHERE agency_id = @travel-AgencyId INTO @DATA(exists).
      IF exists = abap_false.
        message = NEW zcm_da2310_travel( textid    = zcm_da2310_travel=>no_agency_found
                                         agency_id = travel-AgencyId ).
        APPEND VALUE #( %tky     = travel-%tky
                        %element = VALUE #( AgencyId = if_abap_behv=>mk-on )
                        %msg     = message ) TO reported-travel.
        APPEND VALUE #( %tky = travel-%tky ) TO failed-travel.
        CONTINUE.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validate_customer.
    DATA message TYPE REF TO zcm_da2310_travel.

    " Read Travels
    READ ENTITY IN LOCAL MODE ZR_DA2309_Travel
         FIELDS ( CustomerId )
         WITH CORRESPONDING #( keys )
         RESULT DATA(travels).

    " Process Travels
    LOOP AT travels INTO DATA(travel).

      " Validate Agency and Create Error Message
      SELECT SINGLE FROM /dmo/customer FIELDS @abap_true WHERE customer_id = @travel-CustomerId INTO @DATA(exists).
      IF exists = abap_false.
        message = NEW zcm_da2310_travel( textid      = zcm_da2310_travel=>no_customer_found
                                         customer_id = travel-CustomerId ).
        APPEND VALUE #( %tky     = travel-%tky
                        %element = VALUE #( CustomerId = if_abap_behv=>mk-on )
                        %msg     = message ) TO reported-travel.
        APPEND VALUE #( %tky = travel-%tky ) TO failed-travel.
        CONTINUE.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validate_dates.
    DATA message TYPE REF TO zcm_da2310_travel.

    " Read Travels
    READ ENTITY IN LOCAL MODE ZR_DA2309_Travel
         FIELDS ( BeginDate EndDate )
         WITH CORRESPONDING #( keys )
         RESULT DATA(travels).

    " Process Travels
    LOOP AT travels INTO DATA(travel).

      " Validate Dates and Create Error Message
      IF travel-EndDate < travel-BeginDate.
        message = NEW zcm_da2310_travel( textid = zcm_da2310_travel=>invalid_dates ).
        APPEND VALUE #( %tky = travel-%tky
                        %msg = message ) TO reported-travel.
        APPEND VALUE #( %tky = travel-%tky ) TO failed-travel.
        CONTINUE.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD determine_status.
    " Read Travels
    READ ENTITY IN LOCAL MODE ZR_DA2309_Travel
         FIELDS ( Status )
         WITH CORRESPONDING #( keys )
         RESULT DATA(travels).

    " Process Travels
    LOOP AT travels REFERENCE INTO DATA(travel).

      " Set Status
      travel->Status = 'N'.

    ENDLOOP.

    " Modify Travels
    MODIFY ENTITY IN LOCAL MODE ZR_DA2309_Travel
           UPDATE FIELDS ( Status )
           WITH VALUE #( FOR t IN travels
                         ( %tky   = travel->%tky
                           Status = travel->Status ) ).
  ENDMETHOD.

  METHOD determine_travel_id.
    " Read Travels
    READ ENTITY IN LOCAL MODE ZR_DA2309_Travel
         FIELDS ( TravelId )
         WITH CORRESPONDING #( keys )
         RESULT DATA(travels).

    " Process Travels
    LOOP AT travels REFERENCE INTO DATA(travel).

      " Set Travel ID
      SELECT FROM /dmo/travel FIELDS MAX(  travel_id ) INTO @DATA(max_travel_id).
      travel->TravelId = max_travel_id + 1.

    ENDLOOP.

    " Modify Travels
    MODIFY ENTITY IN LOCAL MODE ZR_DA2309_Travel
           UPDATE FIELDS ( TravelId )
           WITH VALUE #( FOR t IN travels
                         ( %tky     = travel->%tky
                           TravelId = travel->TravelId ) ).
  ENDMETHOD.
ENDCLASS.
