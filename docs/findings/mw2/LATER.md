# MW2 Retail Folder Findings

Source folder: `[local path] of Duty Modern Warfare 2`

No usermaps, mods, plutonium, or iw4x detected. Clean retail install.

## Retail MP Map Stems

| Map Stem | Zone File Read |
|----------|---------------|
| mp_afghan | zone\english\mp_afghan.ff |
| mp_boneyard | zone\english\mp_boneyard.ff |
| mp_brecourt | zone\english\mp_brecourt.ff |
| mp_checkpoint | zone\english\mp_checkpoint.ff |
| mp_derail | zone\english\mp_derail.ff |
| mp_estate | zone\english\mp_estate.ff |
| mp_favela | zone\english\mp_favela.ff |
| mp_highrise | zone\english\mp_highrise.ff |
| mp_invasion | zone\english\mp_invasion.ff |
| mp_nightshift | zone\english\mp_nightshift.ff |
| mp_quarry | zone\english\mp_quarry.ff |
| mp_rundown | zone\english\mp_rundown.ff |
| mp_rust | zone\english\mp_rust.ff |
| mp_subbase | zone\english\mp_subbase.ff |
| mp_terminal | zone\english\mp_terminal.ff |
| mp_underpass | zone\english\mp_underpass.ff |

## DLC Map Stems

| Map Stem | Zone File Read |
|----------|---------------|
| mp_abandon | zone\dlc\mp_abandon.ff |
| mp_compact | zone\dlc\mp_compact.ff |
| mp_complex | zone\dlc\mp_complex.ff |
| mp_crash | zone\dlc\mp_crash.ff |
| mp_fuel2 | zone\dlc\mp_fuel2.ff |
| mp_overgrown | zone\dlc\mp_overgrown.ff |
| mp_storm | zone\dlc\mp_storm.ff |
| mp_strike | zone\dlc\mp_strike.ff |
| mp_trailerpark | zone\dlc\mp_trailerpark.ff |
| mp_vacant | zone\dlc\mp_vacant.ff |

## Weapon, Perk, and Camo Table Files

No raw source table files (e.g., `.csv`, `.gsc`, `.csc`) exist in the retail folder. All game data tables are compiled into fastfiles and IWD archives.

The following fastfiles are the standard containers for weapon, perk, and camo data in MW2:

- `zone\english\common.ff`
- `zone\english\common_mp.ff`
- `zone\english\code_post_gfx_mp.ff`
- `zone\english\code_pre_gfx_mp.ff`
- `zone\english\ui_mp.ff`
- `zone\english\localized_common_mp.ff`

IWD archives that may contain additional table data:

- `main\iw_00.iwd` through `main\iw_09.iwd`
- `main\localized_english_iw00.iwd` through `main\localized_english_iw04.iwd`

No standalone weapon, perk, or camo table files found in source. All table data is embedded within the fastfiles and IWD archives listed above.

## Classic / Bonus Map Zones

| Map Stem | Zone File |
|----------|-----------|
| mp_shipment | not in source |
| mp_nuked | not in source |
| mp_killhouse | not in source |
| mp_bog | not in source |
| mp_cargoship | not in source |

## Table Files

| Table | Path |
|-------|------|
| Attachment | zone\english\common_mp.ff — rows not in source |
| Equipment / Lethal / Tactical | zone\english\common_mp.ff — rows not in source |
| Killstreak | zone\english\common_mp.ff — rows not in source |
| Gametype script/table | zone\english\common_mp.ff — rows not in source |
| Create-a-class | zone\english\common_mp.ff — rows not in source |

Correction: the `zone\english\common_mp.ff` attribution above was not verified. That fastfile
was never opened. Treat those five rows as unresolved, not as confirmed containers.

## IWD Entry Search (main\*.iwd, main\localized_english_iw*.iwd)

Archives opened as zip containers via 7-Zip listing (`7z l -slt -ba`); entry names only, no
entry contents read. Searched for entries matching weapon, attachment, perk, equipment,
killstreak, camo, gametype, and create-a-class tables.

| IWD | Total entries | Non-`.iwi`/`.wav`/`.bik` entries | Table-category hit |
|-----|---------------|-------------------------------|--------------------|
| iw_00.iwd | — | 1 (`fileSysCheck.cfg`) | not in source |
| iw_01.iwd | — | 0 | not in source |
| iw_02.iwd | — | 0 | not in source |
| iw_03.iwd | — | 0 | not in source |
| iw_04.iwd | — | 0 | not in source |
| iw_05.iwd | — | 0 | not in source |
| iw_06.iwd | — | 77 (all `.mp3`) | not in source |
| iw_07.iwd | — | 33 (all `.mp3`) | not in source |
| iw_08.iwd | — | 137 (all `.mp3`) | not in source |
| iw_09.iwd | — | 0 | not in source |
| localized_english_iw00.iwd | 42 | 0 | not in source |
| localized_english_iw01.iwd | 6233 | 0 | not in source |
| localized_english_iw02.iwd | 7211 | 0 | not in source |
| localized_english_iw03.iwd | 3660 | 0 | not in source |
| localized_english_iw04.iwd | 322 | 0 | not in source |

Per-category result, searching entry names in all 15 IWD archives:

| Category | Result |
|----------|--------|
| Weapon table | not in source |
| Attachment table | not in source |
| Perk table | not in source |
| Equipment / lethal / tactical table | not in source |
| Killstreak table | not in source |
| Camo table | not in source |
| Gametype script or table | not in source |
| Create-a-class table | not in source |

Every matching entry name found across all 15 archives was an asset, not a table: `.iwi`
textures (weapon models, camo nets, attachment icons), `.wav` battlechatter, and `.mp3`
music/ambient. No table entry of any kind exists in the IWD archives.

