*"* use this source file for your ABAP unit test classes
CLASS ltc_test_class DEFINITION DEFERRED.
CLASS zcl_sapscript_text DEFINITION LOCAL FRIENDS ltc_test_class.

CLASS ltc_test_class DEFINITION ABSTRACT FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.
ENDCLASS.


CLASS ltc_test_class IMPLEMENTATION.
ENDCLASS.


CLASS ltc_text_lines_from_string DEFINITION
  INHERITING FROM ltc_test_class FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    DATA cut TYPE REF TO zcl_sapscript_text.

    METHODS setup.
    METHODS teardown.

    METHODS single_short_line FOR TESTING RAISING cx_static_check.
    METHODS single_long_line  FOR TESTING RAISING cx_static_check.
    METHODS short_lines       FOR TESTING RAISING cx_static_check.
    METHODS double_newlines   FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltc_text_lines_from_string IMPLEMENTATION.
  METHOD setup.
    CREATE OBJECT cut
      EXPORTING text_header = VALUE #( tdobject   = 'ABAP_UNIT'
                                       tdid       = 'TEST'
                                       tdname     = 'TLINES_FROM_STRING'
                                       tdspras    = 'E'
                                       tdlinesize = '072' ).
  ENDMETHOD.

  METHOD teardown.
  ENDMETHOD.

  METHOD single_short_line.
    DATA input_string        TYPE string.
    DATA expected_text_lines TYPE zif_sapscript_text=>ty_text_lines.
    DATA expected_text_line  LIKE LINE OF expected_text_lines.

    " given
    input_string = |Short text|.

    " when
    cut->zif_sapscript_text~set_text_from_string( new_text_as_string          = input_string
                                                  double_newline_to_paragraph = abap_false ).

    " then
    expected_text_line-tdformat = '* '.
    expected_text_line-tdline   = 'Short text'.
    APPEND expected_text_line TO expected_text_lines.

    cl_Abap_Unit_Assert=>assert_Equals( exp = expected_text_lines
                                        act = cut->zif_sapscript_text~get_text( ) ).
  ENDMETHOD.

  METHOD single_long_line.
    DATA input_string        TYPE string.
    DATA expected_text_lines TYPE zif_sapscript_text=>ty_text_lines.
    DATA expected_text_line  LIKE LINE OF expected_text_lines.

    " given
    input_string = |Long text that will not fit in a single long text line.|
                && | The second line should be a continuation of the first line, not a new line.|
                && | Let's see if it works correctly.|.

    " when
    cut->zif_sapscript_text~set_text_from_string( new_text_as_string          = input_string
                                                  double_newline_to_paragraph = abap_false ).

    " then
    expected_text_line-tdformat = '* '.
    expected_text_line-tdline   = |Long text that will not fit in a single long text line. The second line |.
    APPEND expected_text_line TO expected_text_lines.
    expected_text_line-tdformat = '= '.
    expected_text_line-tdline   = |should be a continuation of the first line, not a new line. Let's see if|.
    APPEND expected_text_line TO expected_text_lines.
    expected_text_line-tdformat = '= '.
    expected_text_line-tdline   = | it works correctly.|.
    APPEND expected_text_line TO expected_text_lines.

    cl_Abap_Unit_Assert=>assert_Equals( exp = expected_text_lines
                                        act = cut->zif_sapscript_text~get_text( ) ).
  ENDMETHOD.

  METHOD short_lines.
    DATA input_string        TYPE string.
    DATA expected_text_lines TYPE zif_sapscript_text=>ty_text_lines.
    DATA expected_text_line  LIKE LINE OF expected_text_lines.

    " given
    input_string = |Three{ cl_abap_char_utilities=>newline }|
                && |short{ cl_abap_char_utilities=>newline }|
                && |lines|.

    " when
    cut->zif_sapscript_text~set_text_from_string( new_text_as_string          = input_string
                                                  double_newline_to_paragraph = abap_false ).

    " then
    expected_text_line-tdformat = '* '.
    expected_text_line-tdline   = 'Three'.
    APPEND expected_text_line TO expected_text_lines.
    expected_text_line-tdformat = '/ '.
    expected_text_line-tdline   = 'short'.
    APPEND expected_text_line TO expected_text_lines.
    expected_text_line-tdformat = '/ '.
    expected_text_line-tdline   = 'lines'.
    APPEND expected_text_line TO expected_text_lines.

    cl_Abap_Unit_Assert=>assert_Equals( exp = expected_text_lines
                                        act = cut->zif_sapscript_text~get_text( ) ).
  ENDMETHOD.

  METHOD double_newlines.
    DATA input_string        TYPE string.
    DATA expected_text_lines TYPE zif_sapscript_text=>ty_text_lines.
    DATA expected_text_line  LIKE LINE OF expected_text_lines.

    " given
    input_string = |Three short lines{ cl_abap_char_utilities=>newline }{ cl_abap_char_utilities=>newline }|
                && |separated by{ cl_abap_char_utilities=>newline }{ cl_abap_char_utilities=>newline }|
                && |double newlines|.

    " when
    cut->zif_sapscript_text~set_text_from_string( new_text_as_string          = input_string
                                                  double_newline_to_paragraph = abap_false ).

    " then
    expected_text_line-tdformat = '* '.
    expected_text_line-tdline   = 'Three short lines'.
    APPEND expected_text_line TO expected_text_lines.
    expected_text_line-tdformat = '/ '.
    expected_text_line-tdline   = ''.
    APPEND expected_text_line TO expected_text_lines.
    expected_text_line-tdformat = '/ '.
    expected_text_line-tdline   = 'separated by'.
    APPEND expected_text_line TO expected_text_lines.
    expected_text_line-tdformat = '/ '.
    expected_text_line-tdline   = ''.
    APPEND expected_text_line TO expected_text_lines.
    expected_text_line-tdformat = '/ '.
    expected_text_line-tdline   = 'double newlines'.
    APPEND expected_text_line TO expected_text_lines.

    cl_Abap_Unit_Assert=>assert_Equals( exp = expected_text_lines
                                        act = cut->zif_sapscript_text~get_text( ) ).
  ENDMETHOD.
