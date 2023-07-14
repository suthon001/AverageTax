page 70400 "NCT Average Tax Setup"
{
    PageType = list;
    SourceTable = "NCT Average Tax Setup";
    SourceTableView = sorting("NCT Code");
    ApplicationArea = all;
    UsageCategory = Administration;
    Caption = 'Average Tax Setup';
    layout
    {
        area(Content)
        {
            repeater("NCT Lines")
            {
                ShowCaption = false;
                field("NCT Code"; rec."NCT Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Code of the Average Tax Entry';
                }
                field("NCT Description"; rec."NCT Description")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Description of the Average Tax Entry';
                }
                field("NCT Average %"; rec."NCT Average %")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Average % of the Average Tax Entry';
                }
            }
        }
    }
}