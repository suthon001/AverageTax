/// <summary>
/// PageExtension DSVC Avg. Purch Invoice Card (ID 70404) extends Record Purchase Invoice.
/// </summary>
pageextension 70404 "DSVC Avg. Purch Invoice Card" extends "Purchase Invoice"
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