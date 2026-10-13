# NX1 key locator

`nx1-locate.ps1` — a reusable locator for the `NXffs100` key in NX1 fastfiles.
Facts only. No field named, no struct asserted, no layout claimed.

## What the script does

Takes one fastfile path. Finds the first ASCII `NXffs100`. Prints the offset and the four
bytes immediately following the 12-byte key.

```
.\nx1-locate.ps1 -Path "[local path] of Duty Future Warfare\NX1\mp_nx_galleria.ffm"
mp_nx_galleria.ffm | offset 98198 (0x17F96) | next4 0F 04 54 4C
```

Reports `not in source` when the string is absent, so it is safe to run across the whole
root rather than only on files known to contain the key.

Read-only. It decompresses nothing, opens no `.bin`, and writes nothing to disk. The scan
is chunked with `$patLen - 1` overlap so a match cannot be split across a read boundary,
and uses single-byte encoding (28591) for the same reason.

## The script does not interpret the body

It prints the four bytes after the key and stops. It does not say what they are, does not
assert a header layout, and names no field. Its header comment records the observed facts
it relies on — the 12-byte key, the 16-byte file opening, the load-versus-map offset
behaviour — as descriptive only, with an explicit note that the bytes following the key
are not interpreted.

## Verification: 24 of 24 matched, zero mismatches

The locator was run on every `mp_*.ffm` in the NX1 root and both the offset and the four
trailing bytes were compared against `key-table.md`, per file.

| | Count |
|---|---|
| Files located | 24 |
| Lines in key-table.md | 24 |
| Mismatches | 0 |

The table was built by a separate one-off scan, so the locator reproduces it from
independent code. No file reported `not in source`. No file appeared in one listing and
not the other, so the comparison covered both directions.

## Offset distribution

**Twelve `_load.ffm` files at offset 86.** A fixed offset across twelve files of differing
size and content.

**Twelve map files between 48,854 and 100,790.** Varies per map.

Not a fixed constant, and not a function of file size.

## The 24 values, for reference

```
mp_nx_blank1.ffm          55478 (0xD8B6)   35 82 12 56
mp_nx_blank1_load.ffm     86 (0x56)       74 46 12 10
mp_nx_bom.ffm             54758 (0xD5E6)   92 B5 5B EB
mp_nx_bom_load.ffm        86 (0x56)       BE 0F 51 B0
mp_nx_fallout.ffm         48854 (0xBED6)   16 72 B8 B4
mp_nx_fallout_load.ffm    86 (0x56)       07 ED A3 93
mp_nx_galleria.ffm        98198 (0x17F96)  0F 04 54 4C
mp_nx_galleria_load.ffm   86 (0x56)       1B 86 0B 8C
mp_nx_lockdown.ffm        75062 (0x12536)  1B 41 30 68
mp_nx_lockdown_load.ffm   86 (0x56)       80 AD 60 4A
mp_nx_lockdown_v2.ffm     84902 (0x14BA6)  B4 56 E0 04
mp_nx_lockdown_v2_load.ffm 86 (0x56)      DA 36 4A CB
mp_nx_meteor.ffm          54950 (0xD6A6)   21 FC C8 50
mp_nx_meteor_load.ffm     86 (0x56)       F5 A5 3A 1A
mp_nx_pitstop.ffm         87686 (0x15686)  A9 D7 99 33
mp_nx_pitstop_load.ffm    86 (0x56)       A0 F4 48 12
mp_nx_sandstorm.ffm       73958 (0x120E6)  87 C3 53 96
mp_nx_sandstorm_load.ffm  86 (0x56)       5F DE EC 35
mp_nx_skylab.ffm          75110 (0x12566)  52 D6 4C 4F
mp_nx_skylab_load.ffm     86 (0x56)       4D F6 7C 9F
mp_nx_stasis.ffm          100790 (0x189B6) 66 50 5E 85
mp_nx_stasis_load.ffm     86 (0x56)       2D 7A A0 B6
mp_nx_ugvhh.ffm           87062 (0x15416)  3B 74 84 0D
mp_nx_ugvhh_load.ffm      86 (0x56)       1F 58 8A 65
```

All 24 `next4` values are distinct; no two files share one.

## The four bytes after the key are not a length

The `next4` values `nx1-locate.ps1` prints are not a size, not an offset, and not a
CRC32 of the body that follows them.

Worked example, `mp_nx_blank1_load.ffm` (270,567 bytes), bytes at offset 98:

| | Value |
|---|---|
| Hex | `74 46 12 10` |
| Little-endian | 269,633,140 |
| Big-endian | 1,950,749,200 |
| File length | 270,567 |

`74 46 12 10` is 269633140 little-endian and 1950749200 big-endian, both past end of the
270567-byte file. Not a size. Not an offset. Not a CRC32.

CRC-32 over offsets 102 to end of file is `A38DC92A`, which matches neither byte order.
Standard reflected CRC-32, polynomial `EDB88320`.

The same disqualification applies to offsets 16-19 in the load files, where both byte
orders also exceed the file length.

**An earlier note in this investigation called these values in range. That was wrong.**
Both exceed the file length by roughly three orders of magnitude. The error was in the
interpretation, not in any measured value; the CRC result was correct throughout. The
erroneous contrast is struck rather than deleted, so the record shows what was claimed
and why it was wrong.

Not established what these four bytes are. A seeded CRC, a checksum over a differently
bounded region, or another digest all remain consistent with the observations. The locator
does not interpret them and neither does this note.

## The 16-byte prefix holds

Every `NXff0100` file checked opens with `NXff0100` plus `00 00 01 65 00 00 01 CC`:

```
4E 58 66 66 30 31 30 30  00 00 01 65 00 00 01 CC
```

Confirmed on four files, spanning every key placement found in the tree:

| File | `NXffs100` at |
|---|---|
| `ui_mp.ffm` | 38 |
| `mp_nx_blank1_load.ffm` | 86 |
| `common_mp.ffm` | 41510 |
| `mp_nx_galleria.ffm` | 98198 |

The prefix is identical in all four despite key offsets spanning 38 to 98198. It is stable
regardless of where the key lands.

Recorded as a shared byte sequence, not a header definition. No field is named and no
structure is asserted.

## `NXffu100` files do not carry `NXffs100`

Across all 31 non-`mp_` fastfiles in the NX1 root, the correspondence is exact:

| Opening | Files | Carry `NXffs100` |
|---|---|---|
| `NXffu100` | 20 | 0 |
| `NXff0100` | 11 | 11 |

No file opening with `NXffu100` contains the key anywhere in its contents, and every file
opening with `NXff0100` does. This settles an earlier open question and retires a wrong
reading: `nx_border.ffm` opens with `NXffu100` and was initially taken to be single-player
by its magic, but it is not an outlier — no `NXffu100` file carries the key.

The single-player executables are `1-nx1sp.xex`, `3-nx1sp_fast_server.xex` and
`4-nx1sp_demo.xex`, but no `.ff`/`.ffm` container in the root is named `nx1sp`; fastfiles
are named by content. `NXffu100` should therefore not be read as an MP/SP classification
of the file's contents.

Four distinct key placements now exist across the tree: offset 38 (10 non-`mp_` MP files),
offset 86 (12 `_load.ffm` map files), 48854-100790 (12 map files), and offset 41510
(`common_mp.ffm`). What distinguishes them is not established.

## Build identification

**Hidden Palace, December 18 2011 prototype. `NX1_DEV` 1.0, Build 546, `CODEBOT3`.
Xbox 360.**

Build string as recorded in `REPORT-nx1.md`: `Build 546 12/18/2011 21:02:16 CODEBOT3
SHOOT FOR THE STARS`.

## Key offset 38 is independent of file size

The ten fastfiles whose `NXffs100` sits at offset 38:

| File | Size |
|---|---|
| `code_pre_gfx_mp.ff` | 24,614 |
| `ez_common_mp.ffm` | 24,614 |
| `ez_ui_mp.ffm` | 24,614 |
| `patch_mp.ffm` | 24,614 |
| `development_mp.ffm` | 40,998 |
| `ui_mp.ffm` | 7,725,094 |
| `code_post_gfx_mp.ffm` | 1,294,374 |
| `common_sound_nx1_lunar_mp.ffm` | 18,309,158 |
| `common_sound_iw4_mp.ffm` | 19,398,694 |
| `common_sound_nx1_mp.ffm` | 25,272,358 |

A thousandfold spread — 24,614 to 25,272,358 — with the key at offset 38 in every one.
The placement does not track file size.

The same holds for the other placements: offset 86 across the twelve `_load.ffm` files
regardless of length, and map-file offsets varying from 48,854 to 100,790 with no
correlation to size. `common_mp.ffm` at offset 41510 is 273,399,669 bytes, the largest
file in the root, and carries the largest key offset observed.

No explanation is offered for what determines placement. Recorded as measured.

## The four 24,614-byte files are not identical

SHA-256:

| File | SHA-256 |
|---|---|
| `code_pre_gfx_mp.ff` | `E93302323366D638D8FF5FEA26B9BF637FA076A248B12D551ECE145C03F42E1B` |
| `ez_common_mp.ffm` | `26ED2E79DA50671D515601534A6E0D1B04EDA30D905AA8FDE5E240A22FA8CDA3` |
| `ez_ui_mp.ffm` | `4361F8B6923630DE6EE71E05E38FBD6B843F45457C7161E893275C896F2B212A` |
| `patch_mp.ffm` | `A21C03678E0A4C57DE1429ADABFF1A83EE54AA5FA59A2E120A5ACDA84D4E0E37` |

Four unique hashes. Same length, same key offset at 38, same 16-byte opening — entirely
distinct contents.

`fastfile_extraction_manifest.csv` already recorded identical `InSize` of 24,614 with
differing `Blocks` and `OutSize`; the hashes confirm that byte-exactly rather than
inferring it from the manifest.

The equal size is recorded as an observation. Padding-to-alignment is a guess and is not
offered as a cause.

## The compressor enum is zlib and lzx

`0-Nightly MP maps.mp.pdb` contains `DB_COMPRESSOR_ZLIB` and `DB_COMPRESSOR_LZX`. Both are
enumerators of `DB_CompressorType`.

```
DB_COMPRESSOR_ZLIB
DB_COMPRESSOR_LZX
DB_CompressorType
```

The PDB also names `DecompressStreamLzx` and `XCOMPRESS_FILE_HEADER_LZXNATIVE`, among a
wider set of LZX decoder symbols:

```
DecompressStreamLzx     DecompressSegmentTDLzx    DecompressLzx
LZX_Decode              LZX_DecodeInit            LZX_DecodeFree
LZX_DecodeNewGroup      LZX_DecodeInsertDictionary
InitializeDecompressionContextLzx
GetDecompressionContextSizeLzx
DestroyDecompressionContextLzx
g_LZXInternalState      g_lzxDecmpContext
XCOMPRESS_FILE_HEADER_LZXNATIVE   XCOMPRESS_FILE_HEADER_LZXTDECODE
XCOMPRESS_BLOCK_HEADER_LZXNATIVE
```

**No fastfile has been shown to use either type.** The enum's existence does not establish
what any given file contains. `Mixed compressor types specified` is a literal in
`db_fastfile_load.obj`, which implies a file may carry both types across its streams, but
that too is unverified for any specific file.

### Why the extraction underperformed

The extractor only accepts a zlib frame. `extract_all_ff2.ps1` line 35 tests for the
zlib header bytes `78 01`, `78 9C` and `78 DA` at each offset and advances one byte where
none matches. **An LZX body would be skipped**, because those framing bytes would generally
not occur.

This is consistent with what was measured, and is offered as the explanation rather than a
verified one:

- 86 fastfiles unpacked to 9.08 GB across 100,841 blocks, but very little of that proved
  usable as asset data.
- No zlib header sits adjacent to any `NXffs100` marker in any file examined.
- Both `78 01` candidates that were tested failed to decode, the first with
  `Found invalid data while decoding` after decoding had begun.

A per-stream mixture of the two types would defeat a single-signature scan outright, which
is a second way the same result follows.

