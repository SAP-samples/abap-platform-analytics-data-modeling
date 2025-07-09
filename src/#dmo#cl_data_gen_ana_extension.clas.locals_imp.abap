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

  METHOD print_error.
    IF out IS BOUND.
      out->write( '--> Insert failed' )  ##NO_TEXT.
    ENDIF.
  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_airline_hier IMPLEMENTATION.


  METHOD get_instance.
    r_result = NEW lcl_airline_hier( ).
    r_result->p_hieid = i_hieid.

    r_result->init_by_cubedata( ).
  ENDMETHOD.

  METHOD init_by_cubedata.
    DATA: l_invl_length TYPE i.

    SELECT MIN( flight_date ), MAX( flight_date )
      FROM /dmo/ana_p_flight
      INTO (@p_min_date, @p_max_date ).

    l_invl_length = ( p_max_date - p_min_date )  DIV 3 .

    p_i1_date = p_min_date + l_invl_length.
    p_i2_date = p_i1_date  + l_invl_length.

    SELECT currency_code FROM /dmo/carrier GROUP BY currency_code INTO TABLE @p_ts_curr.

  ENDMETHOD.

  METHOD delete_data_from_db.
    DELETE FROM /dmo/ana_cr_s_h  WHERE hierarchy_id = @p_hieid.
    DELETE FROM /dmo/ana_cr_s_hd WHERE hierarchy_id = @p_hieid.

    DELETE FROM /dmo/ana_cr_t_h  WHERE hierarchy_id = @p_hieid.
    DELETE FROM /dmo/ana_cr_t_hd WHERE hierarchy_id = @p_hieid.
    DELETE FROM /dmo/ana_cr_t_hn WHERE hierarchy_id = @p_hieid.
  ENDMETHOD.

  METHOD save_data_on_db.
    INSERT /dmo/ana_cr_s_h  FROM TABLE @p_t_data_hier.
    INSERT /dmo/ana_cr_s_hd FROM TABLE @p_t_data_dir.

    INSERT /dmo/ana_cr_t_hn FROM TABLE @p_t_data_td_node.

    INSERT /dmo/ana_cr_t_h  FROM TABLE @p_t_data_td_hier.
    INSERT /dmo/ana_cr_t_hd FROM TABLE @p_t_data_td_dir.
  ENDMETHOD.

  METHOD get_parent_id.

    DATA: l_index      TYPE i,
          l_index_n    TYPE n LENGTH 2,
          l_parentname TYPE /dmo/ana_nodename.
    FIELD-SYMBOLS:
          <l_s_nodeid> TYPE pt_s_nodeid.
    CLEAR e_t_parent.

    READ TABLE p_ts_curr TRANSPORTING NO FIELDS
      WITH TABLE KEY table_line = i_s_carrier-currency_code.
    IF sy-subrc = 0.
      l_index = sy-tabix MOD 4.
    ELSE.
      l_index = 0.
    ENDIF.

    CASE l_index.
      WHEN 0. l_parentname = |{ c_nodename }N|.
      WHEN 1. l_parentname = |{ c_nodename }E|.
      WHEN 2. l_parentname = |{ c_nodename }S|.
      WHEN 3. l_parentname = |{ c_nodename }W|.
    ENDCASE.

    IF i_s_carrier-carrier_id(1) = 'A'.
      READ TABLE p_th_nodeid ASSIGNING <l_s_nodeid>
        WITH KEY nodename = l_parentname.
      APPEND VALUE #( parent_id = <l_s_nodeid>-node_id
                      datefrom  = <l_s_nodeid>-datefrom
                      dateto    = ( p_i1_date - 1 ) )
             TO e_t_parent.

      l_index = ( l_index + 1 ) MOD 4.
      CASE l_index.
        WHEN 0. l_parentname = |{ c_nodename }N|.
        WHEN 1. l_parentname = |{ c_nodename }E|.
        WHEN 2. l_parentname = |{ c_nodename }S|.
        WHEN 3. l_parentname = |{ c_nodename }W|.
      ENDCASE.

      DATA: l_first    TYPE abap_bool,
            l_datefrom TYPE d.
      l_first = abap_true.
      LOOP AT p_th_nodeid ASSIGNING <l_s_nodeid>
       WHERE nodename = l_parentname
         AND dateto >= p_i1_date.
        IF l_first = abap_true.
          l_first = abap_false.
          l_datefrom = p_i1_date.
        ELSE.
          l_datefrom = <l_s_nodeid>-datefrom.
        ENDIF.
        APPEND VALUE #( parent_id = <l_s_nodeid>-node_id
                        datefrom  = l_datefrom
                        dateto    = <l_s_nodeid>-dateto )
               TO e_t_parent.
      ENDLOOP.

    ELSE.
      LOOP AT p_th_nodeid ASSIGNING <l_s_nodeid>
        WHERE nodename = l_parentname.
        APPEND VALUE #( parent_id = <l_s_nodeid>-node_id
                        datefrom  = <l_s_nodeid>-datefrom
                        dateto    = <l_s_nodeid>-dateto )
               TO e_t_parent.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD generate_carrier_hier_data.

    CONSTANTS: c_nodeid_world TYPE /dmo/ana_airport_nodeid VALUE '00001'.

    DATA: l_s_hier          TYPE pt_s_carrier_hier,
          l_s_node          TYPE pt_s_carrier_hier_td_node,
          l_t_data_node     type pt_t_carrier_hier_td_node,
          l_t_carrier       TYPE STANDARD TABLE OF /dmo/carrier,
          l_nodetext        TYPE /dmo/ana_text,
          l_node_id         TYPE /dmo/ana_carrier_nodeid,
          l_sequence_number TYPE i,
          l_t_super_node    TYPE pt_t_carrier_hier_td_node,
          l_parent_id       TYPE /dmo/ana_carrier_nodeid,
          l_date_from       TYPE d,
          l_date_to         TYPE d,
          l_t_parent        TYPE pt_t_parent.
    FIELD-SYMBOLS:
          <l_s_node>        TYPE pt_s_carrier_hier_td_node.

    l_t_data_node =  VALUE #(
      ( hierarchy_id = p_hieid  nodename = |{ c_nodename }N|  nodetext = 'Alliance North' )
      ( hierarchy_id = p_hieid  nodename = |{ c_nodename }E|  nodetext = 'Alliance East' )
      ( hierarchy_id = p_hieid  nodename = |{ c_nodename }S|  nodetext = 'Alliance South' )
      ( hierarchy_id = p_hieid  nodename = |{ c_nodename }W|  nodetext = 'Alliance West' )
    ).

    l_t_super_node =  VALUE #(
      ( hierarchy_id = p_hieid  nodename = |SUPER_{ c_nodename }1|  nodetext = 'Super Alliance 1' )
      ( hierarchy_id = p_hieid  nodename = |SUPER_{ c_nodename }2|  nodetext = 'Super Alliance 2' )
      ( hierarchy_id = p_hieid  nodename = |SUPER_{ c_nodename }3|  nodetext = 'Super Alliance 3' )
    ).


