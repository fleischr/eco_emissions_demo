INTERFACE zif_prvd_eco_emissions_demo
  PUBLIC .

  types: BEGIN OF ty_invoice_item_emissions,
            invoice_item_id type string,
            invoice type string,
            invoice_item type string,
            product type string,
            quantity type i,
            quantity_uom type string,
            price type p LENGTH 16 DECIMALS 2,
            price_currency type string,
            emissions_amount type zprvd_eco_demo_carbontonne,
            emissions_uom type string,
            emissions_from_date type string,
            emissions_to_date type string,
            invoice_date type string,
         end of ty_invoice_item_emissions.

  types: BEGIN OF ty_vm0017,
            be type zprvd_eco_demo_carbontonne,
            bef type zprvd_eco_demo_carbontonne,
            beff type zprvd_eco_demo_carbontonne,
            bebb type zprvd_eco_demo_carbontonne,
            brwp type zprvd_eco_demo_carbontonne,
            fromdate type string,
            todate type string,
            serial type string,
            PE type zprvd_eco_demo_carbontonne,
            PEN type zprvd_eco_demo_carbontonne,
            PEF type zprvd_eco_demo_carbontonne,
            PEFF type zprvd_eco_demo_carbontonne,
            PEBB type zprvd_eco_demo_carbontonne,
            PRWP type zprvd_eco_demo_carbontonne,
            PRS type zprvd_eco_demo_carbontonne,
            LHE type zprvd_eco_demo_carbontonne,
         end of ty_vm0017.

ENDINTERFACE.
