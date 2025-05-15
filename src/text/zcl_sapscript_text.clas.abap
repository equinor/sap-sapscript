"! <p class="shorttext synchronized">SAPscript Text</p>
CLASS zcl_sapscript_text DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE
  GLOBAL FRIENDS zcl_sapscript_text_factory.

  PUBLIC SECTION.
    INTERFACES zif_sapscript_text.

    "! <p class="shorttext synchronized">Constructor</p>
    "!
    "! @parameter text_header | <p class="shorttext synchronized">Text header</p>
    "! @parameter text_lines  | <p class="shorttext synchronized">Content as text lines</p>
    METHODS constructor
      IMPORTING text_header TYPE thead
                text_lines  TYPE zif_sapscript_text=>ty_text_lines OPTIONAL.

  PRIVATE SECTION.
    TYPES ty_text_activity     TYPE c LENGTH 4.
    TYPES ty_processing_status TYPE c LENGTH 1.
    TYPES ty_text_source       TYPE byte.

    CONSTANTS: BEGIN OF text_activity,
                 read   TYPE ty_text_activity VALUE 'SHOW' ##NO_TEXT,
                 create TYPE ty_text_activity VALUE 'CREA' ##NO_TEXT,
                 change TYPE ty_text_activity VALUE 'EDIT' ##NO_TEXT,
               END OF text_activity.
    CONSTANTS: BEGIN OF save_status,
                 no_change TYPE ty_processing_status VALUE ' ' ##NO_TEXT,
                 created   TYPE ty_processing_status VALUE 'I' ##NO_TEXT,
                 updated   TYPE ty_processing_status VALUE 'U' ##NO_TEXT,
                 deleted   TYPE ty_processing_status VALUE 'D' ##NO_TEXT,
               END OF save_status.
    CONSTANTS: BEGIN OF text_source,
                 text_lines TYPE ty_text_source VALUE 1,
                 string     TYPE ty_text_source VALUE 2,
               END OF text_source.

    DATA text_id                     TYPE ttxid.
    DATA text_header                 TYPE thead.
    DATA text_lines                  TYPE zif_sapscript_text=>ty_text_lines.
    DATA text_as_string              TYPE string.
    DATA source_of_text              TYPE ty_text_source.
    DATA double_newline_to_paragraph TYPE abap_bool.

    METHODS check_authorization
      IMPORTING activity TYPE ty_text_activity
      RAISING   zcx_sapscript_text.

    METHODS text_lines_from_string
      IMPORTING text_as_string TYPE string
      RETURNING VALUE(result)  TYPE zif_sapscript_text=>ty_text_lines
      RAISING   zcx_sapscript_text.

    METHODS text_lines_as_string
      IMPORTING text_lines                  TYPE zif_sapscript_text=>ty_text_lines
                paragraph_to_double_newline TYPE abap_bool
      RETURNING VALUE(result)               TYPE string
      RAISING   zcx_sapscript_text.

    METHODS text_section_to_text_lines
      IMPORTING text_section             TYPE string
                VALUE(newlines)          TYPE i
                characters_per_text_line TYPE tdlinesize
      RETURNING VALUE(result)            TYPE zif_sapscript_text=>ty_text_lines.
ENDCLASS.


