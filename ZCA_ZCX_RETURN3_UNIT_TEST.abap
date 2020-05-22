REPORT zca_zcx_sub_return3_unit_test.

CLASS zcx_sub_return3 DEFINITION
  INHERITING FROM zcx_return3.

ENDCLASS.

CLASS unit_test DEFINITION FOR TESTING
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    METHODS get_test_data_bapiret2_1_struc
      RETURNING VALUE(rs_exp_bapiret2) TYPE bapiret2.
    METHODS get_test_data_bapiret2_1_tab
      RETURNING VALUE(rt_exp_bapiret2) TYPE bapiret2_t.
    METHODS get_bapiret2_00_059_struc
      RETURNING VALUE(rs_exp_bapiret2) TYPE bapiret2.
    METHODS get_bapiret2_00_060_struc
      IMPORTING iv_type                TYPE bapi_mtype
      RETURNING VALUE(rs_exp_bapiret2) TYPE bapiret2.
    METHODS get_test_data_bapiret2_2_tab
      RETURNING VALUE(rt_exp_bapiret2) TYPE bapiret2_t.
    METHODS get_test_data_bapiret2_3_tab
      RETURNING VALUE(rt_exp_bapiret2) TYPE bapiret2_t.
*
    METHODS sc010_create_system_message      FOR TESTING.
    METHODS sc020_create_system_message_2    FOR TESTING.

    METHODS sc095_create_by_oo_exception     FOR TESTING.

    METHODS sc030_create_mess_and_text_var   FOR TESTING.

    METHODS sc040_create_bapireturn_struc    FOR TESTING.
    METHODS sc050_create_bapireturn_table    FOR TESTING.
    METHODS sc060_create_by_bapiret1_struc   FOR TESTING.
    METHODS sc070_create_by_bapiret1_table   FOR TESTING.
    METHODS sc080_create_by_bapiret2_struc   FOR TESTING.
    METHODS sc090_create_by_bapiret2_table   FOR TESTING.
    METHODS sc091_create_by_bapiret2_table   FOR TESTING.
**CREATE_BY_BDC_TABLE
    METHODS sc100_create_by_text             FOR TESTING. "Do not use

ENDCLASS.