LZX is a Microsoft/Windows compression format and is not documented by Microsoft. No
algorithm detail is inferred here; the symbol names are recorded as found.

### Scope

All four PDBs in the NX1 root are multiplayer builds, so this finding applies to the
multiplayer fastfiles. No single-player PDB exists to confirm it for SP builds.

To determine which type a given file actually uses, `XCOMPRESS_FILE_HEADER_LZXNATIVE`
would need to be decoded from a real file. That has not been done.

No field named, no structure asserted.

## LZX header type names

`0-Nightly MP maps.mp.pdb` contains `XCOMPRESS_FILE_HEADER_LZXNATIVE` and
`XCOMPRESS_FILE_HEADER_LZXTDECODE`. Two LZX header types, not one.

```
XCOMPRESS_FILE_HEADER_LZXNATIVE
XCOMPRESS_FILE_HEADER_LZXTDECODE
```

`CompressedBlockSizeMax` is adjacent. **No value was read** for it, and none is asserted.
Its presence suggests a per-block size limit; that is an inference from the name.

`XCOMPRESS_FILE_HEADER_LZXNATIVE` occurs three times in the PDB:

| Offset | Context |
|---|---|
| 0x164A264 | string-pool entry, adjacent to unrelated timer symbols |
| 0x20EF99F | declaration, beside `CompressedBlockSizeMax` |
| 0x20EF9C1 | declaration, `_XCOMPRESS_FILE_HEADER_LZXNATIVE` followed by `U_XCOMPRESS_FILE_HEADER_LZXNATIVE@@` |

So one hit is a name-table entry and two are the structure's declaration, the second
carrying the `U_...@@` type-descriptor form.

**No fastfile has been shown to carry either header.** Three hits in a debug-info PDB
establish that both structures are compiled into the multiplayer binary. They do not
establish what any fastfile contains.

No field named, no structure asserted, no layout claimed. Neither header's internal layout
is decoded.

Decoding either header from a real file would settle which type a given file uses. That has
not been done.

## No LZX decoder on disk

**No LZX decoder script or binary is in the NX1 root.** Two searches establish this at
different levels.

