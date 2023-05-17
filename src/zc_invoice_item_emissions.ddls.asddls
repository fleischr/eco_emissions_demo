@EndUserText.label: 'Consumption - invoice item emissions'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_INVOICE_ITEM_EMISSIONS as projection on ZI_INVOICE_ITEM_EMISSIONS
{
    key SupplierInvoice,
    key SupplierInvoiceItem,
    PurchaseOrder,
    PurchaseOrderItem,
    QuantityUnit,
    @Semantics.quantity.unitOfMeasure: 'QuantityUnit'
    Quantity,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    GrossAmountInTransacCurrency,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    NetAmountInTransactionCurrency,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    TaxAmountInTransactionCurrency,
    TransactionCurrency,
    Product,
    InvoiceItemID,
    CarbonAmount,
    CarbonUom,
    OrderDate,
    BackorderDate,
    ShuttleURL,
    /* Associations */
    _Emissions,
    _Product,
    _PurchaseOrder,
    _PurchaseOrderItem,
    _QuantityUnit,
    _SupplierInvoice,
    _TransactionCurrency
}
