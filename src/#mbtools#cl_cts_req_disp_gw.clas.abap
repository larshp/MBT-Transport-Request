************************************************************************
* /MBTOOLS/CL_CTS_REQ_DISP_GW
* MBT Transport Request
*
* (c) MBT 2020 https://marcbernardtools.com/
************************************************************************
CLASS /mbtools/cl_cts_req_disp_gw DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES /mbtools/if_cts_req_display .

    ALIASES get_object_descriptions
      FOR /mbtools/if_cts_req_display~get_object_descriptions .
    ALIASES get_object_icon
      FOR /mbtools/if_cts_req_display~get_object_icon .

    CLASS-DATA:
      mt_object_list TYPE RANGE OF e071-object READ-ONLY .

    CLASS-METHODS class_constructor .
  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS /MBTOOLS/CL_CTS_REQ_DISP_GW IMPLEMENTATION.


  METHOD /mbtools/if_cts_req_display~get_object_descriptions.

    DATA:
      ls_e071_txt TYPE /mbtools/trwbo_s_e071_txt.

    FIELD-SYMBOLS:
      <ls_e071> TYPE trwbo_s_e071.

    LOOP AT it_e071 ASSIGNING <ls_e071> WHERE object IN mt_object_list.
      CLEAR ls_e071_txt.
      MOVE-CORRESPONDING <ls_e071> TO ls_e071_txt.

      CALL METHOD get_object_icon
        EXPORTING
          iv_object = <ls_e071>-object
        CHANGING
          rv_icon   = ls_e071_txt-icon.

      CASE <ls_e071>-object.
        WHEN 'G4BA'  " SAP Gateway OData V4 Backend Service Group & Assigments
          OR 'G4BG'  " SAP Gateway OData V4 Backend Service Group & Assigments (obsolete)
          OR 'G4BS'. " SAP Gateway OData V4 Backend Service
          SELECT SINGLE description FROM /iwbep/i_v4_msgt INTO ls_e071_txt-text
            WHERE group_id = <ls_e071>-object AND language = sy-langu.
          INSERT ls_e071_txt INTO TABLE ct_e071_txt.
        WHEN 'IWMO'. " SAP Gateway Business Suite Enablement - Model
          ls_e071_txt-text = ''.
          ls_e071_txt-name = ''.
          INSERT ls_e071_txt INTO TABLE ct_e071_txt.
        WHEN 'IWOM'. " SAP Gateway: Model Metadata
          ls_e071_txt-text = ''.
          ls_e071_txt-name = ''.
          INSERT ls_e071_txt INTO TABLE ct_e071_txt.
        WHEN 'IWPR'. " SAP Gateway BSE - Service Builder Project
          ls_e071_txt-text = ''.
          ls_e071_txt-name = ''.
          INSERT ls_e071_txt INTO TABLE ct_e071_txt.
        WHEN 'IWSG'. " SAP Gateway: Service Groups Metadata
          ls_e071_txt-text = ''.
          ls_e071_txt-name = ''.
          INSERT ls_e071_txt INTO TABLE ct_e071_txt.
        WHEN 'IWSV'. " SAP Gateway Business Suite Enablement - Service
          ls_e071_txt-text = ''.
          ls_e071_txt-name = ''.
          INSERT ls_e071_txt INTO TABLE ct_e071_txt.
        WHEN 'IWVB'. " SAP Gateway Business Suite Enablement -Vocabulary Annotation
          ls_e071_txt-text = ''.
          ls_e071_txt-name = ''.
          INSERT ls_e071_txt INTO TABLE ct_e071_txt.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.


  METHOD /mbtools/if_cts_req_display~get_object_icon.

    CASE iv_object.
      WHEN 'G4BA'. " SAP Gateway OData V4 Backend Service Group & Assigments
      WHEN 'G4BG'. " SAP Gateway OData V4 Backend Service Group & Assigments (obsolete)
      WHEN 'G4BS'. " SAP Gateway OData V4 Backend Service
      WHEN 'IWMO'. " SAP Gateway Business Suite Enablement - Model
      WHEN 'IWOM'. " SAP Gateway: Model Metadata
      WHEN 'IWPR'. " SAP Gateway BSE - Service Builder Project
      WHEN 'IWSG'. " SAP Gateway: Service Groups Metadata
      WHEN 'IWSV'. " SAP Gateway Business Suite Enablement - Service
      WHEN 'IWVB'. " SAP Gateway Business Suite Enablement -Vocabulary Annotation
      WHEN OTHERS.
        rv_icon = icon_dummy.
    ENDCASE.

  ENDMETHOD.


  METHOD class_constructor.

    DATA:
      ls_object_list LIKE LINE OF mt_object_list.

    ls_object_list-sign   = 'I'.
    ls_object_list-option = 'EQ'.

    ls_object_list-low = 'G4BA'. " SAP Gateway OData V4 Backend Service Group & Assigments
    APPEND ls_object_list TO mt_object_list.
    ls_object_list-low = 'G4BG'. " SAP Gateway OData V4 Backend Service Group & Assigments (obsolete)
    APPEND ls_object_list TO mt_object_list.
    ls_object_list-low = 'G4BS'. " SAP Gateway OData V4 Backend Service
    APPEND ls_object_list TO mt_object_list.
    ls_object_list-low = 'IWMO'. " SAP Gateway Business Suite Enablement - Model
    APPEND ls_object_list TO mt_object_list.
    ls_object_list-low = 'IWOM'. " SAP Gateway: Model Metadata
    APPEND ls_object_list TO mt_object_list.
    ls_object_list-low = 'IWPR'. " SAP Gateway BSE - Service Builder Project
    APPEND ls_object_list TO mt_object_list.
    ls_object_list-low = 'IWSG'. " SAP Gateway: Service Groups Metadata
    APPEND ls_object_list TO mt_object_list.
    ls_object_list-low = 'IWSV'. " SAP Gateway Business Suite Enablement - Service
    APPEND ls_object_list TO mt_object_list.
    ls_object_list-low = 'IWVB'. " SAP Gateway Business Suite Enablement -Vocabulary Annotation
    APPEND ls_object_list TO mt_object_list.

  ENDMETHOD.
ENDCLASS.
