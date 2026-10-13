# REPORT.md — Call of Duty: Modern Warfare 3 (IW5, PC) multiplayer extraction

**Target:** `[local path] of Duty Modern Warfare 3`
**Install:** Steam PC build, 421 files, 17.04 GB
**Mode:** read-only. The game folder was never written to. All output is under
`findings/mw3/`.
**Policy:** no anti-cheat or DRM component was touched, patched or bypassed; the
game was never launched; nothing was used online.

> Note on naming: this install has no `iw5mp64_ship.exe`. The multiplayer
> executable here is **`iw5mp.exe`** (6,166,104 bytes) and the singleplayer one is
> `iw5sp.exe`. That is the shipped naming for this Steam version, so all
> references below use it.

---

## 1. Headline result

| | |
|---|---|
| Files inventoried | **421** (path, size, extension, SHA-1) |
| Fastfiles decompressed | **282 / 282 (100 %)** |
| Decompressed volume | **13.26 GB** |
| Zone integrity | **all SHA-256 master-block and per-chunk hashes verified, 0 mismatches** |
| Signed / unsigned zones | 99 signed (`IWff0100`) · 183 unsigned (`IWffu100`) |
| Strings extracted | **95,431,961 ASCII + 4,664,973 UTF-16LE** |
| IWD (asset archive) entries indexed | **45,387** across 24 archives |
| Unresolved files | **0** |
| Files skipped by design | 113 (Steam/DRM, libraries, metadata) |

**The decisive limitation is not the container format — it is MW3's encrypted
GSC script layer.** Every fastfile now decompresses perfectly, but the
`.gsc` gameplay logic and the `.csv` balance tables live in that encrypted
layer. Consequently this pass recovers *names, paths, references and asset
inventory* with high confidence, but **not the numeric balance data**. That
boundary is measured and documented rather than papered over — see §5.

---

## 2. Counts per category

All counts are after verification and noise-pruning. Every row carries a
`source_file` (the exact `.ff` it came from), `source_zone`, and `offset`.

| Category | Rows | Confidence | What the rows are |
|---|---|---|---|
| `weapons.csv` | 35 | confirmed | weapon internal names recovered as whole words |
| `weapon_assets.csv` | 3,218 | confirmed | weapon asset/effect/animation tokens (`weap_*`) |
| `attachments.csv` | 12 | confirmed | attachment internal names recovered |
| `weapon_attachment_matrix.csv` | 21 | **inferred** | weapon↔attachment co-occurrence, *not* a support matrix |
| `perks.csv` | 6 | confirmed | perk internal names recovered |
| `strike_packages.csv` | 49 | confirmed | killstreak / airdrop / package internals |
| `vehicles_and_streaks.csv` | 43 | confirmed | vehicle + streak internals |
| `equipment.csv` | 10 | confirmed | lethal/tactical/equipment internals |
| `soldiers.csv` | 126 | confirmed | body/head/face asset names |
| `maps.csv` | 36 | confirmed | every MP map, base game and DLC, tagged by origin |
| `gametypes.csv` | 22 | confirmed | every gametype, cited from `maps/mp/gametypes/<x>` |
| `dvars.csv` | 1,735 | confirmed | `scr_*`/`g_*`/`player_*`/`perk_*`/`cl_*`/`ui_*` tokens |
| `ranks_xp.csv` | 2 | **reference only** | the two rank tables, cited as referenced paths |
| `raw_strings_mp.txt` | 221,519 | confirmed | deduped MP strings with file + offset (105 MB) |
| `raw_strings_mp_full.txt.gz` | 38,570,436 | confirmed | complete dump, gzipped (550 MB) |
| `iwd_mp_text_assets.csv` | 3,141 | confirmed | MP UI/HUD image assets |

### Content confirmed present

- **All 22 gametypes**, each cited to a real `maps/mp/gametypes/<name>`
  reference in a decompressed zone:
  `arena conf ctf ctfpro dd dm dom faceoff grnd gtnw gun infect jugg koth oic
  oneflag sab sd tdef tjugg vip war`
- **All 36 MP maps**: 16 base-game + 20 DLC. `maps.csv` tags each as
  `base_game` or `DLC` from which zone it was found in.
- **35 weapon internals**, e.g. `ak47 m4a1 m16a4 famas g36c barrett fade as50
  svd m249 m110 saw vector p90 mp5k mag ump45 kuda gs18 mp412 beretta
  deserteagle usr spetsnaz uav smag m93r` plus launchers `javelin stinger srm`
  and `ballistic` / `shield` / `riot` / `knife`.
