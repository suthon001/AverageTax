
/// <summary>
/// PageExtension DSVC Avg. Purch CN Card (ID 70405) extends Record Purchase Credit Memo.
/// </summary>
pageextension 70405 "DSVC Avg. Purch CN Card" extends "Purchase Credit Memo"
{
    // actions
    // {
    //     addafter(Preview)
    //     {
    //         action("DSVC Split Average Tax")
    //         {
    //             Caption = 'Split Average Tax';
    //             ApplicationArea = all;
    //             Image = Splitlines;
    //             Promoted = true;
    //             PromotedCategory = Process;
    //             PromotedIsBig = true;
    //             PromotedOnly = true;
    //             ToolTip = 'Function Split Average Tax';
    //             trigger OnAction()
    //             var
    //                 AvgFunc: Codeunit "DSVC Avg. Funtions";
    //             begin
    //                 AvgFunc."DSVC Split AverageTax"(rec);
    //             end;
    //         }
    //     }
    // }
}