CLASS /dmo/cl_data_gen_ana_extension DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES /dmo/if_data_generation_badi .

    METHODS:
      ana_data_generation
        IMPORTING out TYPE REF TO if_oo_adt_classrun_out OPTIONAL.

  PROTECTED SECTION.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF pt_s_city,
        city    TYPE /dmo/city,       " city
        country TYPE land1, " country
        lat_deg TYPE c LENGTH 3,           " langitude degrees
        lat_min TYPE c LENGTH 2,           " langitude minutes
        lat_ori TYPE c LENGTH 1,           " langitude orientation: N, S
        lon_deg TYPE c LENGTH 3,           " latitude degrees
        lon_min TYPE c LENGTH 2,           " latitude minutes
        lon_ori TYPE c LENGTH 1,           " latitude orientation: E , W
      END OF pt_s_city,
      pt_ts_city             TYPE STANDARD TABLE OF pt_s_city,

      pt_s_dmo_city          TYPE /dmo/ana_city,
      pt_ts_dmo_city         TYPE SORTED TABLE OF pt_s_dmo_city WITH UNIQUE KEY city country,

      pt_s_airport_hier      TYPE /dmo/ana_ap_h,
      pt_t_airport_hier      TYPE STANDARD TABLE OF pt_s_airport_hier WITH NON-UNIQUE KEY table_line,

      pt_s_airport_hier_node TYPE /dmo/ana_ap_hn,
      pt_t_airport_hier_node TYPE STANDARD TABLE OF pt_s_airport_hier_node WITH NON-UNIQUE KEY table_line,

      pt_s_airport_hier_dir  TYPE /dmo/ana_ap_hd,
      pt_t_airport_hier_dir  TYPE STANDARD TABLE OF pt_s_airport_hier_dir WITH NON-UNIQUE KEY table_line.

    DATA: p_r_log TYPE REF TO lcl_text_output.

    METHODS:
      fill_city,
      generate_city_data
        RETURNING VALUE(r_ts_dmo_city) TYPE pt_ts_dmo_city,
      insert_city_data
        IMPORTING i_ts_city TYPE pt_ts_dmo_city,

      fill_airport_hier
        IMPORTING i_hieid TYPE /DMO/ANA_AIRPORT_HIEID,

      generate_geo_hier_data
        IMPORTING i_hieid  TYPE /DMO/ANA_AIRPORT_HIEID
        EXPORTING e_t_hier TYPE pt_t_airport_hier
                  e_t_node TYPE pt_t_airport_hier_node
                  e_t_dir  TYPE pt_t_airport_hier_dir,

      generate_abc_hier_data
        IMPORTING i_hieid  TYPE /DMO/ANA_AIRPORT_HIEID
        EXPORTING e_t_hier TYPE pt_t_airport_hier
                  e_t_node TYPE pt_t_airport_hier_node
                  e_t_dir  TYPE pt_t_airport_hier_dir,

      get_continent
        IMPORTING i_country          TYPE land1
        RETURNING VALUE(r_continent) TYPE /dmo/ana_text,

      get_nodetext
        IMPORTING i_nodename        TYPE /dmo/ana_nodename
        RETURNING VALUE(r_nodetext) TYPE /dmo/ana_text.

ENDCLASS.



CLASS /DMO/CL_DATA_GEN_ANA_EXTENSION IMPLEMENTATION.


  METHOD /dmo/if_data_generation_badi~data_generation.
    ana_data_generation( ).
  ENDMETHOD.


  METHOD ana_data_generation.
    p_r_log = lcl_text_output=>get_instance( out ).

    fill_city( ).

    fill_airport_hier( 'GEO' ).

    fill_airport_hier( 'ABC' ).

  ENDMETHOD.


  METHOD fill_city.
    DATA: l_ts_city TYPE pt_ts_dmo_city.

    p_r_log->print_title( 'City (Analytics)' ) ##NO_TEXT.

    p_r_log->print_delete( ).
    DELETE FROM /dmo/ana_city. "#EC CI_NOWHERE

    p_r_log->print_build( ).
    l_ts_city = generate_city_data( ).

    p_r_log->print_insert( ).
    insert_city_data( l_ts_city ).

    p_r_log->print_done( ).

  ENDMETHOD.


  METHOD generate_city_data.

    DATA: l_ts_city    TYPE pt_ts_city,
          l_s_city     TYPE pt_s_city,
          l_s_dmo_city TYPE pt_s_dmo_city.

