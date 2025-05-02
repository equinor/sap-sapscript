"! <p class="shorttext synchronized">SAPscript Text factory</p>
INTERFACE zif_sapscript_text_factory
  PUBLIC.
  "! <p class="shorttext synchronized">Get existing text</p>
  "!
  "! @parameter text_id            | <p class="shorttext synchronized">Text ID</p>
  "! @parameter text_name          | <p class="shorttext synchronized">Text name</p>
  "! @parameter language           | <p class="shorttext synchronized">Language</p>
  "! @parameter result             | <p class="shorttext synchronized">SAPscript Text</p>
  "! @raising   zcx_sapscript_text | <p class="shorttext synchronized">SAPscript Text error</p>
  METHODS get_text
    IMPORTING text_id       TYPE tdid
              text_name     TYPE tdobname
              !language     TYPE tdspras DEFAULT sy-langu
    RETURNING VALUE(result) TYPE REF TO zif_sapscript_text
    RAISING   zcx_sapscript_text.

  "! <p class="shorttext synchronized">Create new text</p>
  "!
  "! @parameter text_id            | <p class="shorttext synchronized">Text ID</p>
  "! @parameter text_name          | <p class="shorttext synchronized">Text name</p>
  "! @parameter language           | <p class="shorttext synchronized">Language</p>
  "! @parameter result             | <p class="shorttext synchronized">SAPscript Text</p>
  "! @raising   zcx_sapscript_text | <p class="shorttext synchronized">SAPscript Text error</p>
  METHODS create_text
    IMPORTING text_id       TYPE tdid
              text_name     TYPE tdobname
              !language     TYPE tdspras DEFAULT sy-langu
    RETURNING VALUE(result) TYPE REF TO zif_sapscript_text
    RAISING   zcx_sapscript_text.

  "! <p class="shorttext synchronized">Create new text with header and content from existing text</p>
  "!
  "! @parameter text_id            | <p class="shorttext synchronized">Text ID</p>
  "! @parameter text_name          | <p class="shorttext synchronized">Text name</p>
  "! @parameter text               | <p class="shorttext synchronized">Source SAPscript Text</p>
  "! @parameter result             | <p class="shorttext synchronized">SAPscript Text</p>
  "! @raising   zcx_sapscript_text | <p class="shorttext synchronized">SAPscript Text error</p>
  METHODS create_from_text
    IMPORTING text_id       TYPE tdid
              text_name     TYPE tdobname
              !text         TYPE REF TO zif_sapscript_text
    RETURNING VALUE(result) TYPE REF TO zif_sapscript_text
    RAISING   zcx_sapscript_text.
ENDINTERFACE.
