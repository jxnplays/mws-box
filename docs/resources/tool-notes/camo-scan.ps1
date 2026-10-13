# Camo + art scanner for CoD IWD trees (MW2/MW3/BO1/CoD4 readable; NOT BO2/Ghosts/AW/IW/BO3/NX1)
# Usage: .\camo-scan.ps1 [-Mode camo|loadscreen|both]
# Counts distinct base image names matching camo/loadscreen/preview in main/iw_*.iwd.
param([string]$Game = "", [string]$Mode = "both")
Add-Type -AssemblyName System.IO.Compression.FileSystem
$roots = @{
  MW2  = 'F:\SteamLibrary\steamapps\common\Call of Duty Modern Warfare 2\main\iw_*.iwd'
  MW3  = '[local path] of Duty Modern Warfare 3\main\iw_*.iwd'
  BO1  = '[local path] of Duty Black Ops\main\iw_*.iwd'
  CoD4 = 'G:\SteamLibrary\steamapps\common\Call of Duty 4\main\iw_*.iwd'
}
$targets = if ($Game -ne "" -and $roots.ContainsKey($Game)) { @($Game) } else { @($roots.Keys) }
foreach ($g in $targets) {
  $camo = @{}; $art = @{}
  foreach ($f in Get-ChildItem $roots[$g] -ErrorAction SilentlyContinue) {
    $z = [IO.Compression.ZipFile]::OpenRead($f.FullName)
    foreach ($e in $z.Entries) {
      $n = $e.Name.ToLower()
      if ($n -notmatch '\.iwi$') { continue }
      $b = ($n -replace '\.iwi$','' -replace '^[~$]+','' -replace '_[cgns]$','' -replace '-rgb.*$','')
      if ($Mode -in @('camo','both') -and $b -match 'camo|cmoskin') { $camo[$b] = 1 }
      if ($Mode -in @('loadscreen','both') -and $b -match '^(loadscreen|preview)_') { $art[$b] = 1 }
    }
    $z.Dispose()
  }
  Write-Output ("== " + $g + " camo-ish: " + $camo.Count + " | loadscreen/preview: " + $art.Count + " ==")
  if ($Mode -eq 'camo') { $camo.Keys | Sort-Object | ForEach-Object { Write-Output ("  " + $_) } }
}
# Master counts live in brain/projects/mws-and-box/notes/CAMO-MASTER.md
