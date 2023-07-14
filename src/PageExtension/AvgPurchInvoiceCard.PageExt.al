/// <summary>
/// PageExtension NCT Avg. Purch Invoice Card (ID 70404) extends Record Purchase Invoice.
/// </summary>
pageextension 70404 "NCT Avg. Purch Invoice Card" extends "Purchase Invoice"
{
    actions
    {
        addafter(Preview)
        {
            action("NCT Split Average Tax")
            {
                Caption = 'Split Average Tax';
                ApplicationArea = all;
                Image = Splitlines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Function Split Average Tax';
                trigger OnAction()
                var
                    AvgFunc: Codeunit "NCT Avg. Funtions";
                begin
                    AvgFunc."NCT Split AverageTax"(rec);
                end;
            }
        }
    }
}