ENDCLASS.


CLASS ltc_string_from_text_lines DEFINITION
  INHERITING FROM ltc_test_class FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    DATA cut TYPE REF TO zcl_sapscript_text.

    METHODS setup.
    METHODS teardown.

    METHODS single_short_line FOR TESTING RAISING cx_static_check.
    METHODS single_long_line  FOR TESTING RAISING cx_static_check.
    METHODS short_lines       FOR TESTING RAISING cx_static_check.
    METHODS double_newlines   FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltc_string_from_text_lines IMPLEMENTATION.
  METHOD setup.
    CREATE OBJECT cut
      EXPORTING text_header = VALUE #( tdobject   = 'ABAP_UNIT'
                                       tdid       = 'TEST'
                                       tdname     = 'TLINES_FROM_STRING'
                                       tdspras    = 'E'
                                       tdlinesize = '072' ).
  ENDMETHOD.

  METHOD teardown.
  ENDMETHOD.

  METHOD single_short_line.
    DATA input_text_lines TYPE zif_sapscript_text=>ty_text_lines.
    DATA input_text_line  LIKE LINE OF input_text_lines.
    DATA expected_string  TYPE string.

    " given
    input_text_line-tdformat = '* '.
    input_text_line-tdline   = 'Short text'.
    APPEND input_text_line TO input_text_lines.

    " when
    cut->zif_sapscript_text~set_text( input_text_lines ).

    " then
    expected_string = |Short text|.
    cl_Abap_Unit_Assert=>assert_Equals(
        exp = expected_string
        act = cut->zif_sapscript_text~get_text_as_string( paragraph_to_double_newline = abap_false ) ).
  ENDMETHOD.

  METHOD single_long_line.
    DATA input_text_lines TYPE zif_sapscript_text=>ty_text_lines.
    DATA input_text_line  LIKE LINE OF input_text_lines.
    DATA expected_string  TYPE string.

    " given
    input_text_line-tdformat = '* '.
    input_text_line-tdline   = |Long text that will not fit in a single long text line. The second line |.
    APPEND input_text_line TO input_text_lines.
    input_text_line-tdformat = '  '.
    input_text_line-tdline   = |should be a continuation of the first line, not a new line. Let's see if|.
    APPEND input_text_line TO input_text_lines.
    input_text_line-tdformat = '  '.
    input_text_line-tdline   = |it works correctly.|.
    APPEND input_text_line TO input_text_lines.

    " when
    cut->zif_sapscript_text~set_text( input_text_lines ).

    " then
    expected_string = |Long text that will not fit in a single long text line.|
                   && | The second line should be a continuation of the first line, not a new line.|
                   && | Let's see if it works correctly.|.
    cl_Abap_Unit_Assert=>assert_Equals(
        exp = expected_string
        act = cut->zif_sapscript_text~get_text_as_string( paragraph_to_double_newline = abap_false ) ).
  ENDMETHOD.

  METHOD short_lines.
    DATA input_text_lines TYPE zif_sapscript_text=>ty_text_lines.
    DATA input_text_line  LIKE LINE OF input_text_lines.
    DATA expected_string  TYPE string.

    " given
    input_text_line-tdformat = '* '.
    input_text_line-tdline   = 'Three'.
    APPEND input_text_line TO input_text_lines.
    input_text_line-tdformat = '/ '.
    input_text_line-tdline   = 'short'.
    APPEND input_text_line TO input_text_lines.
    input_text_line-tdformat = '/ '.
    input_text_line-tdline   = 'lines'.
    APPEND input_text_line TO input_text_lines.

    " when
    cut->zif_sapscript_text~set_text( input_text_lines ).

    " then
    expected_string = |Three{ cl_abap_char_utilities=>newline }|
                   && |short{ cl_abap_char_utilities=>newline }|
                   && |lines|.
    cl_Abap_Unit_Assert=>assert_Equals(
        exp = expected_string
        act = cut->zif_sapscript_text~get_text_as_string( paragraph_to_double_newline = abap_false ) ).
  ENDMETHOD.

  METHOD double_newlines.
    DATA input_text_lines TYPE zif_sapscript_text=>ty_text_lines.
    DATA input_text_line  LIKE LINE OF input_text_lines.
    DATA expected_string  TYPE string.

    " given
    input_text_line-tdformat = '* '.
    input_text_line-tdline   = 'Three short lines'.
    APPEND input_text_line TO input_text_lines.
    input_text_line-tdformat = '/ '.
    input_text_line-tdline   = ''.
    APPEND input_text_line TO input_text_lines.
    input_text_line-tdformat = '/ '.
    input_text_line-tdline   = 'separated by'.
    APPEND input_text_line TO input_text_lines.
    input_text_line-tdformat = '/ '.
    input_text_line-tdline   = ''.
    APPEND input_text_line TO input_text_lines.
    input_text_line-tdformat = '/ '.
    input_text_line-tdline   = 'double newlines'.
    APPEND input_text_line TO input_text_lines.

    " when
    cut->zif_sapscript_text~set_text( input_text_lines ).

    " then
    expected_string = |Three short lines{ cl_abap_char_utilities=>newline }{ cl_abap_char_utilities=>newline }|
                   && |separated by{ cl_abap_char_utilities=>newline }{ cl_abap_char_utilities=>newline }|
                   && |double newlines|.
    cl_Abap_Unit_Assert=>assert_Equals(
        exp = expected_string
        act = cut->zif_sapscript_text~get_text_as_string( paragraph_to_double_newline = abap_false ) ).
  ENDMETHOD.
