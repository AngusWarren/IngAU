$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

# This will be used to hold the IngContext object created when Connect-Ing is run. This
# allows it to be used by other functions in the module without the user passing it in each time.
$Script:IngContext = $null

Add-Type -AssemblyName "System.Drawing"

$classes = @(Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Classes/*.ps1') -Recurse -ErrorAction Stop)
$public  = @(Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Public/*.ps1')  -Recurse -ErrorAction Stop)
$private = @(Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Private/*.ps1') -Recurse -ErrorAction Stop)
foreach ($import in @($classes + $public + $private)) {
    try {
        . $import.FullName
    } catch {
        throw "Unable to dot source [$($import.FullName)]"
    }
}
Export-ModuleMember -Function $public.Basename
