/// <summary>
/// TableExtension DSVC Avg. VatEntry (ID 70402) extends Record VAT Entry.
/// </summary>
tableextension 70402 "DSVC Avg. VatEntry" extends "VAT Entry"
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
        field(70404; "DSVC Average Tax"; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Average Tax';
            Editable = false;
        }

    }
}