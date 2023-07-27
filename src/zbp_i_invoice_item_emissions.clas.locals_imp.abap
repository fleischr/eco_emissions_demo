CLASS lhc_ZI_INVOICE_ITEM_EMISSIONS DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_invoice_item_emissions RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_invoice_item_emissions RESULT result.

    METHODS verifyCarbonEmissions FOR MODIFY
      IMPORTING keys FOR ACTION zi_invoice_item_emissions~verifyCarbonEmissions RESULT result.

    METHODS offsetCarbonEmissions FOR MODIFY
      IMPORTING keys FOR ACTION zi_invoice_item_emissions~offsetCarbonEmissions RESULT result.

ENDCLASS.

CLASS lhc_ZI_INVOICE_ITEM_EMISSIONS IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD verifyCarbonEmissions.
    DATA: lcl_carbon_emissions_helper TYPE REF TO zcl_prvd_eco_emissions_demo,
          ls_invoice_item_emission    TYPE zif_prvd_eco_emissions_demo=>ty_invoice_item_emissions.

    lcl_carbon_emissions_helper = NEW zcl_prvd_eco_emissions_demo( ).

    READ TABLE keys ASSIGNING FIELD-SYMBOL(<fs_keys>) INDEX 1.
    IF sy-subrc = 0.
*      lv_carrid = <fs_keys>-CarrierID.
*      lv_connid = <fs_keys>-ConnectionID.
*      lv_fldat  = <fs_keys>-FlightDate.
*       ls_invoice_item_emission-emissions_amount = <fs_keys>-
    ELSE.
      "todo handle error
    ENDIF.

    READ ENTITIES OF zi_invoice_item_emissions IN LOCAL MODE
      ENTITY zi_invoice_item_emissions
      ALL FIELDS WITH
      CORRESPONDING #( keys )
      RESULT DATA(invitems).

    result = VALUE #( FOR item IN invitems
             ( %tky   = item-%tky
               %param = item ) ).

    READ TABLE invitems ASSIGNING FIELD-SYMBOL(<fs_item_emission>) INDEX 1.
    IF sy-subrc <> 0.
    ELSE.
      ls_invoice_item_emission-emissions_amount = <fs_item_emission>-CarbonAmount.
      ls_invoice_item_emission-emissions_from_date = <fs_item_emission>-BackorderDate.
      ls_invoice_item_emission-emissions_to_date = <fs_item_emission>-OrderDate.
      ls_invoice_item_emission-emissions_uom = <fs_item_emission>-CarbonUom.
      ls_invoice_item_emission-invoice = <fs_item_emission>-SupplierInvoice.
      ls_invoice_item_emission-invoice_item = <fs_item_emission>-SupplierInvoiceItem.
      ls_invoice_item_emission-invoice_item_id = <fs_item_emission>-InvoiceItemID.
      ls_invoice_item_emission-price = <fs_item_emission>-GrossAmountInTransacCurrency.
      ls_invoice_item_emission-quantity = <fs_item_emission>-Quantity.
      ls_invoice_item_emission-quantity_uom = <fs_item_emission>-QuantityUnit.
      lcl_carbon_emissions_helper->trigger_emissions_proof( ls_invoice_item_emission ).
    ENDIF.




*    READ ENTITIES OF zi_invoice_item_emissions IN LOCAL MODE
*      ENTITY zi_invoice_item_emissions
*      ALL FIELDS WITH
*      CORRESPONDING #( keys )
*      RESULT DATA(invitems).
*
*    result = VALUE #( FOR item IN invitems
*             ( %tky   = item-%tky
*               %param = item ) ).
  ENDMETHOD.

  method offsetCarbonEmissions.
  ENDMETHOD.

ENDCLASS.