*-----------------------------------------------------------------------
*   country city                                latitude       longitude
*-----------------------------------------------------------------------

l_ts_city = value #(

    ( country = 'AT' city = 'Vienna'                            lat_deg = '48' lat_min = '13' lat_ori = 'N'  lon_deg =  '16' lon_min = '22'  lon_ori = 'E'  )
    ( country = 'AU' city = 'Alice Springs, Northern Territory' lat_deg = '23' lat_min = '42' lat_ori = 'S'  lon_deg = '133' lon_min = '48'  lon_ori = 'E'  )
    ( country = 'BR' city = 'Rio de Janeiro'                    lat_deg = '22' lat_min = '54' lat_ori = 'S'  lon_deg =  '43' lon_min = '12'  lon_ori = 'W'  )
    ( country = 'CA' city = 'Ottawa, Ontario'                   lat_deg = '45' lat_min = '24' lat_ori = 'N'  lon_deg =  '75' lon_min = '41'  lon_ori = 'W'  )
    ( country = 'CH' city = 'Zurich'                            lat_deg = '47' lat_min = '22' lat_ori = 'N'  lon_deg =   '8' lon_min = '32'  lon_ori = 'E'  )
    ( country = 'CN' city = 'Hongkong'                          lat_deg = '22' lat_min = '18' lat_ori = 'N'  lon_deg = '114' lon_min = '10'  lon_ori = 'E'  )
    ( country = 'CU' city = 'Havana'                            lat_deg = '23' lat_min =  '7' lat_ori = 'N'  lon_deg =  '82' lon_min = '23'  lon_ori = 'E'  )
    ( country = 'DE' city = 'Berlin'                            lat_deg = '52' lat_min = '31' lat_ori = 'N'  lon_deg =  '13' lon_min = '24'  lon_ori = 'E'  )
    ( country = 'DE' city = 'Frankfurt/Main'                    lat_deg = '50' lat_min = '07' lat_ori = 'N'  lon_deg =   '8' lon_min = '41'  lon_ori = 'E'  )
    ( country = 'DE' city = 'Hamburg'                           lat_deg = '53' lat_min = '33' lat_ori = 'N'  lon_deg =  '10' lon_min = '00'  lon_ori = 'E'  )
    ( country = 'DE' city = 'Munich'                            lat_deg = '48' lat_min = '08' lat_ori = 'N'  lon_deg =  '11' lon_min = '34'  lon_ori = 'E'  )
    ( country = 'ES' city = 'Lanzarote, Canary Islands'         lat_deg = '29' lat_min = '03' lat_ori = 'N'  lon_deg =  '13' lon_min = '37'  lon_ori = 'W'  )
    ( country = 'ES' city = 'Madrid'                            lat_deg = '40' lat_min = '26' lat_ori = 'N'  lon_deg =  '03' lon_min = '42'  lon_ori = 'W'  )
    ( country = 'FR' city = 'Paris'                             lat_deg = '48' lat_min = '51' lat_ori = 'N'  lon_deg =  '02' lon_min = '20'  lon_ori = 'E'  )
    ( country = 'IT' city = 'Rome'                              lat_deg = '41' lat_min = '52' lat_ori = 'N'  lon_deg =  '12' lon_min = '29'  lon_ori = 'E'  )
    ( country = 'IT' city = 'Venice'                            lat_deg = '45' lat_min = '26' lat_ori = 'N'  lon_deg =  '12' lon_min = '20'  lon_ori = 'E'  )
    ( country = 'JP' city = 'Hiroshima, Honshu'                 lat_deg = '34' lat_min = '23' lat_ori = 'N'  lon_deg = '132' lon_min = '27'  lon_ori = 'E'  )
    ( country = 'JP' city = 'Osaka, Honshu'                     lat_deg = '34' lat_min = '41' lat_ori = 'N'  lon_deg = '135' lon_min = '30'  lon_ori = 'E'  )
    ( country = 'JP' city = 'Tokyo, Honshu'                     lat_deg = '35' lat_min = '41' lat_ori = 'N'  lon_deg = '139' lon_min = '44'  lon_ori = 'E'  )
    ( country = 'MX' city = 'Acapulco, Guerrero'                lat_deg = '16' lat_min = '51' lat_ori = 'N'  lon_deg =  '54' lon_min = '35'  lon_ori = 'W'  )
    ( country = 'MY' city = 'Kuala Lumpur'                      lat_deg = '03' lat_min = '08' lat_ori = 'N'  lon_deg = '101' lon_min = '42'  lon_ori = 'E'  )
    ( country = 'NL' city = 'Rotterdam'                         lat_deg = '51' lat_min = '56' lat_ori = 'N'  lon_deg =  '04' lon_min = '29'  lon_ori = 'E'  )
    ( country = 'RU' city = 'Moscow'                            lat_deg = '55' lat_min = '45' lat_ori = 'N'  lon_deg =  '37' lon_min = '37'  lon_ori = 'E'  )
    ( country = 'SA' city = 'Johannesburg'                      lat_deg = '26' lat_min = '12' lat_ori = 'S'  lon_deg =  '28' lon_min = '04'  lon_ori = 'E'  )
    ( country = 'SG' city = 'Singapore'                         lat_deg = '01' lat_min = '17' lat_ori = 'N'  lon_deg = '103' lon_min = '50'  lon_ori = 'E'  )
    ( country = 'TH' city = 'Bangkok'                           lat_deg = '13' lat_min = '45' lat_ori = 'N'  lon_deg = '100' lon_min = '31'  lon_ori = 'E'  )
    ( country = 'UK' city = 'London'                            lat_deg = '51' lat_min = '31' lat_ori = 'N'  lon_deg =  '00' lon_min = '07'  lon_ori = 'W'  )
    ( country = 'US' city = 'Boston, Massachusetts'             lat_deg = '42' lat_min = '21' lat_ori = 'N'  lon_deg =  '71' lon_min = '03'  lon_ori = 'W'  )
    ( country = 'US' city = 'Denver, Colorado'                  lat_deg = '39' lat_min = '44' lat_ori = 'N'  lon_deg = '104' lon_min = '59'  lon_ori = 'W'  )
    ( country = 'US' city = 'El Paso, Texas'                    lat_deg = '31' lat_min = '47' lat_ori = 'N'  lon_deg = '106' lon_min = '29'  lon_ori = 'W'  )
    ( country = 'US' city = 'Houston, Texas'                    lat_deg = '29' lat_min = '46' lat_ori = 'N'  lon_deg =  '95' lon_min = '23'  lon_ori = 'W'  )
    ( country = 'US' city = 'Kansas City, Missouri'             lat_deg = '39' lat_min = '07' lat_ori = 'N'  lon_deg =  '94' lon_min = '35'  lon_ori = 'W'  )
    ( country = 'US' city = 'Las Vegas, Nevada'                 lat_deg = '36' lat_min = '11' lat_ori = 'N'  lon_deg = '115' lon_min = '08'  lon_ori = 'W'  )
    ( country = 'US' city = 'Los Angeles, California'           lat_deg = '34' lat_min = '03' lat_ori = 'N'  lon_deg = '118' lon_min = '15'  lon_ori = 'W'  )
    ( country = 'US' city = 'Miami, Florida'                    lat_deg = '25' lat_min = '47' lat_ori = 'N'  lon_deg =  '80' lon_min = '13'  lon_ori = 'W'  )
    ( country = 'US' city = 'Nashville, Tennessee'              lat_deg = '36' lat_min = '10' lat_ori = 'N'  lon_deg =  '86' lon_min = '47'  lon_ori = 'W'  )
    ( country = 'US' city = 'New York City, New York'           lat_deg = '40' lat_min = '43' lat_ori = 'N'  lon_deg =  '74' lon_min = '00'  lon_ori = 'W'  )
    ( country = 'US' city = 'Newark, New Jersey'                lat_deg = '40' lat_min = '44' lat_ori = 'N'  lon_deg =  '74' lon_min = '11'  lon_ori = 'W'  )
    ( country = 'US' city = 'San Francisco, California'         lat_deg = '37' lat_min = '47' lat_ori = 'N'  lon_deg = '122' lon_min = '25'  lon_ori = 'W'  )
    ( country = 'ZW' city = 'Harare'                            lat_deg = '17' lat_min = '50' lat_ori = 'S'  lon_deg =  '31' lon_min = '03'  lon_ori = 'E'  )
    ).


    LOOP AT l_ts_city ASSIGNING FIELD-SYMBOL(<l_s_city>).
      l_s_dmo_city-city      = <l_s_city>-city.
      l_s_dmo_city-country   = <l_s_city>-country.

      l_s_dmo_city-longitude = <l_s_city>-lon_deg + <l_s_city>-lon_min / '60.0'.
      IF <l_s_city>-lon_ori = 'W'.
        l_s_dmo_city-longitude = l_s_dmo_city-longitude * ( -1 ).
      ENDIF.

      l_s_dmo_city-latitude = <l_s_city>-lat_deg + <l_s_city>-lat_min / '60.0'.
      IF <l_s_city>-lat_ori = 'S'.
        l_s_dmo_city-latitude =  l_s_dmo_city-latitude * ( -1 ).
      ENDIF.

      INSERT  l_s_dmo_city INTO TABLE r_ts_dmo_city.
    ENDLOOP.

  ENDMETHOD.


  METHOD insert_city_data.
