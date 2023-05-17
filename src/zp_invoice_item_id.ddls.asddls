@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Item ID'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zp_invoice_item_id with parameters p_invoice : snwd_po_id, 
                                                      p_item : snwd_po_item_pos
                                                       as select from ZI_PRVD_ECO_CA_2010
{
    key AggregateId,
    ObjectID,
    ObjectType,
    CarbonAmount,
    CarbonUom
} where ObjectID = concat($parameters.p_invoice, concat('.', $parameters.p_item))