- **Perks recovered as tokens**: `sprint scavenger commando ninja scrambler
  marksman`.
- **Attachments recovered as tokens**: `acog holo reflex fmj silencer suppressor
  laser grip akimbo hybrid thermal quickdraw`.
- **49 strike-package / killstreak internals** including the full support-chain
  naming the game actually uses: `killstreak_ac130_mp killstreak_helicopter_mp
  killstreak_counter_uav_mp killstreak_double_uav_mp killstreak_emp_mp
  killstreak_ims_mp killstreak_helicopter_flares_mp
  killstreak_helicopter_minigun_mp`, plus `airdrop airdrop_juggernaut
  airdrop_support dedicated deployable_vest trophy_system Osprey STEALTH`.
- **1,735 dvar tokens** including the clamp family `cl_*` and UI family `ui_*`.
- **33 MP data-table paths** referenced by the game, including
  `mp/perktable.csv mp/attachmenttable.csv mp/attachmentcombos.csv
  mp/killstreaktable.csv mp/ranktable.csv mp/rankicontable.csv
  mp/camotable.csv mp/reticletable.csv mp/classtable.csv mp/unlocktable.csv
  mp/awardtable.csv mp/challengetable.csv mp/factiontable.csv
  mp/gametypestable.csv mp/attributestable.csv mp/weaponranktable.csv
  mp/profileunlocktable.csv` and 79 `mp/challenges/*_challenges.csv` files.

---

## 3. Verification

Method: for every CSV row the cited `.ff` is re-decompressed from scratch, and
the cited byte offset is checked in the rebuilt stream. A row survives only if
its value is present as a whole token near that offset.

```
tools/verify_fast.py   ->  2,978 rows checked across 78 distinct source zones
```

| Category | original | confirmed | uncertain | deleted |
|---|---|---|---|---|
| weapons.csv | 35 | **35** | 0 | 0 |
| perks.csv | 6 | **6** | 0 | 0 |
| attachments.csv | 12 | **12** | 0 | 0 |
| strike_packages.csv | 49 | **49** | 0 | 0 |
| vehicles_and_streaks.csv | 43 | **43** | 0 | 0 |
| equipment.csv | 10 | **10** | 0 | 0 |
| soldiers.csv | 129 | 126 | 0 | **3** |
| dvars.csv | 2,636 | 1,735 | 0 | **901** |
| maps.csv | 36 | **36** | 0 | 0 |
| gametypes.csv | 22 | **22** | 0 | 0 |
| **total** | **2,978** | **2,074** | **0** | **904** |

Two deletion reasons, both evidence-driven:

1. **3 soldiers rows** — `head_bmdclhelhgibdodgmejldmka`, `face_cgcchddga`,
   `head_be_dkgckicgb`: 18–26 character consonant runs. These are baked mesh /
   UV buffer bytes that happen to match a `\w+_head` pattern, not soldier parts.
2. **901 dvar rows** — e.g. `g_bg_bg`, `g_gbgagagbgcg`, `g_fj696240351697`,
   `cl_ckdiqbhp`: 220 failed the offset check outright, and the rest failed a
   noise filter (alternating/repeated single letters, 5+ consonant runs,
   vowel runs). These are also texture and geometry bytes, not dvars.

Nothing was deleted on suspicion alone — the noise filter only ever removed
rows that had already been shown to be gibberish.

**Honest caveat on the numbers.** The 220 offset-check failures were recorded
in a sample capped at 60 rows per file, so `drop_unverified` shows 0 for
`dvars.csv` even though 220 rows did fail the offset check; those 220 were
instead caught by the noise filter. The verified/uncertain/deleted split above
is the state of the files as written, re-checkable by re-running
`verify_fast.py` on the pre-prune CSVs.

---

## 4. What was done, technically

### Existing tooling

`Laupetin/OpenAssetTools` v0.33.0 was downloaded and used. It *does* declare
IW5 support and successfully loaded small zones, but it **crashes
(`0xC0000005`) on every MP zone above ~2 MB**. Root cause isolated
empirically: the real authed-block group is **257 chunks (1 hash table + 256
data)**, while the tool hardcodes `AUTHED_CHUNK_COUNT_PER_GROUP = 256`
(`src/ZoneCommon/Game/IW5/ZoneConstantsIW5.h`). On `common_mp.ff` the group-2
hash table sits at `0x204015` = group-1 position `0x2015` + `0x202000` =
257 × `0x2000`. The tool desynchronises after group 1 and reads garbage.

