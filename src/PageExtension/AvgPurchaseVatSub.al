pageextension 70411 "NCT Avg. Purchase Vat Sub" extends "NCT Purchase Vat Subpage"
{
    layout
    {
        addlast(General)
        {
            field("NCT Average %"; rec."NCT Average %")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Average % field.';
            }
            field("NCT Average Amount"; rec."NCT Average Amount")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Average Amount field.';
            }
            field("NCT Average Tax Code"; rec."NCT Average Tax Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Average Tax Code field.';
            }
        }
    }
}