**Scripts.** All seven scripts in `output\` — `extract_ff.ps1`, `extract_all_ff.ps1`,
`extract_seq.ps1`, `extract_all_ff2.ps1`, `carve_mp.ps1`, `build_catalog.ps1`,
`nx1-locate.ps1` — were searched for LZX and lzx. Zero matches. **The seven extract
scripts only call `DeflateStream`.**

**Files.** A recursive search of every file in the NX1 root for `lzx`, `xcompress` or
`decompress` returned two hits, both `.xma2` audio whose names merely contain
decompression-adjacent wording:

```
AMB_EMITTERS\emt_wind_airplane_decompressed1.xma2
VOICEOVERS\NX_LUNAR\moon_hawk_ext_decompression.xma2
```

Neither is a decoder or an executable. No file named for `lzx` or `xcompress` exists.

### Where the capability actually lives

The LZX decoder is compiled into the Xbox 360 executable. Per the PDB symbols recorded
above, `NXff*` handling sits in `db_fastfile_load.obj` inside the `.xex`, with
`DB_LoadXFile`, `DB_SetCompressor`, `DecompressStreamLzx` and `LZX_Decode` among its
symbols. That code is not present in this dump in any form that can be executed here.

Seven *data* files in `output\` do mention LZX — `symbols_mp.txt`, `symbols_mp_all.txt`,
`symbol_strings.txt`, `pdb_strings.txt`, `pdb_decoded_strings.txt`, `save_svg_strings.txt`
and `unresolved.md`. Those are carved string dumps, not code. The names are available; a
decoder is not.

## The body after the key is unread

`ui_mp.ffm` at offset 50, 12 bytes past the key at 38:

```
0032  F9 7C F1 72 12 D2 D1 CB 4B  9A D8 B3 15 44 AC EB
0042  3A E3 22 9F 93 9C B9 B8 D6  65 91 A9 6A 81 B2 15
```

High entropy. No repeated run at four-byte granularity, no zero run, no recoverable
structure. Consistent with the 32-byte window compared across three load files earlier,
where zero of 32 positions matched between files.

**The body after the key is unread.** Across every file and offset examined, no zlib
header sits adjacent to the key, every tested `78 01` candidate has proved a coincidental
match in high-entropy data, and the `NXffs100` marker itself never appears in any of the
2,818 extracted blocks.

This is the standing limit on the whole line of work. The key is located and its
placement is characterised; what follows it is not decoded, and nothing on disk can decode
it.

No field named, no structure asserted, no header invented.

## LZX header name cluster

Names adjacent to `_XCOMPRESS_FILE_HEADER_LZXNATIVE`:

```
CompressedSizeLow
CompressedSizeHigh
UncompressedBlockSize
CompressedBlockSizeMax
```

Names adjacent to `_XCOMPRESS_BLOCK_HEADER_LZXNATIVE`:

```
CompressedBlockSize
pCompressedData
```

**Names only. No offsets, no types.** Each is a readable token in the PDB within 128 bytes
of the target, recorded as a string present in the binary. No field is assigned to any of
them, no member list is claimed, and nothing here indicates which fastfile on disk — if
any — carries either header.

### Two earlier fragments were window cuts

`zeHigh` and `zeMax` were not additional fields. Both were partial tokens produced by the
128-byte scan window cutting a name in half:

| Fragment seen | Full token | Extent in file |
|---|---|---|
| `zeHigh` | `CompressedSizeHigh` | 0x20EF912..0x20EF923 |
| `zeMax` | `CompressedBlockSizeMax` | 0x20EF96E..0x20EF983 |

Both full tokens were read from the file and confirmed delimited on each side by
non-printable bytes.

`zeMax` and `CompressedBlockSizeMax` are the **same string at the same address** —
0x20EF97F is inside 0x20EF96E..0x20EF983. So the `zeMax` fragment was not a neighbour of
the header token; it was the tail of a token already recorded intact in both 128-byte
windows. Listing it separately implied two names where there is one.

Both targets also carry the same leading-underscore plus `U_...@@` descriptor pairing:

```
_XCOMPRESS_FILE_HEADER_LZXNATIVE     U_XCOMPRESS_FILE_HEADER_LZXNATIVE@@
_XCOMPRESS_BLOCK_HEADER_LZXNATIVE    U_XCOMPRESS_BLOCK_HEADER_LZXNATIVE@@
```

which is consistent with a declaration site rather than a string-pool entry. That is an
observation about formatting, not a layout claim.

### Not established

No byte layout for either structure. No field widths, offsets, or types. The names above
are the recoverable content; the LZX format itself is not decoded, and no LZX decoder
exists in the NX1 root to test any candidate interpretation against.

## LZX inflate functions

Six symbols, all confirmed as **functions** in `db_auth.obj` by the `f` flag in
`2-nx1mp.map`:

```
0007:0011d890   ?DB_AuthInitLZX@@YAXXZ                                     822ed890 f
0007:0011d928   ?DB_AuthLoad_InflateLZX@@YAHPAUdb_z_stream_s@@@Z            822ed928 f
0007:0011dd38   ?DB_AuthLoad_InflateInit@@YAHPAUdb_z_stream_s@@HPBD@Z       822edd38 f
0007:0011da90   ?DBX_AuthLoad_InflateCopyBuffer@@YAHPAUdb_z_stream_s@@H@Z   822eda90 f
0007:0011d740   ?DBX_AuthLoad_ProcessDataBlock@@YA_NPAE@Z                   822ed740 f
0007:0011d848   ?DBX_AuthLoad_ProcessChunk@@YA_NPAEPA_N@Z                   822ed848 f
```

| Symbol | Address |
|---|---|
| `DB_AuthInitLZX` | 0x0011d890 |
| `DB_AuthLoad_InflateLZX` | 0x0011d928 |
| `DB_AuthLoad_InflateInit` | 0x0011dd38 |
| `DBX_AuthLoad_InflateCopyBuffer` | 0x0011da90 |
| `DBX_AuthLoad_ProcessDataBlock` | 0x0011d740 |
| `DBX_AuthLoad_ProcessChunk` | 0x0011d848 |

Six contiguous addresses within about 2 KB, consistent with one cohesive routine group.

### db_z_stream_s is a type name, not proof the body is zlib

Three of the six carry `PAUdb_z_stream_s@@` in their decoration — a pointer to
`db_z_stream_s`:

```
DB_AuthLoad_InflateLZX
DB_AuthLoad_InflateInit
DBX_AuthLoad_InflateCopyBuffer
```

The remaining three do not: `DB_AuthInitLZX` takes no argument, and the two
`DBX_AuthLoad_Process*` routines take a single pointer.

`db_z_stream_s` is the zlib stream structure by name. **That is a type name, not proof
the body is zlib.** The LZX routines operate on a type named for a zlib stream, which may
mean LZX reuses a zlib-shaped stream interface, that the name is historical, or that the
type is shared with the zlib path. None of those is established here, and none should be
inferred from the decoration alone.

No signature has been invented beyond what the mangled decoration states verbatim.

## The stream struct is zlib-shaped

`db_z_stream_s` occurs seven times in the PDB. In the declaration neighbourhoods it sits
adjacent to:

```
state   zalloc   zfree   opaque   data_type
db_inflate_blocks_state
```

**Names only.** No offset, width or type is claimed for any of them, and no field is
assigned to `db_z_stream_s` here.

Those five names, in that order, are the members of zlib's `z_stream` in zlib's own
declaration order. `zalloc` and `zfree` are zlib's allocator callbacks.

### Two further symbols

`DB_AuthLoad_Inflate` and `DB_AuthLoad_InflateEnd` are also present, each with a
`db_z_stream_s` argument:

```
?DB_AuthLoad_Inflate@@YAXPAUdb_z_stream_s@@HH@Z
?DB_AuthLoad_InflateEnd@@YAXPAUdb_z_stream_s@@@Z
```

The inflate routine also carries the format string `g_load?4stream?4avail_out`, and the
init routine carries `init?5failed`.

### A zlib-shaped stream does not mean the fastfile body is zlib

The struct is zlib-shaped. That is a statement about a type name and its adjacent member
names, and nothing follows from it about file contents.

What would settle it is a body: either a valid zlib frame decoding, or an LZX frame
decoding under an LZX implementation. Neither has been done. No LZX decoder exists in the
NX1 root, and every zlib-frame signature tested so far has proved a coincidental match in
high-entropy data.

The struct being zlib-shaped is in fact consistent with the LZX reading — an interface
shaped for zlib streams can be driven by either compressor. Which it is here is not
determined.

## Compressor ordinals are not in the name trail

The 16 bytes after `DB_COMPRESSOR_ZLIB` and `DB_COMPRESSOR_LZX` in the PDB **do not store
a small integer**. Both names are followed by another symbol or by non-printable debug
framing.

Each name occurs twice in the PDB:

```
DB_COMPRESSOR_ZLIB  @0x19923F0  00 00 00 00 1A 00 07 11 FD 10 01 00 01 00 44 42
DB_COMPRESSOR_ZLIB  @0x24035C4  00 F3 F2 F1 02 15 03 00 01 00 44 42 5F 43 4F 4D
DB_COMPRESSOR_LZX   @0x199240F  00 1A 00 0D 11 FD 10 01 00 C8 70 00 00 0B 00 67
DB_COMPRESSOR_LZX   @0x24035DF  00 36 00 07 15 03 00 00 02 74 00 00 00 FC 10 01
```

At three of the four sites another name begins inside the 16-byte window — `DB_COMPRES`,
`DB_COMPRESSOR_`, `DB_Comp`. The fourth is non-printable throughout with `g_compres`
just beyond it. No enumerator value is recoverable this way.

First-four-byte little-endian values, recorded for completeness and **not** as stored
ordinals:

| Site | First 4 bytes | LE uint32 |
|---|---|---|
| ZLIB @0x19923F0 | `00 00 00 00` | 0 |
| ZLIB @0x24035C4 | `00 F3 F2 F1` | 4,059,230,976 |
| LZX @0x199240F | `00 1A 00 0D` | 218,110,464 |
| LZX @0x24035DF | `00 36 00 07` | 117,454,336 |

Only the first is small, and it is a run of zero bytes rather than a stored value.

The recurring `XX 00 YY 00 ZZ 03 00 00 02` shape, with `1A`, `0D`, `36` and `07` varying
where a name length would sit and the next name starting immediately after, is consistent
with debug-info record framing rather than data. That is an observation about the byte
pattern, not a decoded structure.

**Enumerator values are not recoverable this way.** Whether `DB_COMPRESSOR_ZLIB` is 0 and
`DB_COMPRESSOR_LZX` is 1, or any other assignment, is not established. The two names are
confirmed as enumerators of `DB_CompressorType`; their numeric values are not known.

## The probe fails closed

`nx1-lzx-probe.ps1` finds `NXffs100` using the locator rule, reads 32 bytes at 12 past
that offset, and prints `no decoder` plus the hex. **It does not decode.**

On `ui_mp.ffm`:

```
no decoder + F9 7C F1 72 12 D2 D1 CB 4B 9A D8 B3 15 44 AC EB 3A E3 22 9F 93 9C B9 B8 D6 65 91 A9 6A 81 B2 15
```

The hex **matches the hand read at offset 50** of the same file, so the tool reproduces
that window from the marker rather than by hand. High entropy, no repeated run at
four-byte granularity, no zero run.

`no decoder` is unconditional and is **not a verdict on the bytes**. It states that this
toolchain has nothing able to decompress them: no LZX decoder exists in the NX1 root,
script or binary, and `DeflateStream` is not called. Whether this particular body is zlib
or LZX remains untested.

The probe emits no interpretation, claims no header, and assigns no field. That is the
point of it — it records bytes it cannot read rather than guessing at them.

## No LZX decoder on machine

`nx1-lzx-decode.ps1` searched **`[local path]` and `[local path] Files` by filename** for
`lzx` and `xcompress`, across `.dll`, `.exe`, `.sys` and `.ocx`.

```
searching [local path] [local path] Files for names containing: lzx, xcompress
no decoder on machine
```

**Result: no decoder on machine.** Nothing found under either root.

### Filename search only

The search matches on name and nothing else. No file is loaded, executed, or inspected
beyond its filename. An LZX or XCompress implementation present under an unrelated name
would not be detected.

So the result is "none detectable by name," which is narrower than "none installed."

### The fastfile body is still unread

Nothing found on this machine, and nothing in the NX1 root or the extraction scripts, as
recorded earlier. `DeflateStream` is available but accepts only a zlib frame, and every
zlib-frame signature tested has proved a coincidental match in high-entropy data.

**The fastfile body is still unread.** The key is located and its placement characterised
across 24 `mp_*.ffm` files plus 11 non-`mp_` files; what follows the key is not decoded,
and no tool available here can decode it. Passing this point requires implementing an LZX
decoder or obtaining one — not finding one.

## LZX decompress entry points

`DecompressLzx` and `DecompressStreamLzx` take `_LZXDECOMPRESSION_CONTEXT_HEADER`. Mangled
as written, not reconstructed:

```
DecompressLzx@XCOMPRESS@@YAHPAU_LZXDECOMPRESSION_CONTEXT_HEADER@1@PAXPAKPBXK@Z
DecompressStreamLzx@XCOMPRESS@@YAHPAU_LZXDECOMPRESSION_CONTEXT_HEADER@1@PAXPAKPBX2@Z
XMemDecompressStreamLzx@XCOMPRESS@@YAJPAX0PAKPBX1@Z
```

The context type is the one recorded earlier in the `db_z_stream_s` neighbourhood,
alongside `state`, `zalloc`, `zfree`, `opaque` and `data_type`.

Also present:

```
XMemDecompressStreamLzx
XMemResetDecompressionContextLzx
fast_decode_aligned_offset_block
```

`DecompressStreamLzx` occurs six times in the PDB; `XMemDecompressStreamLzx`,
`XMemDecompressLzx`, `XMemDecompressSegmentTDLzx`, `XMemResetDecompressionContextLzx`,
`fast_decode_aligned_offset_block` and `LEndianSwap8In16` appear in adjacent clusters.
`XCOMPRESS@@` confirms the namespace throughout.

`PAXPAKPBX1` and `PAXPAKPBX2` differ only in the final token. Recorded as it stands; what
that difference denotes is not decoded.

**Names only. No body has been decoded.** No parameter binding, no return type, no
calling convention beyond the decoration text quoted above. No fastfile body has been
decoded by anything, and no decoder exists in the NX1 root or on this machine to decode
one — see the entries above.

## LZX context header names

`_LZXDECOMPRESSION_CONTEXT_HEADER` is adjacent to:

```
LzxFlags
WindowSize
LzxData
```

**Names only.** No offset, width or type is claimed for any of them, and no member is
assigned to the struct.

The fullest form appears in the PDB as:

```
XCOMPRESS::_LZXDECOMPRESSION_CONTEXT_HEADER.U_LZXDECOMPRESSION_CONTEXT_HEADER@XCOMPRESS@@
```

`Common` also appears beside this type in one window.

The type is passed by pointer to `DestroyDecompressionContextLzx`,
`ResetDecompressionContextLzx`, `DecompressLzx`, `DecompressStreamLzx` and
`DecompressSegmentTDLzx`.

### Not proof it shares a layout with db_z_stream_s

An earlier entry recorded `db_z_stream_s` adjacent to `Common`, `LzxFlags`, `WindowSize`
and `LzxData` **in that order**. The same four names in the same order now appear beside
`_LZXDECOMPRESSION_CONTEXT_HEADER`.

That is name adjacency in the debug-info string pool. **It is not proof the two
structures share a layout**, and no such claim is made here. Same-named members in one
region of a PDB are not evidence of common offsets, widths, or types, and none has been
read. Establishing that would require decoding either structure, which has not been done.

### No body has been decoded

No fastfile body has been decoded by anything. No LZX decoder exists in the NX1 root or on
this machine — see the entries above — so nothing here can decode one. All findings in
this document are names, offsets of strings within the PDB, and file-level observations.

## The name trail cannot yield values

Bytes after `WindowSize` in the PDB are **the next string-pool record, not a stored
integer**.

`WindowSize` occurs 9 times in the PDB. Exactly one sits within 128 bytes of
`_LZXDECOMPRESSION_CONTEXT_HEADER`, at 0x243B362. The 16 bytes after that token are:

```
65 F3 F2 F1 0D 15 03 00 FD 3B 00 00 14 00 4C
```

`LzxData` begins at offset +16. No small integer is present; the first four bytes read
`0xF2F30065`.

**Name-trailing cannot recover member values.** These are name strings in the debug-info
pool, not struct instances. Reading bytes after a name reads whatever follows that string
in the pool, so it structurally cannot yield a member's stored value. An empty result here
is the expected outcome of the method and says nothing about the member.

The same applies to the `DB_COMPRESSOR_ZLIB` and `DB_COMPRESSOR_LZX` ordinals recorded
earlier: those trails held debug framing and the next name, and the enumerator values were
not recoverable there either.

**A value needs a decoded body. No decoder exists here** — none in the NX1 root, none in
the extraction scripts, none detectable on this machine by filename. So no member value,
enumerator ordinal, or size can be recovered from this material by this route.

## The body is not raw XEX LZX at the key

`LZXDecoder` from `sp00nznet/360tools` (`tools/lzx_decompress.py`, saved as
`output\lzx_decompress.py`) **rejected offset 50 of `ui_mp.ffm` with block type 7.**

LZX block types are 1 (verbatim), 2 (aligned) and 3 (uncompressed). The decoder read the
leading three bits as 7 and raised before producing output.

### Seventeen start offsets did not decode a stream

64 bytes at offset 50, sliced from start offset 0 through 16, output size 4096. Seven
failed on block type. **Ten reported a length of 4096.**

Those ten are not decodes:

| Start | Entropy | Distinct bytes | Output |
|---|---|---|---|
| 3, 4, 9, 11, 13, 14, 16 | 0.000 | 1 | one byte repeated (`DC`, `02`, `36`, `00`, `01`) |
| 6 | 0.124 | 37 | 4058 of 4096 bytes `00` |
| 15 | 0.107 | 32 | 4063 of 4096 bytes `00` |

**Ten reported a length of 4096 of a repeated byte or near-zeros, which is the decoder's
initial window, not file data.** The decoder allocates and fills `output_size` regardless
of how much valid input it consumed; `self.window` starts as `b'\xDC' * window_size` with
`R0 = R1 = R2 = 1`, so a run that decodes a single offset-1 match against an untouched
window emits that byte throughout. The `DC` output at start 3 is that initial value
passing straight through.

Control: 64 zero bytes fail with `Invalid LZX block type: 0`, and 64 `0xFF` bytes fail
with block type 7. The decoder rejects some non-streams, but only on block type, with no
integrity check after that gate.

### What this means

The bytes at the key are **not a raw XEX2 LZX stream**, under any of 17 alignments tried
in this region. That is a stronger negative than the single-offset attempt: it is not
just that offset 50 is wrong, but that the surrounding bytes are not LZX at any offset
tested.

It does not exclude LZX entirely. `lzx_decompress.py` is third-party code written for
Xbox 360 XEX2 containers, not for `NXff*` fastfiles. `NXff*` may frame its data
differently — with its own header, or an outer container the decoder does not expect — so
this rules out raw LZX at the key, not LZX as the underlying algorithm. The
`DB_COMPRESSOR_LZX` enumerator and the LZX decoder symbols recorded earlier stand
unaffected.

No `.xex` was opened. `DeflateStream` was not called. No header is claimed for these bytes.

## The PDB directory is zeroed

**The MSF 7.00 magic is real, and the earlier note that tooling was the only gap was
wrong.**

`0-Nightly MP maps.mp.pdb` opens with the standard PDB 7.00 magic:

```
Microsoft C/C++ MSF 7.00\r\n\x1ADS\0\0\0
```

That is genuine. But the superblock behind it does not parse:

```
4D 69 63 72 6F 73 6F 66 74 20 43 2F 43 2B  2B 20 4D 53 46 20 37 2E
30 30 0D 0A 1A 44 53 00 00 00
```

Page size 1024, 38171 pages used, directory size 158464 — and then **every field from
offset 0x38 is zero**: `numdirblocks=0`, `numstreams=0`, `dirstreamsize=0`.

`pdbparse` 1.5 was installed on this machine for the attempt. It raised
`KeyError: 62195` while reading the root stream. **`DB_CompressorType` cannot be
recovered.**

So the blocker is not a missing tool. A standard PDB parser, given a file with standard
magic and a zeroed directory, still has nothing to read.

**The non-standard layout note in `REPORT-nx1.md` stands.** An earlier entry in this
document treated that note as wrong on the strength of the magic alone, and concluded the
type stream went unread only because no PDB parser was available. That conclusion is
withdrawn. The header is standard while the structure behind it is not, which is closer to
what `REPORT-nx1.md` described.

No claim is made here about why the directory is zeroed — whether the dump is partial,
truncated, or the PDB was written differently on this target is not established.

`DB_CompressorType` ordinals, `db_z_stream_s` member offsets and the
`_LZXDECOMPRESSION_CONTEXT_HEADER` layout all remain unrecoverable from this material.

## The PDBs are two zeroed copies

**The four PDB names are two files.**

| Pair | SHA-256 | Size |
|---|---|---|
| `0-Convoy Test 1_5.mp.pdb` | `9038E69743FF42591189768D11F9B7B7CE7A654D1F3B2483A3409109262816CC` | 28,781,568 |
| `5-nx1mp_demo.pdb` | *(identical)* | 28,781,568 |
| `0-Nightly MP maps.mp.pdb` | `9FA33A4C2C9FCEF2DAB2C737090A3E8C2A6AD002C552423BEC017A20A4A5268F` | 39,087,104 |
| `6-nx1mp_fast_server.pdb` | *(identical)* | 39,087,104 |

Convoy matches demo. Nightly matches fast server. This confirms the build pairing that
`REPORT-nx1.md` previously asserted from matching sizes alone, now established by content.

**Both are MSF 7.00 with directory fields zero from offset 0x38.**

Superblock fields are populated up to 0x37 — in the 28.7 MB file, `0x28` reads
`CB 6D 00 00` and `0x34` reads `C4 6D 00 00`, plausible directory-adjacent values — and
then every field from 0x38 onward is zero: `numdirblocks=0`, `numstreams=0`,
`dirstreamsize=0`.

**`DB_CompressorType` is not recoverable from either.** `pdbparse` 1.5, installed for the
attempt, raised `KeyError: 62195` reading the root stream.

There are two distinct PDBs and no untested PDB remains in the root. The zeroed-directory
finding rests on both, and it is a complete result rather than a partial one.

No explanation is offered for the zeroing. Whether the dump is partial, the PDB was
written differently on this target, or something else applies is not established.

## Offset 338 is not a name slot

**Offset 338 is not a name slot.** It holds `code_pre_gfx_mp` in that one file only.

32 bytes read at 338 in three other fastfiles:

| File | ASCII at 338 |
|---|---|
| `ez_common_mp.ffm` | `NXff0100...e......._............` |
| `ez_ui_mp.ffm` | `NXff0100...e......."............` |
| `patch_mp.ffm` | `NXff0100...e....................` |

