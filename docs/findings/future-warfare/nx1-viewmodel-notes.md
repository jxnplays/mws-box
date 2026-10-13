# NX1 Fastfile and Viewmodel Notes
## Private working document — not for publication

**Status:** One weapon (SCAR Mod 2) is playable in the client. It renders, aims, fires, reloads, and swaps. NX1 textures are not yet bound (donor textures are used). Sounds are not wired.  
**Goal:** One real NX1 gun that feels native in IW4L.  
**Scope:** Call of Duty Future Warfare (NX1) multiplayer assets, starting with the SCAR Mod 2.

### Live progress

| Area | % | Notes |
| --- | --- | --- |
| Namespace / DLC plumbing | 100% | Top-level NX1 category. SCAR Mod 2 selectable as `nx1:weapon/scar2_mp`. |
| .cast mesh reader | 100% | Skeleton, geometry, and tags parse. |
| .cast animation reader | 100% | All 59 clips for the test weapon parse. |
| .cast material reader | 100% | Surfaces and PNG maps extracted. |
| Animation binding | 100% | Clips bound, including idle. |
| Viewmodel rig | 100% | NX1 hands placed and in the draw plan. |
| Playable in game | ~95% | Renders, aims, fires, reloads, and swaps. |
| NX1 textures on gun | ~40% | Reader and loader work. Binding still uses donor textures. A material row minted in the walk is not equivalent to a retail row for FPV draw. |
| NX1 sounds | 0% | WAVs staged, not wired. |
| Generalise to all guns | ~10% | Reader is gun-agnostic. Wiring is still specific to the test weapon. |
| Maps | 0% | Not started. |

One playable weapon is roughly 70% complete. The reusable reader and converter work is roughly 90% complete. The main open problem is texture binding in first-person view.


---

### 1. Starting point

The NX1 install was already unpacked into an `output/unpacked/` tree (9.08 GB, 100,841 blocks). Catalog tables had been extracted and committed (`weapons.csv`, `maps.csv`, `dvars.csv`, and others). The immediate goal was one real NX1 primary in the refreshed IW4L client: correct model, correct name, correct category. Shooting was optional.

Early index searches for `scar2`, `viewmodel_scar2`, and related names returned only string-pool hits in `multiplayer_catalog.json`. No model, material, or image paths were present in the indexes. The asset bodies lived inside the fastfiles and had not been typed.

### 2. Fastfile header and marker work

The first concrete structure located was the `NXffs100` marker.

- Magic at file start: `NXff0100` (MP).
- Shared 16-byte prefix: `4E 58 66 66 30 31 30 30 00 00 01 65 00 00 01 CC`.
- Marker: `NXffs100` followed by four zero bytes.
- In load files (`*_load.ffm`) the marker sits at a fixed offset of 86.
- In map files the offset varies (41,510 in `common_mp.ffm`, 98,198 in `mp_nx_galleria.ffm`, 87,686 in `mp_nx_pitstop.ffm`).
- The marker occurs once per file.

The four bytes immediately after the marker differ per file and are not a size, not a CRC-32 of the head or remainder, and not a zlib header. The region that follows is high-entropy. Zlib signature scans in the body produced only false positives that failed to inflate. The existing extractor (`extract_all_ff2.ps1`) steps one byte at a time looking for a zlib header and therefore skips the marker region.

A 70-byte header template was observed across load files. Offsets 16–21 vary per file. A repeating two-byte slot appears at 35–36 / 39–40 / 79–80 / 83–84. The remaining bytes in the pre-marker region are identical across the three load files examined. These facts were recorded in `key-table.md` and later closed into the findings tree.

### 3. Shift to the .cast export

The path that produced usable mesh data was the existing .cast export of the SCAR Mod 2 viewmodel, not a new fastfile parser. The file `viewmodel_scar2_LOD0.cast` contains 30 `mesh` sections. The first mesh begins at offset `0x4D02`.

