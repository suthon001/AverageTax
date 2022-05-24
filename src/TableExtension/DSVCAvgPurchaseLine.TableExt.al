/// <summary>
/// TableExtension DSVC Avg. PurchaseLine (ID 70400) extends Record Purchase Line.
/// </summary>
tableextension 70400 "DSVC Avg. PurchaseLine" extends "Purchase Line"
{
    fields
    {
        field(70400; "DSVC Average Tax Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "DSVC Average Tax Setup"."DSVC Code";
            Caption = 'Average Tax Code';
            trigger OnValidate()
            var
                AverageTaxsetup: Record "DSVC Average Tax Setup";
            begin
                TestField("DSVC Split Average Tax", false);
                if not AverageTaxsetup.GET("DSVC Average Tax Code") then
                    AverageTaxsetup.Init();
                VALIDATE("DSVC Average %", AverageTaxsetup."DSVC Average %");
            end;
        }
        field(70401; "DSVC Average %"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Average %';
            trigger OnValidate()
            begin
                TestField("DSVC Split Average Tax", false);
                "DSVC CalcurateAverageTax"();
            end;
        }
        field(70402; "DSVC Average Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Average Amount';
            Editable = false;
        }
        field(70403; "DSVC Tax Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Tax Amount';
            Editable = false;
        }
        field(70404; "DSVC Split Average Tax"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Split Average Tax';
            Editable = false;
        }

        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                "DSVC CalcurateAverageTax"();
            end;
        }
        modify("Direct Unit Cost")
        {
            trigger OnAfterValidate()
            begin
                "DSVC CalcurateAverageTax"();
            end;
        }
    }
    /// <summary>
    /// DSVC CalcurateAverageTax.
    /// </summary>
    procedure "DSVC CalcurateAverageTax"()
    var
        TempVatAmount: Decimal;
    begin

        TempVatAmount := "Amount Including VAT" - Amount;
        "DSVC Average Amount" := (TempVatAmount * "DSVC Average %") / 100;
        "DSVC Tax Amount" := TempVatAmount - "DSVC Average Amount";
        "DSVC Tax Amount" := ROUND("DSVC Tax Amount", 0.01, '<');
    end;
}