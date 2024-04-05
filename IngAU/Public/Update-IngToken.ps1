function Update-IngToken {
    $ctx = Get-IngContext
    $renew = Invoke-IngApi -Endpoint '/api/token/refresh' -Body @{ nonUserAction = "true" }
    $ctx.AccessToken = $renew.Token | ConvertTo-SecureString -AsPlainText -Force
    $ctx.TokenExpiry = (Get-Date).AddSeconds($renew.expires_in)
}
