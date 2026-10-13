# swap-menu-background.ps1 — Replace the Plutonium IW5 main menu background
# Usage: .\swap-menu-background.ps1 -ImagePath "C:\path\to\dark_soldier.png"

param(
    [Parameter(Mandatory=$true)]
    [string]$ImagePath
)

$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Drawing

$storagePath = "[local path]
$imagesPath = "$storagePath\images"
$targetFile = "$imagesPath\menu_background.iwi"
$backupDir = "[local path]

# Ensure backup directory exists
if (-not (Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
}

# Backup original if not already backed up
$backupFile = "$backupDir\menu_background_original.iwi"
if (-not (Test-Path $backupFile)) {
    if (Test-Path $targetFile) {
        Copy-Item $targetFile $backupFile -Force
        Write-Output "Original backed up to: $backupFile"
    }
}

# Load and convert image
$image = [System.Drawing.Image]::FromFile($ImagePath)
$width = $image.Width
$height = $image.Height
Write-Output "Input: $ImagePath ($width x $height)"

$bmp = New-Object System.Drawing.Bitmap($width, $height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$graphics = [System.Drawing.Graphics]::FromImage($bmp)
$graphics.DrawImage($image, 0, 0, $width, $height)
$graphics.Dispose()

$data = $bmp.LockBits(
    (New-Object System.Drawing.Rectangle(0, 0, $width, $height)),
    [System.Drawing.Imaging.ImageLockMode]::ReadOnly,
    [System.Drawing.Imaging.PixelFormat]::Format32bppArgb
)

$byteCount = $data.Stride * $height
$pixelBytes = New-Object byte[] $byteCount
[System.Runtime.InteropServices.Marshal]::Copy($data.Scan0, $pixelBytes, 0, $byteCount)
$bmp.UnlockBits($data)

# Convert to BGRA
$bgraBytes = New-Object byte[] $byteCount
for ($i = 0; $i -lt $byteCount; $i += 4) {
    $bgraBytes[$i] = $pixelBytes[$i + 2]
    $bgraBytes[$i + 1] = $pixelBytes[$i + 1]
    $bgraBytes[$i + 2] = $pixelBytes[$i]
    $bgraBytes[$i + 3] = $pixelBytes[$i + 3]
}

# Build IWI v8 header
$header = New-Object byte[] 32
$header[0] = 0x49; $header[1] = 0x57; $header[2] = 0x69
$header[3] = 8
$header[4] = 0; $header[5] = 0
$header[6] = 0; $header[7] = 0
$header[8] = 1; $header[9] = 0
$header[10] = $width -band 0xFF; $header[11] = ($width -shr 8) -band 0xFF
$header[12] = $height -band 0xFF; $header[13] = ($height -shr 8) -band 0xFF
$header[14] = 1; $header[15] = 0
$fileSize = 32 + $byteCount
$header[16] = $fileSize -band 0xFF; $header[17] = ($fileSize -shr 8) -band 0xFF
$header[18] = ($fileSize -shr 16) -band 0xFF; $header[19] = ($fileSize -shr 24) -band 0xFF
$header[20] = 32; $header[21] = 0; $header[22] = 0; $header[23] = 0

# Write IWI file
$fs = [System.IO.File]::Create($targetFile)
$fs.Write($header, 0, 32)
$fs.Write($bgraBytes, 0, $byteCount)
$fs.Close()

$image.Dispose()
$bmp.Dispose()

Write-Output "Output: $targetFile ($fileSize bytes)"
Write-Output "Done. Launch Plutonium to see the new background."
Write-Output "To restore: Copy '$backupFile' back to '$targetFile'"
