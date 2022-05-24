/// <summary>
/// PageExtension DSVC VatInfo (ID 70411) extends Record DSVC VAT Infomation.
/// </summary>
pageextension 70411 "DSVC VatInfo" extends "DSVC VAT Infomation"
{
    layout
    {
        addlast(General)
        {
            field("DSVC Average %"; rec."DSVC Average %")
            {
                ApplicationArea = all;
                ToolTip = 'Spacifies Average %';
            }
            field("DSVC Average Amount"; rec."DSVC Average Amount")
            {
                ApplicationArea = all;
                ToolTip = 'Spacifies Average %';
            }
        }
    }
}
