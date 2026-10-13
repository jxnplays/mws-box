# NX1 progress — next.md

## Current percentages

| Area | % | Notes |
|---|---|---|
| Key location (`NXffs100`) | 100% | Located across all placements (38, 86, map range, 41510). Once per file. |
| 16-byte prefix | 100% | Confirmed identical across key placements. |
| Header template (key-at-38) | 90% | Size at offset 34 confirmed 10/10. Name slot at 338 confirmed. Nine-byte shared run at 22-30. |
| SP body framing | 70% | Five of five `NXffu100` files with zlib at 38 decode. Consecutive streams found in `nx_hospital.ffm`. `patch.ffm` and `code_pre_gfx.ff` yield text. |
| MP body framing | 35% | `mp_nx_galleria.ffm` and `common_mp.ffm` have offset-38 BE value pointing to inflatable zlib streams. Key-at-38 MP files (`ui_mp.ffm` etc.) still undecoded. Not zlib at key+12. |
| LZX path | 40% | Enumerators confirmed (`DB_COMPRESSOR_ZLIB`, `DB_COMPRESSOR_LZX`). Header names and inflate functions recorded. No decoder on disk. Raw XEX LZX rejected at key. PDB directories zeroed. |
| Scar2 textures | 100% | Color and specular IWIs packaged into `nx1_scar2_images.iwd` (1,049,150 bytes). Archive is in `[local path] Specular name survives lowercasing. Index is in-process only. Empty `AuthoredImage` slots confirmed at lines 58 and 84. Normal decode path will locate both images. Demand builder reaches both slots. `decode_material_color_maps` runs after registration. `NamespaceTrees` indexes `main\` and picks up the `.iwd`. `game_main_for_zone` derives `main\` correctly from the `common_mp` zone path. Resolution chain closed end to end. Malformed-archive risk remains. |
| Overall (client excluded) | ~68% | Header closed. SP body partially decoded. MP body started on two files. Scar2 textures fully resolved through the client index path. |

## Scar2 image packaging

`nx1_scar2_images.iwd` exists at `E:\Call of Duty Future Warfare\NX1\output\one-gun\tools\saluki\exported_files\nx1\images\IWI\` (1,049,150 bytes).

Contains exactly two entries under `images/`:

- `nx_weapon_scar_body_col.iwi` (524,320 bytes)
- `~nx_weapon_scar_body_spc-rgb&~04ee13be.iwi` (524,320 bytes)

Both match source SHA-256. Stored uncompressed. No deflate used.

### Client indexing

`asset_transport/src/iwd.rs` reads `.iwd` via `zip::ZipArchive`. `index_image_entries` strips the `images/` prefix and `.iwi` suffix, so these two names index as:

- `nx_weapon_scar_body_col`
- `~nx_weapon_scar_body_spc-rgb&~04ee13be`

These match `IMAGE` and `SPECULAR` in `register_nx1_scar_body_color`.

### Loaded into client main

`nx1_scar2_images.iwd` is now at `[local path] 1,049,150 bytes, SHA-256 identical to the source. No existing file was overwritten.

### Specular name lowercasing

`image_candidates` at `crates/asset_transport/src/iwd.rs:114` does `self.images.get(&name.to_ascii_lowercase())`. The name `~nx_weapon_scar_body_spc-rgb&~04ee13be` contains zero uppercase characters, so `to_ascii_lowercase()` is a no-op on it: 38 bytes in, 38 bytes out, ordinal-equal. The `&` and `~` are not letters and are untouched. The writer side (`index_image_entries`) uses the same lowercasing, so the indexed key and the lookup key agree.

### Index cache

The index lives in two `OnceLock` statics at `crates/asset_transport/src/iwd.rs:50` and `:57`, holding `RwLock<HashMap<PathBuf, Arc<IwdIndex>>>` and a build-lock map. Both start empty and are populated only by `IwdIndex::open` at line 63, which returns early on a cache hit and otherwise calls `open_uncached`. That enumerates the directory with `read_dir` and filters by `is_iwd_archive`, which accepts any `.iwd` extension. There is no invalidation function, no `.clear()` call on either map, and no on-disk index file. The index is rebuilt from scratch every process start. `nx1_scar2_images.iwd` was added before any run, so the next run builds a fresh index that includes it. Nothing to clear.

### Empty AuthoredImage slots

`register_nx1_scar_body_color` pushes the color `AuthoredImage` at lines 46–64. Its empty payload is line 58 (`payload: std::sync::Arc::new(Vec::new())`), with `decoded: None` at 59 and `pending_decode: None` at 63. The specular `AuthoredImage` is pushed at lines 72–90. Its empty payload is line 84, with `decoded: None` at 85 and `pending_decode: None` at 89. Both structs also carry `width: 0`, `height: 0`, `format: 0`, and `level_count: 1` at lines 53–57 and 79–83. The only difference is the semantic: `TS_COLOR_MAP` with `use_srgb_reads: true` versus `TS_SPECULAR_MAP` with `use_srgb_reads: false`. The bindings at lines 113–128 point the material's color and specular slots at these two indices, so the material resolves once the images do.

### Normal decode path

