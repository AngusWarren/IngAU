function Compare-Bitmap {
    param (
        [System.Drawing.Bitmap]
        $Bitmap1,

        [System.Drawing.Bitmap]
        $Bitmap2,

        [System.Drawing.Rectangle]
        $Region
    )

    if ($bitmap1.Width -ne $bitmap2.Width -or $bitmap1.Height -ne $bitmap2.Height) {
        throw "Bitmaps are not of the same size."
    }

    if ($Region) {
        $columns = $Region.Left..$Region.Right
        $rows = $Region.Top..$Region.Bottom
    } else {
        $columns = 0..($Bitmap1.Width - 1)
        $rows = 0..($Bitmap1.Height - 1)
    }
    $totalPixels = $columns.Count * $rows.Count
    $differentPixels = 0
    foreach ($y in $rows) {
        foreach ($x in $columns) {
            if ($Bitmap1.GetPixel($x, $y) -ne $Bitmap2.GetPixel($x, $y)) {
                $differentPixels++
            }
        }
    }
    return [PSCustomObject]@{
        TotalPixels = $totalPixels
        DifferentPixels = $differentPixels
        Ratio = $differentPixels / $totalPixels
    }
}
