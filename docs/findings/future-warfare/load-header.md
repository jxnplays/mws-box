# NX1 load-file header template

Facts observed by direct byte comparison of load fastfiles in the NX1 root.
No field is named, no struct is asserted. Every value below was read from the
files; nothing is inferred.

## Files compared

- `mp_nx_blank1_load.ffm` — 270,567 bytes
- `mp_nx_pitstop_load.ffm` — 352,487 bytes
- `mp_nx_galleria_load.ffm`

All twelve `*_load.ffm` files in the NX1 root place `NXffs100` at offset 86, found by
whole-file scan.

## Facts

**1. `NXffs100` plus four zeros at offset 86.**

`4E 58 66 66 73 31 30 30 00 00 00 00` — the 8-byte name followed by `00 00 00 00` —
at offset 86 in every load file checked. Same 12-byte key appears at the marker in the
map files `common_mp.ffm`, `mp_nx_galleria.ffm`, `mp_nx_pitstop.ffm`, and all twelve
`mp_*.ffm` files in the root.

The four bytes immediately after the key differ per file. Across the 24 `mp_*.ffm` files
scanned, no two shared the same value.

**2. First 16 bytes are `NXff0100` plus `00 00 01 65 00 00 01 CC`.**

```
4E 58 66 66 30 31 30 30  00 00 01 65 00 00 01 CC
```

Identical at offsets 0-15 across the load files compared, and the same 16 bytes open
`common_mp.ffm`.

**3. Offsets 16-21 differ per file, and are not a size and not a CRC32.**

Six contiguous bytes, differing in every file pair compared:

| File | Bytes 16-21 |
|---|---|
| `mp_nx_blank1_load.ffm` | `CE 99 B2 98 D3 A0` |
| `mp_nx_pitstop_load.ffm` | `BC 94 8E BD D9 10` |
| `mp_nx_galleria_load.ffm` | `BC 93 78 45 DA 80` |

Not a size: both byte orders of bytes 16-19 exceed the owning file's length by roughly an
order of magnitude (blank1 little-endian 2,561,841,614 and big-endian 3,466,179,224
against a 270,567-byte file; pitstop 3,180,238,012 and 3,163,852,477 against 352,487).

Not a CRC32: standard reflected CRC-32 over bytes 0-15 gives `D316D6DD`, and over bytes
20 to end gives `A591BA85` for `mp_nx_blank1_load.ffm`. Neither equals bytes 16-19
(`CE 99 B2 98`) in either byte order.

This excludes a plain CRC-32 over those two ranges only. A seeded CRC, a CRC over a
differently bounded region, or another digest remain consistent with what is observed.

**4. Offsets 35-36, 39-40, 79-80, 83-84 are a repeated two-byte slot.**

Four occurrences of a two-byte pair at three-byte spacing. Values observed:

| File | Each slot |
|---|---|
| `mp_nx_blank1_load.ffm` | `04 20` |
| `mp_nx_pitstop_load.ffm` | `05 60` |
| `mp_nx_galleria_load.ffm` | `04 C0` |

The second byte of each pair varies per file (`20`, `60`, `C0`). The first byte takes
values from a small set — `04` in blank1 and galleria, `05` in pitstop — so it is
per-file but not unique per file. Positions that differ between blank1 and pitstop are
16-21, 36, 40, 80, 84; between blank1 and galleria they are 16-21, 36, 40, 80, 84 as
well, differing only in which files share a first-byte value.

**5. The other bytes from 22 to 85 match across blank1, pitstop, and galleria load files.**

Of the 70 bytes at offsets 16-85, only those listed above differ. The remaining bytes are
identical in all three files, including a run of zeros at offsets 48-78 and the
`20 56 00 04 20 E7` / `60 56 00 05 60 E7` sequence in the differing slots' neighbourhood.

## Not established

The meaning of bytes 16-21, the meaning of the repeated pair, and whether any of it is
compressed data. Twenty-one zlib-header signatures were found after offset 98 in
`mp_nx_blank1_load.ffm`, the first at 14389; the one tested read `78 01` and failed
decoding with `InvalidDataException: Found invalid data while decoding`, making it a
coincidental match in high-entropy data. No header signature sits adjacent to the key in
any load file examined.

Whether these 86 bytes are a header at all, or body data preceding one, is not
established. The uniform offset 86 across twelve files of differing size and content is
consistent with a fixed-layout region, but that is a hypothesis about cause rather than an
observation about the bytes.