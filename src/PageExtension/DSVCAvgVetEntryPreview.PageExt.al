/// <summary>
/// PageExtension DSVC Avg. VetEntry Preview (ID 70403) extends Record VAT Entries Preview.
/// </summary>
pageextension 70403 "DSVC Avg. VetEntry Preview" extends "VAT Entries Preview"
{
    layout
    {
        addafter(Amount)
        {

            field("DSVC Average %"; rec."DSVC Average %")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the Average % of the Average Tax Entry';
                Editable = false;
            }
            field("DSVC Average Amount"; rec."DSVC Average Amount")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the Average Amount of the Average Tax Entry';
                Editable = false;
            }

        }
    }
}