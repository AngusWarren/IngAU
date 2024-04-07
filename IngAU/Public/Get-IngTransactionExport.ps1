function Get-IngTransactionExport {
    <#
        .SYNOPSIS
            Exports transaction history in the same formats available from the web interface.
        .DESCRIPTION
            Exports transaction history in the same formats available from the web interface. Defaults to retrieving the
            last 30 days. Override by specifying the StartDate and EndDate parameters.
        .EXAMPLE
            Get-IngTransactionHistoryExport -AccountNumber 123456 | Export-Csv -NoTypeInformation ing_12346.csv
        .EXAMPLE
            Get-IngTransactionHistoryExport -AccountNumber 123456 -Format qif | Set-Content ing_12346.qif
        .EXAMPLE
            $allTransactions = Get-IngTransactionHistoryExport -AccountNumber 123456 -StartDate (Get-Date).AddYears(-5)
    #>
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
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

        [ValidateSet('csv', 'ofx', 'qif')]
        [String]
        $Format = "csv"
    )

    begin {
        $ctx = Get-IngContext
    }
    process {
        $params = @{
            UseBasicParsing = $true
            Uri = $ctx.FullUri("/api/ExportTransactions/Service/ExportTransactionsService.svc/json/ExportTransactions/ExportTransactions")
            Method = "POST"
            Body = [Ordered]@{
                "X-AuthToken" = $ctx.AccessTokenPlain()
                AccountNumber = $AccountNumber
                Format = $Format
                FilterStartDate = $StartDate.ToString('o')
                FilterEndDate = $EndDate.ToString('o')
                FilterMinValue = $MinValue
                FilterMaxValue = $MaxValue
                FilterProductTransactionTypeId = $null
                SearchQuery = $SearchQuery
                IsSpecific = $false
            }
        }
        try {
            $response = Invoke-WebRequest @params
            if ($Format -eq 'csv') {
                [Text.Encoding]::UTF8.GetString($response.Content) | ConvertFrom-Csv
            } else {
                [Text.Encoding]::UTF8.GetString($response.Content)
            }
        } catch {
            if ($_.Exception.Response.StatusCode -eq 400) {
                Write-Warning "Status Code 400 (BadResponse) received for query. This is expected if there were no transactions."
            } else {
                throw $_
            }
        }
    }
}
