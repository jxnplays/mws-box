# unresolved.md — Call of Duty: Modern Warfare 3 (IW5, PC)

Scope: read-only extraction of multiplayer content from
`[local path] of Duty Modern Warfare 3`.

This file lists every format we could **not** fully decode, why, and what the
next concrete step would be. Nothing here is guessed: each entry records the
measured evidence that produced it.

---

## 1. GSC script bodies are encrypted (the single largest gap)

**Status: unresolved — blocks most of Phase 3.**

### What we proved

MW3 splits its files into two layers:

| Layer | Files | Contents |
|---|---|---|
| Data zones | `common_mp.ff`, `mp_*.ff`, `localized_*.ff`, `patch_mp.ff`, `ui_mp.ff` | assets: XModels, GfxImages, sounds, fx, localize strings, menu/asset-name tables |
| Code zones | `code_pre_gfx_mp.ff`, `code_post_gfx_mp.ff`, `localized_code_*_mp.ff`, `patch_mp_*.ff` | the actual **`.gsc` gameplay logic and the `.csv` balance tables** |

The code zones decompress cleanly (e.g. `code_pre_gfx_mp.ff` → 6,046 bytes,
`code_post_gfx_mp.ff` → 1.93 MB) but their payload is **encrypted**.

Measured on `zone/english/code_pre_gfx_mp.ff` (payload = 6,002 bytes after the
44-byte XFile header):

```
distinct byte values : 256  (full range)
most common byte     : 0xff  3.27%,  0x00  2.23%
Shannon entropy      : 7.874 bits/byte
best single-byte XOR : 43.4% printable  (key 0x26)  -> not a simple XOR
```

7.874 bits/byte with all 256 byte values present is the signature of
compressed-or-encrypted data, not source text. By contrast the *decrypted*
regions of the same files are plainly readable, and the GSC **filenames** sit
in cleartext immediately before the encrypted bodies:

```
00012f752  6d 61 70 73 2f 6d 70 2f 67 61 6d 65 74 79 70 65   maps/mp/gametype
00012f762  73 2f 64 6f 6d 00 78 da e5 57 cd 8b 1c 45 14 af   s/dom\0<x zlib>
```

A search for canonical GSC source constructs across all 99 decompressed MP
zones returned **zero** hits for `#include`, `function x(`, `level.x =`,
`self.x =`, `thread x`, `waitfor(`, and `ent_path(`:

| construct | hits across all MP zones |
|---|---|
| `#include "` | 0 |
| `function name(` | 0 |
| `level.x =` | 0 |
| `self.x =` | 0 |
| `thread name` | 0 |
| `waitfor(` | 0 |
| `ent_path(` | 0 |

### Direct consequence for Phase 3

Every value that lives *only* in the encrypted scripts is unrecoverable by
string carving. Measured coverage of canonical internals:

| category | found | searched | note |
|---|---|---|---|
| weapons | 35 | 50 | 15 absent (e.g. `intervention`, `mosin`, `galil`, `five_seven`, `m93r`, `fists`) |
| attachments | 12 | 37 | 25 absent (`red_dot`, `ap_tip`, `rapid_fire`, `bump_stock`, `akimbo`-class tables, `tactical_mag`, `ballistic_cpu`, …) |
| perks | 6 | 22 | 16 absent (`marathon`, `lightfoot`, `quickscope`, `gunfighter`, `deadshot`, `steady_aim`, `hypothermia`, `bruiser`, `quicken`, `perk_less`, …) |

The names that *are* found survive because they are also referenced by
asset-name strings, menu text, or localize keys in the **data** zones. The
numeric balance data (damage, fire rate, recoil, clip/reserve ammo, ADS and
reload timing, movement multipliers, penetration, XP tables, rank thresholds,
squad-point costs, unlock levels) is defined in the encrypted bodies and is
therefore **not present in any deliverable**. Those CSV columns are emitted
empty on purpose rather than filled from memory or a wiki.

### Next step

The protection is MW3's own script obfuscation, not DRM and not anti-cheat.
The legitimate next steps, in order of expected yield:

1. Diff `code_post_gfx_mp.ff` (base) against `patch_mp.ff` and
   `patch_mp_<map>.ff`. Patch zones are tiny (76 B – 4.5 KB) and are the same
   format; a differential may expose the transform or reveal which cipher
   family is in use.
2. Recover the in-game decryption path by tracing the `codescripts/$default`
   loader reference found in `code_pre_gfx_mp.ff` (offset `0x0000d4`) through
   `iw5mp.exe`. This is ordinary static analysis of the shipped executable.
3. Check whether the *shipped* `patch_mp_*.ff` chain contains any unencrypted
   script variant before concluding the body format is uniform.

No DRM or anti-cheat component is touched by any of the above, and nothing in
this pass modified the game folder.

---

## 2. OpenAssetTools crashes on multi-group IW5 zones

**Status: unresolved (upstream bug), worked around.**

`Laupetin/OpenAssetTools` v0.33.0 `Unlinker.exe` reads IW5 zones but crashes
with `0xC0000005` on every MP zone larger than ~2 MB. Empirically isolated
cause: the real authed-block group is **257 chunks (1 hash table + 256 data)**,
while the tool uses `AUTHED_CHUNK_COUNT_PER_GROUP = 256`
(`src/ZoneCommon/Game/IW5/ZoneConstantsIW5.h`).

