
/// <summary>
/// PageExtension DSVC CashReceiptJournal avg (ID 70409) extends Record Cash Receipt Journal.
/// </summary>
pageextension 70409 "DSVC CashReceiptJournal avg" extends "Cash Receipt Journal"
{
    layout
    {
        addafter(Description)
        {
            field("DSVC Average Tax Code"; rec."DSVC Average Tax Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the Code of the Average Tax Entry';
            }
            field("DSVC Average %"; rec."DSVC Average %")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the Average % of the Average Tax Entry';
            }
            field("DSVC Average Amount"; rec."DSVC Average Amount")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the Average Amount of the Average Tax Entry';
            }
        }
    }
    actions
    {
        addafter(Preview)
        {
            action(DSVCPreview)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Preview Posting';
                Image = ViewPostedOrder;
                Promoted = true;
                PromotedCategory = Category8;
                ShortCutKey = 'Ctrl+Alt+F9';
                ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';

                trigger OnAction()
                var
                    ltGenjournalLine: Record "Gen. Journal Line";
                    GenJnlPost: Codeunit "Gen. Jnl.-Post";

                begin
                    ltGenjournalLine.reset();
                    ltGenjournalLine.SetRange("Journal Template Name", rec."Journal Template Name");
                    ltGenjournalLine.SetRange("Journal Batch Name", rec."Journal Batch Name");
                    ltGenjournalLine.SetRange("Document No.", rec."Document No.");
                    if ltGenjournalLine.FindFirst() then
                        GenJnlPost.Preview(ltGenjournalLine);
                end;
            }
        }
        modify(Preview)
        {
            Visible = false;
        }
    }
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
    //                 AvgFunc."DSVC Split AverageTaxgenjournal"(rec);
    //             end;
    //         }
    //     }
    // }
}
