# loadscreen-gen.ps1 — Placeholder loadscreen generator for mws&box
# Generates placeholder PNG images for maps that lack loadscreen art.
# Output: brain/assets/placeholders/loadscreen_<mapname>.png

param(
    [string]$MapName,
    [switch]$All,
    [switch]$ListOnly
)

$ErrorActionPreference = "Stop"
$brainRoot = "[local path]
$outputDir = "$brainRoot\assets\placeholders"
$unionFile = "$brainRoot\projects\mws-and-box\notes\usermap-union.md"

# Ensure output directory exists
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

# Parse union inventory to find maps lacking loadscreen art
function Get-MapsNeedingArt {
    $maps = @()
    
    # G: maps (97 total, 1 has loadscreen: mp_backlot_snow)
    $gPath = "G:\SteamLibrary\steamapps\common\Call of Duty Modern Warfare 2\usermaps"
    if (Test-Path $gPath) {
        $gMaps = Get-ChildItem $gPath -Directory
        foreach ($map in $gMaps) {
            $hasLoadscreen = $false
            $files = Get-ChildItem $map.FullName -Recurse -File -ErrorAction SilentlyContinue
            $loadscreen = $files | Where-Object { $_.Name -match "loadscreen" } | Select-Object -First 1
            if ($loadscreen) { $hasLoadscreen = $true }
            if (-not $hasLoadscreen) {
                $maps += [PSCustomObject]@{
                    Name = $map.Name
                    Source = "G:"
                    Path = $map.FullName
                }
            }
        }
    }
    
    # Plutonium iw5 maps (63 total, 1 has loadscreen: mp_bloc_2)
    $plutPath = "[local path]
    if (Test-Path $plutPath) {
        $plutMaps = Get-ChildItem $plutPath -Directory
        foreach ($map in $plutMaps) {
            $hasLoadscreen = $false
            $files = Get-ChildItem $map.FullName -Recurse -File -ErrorAction SilentlyContinue
            $loadscreen = $files | Where-Object { $_.Name -match "loadscreen" } | Select-Object -First 1
            if ($loadscreen) { $hasLoadscreen = $true }
            if (-not $hasLoadscreen) {
                $maps += [PSCustomObject]@{
                    Name = $map.Name
                    Source = "Plutonium-iw5"
                    Path = $map.FullName
                }
            }
        }
    }
    
    return $maps
}

# Generate a placeholder PNG using System.Drawing
function New-PlaceholderImage {
    param([string]$MapName, [string]$OutputPath)
    
    Add-Type -AssemblyName System.Drawing
    
    $width = 1024
    $height = 512
    
    $bitmap = New-Object System.Drawing.Bitmap($width, $height)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    
    # Dark background
    $graphics.Clear([System.Drawing.Color]::FromArgb(20, 22, 28))
    
    # Draw map name
    $font = New-Object System.Drawing.Font("Arial", 48, [System.Drawing.FontStyle]::Bold)
    $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(200, 200, 210))
    $format = New-Object System.Drawing.StringFormat
    $format.Alignment = [System.Drawing.StringAlignment]::Center
    $format.LineAlignment = [System.Drawing.StringAlignment]::Center
    
    $rect = New-Object System.Drawing.RectangleF(0, 0, $width, $height)
    $graphics.DrawString($MapName, $font, $brush, $rect, $format)
    
    # Draw subtitle
    $subFont = New-Object System.Drawing.Font("Arial", 24, [System.Drawing.FontStyle]::Regular)
    $subBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(120, 130, 150))
    $subRect = New-Object System.Drawing.RectangleF(0, 60, $width, $height)
    $graphics.DrawString("mws&box placeholder", $subFont, $subBrush, $subRect, $format)
    
    # Save
    $bitmap.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    
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
    $maps = Get-MapsNeedingArt
    Write-Output "Maps needing loadscreen art: $($maps.Count)"
    $maps | Format-Table Name, Source -AutoSize
    exit
}

if ($All) {
    $maps = Get-MapsNeedingArt
    Write-Output "Generating placeholders for $($maps.Count) maps..."
    
    $results = @()
    foreach ($map in $maps) {
        $outputFile = "$outputDir\loadscreen_$($map.Name).png"
        try {
            New-PlaceholderImage -MapName $map.Name -OutputPath $outputFile
            $results += [PSCustomObject]@{
                Map = $map.Name
                Source = $map.Source
                Status = "GENERATED"
                Output = $outputFile
            }
            Write-Output "  [OK] $($map.Name)"
        } catch {
            $results += [PSCustomObject]@{
                Map = $map.Name
                Source = $map.Source
                Status = "FAILED"
                Output = $_.Exception.Message
            }
            Write-Output "  [FAIL] $($map.Name): $_"
        }
    }
    
    # Write results
    $resultsFile = "$brainRoot\projects\mws-and-box\notes\loadscreen-gen-results.md"
    $results | Out-File $resultsFile -Encoding UTF8
    Write-Output "`nResults written to: $resultsFile"
    Write-Output "Total: $($results.Count) | Success: $(($results | Where-Object { $_.Status -eq 'GENERATED' }).Count) | Failed: $(($results | Where-Object { $_.Status -eq 'FAILED' }).Count)"
    exit
}

if ($MapName) {
    $outputFile = "$outputDir\loadscreen_$MapName.png"
    New-PlaceholderImage -MapName $MapName -OutputPath $outputFile
    Write-Output "Generated: $outputFile"
    exit
}

Write-Usage