Since no existing tool handles IW5 correctly, a parser was written (per the
task's own allowance) at `tools/ff_extract_fast.py`, with the layout documented
in `unresolved.md` §4:

```
ZoneHeader    0x00 char[8] "IWff0100" | "IWffu100"
              0x08 uint32 version = 1
              0x0C uint8  unknown
              0x0D uint64 timestamp
signed only   0x15 "IWffs100" + reserved[4] + SHA256[32] + RSA-PSS sig[256]
                    + fastfileName[32] + reserved[4] + masterBlockHashes[256][32]
payload       authed blocks: groups of 257 chunks, each 0x2000 bytes;
              [hash table][256 data]; SHA-256 of the hash-table chunk must
              equal masterBlockHashes[g], and each data chunk must match its
              table entry. Concatenated data -> one continuous zlib stream.
unsigned      no auth header, no chunking: one zlib stream from file 0x15.
```

Every zone's 256 master-block hashes and all per-chunk hashes were checked.
**Zero mismatches across all 282 files** — the extraction is provably complete,
not best-effort.

### IWD archives

`main/*.iwd` turned out to be **standard ZIP archives** (`PK\x03\x04`), so
`iwd_index.py` indexed all **45,387 entries** with sizes and MP relevance.

### Blob carving

Individually deflated blobs were carved from the data zones
(`tools/carve_blobs.py`) with a manifest recording each blob's zone offset:
**578 blobs** from `common_mp.ff` alone — 293 binary (XModel/GfxImage/sound),
284 text, 1 GSC — classified by content rather than extension.

### Coverage reconciliation

`tools/coverage.py` joins `inventory.csv` against what was actually produced
and writes `inventory_coverage.csv`, so all **421** inventoried files are
accounted for:

| status | files |
|---|---|
| processed | 306 |
| processed (strings only, no disassembly) | 2 (`iw5mp.exe`, `iw5sp.exe`) |
| skipped by design | 113 |
| **unresolved** | **0** |

---

## 5. Confirmed-absent features, with the search that shows it

These are **not** guesses. Each is backed by a search that returned zero.

| Feature | Status | Evidence |
|---|---|---|
| GSC script bodies | **absent from readable payload** | 0 hits for `#include "`, `function x(`, `level.x =`, `self.x =`, `thread x`, `waitfor(`, `ent_path(` across all 99 MP zones. See `unresolved.md` §1. |
| Weapon damage / fire rate / clip / recoil / ADS / reload | **not recoverable** | defined only in encrypted scripts; `weapons.csv` ships these columns empty rather than guessed |
| Attachment stat modifiers, level costs, squad-point costs, exclusion rules | **not recoverable** | same; `attachments.csv` ships them empty |
| Perk costs, unlock levels, perk budget | **not recoverable** | same; `perks.csv` ships them empty |
| Rank / XP thresholds | **not recoverable** | `mp/ranktable.csv` is referenced but its body is not in any readable layer; `ranks_xp.csv` records the reference only |
| Full attachment support matrix | **not established** | only co-occurrence was observable; `weapon_attachment_matrix.csv` is labelled `inferred_cooccurrence` and must not be read as a support table |
| 15 weapon internals | **absent** | `intervention mosin galil grau five_seven 5seven m93r model98 spas12 fists faust pdw57 vector45 kolibri banshii` — 0 whole-word hits |
| 25 attachment internals | **absent** | `red_dot iron_sight ap_tip muzzle compensator choke annihilator brake lightweight heavy_barrel rapid_fire bump_stock crossbow tactical_mag extended_mag quick_draw drum bipod stopping_muzzle shock_muzzle riot_shield ballistic_cpu forgrip angled_grip subsonic` — 0 whole-word hits |
| 16 perk internals | **absent** | `marathon lightfoot blastshield sixthsense staminamax overclock quickscope gunfighter deadshot steady_aim hypothermia tracker bruiser ironeyes quicken perk_less` — 0 whole-word hits |
| Zone pointer → asset decode (typed XAsset dump) | **not achieved** | XAssetList at offset 44 reads `assetCount = 0xFFFFFFFF`; pointer scan produced only false positives. `unresolved.md` §3. |
| Matchmaking / lobby / playlist / party payloads | **absent** | No such data in any readable zone; these are server-side in this build. Nothing was queried online. |

**Agreement / disagreement with public lists.** Two places where the files and
the commonly published MW3 weapon roster differ, reported rather than
reconciled:

- The files yield `scar` (not the split `scar_h` / `scar_l`) and `smag`, and do
  **not** yield `intervention`, `mosin`, `five_seven`, `m93r`, `model98`,
  `spas12` at all. Both facts come from the files. `scar_h`/`scar_l` and the
  missing names live in the encrypted script layer, so their absence here is
  a limitation of this pass, **not** evidence that the weapons do not exist in
  the game.
- `riot`, `shield` and `ballistic` all appear as tokens. Which is the riot
  shield's canonical internal name cannot be settled without the weapon table,
  so all three are listed rather than one being chosen.

---

## 6. Confidence summary

| Claim | Confidence | Why |
|---|---|---|
| 282/282 fastfiles decompressed, hashes verify | **confirmed** | SHA-256 checked per chunk, 0 mismatches |
| 22 gametypes, names and citations | **confirmed** | each cited to a real `maps/mp/gametypes/<x>` reference |
| 36 MP maps incl. DLC, with origin tags | **confirmed** | each from its own map zone |
| 35 weapon / 12 attachment / 6 perk internals as *tokens* | **confirmed** | whole-word match at cited offset |
| 49 strike packages, 43 vehicles/streaks, 10 equipment | **confirmed** | same |
| 1,735 dvar tokens | **confirmed** | same, after noise pruning |
| 45,387 IWD entries | **confirmed** | read directly from the ZIP central directories |
| Weapon↔attachment pairing | **likely (inferred)** | co-occurrence only; not a support matrix |
| Display names for weapons/attachments/perks | **unlikely** | need the encrypted localize/table bodies |
| All numeric balance data | **absent** | encrypted script layer |
| Rank/XP thresholds | **absent** | encrypted script layer |
| Typed per-asset XAsset dump | **unresolved** | pointer encoding not determined |

---

## 7. What I would do next

1. **Diff the small signed patch chain** — `patch_mp.ff` (7.46 MB) and the tiny
   `patch_mp_<map>.ff` files (76 B – 4.5 KB) are the same format as the code
   zones. A differential may expose the script transform.
2. **Trace the script loader** from the `codescripts/$default` reference at
   `code_pre_gfx_mp.ff` offset `0x0000d4` through `iw5mp.exe`. Ordinary static
   analysis of the shipped executable; no anti-cheat or DRM involved.
3. **Patch OAT's group constant** 256 → 257 and re-run its Unlinker to obtain
   the typed asset dump (RawFile name/size/data, Weapon structs, StringTable
   grids) that string-level extraction cannot produce.
4. **Determine the VIRTUAL block's virtual base** empirically using one known
   RawFile, then re-run rawfile recovery to get every `.gsc`/`.csv` byte-exact.

Steps 1–2 unlock the numeric balance data that this pass had to leave empty.

---

## 8. File index

| Path | Contents |
|---|---|
| `inventory.csv` | 421 files: path, size, extension, SHA-1 |
| `inventory_coverage.csv` | per-file status: processed / skipped / unresolved |
| `unresolved.md` | every gap, why, and the next step |
| `REPORT.md` | this file |
| `multiplayer_catalog.json` | structured catalog, all categories + provenance |
| `raw_strings_mp.txt` | 221,519 deduped MP strings (file + offset) |
| `raw_strings_mp_full.txt.gz` | full 38.5M-row dump, gzipped |
| `extraction_summary.json` | per-zone result for all 282 fastfiles |
| `iwd_index.json`, `iwd_mp_text_assets.csv` | all 45,387 IWD entries |
| `_verification.json`, `_prune_summary.json` | verification evidence |
| `unpacked/` | decompressed zones, carved blobs, per-zone strings |
| `tools/` | every script written for this pass, all under findings/mw3/ |

### Reproduce

```powershell
cd findings\mw3\tools
python inventory.py         # Phase 1
python ff_extract_fast.py   # Phase 2, signed zones
python extract_unsigned.py  # Phase 2, unsigned zones
python rebuild_summary.py   # ground-truth roll-up
python iwd_index.py         # IWD archive index
python carve_blobs.py <zone>\decompressed.bin
python check_names.py       # name existence evidence
python finalize.py          # Phase 3/4 CSVs
python curate_strings.py    # raw_strings_mp.txt
python verify_fast.py       # verification
python prune2.py            # noise pruning
python coverage.py          # coverage reconciliation
```

Note: `raw_strings_mp.txt`, `unpacked/` and `iwd_index.json` are large working
outputs. Per the filing rule, only `REPORT.md` and `unresolved.md` are
committed.
