/// <summary>
/// TableExtension DSVC VATProdPostingGroup (ID 70405).
/// </summary>
tableextension 70405 "DSVC VATProdPostingGroup" extends "VAT Product Posting Group"
{
    fields
    {
        field(74000; "DSVC Average Tax"; Boolean)
        {
            Caption = 'Average Tax';
            DataClassification = CustomerContent;
        }
    }
}