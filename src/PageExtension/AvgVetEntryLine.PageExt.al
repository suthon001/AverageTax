/// <summary>
/// PageExtension NCT Avg. VetEntry Line (ID 70402) extends Record VAT Entries.
/// </summary>
pageextension 70402 "NCT Avg. VetEntry Line" extends "VAT Entries"
{
    layout
    {
        addlast(Control1)
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