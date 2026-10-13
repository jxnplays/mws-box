# LATER.md — Future Warfare extraction: open items (shelf note)

Compiled only from files already written. No `.svg` re-scan, no re-unpack.
Sources: `REPORT.md`, `unresolved.md` (this folder); `output/maps.csv`, `output/weapons.csv`
(the extraction output). Anything not in those is marked **not in source**.

## 1. The 28 MP map stems
Source: `output/maps.csv`, `internal_name` column (fastfiles `mp_nx_*.ff` / `mp_nx_*.ffm`).

1. `mp_nx_asylum_2`
2. `mp_nx_blank1`
3. `mp_nx_bom`
4. `mp_nx_border`
5. `mp_nx_contact`
6. `mp_nx_deadzone`
7. `mp_nx_fallout`
8. `mp_nx_galleria`
9. `mp_nx_import`
10. `mp_nx_leg_crash`
11. `mp_nx_leg_over`
12. `mp_nx_leg_term`
13. `mp_nx_lockdown`
14. `mp_nx_lockdown_v2`
15. `mp_nx_meteor`
16. `mp_nx_monorail`
17. `mp_nx_pitstop`
18. `mp_nx_sandstorm`
19. `mp_nx_seaport`
20. `mp_nx_shipyard`
21. `mp_nx_skylab`
22. `mp_nx_stasis`
23. `mp_nx_streets`
24. `mp_nx_subyard`
25. `mp_nx_ugvcontact`
26. `mp_nx_ugvhh`
27. `mp_nx_ugvsand`
28. `mp_nx_whiteout`

## 2. Weapons marked confirmed
Source: `output/weapons.csv`, `confidence = confirmed` (46 of 64 rows).

`scar`, `scar2`, `asmk27`, `xm108`, `ecr`, `fal`, `type104`, `augks`, `ffar`, `abg`, `ajax`,
`pulserifle`, `laserrifle`, `lasersniper`, `glo`, `needler`, `sonic_warden`, `xm25`, `xm25ks`, `m79`,
`m320`, `srm1216`, `ksg`, `cheytac`, `coltanaconda`, `beretta393`, `semtex`, `throwingknife`,
`claymore`, `c4`, `frag_grenade`, `flash_grenade`, `smoke_grenade`, `gas_grenade`, `emp_grenade`,
`lidar_grenade`, `concussion_grenade`, `grapplinghook`, `portable_radar`, `scavenger_bag`,
`riotshield`, `riotshieldcloak`, `riotshieldcover`, `riotshieldxray`, `vacuum_shotgun`,
`vacuum_railgun`.

## 3. The one downgraded
`pulserifle` — listed `confirmed` in `weapons.csv`, but downgraded to `uncertain` during the
verification pass (`unresolved.md`, Appendix A.3): it occurs only once, as the script case label
`case "pulserifle":`, with no asset reference found. Treat as a script name only, not a confirmed asset.

## 4. Fastfile container (magic + header size)
Source: `REPORT.md` ("identified the container (`NXff0100` MP / `NXffu100` SP, 38-byte header, nested
`NXffs100`)"); `unresolved.md` §3 ("the outer container is a 38-byte header followed by `NXffs100` (MP)
or a zlib stream (SP)").

- Magic: `NXff0100` (MP) / `NXffu100` (SP)
- Header size: **38 bytes**
- Nested marker: `NXffs100` (MP); zlib stream (SP)

## 5. Blocker (one line)
**NXffs100 asset index is not parsed, so damage and fire rate are not in source.**

## 6. Not in source
- Per-weapon damage values (min/max, falloff, headshot/limb multipliers): **not in source** (blocked by §5).
- Fire rate, clip size, ADS/reload times, spread, recoil: **not in source** (blocked by §5).
- English display names / localized strings: **not in source** (the `ez_*_english_mp` fastfiles are absent).
- Complete GSC function bodies in `save_svg_strings.txt`: **not in source** (that artifact is
  strings-only; full bodies exist only in the raw `.svg` dumps, not in the written outputs).
