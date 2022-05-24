/// <summary>
/// TableExtension DSVC Avg. PurchaseInvoiceLine (ID 70401) extends Record Purch. Inv. Line.
/// </summary>
tableextension 70401 "DSVC Avg. PurchaseInvoiceLine" extends "Purch. Inv. Line"
{
    fields
    {
        field(70400; "DSVC Average Tax Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "DSVC Average Tax Setup"."DSVC Code";
            Caption = 'Average Tax Code';

        }
        field(70401; "DSVC Average %"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Average %';

        }
        field(70402; "DSVC Average Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Average Amount';
            Editable = false;
        }
        field(70403; "DSVC Tax Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Tax Amount';
            Editable = false;
        }
        field(70404; "DSVC Split Average Tax"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Split Average Tax';
            Editable = false;
        }
    }
}