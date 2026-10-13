# Unresolved files / formats

This lists everything that could not be fully decoded, the reason, and the next step that would be tried.
Nothing here is skipped silently: every file class is either processed, skipped-as-identical, or listed below.

## 1. XEX executables (8 files)
- **Files:** `2-nx1mp.xex`, `0-Nightly MP maps.mp.xex`, `5-nx1mp_demo.xex`, `6-nx1mp_fast_server.xex`, `0-Convoy Test 1_5.mp.xex`, `1-nx1sp.xex`, `3-nx1sp_fast_server.xex`, `4-nx1sp_demo.xex`
- **Reason:** Xbox 360 XEX2 container with compressed (LZX) code/data sections. Only the uncompressed
  import/string sections are readable; the bulk of the strings are compressed. Carving yields mostly
  high-entropy noise.
- **What worked:** the internal build name (`nx1mp_Test.exe`, `nx1mp_Demo.exe`, `nx1sp_Test.exe`, etc.)
  and a handful of MP tokens (`MP_`, `UAV`, `UGV`, `EMP`) in uncompressed regions.
- **Next step:** decompress the XEX with `xextool`/`xex1tool`/`Xbox360 XEX decompressor`, or use the
  matching `.map` + `.pdb` (already fully extracted) which expose the same symbols uncompressed.

## 2. PDB debug files (4 files)
- **Files:** `0-Convoy Test 1_5.mp.pdb`, `0-Nightly MP maps.mp.pdb`, `5-nx1mp_demo.pdb`, `6-nx1mp_fast_server.pdb`
- **Reason:** custom Xbox 360 PDB layout (not a standard MSF/`RSDS` stream). Carving recovers the
  mangled C++ symbol table and string literals, but the type/line information is not parsed.
- **What worked:** 155k-229k raw strings each; decoded 17,880 unique C++ string literals
  (`output/pdb_decoded_strings.txt`).
- **Next step:** feed the PDBs to a 360-aware PDB parser (e.g. the MSF/`pdbparse` variant used for
  Xenon) to recover function addresses and types.

## 3. Fastfile outer container (`NXff0100` / `NXffu100`)
- **Files:** 34 `.ff` + 52 `.ffm`.
- **Reason:** the outer container is a 38-byte header followed by `NXffs100` (MP) or a zlib stream (SP).
  The MP variants embed **many** small zlib streams (the assets). The `NXffs100` block directory /
  asset index is not fully understood, so we extract by scanning.
- **What worked:** sequential zlib-block extraction (see `output/extract_seq.ps1`) recovers 100-250 MB
  of decompressed data per map fastfile (`output/unpacked/<fastfile>/block_XXXXXXXX.bin`). The `_load`
  fastfiles decompress cleanly to ~502 KB each (load-screen assets).
- **Not fully resolved:**
  - The high-entropy region between the header and the first zlib stream in the small `*_mp.ff` files
    (e.g. `code_pre_gfx_mp.ff` offsets 46-16422) is not zlib and was not identified.
  - A few blocks hit the 32 MB cap (`capped=1` in `fastfile_extraction_manifest.csv`) and were truncated.
  - The asset index (mapping block -> asset name) is not parsed, so blocks are named by file offset.
- **Next step:** reverse the `NXffs100` block directory (likely a table of `{offset, compressedSize,
  uncompressedSize}` entries) and the second-stage compression used for the non-zlib region.

## 4. Compiled GSC bytecode inside fastfiles
- **Reason:** the MP scripts (`maps/mp/gametypes/*.gsc`, `maps/mp/killstreaks/*.gsc`) are stored as
  compiled bytecode. The extracted fastfile blocks contain fragments of the source (comments, function
  names, string literals) but not clean, complete scripts.
- **What worked:** the `.svg` memory dumps (see below) contain large fragments of the **source text**.
- **Next step:** locate and decompile the GSC bytecode (IW4 script VM), or reconstruct the source from
  the `.svg` memory dumps.

## 5. `save/*.svg` and `save/autosave/*.svg` memory dumps
- **Files:** `mp_nx_fallout_dm_5461.svg`, `mp_nx_galleria_dm_5461.svg`, `mp_nx_galleria_war_5461.svg`,
  `mp_nx_pitstop_dm_5461.svg`, `mp_nx_pitstop_dm_5462.svg`, `mp_nx_pitstop_war_5461.svg`,
  `mp_nx_skylab_war_5461.svg`, `mp_nx_stasis_dm_5461.svg`, `mp_nx_fallout_dm_5462.svg`,
  plus `save/autosave/assert_mp1-4.svg`, `error_mp1-3.svg`.
- **Reason:** despite the `.svg` extension these are **binary memory/crash dumps**, not SVG images. They
  contain the map name, the build string, the gametype, and large regions of game script source and
  data, but the memory is fragmented (no file table), so complete files cannot be carved cleanly.
- **What worked:** 82,931 unique ASCII strings, including the complete MP weapon/perk/killstreak/gametype
  name sets, the script module list, character/faction names, and data-table references.
  Saved to `output/save_svg_strings.txt`.
- **Next step:** parse the dump header (`00 00 04 30 ...`) and the internal region table to recover
  contiguous allocations (scripts, CSVs) as whole files.

## 6. Audio (`.xma2`, `.xps`)
- **Files:** 28,177 `.xma2` + 249 `.xps`.
- **Reason:** Xbox 360 XMA/XMA2 (and `.xps` companion) audio. We catalogued names/sizes but did not
  decode the audio (out of scope for data extraction; not needed to identify MP content).
- **What worked:** the file names encode the MP content (e.g. `MP/mp_killstrk_*.xma2`,
  `VEHICLES/nx_miniuav_multiplayer.xma2`, `WEAPONS/GRENADE/weap_flashbang_tone.xma2`).
