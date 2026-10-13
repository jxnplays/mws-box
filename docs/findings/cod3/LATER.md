Install: `[local path] of Duty 3\Call of Duty 3`. Clean extracted Xbox 360 tree. Owner confirmed 2026-10-07. Read-only.

# LATER.md - CoD3 Multiplayer Extraction Notes

## MP Map Stems

Every mp map stem extracted, with the file read from:

| Map Stem | Display Name | Source File |
|----------|--------------|-------------|
| mp_mayenne | Mayenne Bridge | mp/mpmaynne/mpmaynne.cod |
| mp_fuel | Fuel Plant | mp/mp_fuel/mp_fuel.cod |
| mp_hosta | Hostage | mp/mp_hosta/mp_hosta.cod |
| mp_merv | Merville | mp/mp_merv/mp_merv.cod |
| mp_poissons | Poissons | mp/poissons/poissons.cod |
| mp_rouen | Rouen | mp/rouen/rouen.cod |
| mp_verdun | Verdun | mp/verdun/verdun.cod |

## KAPF Collision Hit - REJECTED

The collision chunk found at offset 0xc1215e in mp/mpmaynne/mpmaynne.cod was **rejected**.

The bytes at that offset are `COLOR1` (hex: `434f4c4f5231`), not collision or brush data. This is a false positive from the section name search. The actual collision/brush data is not exposed in the section table.

## Spawn List

The spawn-point records found in mp/mpmaynne/mpmaynne.cod consist of:

- **One `info_player_start`** at offset 0x1516520
- **Effect names** containing "spawn" (e.g., `elec_burst_spawn.ng.bpeb`, `bullet_hmg_metal_spawn.ng.bpeb`, `bullet_smg_metal_spawn.ng.bpeb`, etc.)

The "spawn" matches are primarily particle effect names, not actual spawn-point records. Only one `info_player_start` was found.

## Port Blocker

No decrypted XEX, so ReXGlue cannot start.

## Additional Notes

- **Rank names:** Most rank names (Private First Class through Colonel) not in source. Only "Private", "Corporal", "Sergeant", and "Major" found in SP dialogue subtitles, not as MP rank names.
- **Prestige titles:** Not in source.
- **Weapon stats:** Not in source (binary format inside fastfiles).
- **XP thresholds:** Not in source (binary format inside fastfiles).
- **Dvar defaults:** Not in source (binary format inside fastfiles).
- **.iwi files:** Not in source (inside fastfiles, not standalone files).
- **Perk system:** Not in source (confirmed absent).
- **Killstreak system:** Not in source (confirmed absent).
- **Attachment system:** Not in source (confirmed absent).
