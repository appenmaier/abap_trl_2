CLASS lhc_ZR_DA2309_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result.
    METHODS show_test_message FOR MODIFY
      IMPORTING keys FOR ACTION travel~show_test_message.
    METHODS cancel_booking FOR MODIFY
      IMPORTING keys FOR ACTION travel~cancel_booking.
    METHODS maintain_booking_fees FOR MODIFY
      IMPORTING keys FOR ACTION travel~maintain_booking_fees.
    METHODS determine_travel_id FOR DETERMINE ON MODIFY
      IMPORTING keys FOR travel~determine_travel_id.

    METHODS validate_travel_period FOR VALIDATE ON SAVE
      IMPORTING keys FOR travel~validate_travel_period.

ENDCLASS.

CLASS lhc_ZR_DA2309_Travel IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD show_test_message.

    DATA(message) = NEW zcm_da2309_travel(
      i_textid    = zcm_da2309_travel=>test_message
      i_severity  = if_abap_behv_message=>severity-success
      i_user_name = sy-uname ).

    APPEND message TO reported-%other.

*    APPEND NEW zcm_da2309_travel(
*      i_textid    = zcm_da2309_travel=>test_message
*      i_severity  = if_abap_behv_message=>severity-information
*      i_user_name = sy-uname ) TO reported-%other.

  ENDMETHOD.

  METHOD cancel_booking.

    "Ausgewählte Daten (Reisen) lesen
    READ ENTITY IN LOCAL MODE ZR_DA2309_Travel
      FIELDS ( TravelUuid Description Status )
      WITH CORRESPONDING #( keys )
      RESULT DATA(travels).
    "SELECT FROM zda2309_atravel
    "  FIELDS TravelUuid, Status
    "  WHERE TravelUuid IN keys
    "  INTO TABLE @DATA(travels).

    "Daten (Reisen) sequentiell verarbeiten
    LOOP AT travels REFERENCE INTO DATA(travel).

      "Validierung
      IF travel->Status = 'X'.
        DATA(message) = NEW zcm_da2309_travel(
        i_textid    = zcm_da2309_travel=>travel_already_cancelled
        i_severity  = if_abap_behv_message=>severity-error
        i_travel    = travel->Description ).
        APPEND VALUE #( %tky = travel->%tky %msg = message ) TO reported-travel.
        APPEND VALUE #( %tky = travel->%tky ) TO failed-travel.
        CONTINUE.
      ENDIF.

      "Daten (Reisen) ändern und ggbfs. Nachrichten erzeugen
      travel->Status = 'X'.

      message = NEW zcm_da2309_travel(
        i_textid    = zcm_da2309_travel=>travel_cancelled_successfuly
        i_severity  = if_abap_behv_message=>severity-success
        i_travel    = travel->Description ).
      APPEND VALUE #( %tky = travel->%tky %msg = message ) TO reported-travel.

      "Daten (Reisen) zurückschreiben
      MODIFY ENTITY IN LOCAL MODE ZR_DA2309_Travel
        UPDATE FIELDS ( Status )
        WITH VALUE #( ( %tky = travel->%tky Status = travel->Status ) ).

    ENDLOOP.

  ENDMETHOD.

  METHOD maintain_booking_fees.

    READ ENTITY IN LOCAL MODE ZR_DA2309_Travel
      FIELDS ( TravelUuid )
      WITH CORRESPONDING #( keys )
      RESULT DATA(travels).

    LOOP AT travels REFERENCE INTO DATA(travel).

      travel->BookingFee = keys[ sy-tabix ]-%param-BookingFee.
      travel->CurrencyCode = keys[ sy-tabix ]-%param-CurrencyCode.

      MODIFY ENTITY IN LOCAL MODE ZR_DA2309_Travel
        UPDATE FIELDS ( BookingFee CurrencyCode )
        WITH VALUE #( ( %tky = travel->%tky
                        BookingFee = travel->BookingFee
                        CurrencyCode = travel->CurrencyCode ) ).

    ENDLOOP.

  ENDMETHOD.

  METHOD determine_travel_id.
  ENDMETHOD.

  METHOD validate_travel_period.
  ENDMETHOD.

ENDCLASS.