**All three have `NXff0100` at offset 338.** None contains its own filename there.

### Why this is a stub pattern, not a name field

The `NXff0100` reappearing at 338 is a second copy of the file magic, well past the one at
offset 0. A repeated magic is what a stub or placeholder record would carry, not a name.

The offset is empty of names in all three files — every position after byte 8 is
non-printable except a lone `e`, and a `_` or `"` at position 15 in two of them. So this is
not evidence of a name field elsewhere holding a *different* string; there is simply no
name at 338 to find.

The `code_pre_gfx_mp` literal at 338 in `code_pre_gfx_mp.ff` remains the only case of a
fastfile naming itself in its own body. That was one observation, not a pattern, and it is
not reproduced by any of these three.

These three files share the 24,614-byte size recorded in the hash table, yet differ from
each other and from `code_pre_gfx_mp.ff` at this offset. Same size, different content,
consistent with the SHA-256 table.

## A second magic at 338

Offset 338 holds a second `NXff0100` in five of six files checked:

```
ez_common_mp.ffm
ez_ui_mp.ffm
patch_mp.ffm
ui_mp.ffm
mp_nx_blank1_load.ffm
```

**`code_pre_gfx_mp.ff` has its own name there instead** — `code_pre_gfx_mp`, and that
filename occurrence is not reproduced anywhere else.

So the repeated magic is the common case and the filename is the exception, which is the
reverse of what a name-slot reading predicts. The two map-group files in this set span
both key placements — `ui_mp.ffm` at 38, `mp_nx_blank1_load.ffm` at 86 — so the 338
repetition is not tied to either placement.

What the second magic is remains unestablished. It is a repeated copy of the 8 bytes at
offset 0, appearing 338 bytes in. Whether it marks a stub record, an embedded sub-header,
or something else is not determined, and no field is assigned to it.

## The 338 reading is withdrawn

**The second `NXff0100` at 338 is not general. It is absent in `mp_nx_galleria.ffm`.**

Eight bytes at 338 in that file read `02 57 D9 35 00 00 00 00` — not either file magic.

| File | Key at | ASCII at 338 |
|---|---|---|
| `ez_common_mp.ffm` | 38 | `NXff0100` |
| `ez_ui_mp.ffm` | 38 | `NXff0100` |
| `patch_mp.ffm` | 38 | `NXff0100` |
| `ui_mp.ffm` | 38 | `NXff0100` |
| `mp_nx_blank1_load.ffm` | 86 | `NXff0100` |
| `mp_nx_galleria.ffm` | **98198** | **absent** |
| `code_pre_gfx_mp.ff` | 38 | `code_pre_gfx_mp` |

**Withdraw the header-slot reading.** The entry immediately above this one recorded the
second magic as a general property at offset 338 across five files. That generalisation was
wrong and is withdrawn. Five files agreeing is not a rule, and the sixth contradicts it.

Size does not separate the cases either. `mp_nx_galleria.ffm` is 269,945,205 bytes;
`mp_nx_blank1_load.ffm` is 270,567 bytes and does carry the second magic. Key placement is
the only factor distinguishing them in what has been checked, and one data point is not a
pattern.

So what remains true at 338: the second `NXff0100` appears in the small offset-38 group
and in one offset-86 load file, is absent from a map file with a far-offset key, and in
`code_pre_gfx_mp.ff` holds the filename instead. Nothing about a header slot is
established, and the earlier "not a name slot" entry remains accurate only in that no
*name* was found there.

## Correction: offset 338 does hold a name

The `mp_nx_blank1_load.ffm` second-magic reading was wrong — that file has `NXff0100` only
at offset 0. But re-reading the other four shows the error was wider than that one file.

**Offset 338 does hold a name slot.** It holds each fastfile's own filename:

```
ez_common_mp.ffm   338:  ez_common_mp
ez_ui_mp.ffm       338:  ez_ui_mp
patch_mp.ffm       338:  patch_mp
ui_mp.ffm          338:  ui_mp
code_pre_gfx_mp.ff 338:  code_pre_gfx_mp
```

| File | Key at | ASCII at 338 |
|---|---|---|
| `ez_common_mp.ffm` | 38 | `ez_common_mp` |
| `ez_ui_mp.ffm` | 38 | `ez_ui_mp` |
| `patch_mp.ffm` | 38 | `patch_mp` |
| `ui_mp.ffm` | 38 | `ui_mp` |
| `mp_nx_blank1_load.ffm` | 86 | absent |
| `mp_nx_galleria.ffm` | 98198 | absent |
| `common_mp.ffm` | 41510 | absent |
| `code_pre_gfx_mp.ff` | 38 | `code_pre_gfx_mp` |

### Entries withdrawn

Earlier entries in this document reported `NXff0100` at offset 338 in these files, then
rejected the name-slot reading on that basis, then withdrew the header-slot reading when
`mp_nx_galleria.ffm` contradicted it. **All of that rested on wrong bytes.** The earlier
reads produced `NXff0100...e......._...` where the file actually contains its own name.

What stands: offset 338 holds a name in five of eight files, all with key at 38. The three
files with keys far into the file are absent there. `code_pre_gfx_mp.ff` was never an
outlier — it was the only one of the batch read correctly the first time.

Still valid throughout this document, having been established by whole-file scan rather
than by offset-338 reads: the key placements (38, 86, 41510, 98198) and the `NXffs100`
occurrence counts.

### Not established

Why the offset-338 reads returned wrong bytes. They used the same method as the surrounding
work at the stated offset, and no whole-file verification was done on them at the time.
Until that is understood, any other single-offset read in this investigation that was not
independently confirmed should be treated as suspect.

## The name at 338 matches the filename

Confirmed at 32 bytes in the five key-at-38 files. In every case the name at offset 338 is
exactly the filename without its extension, zero-terminated, with zero padding out to 32
bytes.

| File | Filename stem | Name at 338 | Length |
|---|---|---|---|
| `ui_mp.ffm` | `ui_mp` | `ui_mp` | 5 |
| `ez_ui_mp.ffm` | `ez_ui_mp` | `ez_ui_mp` | 8 |
| `ez_common_mp.ffm` | `ez_common_mp` | `ez_common_mp` | 12 |
| `patch_mp.ffm` | `patch_mp` | `patch_mp` | 8 |
| `code_pre_gfx_mp.ff` | `code_pre_gfx_mp` | `code_pre_gfx_mp` | 15 |

Five of five match. This is the same finding as the correction committed as `44b63d9`,
re-verified at full 32-byte width rather than 8.

### No shared prefix at 322

The 16 bytes at 322 **differ across all five files from the first byte**. There is no
shared prefix. Those bytes are high-entropy and unrelated between files.

No length prefix, offset, or size field is visible in 322-337, and none is claimed. The
name is simply zero-terminated, with no preceding length indicator in the 16 bytes before
it.

Combined with the earlier table, the name slot at 338 holds the fastfile's own filename in
five of eight files checked, all with the key at offset 38. `mp_nx_blank1_load.ffm` (key
86), `mp_nx_galleria.ffm` (98198) and `common_mp.ffm` (41510) are absent there, confirmed
at 16 bytes. That correlation is eight observations, not an established rule.

## The 32-byte name slot at 338

On the five key-at-38 files, **offset 338 is a 32-byte zero-padded filename.**

| File | Filename stem | Name at 338 | Length |
|---|---|---|---|
| `ui_mp.ffm` | `ui_mp` | `ui_mp` | 5 |
| `ez_ui_mp.ffm` | `ez_ui_mp` | `ez_ui_mp` | 8 |
| `ez_common_mp.ffm` | `ez_common_mp` | `ez_common_mp` | 12 |
| `patch_mp.ffm` | `patch_mp` | `patch_mp` | 8 |
| `code_pre_gfx_mp.ff` | `code_pre_gfx_mp` | `code_pre_gfx_mp` | 15 |

The name is zero-terminated and padded with zeros out to 32 bytes. Five of five match the
filename exactly.

**Offset 370 is four zero bytes** in all five. That is the tail of the padding, not a
shared field — name lengths run 5 to 15, so padding begins at 343, 346, 350, 346 and 353
respectively.

**Offset 374 is four per-file bytes, not a size in either endian.** All ten readings — five
files, two byte orders each — exceed their file's length. The closest is `ez_ui_mp.ffm`
big-endian at 52,772,859 against a 24,614-byte file, still over 2,000x the file size.

| File | Bytes at 374 | Little-endian | Big-endian |
|---|---|---|---|
| `ui_mp.ffm` | `42 7E D8 C2` | 3,268,968,002 | 1,115,609,282 |
| `ez_ui_mp.ffm` | `03 25 3F FB` | 4,215,219,459 | 52,772,859 |
| `ez_common_mp.ffm` | `BF 06 03 9F` | 2,667,775,679 | 3,204,842,399 |
| `patch_mp.ffm` | `A7 0C 51 69` | 1,766,919,335 | 2,802,602,345 |
| `code_pre_gfx_mp.ff` | `67 12 FA 58` | 1,492,783,719 | 1,729,296,984 |

### Absent on the other three

**Absent on the load file, `mp_nx_galleria.ffm`, and `common_mp.ffm`.** `mp_nx_blank1_load.ffm`
(key 86), `mp_nx_galleria.ffm` (98198) and `common_mp.ffm` (41510) carry no filename at
338, confirmed at 16 bytes.

So the 32-byte name slot appears in five of eight files checked, all with the key at offset
38. That correlation is eight observations, not an established rule.

No field beyond the name is claimed. The bytes at 322-337 before the name differ across all
five files from the first byte, so there is no shared prefix and no visible length prefix.

## Name slot across the key-at-38 files

Ten of ten key-at-38 files now carry their own filename at offset 338. No exceptions.

| File | Name at 338 | Length | File | Name at 338 | Length |
|---|---|---|---|---|---|
| `ui_mp.ffm` | `ui_mp` | 5 | `code_post_gfx_mp.ffm` | `code_post_gfx_mp` | 16 |
| `ez_ui_mp.ffm` | `ez_ui_mp` | 8 | `common_sound_iw4_mp.ffm` | `common_sound_iw4_mp` | 19 |
| `patch_mp.ffm` | `patch_mp` | 8 | `common_sound_nx1_mp.ffm` | `common_sound_nx1_mp` | 19 |
| `ez_common_mp.ffm` | `ez_common_mp` | 12 | `common_sound_nx1_lunar_mp.ffm` | `common_sound_nx1_lunar_mp` | 25 |
| `code_pre_gfx_mp.ff` | `code_pre_gfx_mp` | 15 | `development_mp.ffm` | `development_mp` | 14 |

`common_sound_nx1_lunar_mp` at 25 characters occupies 338-362, leaving seven zero bytes to
complete the 32-byte window. So the slot holds at least 25 characters plus a terminator.

The three files without the slot all have keys far into the file: `mp_nx_blank1_load.ffm`
at 86, `mp_nx_galleria.ffm` at 98198, `common_mp.ffm` at 41510. **Eleven of eleven
key-at-38 files have the name slot; three of three others do not.**

