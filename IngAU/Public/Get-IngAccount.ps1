function Get-IngAccount {
    $summary = Get-IngSummary
    foreach ($category in $summary.Categories) {
        foreach ($account in $category.Accounts) {
            [PSCustomObject]@{
                Category = $category.Category.Name
                AccountStatus = $account.AccountStatus.Label
                AccountName = $account.AccountName
                CurrentBalance = $account.CurrentBalance
                AvailableBalance = $account.AvailableBalance
                AccountNumber = $account.AccountNumber
                BSB = $account.BSB
                ProductName = $account.ProductName
                Features = $account.Features
            }
        }
    }
}
