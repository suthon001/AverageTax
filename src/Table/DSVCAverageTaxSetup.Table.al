table 70400 "DSVC Average Tax Setup"
{
    LookupPageId = "DSVC Average Tax Setup";
    DrillDownPageId = "DSVC Average Tax Setup";
    fields
    {
        field(70400; "DSVC Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(70401; "DSVC Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(70402; "DSVC Average %"; Decimal)
        {
            Caption = 'Average %';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK1; "DSVC Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "DSVC Code", "DSVC Description", "DSVC Average %") { }
    }
}