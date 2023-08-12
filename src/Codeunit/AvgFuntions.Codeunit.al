/// <summary>
/// Codeunit NCT Avg. Funtions (ID 70400).
/// </summary>
codeunit 70400 "NCT Avg. Funtions"
{
    EventSubscriberInstance = StaticAutomatic;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnSumPurchLines2OnAfterSetFilters', '', false, false)]
    local procedure DSVCOnSumPurchLines2OnAfterSetFilters(var PurchaseLine: Record "Purchase Line")
    begin
        PurchaseLine.SetRange("NCT Split Average Tax", false);
    end;

    [EventSubscriber(ObjectType::Table, database::"NCT Tax & WHT Line", 'OnBeforeInsertVatLine', '', false, false)]
    local procedure OnBeforeInsertVatLine(var TaxReportLine: Record "NCT Tax & WHT Line"; VatTransaction: Record "NCT VAT Transections")
    begin
        TaxReportLine."NCT Average %" := VatTransaction."NCT Average %";
        TaxReportLine."NCT Average Amount" := VatTransaction."NCT Average Amount";
        TaxReportLine."NCT Average Tax" := VatTransaction."NCT Average Tax";
        TaxReportLine."NCT Average Tax Code" := VatTransaction."NCT Average Tax Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document Totals", 'OnAfterCalculatePurchaseSubPageTotals', '', false, false)]
    local procedure DSVCOnAfterCalculatePurchaseSubPageTotals(var TotalPurchHeader: Record "Purchase Header"; var TotalPurchLine: Record "Purchase Line"; var TotalPurchaseLine2: Record "Purchase Line"; var VATAmount: Decimal)
    var
        PurchaseLines: Record "Purchase Line";
    begin
        PurchaseLines.reset();
        PurchaseLines.setrange("Document Type", TotalPurchHeader."Document Type");
        PurchaseLines.setrange("Document No.", TotalPurchHeader."No.");
        PurchaseLines.SetRange("NCT Split Average Tax", false);
        if PurchaseLines.FindFirst() then begin
            PurchaseLines.calcsums("NCT Average Amount", Amount, "Amount Including VAT", "Line Amount");
            VATAmount := PurchaseLines."Amount Including VAT" - PurchaseLines.Amount;
            TotalPurchaseLine2."Line Amount" := PurchaseLines."Line Amount";
            TotalPurchaseLine2.Amount := PurchaseLines.Amount;
            TotalPurchaseLine2."Amount Including VAT" := PurchaseLines."Amount Including VAT";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document Totals", 'OnAfterPurchDeltaUpdateTotals', '', false, false)]
    local procedure DSVCOnAfterPurchDeltaUpdateTotals(var VATAmount: Decimal; var PurchaseLine: Record "Purchase Line"; var TotalPurchaseLine: Record "Purchase Line")
    var
        PurchaseLines: Record "Purchase Line";
    begin
        PurchaseLines.reset();
        PurchaseLines.setrange("Document Type", PurchaseLine."Document Type");
        PurchaseLines.setrange("Document No.", PurchaseLine."Document No.");
        PurchaseLines.SetRange("NCT Split Average Tax", false);
        if PurchaseLines.FindFirst() then begin
            PurchaseLines.calcsums("NCT Average Amount", Amount, "Amount Including VAT", "Line Amount");
            VATAmount := PurchaseLines."Amount Including VAT" - PurchaseLines.Amount;
            TotalPurchaseLine."Line Amount" := PurchaseLines."Line Amount";
            TotalPurchaseLine.Amount := PurchaseLines.Amount;
            TotalPurchaseLine."Amount Including VAT" := PurchaseLines."Amount Including VAT";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterInvPostBufferPreparePurchase', '', false, false)]
    local procedure DSVCOnAfterInvPostBufferPreparePurchase(var InvoicePostBuffer: Record "Invoice Post. Buffer"; var PurchaseLine: Record "Purchase Line")
    begin

        InvoicePostBuffer."NCT Average Tax Code" := PurchaseLine."NCT Average Tax Code";
        InvoicePostBuffer."NCT Average %" := PurchaseLine."NCT Average %";

        if PurchaseLine."Document Type" = PurchaseLine."Document Type"::"Credit Memo" then begin
            InvoicePostBuffer."NCT Tax Amount" := PurchaseLine."NCT Tax Amount" * -1;
            InvoicePostBuffer."NCT Average Amount" := PurchaseLine."NCT Average Amount" * -1;
        end else begin
            InvoicePostBuffer."NCT Tax Amount" := PurchaseLine."NCT Tax Amount";
            InvoicePostBuffer."NCT Average Amount" := PurchaseLine."NCT Average Amount";
        end;
        InvoicePostBuffer."NCT Average Tax" := PurchaseLine."NCT Average Tax Code" <> '';
        InvoicePostBuffer."NCT From Purchase" := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Invoice Posting Buffer", 'OnAfterPreparePurchase', '', false, false)]
    local procedure OnAfterPreparePurchase(var InvoicePostingBuffer: Record "Invoice Posting Buffer" temporary; var PurchaseLine: Record "Purchase Line")
    begin

        InvoicePostingBuffer."NCT Average Tax Code" := PurchaseLine."NCT Average Tax Code";
        InvoicePostingBuffer."NCT Average %" := PurchaseLine."NCT Average %";

        if PurchaseLine."Document Type" = PurchaseLine."Document Type"::"Credit Memo" then begin
            InvoicePostingBuffer."NCT Tax Amount" := PurchaseLine."NCT Tax Amount" * -1;
            InvoicePostingBuffer."NCT Average Amount" := PurchaseLine."NCT Average Amount" * -1;
        end else begin
            InvoicePostingBuffer."NCT Tax Amount" := PurchaseLine."NCT Tax Amount";
            InvoicePostingBuffer."NCT Average Amount" := PurchaseLine."NCT Average Amount";
        end;
        InvoicePostingBuffer."NCT Average Tax" := PurchaseLine."NCT Average Tax Code" <> '';
        InvoicePostingBuffer."NCT From Purchase" := true;
    end;





    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromInvPostBuffer', '', false, false)]
    local procedure DSVCOnAfterCopyGenJnlLineFromInvPostBuffer(InvoicePostBuffer: Record "Invoice Post. Buffer"; var GenJournalLine: Record "Gen. Journal Line")

    begin
        GenJournalLine."NCT Average Tax Code" := InvoicePostBuffer."NCT Average Tax Code";
        GenJournalLine."NCT Average %" := InvoicePostBuffer."NCT Average %";
        GenJournalLine."NCT Average Amount" := InvoicePostBuffer."NCT Average Amount";
        GenJournalLine."NCT Tax Amount" := InvoicePostBuffer."NCT Tax Amount";
        GenJournalLine."NCT Average Tax" := InvoicePostBuffer."NCT Average Tax Code" <> '';
        GenJournalLine."NCT From Purchase" := InvoicePostBuffer."NCT From Purchase";

    end;

    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterCopyToGenJnlLine', '', false, false)]
    local procedure OnAfterCopyToGenJnlLine(InvoicePostBuffer: Record "Invoice Post. Buffer"; var GenJnlLine: Record "Gen. Journal Line")

    begin
        GenJnlLine."NCT Average Tax Code" := InvoicePostBuffer."NCT Average Tax Code";
        GenJnlLine."NCT Average %" := InvoicePostBuffer."NCT Average %";
        GenJnlLine."NCT Average Amount" := InvoicePostBuffer."NCT Average Amount";
        GenJnlLine."NCT Tax Amount" := InvoicePostBuffer."NCT Tax Amount";
        GenJnlLine."NCT Average Tax" := InvoicePostBuffer."NCT Average Tax Code" <> '';
        GenJnlLine."NCT From Purchase" := InvoicePostBuffer."NCT From Purchase";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Invoice Posting Buffer", 'OnAfterCopyToGenJnlLine', '', false, false)]
    local procedure OnAfterCopyToGenJnlLineBuff(InvoicePostingBuffer: Record "Invoice Posting Buffer" temporary; var GenJnlLine: Record "Gen. Journal Line")

    begin
        GenJnlLine."NCT Average Tax Code" := InvoicePostingBuffer."NCT Average Tax Code";
        GenJnlLine."NCT Average %" := InvoicePostingBuffer."NCT Average %";
        GenJnlLine."NCT Average Amount" := InvoicePostingBuffer."NCT Average Amount";
        GenJnlLine."NCT Tax Amount" := InvoicePostingBuffer."NCT Tax Amount";
        GenJnlLine."NCT Average Tax" := InvoicePostingBuffer."NCT Average Tax Code" <> '';
        GenJnlLine."NCT From Purchase" := InvoicePostingBuffer."NCT From Purchase";
    end;


    [EventSubscriber(ObjectType::Table, Database::"VAT Entry", 'OnAfterCopyFromGenJnlLine', '', false, false)]
    local procedure DSVCOnAfterCopyFromGenJnlLine(GenJournalLine: Record "Gen. Journal Line"; var VATEntry: Record "VAT Entry")
    begin
        VATEntry."NCT Average Tax Code" := GenJournalLine."NCT Average Tax Code";
        VATEntry."NCT Average %" := GenJournalLine."NCT Average %";
        VATEntry."NCT Average Amount" := GenJournalLine."NCT Average Amount";
        VATEntry."NCT Average Tax" := GenJournalLine."NCT Average Tax Code" <> '';

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertVAT', '', false, false)]
    local procedure DSVCOnBeforeInsertVATForGLEntry(var VATEntry: Record "VAT Entry"; var GLEntryVATAmount: Decimal; var GenJournalLine: Record "Gen. Journal Line")
    begin
        if GenJournalLine."NCT Average Tax Code" <> '' then
            GLEntryVATAmount := ROUND(GenJournalLine."NCT Average Amount", 0.01, '<')
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitVAT', '', false, false)]
    local procedure DSVCOnAfterInitVAT(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry")
    begin
        if NOT GenJournalLine."NCT From Purchase" then
            if (GenJournalLine."NCT Average Amount" <> 0) AND (GLEntry."VAT Amount" = 0) then
                if GenJournalLine.Amount > 0 then begin
                    GLEntry.Amount := GenJournalLine."NCT Average Amount";
                    GLEntry."Debit Amount" := ABS(GenJournalLine."NCT Average Amount");
                end else begin
                    GLEntry.Amount := GenJournalLine."NCT Average Amount";
                    GLEntry."Credit Amount" := ABS(GenJournalLine."NCT Average Amount");
                end;
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertGlEntry', '', false, false)]
    // local procedure DSVCOnBeforeInsertGlEntry(var GenJnlLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry")
    // begin

    //     if NOT GenJnlLine."NCT From Purchase" then begin
    //         if (GenJnlLine."NCT Average Amount" <> 0) AND (GLEntry."Gen. Prod. Posting Group" <> '') then
    //             GLEntry.Amount := (GLEntry.Amount + GenJnlLine."NCT Tax Invoice Amount") - GenJnlLine."NCT Average Amount"
    //     end else
    //         if (GenJnlLine."NCT Average Amount" <> 0) AND (GLEntry."Gen. Prod. Posting Group" <> '') then
    //             GLEntry.Amount := (GLEntry.Amount + GLEntry."Vat Amount") - GenJnlLine."NCT Average Amount"
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertVATEntry', '', false, false)]
    // local procedure DSVCOnBeforeInsertVATEntry(GenJournalLine: Record "Gen. Journal Line"; var VATEntry: Record "VAT Entry")
    // begin
    //     if GenJournalLine."NCT From Purchase" then begin
    //         if GenJournalLine."NCT Tax Amount" <> 0 then
    //             VATEntry.Amount := VATEntry.Amount + VATEntry."NCT Average Amount";
    //     end else
    //         if (GenJournalLine."NCT Average Tax Code" <> '') then
    //             VATEntry.Amount := GenJournalLine."NCT Tax Invoice Amount";

    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeInitGenJnlLineAmountFieldsFromTotalPurchLine', '', false, false)]
    local procedure DSVCOnBeforeInitGenJnlLineAmountFieldsFromTotalPurchLine(var TotalPurchLine2: Record "Purchase Line"; var TotalPurchLineLCY2: Record "Purchase Line"; var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Purchase Header"; var IsHandled: Boolean)
    var
        PurchaseLIne: Record "Purchase Line";
    begin
        if PurchHeader."Document Type" IN [PurchHeader."Document Type"::Invoice, PurchHeader."Document Type"::"Credit Memo"] then begin
            PurchaseLIne.reset();
            PurchaseLIne.SetRange("Document Type", PurchHeader."Document Type");
            PurchaseLIne.SetRange("Document No.", PurchHeader."No.");
            PurchaseLIne.SetFilter("NCT Average Tax Code", '<>%1', '');
            if PurchaseLIne.FindFirst() then
                if TotalPurchLine2."Amount Including VAT" >= 0 then begin
                    PurchaseLIne.CalcSums("Line Amount", "NCT Average Amount", "NCT Tax Amount");
                    TotalPurchLine2."Amount Including VAT" := PurchaseLIne."Line Amount" + PurchaseLIne."NCT Average Amount" + PurchaseLIne."NCT Tax Amount";
                    TotalPurchLineLCY2."Amount Including VAT" := TotalPurchLine2."Amount Including VAT";
                    TotalPurchLine2."Amount Including VAT" := ROUND(TotalPurchLine2."Amount Including VAT", 0.01);
                    TotalPurchLineLCY2."Amount Including VAT" := ROUND(TotalPurchLineLCY2."Amount Including VAT", 0.01);
                end else begin
                    PurchaseLIne.CalcSums("Line Amount", "NCT Average Amount", "NCT Tax Amount");
                    TotalPurchLine2."Amount Including VAT" := ABS(PurchaseLIne."Line Amount" + PurchaseLIne."NCT Average Amount" + PurchaseLIne."NCT Tax Amount") * -1;
                    TotalPurchLineLCY2."Amount Including VAT" := ABS(TotalPurchLine2."Amount Including VAT") * -1;
                    TotalPurchLine2."Amount Including VAT" := ABS(ROUND(TotalPurchLine2."Amount Including VAT", 0.01)) * -1;
                    TotalPurchLineLCY2."Amount Including VAT" := ABS(ROUND(TotalPurchLineLCY2."Amount Including VAT", 0.01)) * -1;
                end;
        end;

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Post Invoice Events", 'OnBeforeInitGenJnlLineAmountFieldsFromTotalLines', '', false, false)]
    local procedure OnBeforeInitGenJnlLineAmountFieldsFromTotalLines(var TotalPurchLineLCY: Record "Purchase Line"; var GenJnlLine: Record "Gen. Journal Line"; var IsHandled: Boolean; var PurchHeader: Record "Purchase Header"; var TotalPurchLine: Record "Purchase Line")
    var
        PurchaseLIne: Record "Purchase Line";
    begin
        if PurchHeader."Document Type" IN [PurchHeader."Document Type"::Invoice, PurchHeader."Document Type"::"Credit Memo"] then begin
            PurchaseLIne.reset();
            PurchaseLIne.SetRange("Document Type", PurchHeader."Document Type");
            PurchaseLIne.SetRange("Document No.", PurchHeader."No.");
            PurchaseLIne.SetFilter("NCT Average Tax Code", '<>%1', '');
            if PurchaseLIne.FindFirst() then
                if TotalPurchLine."Amount Including VAT" >= 0 then begin
                    PurchaseLIne.CalcSums("Line Amount", "NCT Average Amount", "NCT Tax Amount");
                    TotalPurchLine."Amount Including VAT" := PurchaseLIne."Line Amount" + PurchaseLIne."NCT Average Amount" + PurchaseLIne."NCT Tax Amount";
                    TotalPurchLineLCY."Amount Including VAT" := TotalPurchLine."Amount Including VAT";
                    TotalPurchLine."Amount Including VAT" := ROUND(TotalPurchLine."Amount Including VAT", 0.01);
                    TotalPurchLineLCY."Amount Including VAT" := ROUND(TotalPurchLineLCY."Amount Including VAT", 0.01);
                end else begin
                    PurchaseLIne.CalcSums("Line Amount", "NCT Average Amount", "NCT Tax Amount");
                    TotalPurchLine."Amount Including VAT" := ABS(PurchaseLIne."Line Amount" + PurchaseLIne."NCT Average Amount" + PurchaseLIne."NCT Tax Amount") * -1;
                    TotalPurchLineLCY."Amount Including VAT" := ABS(TotalPurchLine."Amount Including VAT") * -1;
                    TotalPurchLine."Amount Including VAT" := ABS(ROUND(TotalPurchLine."Amount Including VAT", 0.01)) * -1;
                    TotalPurchLineLCY."Amount Including VAT" := ABS(ROUND(TotalPurchLineLCY."Amount Including VAT", 0.01)) * -1;
                end;
        end;

    end;



    /// <summary>
    /// NCT Split AverageTax.
    /// </summary>
    /// <param name="pPurchaseHeader">Record "Purchase Header".</param>
    procedure "NCT Split AverageTax"(pPurchaseHeader: Record "Purchase Header")
    var
        PurchaseLine, PurchaseLine2 : Record "Purchase Line";
        VatProdPostingGroup: Record "VAT Product Posting Group";
        VATPostingGroup: Code[20];
        VatProdMsg: Label 'Not found setup Average Tax in %1', Locked = true;
    begin
        VatProdPostingGroup.reset();
        VatProdPostingGroup.SetRange("NCT Average Tax", true);
        if VatProdPostingGroup.FindFirst() then
            VATPostingGroup := VatProdPostingGroup.Code
        else begin
            Message(VatProdMsg, VatProdPostingGroup.TableCaption);
            exit;
        end;
        PurchaseLine.reset();
        PurchaseLine.SetRange("Document Type", pPurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", pPurchaseHeader."No.");
        PurchaseLine.SetFilter("NCT Average Tax Code", '<>%1', '');
        if PurchaseLine.FindSet() then begin
            PurchaseLine2.reset();
            PurchaseLine2.SetRange("Document Type", pPurchaseHeader."Document Type");
            PurchaseLine2.SetRange("Document No.", pPurchaseHeader."No.");
            PurchaseLine2.SetRange("NCT Split Average Tax", true);
            PurchaseLine2.DeleteAll();
            Commit();
            repeat
                PurchaseLine2.Init();
                PurchaseLine2.TransferFields(PurchaseLine, false);
                PurchaseLine2."Document Type" := pPurchaseHeader."Document Type";
                PurchaseLine2."Document No." := pPurchaseHeader."No.";
                PurchaseLine2."Line No." := PurchaseLine."Line No." + 10;
                PurchaseLine2."NCT WHT %" := 0;
                PurchaseLine2."NCT WHT Amount" := 0;
                PurchaseLine2."NCT WHT Business Posting Group" := '';
                PurchaseLine2."NCT WHT Product Posting Group" := '';
                PurchaseLine2.Validate("VAT Prod. Posting Group", VATPostingGroup);
                PurchaseLine2.Validate(Quantity, 1);
                PurchaseLine2.Validate("Direct Unit Cost", PurchaseLine."Amount Including VAT" - PurchaseLine.Amount - PurchaseLine."NCT Average Amount");
                PurchaseLine2."NCT Split Average Tax" := true;
                PurchaseLine2."NCT Average %" := 0;
                PurchaseLine2."NCT Average Amount" := 0;
                PurchaseLine2."NCT Tax Amount" := 0;
                PurchaseLine2."NCT Average Tax Code" := '';
                PurchaseLine2.Insert();
            until PurchaseLine.next() = 0;
        end else
            Message('Nothing to Create Average Tax');
    end;




    // local procedure "DSVCCheckAgerageTax"(pPurchaseHeader: Record "Purchase Header")
    // var
    //     ltPurchaseLine, ltPurchaseLine2 : Record "Purchase Line";
    // begin
    //     ltPurchaseLine.reset();
    //     ltPurchaseLine.SetRange("Document Type", pPurchaseHeader."Document Type");
    //     ltPurchaseLine.SetRange("Document No.", pPurchaseHeader."No.");
    //     ltPurchaseLine.SetFilter("NCT Average Tax Code", '<>%1', '');
    //     if ltPurchaseLine.FindFirst() then begin
    //         ltPurchaseLine.CalcSums("NCT Average Amount");

    //         ltPurchaseLine2.reset();
    //         ltPurchaseLine2.SetRange("Document Type", pPurchaseHeader."Document Type");
    //         ltPurchaseLine2.SetRange("Document No.", pPurchaseHeader."No.");
    //         ltPurchaseLine2.SetRange("NCT Split Average Tax", true);
    //         if ltPurchaseLine2.IsEmpty() then
    //             ERROR('Please split average text !');
    //         // ltPurchaseLine2.CalcSums("Line Amount");
    //         //  if ltPurchaseLine."NCT Average Amount" <> ltPurchaseLine2."Line Amount" then
    //         //     ltPurchaseLine2.TestField("Line Amount", ltPurchaseLine."NCT Average Amount");
    //         // end else
    //     end;
    //end;

    // local procedure "DSVCCheckAgerageTaxgenjournal"(pGenjournalline: Record "Gen. Journal Line")
    // var
    //     ltgenjournalline, ltgenjournalline2 : Record "Gen. Journal Line";
    // begin
    //     ltgenjournalline.reset();
    //     ltgenjournalline.SetRange("Journal Template Name", pGenJournalLine."Journal Template Name");
    //     ltgenjournalline.setrange("Journal Batch Name", pGenJournalLine."Journal Batch Name");
    //     ltgenjournalline.setrange("Document No.", pGenJournalLine."Document No.");
    //     ltgenjournalline.SetFilter("NCT Average Tax Code", '<>%1', '');
    //     if ltgenjournalline.FindFirst() then begin
    //         ltgenjournalline.CalcSums("NCT Average Amount");

    //         ltgenjournalline2.reset();
    //         ltgenjournalline2.SetRange("Journal Template Name", pGenJournalLine."Journal Template Name");
    //         ltgenjournalline2.setrange("Journal Batch Name", pGenJournalLine."Journal Batch Name");
    //         ltgenjournalline2.setrange("Document No.", pGenJournalLine."Document No.");
    //         ltgenjournalline2.SetRange("NCT Split Average Tax", true);
    //         if ltgenjournalline2.FindFirst() then begin
    //             ltgenjournalline2.CalcSums(Amount);
    //             if ABS(ltgenjournalline."NCT Average Amount") <> ABS(ltgenjournalline2.Amount) then
    //                 ltgenjournalline2.TestField(amount, ABS(ltgenjournalline."NCT Average Amount"));
    //         end else
    //             ERROR('Please split average text !');
    //     end;
    // end;


    /// <summary>
    /// NCT Split AverageTaxgenjournal.
    /// </summary>
    /// <param name="pGenJournalLine">Record "Gen. Journal Line".</param>
    procedure "NCT Split AverageTaxgenjournal"(pGenJournalLine: Record "Gen. Journal Line")
    var
        ltgenjournalline, ltgenjournalline2 : Record "Gen. Journal Line";
        VatProdPostingGroup: Record "VAT Product Posting Group";
        VATPostingGroup: Code[20];
        VatProdMsg: Label 'Not found setup Average Tax in %1', Locked = true;
    begin
        VatProdPostingGroup.reset();
        VatProdPostingGroup.SetRange("NCT Average Tax", true);
        if VatProdPostingGroup.FindFirst() then
            VATPostingGroup := VatProdPostingGroup.Code
        else begin
            Message(VatProdMsg, VatProdPostingGroup.TableCaption);
            exit;
        end;
        ltgenjournalline.reset();
        ltgenjournalline.SetRange("Journal Template Name", pGenJournalLine."Journal Template Name");
        ltgenjournalline.setrange("Journal Batch Name", pGenJournalLine."Journal Batch Name");
        ltgenjournalline.setrange("Document No.", pGenJournalLine."Document No.");
        ltgenjournalline.SetFilter("NCT Average Tax Code", '<>%1', '');
        if ltgenjournalline.FindSet() then begin
            ltgenjournalline2.reset();
            ltgenjournalline2.SetRange("Journal Template Name", pGenJournalLine."Journal Template Name");
            ltgenjournalline2.setrange("Journal Batch Name", pGenJournalLine."Journal Batch Name");
            ltgenjournalline2.setrange("Document No.", pGenJournalLine."Document No.");
            ltgenjournalline2.SetRange("NCT Split Average Tax", true);
            ltgenjournalline2.DeleteAll();
            Commit();
            repeat
                ltgenjournalline2.Init();
                ltgenjournalline2.TransferFields(ltgenjournalline2, false);
                ltgenjournalline2."Journal Batch Name" := pGenJournalLine."Journal Batch Name";
                ltgenjournalline2."Journal Template Name" := pGenJournalLine."Journal Template Name";
                ltgenjournalline2."Document No." := pGenJournalLine."Document No.";
                ltgenjournalline2."Line No." := pGenJournalLine."Line No." + 10;
                ltgenjournalline2."NCT WHT %" := 0;
                ltgenjournalline2."NCT WHT Business Posting Group" := '';
                ltgenjournalline2."NCT WHT Product Posting Group" := '';
                ltgenjournalline2.Validate("VAT Prod. Posting Group", VATPostingGroup);
                ltgenjournalline2.Validate(Quantity, 1);
                ltgenjournalline2.Validate(Amount, pGenJournalLine."VAT Base Amount");
                ltgenjournalline2."NCT Split Average Tax" := true;
                ltgenjournalline2."NCT Average %" := 0;
                ltgenjournalline2."NCT Average Amount" := 0;
                ltgenjournalline2."NCT Tax Amount" := 0;
                ltgenjournalline2."NCT Average Tax Code" := '';
                ltgenjournalline2.Insert();
            until ltgenjournalline.next() = 0;
        end else
            Message('Nothing to Create Average Tax');
    end;
}