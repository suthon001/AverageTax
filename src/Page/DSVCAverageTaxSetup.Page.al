page 70400 "DSVC Average Tax Setup"
{
    PageType = list;
    SourceTable = "DSVC Average Tax Setup";
    SourceTableView = sorting("DSVC Code");
    ApplicationArea = all;
    UsageCategory = Administration;
    Caption = 'Average Tax Setup';
    layout
    {
        area(Content)
        {
            repeater("DSVC Lines")
            {
                ShowCaption = false;
                field("DSVC Code"; rec."DSVC Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Code of the Average Tax Entry';
                }
                field("DSVC Description"; rec."DSVC Description")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Description of the Average Tax Entry';
                }
                field("DSVC Average %"; rec."DSVC Average %")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Average % of the Average Tax Entry';
                }
            }
        }
    }
}