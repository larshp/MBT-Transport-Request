************************************************************************
* /MBTOOLS/CL_CTS_REQ_DISP_CTS
* MBT Request Display
*
* (c) MBT 2020 https://marcbernardtools.com/
************************************************************************
class /MBTOOLS/CL_CTS_REQ_DISP_CTS definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces /MBTOOLS/IF_CTS_REQ_DISPLAY .

  aliases GET_OBJECT_DESCRIPTIONS
    for /MBTOOLS/IF_CTS_REQ_DISPLAY~GET_OBJECT_DESCRIPTIONS .
  aliases GET_OBJECT_ICON
    for /MBTOOLS/IF_CTS_REQ_DISPLAY~GET_OBJECT_ICON .

  class-data:
    mt_object_list TYPE RANGE OF e071-object read-only .

  class-methods CLASS_CONSTRUCTOR .
  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS /MBTOOLS/CL_CTS_REQ_DISP_CTS IMPLEMENTATION.


  METHOD /mbtools/if_cts_req_display~get_object_descriptions.

    DATA:
      ls_e071_txt    TYPE /mbtools/trwbo_s_e071_txt,
      ls_object_text TYPE ko100,
      lt_object_text TYPE TABLE OF ko100.

    FIELD-SYMBOLS:
      <ls_e071> TYPE trwbo_s_e071.

    CALL FUNCTION 'TR_OBJECT_TABLE'
      TABLES
        wt_object_text = lt_object_text.

    LOOP AT it_e071 ASSIGNING <ls_e071> WHERE object IN mt_object_list.
      CLEAR ls_e071_txt.
      MOVE-CORRESPONDING <ls_e071> TO ls_e071_txt.

      CALL METHOD get_object_icon
        EXPORTING
          iv_object = <ls_e071>-object
        CHANGING
          rv_icon   = ls_e071_txt-icon.

      CASE <ls_e071>-object.
        WHEN 'MERG' OR 'RELE' OR 'COMM'.
          " Comment: Object List Included, Comment Entry: Released,
          " Object List of Request or Piece List
          SELECT SINGLE as4text FROM e07t INTO ls_e071_txt-text
            WHERE trkorr = <ls_e071>-obj_name(10) AND langu = sy-langu.
          IF sy-subrc <> 0.
            ls_e071_txt-text = <ls_e071>-obj_name.
          ENDIF.
          ls_e071_txt-name = <ls_e071>-obj_name.
        WHEN 'ADIR'.
          " Object Directory Entry
          READ TABLE lt_object_text INTO ls_object_text
            WITH KEY pgmid = <ls_e071>-obj_name(4) object = <ls_e071>-obj_name+4(4).
          IF sy-subrc = 0.
            ls_e071_txt-text = ls_object_text-text.
          ELSE.
            ls_e071_txt-text = 'No description'.
          ENDIF.
          CONCATENATE <ls_e071>-obj_name(4) <ls_e071>-obj_name+4(4) <ls_e071>-obj_name+8
            INTO ls_e071_txt-name SEPARATED BY space.
        WHEN OTHERS.
          ls_e071_txt-text = <ls_e071>-obj_name.
          ls_e071_txt-name = <ls_e071>-obj_name.
      ENDCASE.

      INSERT ls_e071_txt INTO TABLE ct_e071_txt.
    ENDLOOP.

  ENDMETHOD.


  METHOD /mbtools/if_cts_req_display~get_object_icon.

    CASE iv_object.
      WHEN 'MERG'. " Comment: Object List Included
        rv_icon = icon_include_objects.
      WHEN 'PERF'. " Perforce Changelist
        rv_icon = icon_modified_object.
      WHEN 'RELE'. " Comment Entry: Released
        rv_icon = icon_release.
      WHEN 'ADIR'. " Object Directory Entry
        rv_icon = icon_detail.
      WHEN 'COMM'. " Object List of Request or Piece List
        rv_icon = icon_document.
      WHEN OTHERS.
        rv_icon = icon_dummy.
    ENDCASE.

  ENDMETHOD.


  METHOD class_constructor.

    DATA:
      ls_object_list LIKE LINE OF mt_object_list.

    ls_object_list-sign   = 'I'.
    ls_object_list-option = 'EQ'.

    ls_object_list-low = 'MERG'. " Comment: Object List Included
    APPEND ls_object_list TO mt_object_list.
    ls_object_list-low = 'PERF'. " Perforce Changelist
    APPEND ls_object_list TO mt_object_list.
    ls_object_list-low = 'RELE'. " Comment Entry: Released
    APPEND ls_object_list TO mt_object_list.
    ls_object_list-low = 'ADIR'. " Object Directory Entry
    APPEND ls_object_list TO mt_object_list.
    ls_object_list-low = 'COMM'. " Object List of Request or Piece List
    APPEND ls_object_list TO mt_object_list.

  ENDMETHOD.
ENDCLASS.
