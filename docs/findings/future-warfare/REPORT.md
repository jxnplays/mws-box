# REPORT - NX1 "Call of Duty: Future Warfare" multiplayer content extraction

Target: `E:\Call of Duty Future Warfare\NX1` (cancelled Neversoft Xbox 360 prototype, IW4/MW2 engine,
dev/debug build `Build 546 12/18/2011 21:02:16 CODEBOT3 SHOOT FOR THE STARS`).
All work was read-only against the source; every output is in `output/`.

## 1. What was found (headline)

The single richest source was **not** the executables or the fastfiles, but a set of files named
`save/*.svg` and `save/autosave/*.svg`. Despite the extension these are **binary memory/crash dumps**
of the running multiplayer build. They contain large regions of the actual **GSC script source**, the
complete weapon/perk/killstreak/gametype name sets, character/faction names, and the data-table
references. The second richest source was the `.map`/`.pdb` symbol tables (277,082 symbols, 18,355
unique decoded string literals).

Result: the multiplayer feature set is **substantially recoverable**. The NX1-specific weapon roster,
~110 perks, the killstreak roster, the gametype list, the factions/characters and the script module
layout are all directly evidenced.

## 2. Method (what was actually run)

1. **Inventory** - recursive listing with size + SHA-1 for all 28,579 source files (13.72 GB) ->
   `output/inventory.csv`.
2. **Symbols** - parsed the 8 `.map` linker files (streamed, .NET) -> 277,082 symbols;
   decoded the C++ string literals -> `output/symbol_strings.txt` (18,355) and
   `output/symbols_mp.txt` (117,915 MP-related).
3. **Debug symbols** - carved the 4 `.pdb` files -> `output/pdb_strings.txt`,
   decoded literals -> `output/pdb_decoded_strings.txt` (17,880).
4. **Strings** - carved ASCII + UTF-16BE from `.map`, `.pdb`, `.xex` with byte offsets ->
   `output/raw_strings_mp.txt` (222,841 lines).
5. **Fastfiles** - identified the container (`NXff0100` MP / `NXffu100` SP, 38-byte header, nested
   `NXffs100`), wrote a sequential zlib-block extractor (`output/extract_seq.ps1`) and unpacked all
   86 `.ff`/`.ffm` into `output/unpacked/<fastfile>/block_XXXXXXXX.bin`
   (manifest: `output/fastfile_extraction_manifest.csv`).
6. **Logs / dvars** - parsed `console_mp.log` -> 623 unique dvars -> `output/dvars.csv`.
7. **Memory dumps** - carved `save/*.svg` -> `output/save_svg_strings.txt` (82,931 strings).
8. **Catalogues** - built the CSV catalogues and `output/multiplayer_catalog.json`.

## 3. Counts per category

| Category | Count | File | Confidence |
|---|---|---|---|
| Builds (executables) | 8 (3 distinct MP, 3 distinct SP, 2 duplicates) | `builds.csv` | confirmed |
| MP maps (fastfiles) | 28 | `maps.csv` | confirmed |
| SP maps (fastfiles) | 10 | (in `inventory.csv`) | confirmed |
| Gametypes | 24 identified | `gametypes.csv` | confirmed/likely/uncertain |
| Weapons + equipment | 64 | `weapons.csv` | confirmed |
| Attachments | 21 | `attachments.csv` | confirmed |
| Perks / specialties | 124 | `perks.csv` | confirmed |
| Killstreaks | 36 | `killstreaks.csv` | confirmed |
| Vehicles / deployables | 11 | `vehicles.csv` | confirmed |
| Factions / characters | 21 factions + 23 characters | `factions.csv`, `characters.csv` | confirmed |
| Dvars (with defaults) | 623 | `dvars.csv` | confirmed |
| Rank/XP/class tables | 28 | `ranks_xp.csv` | confirmed (table names) / uncertain (values) |
| Create-a-class | 11 | `classes.csv` | likely |
| MP string literals (decoded) | 18,355 (map) + 17,880 (pdb) | `symbol_strings.txt`, `pdb_decoded_strings.txt` | confirmed |
| MP strings with offsets | 222,841 | `raw_strings_mp.txt` | confirmed |
| Memory-dump strings | 82,931 | `save_svg_strings.txt` | confirmed |
| Fastfile blocks unpacked | 100,839 blocks / 9.02 GB | `unpacked/` | confirmed |

## 4. Key confirmed findings

### Weapons (internal names, from `case "..."` switch + `_mp` assets + script source)
NX1-specific: `scar`, `scar2` (SCAR Mod 2), `asmk27` (Atlas Mk.27), `xm108` (XM108 SEAR), `ecr`,
`fal`, `type104`, `augks`, `ffar`, `abg`, `ajax`, `pulserifle`, `laserrifle`, `lasersniper`, `glo`
(G-LO), `needler`, `sonic_warden`, `xm25`, `xm25ks`, `m79`, `m320`, `srm1216`, `ksg`, `cheytac`,
`coltanaconda`, `beretta393`.
Legacy/ported (present in the switch): `aa12`, `mp5`, `ump45`, `p90`, `rpd`, `m240`, `m21`, `m1014`,
`spas12`, `barrett`, `glock`, `beretta`, `at4`, `rpg`, `javelin`, `stinger`, `socom_141`.
Space/vacuum set: `vacuum_shotgun`, `vacuum_railgun`, `lunarrifle`, `vacuum_bullet_*`.
Shields: `riotshield`, `riotshieldcloak` (Cloaking Shield), `riotshieldcover` (Deployable Shield),
`riotshieldxray`.

