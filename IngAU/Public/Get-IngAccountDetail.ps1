function Get-IngAccountDetail {
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidatePattern('^\d+$')]
        [String]
        $AccountNumber
    )
    process {
        $endpoint = '/api/AccountDetails/Service/AccountDetailsService.svc/json/accountdetails/AccountDetails'
        $details = Invoke-IngApi -Endpoint $endpoint -Body @{
            AccountNumber = $AccountNumber
            PageNumber = 0
            PageSize = 25
        }
        $details.Response
    }
}
