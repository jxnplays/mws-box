# image-to-iwi.ps1 — Convert PNG/JPG to IWI v8 BGRA8 format
# Usage: .\image-to-iwi.ps1 -InputImage "path\to\image.png" -OutputIwi "path\to\output.iwi"

param(
    [Parameter(Mandatory=$true)]
    [string]$InputImage,
    
    [Parameter(Mandatory=$true)]
    [string]$OutputIwi
)

$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Drawing

# Load the image
$image = [System.Drawing.Image]::FromFile($InputImage)
$width = $image.Width
$height = $image.Height

Write-Output "Input: $InputImage ($width x $height)"

# Create a 32bpp bitmap to ensure consistent format
$bmp = New-Object System.Drawing.Bitmap($width, $height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$graphics = [System.Drawing.Graphics]::FromImage($bmp)
$graphics.DrawImage($image, 0, 0, $width, $height)
$graphics.Dispose()

# Lock bits to get pixel data
$data = $bmp.LockBits(
    (New-Object System.Drawing.Rectangle(0, 0, $width, $height)),
    [System.Drawing.Imaging.ImageLockMode]::ReadOnly,
    [System.Drawing.Imaging.PixelFormat]::Format32bppArgb
)

# Copy pixel data
$byteCount = $data.Stride * $height
$pixelBytes = New-Object byte[] $byteCount
[System.Runtime.InteropServices.Marshal]::Copy($data.Scan0, $pixelBytes, 0, $byteCount)
$bmp.UnlockBits($data)

# Convert BGRA (from ARGB) to B,G,R,A order for IWI
$bgraBytes = New-Object byte[] $byteCount
for ($i = 0; $i -lt $byteCount; $i += 4) {
    $bgraBytes[$i] = $pixelBytes[$i + 2]     # B
    $bgraBytes[$i + 1] = $pixelBytes[$i + 1] # G
    $bgraBytes[$i + 2] = $pixelBytes[$i]     # R
    $bgraBytes[$i + 3] = $pixelBytes[$i + 3] # A
}

# Build IWI v8 header (32 bytes)
$header = New-Object byte[] 32
# Magic: IWi
$header[0] = 0x49  # I
$header[1] = 0x57  # W
$header[2] = 0x69  # i
# Version: 8
$header[3] = 8
# Flags: 0
$header[4] = 0
$header[5] = 0
# Usage: 0 (color)
$header[6] = 0
$header[7] = 0
# Format: 1 (BGRA8)
$header[8] = 1
$header[9] = 0
# Width (u16 LE)
$header[10] = $width -band 0xFF
$header[11] = ($width -shr 8) -band 0xFF
# Height (u16 LE)
$header[12] = $height -band 0xFF
$header[13] = ($height -shr 8) -band 0xFF
# Depth: 1 (u16 LE)
$header[14] = 1
$header[15] = 0
# picmip[0]: file size (u32 LE)
$fileSize = 32 + $byteCount
$header[16] = $fileSize -band 0xFF
$header[17] = ($fileSize -shr 8) -band 0xFF
$header[18] = ($fileSize -shr 16) -band 0xFF
$header[19] = ($fileSize -shr 24) -band 0xFF
# picmip[1]: 32 (u32 LE) — start of payload
$header[20] = 32
$header[21] = 0
$header[22] = 0
$header[23] = 0
# picmip[2]: 0
# picmip[3]: 0

# Write IWI file
$fs = [System.IO.File]::Create($OutputIwi)
$fs.Write($header, 0, 32)
$fs.Write($bgraBytes, 0, $byteCount)
$fs.Close()

# Cleanup
$image.Dispose()
$bmp.Dispose()

Write-Output "Output: $OutputIwi ($fileSize bytes)"
Write-Output "Done."
