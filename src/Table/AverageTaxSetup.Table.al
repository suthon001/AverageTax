table 70400 "NCT Average Tax Setup"
{
    LookupPageId = "NCT Average Tax Setup";
    DrillDownPageId = "NCT Average Tax Setup";
    fields
    {
        field(70400; "NCT Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(70401; "NCT Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(70402; "NCT Average %"; Decimal)
        {
            Caption = 'Average %';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK1; "NCT Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "NCT Code", "NCT Description", "NCT Average %") { }
    }
}