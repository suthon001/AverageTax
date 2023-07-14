/// <summary>
/// TableExtension NCT Avg. PurchaseLine (ID 70400) extends Record Purchase Line.
/// </summary>
tableextension 70400 "NCT Avg. PurchaseLine" extends "Purchase Line"
{
    fields
    {
        field(70400; "NCT Average Tax Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "NCT Average Tax Setup"."NCT Code";
            Caption = 'Average Tax Code';
            trigger OnValidate()
            var
                AverageTaxsetup: Record "NCT Average Tax Setup";
            begin
                TestField("NCT Split Average Tax", false);
                if not AverageTaxsetup.GET("NCT Average Tax Code") then
                    AverageTaxsetup.Init();
                VALIDATE("NCT Average %", AverageTaxsetup."NCT Average %");
            end;
        }
        field(70401; "NCT Average %"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Average %';
            trigger OnValidate()
            begin
                TestField("NCT Split Average Tax", false);
                "NCT CalcurateAverageTax"();
            end;
        }
        field(70402; "NCT Average Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Average Amount';
            Editable = false;
        }
        field(70403; "NCT Tax Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Tax Amount';
            Editable = false;
        }
        field(70404; "NCT Split Average Tax"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Split Average Tax';
            Editable = false;
        }

        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                "NCT CalcurateAverageTax"();
            end;
        }
        modify("Direct Unit Cost")
        {
            trigger OnAfterValidate()
            begin
                "NCT CalcurateAverageTax"();
            end;
        }
    }
    /// <summary>
    /// NCT CalcurateAverageTax.
    /// </summary>
    procedure "NCT CalcurateAverageTax"()
    var
        TempVatAmount: Decimal;
    begin

        TempVatAmount := "Amount Including VAT" - Amount;
        "NCT Average Amount" := (TempVatAmount * "NCT Average %") / 100;
        "NCT Tax Amount" := TempVatAmount - "NCT Average Amount";
        "NCT Tax Amount" := ROUND("NCT Tax Amount", 0.01, '<');
    end;
}