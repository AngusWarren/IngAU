function Connect-Ing {
    <#
        .SYNOPSIS
            Sets up the IngContext object which will save the connection details for other functions.
        .DESCRIPTION
            The connection context will be stored in the module's IngContext variable. This allows it to be
            used by other functions in this module. It can be retrieved by the user with Get-IngContext.
        .EXAMPLE
            Connect-Ing

            Prompts for ClientNumber and PIN
        .EXAMPLE
            Connect-Ing -ClientNumber 1234567

            Prompts for the PIN
        .EXAMPLE
            Connect-Ing -Credential $savedCredential
        .EXAMPLE
            Connect-Ing -ClientNumber 1234567 -SecurePin $secureStringPin
    #>
    [CmdletBinding(DefaultParameterSetName="Credential")]
    param (
        [Parameter(ParameterSetName="Credential")]
        [PSCredential]
        $Credential,

        [Parameter(ParameterSetName="SeparateUserAndPassword", Mandatory)]
        [String]
        $ClientNumber,

        [Parameter(ParameterSetName="SeparateUserAndPassword")]
        [SecureString]
        $PIN,

        [Switch]
        $PassThru
    )
    process {
        if (-not $Credential) {
            if ($PSCmdlet.ParameterSetName -eq 'Credential') {
                $Credential = Get-Credential -Message "Enter your ING client number and PIN"
            } else {
                if (-not $PIN) {
                    $PIN = Read-Host -AsSecureString -Prompt "PIN"
                }
                $Credential = [PSCredential]::New($ClientNumber, $PIN)
            }
        }
        $ctx = [IngContext]@{
            Keypad = Get-IngKeypadSecurePin -Credential $Credential
            Session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
            Rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider(2048)
        }

        $publicKey = [BitConverter]::ToString($ctx.Rsa.ExportRSAPublicKey()[9..264]).ToLower().Replace('-','')
        $headers = @{
            "X-AuthCIF" = $Credential.UserName
            "X-AuthPIN" = $ctx.Keypad.SecurePin
            "X-AuthSecret" = $ctx.Keypad.Secret
            "X-MessageSignKey" = $publicKey
            "content-type" = "application/json"
        }
        $resp = Invoke-RestMethod -WebSession $ctx.Session -Method POST -Headers $headers -Uri $ctx.FullUri("/api/token/login/issue")
        if ($resp.PSObject.Properties.Name -notcontains 'Token') {
            Write-Error "Error while requesting token: $( $resp.ErrorMessage )"
        }
        $ctx.AccessToken = ConvertTo-SecureString -AsPlainText -Force $resp.Token
        $ctx.TokenExpiry = (Get-Date).AddSeconds($resp.expires_in)
        $Script:IngContext = $ctx
        if ($PassThru) {
            $ctx
        }
    }
}
