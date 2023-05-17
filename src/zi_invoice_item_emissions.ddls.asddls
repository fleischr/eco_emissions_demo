@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice item emissions'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_INVOICE_ITEM_EMISSIONS 
  as select from    SEPM_I_SupplierInvoiceItem as SII
    left outer join SEPM_I_SupplierInvoice     as SI   on SI.SupplierInvoiceUUID = SII.SupplierInvoiceUUID
    left outer join SEPM_I_PurchaseOrderItem   as POI  on POI.PurchaseOrderItemUUID = SII.PurchaseOrderItemUUID
    left outer join SEPM_I_PurchaseOrder       as PO   on PO.PurchaseOrderUUID = POI.PurchaseOrderUUID
    left outer join SEPM_I_Product             as PROD on PROD.ProductUUID = SII.ProductUUID
    left outer join ZI_PRVD_ECO_CA_2010 as Emissions on Emissions.AggregateId = concat(PO.PurchaseOrder, concat('.', SII.SupplierInvoiceItem)) and Emissions.ObjectType = 'SEPMINVITM'
    //left outer join zp_invoice_item_id( p_invoice :  )         
    //left outer join zprvdeco2010               as Emissions on ZI_INVOICE_ITEM_EMISSIONS.InvoiceItemGUID = Emissions.objnr and Emissions.objid = 'SEPMINVITM'                
    
  association [0..1] to SEPM_I_SupplierInvoice_E   as _SupplierInvoice   on  $projection.SupplierInvoice = _SupplierInvoice.SupplierInvoice
  association [0..1] to SEPM_I_PurchaseOrder_E     as _PurchaseOrder     on  $projection.PurchaseOrder = _PurchaseOrder.PurchaseOrder
  association [0..1] to SEPM_I_PurchaseOrderItem_E as _PurchaseOrderItem on  $projection.PurchaseOrder     = _PurchaseOrderItem.PurchaseOrder
                                                                         and $projection.PurchaseOrderItem = _PurchaseOrderItem.PurchaseOrderItem
  association [0..1] to SEPM_I_Product_E           as _Product           on  $projection.Product = _Product.Product
  association [0..1] to ZI_PRVD_ECO_CA_2010 as _Emissions on $projection.InvoiceItemID = _Emissions.AggregateId and _Emissions.ObjectType = 'SEPMINVITM'
{
  key PO.PurchaseOrder as SupplierInvoice,
  key SII.SupplierInvoiceItem,
      PO.PurchaseOrder,
      POI.PurchaseOrderItem,
      SII.QuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'QuantityUnit'
      SII.Quantity,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      SII.GrossAmountInTransacCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      SII.NetAmountInTransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      SII.TaxAmountInTransactionCurrency,
      SII.TransactionCurrency,
      PROD.Product,
      SII._TransactionCurrency,
      SII._QuantityUnit,
      concat(PO.PurchaseOrder, concat('.', SII.SupplierInvoiceItem)) as InvoiceItemID,
      cast('05162023' as abap.char( 8 )) as OrderDate,
      cast('03012023' as abap.char( 8 )) as BackorderDate,
      cast('https://shuttle.provide.services/workgroups/a44cd947-5dff-4a67-a5d3-c0601db649ff/participants' as abap.char( 500 )) as ShuttleURL,
      //TSTMP_TO_DATS( PO.CreationDateTime, abap_system_timezone( $session.client,'NULL' ), $session.client, 'NULL' ) as OrderDate,
      //cast(SII.PurchaseOrderItemUUID as abap.char( 24 )) as InvoiceItemGUID,
      Emissions.CarbonAmount,
      Emissions.CarbonUom,
       
       //@ObjectModel.association.type:  [ #TO_COMPOSITION_PARENT, #TO_COMPOSITION_ROOT ]
      _SupplierInvoice,
      _PurchaseOrder,
      _PurchaseOrderItem,
      _Product,
      _Emissions
}
