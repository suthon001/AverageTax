/// <summary>
/// PageExtension DSVC VatPurchase Entry (ID 70412) extends Record DSVC VAT Entries-Purchase.
/// </summary>
pageextension 70412 "DSVC VatPurchase Entry" extends "DSVC VAT Entries-Purchase"
{
    layout
    {
        addafter("DSVC Amount")
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
