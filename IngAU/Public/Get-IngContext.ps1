function Get-IngContext {
    process {
        if (-not $Script:IngContext) {
            Write-Error "Unable to retrieve ING context. Use Connect-Ing to connect first."
        }
        return $Script:IngContext
    }
}
