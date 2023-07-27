CLASS zcl_prvd_eco_emissions_demo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS:
      constructor IMPORTING iv_tenant type zprvdtenantid
                            iv_workgroup type zprvdtenantid
                            iv_subj_acct type zprvdtenantid,
      create_sepm_emissions,
      delete_sepm_emissions,
      trigger_emissions_proof IMPORTING is_invoice_item_emissions TYPE zif_prvd_eco_emissions_demo=>ty_invoice_item_emissions
                                        io_api_helper             TYPE REF TO zcl_prvd_api_helper OPTIONAL,
      offset_emissions,
      tokenize_emissions,
      pay_invoice_digitally.
  PROTECTED SECTION.
    DATA: mv_tenant       TYPE zprvdtenantid,
          mv_subj_acct    TYPE zprvdtenantid,
          mv_workgroup_id TYPE zprvdtenantid,
          mcl_prvd_eco_ca_201x   TYPE REF TO zcl_prvd_eco_ca_201x,
          mcl_prvd_eco_cr_3030   TYPE REF TO zcl_prvd_eco_cr_3030,
          mcl_prvd_eco_ao_4010   TYPE REF TO zcl_prvd_eco_ao_4010,
          mcl_prvd_eco_poao_4200 TYPE REF TO zcl_prvd_eco_poao_4200.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_prvd_eco_emissions_demo IMPLEMENTATION.
  METHOD constructor.
    mv_tenant = iv_tenant.
    mv_subj_acct = iv_subj_acct.
    mv_workgroup_id = iv_workgroup.
    mcl_prvd_eco_ca_201x = NEW zcl_prvd_eco_ca_201x( ).
    mcl_prvd_eco_cr_3030 = NEW zcl_prvd_eco_cr_3030( ).
    mcl_prvd_eco_ao_4010 = NEW zcl_prvd_eco_ao_4010( ).
    mcl_prvd_eco_poao_4200 = NEW zcl_prvd_eco_poao_4200( ).
  ENDMETHOD.
  METHOD create_sepm_emissions.
    DATA: lcl_emissions_data_gen  TYPE REF TO zcl_prvd_eco_demo_cemit,
          ls_sepm_carbon_emission TYPE zif_prvd_eco_ca_2010=>ty_carbon_aggregate_ca2010,
          lt_sepm_carbon_emission TYPE zif_prvd_eco_ca_2010=>ty_carbon_aggr_ca2010_list,
          lv_id                   TYPE string.

    lcl_emissions_data_gen = NEW zcl_prvd_eco_demo_cemit( ).
    delete_sepm_emissions( ).
    SELECT * FROM SEPM_I_SupplierInvoiceItem_E INTO TABLE @DATA(lt_supplierinvoice_item).
    IF sy-subrc <> 0.
    ENDIF.
    LOOP AT lt_supplierinvoice_item ASSIGNING FIELD-SYMBOL(<fs_supplierinvoice_item>).
      CLEAR: ls_sepm_carbon_emission, lv_id.
      lv_id = <fs_supplierinvoice_item>-SupplierInvoice && '.' && <fs_supplierinvoice_item>-SupplierInvoiceItem.
      ls_sepm_carbon_emission-aggregate_id = lv_id.
      ls_sepm_carbon_emission-carbon_amount = '0.002'.
      ls_sepm_carbon_emission-carbon_uom = 'MT'.
      ls_sepm_carbon_emission-objid = 'SEPMINVITM'.
      ls_sepm_carbon_emission-objnr = lv_id.
      lcl_emissions_data_gen->zif_prvd_eco_ca_2010~create( is_carbon_aggregate = ls_sepm_carbon_emission ).
    ENDLOOP.

  ENDMETHOD.
  METHOD delete_sepm_emissions.
    DELETE FROM zprvdeco2010 WHERE objid = 'SEPMINVITM'.
    IF sy-subrc <> 0.
    ENDIF.
  ENDMETHOD.

  METHOD trigger_emissions_proof.
    DATA: lcl_prvd_api_helper     TYPE REF TO zcl_prvd_api_helper,
          ls_emissions_proof_data TYPE REF TO data,
          ls_protocol_msg_req     TYPE zif_prvd_baseline=>protocolmessage_req,
          ls_protocol_msg_resp    TYPE zif_prvd_baseline=>protocolmessage_resp,
          lv_status               TYPE i,
          lv_apiresponse          TYPE REF TO data,
          lv_apiresponsestr       TYPE string.

    IF io_api_helper IS NOT INITIAL.
      lcl_prvd_api_helper = io_api_helper.
    ELSE.
      lcl_prvd_api_helper = NEW zcl_prvd_api_helper(   iv_tenant = mv_tenant
                                                       iv_subject_acct_id = mv_subj_acct
                                                       iv_workgroup_id = mv_workgroup_id ).
    ENDIF.

    lcl_prvd_api_helper->setup_protocol_msg( ).

    GET REFERENCE OF is_invoice_item_emissions INTO ls_emissions_proof_data.

    "request to /api/v1/protocol_messages
    ls_protocol_msg_req-payload = ls_emissions_proof_data.
    ls_protocol_msg_req-payload_mimetype = 'json'.
    ls_protocol_msg_req-type = 'InvoiceItemEmissions'.

    ls_protocol_msg_req-id = is_invoice_item_emissions-invoice_item_id .

    lcl_prvd_api_helper->send_protocol_msg( EXPORTING is_body           = ls_protocol_msg_req
                                           IMPORTING ev_statuscode     = lv_status
                                                     ev_apiresponse    = lv_apiresponse
                                                     ev_apiresponsestr = lv_apiresponsestr ).
    CASE lv_status.
      WHEN '202'.
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.

  method offset_emissions.
  ENDMETHOD.

  method tokenize_emissions.
  ENDMETHOD.

  method pay_invoice_digitally.
  ENDMETHOD.
ENDCLASS.
