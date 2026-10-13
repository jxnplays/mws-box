# Ghosts Retail Folder Findings

Source folder opened: `[local path] of Duty Ghosts`

Opened **read-only**. This pass is a directory listing plus a single 64-byte read of one file.
No `.ff` was decoded, no reader was written, nothing was launched or rebuilt, and no asset was
copied into the project.

Top level contains three folders: `APEX\`, `english\`, `main\`. No `usermaps\`, `mods\`,
`plutonium\`, or DLC directories are present. Clean retail install.

Zone (`.ff`) containers seen: **722** at the top level and **145** in `english\` — **867** total.

**Naming warning, same as the earlier scan:** `mp_` is not a map namespace. Of the 455 `mp_*`
stems, only 36 are map stems; the other 419 are character/weapon assets. A map stem is the one
that also has a `_load` and a `_path` twin. This document keeps multiplayer, Extinction, and
campaign zones in separate lists and does not call any non-map file a multiplayer map.

---

## Multiplayer zone files

### Multiplayer map zones (31)

Each stem below has a base `.ff`, a `<stem>_load.ff`, and a `<stem>_path.ff` in the same folder.
The 5 Extinction maps are listed separately below, not here.

| Map stem | Zone file read |
|---|---|
| mp_battery3 | `[local path] of Duty Ghosts\mp_battery3.ff` |
| mp_boneyard_ns | `[local path] of Duty Ghosts\mp_boneyard_ns.ff` |
| mp_ca_behemoth | `[local path] of Duty Ghosts\mp_ca_behemoth.ff` |
| mp_ca_impact | `[local path] of Duty Ghosts\mp_ca_impact.ff` |
| mp_ca_red_river | `[local path] of Duty Ghosts\mp_ca_red_river.ff` |
| mp_ca_rumble | `[local path] of Duty Ghosts\mp_ca_rumble.ff` |
| mp_chasm | `[local path] of Duty Ghosts\mp_chasm.ff` |
| mp_conflict | `[local path] of Duty Ghosts\mp_conflict.ff` |
| mp_dart | `[local path] of Duty Ghosts\mp_dart.ff` |
| mp_descent_new | `[local path] of Duty Ghosts\mp_descent_new.ff` |
| mp_dig | `[local path] of Duty Ghosts\mp_dig.ff` |
| mp_dome_ns | `[local path] of Duty Ghosts\mp_dome_ns.ff` |
| mp_fahrenheit | `[local path] of Duty Ghosts\mp_fahrenheit.ff` |
| mp_favela_iw6 | `[local path] of Duty Ghosts\mp_favela_iw6.ff` |
| mp_flooded | `[local path] of Duty Ghosts\mp_flooded.ff` |
| mp_frag | `[local path] of Duty Ghosts\mp_frag.ff` |
| mp_hashima | `[local path] of Duty Ghosts\mp_hashima.ff` |
| mp_lonestar | `[local path] of Duty Ghosts\mp_lonestar.ff` |
| mp_mine | `[local path] of Duty Ghosts\mp_mine.ff` |
| mp_pirate | `[local path] of Duty Ghosts\mp_pirate.ff` |
| mp_prisonbreak | `[local path] of Duty Ghosts\mp_prisonbreak.ff` |
| mp_shipment_ns | `[local path] of Duty Ghosts\mp_shipment_ns.ff` |
| mp_skeleton | `[local path] of Duty Ghosts\mp_skeleton.ff` |
| mp_snow | `[local path] of Duty Ghosts\mp_snow.ff` |
| mp_sovereign | `[local path] of Duty Ghosts\mp_sovereign.ff` |
| mp_strikezone | `[local path] of Duty Ghosts\mp_strikezone.ff` |
| mp_swamp | `[local path] of Duty Ghosts\mp_swamp.ff` |
| mp_warhawk | `[local path] of Duty Ghosts\mp_warhawk.ff` |
| mp_zebra | `[local path] of Duty Ghosts\mp_zebra.ff` |
| mp_zerosub | `[local path] of Duty Ghosts\mp_zerosub.ff` |
| mp_zulu | `[local path] of Duty Ghosts\mp_zulu.ff` |

Map companion zones (not maps): the 31 stems above each also have `mp_<stem>_load.ff` and
`mp_<stem>_path.ff`, i.e. 62 further files, e.g.
`[local path] of Duty Ghosts\mp_warhawk_load.ff` and
`[local path] of Duty Ghosts\mp_warhawk_path.ff`.

### Multiplayer non-map zones (root)

These are multiplayer zones but they are **not maps**:

| Zone file | Path |
|---|---|
| code_nvidia_mp.ff | `[local path] of Duty Ghosts\code_nvidia_mp.ff` |
| code_post_gfx_mp.ff | `[local path] of Duty Ghosts\code_post_gfx_mp.ff` |
| code_pre_gfx_mp.ff | `[local path] of Duty Ghosts\code_pre_gfx_mp.ff` |
| common_mp.ff | `[local path] of Duty Ghosts\common_mp.ff` |
| common_core_mp.ff | `[local path] of Duty Ghosts\common_core_mp.ff` |
| common_core_dlc_updated_mp.ff | `[local path] of Duty Ghosts\common_core_dlc_updated_mp.ff` |
| common_bots_mp.ff | `[local path] of Duty Ghosts\common_bots_mp.ff` |
| common_bots_fireteam_mp.ff | `[local path] of Duty Ghosts\common_bots_fireteam_mp.ff` |
| development_mp.ff | `[local path] of Duty Ghosts\development_mp.ff` |
| ui_mp.ff | `[local path] of Duty Ghosts\ui_mp.ff` |
| patch_ui_mp.ff | `[local path] of Duty Ghosts\patch_ui_mp.ff` |
| patch_common_mp.ff | `[local path] of Duty Ghosts\patch_common_mp.ff` |
| patch_common_core_mp.ff | `[local path] of Duty Ghosts\patch_common_core_mp.ff` |
| patch_common_bots_mp.ff | `[local path] of Duty Ghosts\patch_common_bots_mp.ff` |
| patch_common_vo_mtx1_mp.ff | `[local path] of Duty Ghosts\patch_common_vo_mtx1_mp.ff` |
| patch_common_vo_mtx2_mp.ff | `[local path] of Duty Ghosts\patch_common_vo_mtx2_mp.ff` |
| patch_code_post_gfx_mp.ff | `[local path] of Duty Ghosts\patch_code_post_gfx_mp.ff` |
| patch_code_pre_gfx_mp.ff | `[local path] of Duty Ghosts\patch_code_pre_gfx_mp.ff` |
| patch_mp_level_load.ff | `[local path] of Duty Ghosts\patch_mp_level_load.ff` |

Also present, one per multiplayer map stem: `patch_mp_<stem>.ff` (31 files), e.g.
`[local path] of Duty Ghosts\patch_mp_warhawk.ff`.

### Multiplayer character zones (not maps)

Counted from the listing, not enumerated here:

| Family | Count | Pattern |
|---|---:|---|
| `mp_head_*` | 306 | head/helmet models |
| `mp_body_*` | 93 | body models |
| `mp_viewhands_*` | 15 | first-person arms |
| `mp_character_room*` | 5 | `mp_character_room`, `_bodies`, `_bodies_updated`, `_dlc_updated`, `_heads` |

Example path: `[local path] of Duty Ghosts\mp_viewhands_price_tr.ff`.
Plus `patch_mp_character_room.ff` at the root.

### Multiplayer techset zones (not maps)

**39** files match `techsets_*mp*` at the root, e.g.
`[local path] of Duty Ghosts\techsets_mp_warhawk.ff` and
`[local path] of Duty Ghosts\techsets_common_core_mp.ff`.

### Localized multiplayer zones (`english\`)

**21** files in `english\` match `*_mp.ff`, e.g.
`[local path] of Duty Ghosts\english\eng_common_mp.ff` and
`[local path] of Duty Ghosts\english\eng_ui_mp.ff`.

---

## Extinction zone files

Extinction maps are `mp_alien_*`. They are **not** counted as multiplayer maps above.

| Extinction map stem | Zone file read |
|---|---|
| mp_alien_armory | `[local path] of Duty Ghosts\mp_alien_armory.ff` |
| mp_alien_beacon | `[local path] of Duty Ghosts\mp_alien_beacon.ff` |
| mp_alien_dlc3 | `[local path] of Duty Ghosts\mp_alien_dlc3.ff` |
| mp_alien_last | `[local path] of Duty Ghosts\mp_alien_last.ff` |
| mp_alien_town | `[local path] of Duty Ghosts\mp_alien_town.ff` |

Extinction companion and shared zones seen:

- `mp_alien_<stem>_load.ff` and `mp_alien_<stem>_path.ff` (10 files)
- `patch_mp_alien_<stem>.ff` (5 files)
- `techsets_mp_alien_<stem>.ff` (5 files)
- `common_alien_mp.ff`, `common_alien_dlc_updated_mp.ff`
- `patch_common_alien_mp.ff`
- `english\eng_common_alien_mp.ff`, `english\eng_common_alien_dlc_updated_mp.ff`,
  `english\eng_patch_common_alien_mp.ff`, `english\eng_mp_alien_<stem>.ff` (5),
  `english\eng_patch_mp_alien_<stem>.ff` (5)
- Extinction character assets: `mp_body_extinction_*.ff` (8), `mp_head_extinction_*.ff` (6),
  `mp_viewhands_extinction_tr.ff`

---

## Campaign zone files

Each stem below has a matching `mission_preview_<stem>.bik` in the same folder, which is the
basis for calling these campaign. They are **not** multiplayer maps.

| Campaign stem | Zone file read |
|---|---|
| black_ice | `[local path] of Duty Ghosts\black_ice.ff` |
| carrier | `[local path] of Duty Ghosts\carrier.ff` |
| clockwork | `[local path] of Duty Ghosts\clockwork.ff` |
| cornered | `[local path] of Duty Ghosts\cornered.ff` |
| deer_hunt | `[local path] of Duty Ghosts\deer_hunt.ff` |
| enemyhq | `[local path] of Duty Ghosts\enemyhq.ff` |
| factory | `[local path] of Duty Ghosts\factory.ff` |
| flood | `[local path] of Duty Ghosts\flood.ff` |
| homecoming | `[local path] of Duty Ghosts\homecoming.ff` |
| jungle_ghosts | `[local path] of Duty Ghosts\jungle_ghosts.ff` |
| las_vegas | `[local path] of Duty Ghosts\las_vegas.ff` |
| loki | `[local path] of Duty Ghosts\loki.ff` |
| nml | `[local path] of Duty Ghosts\nml.ff` |
| oilrocks | `[local path] of Duty Ghosts\oilrocks.ff` |
| prologue | `[local path] of Duty Ghosts\prologue.ff` |
| satfarm | `[local path] of Duty Ghosts\satfarm.ff` |
| ship_graveyard | `[local path] of Duty Ghosts\ship_graveyard.ff` |
| skyway | `[local path] of Duty Ghosts\skyway.ff` |

Plus `satfarm_b.ff` (campaign sub-zone, no preview clip of its own).

Campaign companion and shared single-player zones seen: `<stem>_*_tr.ff` transients,
`patch_<stem>.ff`, `techsets_<stem>.ff`, and the shared `code_post_gfx.ff`, `code_pre_gfx.ff`,
`code_nvidia.ff`, `common.ff`, `ui.ff`, `patch_ui.ff`, `patch_common.ff`, `development.ff`,
`ui_install.ff` (97 bytes).

---

## One `.ff` file read

| Field | Value |
|---|---|
| File name | `mp_warhawk.ff` |
| Path | `[local path] of Duty Ghosts\mp_warhawk.ff` |
| Size | 119412812 bytes |

First 64 bytes (hex):

```
49 57 66 66 30 31 30 30 35 02 00 00 01 00 08 04 00 00 00 00 00 00 00 00
AC 23 00 00 00 00 01 00 00 00 00 00 25 B5 4A 05 00 00 00 00 9E DA 4A 05
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
```

No header field is named from these bytes.

---

## Table Files

No loose table files (`.csv`, `.gsc`, `.cfg`, `.arena`, `.txt`) are visible in the retail folder —
this pass was a directory listing only, and no `.ff` was opened. Game data tables are compiled
into fastfile (`.ff`) containers; art and audio live in the numbered `.pak` archives
(`imagefile*.pak`, `soundfile*.pak`).

| Table | Path |
|-------|------|
| Weapon | rows not in source |
| Attachment | rows not in source |
| Perk | rows not in source |
| Equipment / Lethal / Tactical | rows not in source |
| Killstreak | rows not in source |
| Camo | rows not in source |
| Gametype | rows not in source |
| Create-a-class | rows not in source |