*   WGS 84 / Pseudo-Mercator – SRID 3857
*   WGS 84 / Pseudo-Mercator is popular in map visualization applications. It is not a recognized geodetic system,
*   because errors in scale and northing may arise.
*
*    WGS 84 / Pseudo-Mercator Coordinates are in metre, where the first coordinate is X with bounds -20037508.34 to 20037508.34,
*    and the second coordinate is Y with bounds 20048966.10 to 20048966.10 (which correspond to latitude -85.06° to 85.06°).
*
*    The default unit of measure for WGS 84 / Pseudo-Mercator is METRE, and it is a flat-Earth type of spatial reference system.
    DATA: l_longitude_meter TYPE f,
          l_latitude_meter  TYPE f.

*
* Radius Äquator: 6.378.137m
* 1/2 Umfang Äquator: 20.037.508,34m

* Radius Längenkreis: 6.356.752m
* 1/2 Umfang Längenkreis: 19.970.325,38m
* 1/4 Umfang Längenkreis:  9.985.162,69m

    data ana_city_tab type STANDARD TABLE OF /DMO/ANA_CITY.

    ana_city_tab = value #( for city in i_ts_city
    (
      mandt = sy-mandt
      country = city-country
      city = city-city
      latitude = city-latitude
      longitude = city-longitude
* AR Not sure how this can be done in ABAP??
      " geopoint = value #(  )
    ) ).
    insert /DMO/ANA_CITY from table @ana_city_tab.

