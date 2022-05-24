tableextension 70404 "DSVC Avg.Invoice Buffer" extends "Invoice Post. Buffer"
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
        field(70405; "DSVC From Purchase"; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'From Purchase';
            Editable = false;
        }
    }
}