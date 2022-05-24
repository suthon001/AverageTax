/// <summary>
/// Codeunit DSVC Avg. Funtions (ID 70400).
/// </summary>
codeunit 70400 "DSVC Avg. Funtions"
{
    EventSubscriberInstance = StaticAutomatic;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnSumPurchLines2OnAfterSetFilters', '', false, false)]
    local procedure DSVCOnSumPurchLines2OnAfterSetFilters(var PurchaseLine: Record "Purchase Line")
    begin
        PurchaseLine.SetRange("DSVC Split Average Tax", false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document Totals", 'OnAfterCalculatePurchaseSubPageTotals', '', false, false)]
    local procedure DSVCOnAfterCalculatePurchaseSubPageTotals(var TotalPurchHeader: Record "Purchase Header"; var TotalPurchLine: Record "Purchase Line"; var TotalPurchaseLine2: Record "Purchase Line"; var VATAmount: Decimal)
    var
        PurchaseLines: Record "Purchase Line";
    begin
        PurchaseLines.reset();
        PurchaseLines.setrange("Document Type", TotalPurchHeader."Document Type");
        PurchaseLines.setrange("Document No.", TotalPurchHeader."No.");
        PurchaseLines.SetRange("DSVC Split Average Tax", false);
        if PurchaseLines.FindFirst() then begin
            PurchaseLines.calcsums("DSVC Average Amount", Amount, "Amount Including VAT", "Line Amount");
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
        PurchaseLines.SetRange("DSVC Split Average Tax", false);
        if PurchaseLines.FindFirst() then begin
            PurchaseLines.calcsums("DSVC Average Amount", Amount, "Amount Including VAT", "Line Amount");
            VATAmount := PurchaseLines."Amount Including VAT" - PurchaseLines.Amount;
            TotalPurchaseLine."Line Amount" := PurchaseLines."Line Amount";
            TotalPurchaseLine.Amount := PurchaseLines.Amount;
            TotalPurchaseLine."Amount Including VAT" := PurchaseLines."Amount Including VAT";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterInvPostBufferPreparePurchase', '', false, false)]
    local procedure DSVCOnAfterInvPostBufferPreparePurchase(var InvoicePostBuffer: Record "Invoice Post. Buffer"; var PurchaseLine: Record "Purchase Line")
    begin

        InvoicePostBuffer."DSVC Average Tax Code" := PurchaseLine."DSVC Average Tax Code";
        InvoicePostBuffer."DSVC Average %" := PurchaseLine."DSVC Average %";

        if PurchaseLine."Document Type" = PurchaseLine."Document Type"::"Credit Memo" then begin
            InvoicePostBuffer."DSVC Tax Amount" := PurchaseLine."DSVC Tax Amount" * -1;
            InvoicePostBuffer."DSVC Average Amount" := PurchaseLine."DSVC Average Amount" * -1;
        end else begin
            InvoicePostBuffer."DSVC Tax Amount" := PurchaseLine."DSVC Tax Amount";
            InvoicePostBuffer."DSVC Average Amount" := PurchaseLine."DSVC Average Amount";
        end;
        InvoicePostBuffer."DSVC Average Tax" := PurchaseLine."DSVC Average Tax Code" <> '';
        InvoicePostBuffer."DSVC From Purchase" := true;
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnCopyPurchInvLinesToDocOnAfterTransferFields', '', false, false)]
    // local procedure DSVCOnCopyPurchInvLinesToDocOnAfterTransferFields(var FromPurchaseLine: Record "Purchase Line")
    // begin
    //     FromPurchaseLine."DSVC Average Tax Code" := '';
    //     FromPurchaseLine."DSVC Average Amount" := 0;
    //     FromPurchaseLine."DSVC Average %" := 0;
    //     FromPurchaseLine."DSVC Tax Amount" := 0;

    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnCopyPurchCrMemoLinesToDocOnAfterTransferFields', '', false, false)]
    // local procedure DSVCOnCopyPurchCrMemoLinesToDocOnAfterTransferFields(var FromPurchaseLine: Record "Purchase Line")
    // begin
    //     FromPurchaseLine."DSVC Average Tax Code" := '';
    //     FromPurchaseLine."DSVC Average Amount" := 0;
    //     FromPurchaseLine."DSVC Average %" := 0;
    //     FromPurchaseLine."DSVC Tax Amount" := 0;
    // end;



    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromInvPostBuffer', '', false, false)]
    local procedure DSVCOnAfterCopyGenJnlLineFromInvPostBuffer(InvoicePostBuffer: Record "Invoice Post. Buffer"; var GenJournalLine: Record "Gen. Journal Line")

    begin
        GenJournalLine."DSVC Average Tax Code" := InvoicePostBuffer."DSVC Average Tax Code";
        GenJournalLine."DSVC Average %" := InvoicePostBuffer."DSVC Average %";
        GenJournalLine."DSVC Average Amount" := InvoicePostBuffer."DSVC Average Amount";
        GenJournalLine."DSVC Tax Amount" := InvoicePostBuffer."DSVC Tax Amount";
        GenJournalLine."DSVC Average Tax" := InvoicePostBuffer."DSVC Average Tax Code" <> '';
        GenJournalLine."DSVC From Purchase" := InvoicePostBuffer."DSVC From Purchase";

    end;


    [EventSubscriber(ObjectType::Table, Database::"VAT Entry", 'OnAfterCopyFromGenJnlLine', '', false, false)]
    local procedure DSVCOnAfterCopyFromGenJnlLine(GenJournalLine: Record "Gen. Journal Line"; var VATEntry: Record "VAT Entry")
    begin
        VATEntry."DSVC Average Tax Code" := GenJournalLine."DSVC Average Tax Code";
        VATEntry."DSVC Average %" := GenJournalLine."DSVC Average %";
        VATEntry."DSVC Average Amount" := GenJournalLine."DSVC Average Amount";
        VATEntry."DSVC Tax Amount" := GenJournalLine."DSVC Tax Amount";
        VATEntry."DSVC Average Tax" := GenJournalLine."DSVC Average Tax Code" <> '';

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertVAT', '', false, false)]
    local procedure DSVCOnBeforeInsertVATForGLEntry(var VATEntry: Record "VAT Entry"; var GLEntryVATAmount: Decimal; var GenJournalLine: Record "Gen. Journal Line")
    begin
        if GenJournalLine."DSVC Average Tax Code" <> '' then
            GLEntryVATAmount := ROUND(GenJournalLine."DSVC Average Amount", 0.01, '<')
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitVAT', '', false, false)]
    local procedure DSVCOnAfterInitVAT(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry")
    begin
        if NOT GenJournalLine."DSVC From Purchase" then
            if (GenJournalLine."DSVC Average Amount" <> 0) AND (GLEntry."VAT Amount" = 0) then
                if GenJournalLine.Amount > 0 then begin
                    GLEntry.Amount := GenJournalLine."DSVC Average Amount";
                    GLEntry."Debit Amount" := ABS(GenJournalLine."DSVC Average Amount");
                end else begin
                    GLEntry.Amount := GenJournalLine."DSVC Average Amount";
                    GLEntry."Credit Amount" := ABS(GenJournalLine."DSVC Average Amount");
                end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertGlEntry', '', false, false)]
    local procedure DSVCOnBeforeInsertGlEntry(var GenJnlLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry")
    begin

        if NOT GenJnlLine."DSVC From Purchase" then begin
            if (GenJnlLine."DSVC Average Amount" <> 0) AND (GLEntry."Gen. Prod. Posting Group" <> '') then
                GLEntry.Amount := (GLEntry.Amount + GenJnlLine."DSVC Tax Invoice Amount") - GenJnlLine."DSVC Average Amount"
        end else
            if (GenJnlLine."DSVC Average Amount" <> 0) AND (GLEntry."Gen. Prod. Posting Group" <> '') then
                GLEntry.Amount := (GLEntry.Amount + GLEntry."Vat Amount") - GenJnlLine."DSVC Average Amount"
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertVATEntry', '', false, false)]
    local procedure DSVCOnBeforeInsertVATEntry(GenJournalLine: Record "Gen. Journal Line"; var VATEntry: Record "VAT Entry")
    begin
        if GenJournalLine."DSVC From Purchase" then begin
            if GenJournalLine."DSVC Tax Amount" <> 0 then
                VATEntry.Amount := VATEntry.Amount + VATEntry."DSVC Average Amount";
        end else
            if (GenJournalLine."DSVC Average Tax Code" <> '') then
                VATEntry.Amount := GenJournalLine."DSVC Tax Invoice Amount";

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeInitGenJnlLineAmountFieldsFromTotalPurchLine', '', false, false)]
    local procedure DSVCOnBeforeInitGenJnlLineAmountFieldsFromTotalPurchLine(var TotalPurchLine2: Record "Purchase Line"; var TotalPurchLineLCY2: Record "Purchase Line"; var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Purchase Header"; var IsHandled: Boolean)
    var
        PurchaseLIne: Record "Purchase Line";

    begin


        if PurchHeader."Document Type" IN [PurchHeader."Document Type"::Invoice, PurchHeader."Document Type"::"Credit Memo"] then begin
            PurchaseLIne.reset();
            PurchaseLIne.SetRange("Document Type", PurchHeader."Document Type");
            PurchaseLIne.SetRange("Document No.", PurchHeader."No.");
            PurchaseLIne.SetFilter("DSVC Average Tax Code", '<>%1', '');
            if PurchaseLIne.FindFirst() then
                if TotalPurchLine2."Amount Including VAT" >= 0 then begin
                    PurchaseLIne.CalcSums("Line Amount", "DSVC Average Amount", "DSVC Tax Amount");
                    TotalPurchLine2."Amount Including VAT" := PurchaseLIne."Line Amount" + PurchaseLIne."DSVC Average Amount" + PurchaseLIne."DSVC Tax Amount";
                    TotalPurchLineLCY2."Amount Including VAT" := TotalPurchLine2."Amount Including VAT";
                    TotalPurchLine2."Amount Including VAT" := ROUND(TotalPurchLine2."Amount Including VAT", 0.01);
                    TotalPurchLineLCY2."Amount Including VAT" := ROUND(TotalPurchLineLCY2."Amount Including VAT", 0.01);
                end else begin
                    PurchaseLIne.CalcSums("Line Amount", "DSVC Average Amount", "DSVC Tax Amount");
                    TotalPurchLine2."Amount Including VAT" := ABS(PurchaseLIne."Line Amount" + PurchaseLIne."DSVC Average Amount" + PurchaseLIne."DSVC Tax Amount") * -1;
                    TotalPurchLineLCY2."Amount Including VAT" := ABS(TotalPurchLine2."Amount Including VAT") * -1;
                    TotalPurchLine2."Amount Including VAT" := ABS(ROUND(TotalPurchLine2."Amount Including VAT", 0.01)) * -1;
                    TotalPurchLineLCY2."Amount Including VAT" := ABS(ROUND(TotalPurchLineLCY2."Amount Including VAT", 0.01)) * -1;
                end;
        end;

    end;



    /// <summary>
    /// DSVC Split AverageTax.
    /// </summary>
    /// <param name="pPurchaseHeader">Record "Purchase Header".</param>
    procedure "DSVC Split AverageTax"(pPurchaseHeader: Record "Purchase Header")
    var
        PurchaseLine, PurchaseLine2 : Record "Purchase Line";
        VatProdPostingGroup: Record "VAT Product Posting Group";
        VATPostingGroup: Code[20];
        VatProdMsg: Label 'Not found setup Average Tax in %1', Locked = true;
    begin
        VatProdPostingGroup.reset();
        VatProdPostingGroup.SetRange("DSVC Average Tax", true);
        if VatProdPostingGroup.FindFirst() then
            VATPostingGroup := VatProdPostingGroup.Code
        else begin
            Message(VatProdMsg, VatProdPostingGroup.TableCaption);
            exit;
        end;
        PurchaseLine.reset();
        PurchaseLine.SetRange("Document Type", pPurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", pPurchaseHeader."No.");
        PurchaseLine.SetFilter("DSVC Average Tax Code", '<>%1', '');
        if PurchaseLine.FindSet() then begin
            PurchaseLine2.reset();
            PurchaseLine2.SetRange("Document Type", pPurchaseHeader."Document Type");
            PurchaseLine2.SetRange("Document No.", pPurchaseHeader."No.");
            PurchaseLine2.SetRange("DSVC Split Average Tax", true);
            PurchaseLine2.DeleteAll();
            Commit();
            repeat
                PurchaseLine2.Init();
                PurchaseLine2.TransferFields(PurchaseLine, false);
                PurchaseLine2."Document Type" := pPurchaseHeader."Document Type";
                PurchaseLine2."Document No." := pPurchaseHeader."No.";
                PurchaseLine2."Line No." := PurchaseLine."Line No." + 10;
                PurchaseLine2."DSVC WHT %" := 0;
                PurchaseLine2."DSVC WHT Amount" := 0;
                PurchaseLine2."DSVC WHT Business Posting Grp" := '';
                PurchaseLine2."DSVC WHT Product Posting Group" := '';
                PurchaseLine2.Validate("VAT Prod. Posting Group", VATPostingGroup);
                PurchaseLine2.Validate(Quantity, 1);
                PurchaseLine2.Validate("Direct Unit Cost", PurchaseLine."Amount Including VAT" - PurchaseLine.Amount - PurchaseLine."DSVC Average Amount");
                PurchaseLine2."DSVC Split Average Tax" := true;
                PurchaseLine2."DSVC Average %" := 0;
                PurchaseLine2."DSVC Average Amount" := 0;
                PurchaseLine2."DSVC Tax Amount" := 0;
                PurchaseLine2."DSVC Average Tax Code" := '';
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
    //     ltPurchaseLine.SetFilter("DSVC Average Tax Code", '<>%1', '');
    //     if ltPurchaseLine.FindFirst() then begin
    //         ltPurchaseLine.CalcSums("DSVC Average Amount");

    //         ltPurchaseLine2.reset();
    //         ltPurchaseLine2.SetRange("Document Type", pPurchaseHeader."Document Type");
    //         ltPurchaseLine2.SetRange("Document No.", pPurchaseHeader."No.");
    //         ltPurchaseLine2.SetRange("DSVC Split Average Tax", true);
    //         if ltPurchaseLine2.IsEmpty() then
    //             ERROR('Please split average text !');
    //         // ltPurchaseLine2.CalcSums("Line Amount");
    //         //  if ltPurchaseLine."DSVC Average Amount" <> ltPurchaseLine2."Line Amount" then
    //         //     ltPurchaseLine2.TestField("Line Amount", ltPurchaseLine."DSVC Average Amount");
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
    //     ltgenjournalline.SetFilter("DSVC Average Tax Code", '<>%1', '');
    //     if ltgenjournalline.FindFirst() then begin
    //         ltgenjournalline.CalcSums("DSVC Average Amount");

    //         ltgenjournalline2.reset();
    //         ltgenjournalline2.SetRange("Journal Template Name", pGenJournalLine."Journal Template Name");
    //         ltgenjournalline2.setrange("Journal Batch Name", pGenJournalLine."Journal Batch Name");
    //         ltgenjournalline2.setrange("Document No.", pGenJournalLine."Document No.");
    //         ltgenjournalline2.SetRange("DSVC Split Average Tax", true);
    //         if ltgenjournalline2.FindFirst() then begin
    //             ltgenjournalline2.CalcSums(Amount);
    //             if ABS(ltgenjournalline."DSVC Average Amount") <> ABS(ltgenjournalline2.Amount) then
    //                 ltgenjournalline2.TestField(amount, ABS(ltgenjournalline."DSVC Average Amount"));
    //         end else
    //             ERROR('Please split average text !');
    //     end;
    // end;


    /// <summary>
    /// DSVC Split AverageTaxgenjournal.
    /// </summary>
    /// <param name="pGenJournalLine">Record "Gen. Journal Line".</param>
    procedure "DSVC Split AverageTaxgenjournal"(pGenJournalLine: Record "Gen. Journal Line")
    var
        ltgenjournalline, ltgenjournalline2 : Record "Gen. Journal Line";
        VatProdPostingGroup: Record "VAT Product Posting Group";
        VATPostingGroup: Code[20];
        VatProdMsg: Label 'Not found setup Average Tax in %1', Locked = true;
    begin
        VatProdPostingGroup.reset();
        VatProdPostingGroup.SetRange("DSVC Average Tax", true);
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
        ltgenjournalline.SetFilter("DSVC Average Tax Code", '<>%1', '');
        if ltgenjournalline.FindSet() then begin
            ltgenjournalline2.reset();
            ltgenjournalline2.SetRange("Journal Template Name", pGenJournalLine."Journal Template Name");
            ltgenjournalline2.setrange("Journal Batch Name", pGenJournalLine."Journal Batch Name");
            ltgenjournalline2.setrange("Document No.", pGenJournalLine."Document No.");
            ltgenjournalline2.SetRange("DSVC Split Average Tax", true);
            ltgenjournalline2.DeleteAll();
            Commit();
            repeat
                ltgenjournalline2.Init();
                ltgenjournalline2.TransferFields(ltgenjournalline2, false);
                ltgenjournalline2."Journal Batch Name" := pGenJournalLine."Journal Batch Name";
                ltgenjournalline2."Journal Template Name" := pGenJournalLine."Journal Template Name";
                ltgenjournalline2."Document No." := pGenJournalLine."Document No.";
                ltgenjournalline2."Line No." := pGenJournalLine."Line No." + 10;
                ltgenjournalline2."DSVC WHT %" := 0;
                ltgenjournalline2."DSVC WHT Business Posting Grp" := '';
                ltgenjournalline2."DSVC WHT Product Posting Group" := '';
                ltgenjournalline2.Validate("VAT Prod. Posting Group", VATPostingGroup);
                ltgenjournalline2.Validate(Quantity, 1);
                ltgenjournalline2.Validate(Amount, pGenJournalLine."VAT Base Amount");
                ltgenjournalline2."DSVC Split Average Tax" := true;
                ltgenjournalline2."DSVC Average %" := 0;
                ltgenjournalline2."DSVC Average Amount" := 0;
                ltgenjournalline2."DSVC Tax Amount" := 0;
                ltgenjournalline2."DSVC Average Tax Code" := '';
                ltgenjournalline2.Insert();
            until ltgenjournalline.next() = 0;
        end else
            Message('Nothing to Create Average Tax');
    end;
}