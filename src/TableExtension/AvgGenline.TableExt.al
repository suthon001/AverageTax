/// <summary>
/// TableExtension NCT Avg. Gen.line (ID 70403) extends Record Gen. Journal Line.
/// </summary>
tableextension 70403 "NCT Avg. Gen.line" extends "Gen. Journal Line"
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
        field(70404; "NCT Average Tax"; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Average Tax';
            Editable = false;
        }
        field(70405; "NCT Split Average Tax"; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Split Average Tax';
            Editable = false;
        }
        field(70406; "NCT From Purchase"; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'From Purchase';
            Editable = false;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                "NCT CalcurateAverageTax"();
            end;
        }
        modify(Amount)
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
        TempVatAmount := "NCT Tax Invoice Amount";
        if "NCT Average %" <> 0 then
            "NCT Average Amount" := (TempVatAmount * "NCT Average %") / 100
        else
            "NCT Average Amount" := 0;
    end;
}