Measured on `zone/english/common_mp.ff`: the group-2 hash table sits at file
offset `0x204015`, which is `0x204015 - 0x2015 = 0x202000 = 257 × 0x2000`
bytes after the group-1 hash table — i.e. 257 chunks per group, not 256. The
tool desynchronises after group 1 and reads garbage.

Because the tool additionally size-limits output and does not emit the IW5
XAsset table without a valid header, it produced **no usable asset rows**.
Our own parser (`tools/ff_extract_fast.py`, documented in §4) implements the
257-chunk layout and decompresses all 99 MP zones with every SHA-256 chunk
hash matching.

### Next step

Report the 256-vs-257 discrepancy upstream, or patch the constant to 257 and
re-run the Unlinker to obtain typed asset dumps (RawFile/Localize/Weapon)
that our string-level extraction cannot produce.

---

## 3. XAsset / XAssetList table not decoded

**Status: unresolved — pointer encoding not fully determined.**

Every MP zone decompresses correctly and all chunk hashes verify, but the
inner XFile asset index was not parsed. Layout is confirmed:

```
0x00  uint32      zone_size
0x04  uint32      external_size
0x08  uint32[9]   XBlock sizes      (TEMP, PHYSICAL, RUNTIME, VIRTUAL,
                                      LARGE, CALLBACK, VERTEX, INDEX, SCRIPT)
0x2C  ...         content stream
```

Verified on `common_mp.ff`: `zone_size = 105,633,132`,
blocks = `[643348, 0, 0, 62199086, 0, 0, 31621760, 4445152, 776400]`.

At stream offset 44 the 16-byte `XAssetList` reads
`{count=1429, strings=0x00000000, assetCount=0xFFFFFFFF, assets=0xFFFFFFFF}`,
i.e. the asset count is the sentinel `-1`, so the asset array is not where the
`ARCH_x86` reader path expects it. Zone pointers use
`(block << 28) | (offset & 0x0FFFFFFF)`, stored `+1`
(`src/ZoneLoading/Zone/Stream/ZoneInputStream.cpp`), but scanning for dense
runs of valid `{type, ptr}` records produced only false positives (menu and
font data). RawFile recovery by that route returned 0 headers.

Consequence: per-asset typed data (RawFile name/size/data triples, Weapon
struct fields, StringTable column/row counts, attachment stat blocks) was not
recovered; all deliverables are therefore string-level.

### Next step

Instrument the loader chain from `ContentLoaderIW5::Load()` to observe the
real `XAssetList` position and the block-base mapping, or derive the virtual
base of the VIRTUAL block empirically once a single known RawFile
(`maps/mp/gametypes/dom` → blob at `0x127f76a`) is located by pointer rather
than by proximity.

---

## 4. Our own parser — documented structure

`tools/ff_extract_fast.py`. Used because no existing tool handles IW5
correctly (§2). Structure confirmed against 180 zones:

```
ZoneHeader      0x00  char[8] "IWff0100" (signed) | "IWffu100" (unsigned)
                0x08  uint32 version = 1
                0x0C  uint8  unknown (skipped by the loader too)
                0x0D  uint64 timestamp
--- signed only ---
AuthHeader      0x15  char[8] "IWffs100"
                0x1D  uint32 reserved
                0x21  uint8[32]  sub-header SHA-256
                0x41  uint8[256] RSA-PSS/SHA-256 signature
                0x141 char[32]  fastfile name   (matches the .ff basename)
                0x161 uint32    reserved
                0x165 uint8[32][256] master block hashes (SHA-256)
--- payload ---
AuthedBlocks    first 0x2000-byte chunk is the auth header + padding.
                Groups of 257 chunks: [hash table][256 data chunks].
                The hash-table chunk's SHA-256 must equal
                masterBlockHashes[group]; each data chunk's SHA-256 must
                equal its entry in that table.
                Concatenated data chunks -> one continuous zlib stream.
--- unsigned only ---
                no auth header, no chunking: a single continuous zlib
                stream starting at file offset 0x15.
```

All 256 master-block hashes and every data-chunk hash verified for each
signed MP zone processed; zero mismatches.

---

## 5. Xbox / big-endian zone variants

**Status: not applicable to this install — recorded for completeness.**

`zone/dlc/*_specops.ff` and the `so_*` survival zones failed zlib inflate.
Their headers are `IWff0100` with LE version 1, so they are not the IW4
big-endian Xbox variants (those carry version 269/253). They are
SPEC-Ops/Survival content rather than multiplayer, so they were not pursued.
If needed, next step is to test the 48-byte-zone-header Xbox path described in
`ZoneLoaderFactoryIW4.cpp`.

---

## 6. Files deliberately skipped (not unresolved)

| group | files | reason |
|---|---|---|
| Steam/DRM | `steam_api64.dll`, `steamclient.dll`, `SteamAPIUpdater.dll`, `UpdateDLLWrapper.dll`, `*.sdm` | not game data; anti-cheat/DRM untouched by policy |
| binaries | `iw5mp.exe`, `iw5sp.exe`, `tier0_s.dll`, `vstdlib_s.dll`, `bink2w64.dll` | strings carved only; no disassembly performed |
| images | `logo.bmp`, `splash.bmp` | not MP data |
| metadata | `installscript.vdf`, `localization.txt` | install metadata |

`iw5mp.exe` was carved for strings only. It is the multiplayer executable and
is a legitimate target for the script-loader analysis proposed in §1; that
analysis was **not** performed in this pass.