- **Next step:** decode with `xma2wav`/`vgmstream` if audio content is needed.

## 7. Video (`.bik`) and caches
- **Files:** 16 `.bik` (Bink video), `demo.cache`, `markHistory.cache`, `timeHistory.cache`,
  `time.history`, `games_mp.log` (0 bytes).
- **Reason:** Bink is a proprietary video codec; caches are empty or undocumented.
- **Next step:** RAD Bink tools for `.bik`; the caches appear unused (0 bytes / tiny).

## 8. Localized string fastfiles
- **Referenced but missing:** `ez_common_english_mp`, `ez_ui_english_mp`, `dlc1_ui_mp`, `dlc2_ui_mp`
  (loaded by `console_mp.log` but not present on disk). Only `ez_common_mp.ffm` / `ez_ui_mp.ffm`
  (24,614-byte stubs) exist.
- **Consequence:** display names for weapons/perks/maps (the localized `@` strings) could not be read.
  The keys (`MP_US_NAME`, `MP_EC_NAME`, `MP_UNKNOWN_PLAYER`, ...) are known but their English values
  are not in the provided files.
- **Next step:** obtain the missing `ez_*_english_mp` fastfiles, or read the `.str`/localize files from
  the retail/localized build.

## 9. Weapon stat tables (damage, fire rate, ...)
- **Reason:** the data tables (`mp/statstable.csv`, `mp/attachmentTable.csv`, `mp/perkTable.csv`,
  `mp/killstreakTable.csv`, `mp/rankTable.csv`, `mp/classTable.csv`, `mp/factionTable.csv`,
  `mp/buffTable.csv`, `mp/exosuitTable.csv`, `mp/camoTable.csv`, `mp/attachmentCombos.csv`,
  `mp/awardTable.csv`, `mp/allChallengesTable.csv`, `mp/splashTable.csv`, `mp/MTDMTable.csv`) are
  referenced by the scripts but are **not present as standalone files**; they live inside the fastfiles.
  The fastfile blocks are binary and the CSV structure was not recovered.
- **What worked:** the table schemas and column indices are visible in the script source
  (e.g. `tableLookup("mp/perkTable.csv", 1, perkName, 5) != "equipment"`,
  `tableLookup("mp/attachmentTable.csv", 9, index, 4)`, `mp/ranktable.csv` cols 1/2/3/7/16).
- **Next step:** extract the CSV assets from `common_mp.ffm` / the map fastfiles by parsing the
  `NXffs100` asset index (same task as item 3).

## 10. `6-nx1mp_fast_server.pe`
- **Reason:** a 10.6 MB `MZ` PE (Windows x86) build artifact of the fast server. It is a different
  architecture from the XEX and its sections are compressed/unmapped.
- **Next step:** run a normal PE analysis (dumpbin/objdump) if the desktop build is of interest.

---

## Appendix A - Verification pass (2026-10-06)

### A.1 `save/*.svg` are binary dumps, not images
File `save/mp_nx_pitstop_dm_5461.svg` (5,997,761 bytes), first 32 bytes:

```
00 00 04 30 00 00 00 00 C2 DA C4 5C 00 00 00 00 01 00 00 00 48 75 47 EF 00 07 DC 64 00 07 FD 31
```

No image signature (PNG `89 50 4E 47`, JPEG `FF D8 FF`, GIF `47 49 46 38`, BMP `42 4D`, SVG text
`<?xml` / `<svg`). The in-file line terminator is `0D 00` (CR + NUL).
**Confirmed: binary memory dump, not an image.**

### A.2 Full GSC function body test
- `output/save_svg_strings.txt` is an alphabetically **sorted set of individual source lines** (the
  carver split on the `0D 00` terminator). It contains statements, conditions, comments and calls, but
  **no contiguous function body** -> for that artifact the "GSC source" claim is **strings only**.
- The **raw** `.svg` dump does contain contiguous GSC function bodies. Read-only quote from
  `mp_nx_pitstop_dm_5461.svg` at offset 441633:

```
onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		player thread onPlayerSpawned();
	}
}
```

  (immediately followed in the same dump by `onPlayerSpawned() { self endon( "disconnect" ); ... }`)
- Verdict: **GSC source is confirmed in the raw dumps**; the committed `save_svg_strings.txt`
  under-represents it and must be treated as **strings-only**. Recovering full bodies requires
  re-scanning the raw `.svg` files using the `0D 00` line terminator (not done in this pass).

### A.3 `weapons.csv` spot check (64 rows confirmed)
| name | occurrences found | nature |
|---|---|---|
| `scar2` | `scar2_reflex_mp` (engine string const in `cg_hudelem.obj`) + `case "scar2":` | **asset name** (attachment variant) + script case label |
| `pulserifle` | `case "pulserifle":` only (1 hit) | **one string hit** - not confirmed as an asset |
| `vacuum_shotgun` | `vacuum_shotgun` + `vacuum_shotgun_explode` (`bg_weapons_util.obj`) and `IMPACT_TYPE_VACUUM_SHOTGUN` / `IMPACT_TYPE_VACUUM_SHOTGUN_EXPLODE` | **asset / impact-type name** (engine-referenced) |

Action: `pulserifle` should be downgraded from `confirmed` to `uncertain` (script case label only, no
asset reference found). `scar2` and `vacuum_shotgun` stand as confirmed assets.

### A.4 `perks.csv` spot check - `specialty_moonsuit`
- `specialty_moonsuit` appears as an engine string constant in `bg_perks_mp.obj` (multiple occurrences)
  and as a real script call `maps\mp\perks\_perks::givePerk( "specialty_moonsuit" );`.
- Verdict: **confirmed** perk internal name (engine symbol + live script call), not a single string hit.
