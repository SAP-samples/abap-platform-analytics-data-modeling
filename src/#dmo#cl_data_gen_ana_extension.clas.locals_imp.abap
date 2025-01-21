*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_text_output IMPLEMENTATION.

  METHOD get_instance.
    IF instance IS NOT BOUND.
      instance = NEW lcl_text_output( out ).
    ENDIF.
    result = instance.
  ENDMETHOD.

  METHOD constructor.
    me->out = out.
  ENDMETHOD.

  METHOD print_build.
    IF out IS BOUND.
      out->write( '--> Build Content.' ) ##NO_TEXT.
    ENDIF.
  ENDMETHOD.

  METHOD print_delete.
    IF out IS BOUND.
      out->write( '--> Delete Content.' ) ##NO_TEXT.
    ENDIF.
  ENDMETHOD.

  METHOD print_done.
    IF out IS BOUND.
      out->write( |--> Done.\r\n| ) ##NO_TEXT.
    ENDIF.
  ENDMETHOD.

  METHOD print_insert.
    IF out IS BOUND.
      out->write( '--> Insert Content.' ) ##NO_TEXT.
    ENDIF.
  ENDMETHOD.

  METHOD print_title.
    IF out IS BOUND.
      out->write( |Generating Data: { i_title }.| ) ##NO_TEXT.
    ENDIF.
  ENDMETHOD.

  method print_error.
    if out is bound.
      out->write( '--> Insert failed' )  ##NO_TEXT.
    endif.
  endmethod.

ENDCLASS.
