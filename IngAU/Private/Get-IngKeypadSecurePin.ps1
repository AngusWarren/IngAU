function Get-IngKeypadSecurePin {
    param (
        [Parameter(Mandatory)]
        [PSCredential]
        $Credential
    )
    process {
        $keypad = Get-IngKeypad
        $strike = foreach ($digit in [int[]](($Credential.GetNetworkCredential().Password -split '') -ne '')) {
            $keypad.mapping[$digit]
        }
        $securePin = ConvertTo-EncryptedString -PemCertificate $keypad.PemEncryptionKey -Message ($strike -join ',')
        [PSCustomObject]@{
            Strike = $strike
            SecurePin = $securePin
            Mapping = $keypad.Mapping
            Secret = $keypad.Secret
            PemEncryptionKey = $keypad.PemEncryptionKey
        }
    }
}
