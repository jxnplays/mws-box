# Infinite Warfare Retail Folder Findings

Source folder opened: `D:\SteamLibrary\steamapps\common\Call of Duty - Infinite Warfare`

Opened **read-only**. This pass is a directory listing plus a single 64-byte read of one file.
No `.ff` was decoded, no reader was written, nothing was launched or rebuilt, and no asset was
copied into the project.

This install is the Steam retail install **plus the IW7 client mod**. The two are separated below
by on-disk evidence, not by file name.

---

## Folder and install identity

| Field | Value |
|---|---|
| Install folder | `D:\SteamLibrary\steamapps\common\Call of Duty - Infinite Warfare` |
| Steam app id | 292730 (`Call of Duty: Infinite Warfare`) |
| Steam `LastUpdated` | 1742157912 = 2025-03-16 |
| Retail engine executable | `iw7_ship.exe` (48612264 bytes, dated 2025-03-16) |

The retail `iw7_ship.exe` matches Steam depot 292731 (size 48612664). `iw7` is the retail engine
codename for this title — it is **not** a mod marker. Files bearing `iw7` in the name are only
treated as mod when they actually live in the mod folder or carry the mod's install date.

---

## IW7 client mod

The IW7 client mod is the folder named **`iw7-mod`**:

`D:\SteamLibrary\steamapps\common\Call of Duty - Infinite Warfare\iw7-mod\`

It contains:

| Item | Path |
|---|---|
| zone | `iw7-mod\zone\iw7mod_code_post_gfx.ff`, `iw7-mod\zone\iw7mod_ui_mp.ff` |
| custom_scripts | `iw7-mod\custom_scripts\mp\bots.gsc`, `ranked.gsc`, `cp\patches.gsc`, `cp_mp\inspect.gsc` |
| ui_scripts | `iw7-mod\ui_scripts\` (Lua: Conditions, EndGame, Lobby, MainMenu, Mods, SystemLinkMenu) |
| sounddata | `iw7-mod\sounddata\mp\*.json`, `iw7-mod\sounddata\cp\*.json` |
| players2 | `iw7-mod\players2\` (config, savegame, user data) |
| logs | `iw7-mod\logs\games_mp.log` |
| start.cfg | `iw7-mod\start.cfg` |

Mod launcher files that sit at the install root (not in the folder):

- `iw7-mod.exe` (4605952 bytes, 2025-04-17) — mod client executable
- `runner.exe` (219648 bytes, 2025-04-17)
- `tlsdll.dll` (115200 bytes, 2025-04-17)
- `d3d9.dll` (4460558 bytes, 2025-04-19) — DXVK wrapper
- `dxvk.conf` (24 bytes, 2025-04-19)
- `!start_client.bat` (181 bytes, 2025-04-17) — launches `iw7-mod.exe`
- `minidumps\iw7mod-crash-2026-01-13-00-09-57.zip`

All of the above are kept **out of the retail lists** below.

### How mod was separated from retail

Retail files carry the Steam install timestamp **2025-03-16** (Steam `LastUpdated` = 1742157912).
Mod files carry **2025-04-17 or later**. Every top-level `.ff` (including the `iw7`-named weapon
and character zones) is dated 2025-03-16, i.e. they came from Steam and are retail. The only
`iw7mod`-named zones are inside `iw7-mod\zone\`.

---

## Multiplayer zone files

All paths below are under
`D:\SteamLibrary\steamapps\common\Call of Duty - Infinite Warfare\`.

### Multiplayer map zones (33)

Each stem below is an `mp_<stem>.ff` map zone. Each also has a `patch_mp_<stem>.ff` companion at
the root, and most have a matching `english\eng_mp_<stem>.ff` localized zone and a map
`*_screen*.bik`. These are multiplayer maps, not campaign or zombies.

| Map zone file | Path | Size (bytes) |
|---|---|---|
| mp_afghan.ff | `...\mp_afghan.ff` | 138147568 |
| mp_breakneck.ff | `...\mp_breakneck.ff` | 109605744 |
| mp_carnage2.ff | `...\mp_carnage2.ff` | 92667280 |
| mp_codphish.ff | `...\mp_codphish.ff` | 119574816 |
| mp_depot.ff | `...\mp_depot.ff` | 128024128 |
| mp_desert.ff | `...\mp_desert.ff` | 99735008 |
| mp_divide.ff | `...\mp_divide.ff` | 113861472 |
| mp_dome_iw.ff | `...\mp_dome_iw.ff` | 72149160 |
| mp_fallen.ff | `...\mp_fallen.ff` | 106660528 |
| mp_flip.ff | `...\mp_flip.ff` | 55292456 |
| mp_frontier.ff | `...\mp_frontier.ff` | 124533352 |
| mp_geneva.ff | `...\mp_geneva.ff` | 68653064 |
| mp_hawkwar.ff | `...\mp_hawkwar.ff` | 87580544 |
| mp_junk.ff | `...\mp_junk.ff` | 73455504 |
| mp_mansion.ff | `...\mp_mansion.ff` | 142605864 |
| mp_marsoasis.ff | `...\mp_marsoasis.ff` | 127755984 |
| mp_metropolis.ff | `...\mp_metropolis.ff` | 86107256 |
| mp_neon.ff | `...\mp_neon.ff` | 83272512 |
| mp_nova.ff | `...\mp_nova.ff` | 129375224 |
| mp_overflow.ff | `...\mp_overflow.ff` | 102957272 |
| mp_paris.ff | `...\mp_paris.ff` | 123479496 |
| mp_parkour.ff | `...\mp_parkour.ff` | 112748024 |
| mp_permafrost2.ff | `...\mp_permafrost2.ff` | 101515480 |
| mp_pixel.ff | `...\mp_pixel.ff` | 142875640 |
| mp_prime.ff | `...\mp_prime.ff` | 90162936 |
| mp_proto.ff | `...\mp_proto.ff` | 162118280 |
| mp_quarry.ff | `...\mp_quarry.ff` | 121513256 |
| mp_rally.ff | `...\mp_rally.ff` | 93126032 |
| mp_renaissance2.ff | `...\mp_renaissance2.ff` | 68751392 |
| mp_riot.ff | `...\mp_riot.ff` | 104709704 |
| mp_rivet.ff | `...\mp_rivet.ff` | 112972000 |
| mp_skyway.ff | `...\mp_skyway.ff` | 115296568 |
| mp_turista2.ff | `...\mp_turista2.ff` | 127739312 |

Map name note: `mp_afghan.ff` is the retail multiplayer map **Afghan**, remade in Infinite Warfare
as **Dominion**. Recorded here as retail under both names. It is **not** marked mod — the file name
is not a mod signal.

### Multiplayer zones that are not maps

| Zone file | Path | Note |
|---|---|---|
| mp_frontend.ff | `...\mp_frontend.ff` | multiplayer frontend, not a map |
| mp_fullbody_assault_tr.ff | `...\mp_fullbody_assault_tr.ff` | character asset, not a map |
| mp_body_*.ff (40) | `...\mp_body_ftl_1_tr.ff` etc. | character body zones, not maps |
| mp_head_*.ff | `...\mp_head_ghost_2_tr.ff` etc. | character head zones, not maps |
| mp_viewhands_*.ff | `...\mp_viewhands_ftl_1_tr.ff` etc. | first-person arms, not maps |
| mp_weapon_view_iw7_*.ff (102) | `...\mp_weapon_view_iw7_ake_tr.ff` etc. | weapon view zones, not maps |
| mp_weapon_world_iw7_*.ff (102) | `...\mp_weapon_world_iw7_ake_tr.ff` etc. | weapon world zones, not maps |

None of the above is called a multiplayer map.

---

## Campaign zone files

The 32 stems below each have a localized companion `english\eng_<stem>.ff` and, for most, an
`sc_<stem>_*.bik` cutscene. They are single-player campaign zones, **not** multiplayer maps.
All paths are under
`D:\SteamLibrary\steamapps\common\Call of Duty - Infinite Warfare\`.

| Campaign zone file | Path | Size (bytes) |
|---|---|---|
| europa.ff | `...\europa.ff` | 129977632 |
| heist.ff | `...\heist.ff` | 103708560 |
| heistspace.ff | `...\heistspace.ff` | 91795512 |
| ja_asteroid.ff | `...\ja_asteroid.ff` | 57065112 |
| ja_mining.ff | `...\ja_mining.ff` | 70355472 |
| ja_spacestation.ff | `...\ja_spacestation.ff` | 45586168 |
| ja_titan.ff | `...\ja_titan.ff` | 78286472 |
| ja_wreckage.ff | `...\ja_wreckage.ff` | 55982960 |
| marsbase.ff | `...\marsbase.ff` | 95940016 |
| marscrash.ff | `...\marscrash.ff` | 89508616 |
| marscrib.ff | `...\marscrib.ff` | 87753800 |
| moonjackal.ff | `...\moonjackal.ff` | 55884656 |
| moon_port.ff | `...\moon_port.ff` | 136359400 |
| phparade.ff | `...\phparade.ff` | 60431496 |
| phspace.ff | `...\phspace.ff` | 67153760 |
| phstreets.ff | `...\phstreets.ff` | 139127480 |
| prisoner.ff | `...\prisoner.ff` | 141706984 |
| rogue.ff | `...\rogue.ff` | 155521256 |
| sa_assassination.ff | `...\sa_assassination.ff` | 104509080 |
| sa_empambush.ff | `...\sa_empambush.ff` | 123237072 |
| sa_moon.ff | `...\sa_moon.ff` | 98272384 |
| sa_vips.ff | `...\sa_vips.ff` | 94398720 |
| sa_wounded.ff | `...\sa_wounded.ff` | 87582416 |
| shipcrib_epilogue.ff | `...\shipcrib_epilogue.ff` | 55654376 |
| shipcrib_europa.ff | `...\shipcrib_europa.ff` | 108246288 |
| shipcrib_moon.ff | `...\shipcrib_moon.ff` | 105324088 |
| shipcrib_prisoner.ff | `...\shipcrib_prisoner.ff` | 122217624 |
| shipcrib_rogue.ff | `...\shipcrib_rogue.ff` | 115023224 |
| shipcrib_titan.ff | `...\shipcrib_titan.ff` | 104991912 |
| titan.ff | `...\titan.ff` | 135732632 |
| titanjackal.ff | `...\titanjackal.ff` | 91604664 |
| yard.ff | `...\yard.ff` | 126485800 |

Campaign companion transient zones seen (not listed in full): `*_tr.ff` for each stem above
(e.g. `titan_base_tr.ff`, `sa_moon_interior_tr.ff`, `shipcrib_rogue_bridge_tr.ff`), plus
`prisoner_*_tr.ff`, `pnr_*_tr.ff`, `heist_*_tr.ff`, `heistspace_*_tr.ff`, `marsbase_*_tr.ff`,
`marscrash_*_tr.ff`, `moon_port_*_tr.ff`, `moonjackal_*_tr.ff`, `geneva_periph_*_tr.ff`.

---

## Zombies zone files

Zombies (co-op) map zones are `cp_*`. Each has a `zombies_cp_<stem>_*.bik` intro/outro at the root,
which is the basis for calling these zombies. They are **not** multiplayer maps.
All paths are under
`D:\SteamLibrary\steamapps\common\Call of Duty - Infinite Warfare\`.

| Zombies zone file | Path | Size (bytes) |
|---|---|---|
| cp_disco.ff | `...\cp_disco.ff` | 179048816 |
| cp_final.ff | `...\cp_final.ff` | 202952968 |
| cp_rave.ff | `...\cp_rave.ff` | 202446008 |
| cp_town.ff | `...\cp_town.ff` | 170421160 |
| cp_zmb.ff | `...\cp_zmb.ff` | 206039200 |

`cp_frontend.ff` (`...\cp_frontend.ff`, 14748392 bytes) is the zombies frontend, not a map.

---

## Shared zones (not maps, not campaign, not zombies)

| Zone file | Path | Note |
|---|---|---|
| common.ff | `...\common.ff` | shared |
| code_post_gfx.ff | `...\code_post_gfx.ff` | shared |
| code_pre_gfx.ff | `...\code_pre_gfx.ff` | shared |
| global.ff | `...\global.ff` | shared |
| ui.ff | `...\ui.ff` | shared UI |
| ui_boot.ff | `...\ui_boot.ff` | shared UI |
| common_mp.ff | `...\common_mp.ff` | multiplayer shared |
| common_core_mp.ff | `...\common_core_mp.ff` | multiplayer shared |
| global_mp.ff | `...\global_mp.ff` | multiplayer shared |
| global_core_mp.ff | `...\global_core_mp.ff` | multiplayer shared |
| ui_mp.ff | `...\ui_mp.ff` | multiplayer UI |
| ui_core_mp.ff | `...\ui_core_mp.ff` | multiplayer UI |
| common_cp.ff | `...\common_cp.ff` | zombies shared |
| global_cp.ff | `...\global_cp.ff` | zombies shared |
| ui_cp.ff | `...\ui_cp.ff` | zombies UI |
| common_sp.ff | `...\common_sp.ff` | campaign shared |
| global_sp.ff | `...\global_sp.ff` | campaign shared |
| weapon_iw7_*_tr.ff (30) | `...\weapon_iw7_ake_tr.ff` etc. | retail weapon zones, not maps |

These are retail zones (Steam date 2025-03-16) and are **not** mod.

---

## One retail `.ff` file read

| Field | Value |
|---|---|
| File name | `mp_afghan.ff` |
| Path | `D:\SteamLibrary\steamapps\common\Call of Duty - Infinite Warfare\mp_afghan.ff` |
| Size | 138147568 bytes |
| Retail map name | Afghan (Infinite Warfare remake: Dominion) |

First 64 bytes (hex):

```
49 57 66 66 30 31 30 30 53 06 00 00 00 01 01 01
00 00 00 00 00 00 00 00 B1 1B AF 0D 00 00 00 00
7B A6 52 0A 00 00 00 00 00 00 00 00 00 00 00 00
40 12 00 02 00 00 00 00 A0 50 06 00 00 00 00 00
```

No header field is named from these bytes.

---

## Table Files

No loose table files (`.csv`, `.gsc`, `.cfg`, `.arena`, `.txt`) are visible in the retail folder —
this pass was a directory listing only, and no `.ff` was opened. Game data tables are compiled
into fastfile (`.ff`) containers; art and audio live in the numbered `.pak` archives
(`imagefile*.pak`, `assetfile*.pak`) and the `.sabl`/`.sabs` audio files.

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

---

## Companion checks for the 33 multiplayer maps, and two more 64-byte reads

Paths are relative to `D:\SteamLibrary\steamapps\common\Call of Duty - Infinite Warfare\`.
Read-only; no `.ff` was decoded and no reader was written.

### `patch_mp_<stem>.ff` and `english\eng_mp_<stem>.ff`

| Map zone | `patch_mp_<stem>.ff` exists | size (bytes) | `english\eng_mp_<stem>.ff` exists | size (bytes) |
|---|---|---|---|---|
| mp_afghan.ff | Yes | 721416 | Yes | 49384 |
| mp_breakneck.ff | Yes | 607184 | Yes | 49480 |
| mp_carnage2.ff | Yes | 65768 | Yes | 49384 |
| mp_codphish.ff | Yes | 49384 | Yes | 65768 |
| mp_depot.ff | Yes | 65768 | Yes | 49384 |
| mp_desert.ff | Yes | 475896 | Yes | 49384 |
| mp_divide.ff | Yes | 311624 | Yes | 49384 |
| mp_dome_iw.ff | Yes | 901688 | Yes | 49384 |
| mp_fallen.ff | Yes | 836800 | Yes | 49384 |
| mp_flip.ff | Yes | 82152 | Yes | 49384 |
| mp_frontier.ff | Yes | 476352 | Yes | 49384 |
| mp_geneva.ff | Yes | 229920 | Yes | 65768 |
| mp_hawkwar.ff | Yes | 65768 | Yes | 49384 |
| mp_junk.ff | Yes | 180552 | Yes | 49384 |
| mp_mansion.ff | Yes | 245992 | Yes | 49384 |
| mp_marsoasis.ff | Yes | 197032 | Yes | 49384 |
| mp_metropolis.ff | Yes | 98536 | Yes | 49384 |
| mp_neon.ff | Yes | 131496 | Yes | 49384 |
| mp_nova.ff | Yes | 803048 | Yes | 65768 |
| mp_overflow.ff | Yes | 98536 | Yes | 65768 |
| mp_paris.ff | Yes | 65864 | Yes | 49384 |
| mp_parkour.ff | Yes | 819648 | Yes | 49384 |
| mp_permafrost2.ff | Yes | 49384 | Yes | 49384 |
| mp_pixel.ff | Yes | 82248 | Yes | 49384 |
| mp_prime.ff | Yes | 49384 | Yes | 49384 |
| mp_proto.ff | Yes | 1393664 | Yes | 49384 |
| mp_quarry.ff | Yes | 737920 | Yes | 49384 |
| mp_rally.ff | Yes | 49384 | Yes | 49384 |
| mp_renaissance2.ff | Yes | 82152 | Yes | 49384 |
| mp_riot.ff | Yes | 114920 | Yes | 49384 |
| mp_rivet.ff | Yes | 885448 | Yes | 49384 |
| mp_skyway.ff | Yes | 590992 | Yes | 49384 |
| mp_turista2.ff | Yes | 147688 | Yes | 49384 |

All 33 have both companions: Yes.

### Two more `.ff` first-64-byte reads (hex only)

`cp_zmb.ff` — `D:\SteamLibrary\steamapps\common\Call of Duty - Infinite Warfare\cp_zmb.ff` — 206039200 bytes

```
49 57 66 66 30 31 30 30 53 06 00 00 00 01 01 01
00 00 00 00 00 00 00 00 E4 75 D2 15 00 00 00 00
63 AE 8A 15 00 00 00 00 00 00 00 00 00 00 00 00
40 76 40 01 00 00 00 00 B0 27 32 00 00 00 00 00
```

`europa.ff` — `D:\SteamLibrary\steamapps\common\Call of Duty - Infinite Warfare\europa.ff` — 129977632 bytes

```
49 57 66 66 30 31 30 30 53 06 00 00 00 01 01 01
00 00 00 00 00 00 00 00 06 96 EA 0E 00 00 00 00
38 61 51 19 00 00 00 00 00 00 00 00 00 00 00 00
40 12 00 02 00 00 00 00 A0 AF 19 00 00 00 00 00
```

No header field is named from these bytes.
