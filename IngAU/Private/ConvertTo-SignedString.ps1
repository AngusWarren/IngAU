function ConvertTo-SignedString {
    param (
        [Parameter(Mandatory)]
        [Security.Cryptography.RSACryptoServiceProvider]
        $Rsa,

        [Parameter(Mandatory, ValueFromPipeline)]
        [String]
        $Message,

        [Switch]
        $AsBase64
    )
    process {
        $messageBytes = [Text.Encoding]::UTF8.GetBytes($Message)
        $signedData = $rsa.SignData($messageBytes, [Security.Cryptography.HashAlgorithmName]::SHA256, [Security.Cryptography.RSASignaturePadding]::Pkcs1)
        if ($AsBase64) {
            [System.Convert]::ToBase64String($signedData)
        } else {
            [BitConverter]::ToString($signedData).ToLower().Replace('-','')
        }
    }
}