### The four zeros at 370

**The four zeros at 370 are after the 32-byte name, which ends at 369. They are not
leftover name padding.**

This corrects the description in the preceding entry, which attributed the zeros at 370 to
the tail of the name's own zero padding. The name occupies 338-369 inclusive as a 32-byte
field. Offset 370 is the first byte after that field, not part of it.

That reading only becomes visible with longer names. For `ui_mp` at 5 characters, the
padding inside the field runs 343-369, so a zero at 370 looks continuous with it. For
`common_sound_nx1_lunar_mp` at 25 characters, padding runs 363-369 and 370 begins the next
region.

So the correct description is: the 32-byte name field ends at 369, and offset 370 begins
whatever follows it. The four bytes at 374 are per-file and not a size in either endian,
as recorded above.

### Not established

Why the slot is present only in key-at-38 files. The correlation is eleven of eleven and
three of three, but no mechanism is claimed for it.

## Name record closed for key-at-38

**All 10 key-at-38 files have a 32-byte filename at 338 and four zero bytes at 370. The
four bytes at 374 are per file and not a size.**

| Offset | Content |
|---|---|
| 338-369 | 32-byte zero-padded filename, equal to the file's stem |
| 370-373 | four zero bytes |
| 374-377 | four per-file bytes, not a size in either endian |

Confirmed at 8 bytes on the five files read most recently:

```
code_post_gfx_mp.ffm             00 00 00 00 31 20 A4 CD
common_sound_iw4_mp.ffm          00 00 00 00 2A B8 CE 17
common_sound_nx1_lunar_mp.ffm    00 00 00 00 FF BF E3 80
common_sound_nx1_mp.ffm          00 00 00 00 87 7D 94 C0
development_mp.ffm               00 00 00 00 51 E4 8C 0F
```

All ten key-at-38 files begin with four zeros at 370; bytes 374-377 differ per file and all
twenty readings in both byte orders exceed their file's length.

### The 370 correction, now with evidence

The entry before last attributed these zeros to the tail of the name's own padding. The
five files read above disprove that: with name lengths 14 to 25, padding inside the 32-byte
field ends at 369 in every case, and 370 is separately zero.

The error was visible only for short names. `ui_mp` at 5 characters pads 343-369, so zeros
at 370 look continuous with it. `common_sound_nx1_lunar_mp` at 25 characters pads 363-369,
which makes the boundary at 370 unambiguous.

This closes the name record for the key-at-38 group. The three files without it —
`mp_nx_blank1_load.ffm` (86), `mp_nx_galleria.ffm` (98198), `common_mp.ffm` (41510) — remain
absent at 338, 370 and 374 alike.

## A ten-byte run at 22

`00 00 00 01 00 00 00 00 00 00` at offset 22, present in all three files read there:

| File | Bytes at 22 |
|---|---|
| `ui_mp.ffm` | `00 00 00 01 00 00 00 00 00 00` |
| `development_mp.ffm` | `00 00 00 01 00 00 00 00 00 00` |
| `patch_mp.ffm` | `00 00 00 01 00 00 00 00 00 00` |

Three of three hold. The `01` sits at offset 25 in each. **No value is read from it and no
field is claimed** — a consistent pattern across three files is not a decoded meaning.

This sits outside the name record at 338-377 and is the only shared structure found ahead
of the key.

The surrounding 22 bytes at offset 16 differ between files from byte 17 onward: byte 16 is
`BC` in both, 17-21 differ per file, 22-31 are the run above, and 32-37 differ
structurally. `ui_mp.ffm` repeats a four-byte unit `75 E0 26 00` twice at 32-37;
`development_mp.ffm` has `A0 26` twice at different offsets. Recorded as byte-value
observation only.

The key at offset 38 is `NXffs100` in both `ui_mp.ffm` and `development_mp.ffm`, consistent
with the placement already recorded.

## Correction: the shared run is nine bytes

**The ten-byte run in `1fcfe09` was too long. The shared run is nine bytes, offsets 22-30,
on all 10 key-at-38 files. Byte 31 differs.**

```
00 00 00 01 00 00 00 00 00
```

Ten of ten files read at offset 22 carry these nine bytes identically. The `01` sits at
offset 25 in each.

Byte 31 is the first that varies:

| File | Bytes at 22 | Byte 31 |
|---|---|---|
| `ui_mp.ffm` | `00 00 00 01 00 00 00 00 00` + `00` | `00` |
| `development_mp.ffm` | `00 00 00 01 00 00 00 00 00` + `00` | `00` |
| `patch_mp.ffm` | `00 00 00 01 00 00 00 00 00` + `00` | `00` |
| `code_pre_gfx_mp.ff` | `00 00 00 01 00 00 00 00 00` + `00` | `00` |
| `ez_common_mp.ffm` | `00 00 00 01 00 00 00 00 00` + `00` | `00` |
| `ez_ui_mp.ffm` | `00 00 00 01 00 00 00 00 00` + `00` | `00` |
| `code_post_gfx_mp.ffm` | `00 00 00 01 00 00 00 00 00` + `13` | `13` |
| `common_sound_iw4_mp.ffm` | `00 00 00 01 00 00 00 00 00` + `01 28` | `01` |
| `common_sound_nx1_mp.ffm` | `00 00 00 01 00 00 00 00 00` + `01 81` | `01` |
| `common_sound_nx1_lunar_mp.ffm` | `00 00 00 01 00 00 00 00 00` + `01 17` | `01` |

### Why the earlier claim was wrong

`1fcfe09` reported a ten-byte run on the strength of three files — `ui_mp.ffm`,
`development_mp.ffm` and `patch_mp.ffm`. All three had `00` at byte 31, and all three are
of similar length, so the sample did not vary the value that mattered.

Reading seven more files found `13` and `01 28`, `01 81`, `01 17` at byte 31. The run is
nine bytes; byte 31 is per file.

The substance of `1fcfe09` stands — a shared structure ahead of the key, with `01` at offset
25, present in all ten key-at-38 files. Only the length was wrong, and it was stated with
more confidence than three files supported.

No value is read from byte 31 and no field is claimed. What the nine-byte run and the `01`
mean is not established.

## The public linker is a zlib writer

`riicchhaarrd/linker_nx1`, `linker.c`. Third-party code, not NX1 source.

**It writes `NXffu100` with zlib, handles `rawfile` and `localize` only, and never reads
an `.ffm`.**

```c
XFileHeader header = { 0 };
memcpy(&header.magic, "NXffu100", sizeof(header.magic));
header.version = 357;
```

```c
uLongf compressed_size = compressBound(filesize);
if(compress(compressed_data, &compressed_size, input_data, filesize) != Z_OK)
```

`compress()` and `compressBound()` are the zlib one-shot API, built against `miniz.h`; the
zlib include is commented out at the top of the file. A second `compress_memory()` using
`mz_deflateInit`/`mz_deflate`/`MZ_FINISH` is present but unused.

Asset types, from `asset_type_for_string()`:

| CSV token | Type |
|---|---|
| `localize` | `ASSET_TYPE_LOCALIZE_ENTRY` |
| `rawfile` | `ASSET_TYPE_RAWFILE` |

`scriptStrings` is empty. `serialize_raw_file` sets `compressedLen = 0` with the comment
"Don't compress lol", so the zlib call applies to the whole-file payload only.

### It does not describe the NXff0100 files or NXffs100

The magic it writes is `NXffu100` — the single-player magic. **There is no path in this
linker to `NXff0100`**, the magic observed in all 24 `mp_*.ffm` files and the 11
non-`mp_` MP fastfiles in this dump.

It also never mentions LZX, `XCOMPRESS`, or `NXffs100`. And it never reads a fastfile at
all: it takes a CSV, builds a `.ffraw`, and writes `<mod>.ffm`. `read_file_to_memory()` loads
source assets listed in the CSV, not fastfiles.

So it is a fastfile authoring tool, not a reader, and cannot be used to decode anything in
this dump. It gives no evidence about the MP container format, about `NXffs100`, or about
whether LZX is used.

Its zlib writer and the runtime's `DB_COMPRESSOR_LZX` enumerator are not contradictory — a
tool may emit zlib while a runtime also accepts LZX — but nothing here resolves which
applies to any given fastfile.

## The file size at offset 34

**Offset 34 holds the file's own uncompressed size, big-endian 32-bit.**

| File | Hex at 34 | Big-endian | File size |
|---|---|---|---|
| `ui_mp.ffm` | `00 75 E0 26` | 7,725,094 | 7,725,094 |
| `development_mp.ffm` | `00 00 A0 26` | 40,998 | 40,998 |
| `patch_mp.ffm` | `00 00 60 26` | 24,614 | 24,614 |
| `code_post_gfx_mp.ffm` | `00 13 C0 26` | 1,294,374 | 1,294,374 |

**Four of four exact.** All four begin `00` and end `26` at offset 37. The middle bytes vary
correctly with magnitude across a 300-fold size range:

```
00 75 E0 26   ->  7,725,094
00 13 C0 26   ->  1,294,374
00 00 A0 26   ->     40,998
00 00 60 26   ->     24,614
```

24,614 and 40,998 differ only at byte 35; the two larger values differ at bytes 35 and 36.
That the encoding tracks size rather than varying randomly is what distinguishes this from
the coincidental matches recorded elsewhere in this investigation — a random 32-bit value
matching four independent file sizes exactly is not a plausible outcome.

Little-endian at 34 was checked once, on `ui_mp.ffm`, and read 652,244,224, far past end.
**Big-endian is the reading that fits.**

### Scope

Observed in four files, all with the key at offset 38. The other six key-at-38 files are
unchecked at this offset. No claim is made about the three files without the name slot, or
about the field's width or byte order for any other reader.

No field is named beyond this description, and no header layout is asserted. The fetched
`linker_nx1/linker.c` writes `zoneStart` and `zoneEnd` at the end of a 38-byte sequence
rather than a file size at offset 34, so this does not extend to that writer.

## The size at 34 holds across key-at-38

**Big-endian 32-bit at offset 34 is the file's uncompressed size, in ten of ten key-at-38
files. No exceptions.**

| File | Hex at 34 | Big-endian | File size |
|---|---|---|---|
| `ui_mp.ffm` | `00 75 E0 26` | 7,725,094 | 7,725,094 |
| `code_post_gfx_mp.ffm` | `00 13 C0 26` | 1,294,374 | 1,294,374 |
| `development_mp.ffm` | `00 00 A0 26` | 40,998 | 40,998 |
| `ez_common_mp.ffm` | `00 00 60 26` | 24,614 | 24,614 |
| `ez_ui_mp.ffm` | `00 00 60 26` | 24,614 | 24,614 |
| `code_pre_gfx_mp.ff` | `00 00 60 26` | 24,614 | 24,614 |
| `patch_mp.ffm` | `00 00 60 26` | 24,614 | 24,614 |
| `common_sound_nx1_mp.ffm` | `01 81 A0 26` | 25,272,358 | 25,272,358 |
| `common_sound_iw4_mp.ffm` | `01 28 00 26` | 19,398,694 | 19,398,694 |
| `common_sound_nx1_lunar_mp.ffm` | `01 17 60 26` | 18,309,158 | 18,309,158 |

All ten end in `26` at offset 37. The encoding tracks size across a 1,000-fold range, which
is what separates this from the coincidental matches recorded elsewhere in this document —
a random 32-bit value matching ten independent file sizes exactly is not plausible.

Little-endian at 34 was checked once, on `ui_mp.ffm`, and read 652,244,224 — far past end.
**Big-endian is the reading that fits.**

### Byte 31 also tracks size

`01` appears at byte 31 in six of the ten: all three sound fastfiles and the three 24,614-byte
files. `00` appears in `ui_mp.ffm`, `development_mp.ffm`, `patch_mp.ffm` and
`code_post_gfx_mp.ffm`. `13` appears in `code_post_gfx_mp.ffm`.

The `00` group is the four smallest files, 24,614 to 1,294,374. The `01` group runs
18,309,158 to 25,272,358. `code_post_gfx_mp.ffm` at 1,294,374 with `13` sits between them
without joining either.