CLASS zcl_sapscript_text IMPLEMENTATION.
  METHOD constructor.
    me->text_header = text_header.
    me->text_lines  = text_lines.

    source_of_text = text_source-text_lines.
  ENDMETHOD.

  METHOD zif_sapscript_text~get_title.
    result = text_header-tdtitle.
  ENDMETHOD.

  METHOD zif_sapscript_text~get_match_code_1.
    result = text_header-tdmacode1.
  ENDMETHOD.

  METHOD zif_sapscript_text~get_match_code_2.
    result = text_header-tdmacode2.
  ENDMETHOD.

  METHOD zif_sapscript_text~get_text.
    CHECK source_of_text IS NOT INITIAL.

    IF source_of_text = text_source-text_lines.
      result = text_lines.
    ELSE.
      result = text_lines_from_string( text_as_string ).
    ENDIF.
  ENDMETHOD.

  METHOD zif_sapscript_text~get_text_as_string.
    CHECK source_of_text IS NOT INITIAL.

    IF source_of_text = text_source-string.
      IF double_newline_to_paragraph = paragraph_to_double_newline.
        result = text_as_string.
      ELSE.
        result = text_lines_as_string( text_lines                  = text_lines_from_string( text_as_string )
                                       paragraph_to_double_newline = paragraph_to_double_newline ).
      ENDIF.
    ELSE.
      result = text_lines_as_string( text_lines                  = text_lines
                                     paragraph_to_double_newline = paragraph_to_double_newline ).
    ENDIF.
  ENDMETHOD.

  METHOD zif_sapscript_text~set_title.
    result = me.
    text_header-tdtitle = new_title.
  ENDMETHOD.

  METHOD zif_sapscript_text~set_match_code_1.
    result = me.
    text_header-tdmacode1 = new_match_code.
  ENDMETHOD.

  METHOD zif_sapscript_text~set_match_code_2.
    result = me.
    text_header-tdmacode2 = new_match_code.
  ENDMETHOD.

  METHOD zif_sapscript_text~set_text.
    result = me.
    text_lines = new_text.
    source_of_text = text_source-text_lines.
    CLEAR text_as_string.
  ENDMETHOD.

  METHOD zif_sapscript_text~set_text_from_string.
    result = me.
    text_as_string = new_text_as_string.
    source_of_text = text_source-string.
    me->double_newline_to_paragraph = double_newline_to_paragraph.
    CLEAR text_lines.
  ENDMETHOD.

  METHOD zif_sapscript_text~save.
    DATA text_is_new        TYPE c LENGTH 1                        VALUE ' '.
    DATA savemode_direct    TYPE c LENGTH 1                        VALUE ' '.
    DATA keep_last_changed  TYPE c LENGTH 1                        VALUE ' '.
    DATA save_function      TYPE ty_processing_status.
    DATA text_as_text_lines TYPE zif_sapscript_text=>ty_text_lines.
    DATA new_header         TYPE thead.

    IF text_header-mandt IS INITIAL.
      text_is_new = 'X'.
    ENDIF.
    IF save_immediately = abap_true.
      savemode_direct = 'X'.
    ENDIF.
    IF ghost_update = abap_true.
      keep_last_changed = 'X'.
    ENDIF.

    IF text_is_new = 'X'.
      check_authorization( text_activity-create ).
    ELSE.
      check_authorization( text_activity-change ).
    ENDIF.
    text_as_text_lines = zif_sapscript_text~get_text( ).
    CALL FUNCTION 'SAVE_TEXT'
      EXPORTING  header            = text_header
                 insert            = text_is_new
                 savemode_direct   = savemode_direct
                 owner_specified   = 'X'
                 keep_last_changed = keep_last_changed
      IMPORTING  function          = save_function
                 newheader         = new_header
      TABLES     lines             = text_as_text_lines
      EXCEPTIONS id                = 1
                 language          = 2
                 name              = 3
                 object            = 4.
    CASE sy-subrc.
      WHEN 0.
        " Everything is OK - processing continues below
      WHEN 1.
        RAISE EXCEPTION TYPE zcx_sapscript_text
          EXPORTING textid        = zcx_sapscript_text=>sap_text_id_not_found
                    text_name     = text_header-tdname
                    text_id       = text_header-tdid
                    text_object   = text_header-tdobject
                    language_code = text_header-tdspras.
      WHEN 2.
        RAISE EXCEPTION TYPE zcx_sapscript_text
          EXPORTING textid        = zcx_sapscript_text=>sap_language_not_allowed
                    text_name     = text_header-tdname
                    text_id       = text_header-tdid
                    text_object   = text_header-tdobject
                    language_code = text_header-tdspras.
      WHEN 3.
        RAISE EXCEPTION TYPE zcx_sapscript_text
          EXPORTING textid        = zcx_sapscript_text=>sap_text_name_invalid
                    text_name     = text_header-tdname
                    text_id       = text_header-tdid
                    text_object   = text_header-tdobject
                    language_code = text_header-tdspras.
      WHEN 4.
        RAISE EXCEPTION TYPE zcx_sapscript_text
          EXPORTING textid        = zcx_sapscript_text=>sap_text_object_not_found
                    text_name     = text_header-tdname
                    text_id       = text_header-tdid
                    text_object   = text_header-tdobject
                    language_code = text_header-tdspras.
    ENDCASE.

    CASE save_function.
      WHEN save_status-created
      OR   save_status-updated.
        text_header = new_header.
      WHEN save_status-deleted.
        CLEAR text_header.
        CLEAR text_lines.
        CLEAR text_as_string.
        CLEAR source_of_text.
    ENDCASE.
  ENDMETHOD.

  METHOD zif_sapscript_text~delete.
    DATA savemode_direct TYPE c LENGTH 1 VALUE ' '.

    IF text_header-mandt IS INITIAL.
      CLEAR text_header.
      CLEAR text_lines.
      CLEAR text_as_string.
      CLEAR source_of_text.
      RETURN.
    ENDIF.

    IF save_immediately = abap_true.
      savemode_direct = 'X'.
    ENDIF.

    check_authorization( text_activity-change ).
    CALL FUNCTION 'DELETE_TEXT'
      EXPORTING  id              = text_header-tdid
                 language        = text_header-tdspras
                 name            = text_header-tdname
                 object          = text_header-tdobject
                 savemode_direct = savemode_direct
      EXCEPTIONS not_found       = 1.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_sapscript_text
        EXPORTING textid        = zcx_sapscript_text=>sap_text_not_found
                  text_name     = text_header-tdname
                  text_id       = text_header-tdid
                  text_object   = text_header-tdobject
                  language_code = text_header-tdspras.
    ENDIF.
  ENDMETHOD.

  METHOD check_authorization.
    CALL FUNCTION 'CHECK_TEXT_AUTHORITY'
      EXPORTING  activity     = activity
                 id           = text_header-tdid
                 language     = text_header-tdspras
                 name         = text_header-tdname
                 object       = text_header-tdobject
      EXCEPTIONS no_authority = 1.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_sapscript_text
        EXPORTING textid        = zcx_sapscript_text=>sap_not_authorized
                  text_name     = text_header-tdname
                  text_id       = text_header-tdid
                  text_object   = text_header-tdobject
                  language_code = text_header-tdspras.
    ENDIF.
  ENDMETHOD.

  METHOD text_lines_from_string.
    DATA text_lines     LIKE result.
    DATA current_offset TYPE i.
    DATA newlines       TYPE i.

    CHECK text_as_string IS NOT INITIAL.

    FIND ALL OCCURRENCES OF cl_abap_char_utilities=>newline IN text_as_string RESULTS DATA(line_feeds).
    current_offset = 0.
    LOOP AT line_feeds INTO DATA(line_feed).
      newlines = newlines + 1.
      IF line_feed-offset > current_offset.
        text_lines = text_section_to_text_lines(
                         text_section             = substring( val = text_as_string
                                                               off = current_offset
                                                               len = line_feed-offset - current_offset )
                         newlines                 = newlines
                         characters_per_text_line = text_header-tdlinesize ).
        IF current_offset = 0 AND text_lines IS NOT INITIAL.
          text_lines[ 1 ]-tdformat = '* '.
        ENDIF.
        APPEND LINES OF text_lines TO result.
        newlines = 0.
      ENDIF.
      current_offset = line_feed-offset + line_feed-length.
    ENDLOOP.

    " Final section/line
    newlines = newlines + 1.
    text_lines = text_section_to_text_lines( text_section             = substring( val = text_as_string
                                                                                   off = current_offset )
                                             newlines                 = newlines
                                             characters_per_text_line = text_header-tdlinesize ).
    IF current_offset = 0 AND text_lines IS NOT INITIAL.
      text_lines[ 1 ]-tdformat = '* '.
    ENDIF.
    APPEND LINES OF text_lines TO result.
  ENDMETHOD.

  METHOD text_lines_as_string.
    DATA text_line TYPE tline.

    CHECK text_lines IS NOT INITIAL.

    LOOP AT text_lines INTO text_line.
      CASE text_line-tdformat.
        WHEN '*'.
          IF result IS INITIAL.
            result = text_line-tdline.
          ELSE.
            IF paragraph_to_double_newline = abap_true.
              result = result && cl_abap_char_utilities=>newline.
            ENDIF.
            result = result && cl_abap_char_utilities=>newline && text_line-tdline.
          ENDIF.
        WHEN '/ '.
          result = result && cl_abap_char_utilities=>newline && text_line-tdline.
        WHEN '= '.
          CONCATENATE result text_line-tdline INTO result.
        WHEN OTHERS.
          CONCATENATE result text_line-tdline INTO result SEPARATED BY space.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.

  METHOD text_section_to_text_lines.
    DATA text_line TYPE tline.

    IF newlines = 1.
      text_line-tdformat = '/ '.
    ELSE.
      IF newlines MOD 2 = 1. " Blank line at end of paragraph
        text_line-tdformat = '/ '.
        APPEND text_line TO result.
        newlines = newlines - 1.
      ENDIF.

      IF double_newline_to_paragraph = abap_true.
        text_line-tdformat = '* '.
        newlines = newlines DIV 2.
      ELSE.
        text_line-tdformat = '/ '.
      ENDIF.

      WHILE newlines > 1.
        APPEND text_line TO result.
        newlines = newlines - 1.
      ENDWHILE.
    ENDIF.
    newlines = 0.

    DATA(section_length) = strlen( text_section ).
    DATA(current_offset) = 0.
    WHILE section_length > characters_per_text_line.
      text_line-tdline = text_section+current_offset(characters_per_text_line).
      APPEND text_line TO result.
      CLEAR text_line.
      text_line-tdformat = '= '.
      section_length = section_length - characters_per_text_line.
      current_offset = current_offset + characters_per_text_line.
    ENDWHILE.
    IF section_length > 0.
      text_line-tdline = text_section+current_offset(section_length).
      APPEND text_line TO result.
      CLEAR text_line.
    ENDIF.
    current_offset = current_offset + section_length.
  ENDMETHOD.
ENDCLASS.
