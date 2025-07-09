*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section
CLASS lcl_text_output DEFINITION CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS:
      get_instance
        IMPORTING
          out           TYPE REF TO if_oo_adt_classrun_out optional
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
          out TYPE REF TO if_oo_adt_classrun_out optional.

ENDCLASS.

CLASS lcl_airline_hier DEFINITION CREATE PRIVATE.

  PUBLIC SECTION.

    CLASS-METHODS:
      get_instance IMPORTING i_hieid         TYPE /dmo/ana_carrier_hieid
                   RETURNING VALUE(r_result) TYPE REF TO lcl_airline_hier.

    methods:
      init_by_cubedata,
      generate_carrier_hier_data,
      generate_carrier_hier_td_data,
      delete_data_from_db,
      save_data_on_db.


  PRIVATE SECTION.
    CONSTANTS: c_nodename TYPE /dmo/ana_nodename VALUE 'ALLIANCE_'.
    TYPES:
      pt_t_carrier_hier      TYPE STANDARD TABLE OF /dmo/ana_cr_s_h,
      pt_s_carrier_hier      TYPE /dmo/ana_cr_s_h,
      pt_t_carrier_hier_dir  TYPE STANDARD TABLE OF /dmo/ana_cr_s_hd,
      pt_s_carrier_hier_dir  TYPE /dmo/ana_cr_s_hd,

      pt_t_carrier_hier_td      TYPE STANDARD TABLE OF /dmo/ana_cr_t_h,
      pt_s_carrier_hier_td      TYPE /dmo/ana_cr_t_h,
      pt_t_carrier_hier_td_node TYPE STANDARD TABLE OF /dmo/ana_cr_t_hn,
      pt_s_carrier_hier_td_node TYPE /dmo/ana_cr_t_hn,
      pt_t_carrier_hier_td_dir  TYPE STANDARD TABLE OF /dmo/ana_cr_t_hd,
      pt_s_carrier_hier_td_dir  TYPE /dmo/ana_cr_t_hd,

      BEGIN OF pt_s_nodeid,
        nodename TYPE /dmo/ana_nodename,
        datefrom TYPE /dmo/ana_date_from,
        dateto   TYPE /dmo/ana_date_to,
        node_id  TYPE /dmo/ana_carrier_nodeid,
      END OF pt_s_nodeid,
      BEGIN OF pt_s_parent,
        parent_id TYPE /dmo/ana_carrier_nodeid,
        datefrom  TYPE /dmo/ana_date_from,
        dateto    TYPE /dmo/ana_date_to,
      END OF pt_s_parent,
      pt_t_parent TYPE STANDARD TABLE OF pt_s_parent WITH NON-UNIQUE KEY table_line.

    DATA: p_min_date  TYPE d,
          p_i1_date   TYPE d,
          p_i2_date   TYPE d,
          p_max_date  TYPE d,
          p_hieid     TYPE /dmo/ana_carrier_hieid,
          p_ts_curr   TYPE SORTED TABLE OF /dmo/currency_code WITH UNIQUE KEY table_line,
          p_th_nodeid TYPE HASHED TABLE OF pt_s_nodeid WITH UNIQUE KEY nodename datefrom,

          p_t_data_hier TYPE pt_t_carrier_hier,
          p_t_data_dir  TYPE pt_t_carrier_hier_dir,

          p_t_data_td_hier TYPE pt_t_carrier_hier_td,
          p_t_data_td_node TYPE pt_t_carrier_hier_td_node,
          p_t_data_td_dir  TYPE pt_t_carrier_hier_td_dir.

    methods:
      get_parent_id IMPORTING i_s_carrier TYPE /dmo/carrier
                    EXPORTING e_t_parent  TYPE pt_t_parent,
      get_text_with_time importing i_text type csequence
                                   i_datefrom type d
                                   i_dateto   type d
                         returning value(r_text) type string,
      get_text_for_date IMPORTING i_date type d
                        RETURNING VALUE(r_text) type string,
      set_node_data importing i_t_data_node type pt_t_carrier_hier_td_node.

ENDCLASS.
