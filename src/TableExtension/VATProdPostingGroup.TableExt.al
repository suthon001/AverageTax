/// <summary>
/// TableExtension NCT VATProdPostingGroup (ID 70405).
/// </summary>
tableextension 70405 "NCT VATProdPostingGroup" extends "VAT Product Posting Group"
{
    fields
    {
        field(74000; "NCT Average Tax"; Boolean)
        {
            Caption = 'Average Tax';
            DataClassification = CustomerContent;
        }
    }
}