### Perks
124 `specialty_*` entries, including NX1 suits (`specialty_moonsuit`, `specialty_jetsuit`,
`specialty_agisuit`, `specialty_tacsuit`, `specialty_stealthsuit`, `specialty_juggersuit`,
`specialty_spectre`, `specialty_spectrepro`) and many new utility perks
(`specialty_xrayvision`, `specialty_grapplinghook`, `specialty_equipmenthack`, `specialty_blackbox`,
`specialty_disruptor`, `specialty_combathigh`, `specialty_endgame`, `specialty_siege`,
`specialty_rollover`, `specialty_saboteur`, `specialty_challenger`, `specialty_marksman`,
`specialty_loaded`, `specialty_juiced`, `specialty_dishclip`, `specialty_steelnerves`,
`specialty_netpainkiller`, `specialty_autospot`, `specialty_paint`, `specialty_paint_pro`,
`specialty_delaymine`, `specialty_rechargetest`, `specialty_fasterlockon`, `specialty_localjammer`,
`specialty_c4death`, `specialty_concussiongrenade`, `specialty_gasmask`, `specialty_blastshield`,
`specialty_rearview`, `specialty_primarydeath`, `specialty_laststandoffhand`, `specialty_marathonholder`,
`specialty_ninjaholder`, `specialty_quickdrawholder`, `specialty_twoprimariesholder/lethal/offhand`).
Perk effects are driven by `perk_*` dvars (e.g. `perk_agiSprintSpeedScale=1.0`,
`perk_juggerSprintSpeedScale=0.5`, `perk_blastShield=65`, `perk_armorPiercingDamage=40`).

### Killstreaks
Script modules `maps/mp/killstreaks/_*.gsc`: `_ac130`, `_airdrop`, `_airstrike`, `_autosentry`,
`_blueshell`, `_emp`, `_exosuit`, `_harrier`, `_helicopter`, `_jet`, `_killstreaks`, `_lockseekdie`,
`_nuke`, `_reaper`, `_remotemissile`, `_rodsofgod`, `_spider`, `_uav`, `_weapdrop`.
Named streaks: care package / mega airdrop, precision / stealth / super airstrike, counter-UAV /
double UAV / UAV / UAV strike, EMP, harrier, attack helicopter (flares / minigun / mk19 / blackbox),
Lock-Seek-Die ("Night Raven"), nuke, Reaper, remote mortar, remote missile, sentry gun, **Exosuit**,
**Spider**, Blue Shell, Rods of God, civilian jet, weapon drop, Predator missile, Pave Low, AC-130.
`mp/killstreakTable.csv` is the authoritative table (referenced in source).

### Gametypes
Confirmed in script switch / dvars / spawn classes: `dm`, `war`, `dom`, `ctf`, `sd`, `sab`, `dd`,
`escort`, `escortplus`, `mtdm`, `hvt`, `koth`, `hardpoint`, `hc`, `wargasm` (joke/test), plus the
legacy dvar-only sets `arena`, `convoy`, `cwtest`, `gg`, `glad`, `gtnw`, `merc`, `oneflag`, `vip`.
Spawn classes found in `z_mymapents.tmp`:
`mp_dm_spawn`, `mp_tdm_spawn`, `mp_dom_spawn`, `mp_ctf_spawn`, `mp_sd_spawn`, `mp_sab_spawn`,
`mp_dd_spawn`, `mp_escort_spawn`, `mp_mtdm_spawn_team_0..8`, `mp_global_intermission`.
Escort is the UGV mode (Trophy System, checkpoints: `CG_IsSelectingUGVLocation`,
`CGAME_SB_CHECKPOINTS`, `selecting_ugv_location`).

### Factions / characters
`nx_us` (army / pres / space / specops / secret service), `nx_ec` / `nx_ec_*` (Eastern Coalition),
`seals_udt`, `socom_141`, `militia`; runtime team icons `faction_128_seals` (Allies, `MP_US_NAME`)
and `faction_128_arab` (Axis/Eastern Coalition, `MP_EC_NAME`).
Character suit variants: `_marathon`, `_hardline`, `_ninja`, `_trophy`, `_hulc`, `_space`.

### Low-gravity / space
`player_moon_grav_*` (scale 0.25, jump boost 1.18, air-control 1.35), `jump_lunar_boost_rel_lvl1/2/3`,
`setmoongravity`, `environment_moon`, `enablemoonhelmethud`, `overlay_moon_helmet_mp`,
`enablelunarrocketman`, `lunar_rover`, `NX/NX_SPACE/amb_space_suit_helmet.xma2`.

