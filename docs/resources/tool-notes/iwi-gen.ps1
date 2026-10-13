# iwi-gen.ps1 — IWI v8 loadscreen generator for mws&box
# Generates IWI v8 BGRA8 images for maps that lack loadscreen art.
# Output: brain/assets/iwi/loadscreen_<mapname>.iwi

param(
    [string]$MapName,
    [switch]$All,
    [switch]$ListOnly
)

$ErrorActionPreference = "Stop"
$brainRoot = "[local path]
$outputDir = "$brainRoot\assets\iwi"

# Ensure output directory exists
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

# Maps that genuinely lack loadscreen art (from council audit)
$mapsNeedingArt = @(
    "mp_beta",           # G: — 0 IWD files
    "mp_efa_rebirth",    # G: — 0 IWD files
    "mp_crash",          # Plutonium — no loadscreen in IWD
    "mp_crossfire",      # Plutonium — no loadscreen in IWD
    "mp_overgrown"       # Plutonium — no loadscreen in IWD
)

# Generate IWI v8 BGRA8 image
function New-IwiV8 {
    param([string]$MapName, [string]$OutputPath)
    
    Add-Type -AssemblyName System.Drawing
    
    $width = 1024
    $height = 1024
    
    $bitmap = New-Object System.Drawing.Bitmap($width, $height)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    
    # Dark background
    $graphics.Clear([System.Drawing.Color]::FromArgb(20, 22, 28))
    
    # Draw map name
    $font = New-Object System.Drawing.Font("Arial", 72, [System.Drawing.FontStyle]::Bold)
    $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(200, 200, 210))
    $format = New-Object System.Drawing.StringFormat
    $format.Alignment = [System.Drawing.StringAlignment]::Center
    $format.LineAlignment = [System.Drawing.StringAlignment]::Center
    
    $rect = New-Object System.Drawing.RectangleF(0, 0, $width, $height)
    $graphics.DrawString($MapName, $font, $brush, $rect, $format)
    
    # Draw subtitle
    $subFont = New-Object System.Drawing.Font("Arial", 32, [System.Drawing.FontStyle]::Regular)
    $subBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(120, 130, 150))
    $subRect = New-Object System.Drawing.RectangleF(0, 80, $width, $height)
    $graphics.DrawString("mws&box placeholder", $subFont, $subBrush, $subRect, $format)
    
    # Get raw BGRA pixels
    $bmpData = $bitmap.LockBits(
        (New-Object System.Drawing.Rectangle(0, 0, $width, $height)),
        [System.Drawing.Imaging.ImageLockMode]::ReadOnly,
        [System.Drawing.Imaging.PixelFormat]::Format32bppArgb
    )
    
    $byteCount = $bmpData.Stride * $height
    $pixelBytes = New-Object byte[] $byteCount
    [System.Runtime.InteropServices.Marshal]::Copy($bmpData.Scan0, $pixelBytes, 0, $byteCount)
    $bitmap.UnlockBits($bmpData)
    
    # Convert BGRA (from ARGB) to B,G,R,A order for IWI
    # System.Drawing uses ARGB in memory, IWI expects BGRA
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
    # Width: 1024 (u16 LE)
    $header[10] = 0x00
    $header[11] = 0x04
    # Height: 1024 (u16 LE)
    $header[12] = 0x00
    $header[13] = 0x04
    # Depth: 1 (u16 LE)
    $header[14] = 1
    $header[15] = 0
    # picmip[0]: file size (u32 LE) — will be filled after we know the size
    # picmip[1]: 32 (u32 LE) — start of payload
    $header[20] = 32
    $header[21] = 0
    $header[22] = 0
    $header[23] = 0
    # picmip[2]: 0
    # picmip[3]: 0
    
    # Total file size = 32 (header) + byteCount (payload)
    $fileSize = 32 + $byteCount
    
    # Fill picmip[0] with file size
    $header[16] = $fileSize -band 0xFF
    $header[17] = ($fileSize -shr 8) -band 0xFF
    $header[18] = ($fileSize -shr 16) -band 0xFF
    $header[19] = ($fileSize -shr 24) -band 0xFF
    
    # Write file
    $fs = [System.IO.File]::Create($OutputPath)
    $fs.Write($header, 0, 32)
    $fs.Write($bgraBytes, 0, $byteCount)
    $fs.Close()
    
    # Cleanup
    $graphics.Dispose()
    $bitmap.Dispose()
    $font.Dispose()
    $subFont.Dispose()
    $brush.Dispose()
    $subBrush.Dispose()
    $format.Dispose()
}

# Main logic
if ($ListOnly) {
    Write-Output "Maps needing loadscreen art (IWI v8):"
    $mapsNeedingArt | ForEach-Object { Write-Output "  $_" }
    exit
}

if ($All) {
    Write-Output "Generating IWI v8 loadscreen images for $($mapsNeedingArt.Count) maps..."
    
    $results = @()
    foreach ($map in $mapsNeedingArt) {
        $outputFile = "$outputDir\loadscreen_$map.iwi"
        try {
            New-IwiV8 -MapName $map -OutputPath $outputFile
            $fileInfo = Get-Item $outputFile
            $results += [PSCustomObject]@{
                Map = $map
                Status = "GENERATED"
                Output = $outputFile
                Size = $fileInfo.Length
            }
            Write-Output "  [OK] $map ($($fileInfo.Length) bytes)"
        } catch {
            $results += [PSCustomObject]@{
                Map = $map
                Status = "FAILED"
                Output = $_.Exception.Message
                Size = 0
            }
            Write-Output "  [FAIL] ${map}: $($_)"
        }
    }
    
    # Write results
    $resultsFile = "$brainRoot\projects\mws-and-box\notes\iwi-gen-results.md"
    $results | Out-File $resultsFile -Encoding UTF8
    Write-Output "`nResults written to: $resultsFile"
    Write-Output "Total: $($results.Count) | Success: $(($results | Where-Object { $_.Status -eq 'GENERATED' }).Count) | Failed: $(($results | Where-Object { $_.Status -eq 'FAILED' }).Count)"
    exit
}

if ($MapName) {
    $outputFile = "$outputDir\loadscreen_$MapName.iwi"
    New-IwiV8 -MapName $MapName -OutputPath $outputFile
    $fileInfo = Get-Item $outputFile
    Write-Output "Generated: $outputFile ($($fileInfo.Length) bytes)"
    exit
}

Write-Output "Usage: .\iwi-gen.ps1 -All | -MapName <name> | -ListOnly"
