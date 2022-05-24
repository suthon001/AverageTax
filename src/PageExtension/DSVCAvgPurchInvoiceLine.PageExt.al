/// <summary>
/// PageExtension DSVC Avg. Purch. Invoice Line (ID 70400) extends Record Purch. Invoice Subform.
/// </summary>
pageextension 70400 "DSVC Avg. Purch. Invoice Line" extends "Purch. Invoice Subform"
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
        DSVCcalaverageTax();
    end;

    local procedure "DSVCcalaverageTax"()
    begin
        if not Currency.GET(PurchaseHeader."Currency Code") then
            Currency.init();
        PurchaseLines.reset();
        PurchaseLines.setrange("Document Type", rec."Document Type");
        PurchaseLines.setrange("Document No.", rec."Document No.");
        PurchaseLines.SetRange("DSVC Split Average Tax", false);
        if PurchaseLines.FindFirst() then begin
            PurchaseLines.calcsums("DSVC Average Amount", Amount, "Amount Including VAT");
            AverageText := PurchaseLines."DSVC Average Amount";
            OriginalVat := PurchaseLines."Amount Including VAT" - PurchaseLines.Amount - PurchaseLines."DSVC Average Amount";
        end;
    end;

    var
        Currency: Record Currency;
        PurchaseHeader: Record "Purchase Header";
        PurchaseLines: record "Purchase Line";
        AverageText, OriginalVat : Decimal;

}