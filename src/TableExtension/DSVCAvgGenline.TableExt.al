/// <summary>
/// TableExtension DSVC Avg. Gen.line (ID 70403) extends Record Gen. Journal Line.
/// </summary>
tableextension 70403 "DSVC Avg. Gen.line" extends "Gen. Journal Line"
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
        field(70404; "DSVC Average Tax"; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Average Tax';
            Editable = false;
        }
        field(70405; "DSVC Split Average Tax"; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Split Average Tax';
            Editable = false;
        }
        field(70406; "DSVC From Purchase"; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'From Purchase';
            Editable = false;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                "DSVC CalcurateAverageTax"();
            end;
        }
        modify(Amount)
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
        TempVatAmount := "DSVC Tax Invoice Amount";
        if "DSVC Average %" <> 0 then
            "DSVC Average Amount" := (TempVatAmount * "DSVC Average %") / 100
        else
            "DSVC Average Amount" := 0;
    end;
}