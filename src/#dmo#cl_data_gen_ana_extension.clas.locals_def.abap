*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section
CLASS lcl_text_output DEFINITION CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS:
      get_instance
        IMPORTING
          out           TYPE REF TO if_oo_adt_classrun_out
        RETURNING
          VALUE(result) TYPE REF TO lcl_text_output.

    METHODS:
      print_title
        IMPORTING
          i_title TYPE string,
      print_delete,
      print_build,
      print_insert,
      print_error,
      print_done.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA:
      instance TYPE REF TO lcl_text_output.

    DATA:
      out TYPE REF TO if_oo_adt_classrun_out.

    METHODS:
      constructor
        IMPORTING
          out TYPE REF TO if_oo_adt_classrun_out.

ENDCLASS.
