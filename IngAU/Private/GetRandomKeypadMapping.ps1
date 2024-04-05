function GetRandomKeypadMapping {
    param (
        [Hashtable]
        $Template,

        [String[]]
        $KeypadImages
    )
    process {
        $digitBoundry = [System.Drawing.Rectangle]::New(81, 38, 20, 31)
        $mapped = @{}
        foreach ($digit in $Template.Keys) {
            $templateBitmap = ConvertTo-Bitmap -Content $Template[$digit]
            foreach ($index in 0..9) {
                if ($index -in $mapped.Values) {
                    continue
                }
                $keypadBitmap = ConvertTo-Bitmap -Content $KeypadImages[$index]
                $comparison = Compare-Bitmap -Bitmap1 $templateBitmap -Bitmap2 $keypadBitmap -Region $digitBoundry
                if ($comparison.DifferentPixels -lt 20) {
                    $mapped[$digit] = $index
                    break
                }
            }
        }
        return $mapped
    }
}
