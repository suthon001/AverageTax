/// <summary>
/// Report DSVC Purchase VAT Averate Tax (ID 70400).
/// </summary>
report 70400 "DSVC Purchase VAT Average Tax"
{
    Caption = 'Purchase Vat (Average Tax)';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    RDLCLayout = './LayoutReport/DSVCPurchaseVatAverateTax.rdl';
    PreviewMode = PrintLayout;
    DefaultLayout = RDLC;
    dataset
    {
        dataitem("VAT Entry"; "VAT Entry")
        {
            DataItemTableView = SORTING("Posting Date", "VAT Prod. Posting Group") WHERE(Type = FILTER(Purchase), "DSVC Average Tax Code" = filter(<> ''));
            RequestFilterFields = "DSVC Submit Year", "DSVC Submit Month", "Posting Date", "VAT Prod. Posting Group", "DSVC Average Tax Code", "VAT Bus. Posting Group";
            column(MonthText; FORMAT(gvMonthText))
            {
            }
            column(FilterAverageText; FilterAverageText) { }
            column(RunDate; FORMAT(TODAY(), 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(CompanyNameThai; CompanyInfo."DSVC Company Name In Thai")
            {
            }
            column(ThaiAddress1; CompanyInfo."DSVC Thai Address1")
            {
            }
            column(ThaiAddress2; CompanyInfo."DSVC Thai Address2")
            {
            }
            column(ThaiAddress3; CompanyInfo."DSVC Thai Address3")
            {
            }
            column(Company_VATNo; CompanyInfo."VAT Registration No.")
            {
            }
            column(gvCheckedBranch1; gvCheckedBranch[1])
            {
            }
            column(gvCheckedBranch2; gvCheckedBranch[2])
            {
            }
            column(gvBranchNo; gvBranchNo)
            {
            }
            column(gvLineNo; gvLineNo)
            {
            }
            column(DocumentDate_VATEntry; "VAT Entry"."Document Date")
            {
            }
            column(PostingDate_VATEntry; "VAT Entry"."Posting Date")
            {
            }
            column(ExternalDocumentNo_VATEntry; "VAT Entry"."External Document No.")
            {
            }
            column(VendName; VendName)
            {
            }
            column(GvVATRegNo; GvVATRegNo)
            {
            }
            column(gvvendAdd; gvVendAdd)
            {
            }
            column(gvBranchId; gvBranchID)
            {
            }
            column(VATBase; base)
            {
            }
            column(VATAmount; Amount)
            {
            }
            column(DSVC_Average_Amount; "DSVC Average Amount") { }
            column(DSVC_Tax_Amount; "DSVC Tax Amount") { }
            column(AverageVATAmt; AverageVATAmt) { }
            column(NetAmount; Base + Amount)
            {
            }
            column(gvTotalBase; BaseTotal)
            {
            }
            column(gvTotalVAT; VATAmtTotal)
            {
            }
            column(TotalAmount; BaseTotal + VATAmtTotal)
            {
            }
            column(gvOfficeId; gvOfficeID)
            {
            }
            column(EntryNo; "VAT Entry"."Entry No.")
            {
            }
            column(DocumentNo_VATEntry; "VAT Entry"."Document No.")
            {
            }
            column(DocumentType_VATEntry; "VAT Entry"."Document Type")
            {
            }
            column(VATProdPostingGroup_VATEntry; "VAT Entry"."VAT Prod. Posting Group")
            {
            }

            trigger OnAfterGetRecord();
            var
                ltVendor: Record Vendor;
            begin
                CLEAR(gvOfficeID);
                CLEAR(gvBranchID);
                CLEAR(VendName);
                CLEAR(ltVendor);
                Clear(gvRunningNo);
                if ltVendor.GET("VAT Entry"."Bill-to/Pay-to No.") then begin
                    If ltVendor."DSVC Thai Name" <> '' THEN
                        VendName := ltVendor."DSVC Thai Name"
                    else
                        VendName := ltVendor.Name;
                    GvVATRegNo := ltVendor."VAT Registration No.";
                    gvVendAdd := ltVendor.Address + ' ' + ltVendor."Address 2" + ' ' + ltVendor.City + ' ' + ltVendor."Post Code";

                    if ltVendor."DSVC Branch ID" = '' then
                        gvOfficeID := '00000'
                    else
                        if ltVendor."DSVC Branch ID" <> '00000' then
                            gvBranchID := ltVendor."DSVC Branch ID"
                        else
                            gvOfficeID := ltVendor."DSVC Branch ID";
                end;

                BaseTotal := BaseTotal + Base;
                VATAmtTotal := VATAmtTotal + amount;

                if (gvLineNo = 0) or (gvOldExtDocNo <> "VAT Entry"."External Document No.") then begin
                    gvLineNo += 1;
                    gvRunningNo := gvLineNo;

                    TempVATEntry.INIT();
                    TempVATEntry := "VAT Entry";
                    TempVATEntry."Entry No." := gvLineNo;
                    TempVATEntry."Source Code" := COPYSTR(gvOfficeID, 1, 10);
                    TempVATEntry."Reason Code" := COPYSTR(gvBranchID, 1, 10);
                    TempVATEntry.INSERT();
                end
                else
                    if gvOldType <> "VAT Entry"."Document Type".AsInteger() then begin
                        gvLineNo += 1;
                        gvRunningNo := gvLineNo;
                        TempVATEntry.INIT();
                        TempVATEntry := "VAT Entry";
                        TempVATEntry."Entry No." := gvLineNo;
                        TempVATEntry."Source Code" := COPYSTR(gvOfficeID, 1, 10);
                        TempVATEntry."Reason Code" := COPYSTR(gvBranchID, 1, 10);
                        TempVATEntry.INSERT();
                    end else begin
                        gvRunningNo := 0;
                        TempVATEntry.Base += "VAT Entry".Base;
                        TempVATEntry.Amount += "VAT Entry".Amount;
                        TempVATEntry.MODIFY();
                    end;


                gvOldType := "VAT Entry"."Document Type".AsInteger();
                gvOldExtDocNo := "VAT Entry"."External Document No.";

                AverageVATAmt := ("DSVC Average %" * Base) / 100;
                AverageVATAmt := Base - AverageVATAmt;
            end;

            trigger OnPreDataItem();
            var
                checkVatBusErr: Label 'VAT Bus. Posting Group must spacifies';
            begin
                if GetFilter("VAT Bus. Posting Group") = '' then
                    error(checkVatBusErr);
                CompanyInfo.GET();

                CLEAR(gvBranchNo);
                CLEAR(gvCheckedBranch);
                if CompanyInfo."DSVC Branch Code" = ShowBranchMsg then
                    gvCheckedBranch[1] := XShowMsg
                else begin
                    gvCheckedBranch[2] := XShowMsg;
                    gvBranchNo := CompanyInfo."DSVC Branch Code";
                end;

                if "VAT Entry".GETFILTER("DSVC Submit Month") <> '' then
                    EVALUATE(gvMonth, "VAT Entry".GETFILTER("DSVC Submit Month"))
                else
                    gvMonth := DATE2DMY("VAT Entry".GETRANGEMIN("Posting Date"), 2);

                if "VAT Entry".GETFILTER("DSVC Submit Year") <> '' then
                    EVALUATE(gvYear, "VAT Entry".GETFILTER("DSVC Submit Year"))
                else
                    gvYear := DATE2DMY("VAT Entry".GETRANGEMIN("Posting Date"), 3);

                gvMonthText := GetMonthText(true, gvMonth, gvYear) + ' ' + FORMAT(gvYear);

                CLEAR(gvOldType);
                CLEAR(gvOldExtDocNo);
                gvLineNo := 0;

                if GetFilter("DSVC Average Tax Code") <> '' then begin
                    AverageTaxSetup.GET(GetFilter("DSVC Average Tax Code"));
                    FilterAverageText := StrSubstNo(AverageTaxTxt, 100 - AverageTaxSetup."DSVC Average %");
                end;
            end;
        }
        dataitem("Excel Line"; "Integer")
        {
            DataItemTableView = SORTING(Number);

            trigger OnAfterGetRecord();
            begin
                if "Excel Line".Number <> 1 then
                    TempVATEntry.NEXT();
            end;


            trigger OnPreDataItem();
            begin
                CLEAR(TempVATEntry);
                if TempVATEntry.COUNT() <> 0 then begin
                    "Excel Line".SETRANGE(Number, 1, TempVATEntry.COUNT());
                    TempVATEntry.FindFirst()
                end else
                    "Excel Line".SETRANGE(Number, 1, 0);
            end;
        }
    }


    var
        AverageTaxSetup: Record "DSVC Average Tax Setup";
        TempVATEntry: Record "VAT Entry" temporary;
        CompanyInfo: Record "Company Information";
        BaseTotal, AverageVATAmt : Decimal;
        VATAmtTotal: Decimal;
        VendName, FilterAverageText : Text[100];
        GvVATRegNo: Text[20];
        gvVendAdd: Text[250];
        gvBranchID: Code[12];
        gvOfficeID: Code[12];
        gvLineNo: Integer;
        gvCheckedBranch: array[2] of Text[1];
        gvBranchNo: Code[20];
        gvOldExtDocNo: Code[40];
        gvRunningNo: Integer;
        gvMonthText: Text[250];
        gvMonth: Integer;
        gvYear: Integer;
        gvOldType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        ShowBranchMsg: Label '00000', MaxLength = 5;
        XShowMsg: Label 'X', MaxLength = 1;
        AverageTaxTxt: Label 'ภาษีที่ใช้สิทธิได้ %1 %', Locked = true;

    local procedure GetMonthText(pvTH: Boolean; pvNo: Integer; var pvYear: Integer) Month: Text[30];
    begin
        if pvTH then begin
            case pvNo of
                1:
                    Month := 'มกราคม';
                2:
                    Month := 'กุมภาพันธ์';
                3:
                    Month := 'มีนาคม';
                4:
                    Month := 'เมษายน';
                5:
                    Month := 'พฤษภาคม';
                6:
                    Month := 'มิถุนายน';
                7:
                    Month := 'กรกฏาคม';
                8:
                    Month := 'สิงหาคม';
                9:
                    Month := 'กันยายน';
                10:
                    Month := 'ตุลาคม';
                11:
                    Month := 'พฤศจิกายน';
                12:
                    Month := 'ธันวาคม';
                else
                    Month := ''
            end;

            pvYear += 543;
        end
        else
            case pvNo of
                1:
                    Month := 'January';
                2:
                    Month := 'February';
                3:
                    Month := 'March';
                4:
                    Month := 'April';
                5:
                    Month := 'May';
                6:
                    Month := 'June';
                7:
                    Month := 'July';
                8:
                    Month := 'August';
                9:
                    Month := 'September';
                10:
                    Month := 'October';
                11:
                    Month := 'November';
                12:
                    Month := 'December';
                else
                    Month := ''
            end;
    end;
}