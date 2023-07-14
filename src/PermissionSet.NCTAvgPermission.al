permissionset 70400 "NCT Avg Permission"
{
    Assignable = true;
    Caption = 'Avg Permission', MaxLength = 30;
    Permissions =
        table "NCT Average Tax Setup" = X,
        tabledata "NCT Average Tax Setup" = RMID,
        codeunit "NCT Avg. Funtions" = X,
        page "NCT Average Tax Setup" = X,
        report "NCT Purchase VAT Average Tax" = X;
}