Whether byte 31 is a separate field, a high-order digit, or part of a wider encoding is not
determined. No field is claimed for it.

### Scope

The three files without the name slot — `mp_nx_blank1_load.ffm` (key 86),
`mp_nx_galleria.ffm` (98198) and `common_mp.ffm` (41510) — are unchecked at offset 34. The
field's width or byte order for any other reader is not determined either.

The fetched `linker_nx1/linker.c` writes `zoneStart` and `zoneEnd` at the end of a 38-byte
sequence rather than a size at offset 34, so this does not extend to that writer.

## The size at 34 is key-at-38 only

**File size at offset 34, big-endian, holds on all 10 key-at-38 files. It does not hold on
`mp_nx_blank1_load.ffm`, `mp_nx_galleria.ffm`, or `common_mp.ffm`.**

| File | Hex at 34 | Big-endian | File size | Equal |
|---|---|---|---|---|
| `mp_nx_blank1_load.ffm` | `00 04 20 56` | 270,422 | 270,567 | no |
| `mp_nx_galleria.ffm` | `01 B7 FF 96` | 28,835,734 | 269,945,205 | no |
| `common_mp.ffm` | `02 03 42 26` | 33,767,974 | 273,399,669 | no |

None equals its file's size. The size field is confirmed only in the key-at-38 group.

### The load file's near miss is not a field

`mp_nx_blank1_load.ffm` reads **270,422 against a size of 270,567 — 145 bytes short.** A
value that close is not a random 32-bit read; 270,422 would be a plausible compressed or
zone length for that file.

**It is not claimed as a field.** It is one observation at one offset in one file, and the
other two read far off — by an order of magnitude in both cases — so nothing supports a
reading of what sits at 34 in these files. Whether it is a different quantity, or the same
field holding different contents, is not determined.

### Two absences in the same three files

The three files without the name slot lack both the 32-byte filename at 338 and the size at
34. Two independent absences in the same three files is a stronger observation than either
alone that they are a different container shape — but no mechanism for the difference is
claimed.

## patch.ffm inflates as zlib

**`patch.ffm` is `NXffu100`, 324 bytes, carries its size at offset 34, and holds a zlib
stream at offset 38 that inflates to 519 bytes of DLC strings. No `NXffs100`.**

| Property | Value |
|---|---|
| Magic at 0 | `NXffu100` |
| File size | 324 |
| Hex at 34 | `00 00 01 44` — big-endian 324, its own size |
| Body | offset 38 to end, **286 bytes**, opening `78 DA` |
| Inflated | **519 bytes** |
| `NXffs100` | absent |

The body begins `78 DA` — `0x78` is the zlib CMF byte, `0xDA` an FDICT-bearing FLG value.
Inflated with Python's `zlib` module. **No LZXDecoder was called, no `.xex` opened, no
other fastfile opened or inflated.**

### Inflated content

A DLC entitlement table of `FF FF FF FF` and `00 00 00 1A` separators, holding strings
including:

```
Unknown Content Package
DLC_UNKNOWN
&&2 disabled!
&&1 does not have the map pack.
DLC_PLAYER_DOESNT_HAVE_MAP_PACK
DLC_PLAYER_DOESNT_HAVE_MAP_PACK_NOT_ENABLED
DLC_PLAYLIST_MAPS_NOT_ENABLED
This playlist requires a map pack that you have, but other members of your party do not have.
This playlist requires map packs that you have, but other members of your party do not have.
DLC_NOTEVERYONEHASREQUIRED
patch
```

The stream ends with `patch`, the file's own stem — the same convention as the 32-byte
filename at 338 in the MP files.

### Scope

This is a decode of the **SP** side only. `patch.ffm` is `NXffu100`, lacks `NXffs100`, and
its body is plain zlib, which is the shape the third-party `linker_nx1` produces with
`compress()`. **It does not show that the MP fastfiles are zlib.** Whether the `NXff0100`
bodies are zlib or something else is undetermined, and the earlier LZX findings stand
unchanged.

## The key-at-38 body is not zlib at 50

**No key-at-38 fastfile carries a zlib frame at offset 50. Ten of ten.**

| File | Hex at 50 |
|---|---|
| `ui_mp.ffm` | `F9 7C` |
| `patch_mp.ffm` | `04 BD` |
| `code_post_gfx_mp.ffm` | `42 89` |
| `development_mp.ffm` | `A5 0B` |
| `ez_common_mp.ffm` | `B4 3A` |
| `ez_ui_mp.ffm` | `3B A4` |
| `code_pre_gfx_mp.ff` | `1C 74` |
| `common_sound_nx1_mp.ffm` | `42 DD` |
| `common_sound_iw4_mp.ffm` | `45 87` |
| `common_sound_nx1_lunar_mp.ffm` | `EA 13` |

**Count: 0 of 10** against `78 01`, `78 9C` and `78 DA`. Not one file has `78` as the byte
at 50, across ten files spanning 24,614 to 25,272,358 bytes. A leading `78` is the
requirement for a zlib stream.

### Scope

This is a negative result at **one offset chosen by this investigation**, not a boundary
shown by the format. The key sits at 38 and the size at 34; nothing determines where an MP
body begins. If the MP layout places header data past 50, this test read header bytes and
says nothing about the payload. **It is not a claim that these files contain no zlib
anywhere**, and no zlib header was searched for at any other offset.

The `patch.ffm` decode cannot be transferred to them. That file is `NXffu100`, carries no
`NXffs100`, and inflates from offset 38 immediately after the header — an offset the SP side
does establish, because the file decodes cleanly from there. The two sides remain separate:
one SP file decoded at a known-good offset, the MP bodies undecoded and their framing
undetermined.

Nothing was inflated for this result. No field named, no header asserted, no model name
emitted. LZXDecoder not called, no `.xex` opened.

## The MP body is not zlib at the key

**The 2 bytes immediately after `NXffs100` plus four zeros are not a zlib header — on the 10
key-at-38 files, nor on the load file, nor `common_mp.ffm`, nor `mp_nx_galleria.ffm`.**

| File | Key offset | Read offset | Hex |
|---|---|---|---|
| `ui_mp.ffm` | 38 | 50 | `F9 7C` |
| `patch_mp.ffm` | 38 | 50 | `04 BD` |
| `code_post_gfx_mp.ffm` | 38 | 50 | `42 89` |
| `development_mp.ffm` | 38 | 50 | `A5 0B` |
| `ez_common_mp.ffm` | 38 | 50 | `B4 3A` |
| `ez_ui_mp.ffm` | 38 | 50 | `3B A4` |
| `code_pre_gfx_mp.ff` | 38 | 50 | `1C 74` |
| `common_sound_nx1_mp.ffm` | 38 | 50 | `42 DD` |
| `common_sound_iw4_mp.ffm` | 38 | 50 | `45 87` |
| `common_sound_nx1_lunar_mp.ffm` | 38 | 50 | `EA 13` |
| `mp_nx_blank1_load.ffm` | 86 | 98 | `74 46` |
| `common_mp.ffm` | 41510 | 41522 | `DA 87` |
| `mp_nx_galleria.ffm` | 98198 | 98210 | `0F 04` |

**Zero of thirteen** match `78 01`, `78 9C` or `78 DA`. Not one has `78` as its first byte.

**`patch.ffm` remains the only body in this investigation that has been inflated.**

### Two limits on this negative result

**Offset 12 past the key is not a measured constant.** It is the gap observed in the
placement at 38, carried to placements 86, 41510 and 98198 without justification. No body
offset has been independently established for those three placements by any other means.
Since those files already differ from the key-at-38 group in two other respects — no
filename at 338, no size at 34 — assuming a third structural property is the same would
assume away what is being tested.

**This is a negative result at one chosen offset, not a claim about the payload.** No zlib
header was searched for at any other offset. `DA 87` at 41522 in `common_mp.ffm` has the
shape of a zlib FLG byte in leading position, but it is the second byte of an arbitrary
read at an unestablished offset and is **not** called a hit; the test was for the pair
`78 xx`. That shape has produced false positives elsewhere in this investigation and the
retractions are recorded above.

### Standing position

| Side | Body framing | Status |
|---|---|---|
| SP, `patch.ffm` | zlib at 38 | **inflated, 519 bytes** |
| MP, 13 files | not zlib at key+12 | undecoded, framing undetermined |

The MP fastfiles in this dump remain undecoded. Nothing here shows whether their bodies are
zlib elsewhere, LZX, or something else. The LZX findings elsewhere in this document stand
unchanged.

No field named, no header asserted, no model name emitted. Nothing inflated for this result,
no fastfile opened for it, LZXDecoder not called, no `.xex` opened.

## code_pre_gfx.ff inflates, and the SP side is split

**`code_pre_gfx.ff` is `NXffu100`, carries a zlib `78 01` frame at offset 38, and inflates
to 2,256 bytes.**

| Property | Value |
|---|---|
| File | `code_pre_gfx.ff`, 2,246 bytes |
| Bytes at 38 | `78 01` |
| Inflated | **2,256 bytes** |
| First run | `codescripts/$default`, at offset 104, 20 characters |
| Ends with | `code_pre_gfx` — the file's own stem |

Other strings present: `default.cfg`, `language.cfg`, `ragdoll.cfg`. The opening
`FF FF FF FF` / `00 00 00 24` separators match those in the inflated `patch.ffm`, and the
trailing stem follows the same convention as the 32-byte filename at 338 in the MP files.

### Eight of twenty `NXffu100` files have a zlib header at 38. Twelve do not.

| | Count |
|---|---|
| `NXffu100` files in the NX1 root | 20 |
| zlib header (`78 01` / `78 9C` / `78 DA`) at offset 38 | **8** |
| no zlib header at offset 38 | **12** |

Seven of the eight read `78 01`, which is the FLG for stored / no-deflate; `patch.ffm`
alone reads `78 DA`. **Only two of the eight have actually been inflated.** The reading
that the `78 01` bodies are stored rather than deflated rests on the two header bytes plus
the single `code_pre_gfx.ff` decode, not on seven.

The 12 non-zlib files all have a first byte at 38 in the range `00` through `04` — never
`78`, and consistently small in a way compressed output essentially never is, with values
rising alongside file size. That is suggestive of a small numeric field rather than a
stream start. **No field is claimed.** It is a 12-sample trend and could be coincidence.

### Two anomalies in code_pre_gfx.ff, recorded unexplained

**The inflated output is larger than the file.** A 2,208-byte body inflates to 2,256 bytes,
48 more than the whole 2,246-byte file. With FLG `01` the payload should not grow. Stored
blocks carry per-block overhead the outer wrapper may not account for, but that is a
guess — **no mechanism is claimed** on one measurement.

**A second `78 DA` appears at offset 152 in the inflated output**, right after
`default.cfg`, followed by `6D 8F 4D 4F`. It was not inflated. `78 DA` is the genuine
opening of a real stream in `patch.ffm`, so a coincidental `78 DA` mid-structure is
plausible and is the same shape that produced false positives elsewhere in this document.
**Nothing is claimed about it and its extent is unknown.**

### Multiplayer bodies are still unread

All 13 MP fastfiles checked so far read non-zlib at key+12. `patch.ffm` and
`code_pre_gfx.ff` are the only bodies in this investigation that have been inflated, both on
the **SP** side. Every MP file in this dump remains undecoded, and no confirmed framing is
shared between the two sides — the `NXffs100` key is absent from all 20 `NXffu100` files.

No fastfile opened or inflated for this entry. No field named, no header asserted, no model
name emitted. LZXDecoder not called, no `.xex` opened.

## The MP galleria stream inflates

**Offset 38 in `mp_nx_galleria.ffm` is `28,839,510`. There is a zlib `78 01` at that
offset, and it inflates to 49,152 bytes with no names.**

| Step | Result |
|---|---|
| Offset 34, big-endian | 28,835,734 — not the file size |
| Offset 38, big-endian | **28,839,510** |
| Bytes at 28,839,510 | `78 01` |
| Compressed length | 5,103 |
| End offset | 28,844,613 |
| Inflated | **49,152 bytes** — zero printable runs of 8 or more |
| Bytes at 28,844,613 | `78 01` — a further stream begins, not inflated |

