/// <summary>
/// PageExtension NCT AvgPostedPurchInv.Line (ID 70401) extends Record Posted Purch. Invoice Subform.
/// </summary>
pageextension 70401 "NCT AvgPostedPurchInv.Line" extends "Posted Purch. Invoice Subform"
{
    layout
    {
        addafter(Description)
        {
            field("NCT Average Tax Code"; rec."NCT Average Tax Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the Code of the Average Tax Entry';
            }
            field("NCT Average %"; rec."NCT Average %")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the Average % of the Average Tax Entry';
            }
            field("NCT Average Amount"; rec."NCT Average Amount")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the Average Amount of the Average Tax Entry';
            }
        }
    }
}