### Balance data actually read from the dumps
- `ac130model.maxhealth = 1000`
- `chopper.health = 500`, `chopper.maxhealth = level._heli_maxhealth*2`, `SetMaxPitchRoll(45,85)`
- `giveRankXP("kill", 50/100/300/400)`
- `// 7x damage for explosives - GRENADES`
- `// Chad - ask Brent why we think melee is worth 100000 damage`
- `// radius of bomb damage is 512`
- `// Sprint Speed 13.0-14.0`
- `bg_fallDamageMaxHeight=300`, `bg_fallDamageMinHeight=128`
- `scr_player_maxhealth=100`, `scr_player_healthregentime=5`, `scr_player_sprinttime=4`, `jump_height=39`, `g_gravity=800`
- gas cloud: `scr_gasCloudDuration=8`, `scr_gasCloudRadius=185`, `scr_gasCloudTickDamage=13`
- EMP grenade: `scr_empGrenadeTime=7.0`, `scr_empGrenadeRadius=500`
- LIDAR: `scr_LIDARPulseRadius=350`, `scr_LIDARNumTicks=6.0`, `scr_LIDARTickTime=1.0`
- `scr_riotShieldXPBullets=15`

## 5. Confirmed-absent features (with the search that shows it)

Searches were run over `output/symbol_strings.txt` + `output/pdb_decoded_strings.txt` +
`output/save_svg_strings.txt` + `output/raw_strings_mp.txt` (substring, case-insensitive).

| Claimed item | Search | Result |
|---|---|---|
| HERA-82 | `hera` | only `r_otherAllocator` false positive - **not found** |
| Type 207 | `type207` / `type 207` | **not found** |
| Lancer | `lancer` | **not found** |
| ESR | `esr` | **not found** (but `laserrifle`, `lasersniper` exist) |
| Sealant | `sealant` | **not found** |
| Sticky Grenade Launcher | `sticky` | only `Vehicle_AttachedStickyMissile` (engine code) - **not found as a weapon**; `abg` / `m320` launchers exist instead |
| Cloaking Shield | `cloaking shield` | phrase not found; mechanic confirmed (`gp_rdvar_cloaking_enabled`, `Enable/Disable cloaking`) and asset `riotshieldcloak_mp` exists |
| Deployable Shield | `deployable shield` | phrase not found; asset `riotshieldcover_mp` exists |
| "The Emergent War" / Clan Wars | `emergent` / `clan war` | **not found**; the only Clan-Wars-like entry is the `cwtest` dvar set |
| Moon map (as a named MP map) | `mp_nx_` list | no moon/lunar MP map fastfile; moon mechanics are shared SP/MP |
| Dedicated-server MP build | executable list | no separate MP dedicated server XEX; `nx1sp_fast_server` is SP and `6-nx1mp_fast_server.pe` is the x86 fast server |

## 6. Confidence key

- **confirmed** - the string/asset/script/dvar is directly present in a source file (cited).
- **likely** - inferred from a naming convention, a partial asset (e.g. `weapon` case without full def),
  or a single weak reference; marked `inferred=yes` / `likely` in the CSVs.
- **uncertain** - minimal or ambiguous evidence (e.g. gametypes known only from a dvar prefix with no
  script switch); listed as `uncertain`.

## 7. Coverage - every source file accounted for

`output/coverage.csv` marks each of the 28,578 files in `inventory.csv` as **processed**, **skipped**,
or **unresolved**:

| Status | Count | Meaning |
|---|---|---|
| processed | 131 | `.map` (8), `.pdb` (4), `.xex` (8), `.ff`/`.ffm` (86), `.log` (4), `.svg` (16), `.csv` (2), `.txt` (1), `.tmp` (1), `.pe` (1) |
| skipped | 28,447 | `.xma2` (28,177) and `.xps` (249) audio - filenames used for cataloguing, audio not decoded; `.bik` (16) video; `.cache`/`.history`/0-byte placeholders (5) |
| unresolved | 0 | (the format-level issues are documented in `unresolved.md`; no file was dropped) |

Every `.ff`/`.ffm` is listed in `output/fastfile_extraction_manifest.csv` with its block count and
decompressed size. Every `.xma2`/`.xps` filename is retained in `inventory.csv` and the MP ones are
cited in `weapons.csv` / `killstreaks.csv` / `vehicles.csv`.

## 8. Limitations / next steps (see `unresolved.md`)

- XEX code sections are LZX-compressed and were not decompressed (the `.map`/`.pdb` cover the same symbols).
- The fastfile `NXffs100` asset index is not parsed, so the `mp/*.csv` stat tables (damage, fire rate,
  unlock levels) were not recovered as values; only their names, schemas and column indices.
- Localized display strings (`ez_*_english_mp`) are missing from the folder, so English names are not available.
- The `.svg` memory dumps are fragmented; only strings, not whole files, were carved.