CLASS unit_test IMPLEMENTATION.

  METHOD get_test_data_bapiret2_1_struc.

    rs_exp_bapiret2 = VALUE #(
        type        = 'E'
        id          = '00'
        number      = '058'
        message     = 'Entry 1 2 3 does not exist in 4 (check entry)'
        message_v1  = '1'
        message_v2  = '2'
        message_v3  = '3'
        message_v4  = '4'
    ).

  ENDMETHOD.

  METHOD get_test_data_bapiret2_1_tab.

    DATA(ls_exp_bapiret2) = get_test_data_bapiret2_1_struc(  ).

    APPEND ls_exp_bapiret2 TO rt_exp_bapiret2.

  ENDMETHOD.

  METHOD get_bapiret2_00_059_struc.

    rs_exp_bapiret2 = VALUE #(
        type        = 'E'
        id          = '00'
        number      = '059'
        message     = ''
        message_v1  = ''
        message_v2  = ''
        message_v3  = ''
        message_v4  = ''
    ).

    MESSAGE
      ID     rs_exp_bapiret2-id
      TYPE   rs_exp_bapiret2-type
      NUMBER rs_exp_bapiret2-number
      WITH
        rs_exp_bapiret2-message_v1
        rs_exp_bapiret2-message_v2
        rs_exp_bapiret2-message_v3
        rs_exp_bapiret2-message_v4
      INTO rs_exp_bapiret2-message.

  ENDMETHOD.

  METHOD get_bapiret2_00_060_struc.

    rs_exp_bapiret2 = VALUE #(
        type        = iv_type
        id          = '00'
        number      = '060'
        message     = ''
        message_v1  = ''
        message_v2  = ''
        message_v3  = ''
        message_v4  = ''
    ).

    MESSAGE
      ID     rs_exp_bapiret2-id
      TYPE   rs_exp_bapiret2-type
      NUMBER rs_exp_bapiret2-number
      WITH
        rs_exp_bapiret2-message_v1
        rs_exp_bapiret2-message_v2
        rs_exp_bapiret2-message_v3
        rs_exp_bapiret2-message_v4
      INTO rs_exp_bapiret2-message.

  ENDMETHOD.

  METHOD get_test_data_bapiret2_2_tab.

    rt_exp_bapiret2 = get_test_data_bapiret2_1_tab(  ).

    DATA(ls_exp_bapiret2) = get_bapiret2_00_059_struc(  ).

    APPEND ls_exp_bapiret2 TO rt_exp_bapiret2.

  ENDMETHOD.

  METHOD get_test_data_bapiret2_3_tab.

    DATA ls_exp_bapiret2 TYPE bapiret2.

    ls_exp_bapiret2 = get_bapiret2_00_060_struc( 'S' ).

    APPEND ls_exp_bapiret2 TO rt_exp_bapiret2.


    ls_exp_bapiret2 = get_test_data_bapiret2_1_struc(  ).

    APPEND ls_exp_bapiret2 TO rt_exp_bapiret2.


    ls_exp_bapiret2 = get_bapiret2_00_060_struc( 'I' ).

    APPEND ls_exp_bapiret2 TO rt_exp_bapiret2.


    ls_exp_bapiret2 = get_bapiret2_00_060_struc( 'S' ).

    APPEND ls_exp_bapiret2 TO rt_exp_bapiret2.


    ls_exp_bapiret2 = get_bapiret2_00_059_struc(  ).

    APPEND ls_exp_bapiret2 TO rt_exp_bapiret2.


    ls_exp_bapiret2 = get_bapiret2_00_060_struc( 'S' ).

    APPEND ls_exp_bapiret2 TO rt_exp_bapiret2.

  ENDMETHOD.

  METHOD sc010_create_system_message.

    DATA(lt_exp_bapiret2) = get_test_data_bapiret2_1_tab( ).

    TRY.

        "********************************************************
        "Create message: Tag '&1' may not be nested in tag '&2'

        RAISE EXCEPTION TYPE zcx_sub_return3
          MESSAGE e058(00)
          WITH '1' '2' '3' '4'.

      CATCH zcx_sub_return3 INTO DATA(lx_return).

        DATA(lt_act_bapiret2) = lx_return->get_bapiret2_table( ).

        cl_abap_unit_assert=>assert_equals(
          act = lt_act_bapiret2
          exp = lt_exp_bapiret2 ).

        DATA(lv_text) = lx_return->get_text( ).

        cl_abap_unit_assert=>assert_equals(
          act = lv_text
          exp = lt_act_bapiret2[ 1 ]-message ).

        "********************************************************
        "Add message: The input value is too big (maximum 255)

        "Expected
        DATA(ls_exp_bapiret2) = get_bapiret2_00_059_struc( ).

        APPEND ls_exp_bapiret2 TO lt_exp_bapiret2.

        "Actual
        MESSAGE e059(00)
          INTO DATA(lv_dummy_2).

        lx_return->add_system_message( ).

        lt_act_bapiret2 = lx_return->get_bapiret2_table( ).

        cl_abap_unit_assert=>assert_equals(
          act = lt_act_bapiret2
          exp = lt_exp_bapiret2 ).

    ENDTRY.

  ENDMETHOD.

  METHOD sc020_create_system_message_2.

    MESSAGE i058(00)
      WITH '1' '2' '3' '4'
      INTO DATA(lv_dummy).

    DATA(lx_return) = NEW zcx_sub_return3( ).

    lx_return->add_system_message( ).

    IF lx_return->has_messages( ) = abap_true.
      cl_abap_unit_assert=>fail(
        msg = 'It should not contain messages' ).
    ENDIF.

    MESSAGE s058(00)
      WITH '1' '2' '3' '4'
      INTO DATA(lv_dummy2).

    lx_return->add_system_message( ).

    IF lx_return->has_messages( ) = abap_true.
      cl_abap_unit_assert=>fail(
        msg = 'It should not contain messages' ).
    ENDIF.

  ENDMETHOD.

  METHOD sc030_create_mess_and_text_var.

    "Expected data
    DATA(ls_exp_bapiret2) = VALUE bapiret2(
        type        = 'E'
        id          = '00'
        number      = '081'
        message     = 'Entry 1 2 3 does not exist in 4 (check entry)'
        message_v1  = 'V1:45678901234567890123456789012345678901234567890'
        message_v2  = 'V2:45678901234567890123456789012345678901234567890'
        message_v3  = 'V3:45678901234567890123456789012345678901234567890'
        message_v4  = 'V4:45678901234567890123456789012345678901234567890'
    ).

    MESSAGE
      ID     ls_exp_bapiret2-id
      TYPE   ls_exp_bapiret2-type
      NUMBER ls_exp_bapiret2-number
      WITH
        ls_exp_bapiret2-message_v1
        ls_exp_bapiret2-message_v2
        ls_exp_bapiret2-message_v3
        ls_exp_bapiret2-message_v4
      INTO ls_exp_bapiret2-message.

    DATA lt_exp_bapiret2 TYPE bapiret2_t.

    APPEND ls_exp_bapiret2 TO lt_exp_bapiret2.

    "Call data
    DATA lv_char_200 TYPE char200.

    lv_char_200 =
      ls_exp_bapiret2-message_v1 &&
      ls_exp_bapiret2-message_v2 &&
      ls_exp_bapiret2-message_v3 &&
      ls_exp_bapiret2-message_v4.

    DATA(lx_return) = NEW zcx_sub_return3( ).

    lx_return->add_message_and_text_var(
      iv_type           = ls_exp_bapiret2-type
      iv_id             = ls_exp_bapiret2-id
      iv_number         = ls_exp_bapiret2-number
      iv_text_variable  = lv_char_200 ).

    "Actual data
    DATA(lt_act_bapiret2) = lx_return->get_bapiret2_table( ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_act_bapiret2
      exp = lt_exp_bapiret2 ).

  ENDMETHOD.

  METHOD sc040_create_bapireturn_struc.

    DATA(lt_exp_bapiret2) = get_test_data_bapiret2_1_tab( ).
    DATA(ls_exp_bapiret2) = lt_exp_bapiret2[ 1 ].

    DATA ls_bapireturn TYPE bapireturn.

    ls_bapireturn = VALUE #(
        type         = ls_exp_bapiret2-type
        code         = ls_exp_bapiret2-id && ls_exp_bapiret2-number
        message      = ls_exp_bapiret2-message
        log_no       = ls_exp_bapiret2-log_no
        log_msg_no   = ls_exp_bapiret2-log_msg_no
        message_v1   = ls_exp_bapiret2-message_v1
        message_v2   = ls_exp_bapiret2-message_v2
        message_v3   = ls_exp_bapiret2-message_v3
        message_v4   = ls_exp_bapiret2-message_v4
    ).

    DATA(lx_return) = NEW zcx_sub_return3( ).

    lx_return->add_bapireturn_struc( ls_bapireturn ).

    IF lx_return->has_messages( ) = abap_false.
      cl_abap_unit_assert=>fail(
        msg = 'It should contain messages' ).
    ENDIF.

    DATA(lt_act_bapiret2) = lx_return->get_bapiret2_table( ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_act_bapiret2
      exp = lt_exp_bapiret2 ).

    DATA(lv_text) = lx_return->get_text( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_text
      exp = lt_exp_bapiret2[ 1 ]-message ).

  ENDMETHOD.

  METHOD sc050_create_bapireturn_table.

    DATA(lt_exp_bapiret2) = get_test_data_bapiret2_2_tab( ).

    DATA lt_bapireturn TYPE STANDARD TABLE OF bapireturn.

    LOOP AT lt_exp_bapiret2
      ASSIGNING FIELD-SYMBOL(<ls_exp_bapiret2>).

      DATA ls_bapireturn TYPE bapireturn.

      ls_bapireturn = VALUE #(
          type         = <ls_exp_bapiret2>-type
          code         = <ls_exp_bapiret2>-id && <ls_exp_bapiret2>-number
          message      = <ls_exp_bapiret2>-message
          log_no       = <ls_exp_bapiret2>-log_no
          log_msg_no   = <ls_exp_bapiret2>-log_msg_no
          message_v1   = <ls_exp_bapiret2>-message_v1
          message_v2   = <ls_exp_bapiret2>-message_v2
          message_v3   = <ls_exp_bapiret2>-message_v3
          message_v4   = <ls_exp_bapiret2>-message_v4
      ).

      APPEND ls_bapireturn TO lt_bapireturn.

    ENDLOOP.

    DATA(lx_return) = NEW zcx_sub_return3( ).

    lx_return->add_bapireturn_table( lt_bapireturn ).

    DATA(lt_act_bapiret2) = lx_return->get_bapiret2_table( ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_act_bapiret2
      exp = lt_exp_bapiret2 ).


    DATA(ls_act_bapiret2) = lx_return->get_bapiret2_struc( ).
    DATA(ls_exp_bapiret2) = lt_exp_bapiret2[ 1 ].

    cl_abap_unit_assert=>assert_equals(
      act = ls_act_bapiret2
      exp = ls_exp_bapiret2 ).

  ENDMETHOD.

  METHOD sc060_create_by_bapiret1_struc.

    DATA(lt_exp_bapiret2) = get_test_data_bapiret2_1_tab( ).
    DATA(ls_exp_bapiret2) = lt_exp_bapiret2[ 1 ].

    DATA ls_bapiret1 TYPE bapiret1.

    ls_bapiret1 = VALUE #(
        type         = ls_exp_bapiret2-type
        id           = ls_exp_bapiret2-id
        number       = ls_exp_bapiret2-number
        message      = ls_exp_bapiret2-message
        log_no       = ls_exp_bapiret2-log_no
        log_msg_no   = ls_exp_bapiret2-log_msg_no
        message_v1   = ls_exp_bapiret2-message_v1
        message_v2   = ls_exp_bapiret2-message_v2
        message_v3   = ls_exp_bapiret2-message_v3
        message_v4   = ls_exp_bapiret2-message_v4
    ).

    DATA(lx_return) = NEW zcx_sub_return3( ).

    lx_return->add_bapiret1_struc( ls_bapiret1 ).

    DATA(lt_act_bapiret2) = lx_return->get_bapiret2_table( ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_act_bapiret2
      exp = lt_exp_bapiret2 ).

  ENDMETHOD.

  METHOD sc070_create_by_bapiret1_table.

    DATA(lt_exp_bapiret2) = get_test_data_bapiret2_2_tab( ).

    DATA lt_bapiret1 TYPE STANDARD TABLE OF bapiret1.

    LOOP AT lt_exp_bapiret2
      ASSIGNING FIELD-SYMBOL(<ls_exp_bapiret2>).

      DATA ls_bapiret1 TYPE bapiret1.

      ls_bapiret1 = VALUE #(
          type         = <ls_exp_bapiret2>-type
          id           = <ls_exp_bapiret2>-id
          number       = <ls_exp_bapiret2>-number
          message      = <ls_exp_bapiret2>-message
          log_no       = <ls_exp_bapiret2>-log_no
          log_msg_no   = <ls_exp_bapiret2>-log_msg_no
          message_v1   = <ls_exp_bapiret2>-message_v1
          message_v2   = <ls_exp_bapiret2>-message_v2
          message_v3   = <ls_exp_bapiret2>-message_v3
          message_v4   = <ls_exp_bapiret2>-message_v4
      ).

      APPEND ls_bapiret1 TO lt_bapiret1.

    ENDLOOP.

    DATA(lx_return) = NEW zcx_sub_return3( ).

    lx_return->add_bapiret1_table( lt_bapiret1 ).

    DATA(lt_act_bapiret2) = lx_return->get_bapiret2_table( ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_act_bapiret2
      exp = lt_exp_bapiret2 ).


    DATA(ls_act_bapiret2) = lx_return->get_bapiret2_struc( ).
    DATA(ls_exp_bapiret2) = lt_exp_bapiret2[ 1 ].

    cl_abap_unit_assert=>assert_equals(
      act = ls_act_bapiret2
      exp = ls_exp_bapiret2 ).

  ENDMETHOD.

  METHOD sc080_create_by_bapiret2_struc.

    DATA(lt_exp_bapiret2) = get_test_data_bapiret2_1_tab( ).
    DATA(ls_exp_bapiret2) = lt_exp_bapiret2[ 1 ].


    DATA(lx_return) = NEW zcx_sub_return3( ).

    lx_return->add_bapiret2_struc( ls_exp_bapiret2 ).

    DATA(lt_act_bapiret2) = lx_return->get_bapiret2_table( ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_act_bapiret2
      exp = lt_exp_bapiret2 ).

  ENDMETHOD.

  METHOD sc090_create_by_bapiret2_table.

    DATA(lt_exp_bapiret2) = get_test_data_bapiret2_2_tab( ).

    DATA(lx_return) = NEW zcx_sub_return3( ).
    lx_return->add_bapiret2_table( lt_exp_bapiret2 ).

    DATA(lt_act_bapiret2) = lx_return->get_bapiret2_table( ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_act_bapiret2
      exp = lt_exp_bapiret2 ).


    DATA(ls_act_bapiret2) = lx_return->get_bapiret2_struc( ).
    DATA(ls_exp_bapiret2) = lt_exp_bapiret2[ 1 ].

    cl_abap_unit_assert=>assert_equals(
      act = ls_act_bapiret2
      exp = ls_exp_bapiret2 ).

    DATA(lv_act_text) = lx_return->get_text( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_act_text
      exp = ls_exp_bapiret2-message ).

  ENDMETHOD.

  METHOD sc091_create_by_bapiret2_table.

    DATA(lt_exp_bapiret2) = get_test_data_bapiret2_2_tab( ).

    DATA(lt_data_bapiret2) = get_test_data_bapiret2_3_tab( ).

    DATA(lx_return) = NEW zcx_sub_return3( ).

    lx_return->add_bapiret2_table( lt_data_bapiret2 ).

    DATA(lt_act_bapiret2) = lx_return->get_bapiret2_table( ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_act_bapiret2
      exp = lt_exp_bapiret2 ).

    DATA(ls_act_bapiret2) = lx_return->get_bapiret2_struc( ).
    DATA(ls_exp_bapiret2) = lt_exp_bapiret2[ 1 ].

    cl_abap_unit_assert=>assert_equals(
      act = ls_act_bapiret2
      exp = ls_exp_bapiret2 ).

  ENDMETHOD.

  METHOD sc095_create_by_oo_exception.

    TRY.

        TRY.

            RAISE EXCEPTION TYPE cx_aab_object.

          CATCH cx_root INTO DATA(lx_root). "TODO: change exception class

            "<Short error name>: &1 &2 &3 &4
            MESSAGE e001(00)                   "Todo: change error number
              INTO DATA(lv_dummy).

            "Method will split message text into &1 &2 &3 &4
            DATA(lx_return) = NEW zcx_sub_return3( ).

            lx_return->add_exception_object( lx_root ). "Change variable name

            RAISE EXCEPTION lx_return.

        ENDTRY.

      CATCH zcx_sub_return3 INTO DATA(lx_return2).

        DATA(lt_act_bapiret2) = lx_return2->get_bapiret2_table( ).

        DATA(lt_exp_bapiret2) = VALUE bapiret2_t(
          (
            type        = 'E'
            id          = '00'
            number      = '001'
            message     = 'Checkpoint group or activation variant specified does not exist'
            message_v1  = 'Checkpoint group or activation variant specified d'
            message_v2  = 'oes not exist'
            message_v3  = ''
            message_v4  = ''
          )
        ).

        cl_abap_unit_assert=>assert_equals(
          act = lt_act_bapiret2
          exp = lt_exp_bapiret2 ).

    ENDTRY.

  ENDMETHOD.

  METHOD sc100_create_by_text.

    DATA(lt_exp_bapiret2) = VALUE bapiret2_t(
      (
        type        = 'E'
        id          = ''
        number      = '000'
        message     = 'Entry A B C does not exist in D (check entry)'
        message_v1  = 'A'
        message_v2  = 'B'
        message_v3  = 'C'
        message_v4  = 'D'
      )
    ).

    DATA(lx_return) = NEW zcx_sub_return3( ).

    lx_return->add_text(
      iv_type       = 'E'
      iv_message    = 'Entry &1 &2 &3 does not exist in &4 (check entry)'
      iv_variable_1 = 'A'
      iv_variable_2 = 'B'
      iv_variable_3 = 'C'
      iv_variable_4 = 'D'
    ).

    DATA(lt_act_bapiret2) = lx_return->get_bapiret2_table( ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_act_bapiret2
      exp = lt_exp_bapiret2 ).

  ENDMETHOD.

ENDCLASS.
