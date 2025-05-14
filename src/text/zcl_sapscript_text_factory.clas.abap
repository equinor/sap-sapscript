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
                 object                  = text_object-tdobject
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
    DATA text_lines  TYPE zif_sapscript_text=>ty_text_lines.

    CALL FUNCTION 'INIT_TEXT'
      EXPORTING  id       = text_id
                 language = language
                 name     = text_name
                 object   = text_object-tdobject
      IMPORTING  header   = text_header
      TABLES     lines    = text_lines
      EXCEPTIONS id       = 1
                 language = 2
                 name     = 3
                 object   = 4
                 OTHERS   = 5.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_sapscript_text
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CREATE OBJECT result TYPE zcl_sapscript_text
      EXPORTING text_header = text_header.
  ENDMETHOD.
ENDCLASS.
