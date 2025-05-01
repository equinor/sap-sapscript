"! <p class="shorttext synchronized">SAPscript Text factory</p>
CLASS zcl_sapscript_text_factory DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE
  GLOBAL FRIENDS zcl_sapscript_factory.

  PUBLIC SECTION.
    INTERFACES zif_sapscript_text_factory.

    METHODS constructor
      IMPORTING text_object TYPE tdobject
      RAISING   zcx_sapscript_text.

  PRIVATE SECTION.
    DATA text_object TYPE ttxob.
ENDCLASS.


CLASS zcl_sapscript_text_factory IMPLEMENTATION.
  METHOD constructor.
    CALL FUNCTION 'CHECK_TEXT_OBJECT'
      EXPORTING  object = text_object
      EXCEPTIONS object = 1
                 OTHERS = 2.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_sapscript_text
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    me->text_object = text_object.
  ENDMETHOD.

  METHOD zif_sapscript_text_factory~get_text.
    DATA text_header TYPE thead.
    DATA text_lines  TYPE zif_sapscript_text=>ty_text_lines.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING  id                      = text_id
                 language                = language
                 name                    = text_name
                 object                  = text_object
      IMPORTING  header                  = text_header
      TABLES     lines                   = text_lines
      EXCEPTIONS id                      = 1
                 language                = 2
                 name                    = 3
                 not_found               = 4
                 object                  = 5
                 reference_check         = 6
                 wrong_access_to_archive = 7
                 OTHERS                  = 8.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_sapscript_text
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CREATE OBJECT result TYPE zcl_sapscript_text
      EXPORTING text_header = text_header
                text_lines  = text_lines.
  ENDMETHOD.

  METHOD zif_sapscript_text_factory~create_text.
    DATA text_header TYPE thead.

    CALL FUNCTION 'CHECK_TEXT_ID'
      EXPORTING  id     = text_id
                 object = text_object
      EXCEPTIONS id     = 1
                 OTHERS = 2.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_sapscript_text
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    " The text object was checked when the factory was created, but the function must be called
    " to ensure that global variable TTXOB in function group STXD holds data for the correct
    " text object, as this variable is  used by CHECK_TEXT_NAME
    CALL FUNCTION 'CHECK_TEXT_OBJECT'
      EXPORTING  object = text_object
      EXCEPTIONS object = 1
                 OTHERS = 2.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_sapscript_text
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
    CALL FUNCTION 'CHECK_TEXT_NAME'
      EXPORTING  name   = text_name
      EXCEPTIONS name   = 1
                 OTHERS = 2.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_sapscript_text
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CALL FUNCTION 'CHECK_TEXT_LANGUAGE'
      EXPORTING  language = language
      EXCEPTIONS language = 1
                 OTHERS   = 2.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_sapscript_text
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    text_header-tdobject = text_object.
    text_header-tdid     = text_id.
    text_header-tdname   = text_name.
    text_header-tdspras  = language.

    CREATE OBJECT result TYPE zcl_sapscript_text
      EXPORTING text_header = text_header.
  ENDMETHOD.
ENDCLASS.
