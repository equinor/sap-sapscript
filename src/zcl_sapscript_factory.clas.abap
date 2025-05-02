"! <p class="shorttext synchronized">SAPscript factory</p>
CLASS zcl_sapscript_factory DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC
  GLOBAL FRIENDS zth_sapscript_injector.

  PUBLIC SECTION.
    "! <p class="shorttext synchronized">Create SAPscript Text factory for a text object</p>
    "!
    "! @parameter text_object        | <p class="shorttext synchronized">Text object</p>
    "! @parameter result             | <p class="shorttext synchronized">SAPscript Text factory</p>
    "! @raising   zcx_sapscript_text | <p class="shorttext synchronized">SAPscript Text error</p>
    CLASS-METHODS create_text_factory
      IMPORTING text_object   TYPE tdobject
      RETURNING VALUE(result) TYPE REF TO zif_sapscript_text_factory
      RAISING   zcx_sapscript_text.

  PRIVATE SECTION.
    CLASS-DATA text_factory_test_double TYPE REF TO zif_sapscript_text_factory.

    CLASS-METHODS clear_all_test_doubles.

    CLASS-METHODS set_text_factory
      IMPORTING test_double TYPE REF TO zif_sapscript_text_factory.
ENDCLASS.


CLASS zcl_sapscript_factory IMPLEMENTATION.
  METHOD create_text_factory.
    IF text_factory_test_double IS BOUND.
      result = text_factory_test_double.
      RETURN.
    ENDIF.

    CREATE OBJECT result TYPE zcl_sapscript_text_factory
      EXPORTING text_object = text_object.
  ENDMETHOD.

  METHOD clear_all_test_doubles.
    CLEAR text_factory_test_double.
  ENDMETHOD.

  METHOD set_text_factory.
    text_factory_test_double = test_double.
  ENDMETHOD.
ENDCLASS.