ENDCLASS.


CLASS ltc_double_newline_to_paragrph DEFINITION
  INHERITING FROM ltc_test_class FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    DATA cut TYPE REF TO zcl_sapscript_text.

    METHODS setup.
    METHODS teardown.

    METHODS text_lines_from_string      FOR TESTING RAISING cx_static_check.
    METHODS string_from_text_lines      FOR TESTING RAISING cx_static_check.
    METHODS blank_line_before_paragraph FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltc_double_newline_to_paragrph IMPLEMENTATION.
  METHOD setup.
    CREATE OBJECT cut
      EXPORTING text_header = VALUE #( tdobject   = 'ABAP_UNIT'
                                       tdid       = 'TEST'
                                       tdname     = 'TLINES_FROM_STRING'
                                       tdspras    = 'E'
                                       tdlinesize = '072' ).
  ENDMETHOD.

  METHOD teardown.
  ENDMETHOD.

  METHOD text_lines_from_string.
    DATA input_string        TYPE string.
    DATA expected_text_lines TYPE zif_sapscript_text=>ty_text_lines.
    DATA expected_text_line  LIKE LINE OF expected_text_lines.

    " given
    input_string = |Three|
                && |{ cl_abap_char_utilities=>newline }{ cl_abap_char_utilities=>newline }short|
                && |{ cl_abap_char_utilities=>newline }{ cl_abap_char_utilities=>newline }paragraphs|.

    " when
    cut->zif_sapscript_text~set_text_from_string( new_text_as_string          = input_string
                                                  double_newline_to_paragraph = abap_true ).

    " then
    expected_text_line-tdformat = '* '.
    expected_text_line-tdline   = 'Three'.
    APPEND expected_text_line TO expected_text_lines.
    expected_text_line-tdline = 'short'.
    APPEND expected_text_line TO expected_text_lines.
    expected_text_line-tdline = 'paragraphs'.
    APPEND expected_text_line TO expected_text_lines.

    cl_Abap_Unit_Assert=>assert_Equals( exp = expected_text_lines
                                        act = cut->zif_sapscript_text~get_text( ) ).
  ENDMETHOD.

  METHOD string_from_text_lines.
    DATA input_text_lines TYPE zif_sapscript_text=>ty_text_lines.
    DATA input_text_line  LIKE LINE OF input_text_lines.
    DATA expected_string  TYPE string.

    " given
    input_text_line-tdformat = '* '.
    input_text_line-tdline   = 'Three'.
    APPEND input_text_line TO input_text_lines.
    input_text_line-tdline = 'short'.
    APPEND input_text_line TO input_text_lines.
    input_text_line-tdline = 'paragraphs'.
    APPEND input_text_line TO input_text_lines.

    " when
    cut->zif_sapscript_text~set_text( input_text_lines ).

    " then
    expected_string = |Three|
                   && |{ cl_abap_char_utilities=>newline }{ cl_abap_char_utilities=>newline }short|
                   && |{ cl_abap_char_utilities=>newline }{ cl_abap_char_utilities=>newline }paragraphs|.
    cl_Abap_Unit_Assert=>assert_Equals(
        exp = expected_string
        act = cut->zif_sapscript_text~get_text_as_string( paragraph_to_double_newline = abap_true ) ).
  ENDMETHOD.

  METHOD blank_line_before_paragraph.
    DATA input_text_lines TYPE zif_sapscript_text=>ty_text_lines.
    DATA input_text_line  LIKE LINE OF input_text_lines.
    DATA expected_string  TYPE string.

    " given
    input_text_line-tdformat = '* '.
    input_text_line-tdline   = 'Paragrahp with blank line at end.'.
    APPEND input_text_line TO input_text_lines.
    input_text_line-tdformat = '/ '.
    input_text_line-tdline   = ''.
    APPEND input_text_line TO input_text_lines.
    input_text_line-tdformat = '* '.
    input_text_line-tdline   = 'Followed by a new paragraph.'.
    APPEND input_text_line TO input_text_lines.
    input_text_line-tdformat = '* '.
    input_text_line-tdline   = 'Another paragrahp with blank line at end.'.
    APPEND input_text_line TO input_text_lines.
    input_text_line-tdformat = '/ '.
    input_text_line-tdline   = ''.
    APPEND input_text_line TO input_text_lines.
    input_text_line-tdformat = '* '.
    input_text_line-tdline   = 'Followed by the final paragraph!'.
    APPEND input_text_line TO input_text_lines.

    " when
    cut->zif_sapscript_text~set_text( input_text_lines ).

    " then
    expected_string = |Paragrahp with blank line at end.{ cl_abap_char_utilities=>newline }|
                   && |{ cl_abap_char_utilities=>newline }{ cl_abap_char_utilities=>newline }Followed by a new paragraph.|
                   && |{ cl_abap_char_utilities=>newline }{ cl_abap_char_utilities=>newline }Another paragrahp with blank line at end.{ cl_abap_char_utilities=>newline }|
                   && |{ cl_abap_char_utilities=>newline }{ cl_abap_char_utilities=>newline }Followed by the final paragraph!|.

    cl_Abap_Unit_Assert=>assert_Equals(
        exp = expected_string
        act = cut->zif_sapscript_text~get_text_as_string( paragraph_to_double_newline = abap_true ) ).
  ENDMETHOD.
ENDCLASS.