* add nodes on level 1
    LOOP AT l_t_super_node ASSIGNING <l_s_node>.
      IF <l_s_node>-nodename CA '3'.
        l_date_from = p_i1_date.
      ELSE.
        l_date_from = '10000101'.
      ENDIF.
      l_node_id += 1.
      APPEND VALUE #( hierarchy_id    = <l_s_node>-hierarchy_id
                      node_id         = l_node_id
                      parent_node_id  = 0
                      date_from       = l_date_from
                      date_to         = '99991231'
                      nodename        = <l_s_node>-nodename
                      sequence_number = l_node_id )
        TO p_t_data_hier.
      INSERT VALUE #( nodename = <l_s_node>-nodename
                      datefrom = l_date_from
                      dateto   = '99991231'
                      node_id  = l_node_id )
        INTO TABLE p_th_nodeid.
    ENDLOOP.

* add nodes on level 2
    LOOP AT l_t_data_node ASSIGNING <l_s_node>.
      CASE sy-tabix.
        WHEN 1.
          l_t_parent = VALUE #( ( parent_id = 1 datefrom = p_min_date dateto = p_max_date ) ).
        WHEN 2.
          l_t_parent = VALUE #( ( parent_id = 1 datefrom = p_min_date dateto = ( p_i1_date - 1 ) )
                                ( parent_id = 3 datefrom = p_i1_date  dateto = p_max_date ) ).
        WHEN 3.
          l_t_parent = VALUE #( ( parent_id = 2 datefrom = p_min_date dateto = p_max_date ) ).
        WHEN 4.
          l_t_parent = VALUE #( ( parent_id = 2 datefrom = p_min_date dateto = ( p_i2_date - 1 ) )
                                ( parent_id = 3 datefrom = p_i2_date  dateto = p_max_date ) ).
      ENDCASE.

      LOOP AT l_t_parent ASSIGNING FIELD-SYMBOL(<l_s_parent>).
        l_node_id += 1.
        APPEND VALUE #( hierarchy_id    = <l_s_node>-hierarchy_id
                        node_id         = l_node_id
                        parent_node_id  = <l_s_parent>-parent_id
                        date_from       = <l_s_parent>-datefrom
                        date_to         = <l_s_parent>-dateto
                        nodename        = <l_s_node>-nodename
                        sequence_number = l_node_id )
          TO p_t_data_hier.
        INSERT VALUE #( nodename = <l_s_node>-nodename
                        datefrom = <l_s_parent>-datefrom
                        dateto   = <l_s_parent>-dateto
                        node_id  = l_node_id )
          INTO TABLE p_th_nodeid.
      ENDLOOP.
    ENDLOOP.

    APPEND LINES OF l_t_super_node TO l_t_data_node.

    set_node_data( l_t_data_node ).

