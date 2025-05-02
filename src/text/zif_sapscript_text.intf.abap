"! <p class="shorttext synchronized">SAPscript Text</p>
INTERFACE zif_sapscript_text
  PUBLIC.
  TYPES ty_text_lines TYPE STANDARD TABLE OF tline WITH EMPTY KEY.

  "! <p class="shorttext synchronized">Get title</p>
  "!
  "! @parameter result | <p class="shorttext synchronized">Title</p>
  METHODS get_title
    RETURNING VALUE(result) TYPE tdtitle.

  "! <p class="shorttext synchronized">Get match code 1</p>
  "!
  "! @parameter result | <p class="shorttext synchronized">Match code 1</p>
  METHODS get_match_code_1
    RETURNING VALUE(result) TYPE thead-tdmacode1.

  "! <p class="shorttext synchronized">Get match code 2</p>
  "!
  "! @parameter result | <p class="shorttext synchronized">Match code 2</p>
  METHODS get_match_code_2
    RETURNING VALUE(result) TYPE thead-tdmacode2.

  "! <p class="shorttext synchronized">Get text (content)</p>
  "!
  "! @parameter result | <p class="shorttext synchronized">Text as table of SAPscript text lines</p>
  METHODS get_text
    RETURNING VALUE(result) TYPE ty_text_lines.

  "! <p class="shorttext synchronized">Get text (content) as string</p>
  "!
  "! @parameter paragraph_to_double_newline | <p class="shorttext synchronized">Convert new paragraph to two consecutive newline characters</p>
  "! @parameter result                      | <p class="shorttext synchronized">Text as string</p>
  METHODS get_text_as_string
    IMPORTING paragraph_to_double_newline TYPE abap_bool DEFAULT abap_true
    RETURNING VALUE(result)               TYPE string.

  "! <p class="shorttext synchronized">Set title</p>
  "!
  "! @parameter new_title | <p class="shorttext synchronized">New title</p>
  "! @parameter result    | <p class="shorttext synchronized">Self-reference for chained calls</p>
  METHODS set_title
    IMPORTING new_title     TYPE csequence
    RETURNING VALUE(result) TYPE REF TO zif_sapscript_text.


  "! <p class="shorttext synchronized">Set match code 1</p>
  "!
  "! @parameter new_match_code | <p class="shorttext synchronized">New match code 1</p>
  "! @parameter result         | <p class="shorttext synchronized">Self-reference for chained calls</p>
  METHODS set_match_code_1
    IMPORTING new_match_code TYPE csequence
    RETURNING VALUE(result)  TYPE REF TO zif_sapscript_text.

  "! <p class="shorttext synchronized">Set match code 2</p>
  "!
  "! @parameter new_match_code | <p class="shorttext synchronized">New match code 2</p>
  "! @parameter result         | <p class="shorttext synchronized">Self-reference for chained calls</p>
  METHODS set_match_code_2
    IMPORTING new_match_code TYPE csequence
    RETURNING VALUE(result)  TYPE REF TO zif_sapscript_text.

  "! <p class="shorttext synchronized">Set text (content)</p>
  "!
  "! @parameter new_text           | <p class="shorttext synchronized">New text as table of SAPscript text lines</p>
  "! @parameter result             | <p class="shorttext synchronized">Self-reference for chained calls</p>
  "! @raising   zcx_sapscript_text | <p class="shorttext synchronized">SAPscript Text error</p>
  METHODS set_text
    IMPORTING new_text      TYPE ty_text_lines
    RETURNING VALUE(result) TYPE REF TO zif_sapscript_text
    RAISING   zcx_sapscript_text.

  "! <p class="shorttext synchronized">Set text (content) from string</p>
  "!
  "! @parameter new_text_as_string          | <p class="shorttext synchronized">New text as string</p>
  "! @parameter double_newline_to_paragraph | <p class="shorttext synchronized">Convert two consecutive newline characters to new paragraph</p>
  "! @parameter result                      | <p class="shorttext synchronized">Self-reference for chained calls</p>
  METHODS set_text_from_string
    IMPORTING new_text_as_string          TYPE string
              double_newline_to_paragraph TYPE abap_bool DEFAULT abap_true
    RETURNING VALUE(result)               TYPE REF TO zif_sapscript_text.

  "! <p class="shorttext synchronized">Save text</p>
  "!
  "! @parameter ghost_update       | <p class="shorttext synchronized">Don't update 'Last changed'</p>
  "! @parameter save_immediately   | <p class="shorttext synchronized">Save immediately</p>
  "!     <p>By default text object configuration controls whether the text is saved immediately or in update task.
  "!        <br/>This parameter can be used to override that and save the text immediately.</p>
  "! @raising   zcx_sapscript_text | <p class="shorttext synchronized">Save failed</p>
  METHODS save
    IMPORTING ghost_update     TYPE abap_bool DEFAULT abap_false
              save_immediately TYPE abap_bool DEFAULT abap_false
    RAISING   zcx_sapscript_text.

  "! <p class="shorttext synchronized">Delete text</p>
  "!
  "! @parameter save_immediately   | <p class="shorttext synchronized">Save immediately</p>
  "!     <p>By default text object configuration controls whether the text is saved immediately or in update task.
  "!        <br/>This parameter can be used to override that and save the text immediately.</p>
  "! @raising   zcx_sapscript_text | <p class="shorttext synchronized">Deletion failed</p>
  METHODS delete
    IMPORTING save_immediately TYPE abap_bool DEFAULT abap_false
    RAISING   zcx_sapscript_text.
ENDINTERFACE.