Script: `output/one-gun/galleria_stream.py`. LZXDecoder not called, no `.xex` opened.

### This is the first confirmed MP-side decode

`mp_nx_galleria.ffm` is `NXff0100` at 269,945,205 bytes, carries `NXffs100` at 98,198, has
no filename at 338, and has no file size at 34. It shares no header feature with the ten
key-at-38 files, which have a size at 34 and no zlib header at key+12. Instead it points from
offset 38 to a stream that decodes.

That makes **four of four** files where the big-endian 32-bit value at offset 38 lands
exactly on a zlib header:

| File | Magic | Hex at 38 | Big-endian | Bytes there | Inflated |
|---|---|---|---|---|---|
| `common_ignore.ff` | `NXffu100` | `00 11 95 8A` | 1,152,394 | `78 01` | not attempted |
| `common.ffm` | `NXffu100` | `00 4B 99 27` | 4,954,407 | `78 01` | not attempted |
| `nx_hospital.ffm` | `NXffu100` | `02 E1 9B 46` | 48,339,782 | `78 01` | yes, 49,152 |
| `mp_nx_galleria.ffm` | `NXff0100` | `01 B8 0E 56` | 28,839,510 | `78 01` | yes, 49,152 |

**No field is claimed for offset 38.** The `nx_hospital.ffm` inflate already ruled out a
size reading — 48,339,782 pointed at a 5,744-byte compressed stream. Whether the value is a
position, an index, or a count is not determined; that it points at a stream start is.

### Every decoded stream has inflated length a multiple of 1,024

Nine streams decoded across this investigation: 49,152, 24,576, 49,152, 16,384, 16,384,
49,152, 49,152, 24,576 and 49,152. **All nine are exact multiples of 1,024**, in only three
distinct sizes — 16, 24 and 48 KB.

**No block size is claimed.** Three distinct multiples of 1,024 are consistent with several
underlying schemes, and a regularity across samples is not a specification.

### One decode remains unresolved

In `nx_hospital.ffm`, streams 4 and 5 each report 16,384 bytes inflated from 2,385 and 1,594
compressed, with output opening all zeros. A wholly-zero output should compress to a few
dozen bytes, and under FLG `01` (stored) 16,384 bytes of output should occupy roughly that
many input bytes. Only the first 64 bytes of each stream were captured, so an
all-zero-tail explanation cannot be excluded from what was recorded.

**These two lengths are inconsistent and are not resolved.** They should be re-verified
before any length in this document is relied on.

### Content

No stream decoded so far contains readable text. Runs of 8 or more that did appear —
`a}uj('Py` and `}X+*Qa)z` in two `nx_hospital.ffm` streams — are 8-character coincidences of
punctuation inside binary data and are **not** names. `82 7D` recurs eleven times in the
103 meaningful bytes of the galleria output; that is recorded as a byte pattern with **no
interpretation attached**.

### Unexamined

28,839,510 bytes precede the first galleria stream and 241,100,592 bytes follow the second.
The key at 98,198 sits 69,688 bytes past the first stream start, so key and stream are not
adjacent; whether the key's position relates to anything is untested. The ten key-at-38 MP
files have not been read at offset 38.

No field named, no header asserted, no model name emitted.

## ui.ffm inflates, and the first real strings

**`ui.ffm` is `NXffu100`, carries a zlib stream at offset 38, and inflates to 40,927,468
bytes. The stream consumes the entire file — nothing follows it.**

| Property | Value |
|---|---|
| File | `ui.ffm`, 16,629,872 bytes |
| Stream start | 38 (`78 01`) |
| Compressed length | 16,629,834 |
| End offset | 16,629,872 |
| **Bytes after the stream** | **0** |
| Inflated | **40,927,468 bytes** |
| Printable runs of 8 or more | 16,068 |

Script: `output/one-gun/ui_stream.py`. No other file opened or inflated, no `.xex` opened.

This is the largest decode so far and the only one whose stream spans its whole file. Every
earlier decode left a remainder; the two map files left hundreds of megabytes.

### Contents

The inflated output opens with a header-like byte sequence followed by `FF FF FF FF` and
`00 00 00 05` separators — the same separator family seen in `patch.ffm` and
`code_pre_gfx.ff` — then 16,068 strings. Many are lower-case underscored identifiers;
some are human-readable labels carrying dates.

Two of the strings, as recorded:

```
menu_soldier_band_blur
Javelin Weapon Test (01-16-07)
```

Others include `nx_menu_flash_frames`, `menu_flash_frames`, `nx_menu_flash_grid`,
`nx_menu_glow_orb`, `menu_glow_orb`, `nx_menu_highlight_overlay`,
`Javelin Weapon Test, Night (01-16-07)`, `@MENU_SWITCH_WEAPON`, `@MENU_FIRE_WEAPON`,
`nx_test_weapon_cody`, `sensor_fuzed_weapon_test`, `weapon_impact_test`, `weapon_pickup_test`.

### Token counts across the whole output

| Token | Runs containing it |
|---|---|
| `menu` | 549 |
| `weapon` | 8 |
| `xmodel` | **0 — absent from all 40,927,468 bytes** |

**`xmodel` does not appear anywhere in this output.** That is a negative across the entire
decoded stream, not a sample. The first three runs by offset do contain no token, but 557 of
the 16,068 runs do — so any statement that this file has no `menu` or `weapon` strings would
be wrong, and any statement based on the first three runs alone would understate it badly.

**No model name is emitted**, and none appears to exist in this stream.

### Scope

No structure is claimed. That 16,068 strings exist is a count; what they are, how they are
delimited, and what the surrounding bytes encode are not determined.

**This does not change the MP position.** `ui.ffm` is `NXffu100` and carries no `NXffs100`.
The ten key-at-38 MP files remain undecoded and `mp_nx_galleria.ffm` remains the only MP
decode on record.

## code_post_gfx.ffm inflates, and the 1 KB pattern is falsified

**`code_post_gfx.ffm` is `NXffu100`, carries a zlib `78 01` at offset 38, and inflates to
5,382,035 bytes. It contains `MENU_PASSWORD2`.**

| Property | Value |
|---|---|
| File | `code_post_gfx.ffm`, 1,534,886 bytes |
| Bytes at 38 | `78 01` |
| Compressed length | 1,534,848 |
| End offset | 1,534,886 |
| **Bytes after the stream** | **0** |
| Inflated | **5,382,035 bytes** |
| Printable runs of 8 or more | 6,627 |

Script: `output/one-gun/cpg_stream.py`. No other file opened or inflated, no `.xex` opened.

### Contents

| Token | Runs containing it |
|---|---|
| `menu` | 1,512 |
| `weapon` | 69 |
| `xmodel` | **0 — absent from all 5,382,035 bytes** |

1,563 of 6,627 runs contain one of the three. **Sampling a few runs would badly understate
this file**: the first qualifying run is at offset 19,222 of 5,382,035, so roughly the first
0.36% of the output contains none of them. The first two runs by offset are
`trim_char_f_1_1` and `trim_char_x_1_1`, neither carrying a token.

First run containing `weapon`, at offset 23,803: `MENU_RELOAD_WEAPON`.

The strings are UI display labels paired with uppercase tokens at adjacent offsets —
`Reenter Password:` / `MENU_PASSWORD2`, `Multiplayer` / `MENU_MULTIPLAYER`,
`Save/Load Game` / `MENU_SAVELOADGAME`, `Load Game` / `MENU_LOADGAME`, and unpaired
`MENU_TRAINING`, `MENU_RESUMEGAME`, `MENU_CURRENTLYINAGAME`, `MENU_DOYOUWISHTOCONTINUE`,
`MENU_CHOOSESKILLLEVEL`.

**That pairing is an adjacency observation, not a claimed structure.** No format named, no
field claimed. Opening bytes carry the `FF FF FF FF` and `00 00 1A` separator family already
recorded from `patch.ffm`, `code_pre_gfx.ff` and `ui.ffm`.

**`xmodel` is absent from this file and from `ui.ffm`** — two whole-output negatives.

### The multiple-of-1,024 regularities are now falsified

**5,382,035 is not a multiple of 1,024.** It is 5,383 × 1,024 minus 229.

Nine prior decoded streams had all reported exact multiples — 16, 24 and 48 KB across two
files, with no exceptions. That regularity was recorded as an observation and **explicitly
not claimed as a block size**, because a set of three multiples of 1,024 is consistent with
several underlying schemes. This decode is the first to break it.

**Two regularities are now falsified as general rules:**

1. *Inflated length is a multiple of 1,024* — false, per this file.
2. *Inflated length matches the compressed size plausibly* — already in doubt from
   `nx_hospital.ffm` streams 4 and 5, which reported 16,384 bytes from 2,385 and 1,594
   compressed with all-zero heads. **That discrepancy remains unresolved.**

Whether either pattern was ever a property of the smaller streams rather than a coincidence
across similar inputs is not determined.

### Standing position

| File | Magic | Stream start | Compressed | Inflated | Bytes after |
|---|---|---|---|---|---|
| `code_post_gfx.ffm` | `NXffu100` | 38 | 1,534,848 | 5,382,035 | **0** |
| `ui.ffm` | `NXffu100` | 38 | 16,629,834 | 40,927,468 | **0** |

Two SP files decode with the stream consuming the entire file. **The MP side is unchanged**:
`ui_mp.ffm` remains undecoded, and the ten key-at-38 MP files have still never been read at
offset 38.

No model name emitted.

## Five of five SP files with zlib at 38 decode

**`development.ffm` is `NXffu100`, carries a zlib `78 01` at offset 38, and inflates to
29,320 bytes of `.cfg` filenames. No `menu` or `weapon` token appears.**

| Property | Value |
|---|---|
| File | `development.ffm`, 28,102 bytes |
| Bytes at 38 | `78 01` |
| Compressed length | 28,064 |
| End offset | 28,102 |
| **Bytes after the stream** | **0** |
| Inflated | **29,320 bytes** |
| Printable runs of 8 or more | 59 |

Script: `output/one-gun/dev_stream.py`. No other file opened or inflated, no `.xex` opened.

**Zero of the 59 runs contain `menu` or `weapon`.** The output is `.cfg` filenames —
`autoexec_console_dev.cfg`, `avatar_createfx.cfg`, `devgui_aimassist.cfg`, `createfx.cfg`,
`demo.cfg`, alongside personal-name stems such as `benk.cfg`, `brent_dev.cfg` and
`chad.cfg`. Opening bytes carry the `FF FF FF FF` / `00 00 00 24` separator family already
recorded from four other decodes.

**Nothing is claimed about the structure.** That these are filenames is visible from the
`.cfg` suffix and the separators; what the surrounding bytes encode and how the list is
delimited is not determined. No field named, no model name emitted.

### The SP set at offset 38 is five of five

Every `NXffu100` file found to carry a zlib header at offset 38 has now been inflated, and
**all five decoded:**

| File | Compressed | Inflated | Bytes after stream |
|---|---|---|---|
| `patch.ffm` | — | 519 | small file |
| `code_pre_gfx.ff` | — | 2,256 | — |
| `development.ffm` | 28,064 | 29,320 | **0** |
| `code_post_gfx.ffm` | 1,534,848 | 5,382,035 | **0** |
| `ui.ffm` | 16,629,834 | 40,927,468 | **0** |

Three SP files now have their stream running to the last byte with nothing after it.

The three remaining files in the `78 01` group — `common_sound_iw4.ffm`,
`common_sound_nx1.ffm` and `common_sound_nx1_lunar.ffm` — are untested.

**This says nothing about the MP side.** `ui_mp.ffm` remains undecoded, and the ten key-at-38
MP files have still never been read at offset 38. The MP files that have decoded —
`mp_nx_galleria.ffm` and `common_mp.ffm` — did so by *seeking* to the big-endian value at
offset 38, not by having zlib at 38 directly.

### The 1 KB regularity is broken in two of the three whole-file decodes

