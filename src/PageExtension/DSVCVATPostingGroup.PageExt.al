/// <summary>
/// PageExtension DSVC VATPostingGroup (ID 70407).
/// </summary>
pageextension 70407 "DSVC VATPostingGroup" extends "VAT Product Posting Groups"
{
    layout
    {
        addafter(Description)
        {
            field("DSVC Average Tax"; rec."DSVC Average Tax")
            {
                ApplicationArea = all;
                ToolTip = 'Spcifies Average Tax';
            }
        }
    }
}