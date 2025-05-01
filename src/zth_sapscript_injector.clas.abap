"! <p class="shorttext synchronized">ABAP Unit injector for SAPscript factory</p>
CLASS zth_sapscript_injector DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC
  FOR TESTING.

  PUBLIC SECTION.
    CLASS-METHODS clear_all_test_doubles.

    CLASS-METHODS set_text_factory
      IMPORTING test_double TYPE REF TO zif_sapscript_text_factory.
ENDCLASS.


CLASS zth_sapscript_injector IMPLEMENTATION.
  METHOD clear_all_test_doubles.
    zcl_sapscript_factory=>clear_all_test_doubles( ).
  ENDMETHOD.

  METHOD set_text_factory.
    zcl_sapscript_factory=>set_text_factory( test_double ).
  ENDMETHOD.
ENDCLASS.