29,320 is not a multiple of 1,024, as neither was `code_post_gfx.ffm`'s 5,382,035. Only
`ui.ffm`'s 40,927,468 lands on a multiple by coincidence of its own size. This extends the
falsification recorded for `code_post_gfx.ffm`: the pattern that held across nine prior
decodes is now contradicted twice among the largest and the second-largest whole-file
results.

**No block size is claimed, and the multiple-of-1,024 observation should be treated as
falsified rather than merely unconfirmed.**

The `nx_hospital.ffm` streams 4 and 5 discrepancy — 16,384 bytes inflated from 2,385 and
1,594 compressed with all-zero heads — remains **unresolved**.

## The SP sound file inflates, with bone names

**`common_sound_iw4.ffm` is `NXffu100`, carries a zlib `78 01` at offset 38, and inflates to
29,505,215 bytes. It contains `j_mainroot` and a large family of `j_` bone names. `xmodel`
is absent.**

| Property | Value |
|---|---|
| File | `common_sound_iw4.ffm`, 23,041,483 bytes |
| Bytes at 38 | `78 01` |
| Compressed length | 23,041,445 |
| End offset | 23,041,483 |
| **Bytes after the stream** | **0** |
| Inflated | **29,505,215 bytes** |
| Printable runs of 8 or more | 40,595 |

Script: `output/one-gun/sound_iw4_stream.py`. No other file opened or inflated, no `.xex`
opened.

This is the smallest `common_sound*.ffm` opening with `NXffu100`. The three smaller sound
files are `NXff0100` and were not opened.

### Contents: skeletal rig identifiers

```
j_mainroot    j_hip_le     j_hiptwist_le    j_knee_le     j_ankle_le
j_ball_le     j_knee_bulge_le    j_hip_ri
```

The runs are densely packed from offset 1,240 — 40,595 runs across 29,505,215 bytes, so a
name table rather than sparse text. The `_le` / `_ri` pairing is the standard left/right
convention and `j_` prefixes the set.

**These are recorded as the byte strings they are.** No rig, skeleton or asset is named, and
nothing is claimed about what these identifiers reference, nor about the delimiters or
surrounding bytes. **No model name is emitted.**

`xmodel` does not appear — the third whole-output negative after `ui.ffm` and
`code_post_gfx.ffm`.

### Six of six SP files with zlib at 38 decode

| File | Compressed | Inflated | Bytes after stream |
|---|---|---|---|
| `patch.ffm` | — | 519 | small file |
| `code_pre_gfx.ff` | — | 2,256 | — |
| `development.ffm` | 28,064 | 29,320 | **0** |
| `code_post_gfx.ffm` | 1,534,848 | 5,382,035 | **0** |
| `ui.ffm` | 16,629,834 | 40,927,468 | **0** |
| `common_sound_iw4.ffm` | 23,041,445 | 29,505,215 | **0** |

**Six of six.** Four of them have their stream running to the last byte. The two remaining
files in the `78 01` group — `common_sound_nx1.ffm` (25,102,933) and
`common_sound_nx1_lunar.ffm` (26,822,692) — are untested.

29,505,215 is again not a multiple of 1,024, so **the multiple-of-1,024 observation is now
contradicted in three of the four whole-file SP decodes.** `ui.ffm` is the only one landing
on a multiple. The pattern should be treated as falsified, not merely unconfirmed.

### What this does not reach

The three `NXff0100` sound files — `common_sound_nx1_lunar_mp.ffm` (18,309,158),
`common_sound_iw4_mp.ffm` (19,398,694) and `common_sound_nx1_mp.ffm` (25,272,358) — read
`4E 58` at offset 38, which is `NX`, not a zlib header. **Nothing is claimed about them.**

They belong to the MP group whose bodies remain undecoded. The two MP decodes on record —
`mp_nx_galleria.ffm` and `common_mp.ffm` — got there by seeking to the big-endian value at
offset 38, not by having zlib at 38 directly. The ten key-at-38 MP files have still never
been read at offset 38.

The `nx_hospital.ffm` streams 4 and 5 discrepancy remains **unresolved**.

## NX1 gun tokens are absent from the decoded UI and sound output

**`vacuum_railgun` and `pulserifle` do not appear in the inflated `ui.ffm` or
`common_sound_nx1.ffm` outputs — as whole tokens or as substrings. `xmodel` does not appear
in the inflated UI, post-gfx, or first common stream.**

| File | Inflated | `xmodel` | `scar2` | `vacuum_railgun` | `pulserifle` |
|---|---|---|---|---|---|
| `ui.ffm` | 40,927,468 | 0 | 0 (substring) | **0 (both)** | **0 (both)** |
| `code_post_gfx.ffm` | 5,382,035 | 0 | not searched | not searched | not searched |
| `common.ffm` | 49,152 | 0 | not searched | not searched | not searched |
| `common_sound_nx1.ffm` | 32,300,513 | not searched | 0 (whole token) | **0 (both)** | **0 (both)** |

Scripts: `output/one-gun/ui_gun2.py`, `output/one-gun/sound_nx1_gun.py`. No other file
opened or inflated, no `.xex` opened.

### Why both search conventions were run

Earlier short-substring searches produced artifacts: `glo` matched inside `glow`, `global`
and `gulag`; `ecr` matched inside `recruit` and `recreate`. Later searches switched to
whole-token matching, which cannot produce that false-positive class — but at the cost of not
covering occurrences inside longer identifiers.

**Both conventions were therefore run for these two tokens, and both return zero.** The
substring test subsumes the whole-token test in this case, so the negative is unqualified:
neither token appears anywhere in the 16,068 runs of `ui.ffm` or the 42,762 runs of
`common_sound_nx1.ffm`, standalone or embedded.

`scar2` remains whole-token-only in `common_sound_nx1.ffm` and substring-only in `ui.ffm`,
so **an occurrence inside a longer identifier is not ruled out for that token.**

### What these negatives are not

**Every cell is scoped to the single stream searched.** None extends to a file, a directory,
or the codebase. `vacuum_railgun` was searched in exactly two streams — it has one filled
cell and two untested ones.

Both tokens are recorded elsewhere in this investigation as **string-only**, from symbol
dumps across the install: `vacuum_railgun` in `bg_weapons_util.obj`, `pulserifle` among the
NX1-unique primaries. **These decodes neither confirm nor contradict that**, and no claim is
made that either token is unused.

The same applies to `xmodel`: absent from three decoded outputs, including the two largest SP
decodes on record, and that is a fact about those streams alone.

No model name emitted, no field named.

### One internal inconsistency left unresolved

The inflated output of `common_sound_nx1.ffm` is 32,300,513 bytes on every read, but the
printable-run count differs between two scripts that scanned it: **42,763 in one, 42,762 in
the other.** The most likely cause is how the carry buffer across chunk boundaries is handled
in each script, but it was not verified and **neither count should be treated as exact.**

No model name emitted. LZXDecoder not called, no `.xex` opened.

## The map slot holds across 12 maps; the load files hold their own size

**All 12 `mp_nx_*.ffm` map files have a big-endian 32-bit value at offset 38 that lands on
`78 01`. All 12 `mp_nx_*_load.ffm` files store their own file size at offset 38.**

**No field is claimed for offset 38.**

### Provenance of the map count — 10 here, 2 from earlier entries

The 22-file sweep covered every `mp_nx_*.ffm` except `mp_nx_galleria.ffm` and
`mp_nx_pitstop.ffm`. **Ten of ten of those point at `78 01`:**

| File | Hex at 38 | Big-endian | Bytes there |
|---|---|---|---|
| `mp_nx_blank1.ffm` | `00 FF 0F 64` | 16,715,620 | `78 01` |
| `mp_nx_bom.ffm` | `01 72 5B 1E` | 24,271,646 | `78 01` |
| `mp_nx_fallout.ffm` | `00 DF 95 63` | 14,652,771 | `78 01` |
| `mp_nx_lockdown.ffm` | `01 5C FB 84` | 22,870,916 | `78 01` |
| `mp_nx_lockdown_v2.ffm` | `01 60 A1 CD` | 23,110,093 | `78 01` |
| `mp_nx_meteor.ffm` | `01 55 BE EF` | 22,396,655 | `78 01` |
| `mp_nx_sandstorm.ffm` | `01 89 17 FC` | 25,761,788 | `78 01` |
| `mp_nx_skylab.ffm` | `01 29 38 48` | 19,478,600 | `78 01` |
| `mp_nx_stasis.ffm` | `01 AA 9F A8` | 27,959,208 | `78 01` |
| `mp_nx_ugvhh.ffm` | `02 1B AA 4D` | 35,367,501 | `78 01` |

**The 12 of 12 figure is ten from this sweep plus two already recorded and inflated
individually:**

| File | Hex at 38 | Big-endian | Bytes there | Inflated |
|---|---|---|---|---|
| `mp_nx_galleria.ffm` | `01 B8 0E 56` | 28,839,510 | `78 01` | 49,152 |
| `mp_nx_pitstop.ffm` | `01 C7 87 7C` | 29,853,564 | `78 01` | 65,536 |

**This is an assembly across three separate runs, not one sweep of 12.** The two files are
the same as the two the sweep excluded, so there is no gap in coverage — but the twelve were
not read in a single pass and no single run covers all of them.

Sizes span 158,398,254 to 334,230,786, and every big-endian value falls between 5.6% and
15.5% of its file. Ten alignments across that spread are not plausibly chance.

### The 12 load files

| File | Big-endian at 38 | File size | Equal |
|---|---|---|---|
| `mp_nx_blank1_load.ffm` | 270,567 | 270,567 | yes |
| `mp_nx_bom_load.ffm` | 311,527 | 311,527 | yes |
| `mp_nx_fallout_load.ffm` | 352,487 | 352,487 | yes |
| `mp_nx_galleria_load.ffm` | 311,527 | 311,527 | yes |
| `mp_nx_lockdown_load.ffm` | 344,295 | 344,295 | yes |
| `mp_nx_lockdown_v2_load.ffm` | 319,719 | 319,719 | yes |
| `mp_nx_meteor_load.ffm` | 385,255 | 385,255 | yes |
| `mp_nx_pitstop_load.ffm` | 352,487 | 352,487 | yes |
| `mp_nx_sandstorm_load.ffm` | 319,719 | 319,719 | yes |
| `mp_nx_skylab_load.ffm` | 327,911 | 327,911 | yes |
| `mp_nx_stasis_load.ffm` | 385,255 | 385,255 | yes |
| `mp_nx_ugvhh_load.ffm` | 270,567 | 270,567 | yes |

**Twelve of twelve, all in one sweep.** This extends the single earlier measurement on
`mp_nx_blank1_load.ffm` from one file to twelve — the sample size that single reading lacked.
Seeking to the value puts the read at EOF, so none yields a zlib header.

### What mixed means here, and what is not claimed

The 22-file aggregate is `mixed`: 10 zlib headers, 12 values past the end of file. **Within
each group the result is uniform** — 10 of 10 maps point at a stream, 12 of 12 loads hold
their size. Map and load files doing different things at the same offset is the pattern
already recorded, not a failure of the offset-38 relationship.

**No field is claimed.** For the map group a size reading is already ruled out:
`nx_hospital.ffm`'s 48,339,782 pointed at a 5,744-byte compressed stream. That the load
files' value *is* their size is a separate fact about a separate group, and does not
establish what either value means.

### Unchanged and still open

**The ten key-at-38 MP files have never been read at offset 38.** That is the offset which
works in six individual files and in the whole map set, and it remains the largest unclosed
gap on the MP side.

The `nx_hospital.ffm` streams 4 and 5 discrepancy is **unresolved**, as is the differing
printable-run count for `common_sound_nx1.ffm` (42,763 vs 42,762).

No model name emitted by this entry — the names above are fastfile names as they appear on
disk. No fastfile opened or inflated for it, no `.xex` opened.

## What remains open

Locating the key is solved. Interpreting what follows it is not. Across every file and
offset examined, no zlib header signature sits adjacent to the key, and the one candidate
tested decoded as a false positive. The bytes after the key remain unidentified. See
`nxffs100.md` and `load-header.md`.