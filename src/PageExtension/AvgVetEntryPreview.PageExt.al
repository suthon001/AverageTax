/// <summary>
/// PageExtension NCT Avg. VetEntry Preview (ID 70403) extends Record VAT Entries Preview.
/// </summary>
pageextension 70403 "NCT Avg. VetEntry Preview" extends "VAT Entries Preview"
{
    layout
    {
        addafter(Amount)
        {

            field("NCT Average %"; rec."NCT Average %")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the Average % of the Average Tax Entry';
                Editable = false;
            }
            field("NCT Average Amount"; rec."NCT Average Amount")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the Average Amount of the Average Tax Entry';
                Editable = false;
            }

        }
    }
}