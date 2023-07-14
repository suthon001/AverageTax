tableextension 70407 "NCT Avg. VAT Transections" extends "NCT VAT Transections"
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

        field(70403; "NCT Average Tax"; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Average Tax';
            Editable = false;
        }

    }
}