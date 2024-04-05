function ConvertTo-EncryptedString {
    param (
        [Parameter(Mandatory)]
        [String]
        $PemCertificate,

        [Parameter(Mandatory, ValueFromPipeline)]
        [String]
        $Message
    )
    begin {
        $rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider
        $rsa.ImportFromPem($PemCertificate)
    }
    process {
        $messageBytes = [System.Text.Encoding]::UTF8.GetBytes($Message)
        $encryptedData = $rsa.Encrypt($messageBytes, [System.Security.Cryptography.RSAEncryptionPadding]::Pkcs1)
        [System.Convert]::ToBase64String($encryptedData)
    }
}
