function ConvertTo-Bitmap {
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [Alias('Base64')]
        [String]
        $Content
    )
    begin {
        Add-type -AssemblyName "System.Drawing"
    }
    process {
        $bytes = [Convert]::FromBase64String($Content)
        $memoryStream = New-Object System.IO.MemoryStream(,$bytes)
        New-Object System.Drawing.Bitmap($memoryStream)
    }
}
