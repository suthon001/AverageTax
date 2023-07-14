
/// <summary>
/// PageExtension NCT Avg. Purch. CN Line (ID 70406) extends Record Purch. Cr. Memo Subform.
/// </summary>
pageextension 70406 "NCT Avg. Purch. CN Line" extends "Purch. Cr. Memo Subform"
{
    layout
    {
        addafter(Description)
        {
            field("NCT Average Tax Codeๅจ"; rec."NCT Average Tax Code")
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
        addafter("Invoice Disc. Pct.")
        {
            field(AverageText; AverageText)
            {
                Caption = 'Average Tax';
                Editable = false;
                ToolTip = 'Total Average Tax';
                ApplicationArea = all;
            }
            field(OriginalVat; OriginalVat)
            {
                Caption = 'Total Vat';
                Editable = false;
                ToolTip = 'Total Average Tax';
                ApplicationArea = all;
                // CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption('Total Vat', Currency.Code);
            }
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                CurrPage.Update();
            end;
        }
        modify("Direct Unit Cost")
        {
            trigger OnAfterValidate()
            begin
                CurrPage.Update();
            end;
        }
        modify("Line Discount %")
        {
            trigger OnAfterValidate()
            begin
                CurrPage.Update();
            end;
        }
    }
    trigger OnAfterGetRecord()
    begin
        "NCT calaverageTax"();
    end;

    local procedure "NCT calaverageTax"()
    begin
        if not Currency.GET(PurchaseHeader."Currency Code") then
            Currency.init();
        PurchaseLines.reset();
        PurchaseLines.setrange("Document Type", rec."Document Type");
        PurchaseLines.setrange("Document No.", rec."Document No.");
        PurchaseLines.SetRange("NCT Split Average Tax", false);
        if PurchaseLines.FindFirst() then begin
            PurchaseLines.calcsums("NCT Average Amount", Amount, "Amount Including VAT");
            AverageText := PurchaseLines."NCT Average Amount";
            OriginalVat := PurchaseLines."Amount Including VAT" - PurchaseLines.Amount - PurchaseLines."NCT Average Amount";
        end;
    end;

    var
        Currency: Record Currency;
        PurchaseHeader: Record "Purchase Header";
        PurchaseLines: record "Purchase Line";
        AverageText, OriginalVat : Decimal;

}