* AR Commenting out until we can use the geopoints
*    TRY.
*        LOOP AT i_ts_city INTO DATA(l_s_city).
*          l_longitude_meter = l_s_city-longitude / 180 * '20037508.34'.
*          l_latitude_meter  = l_s_city-latitude /   90 * '11183382.21'.  " correct with factor 1.12
*
*
*         " EXEC SQL.
*         "   insert into "/DMO/ANA_CITY" (mandt, country, city, latitude, longitude, geopoint)
*         "     values( :sy-mandt , :l_s_city-COUNTRY , :l_s_city-city , :l_s_city-LATITUDE , :l_s_city-longitude , new st_point( :l_longitude_meter , :l_latitude_meter, 3857 ) )
*         " ENDEXEC .
*           "#EC CI_EXECSQL
*        ENDLOOP.
*      CATCH cx_sy_native_sql_error INTO DATA(l_r_exc).
*        p_r_log->print_error( ).
*    ENDTRY.

  ENDMETHOD.


  METHOD fill_airport_hier.

    DATA: l_t_hier      TYPE pt_t_airport_hier,
          l_t_hier_node TYPE pt_t_airport_hier_node,
          l_t_hier_dir  TYPE pt_t_airport_hier_dir.

    p_r_log->print_title( |Airport { i_hieid } hierarchy (Analytics)| ) ##NO_TEXT.

    p_r_log->print_delete( ).
    DELETE FROM /dmo/ana_ap_h  WHERE hierarchy_id = @i_hieid.
    DELETE FROM /dmo/ana_ap_hn WHERE hierarchy_id = @i_hieid.
    DELETE FROM /dmo/ana_ap_hd WHERE hierarchy_id = @i_hieid.

    p_r_log->print_build( ).
    CASE i_hieid.
      WHEN 'GEO'.
        generate_geo_hier_data( EXPORTING i_hieid       = i_hieid
                                IMPORTING e_t_hier      = l_t_hier
                                          e_t_node = l_t_hier_node
                                          e_t_dir  = l_t_hier_dir ).

      WHEN 'ABC'.
        generate_abc_hier_data( EXPORTING i_hieid       = i_hieid
                                IMPORTING e_t_hier      = l_t_hier
                                          e_t_node = l_t_hier_node
                                          e_t_dir  = l_t_hier_dir ).
      WHEN OTHERS.
        p_r_log->print_error( ).
        RETURN.
    ENDCASE.

    p_r_log->print_insert( ).
    INSERT /dmo/ana_ap_h  FROM TABLE @l_t_hier.
    INSERT /dmo/ana_ap_hn FROM TABLE @l_t_hier_node.
    INSERT /dmo/ana_ap_hd FROM TABLE @l_t_hier_dir.


    p_r_log->print_done( ).

  ENDMETHOD.


  METHOD generate_geo_hier_data.

    CONSTANTS: c_nodeid_world TYPE /DMO/ANA_AIRPORT_NODEID VALUE '00001'.

    DATA: l_s_hier          TYPE pt_s_airport_hier,
          l_s_node          TYPE pt_s_airport_hier_node,
          l_t_airport       TYPE STANDARD TABLE OF /dmo/airport,
          l_nodetext        TYPE /dmo/ana_text,
          l_node_id         TYPE /dmo/ana_airport_nodeid,
          l_sequence_number TYPE i.

    SELECT * FROM /dmo/airport INTO TABLE @l_t_airport. "#EC CI_NOWHERE

    APPEND VALUE #( hierarchy_id = i_hieid
                    nodename     = 'WORLD'
                    nodetext     = 'World'  ##NO_TEXT
                  ) TO e_t_node.

    ADD 1 TO l_node_id.
    ADD 1 TO l_sequence_number.
    APPEND VALUE #( hierarchy_id    = i_hieid
                    node_id         = l_node_id
