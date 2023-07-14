/// <summary>
/// TableExtension NCT Avg. PurchaseInvoiceLine (ID 70401) extends Record Purch. Inv. Line.
/// </summary>
tableextension 70401 "NCT Avg. PurchaseInvoiceLine" extends "Purch. Inv. Line"
{
    fields
    {
        field(70400; "NCT Average Tax Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "NCT Average Tax Setup"."NCT Code";
            Caption = 'Average Tax Code';

        }
        field(70401; "NCT Average %"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Average %';

        }
        field(70402; "NCT Average Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Average Amount';
            Editable = false;
        }
        field(70403; "NCT Tax Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Tax Amount';
            Editable = false;
        }
        field(70404; "NCT Split Average Tax"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Split Average Tax';
            Editable = false;
        }
    }
}