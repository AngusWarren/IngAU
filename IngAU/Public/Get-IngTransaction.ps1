function Get-IngTransaction {
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidatePattern('^\d+$')]
        [String]
        $AccountNumber,

        [DateTime]
        $StartDate = (Get-Date).Date.AddDays(-30),

        [DateTime]
        $EndDate = (Get-Date).Date.AddDays(1),

        [AllowNull()]
        [Nullable[Int32]]
        $MinValue,

        [AllowNull()]
        [Nullable[Int32]]
        $MaxValue,

        [String]
        $SearchQuery,

        [Int]
        $PageNumber = 0,

        [ValidateRange(1, 257)]
        [Int]
        $PageSize = 200
    )
    process {
        $endpoint = '/api/TransactionHistory/Service/TransactionHistoryService.svc/json/TransactionHistory/TransactionHistory'
        $filter = @{
            StartDate = $StartDate.ToString('o')
            EndDate = $EndDate.ToString('o')
            IsSpecific = $false
        }
        if ($MinValue) {
            $filter['MinValue'] = [String]$MinValue
        }
        if ($MaxValue) {
            $filter['MaxValue'] = [String]$MaxValue
        }
        $transactions = Invoke-IngApi -Endpoint $endpoint -Body @{
            AccountNumber = $AccountNumber
            SearchQuery = $SearchQuery
            Filter = $filter
            PageNumber = $PageNumber
            PageSize = $PageSize
        }
        $transactions.Response.Transactions
        $total = $transactions.Response.TotalTransactionsCount
        if (-not $PSBoundParameters.ContainsKey('PageNumber') -and $total -gt $PageSize) {
            Write-Warning "$PageSize/$total records retrieved. Use -PageNumber X to retrieve more pages."
        }
    }
}