Header of the first mesh:
- Length field `0x0006C960`
- Tag `E1RTRWINS`
- Attribute descriptors including `ul`, `mi`, `cl`, `sml`, `inear`

Immediately after the attribute list:
- Little-endian count `0x1C7B` (7,291)
- Tag `vp`
- Stream of little-endian IEEE-754 floats

### 4. Vertex stream and following structures

The first 36 bytes at `0x4D56` are three position groups:

```
43.1921883   0.0000000   6.1287632
43.1741562   2.3408639   3.7503138
43.1782265   0.0000000   3.7335415
```

A count of consecutive little-endian float groups of three whose three floats all lie between -100 and 100 returned **7,292 groups**. The first group that fails the test is at file offset `0x1A326`.

7,292 × 12 = 87,504 bytes of sequential positions. This matches the earlier little-endian count `0x1C7B` (7,291) within one group. The position block therefore runs from `0x4D56` to `0x1A326`.

Immediately at `0x1A326` a run of six consecutive 12-byte groups begins with the bytes `80 3F`. The run is 72 bytes long and ends at file offset `0x1A36E`. The pattern is not three plain floats. Its type has not been identified.

### 5. Later 12-byte runs (closed)

After the position block and the short run ending at `0x1A36E`, sixteen consecutive 12-byte pattern runs have been counted. Each run is exactly three groups long.

| Start offset | Sequence (12 bytes) | Consecutive groups | Ends at |
|--------------|---------------------|--------------------|---------|
| `0x1A3FC`    | `3C 78 70 BF 38 70 60 3D 2B 56 AC 3E` | 3 | `0x1A420` |
| `0x1A420`    | `BE 7B 77 BF 00 00 00 00 21 42 84 3E` | 3 | `0x1A444` |
| `0x1A444`    | `BD 79 73 BF 00 00 00 00 A8 4F 9F BE` | 3 | `0x1A468` |
| `0x1A468`    | `38 71 62 BF 21 42 04 3E 3A 73 E6 BE` | 3 | `0x1A48C` |
| `0x1A48C`    | `00 00 00 00 A3 46 8D 3E FD FA 75 BF` | 3 | `0x1A4B0` |
| `0x1A4B0`    | `00 00 00 00 29 52 24 3E 3F 7E 7C 3F` | 3 | `0x1A4D4` |
| `0x1A4D4`    | `00 00 00 00 FF FD 7B 3F 2E 5B 36 3E` | 3 | `0x1A4F8` |
| `0x1A4F8`    | `36 6D 5A 3E 3A 74 E8 3D 3E 7C 78 3F` | 3 | `0x1A51C` |
| `0x1A51C`    | `35 6A 54 3E 38 70 E0 3D 7E FC 78 3F` | 3 | `0x1A540` |
| `0x1A540`    | `BC 77 6F 3F 2C 58 B0 BC 2D 5A B4 3E` | 3 | `0x1A564` |
| `0x1A564`    | `7B F6 6C 3F 00 00 00 00 B0 60 C1 3E` | 3 | `0x1A588` |
| `0x1A588`    | `B7 6E 5D 3F 00 00 00 00 20 40 00 BF` | 3 | `0x1A5AC` |
| `0x1A5AC`    | `3C 78 70 3F 31 62 C4 3D AA 54 A9 BE` | 3 | `0x1A5D0` |
| `0x1A5D0`    | `00 00 00 00 FF FE 7D 3F 20 40 00 3E` | 3 | `0x1A5F4` |
| `0x1A5F4`    | `00 00 00 00 FF FE 7D 3F 22 43 06 3E` | 3 | `0x1A618` |
| `0x1A618`    | `00 00 00 00 FF FE 7D 3F 22 44 08 3E` | 3 | `0x1A63C` |

All sixteen sequences share the shape `XX XX XX BF 00 00 00 00 YY YY YY BE/3E` (or close variant). No semantic assigned. The gap between `0x1A36E` and `0x1A3FC` has not been examined. Face indices have not been located. The same layout has not yet been confirmed in a second mesh.

