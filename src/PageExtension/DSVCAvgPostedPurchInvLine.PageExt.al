/// <summary>
/// PageExtension DSVC AvgPostedPurchInv.Line (ID 70401) extends Record Posted Purch. Invoice Subform.
/// </summary>
pageextension 70401 "DSVC AvgPostedPurchInv.Line" extends "Posted Purch. Invoice Subform"
{
    layout
    {
        addafter(Description)
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
        }
    }
}