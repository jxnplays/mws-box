# NX1: the scar2 and xm108 sets, closed on disk

Written from entries already recorded in `output/one-gun/lzx-spec.md`. Every value below is
an observation from a Saluki runtime export of the `nx1` title under
`output/one-gun/tools/saluki/exported_files/nx1`. No `.cast`, `.png` or `.txt` in the export
was opened for this summary; the two material files named here were opened in the entries they
come from, and nothing else was.

## weapon_scar2

**Model file**

```
nx1\models\weapon_scar2\weapon_scar2_LOD0.cast     152,152 bytes
```

**Material file and the four images it names**

`nx1\models\weapon_scar2\_mat_info\mtl_nx_weapon_nx_scar_body.txt` — 498 bytes.

| Label in file | Image named |
|---|---|
| `unk_semantic_34ecccb3` | `~nx_weapon_scar_body_spc-rgb&~04ee13be` |
| `unk_semantic_59d30d0f` | `nx_weapon_scar_body_nml` |
| `unk_semantic_a0ab1041` | `nx_weapon_scar_body_col` |
| `unk_semantic_eb529b4d` | `detail_kaki_paint` |

**The three images, as files in `nx1\images\`**

```
nx1\images\~nx_weapon_scar_body_spc-rgb&~04ee13be.png    1,738,512 bytes
nx1\images\nx_weapon_scar_body_nml.png                     690,407 bytes
nx1\images\nx_weapon_scar_body_col.png                     838,935 bytes
```

All three names match those in the material file exactly, including the `~` prefix and hash
suffix. **That is a name match only.** The images were not opened, and no claim is made about
their content, or about whether the extensionless names in the material file resolve to these
`.png` files at runtime.

`nx1\images\detail_kaki_paint.png` also exists.

**Context, not part of the claim.** Five parts — `bar`, `body`, `iron`, `mag`, `stock` — each
have a `_col`, an `_nml` and one `~`-prefixed `_spc-rgb` file in `images\`: 15
`nx_weapon_scar*` files total. That matches the five material files in
`weapon_scar2\_mat_info\`, one per part. **The `_iron`, `_mag` and `_stock` material files were
not read, so no claim is made that those materials name those images.**

## weapon_xm108

**Model files**

```
nx1\models\weapon_xm108\weapon_xm108_LOD0.cast             264,656 bytes
nx1\models\viewmodel_xm108\viewmodel_xm108_LOD0.cast       1,055,252 bytes
```

**Material file and the image it names**

`nx1\models\weapon_xm108\_mat_info\mtl_nx_weapon_xm108.txt` — 488 bytes.

| Label in file | Image named |
|---|---|
| `unk_semantic_a0ab1041` | `weapon_xm108sear_col` |

This file names four images: `~weapon_xm108sear_spc-rgb&wea~cb903a8a`,
`weapon_xm108sear_nrml`, `weapon_xm108sear_col` and `detail_black_paint`. **Three of the four
appear in `nx1\images\`** with matching names before the extension, including
`weapon_xm108sear_col`. Name match only; none was opened.

## Scope

**This is a loaded-pool runtime export, not static content.** The `scar2` and `xm108` stems
were recorded earlier in this investigation as string-only, from symbol and string dumps across
the install. This document supersedes that *for the loaded pool*: folders, a mesh, material
info and images exist for both under the names used here.

**It does not supersede the static-content negatives.** Searches of 100,839 extracted blocks
recorded in `lzx-spec.md` found `scar2` in only three of them and `viewmodel_xm108` in none of
76 non-`nx_*` directories. A folder in a loaded pool is not a match in static content, and
those negatives stand.

The export was still being written during the earlier listing passes — `models\` went from 390
to 21,655 files between two reads — so **any absence recorded during that window is weak
evidence.**

**No field within either material file is named.** The semantic and constant labels in both are
literally `unk_semantic_*` and `unk_constant_*`, and nothing here interprets what any row,
image or constant means.

**No model name is emitted.** Everything above is a filename, a size or a string as written.# NX1: the scar2 and xm108 sets closed on disk

Compiled from `output/one-gun/lzx-spec.md`. Everything below was read from the Saluki export
at `output/one-gun/tools/saluki/exported_files/nx1` — a runtime export of a loaded model pool,
not static content. No `.cast`, `.png` or mesh file was opened; the two `.txt` material files
named here were read in full.

## weapon_scar2

### The model

| | |
|---|---|
| Path | `nx1\models\weapon_scar2\weapon_scar2_LOD0.cast` |
| Size | **152,152 bytes** |

One `.cast`, sitting directly in the folder.

### The material

`weapon_scar2\_mat_info\mtl_nx_weapon_nx_scar_body.txt` (498 bytes) names four images:

```
~nx_weapon_scar_body_spc-rgb&~04ee13be
nx_weapon_scar_body_nml
nx_weapon_scar_body_col
detail_kaki_paint
```

| Label as written in the file | Image name |
|---|---|
| `unk_semantic_34ecccb3` | `~nx_weapon_scar_body_spc-rgb&~04ee13be` |
| `unk_semantic_59d30d0f` | `nx_weapon_scar_body_nml` |
| `unk_semantic_a0ab1041` | `nx_weapon_scar_body_col` |
| `unk_semantic_eb529b4d` | `detail_kaki_paint` |

**The labels are literally `unk_*` in the file. No field within it is named or interpreted.**

### The three images, resolved in `images\`

| Image path under `nx1\images\` | Size |
|---|---|
| `~nx_weapon_scar_body_spc-rgb&~04ee13be.png` | **1,738,512 bytes** |
| `nx_weapon_scar_body_nml.png` | **690,407 bytes** |
| `nx_weapon_scar_body_col.png` | **838,935 bytes** |

All three names match the material's entries byte-for-byte, including the `~` prefix and the
hash suffix. `detail_kaki_paint.png` is also present in `images\`.

**This is a name match only.** No image was opened, and nothing is claimed about content,
dimensions, format, or whether the extensionless reference resolves to the `.png` at runtime.

### The wider set

15 files matching `nx_weapon_scar*` in `images\` — five parts (`bar`, `body`, `iron`, `mag`,
`stock`), each with a `_col`, an `_nml`, and one `~`-prefixed `_spc-rgb` file. That matches
the five material files in `weapon_scar2\_mat_info\`, one per part. The `_iron`, `_mag` and
`_stock` materials were **not** read, so no claim is made that they name those images.

Token order differs between material and images: materials read `mtl_nx_weapon_nx_scar_body`
while images read `nx_weapon_scar_body_*`. Recorded as an observed difference; neither ordering
is claimed canonical.

## xm108

### Both models

| | Path | Size |
|---|---|---|
| Viewmodel | `nx1\models\viewmodel_xm108\viewmodel_xm108_LOD0.cast` | **1,055,252 bytes** |
| Worldmodel-prefixed | `nx1\models\weapon_xm108\weapon_xm108_LOD0.cast` | **264,656 bytes** |

One `.cast` in each folder. No `worldmodel` name exists in this tree — the second family is
named `weapon_`, and that is recorded as the folder name without claiming what it denotes.

Folder contents: `viewmodel_xm108` holds 91 files (1 cast, 65 under `_images`, 25 under
`_mat_info`); `weapon_xm108` holds 25 files (1 cast, 18 images, 6 material). Both account fully.

### The material

`weapon_xm108\_mat_info\mtl_nx_weapon_xm108.txt` (488 bytes) names four images:

```
~weapon_xm108sear_spc-rgb&wea~cb903a8a
weapon_xm108sear_nrml
weapon_xm108sear_col
detail_black_paint
```

**It does name `weapon_xm108sear_col`** — as the value of `unk_semantic_a0ab1041`. The other
three image names in `images\` all contain the compound `xm108sear`; none is a plain `xm108`
filename.

| Image path under `nx1\images\` | Size |
|---|---|
| `~weapon_xm108sear_spc-rgb&wea~cb903a8a.png` | 1,368,670 bytes |
| `weapon_xm108sear_nrml.png` | 1,185,108 bytes |
| `weapon_xm108sear_col.png` | 1,533,492 bytes |
| `weapon_xm108sear_ironsights_col.png` | 65,256 bytes |
| `weapon_xm108sear_ironsights_nrml.png` | 74,142 bytes |
| `~weapon_xm108sear_ironsights_~d32415d5.png` | 93,248 bytes |

**32 `_mat_info` files across `models\`** carry `xm108` in the filename, three per folder
across ten variant folders.

## Scope

**This is a loaded-pool export, not static content.** The 100,839-block static searches
recorded elsewhere in this investigation — `scar2` absent from 1,778 `mp_nx_blank1` blocks and
1,450 `common_mp` blocks, `viewmodel_xm108` absent from 76 non-`nx_*` directories — are
unaffected and consistent with what is here.

The export was still being written during the first four listing passes (`models\` went from 5
`viewmodel_` folders to 180 between two of them). **Any absence recorded from this tree is weak
evidence.** `pulserifle` appears here as a sound asset only
(`sounds\weapons\pulserifle\weap_pulserifle_fire_npc.wav`) and has no folder under `models\`;
`vacuum` returns zero matches anywhere.

**No model name is emitted and no asset is identified.** These are paths, filenames and byte
counts as read. No field inside any material file is named or interpreted.

No `.xex` was opened. LZXDecoder was not called.
