# COD4 / WaW asset notes (external reference)

Neutral reference notes on CoD4 (IW3), WaW (T4), and related differences from MW2 (IW4). Compiled from external reverse-engineering work. No personal paths or session data.

## Zone / fastfile reading

- Schema-driven loader generated from OpenAssetTools per-game headers and command files (`IWx_Assets.h`, `*_Commands.txt`, `XAssets/*.txt`) into one data table, with one generic loader. OAT is GPL; use as a layout reference only and write original code.
- Correctness check: track block offsets exactly and count unresolved references. The XFile header’s per-block sizes act as a checksum. When every block size matches byte-for-byte and 0 references are unresolved, the loader is correct.
- Gotchas:
  - OAT reorder: `a b c` visits a, b and c consecutively at a’s position; it does not move them to the end. IW4 has types with more than one reorder.
  - A `-2` pointer reserves a 4-byte alias slot in the virtual block before the data, even for non-asset members.
  - Asset references can point back at the pointer field where something was first loaded inline.
  - Reusable members are everywhere (shared skeletons, sound files, weapon variant trees). Remember where reusable data was loaded and resolve back-references, or shared data returns empty.
  - Do not deep-clone remembered reusable trees (MW2 `common_mp` improved from ~8 s to ~2.5 s once cloning stopped).
  - Embedded fixed-size arrays (multi-pass techniques) must process every element.
- Container differences:
  - CoD4/WaW: 4 vs 3 pointer-block bits.
  - MW2: `IWffs100` signed container, 8 KB hash block per 2 MB piece, one zlib stream, 8 blocks.

## MW2 vs CoD4 asset differences

(Conversion direction: MW2 → CoD4-style in memory.)

- **XAnimParts**: Nearly identical. Flags byte maps to loop/delta; delta part goes from 12 to 8 bytes. All ~2,275 MW2 anims converted cleanly.
- **Weapons**: Every allowed attachment pair is its own weapon (e.g. `m4_acog_silencer_mp`, names sorted). One viewmodel with every attachment on it; `hideTags` pick what shows. Camos are `gunXModel[1..8]` variant models using CoD4-style detail-map camo. MW2 has 37 anim slots vs CoD4’s 33.
- **Materials**: 48 techniques map onto CoD4’s 34. MW2 q0 techsets put a detail normal map where CoD4 has the camo detail map.
- **Normal maps**: Two-channel unit XY; z must be reconstructed.
- **Images**: IWI v8 has a 32-byte header with u32 flags (cube, volume, normal-map bits).
- **Reflection probes**: Alpha channel is noise and should be ignored.
- **Sky**: MW2 skybox cubes are mirrored relative to CoD4’s.

## Viewmodels

- **Pose rule**: An animated bone’s local translation = the XModel’s own `trans[i]` + the anim’s translation. The anim’s rotation replaces the local rotation.
- Do not use the bind pose as the base for viewhands. Viewhands models store `trans = 0`, and their anims carry absolute translations. Adding the bind pose doubled arm lengths and broke every viewmodel anim.
- Reflex sights: the red dot is projected along the lens normal by its shader (`mc_reflexsight`, additive). Mesh UVs do not map it; drawn as a plain texture it shows as a black square.
- Notetracks are sound alias names at normalized times.

## Sound

- CoD4 MP: all aliases are in `localized_common_mp`, not `common_mp`. `soundFile` is reusable; over half the aliases point back at earlier sound files.
- MW2: gun sounds are plain PCM in `localized_common_mp`; a channels table decides 2D vs 3D.
- WaW: MS-ADPCM WAVs stored as whole RIFF files, plus a few xWMA sounds that need a separate decoder. A `,name` sound has no data in that zone; the data lives in another zone.

## WaW specifics

- Guns, equipment and anims are in `common_mp`.
- MP characters are not in `common_mp`. They are in `localized_mp_<map>.ff` (e.g. Makin for Marines/Japanese, Dome for Russians/Germans). Character scripts pair body, head and view arms.
- WaW weapons use `viewmodel_hands_no_model`: the arms come from the character, not the weapon.
- Name case: weapon files’ anim names differ in case from the zone’s names; match case-insensitively.
- ADS anims: WaW’s ADS anims position `tag_torso` from frame 0 while idle, fire and reload leave it alone, so the ADS layer must always apply.
- No sprint anims: sprinting is procedural (`sprintRot`/`sprintOfs`). `sprintOfsR` runs along the view’s left axis; read naively, the gun flies off screen.
- MP has no weapon camos. The camo table rows are leftover stubs.
- XAnimParts, images and vertex formats are the same as CoD4’s.

## Dead ends worth skipping

- Building on bind poses for viewmodels (see above).
- Treating map brush models (`cmodels[1..]`) as world collision. They are in entity-local space; on one map they put a giant slab over the level.
- Reflection probe 0 is an engine placeholder (the same reddish cube on every map). Treat it as “no probe”.
