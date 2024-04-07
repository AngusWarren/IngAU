# IngAU PowerShell Module
Connects to the API for ING Australia.

## Overview
Basic wrapper for the API used by ING's web interface in Australia (https://www.ing.com.au/securebanking/). Allows for programmatic export of transaction data, and includes a helper function (Invoke-IngApi) to make any unimplemented API calls.

## Examples

```powershell
Connect-Ing -ClientNumber 12345
 PIN: ******

$accounts = Get-IngAccount
$accounts | ft -auto Category,AccountName,AccountNumber

Category          AccountName       AccountNumber
--------          -----------       -------------
Consumer credit
Everyday banking  Primary Account   11111111
Everyday banking  Joint Account     22222222
Savings           Savings Account   33333333


$ErrorActionPreference = "Stop"
$accounts | ?{ $_.AccountNumber } | ForEach-Object {
    $fileName = "Transactions - $( $_.AccountName ) ($( $_.AccountNumber )).csv"
    $transactions = $_ | Get-IngTransactionExport -StartDate (Get-Date).AddMonths(-12)
    $transactions | Export-Csv -NoTypeInformation $fileName
}
```