* add leaves
    SELECT * FROM /dmo/carrier INTO TABLE @l_t_carrier. "#EC CI_NOWHERE

    LOOP AT l_t_carrier ASSIGNING FIELD-SYMBOL(<l_s_carrier>).

      get_parent_id( EXPORTING i_s_carrier = <l_s_carrier>
                     IMPORTING e_t_parent  =  l_t_parent ).

      LOOP AT l_t_parent ASSIGNING <l_s_parent>.
        l_node_id += 1.
        APPEND VALUE #( hierarchy_id    = p_hieid
                        node_id         = l_node_id
                        parent_node_id  = <l_s_parent>-parent_id
                        date_from       = <l_s_parent>-datefrom
                        date_to         = <l_s_parent>-dateto
                        carrier_id      = <l_s_carrier>-carrier_id
                        sequence_number = l_node_id )
          TO p_t_data_hier.
      ENDLOOP.
    ENDLOOP.


* directory
    DATA: l_s_dir TYPE pt_s_carrier_hier_dir.

    l_s_dir-hierarchy_id = p_hieid.
    l_s_dir-name         = 'Alliance Hierarchy'  ##NO_TEXT.
    GET TIME STAMP FIELD l_s_dir-last_changed_at.
    INSERT l_s_dir INTO TABLE p_t_data_dir.


  ENDMETHOD.

  METHOD generate_carrier_hier_td_data.
    DATA: l_datefrom TYPE /dmo/ana_date_from,
          l_dateto   TYPE /dmo/ana_date_to.

    DO 3 TIMES.
      CASE sy-index.
        WHEN 1. l_datefrom = '10000101'.    l_dateto = p_i1_date.
        WHEN 2. l_datefrom = p_i1_date + 1. l_dateto = p_i2_date.
        WHEN 3. l_datefrom = p_i2_date + 1. l_dateto = '99991209'.
      ENDCASE.

      " hierarchy directory (time dependent)
      DATA: l_s_data_td_dir TYPE pt_s_carrier_hier_td_dir.
      LOOP AT p_t_data_dir ASSIGNING FIELD-SYMBOL(<l_s_data_dir>).
        MOVE-CORRESPONDING <l_s_data_dir> TO l_s_data_td_dir.
        l_s_data_td_dir-date_from = l_datefrom.
        l_s_data_td_dir-date_to   = l_dateto.
        l_s_data_td_dir-name = get_text_with_time( i_text     = <l_s_data_dir>-name
                                                   i_datefrom = l_datefrom
                                                   i_dateto   = l_dateto ).
        APPEND l_s_data_td_dir TO p_t_data_td_dir.
      ENDLOOP.

      " hierarchy structure (not time dependent - fill dateto, which belongs to hierarchy key, with dateto from directory)
      IF l_datefrom = '10000101'.
        l_datefrom = p_min_date.
      ENDIF.
      DATA: l_s_data_td_hier TYPE pt_s_carrier_hier_td.
      LOOP AT p_t_data_hier ASSIGNING FIELD-SYMBOL(<l_s_data_hier>)
        WHERE date_from <= l_datefrom
          AND date_to   >= l_datefrom.
        MOVE-CORRESPONDING <l_s_data_hier> TO l_s_data_td_hier.
        l_s_data_td_hier-date_to = l_dateto.
        APPEND l_s_data_td_hier TO p_t_data_td_hier.
      ENDLOOP.

    ENDDO.

  ENDMETHOD.

  method set_node_data.
      DATA: l_datefrom       TYPE /dmo/ana_date_from,
            l_dateto         TYPE /dmo/ana_date_to,
            l_s_data_td_node TYPE pt_s_carrier_hier_td_node.
    " hierarchy node text (not time dependent - fill dateto, which belongs to hierarchy key, with dateto from directory)
    LOOP AT i_t_data_node ASSIGNING FIELD-SYMBOL(<l_s_data_node>).
      MOVE-CORRESPONDING <l_s_data_node> TO l_s_data_td_node.
      DO 3 TIMES.
        CASE sy-index.
          WHEN 1. l_datefrom = '10000101'.    l_dateto = p_i1_date.
          WHEN 2. l_datefrom = p_i1_date + 1. l_dateto = p_i2_date.
          WHEN 3. l_datefrom = p_i2_date + 1. l_dateto = '99991209'.
        ENDCASE.

        l_s_data_td_node-date_from = l_datefrom.
        l_s_data_td_node-date_to   = l_dateto.
        l_s_data_td_node-nodetext  = get_text_with_time( i_text     = <l_s_data_node>-nodetext
                                                         i_datefrom = l_datefrom
                                                         i_dateto   = l_dateto ).
        APPEND l_s_data_td_node TO p_t_data_td_node.
      ENDDO.
    ENDLOOP.
  endmethod.

  METHOD get_text_with_time.

    DATA: l_interval_c TYPE string.

    " text for time interval
    IF i_datefrom = '10000101'.
      l_interval_c = |(to {  get_text_for_date( i_dateto ) })|.
    ELSEIF i_dateto = '99991209'.
      l_interval_c = |(from {  get_text_for_date( i_datefrom ) })|.
    ELSE.
      l_interval_c = |({ get_text_for_date( i_datefrom ) } - {  get_text_for_date( i_dateto ) })|.
    ENDIF.

    r_text = |{ i_text } { l_interval_c }|.
  ENDMETHOD.

  METHOD get_text_for_date.
    DATA: l_date_c TYPE c LENGTH 8,
          l_month  TYPE c LENGTH 3.
    l_date_c = i_date.

    CASE l_date_c+4(2).
      WHEN  1. l_month = 'Jan'.
      WHEN  2. l_month = 'Feb'.
      WHEN  3. l_month = 'Mar'.
      WHEN  4. l_month = 'Apr'.
      WHEN  5. l_month = 'May'.
      WHEN  6. l_month = 'Jun'.
      WHEN  7. l_month = 'Jul'.
      WHEN  8. l_month = 'Aug'.
      WHEN  9. l_month = 'Sep'.
      WHEN 10. l_month = 'Oct'.
      WHEN 11. l_month = 'Nov'.
      WHEN 12. l_month = 'Dec'.
    ENDCASE.

    r_text = |{ l_date_c+6(2) }-{ l_month }-{ l_date_c(4) }|.

  ENDMETHOD.
ENDCLASS.
