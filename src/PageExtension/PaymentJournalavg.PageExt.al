/// <summary>
/// PageExtension NCT PaymentJournal avg (ID 70408) extends Record Payment Journal.
/// </summary>
pageextension 70408 "NCT PaymentJournal avg" extends "Payment Journal"
{
    layout
    {
        addafter(Description)
        {
            field("NCT Average Tax Code"; rec."NCT Average Tax Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the Code of the Average Tax Entry';
            }
            field("NCT Average %"; rec."NCT Average %")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the Average % of the Average Tax Entry';
            }
            field("NCT Average Amount"; rec."NCT Average Amount")
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
            action("NCT Preview")
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
                    AvgFunc."NCT Split AverageTaxgenjournal"(rec);
                end;
            }
        }

    }
}
