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
        EXPORTING textid      = zcx_sapscript_text=>sap_text_object_not_found
                  text_object = text_object.
    ENDIF.

    me->text_object = text_object.
  ENDMETHOD.

  METHOD zif_sapscript_text_factory~get_text.
    DATA text_header            TYPE thead.
    DATA text_lines             TYPE zif_sapscript_text=>ty_text_lines.
    DATA text_headers_and_lines TYPE text_lh.

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
                 object                  = 5 " Object is checked in constructor, so we shouldn't get this
                 reference_check         = 6
                 wrong_access_to_archive = 7
                 OTHERS                  = 8.
    CASE sy-subrc.
      WHEN 0.
        CREATE OBJECT result TYPE zcl_sapscript_text
          EXPORTING text_header = text_header
                    text_lines  = text_lines.
      WHEN 1.
        RAISE EXCEPTION TYPE zcx_sapscript_text
          EXPORTING textid      = zcx_sapscript_text=>sap_text_id_not_found
                    text_id     = text_id
                    text_object = text_object-tdobject.
      WHEN 2.
        RAISE EXCEPTION TYPE zcx_sapscript_text
          EXPORTING textid        = zcx_sapscript_text=>sap_language_not_allowed
                    language_code = language.
      WHEN 3.
        RAISE EXCEPTION TYPE zcx_sapscript_text
          EXPORTING textid    = zcx_sapscript_text=>sap_text_name_invalid
                    text_name = text_name.
      WHEN 4. " Check if the text exists in other language(s)
        CALL FUNCTION 'READ_MULTIPLE_TEXTS'
          EXPORTING  name       = text_name
                     object     = text_object-tdobject
                     id         = text_id
          IMPORTING  text_table = text_headers_and_lines
          EXCEPTIONS OTHERS     = 2.
        IF sy-subrc = 0.
          IF text_headers_and_lines IS INITIAL.
            RAISE EXCEPTION TYPE zcx_sapscript_text
              EXPORTING textid        = zcx_sapscript_text=>text_not_found
                        text_name     = text_name
                        text_id       = text_id
                        text_object   = text_object-tdobject
                        language_code = language.
          ELSE.
            RAISE EXCEPTION TYPE zcx_sapscript_text
              EXPORTING textid        = zcx_sapscript_text=>text_not_translated
                        text_name     = text_name
                        text_id       = text_id
                        text_object   = text_object-tdobject
                        language_code = language.
          ENDIF.
        ELSE.
          RAISE EXCEPTION TYPE zcx_sapscript_text.
        ENDIF.
      WHEN OTHERS.
        RAISE EXCEPTION TYPE zcx_sapscript_text.
    ENDCASE.
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
                 object   = 4 " Object is checked in constructor, so we shouldn't get this
                 OTHERS   = 5.
    CASE sy-subrc.
      WHEN 0.
        CREATE OBJECT result TYPE zcl_sapscript_text
          EXPORTING text_header = text_header.
      WHEN 1.
        RAISE EXCEPTION TYPE zcx_sapscript_text
          EXPORTING textid      = zcx_sapscript_text=>sap_text_id_not_found
                    text_id     = text_id
                    text_object = text_object-tdobject.
      WHEN 2.
        RAISE EXCEPTION TYPE zcx_sapscript_text
          EXPORTING textid        = zcx_sapscript_text=>sap_language_not_allowed
                    language_code = language.
      WHEN 3.
        RAISE EXCEPTION TYPE zcx_sapscript_text
          EXPORTING textid    = zcx_sapscript_text=>sap_text_name_invalid
                    text_name = text_name.
      WHEN OTHERS.
        RAISE EXCEPTION TYPE zcx_sapscript_text.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