*                 PARENT_NODE_ID initial == root!
                    nodename        = 'WORLD'
                    nodetype        = 'NODENAME'
                    sequence_number = l_sequence_number
                  ) TO e_t_hier.

    LOOP AT l_t_airport ASSIGNING FIELD-SYMBOL(<l_s_airport>).

      READ TABLE e_t_hier ASSIGNING FIELD-SYMBOL(<l_s_hier_city>)
        WITH KEY country = <l_s_airport>-country
                 city    = <l_s_airport>-city .
      IF sy-subrc <> 0.
        READ TABLE e_t_hier ASSIGNING FIELD-SYMBOL(<l_s_hier_country>)
          WITH KEY country = <l_s_airport>-country .
        IF sy-subrc <> 0.
          l_nodetext = get_continent( <l_s_airport>-country ).

          READ TABLE e_t_hier ASSIGNING FIELD-SYMBOL(<l_s_hier_node>)
            WITH KEY nodename = to_upper( l_nodetext ).
          IF sy-subrc <> 0.
            ADD 1 TO l_node_id.
            ADD 1 TO l_sequence_number.
            APPEND VALUE #( hierarchy_id    = i_hieid
                            node_id         = l_node_id
                            parent_node_id  = c_nodeid_world
                            nodename        = to_upper( l_nodetext )
                            nodetype        = 'NODENAME'
                            sequence_number = l_sequence_number
                          ) TO e_t_hier ASSIGNING <l_s_hier_node>.
            APPEND VALUE #( hierarchy_id = i_hieid
                            nodename     = to_upper( l_nodetext )
                            nodetext     = l_nodetext
                          ) TO e_t_node.
          ENDIF.

          ADD 1 TO l_node_id.
          ADD 1 TO l_sequence_number.
          APPEND VALUE #( hierarchy_id    = i_hieid
                          node_id         = l_node_id
                          parent_node_id  = <l_s_hier_node>-node_id
                          country         = <l_s_airport>-country
                          nodetype        = 'COUNTRY'
                          sequence_number = l_sequence_number
                        ) TO e_t_hier ASSIGNING <l_s_hier_country>.
        ENDIF.

        ADD 1 TO l_node_id.
        ADD 1 TO l_sequence_number.
        APPEND VALUE #( hierarchy_id = i_hieid
                        node_id      = l_node_id
                        parent_node_id = <l_s_hier_country>-node_id
                        country      = <l_s_airport>-country
                        city         = <l_s_airport>-city
                        nodetype     = 'CITY'
                        sequence_number = l_sequence_number
                      ) TO e_t_hier ASSIGNING <l_s_hier_city>.
      ENDIF.

      ADD 1 TO l_node_id.
      ADD 1 TO l_sequence_number.
      APPEND VALUE #( hierarchy_id = i_hieid
                      node_id      = l_node_id
                      parent_node_id = <l_s_hier_city>-node_id
                      airport      = <l_s_airport>-airport_id
                      nodetype     = 'AIRPORT'
                      sequence_number = l_sequence_number
                    ) TO e_t_hier.

    ENDLOOP.

    DATA: l_s_dir TYPE pt_s_airport_hier_dir.

    l_s_dir-hierarchy_id = i_hieid.
    l_s_dir-name         = 'Geo Hierarchy'  ##NO_TEXT.
    GET TIME STAMP FIELD l_s_dir-last_changed_at.
    INSERT l_s_dir INTO TABLE e_t_dir.

  ENDMETHOD.


  METHOD generate_abc_hier_data.
    CONSTANTS: c_nodeid_all TYPE /DMO/ANA_AIRPORT_NODEID VALUE '00001'.

    DATA: l_s_hier          TYPE pt_s_airport_hier,
          l_s_node          TYPE pt_s_airport_hier_node,
          l_t_airport       TYPE STANDARD TABLE OF /dmo/airport,
          l_nodename        TYPE /dmo/ana_nodename,
          l_nodename_p      TYPE /dmo/ana_nodename,
          l_nodetext        TYPE /dmo/ana_text,
          l_node_id         TYPE /dmo/ana_airport_nodeid,
          l_sequence_number TYPE i.

    " select all fields / performance is not issue here
    SELECT * FROM /dmo/airport
      ORDER BY airport_id
      INTO TABLE @l_t_airport.   "#EC CI_ALL_FIELDS_NEEDED #EC CI_NOWHERE

    APPEND VALUE #( hierarchy_id = i_hieid
                    nodename = 'ALL'
                    nodetext = 'all'   ##NO_TEXT
                  ) TO e_t_node.

    ADD 1 TO l_node_id.
    ADD 1 TO l_sequence_number.
    APPEND VALUE #( hierarchy_id    = i_hieid
                    node_id         = l_node_id
