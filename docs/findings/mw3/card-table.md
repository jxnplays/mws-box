# MW3 card tables — source availability

Scope: the existing MW3 unpack under `findings/mw3/unpacked` only. No rescan of
the install was performed. One pass.

**Result: all three card tables are referenced by the game; no table body is
present in the unpack.** No emblem table is named anywhere in the unpack.

---

## `mp/cardIconTable.csv` — not in source

Body absent. 8 references found:

| zone | reference offset |
|---|---|
| `zone__english__code_post_gfx` | `0x002e4f5d` |
| `zone__english__code_post_gfx_mp` | `0x001cfa27` |
| `zone__english__common` | `0x02ad63cf` |
| `zone__english__common_mp` | `0x04c748e3` |
| `zone__english__localized_ui_mp` | `0x000697aa` |
| `zone__english__patch` | `0x0001c472` |
| `zone__english__patch_mp` | `0x0002b4e8` |
| `zone__english__ui` | `0x0001b6c5` |

- column count: **not in source**
- first 5 rows: **not in source**

## `mp/cardTitleTable.csv` — not in source

Body absent. 9 references found:

| zone | reference offset |
|---|---|
| `zone__english__code_post_gfx` | `0x002d02d3` |
| `zone__english__code_post_gfx_mp` | `0x001b8fc8` |
| `zone__english__common` | `0x02ad63f5` |
| `zone__english__common_mp` | `0x04c74909` |
| `zone__english__localized_ui_mp` | `0x000697d0` |
| `zone__english__patch` | `0x0001c498` |
| `zone__english__patch_mp` | `0x0002b4fd`, `0x006275d5` |
| `zone__english__ui` | `0x0001b6eb` |

- column count: **not in source**
- first 5 rows: **not in source**

## `mp/cardNameplateTable.csv` — not in source

Body absent. 2 references found:

| zone | reference offset |
|---|---|
| `zone__english__code_post_gfx` | `0x002ebf90` |
| `zone__english__code_post_gfx_mp` | `0x001d64e1` |

- column count: **not in source**
- first 5 rows: **not in source**

## Emblem table — not in source

No `*emblem*.csv` filename exists anywhere in the unpack. A regex for
`[\w\-./\\]*\w*[Ee]mblem\w*\.csv` across every extracted string returned
**0 matches**.

Emblem *UI text* does exist (e.g. `Choose your emblem.` at
`zone__english__code_post_gfx` `0x0002f7a0`, `MENU_EMBLEM_CAPS` at
`0x0002e0ab`, `EMBLEM` at `0x0002e0ab`), and emblem *image* assets exist
(`treyarch_emblem_64` at `zone__english__common_mp` `0x011eb13c`,
`ns_emblem_64` at `0x011ec8fb`). Those are localize strings and textures
respectively — **neither is a table**, and neither is treated as one here.

---

## Evidence that these are references, not bodies

**1. The bytes after each reference are more string-pool entries, never CSV
rows.** Read directly from the decompressed payload at each cited offset:

```
mp/cardIconTable.csv   @ zone__english__common_mp 0x04c748e3
  next bytes -> browsingCardIcon / mp/cardTitleTable.csv / browsingCardTitle
                / clanlvl_box / [.] / mp/rankIconTable.csv / sp/rankTable.csv
                / xp / gxp / @PLATFORM_NO_FRIENDS_STEAM

mp/cardTitleTable.csv  @ zone__english__patch_mp 0x0002b4fd
  next bytes -> clanlvl_box / [.] / mp/rankIconTable.csv / sp/rankTable.csv
                / mp/killstreakTable.csv
```

A table body would begin with a header row. These continue as an adjacent run
of asset paths and dvar names.

**2. No card-table body anywhere in the unpack.** Across **321** decompressed
payloads:

- 0 table-like bodies (≥2 comma-bearing printable lines) containing
  card/emblem column vocabulary
- 0 column-header signature matches for `index,name` · `name,icon` ·
  `card,icon|title|nameplate` · `icon,name` · `title,icon` · `nameplate,icon` ·
  `emblem,name`
- 0 CSV-shaped field rows (≥3 lowercase identifier fields, one of which is
  `icon`/`title`/`emblem`/`nameplate`)

**3. Not hiding in a deflated blob inside the code zones.** The citing
`code_post_gfx_mp` payload has low entropy (3.468 bits/byte), i.e. compressed
rather than strongly encrypted, so individual zlib streams were carved and
inspected:

| zone | blobs | csv-shaped | card/emblem |
|---|---|---|---|
| `code_post_gfx_mp` | 33 | 0 | 0 |
| `code_post_gfx` | 84 | 1 | 0 |
| `code_pre_gfx_mp` | 5 | 1 | 1 |
| `patch_mp` | 70 | 0 | 0 |
| `common_mp` | 515 | 0 | 0 |

The single `code_pre_gfx_mp` hit is a **false positive**: a GPU benchmark
config whose comment reads *"The file is broken into the CPU section followed
by the GPU section…"* — it matches only because the word "card" appears
elsewhere in the text ("graphics card"). It is not a card table.

## Why the body is absent

Consistent with the documented MW3 script protection: the `.csv` balance
tables live in the encrypted `.gsc` script layer, so only their **paths**
survive into the readable string pool. See `REPORT.md` §5 and
`unresolved.md` §1.

## Next step if the body is wanted

Diff the smallest signed patch that carries these references
(`zone__english__patch_mp`, reference at `0x006275d5`) against the base
`code_post_gfx_mp`, or resolve the script-loader transform via
`iw5mp.exe`. Both are described in `unresolved.md` §1.

---

Probes used (all read-only, under `findings/mw3/tools/`):
`card_table_probe.py`, `card_table_confirm.py`, `card_table_carve.py`.
Evidence: `_card_probe.json`, `_card_probe2.json`.
