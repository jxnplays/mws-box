# NXffs100 — closed facts

NX1 `common_mp.ffm` / `mp_nx_galleria.ffm`. Only facts closed by direct byte
observation and by reading the extraction script on disk. Nothing inferred,
nothing assumed, no struct asserted.

## Closed facts

**File magic: `NXff0100` at byte 0.**
Observed as the first eight bytes of `common_mp.ffm`.

**`NXffs100` occurs once per file.**
- `common_mp.ffm` — offset 41510 (0xA226), the only occurrence in 273,399,669 bytes
- `mp_nx_galleria.ffm` — offset 98198 (0x17F96), the only occurrence in 269,945,205 bytes

Whole-file scans, chunked with overlap, single-byte encoding so no multi-byte boundary
can split a match. The offset is not a constant and is not a function of file size.

**The shared key is those 8 bytes plus four zeros.**
Both files read `4E 58 66 66 73 31 30 30 00 00 00 00` — 12 bytes, identical at the
marker in both files. Bytes 12 onward differ between the two files, so the 12-byte
prefix is the whole of the common portion.

**The body is not a size field and is not raw DEFLATE.**
- Not a size field: byte 12 onward differs between the files (`DA 87 B9 04` in
  `common_mp.ffm`; `0F 04 54 4C` in `mp_nx_galleria.ffm`), so the bytes are not a
  constant that could be a shared length.
- Not raw DEFLATE: the 65,536 bytes at offset 98210 in `mp_nx_galleria.ffm`, fed to
  `DeflateStream` with no zlib header, fail with
  `InvalidDataException: Unknown block type. Stream might be corrupted.`
  Its leading bits select no valid DEFLATE block type.

**Absent from all 2,818 galleria blocks.**
`output\unpacked\mp_nx_galleria`, all `block_*.bin`, byte-level match across
245,248,641 bytes: **0 hits**.

**The only decoder on disk is `DeflateStream`.**
Four scripts under `output\` call it — `extract_all_ff.ps1`, `extract_all_ff2.ps1`,
`extract_ff.ps1`, `extract_seq.ps1`. All use raw DEFLATE via .NET
`System.IO.Compression.DeflateStream`. No LZ4, LZO, Oodle, XOR, inflate, gzip, 7z, or
LZMA appears anywhere in the tree.

## Supporting observations

These are recorded because they bear on any future attempt, not because they close
anything.

- No zlib header (`78 01` / `78 9C` / `78 DA`) occurs in the 16 bytes before the marker,
  nor anywhere in the 4,096 bytes following it (98210-102258). The 82,654 bytes preceding
  it contain 3 signatures, the last at 38581 (0x96B5), which reads `78 01` but fails
  decoding partway with `InvalidDataException: Found invalid data while decoding` — a
  coincidental match, not a real stream header.
- `extract_all_ff2.ps1` line 35 tests for a zlib header at each offset and otherwise
  advances one byte (line 52), and on any exception also advances one byte (line 51).
  Line 47 records a block only when decompression yields output. With no header near the
  marker, the stream containing it is stepped over and never written. The precondition
  for this is observed; the mechanism is read from the script.
- `block_00003CB5.bin`, the nearest block start below the marker at 15541, is 3 bytes.
  The nearest above, `block_0003914C.bin` at 233804, lies above the marker. The 82,657
  bytes between them carry no block start.
- Block filenames are source offsets, not sequence identifiers: `$b.Offset` is the
  fastfile position, formatted `block_{0:X8}.bin` (`extract_all_ff2.ps1` lines 47, 82).
- `extract_all_ff2.ps1` line 33 hardcodes `pos = 38`, a 38-byte pre-data header. That
  value is a hardcoded assumption in the script, not a validated layout.

## Not established

Where the compressed stream containing the marker begins. It lies above 102258 or below
15544, and no recorded block start in that territory is below the marker apart from the
3-byte false positive. Confirming this requires decompressing candidate blocks.

No weapon asset was recovered. Seven NX1-unique primaries (`scar2`, `asmk27`, `xm108`,
`ecr`, `pulserifle`, `type104`, `glo`) have no viewmodel, worldmodel, material, or image
path recorded in `inventory.csv`, `coverage.csv`, or `multiplayer_catalog.json` — all
three return nothing for those names. They appear as script `case` labels and
`*_reflex_mp` attachment names only. A viewer-ready weapon needs the index above, which
remains unparsed.