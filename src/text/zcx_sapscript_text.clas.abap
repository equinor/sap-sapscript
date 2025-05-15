"! <p class="shorttext synchronized">SAPscript Text error</p>
CLASS zcx_sapscript_text DEFINITION
  PUBLIC
  INHERITING FROM zcx_sapscript
  CREATE PUBLIC.

  PUBLIC SECTION.
    CONSTANTS:
      BEGIN OF sap_text_not_found,
        msgid TYPE symsgid      VALUE 'TD',
        msgno TYPE symsgno      VALUE '600',
        attr1 TYPE scx_attrname VALUE 'TEXT_NAME',
        attr2 TYPE scx_attrname VALUE 'TEXT_ID',
        attr3 TYPE scx_attrname VALUE 'LANGUAGE',
        attr4 TYPE scx_attrname VALUE '',
      END OF sap_text_not_found.
    CONSTANTS:
      BEGIN OF sap_text_object_not_found,
        msgid TYPE symsgid      VALUE 'TD',
        msgno TYPE symsgno      VALUE '602',
        attr1 TYPE scx_attrname VALUE 'TEXT_OBJECT',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF sap_text_object_not_found.
    CONSTANTS:
      BEGIN OF sap_text_id_not_found,
        msgid TYPE symsgid      VALUE 'TD',
        msgno TYPE symsgno      VALUE '603',
        attr1 TYPE scx_attrname VALUE 'TEXT_ID',
        attr2 TYPE scx_attrname VALUE 'TEXT_OBJECT',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF sap_text_id_not_found.
    CONSTANTS:
      BEGIN OF sap_text_name_invalid,
        msgid TYPE symsgid      VALUE 'TD',
        msgno TYPE symsgno      VALUE '605',
        attr1 TYPE scx_attrname VALUE 'TEXT_NAME',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF sap_text_name_invalid.
    CONSTANTS:
      BEGIN OF sap_language_not_allowed,
        msgid TYPE symsgid      VALUE 'TD',
        msgno TYPE symsgno      VALUE '604',
        attr1 TYPE scx_attrname VALUE 'LANGUAGE_CODE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF sap_language_not_allowed.
    CONSTANTS:
      BEGIN OF sap_not_authorized,
        msgid TYPE symsgid      VALUE 'TD',
        msgno TYPE symsgno      VALUE '611',
        attr1 TYPE scx_attrname VALUE 'LANGUAGE',
        attr2 TYPE scx_attrname VALUE 'TEXT_ID',
        attr3 TYPE scx_attrname VALUE 'TEXT_NAME',
        attr4 TYPE scx_attrname VALUE '',
      END OF sap_not_authorized.
    CONSTANTS:
      BEGIN OF text_not_found,
        msgid TYPE symsgid      VALUE 'ZCA_SAPSCRIPT_TEXT',
        msgno TYPE symsgno      VALUE '001',
        attr1 TYPE scx_attrname VALUE 'TEXT_NAME',
        attr2 TYPE scx_attrname VALUE 'TEXT_ID',
        attr3 TYPE scx_attrname VALUE 'TEXT_OBJECT',
        attr4 TYPE scx_attrname VALUE 'LANGUAGE',
      END OF text_not_found.
    CONSTANTS:
      BEGIN OF text_not_translated,
        msgid TYPE symsgid      VALUE 'ZCA_SAPSCRIPT_TEXT',
        msgno TYPE symsgno      VALUE '002',
        attr1 TYPE scx_attrname VALUE 'TEXT_NAME',
        attr2 TYPE scx_attrname VALUE 'TEXT_ID',
        attr3 TYPE scx_attrname VALUE 'TEXT_OBJECT',
        attr4 TYPE scx_attrname VALUE 'LANGUAGE',
      END OF text_not_translated.

    DATA text_name     TYPE tdobname READ-ONLY.
    DATA text_id       TYPE tdid     READ-ONLY.
    DATA text_object   TYPE tdobject READ-ONLY.
    DATA language_code TYPE tdspras  READ-ONLY.
    DATA language      TYPE sptxt    READ-ONLY.

    "! <p class="shorttext synchronized">CONSTRUCTOR</p>
    METHODS constructor
      IMPORTING textid        LIKE if_t100_message=>t100key OPTIONAL
                !previous     LIKE previous                 OPTIONAL
                text_name     TYPE tdobname                 OPTIONAL
                text_id       TYPE tdid                     OPTIONAL
                text_object   TYPE tdobject                 OPTIONAL
                language_code TYPE tdspras                  OPTIONAL.

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.


CLASS zcx_sapscript_text IMPLEMENTATION.
  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( previous = previous ).

    me->text_name     = text_name.
    me->text_id       = text_id.
    me->text_object   = text_object.
    me->language_code = language_code.

    IF me->language_code IS NOT INITIAL.
      SELECT SINGLE FROM t002t
        FIELDS sptxt
        WHERE spras = @sy-langu
          AND sprsl = @me->language_code
        INTO @me->language.
    ENDIF.

    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
