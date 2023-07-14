/// <summary>
/// PageExtension NCT VATPostingGroup (ID 70407).
/// </summary>
pageextension 70407 "NCT VATPostingGroup" extends "VAT Product Posting Groups"
{
    layout
    {
        addafter(Description)
        {
            field("NCT Average Tax"; rec."NCT Average Tax")
            {
                ApplicationArea = all;
                ToolTip = 'Spcifies Average Tax';
            }
        }
    }
}