*                 PARENT_NODE_ID initial == root!
                    nodename        = 'ALL'
                    nodetype        = 'NODENAME'
                    sequence_number = l_sequence_number
                  ) TO e_t_hier.

    LOOP AT l_t_airport ASSIGNING FIELD-SYMBOL(<l_s_airport>).

      IF     <l_s_airport>-airport_id(1) BETWEEN 'A' AND 'E'.
        l_nodename = 'A_E'.
        l_nodename_p = 'A_J'.
      ELSEIF <l_s_airport>-airport_id(1) BETWEEN 'F' AND 'J'.
        l_nodename = 'F_J'.
        l_nodename_p = 'A_J'.
      ELSEIF <l_s_airport>-airport_id(1) BETWEEN 'K' AND 'O'.
        l_nodename = 'K_O'.
        l_nodename_p = 'K_Z'.
      ELSEIF <l_s_airport>-airport_id(1) BETWEEN 'P' AND 'T'.
        l_nodename = 'P_T'.
        l_nodename_p = 'K_Z'.
      ELSE.
        l_nodename = 'U_Z'.
        l_nodename_p = 'K_Z'.
      ENDIF.

      READ TABLE e_t_hier ASSIGNING FIELD-SYMBOL(<l_s_hier_l2>)
        WITH KEY nodename = l_nodename .
      IF sy-subrc <> 0.
        READ TABLE e_t_hier ASSIGNING FIELD-SYMBOL(<l_s_hier_l1>)
          WITH KEY nodename = l_nodename_p .
        IF sy-subrc <> 0.
          ADD 1 TO l_node_id.
          ADD 1 TO l_sequence_number.
          APPEND VALUE #( hierarchy_id    = i_hieid
                          node_id         = l_node_id
                          parent_node_id  = c_nodeid_all
                          nodename        = l_nodename_p
                          nodetype        = 'NODENAME'
                          sequence_number = l_sequence_number
                        ) TO e_t_hier ASSIGNING <l_s_hier_l1>.
          APPEND VALUE #( hierarchy_id = i_hieid
                          nodename     = l_nodename_p
                          nodetext     = get_nodetext( l_nodename_p )
                        ) TO e_t_node.
        ENDIF.

        ADD 1 TO l_node_id.
        ADD 1 TO l_sequence_number.
        APPEND VALUE #( hierarchy_id    = i_hieid
                        node_id         = l_node_id
                        parent_node_id  = <l_s_hier_l1>-node_id
                          nodename        = l_nodename
                          nodetype        = 'NODENAME'
                        sequence_number = l_sequence_number
                      ) TO e_t_hier ASSIGNING <l_s_hier_l2>.
        APPEND VALUE #( hierarchy_id = i_hieid
                        nodename     = l_nodename
                        nodetext     = get_nodetext( l_nodename )
                      ) TO e_t_node.
      ENDIF.

      ADD 1 TO l_node_id.
      ADD 1 TO l_sequence_number.
      APPEND VALUE #( hierarchy_id = i_hieid
                      node_id      = l_node_id
                      parent_node_id = <l_s_hier_l2>-node_id
                      airport      = <l_s_airport>-airport_id
                      nodetype     = 'AIRPORT'
                      sequence_number = l_sequence_number
                    ) TO e_t_hier.

    ENDLOOP.

    DATA: l_s_dir TYPE pt_s_airport_hier_dir.

    l_s_dir-hierarchy_id = i_hieid.
    l_s_dir-name         = 'ABC Hierarchy'  ##NO_TEXT.
    GET TIME STAMP FIELD l_s_dir-last_changed_at.
    INSERT l_s_dir INTO TABLE e_t_dir.

  ENDMETHOD.


  METHOD get_continent.
    CASE i_country.
      WHEN 'DE' OR 'FR' OR 'AT' OR 'CH' OR 'NL' OR 'IT' OR 'UK'
        OR 'ES' OR 'RU'.
        r_continent = 'Europe' ##NO_TEXT.

      WHEN 'US' OR 'CU' OR 'CA' OR 'MX'.
        r_continent = 'North America' ##NO_TEXT.

      WHEN 'BR'.
        r_continent = 'South America' ##NO_TEXT.

      WHEN 'ZA' OR 'ZW'.
        r_continent = 'Africa' ##NO_TEXT.

      WHEN 'SA'.
        r_continent = 'MiddleEast' ##NO_TEXT.

      WHEN 'MY' OR 'SG' OR 'JP' OR 'CN' OR 'TH'.
        r_continent = 'Asia' ##NO_TEXT.

      WHEN 'AU'.
        r_continent = 'Oceania' ##NO_TEXT.

      WHEN OTHERS.
        CLEAR r_continent.

    ENDCASE.
  ENDMETHOD.


  METHOD get_nodetext.

    r_nodetext = |{ i_nodename(1) } to { i_nodename+2(1) }|.
  ENDMETHOD.
ENDCLASS.
