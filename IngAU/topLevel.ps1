#Requires -PSEdition Core
#Requires -Modules Microsoft.PowerShell.Utility
$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0
Import-Module Microsoft.PowerShell.Utility
Add-type -AssemblyName "System.Drawing"
Add-Type -AssemblyName Microsoft.PowerShell.Commands.Utility

# This will be used to hold the IngContext object created when Connect-Ing is run. This
# allows it to be used by other functions in the module without the user passing it in each time.
$Script:IngContext = $null

Export-ModuleMember -Function Connect-Ing
Export-ModuleMember -Function Get-IngContext
Export-ModuleMember -Function Get-IngKeypad
Export-ModuleMember -Function Get-IngKeypadSecurePin
Export-ModuleMember -Function Get-IngTransactionHistory
Export-ModuleMember -Function Invoke-IngApi