`claim` at line 2042 treats an empty payload as the signal to decode. Line 2053 is `if image.payload.is_empty()`, and 2054 sets `pending_decode = Some(id)` then pushes the row into the plan. A non-empty payload instead goes to `inline` for direct decode. So leaving both payloads empty is what queues them, not a defect. `ImageDemandPlan::run` at line 1669 opens the index with `game_main_for_zone(&self.zone_ff)` then `IwdIndex::open(&main)` at line 1680, which is the game's `main\` directory where the new `.iwd` now sits. It then decodes each demand through `index.decode(name)` at line 578, returning `Missing` only when the name is absent from the index. Combined with the two earlier checks, the name resolution lines up end to end: `index_image_entries` strips `images/` and `.iwi` to key both entries, and `image_candidates` lowercases, which is a no-op for `~nx_weapon_scar_body_spc-rgb&~04ee13be`.

### Demand builder reachability

`requested_color_map_slots` at `material_images.rs:104` iterates `for material in &catalog.materials` at line 106 with no reachability filter. It is a full catalog sweep, not a walk from scene roots. So the material pushed by `register_nx1_scar_body_color` is covered simply by being in the catalog. Three gates could still have skipped each slot, and none does: the semantic gate at line 116 calls `texture_semantic_decodes_as_normal`, which returns `Some(false)` for both `TS_COLOR_MAP` and `TS_SPECULAR_MAP`; the binding gate at line 120 requires `texture.image` to be `Some`, and both bindings at `match_walk.rs:119` and `:127` carry the indices returned by the two pushes; the skip gate at lines 123–129 skips images already decoded or already claimed, and both slots have `decoded: None` and `pending_decode: None`, so neither is skipped and both land in the request list.

### Post-registration decode

`plan_material_color_maps` call sites are all three in the `lane\` modules (`iw4.rs:987`, `iw5.rs:701`, `t5.rs:648`). None is in `match_walk.rs`. The match-load path calls a different function. At `match_walk.rs:706` registration runs, and at `:708` the very next statement is `decode_material_color_maps(&image_trees, &mut global, ...)` on the same `&mut global`. That function uses the same demand builder. `decode_material_color_maps` at `material_images.rs:61` calls `requested_color_map_slots(catalog)` at line 67, which is the identical full-catalog sweep from line 104. It then fills `slot.decoded` at line 86. So the equivalent decode does run after registration, one line later, through the sibling function that shares the demand builder.

### NamespaceTrees indexing

`NamespaceTrees::discover` at `namespace_trees.rs:32` anchors on the located `common_mp` zone via `find_zone_file_version`, then builds `NamespaceTree::from_anchor(found.path)` at line 42. `from_anchor` at line 17 sets `main` with `game_main_for_zone(&anchor).ok()` at line 18. That is the same helper the earlier `ImageDemandPlan::run` path used. `decode_requests_from_trees` at `material_images.rs:394` calls `trees.main_for(namespace)` and then `IwdIndex::open(main)` at line 395. So this path reaches the identical `IwdIndex::open` on the identical `main\` directory as the path traced earlier. There is no separate lookup mechanism. The namespace filter also lines up. `register_nx1_scar_body_color` registers both images under `AssetNamespace::Iw4` at `match_walk.rs:37`. `decode_requests_from_trees` iterates namespaces starting with `Iw4` at line 377 and selects rows by `image.namespace == namespace` at line 388, so both slots are collected in that pass and resolved against `main_for(Iw4)`.

### Zone path derivation

`game_main_for_zone` at `crates/asset_transport/src/iwd.rs:395` iterates `zone_ff.ancestors()` and returns the first `ancestor.join("main")` that `is_dir()`, erroring only if none is found. `NamespaceTrees::discover` anchors on `common_mp`, which resolves to `[local path] Walking its ancestors on disk gives:

```
[local path]   main_is_dir=False
[local path]            main_is_dir=False
[local path]                 main_is_dir=True   -> returns here
```

No nearer `main\` shadows it, so the returned path is `[local path] which is exactly where `nx1_scar2_images.iwd` now sits at 1,049,150 bytes.

### Resolution chain closed

The material is registered at `match_walk.rs:706`, decoded one line later at `:708`, its two empty slots are demanded by the full-catalog sweep, the namespace filter selects them under `Iw4`, the tree resolves `main_for(Iw4)` to the directory holding the new `.iwd`, and the index keys both entry names without any case change.

### Remaining risk

`main\` holds sixteen `.iwd` files including several multi-hundred-MB archives, and `open_uncached` indexes all of them, propagating any malformed archive as a whole-directory failure. That sweep has not been verified to succeed.

### Observations

- `nx1_scar_body_col.iwd` already exists in `main\` at 2,097,675 bytes, larger than the two IWIs combined. It may already resolve `nx_weapon_scar_body_col` from earlier work.
- `main\` contains 15 other `.iwd` files. `open_uncached` indexes every one of them. If any is a malformed ZIP, `index_image_entries` returns an error and the whole directory index fails. That is a pre-existing risk, not something the new file introduces.

## Missing IWIs from the full dump

11 PNGs in the original dump have no matching IWI by stem:

- `cardtitle_harrier.png`
- `cod4_prestige_01.png` through `cod4_prestige_09.png`
- `com_bluetarp_nml.png`

None of these are required for scar2. Both scar2 body textures and the other 86 scar2 part textures have matching IWIs.

## Standing limits

- MP key-at-38 files have never been read at offset 38. The method that worked on galleria and common_mp has not been applied to them.
- `nx_hospital.ffm` streams 4/5 length discrepancy is unresolved.
- No LZX decoder exists on disk or on the machine. PDB type stream is zeroed.
- Malformed-archive risk in `main\` unverified.