### 6. Client load state (current)

Geometry loads. `crates/assets/src/session_load/match_walk.rs` already inserts both `viewmodel_scar2_LOD0.cast` and `weapon_scar2_LOD0.cast` from the saluki export folder into the fpv and world spaces via `read_cast_xmodel`. Model is visible in first person.

Textures resolve. The scar2 color and specular IWIs are packaged in `nx1_scar2_images.iwd` (1,049,150 bytes) and placed in `main\\`. The resolution chain is closed. Malformed-archive risk remains.

Sounds are not wired. Nine WAVs exist under `[local path] of Duty Future Warfare\\NX1\\output\\one-gun\\tools\\saluki\\exported_files\\nx1\\sounds\\weapons\\scar2\\`. The client has `IwdSoundIndex`. No sound IWD packaged. No aliases assigned. In-game gun uses M4 sounds.

Animations are not loaded. The client supports XAnims for MW3 and BO1. No NX1 raise/reload/fire clips have been located or bound to scar2.

Camo is not supported. The client has `weapon_camo.rs` for other games. Scar2's body material has no camo slot. No NX1 camo materials exist in the client. Camo menu shows IW4 options.

Create-a-class icon is missing. SCAR2 appears in the assault rifle list with an asterisk (`*SCAR2`). No weapon image in the class editor preview. Class name shows as `M4 ASSAULT`.

Weapon definition is empty. Scar2 is registered from .cast geometry only. No real NX1 fire rate, damage, recoil, or category data is bound. It falls back to defaults.

### 7. What has not been done

- No face/index section has been identified in the .cast.
- No material or texture binding has been read from the .cast.
- Malformed-archive risk in `main\\` unverified.
- Sounds not packaged or assigned.
- Animations not located or bound.
- Camo not wired.
- Create-a-class icon not registered.
- Weapon stats not bound.
- The white paper for public release has not been started. It is written after the gun is in-game and feels native.

### 8. Next steps

1. Package the 9 scar2 WAVs into an IWD under `sound/weapons/scar2/` and place it in `main\\`.
2. Find the local scar2 registration site and assign sound aliases.
3. Locate NX1 XAnims for scar2 raise/reload/fire and bind them.
4. Register a menu icon under the scar2 name so it appears correctly in create-a-class.
5. Bind real NX1 weapon stats (fire rate, damage, category) so it does not fall back to defaults.
6. Do not invent a converter. Do not build the client until the path is observed or written.

All work continues under the same constraints: bounded reads, no invented structs, no full unpack scans.

---

### Body state — 2026-10-10

- SP zlib-at-38 set is closed: 5/5 files with zlib at offset 38 decode.
  - patch.ffm (DLC text)
  - code_pre_gfx.ff (codescripts/$default)
  - development.ffm (.cfg names)
  - code_post_gfx.ffm (MENU_PASSWORD2; 1,512 menu / 69 weapon runs)
  - ui.ffm (40.9 MB; menu_soldier_band_blur; 549 menu / 8 weapon runs)
- xmodel is absent from both full UI inflates.
- Offset 38 big-endian dword points to a zlib stream in 5/5 tested files across both magics:
  - SP: common_ignore.ff, common.ffm, nx_hospital.ffm
  - MP: mp_nx_galleria.ffm (28,839,510 → inflated 49,152), common_mp.ffm (33,768,503 → inflated 65,536)
- mp_nx_blank1_load.ffm has its own size at offset 38 (270,567).
- The ten key-at-38 MP files have never been read at offset 38.
- Inflated length is not always a multiple of 1,024 (falsified by code_post_gfx 5,382,035 and development 29,320).
- nx_hospital.ffm streams 4/5 compressed-size discrepancy is unresolved.

---

*Table updated after audio identification session 2026-10-10. common_sound zlib-at-38 identified, not inflated. SP zlib-at-38 closed. Geometry and textures closed. Everything else open. Private. Do not publish.*
