tableextension 70404 "NCT Avg.Invoice Buffer" extends "Invoice Post. Buffer"
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
        field(70404; "NCT Average Tax"; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Average Tax';
            Editable = false;
        }
        field(70405; "NCT From Purchase"; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'From Purchase';
            Editable = false;
        }
    }
}