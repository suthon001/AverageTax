/// <summary>
/// PageExtension DSVC Avg. VetEntry Line (ID 70402) extends Record VAT Entries.
/// </summary>
pageextension 70402 "DSVC Avg. VetEntry Line" extends "VAT Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("DSVC Average Tax Code"; rec."DSVC Average Tax Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the Code of the Average Tax Entry';
            }
            field("DSVC Average %"; rec."DSVC Average %")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the Average % of the Average Tax Entry';
            }
            field("DSVC Average Amount"; rec."DSVC Average Amount")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the Average Amount of the Average Tax Entry';
            }
            field("DSVC Tax Amount"; rec."DSVC Tax Amount")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the Average Amount of the Tax Amount Entry';
            }
        }
    }
}