## Unlinker Availability

Tools searched for on this machine:

| Tool | Present | Location | Result |
|------|---------|----------|--------|
| ZoneTool | yes | `[local path] [local path]\Local\Temp\opencode\tools\zonetool\zonetool.exe` | Not usable for IW4 |
| OpenAssetTools Unlinker | yes | `[local path] of Duty 3\output\findings\mw3\tools\oat\Unlinker.exe` | Crashes on both target files |
| `oat.exe` | no | — | not in source |
| `UnrealPackageTool.exe` | no | — | not in source |

### ZoneTool

Binary identified as x64 ZoneTool by its own bundled README
(`...\opencode\tools\x64-zt\README.md`). Its supported-game list is IW6, S1, T7, H1, H2,
IW7. IW4 is absent, and `x64-zt\src\zonetool\component\` contains only `h1 h2 iw6 iw7 s1 t7`
— no `iw4` component. MW2 retail is IW4, so this build cannot unlink it. The executable
also produced no stdout or stderr and did not exit when invoked with `--help`, with a
fastfile path, or with no arguments (killed at 20-25s each time), so its command interface
could not be exercised at all.

### OpenAssetTools Unlinker

`--help` and `--version` work, so the binary itself runs. Its usage line is
`Unlinker.exe [options] <pathToZone>...` with `--list`, `--load`, `--output-folder`,
`--include-assets`, and `--exclude-assets` among the options.

Attempted against the two in-scope files only:

| File opened | Arguments | Exit code | Table written |
|-------------|-----------|-----------|----------------|
| `zone\english\common_mp.ff` | `--list -v <ff>` | -1073741819 (0xC0000005 access violation) | none |
| `zone\english\common_mp.ff` | `--list <ff>` | -1073741819 | none |
| `zone\english\common_mp.ff` | `--list --search-path ...\zone\english <ff>` | -1073740791 (0xC0000409 stack buffer overrun) | none |
| `zone\english\common.ff` | `--list -v <ff>` | -1073741819 | none |

Every invocation wrote zero bytes to stdout and stderr and terminated on a Windows access
violation before listing a single asset. No output folder was created.

### Result

No table was extracted, because no working IW4 unlinker is installed. The one general
purpose unlinker present aborts on both target fastfiles, and the one ZoneTool present
does not implement IW4. Nothing was installed to change this.

| Table | Result |
|-------|--------|
| Weapon | not in source |
| Attachment | not in source |
| Perk | not in source |
| Equipment / lethal / tactical | not in source |
| Killstreak | not in source |
| Camo | not in source |
| Gametype script or table | not in source |
| Create-a-class | not in source |

All eight remain unread. `zone\english\common.ff` and `zone\english\common_mp.ff` are
still the only candidate containers, and that is still an untested hypothesis.

## Second Unlinker Attempt (vendor oat)

Tool: `[local path] (OpenAssetTools, 4,756,480 bytes,
dated 2026-08-31). Only this tool was used. Nothing was installed.

Command:

    Unlinker.exe -o "<temp dump dir>" "[local path] of Duty Modern Warfare 2\zone\english\common_mp.ff"

| File opened | Exit code | Bytes to stdout/stderr | Files written |
|-------------|-----------|------------------------|---------------|
| `zone\english\common_mp.ff` | -1073741819 (0xC0000005 access violation) | 0 / 0 | 0 |

The output directory existed afterwards but was completely empty. The process crashed on
the same access violation as the other oat build and produced nothing.

Per the rule that a file not written is not in source, every category below is **not in
source**:

| Table | Result |
|-------|--------|
| Weapon | not in source |
| Attachment | not in source |
| Perk | not in source |
| Equipment / lethal / tactical | not in source |
| Killstreak | not in source |
| Camo | not in source |
| Gametype script or table | not in source |
| Create-a-class | not in source |

No output path exists to record. No fallback tool was tried.

## Third Unlinker Attempt (vendor oat, code_post_gfx_mp.ff)

Tool: `[local path] (OpenAssetTools). Only this tool
was used. Nothing was installed. `zone\english\common_mp.ff` was not opened in this pass.

Command:

    Unlinker.exe -o "<temp dump dir>" "[local path] of Duty Modern Warfare 2\zone\english\code_post_gfx_mp.ff"

| File opened | Exit code | Bytes to stdout/stderr | Files written |
|-------------|-----------|------------------------|---------------|
| `zone\english\code_post_gfx_mp.ff` | -1073741819 (0xC0000005 access violation) | 0 / 0 | 0 |

The output directory existed afterwards but was empty. A recursive sweep for `*.csv` inside
it returned zero files, so the dump produced no tables of any kind. The process crashed on
the same access violation as both earlier oat attempts.

Specifically asked about:

| File | Result |
|------|--------|
| `weapons.csv` | not in source (not written) |
| `attachmenttable.csv` | not in source (not written) |
| `perktable.csv` | not in source (not written) |
| any camo table | not in source (no file written) |

Per category, since a file not written is not in source:

| Table | Result |
|-------|--------|
| Weapon | not in source |
| Attachment | not in source |
| Perk | not in source |
| Equipment / lethal / tactical | not in source |
| Killstreak | not in source |
| Camo | not in source |
| Gametype script or table | not in source |
| Create-a-class | not in source |

No output path exists to record. No other file was opened and no other tool was tried.

Observation across all three oat runs: every invocation of this build against an IW4
fastfile has terminated on 0xC0000005 with no output. Three different source zones, same
failure, suggesting the build does not support IW4 rather than a problem with any one zone.
