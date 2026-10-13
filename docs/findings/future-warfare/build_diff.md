# Build Diff - NX1 / Call of Duty: Future Warfare multiplayer content

All builds share the same base string: `Build 546 12/18/2011 21:02:16 CODEBOT3 SHOOT FOR THE STARS`
(found at the top of `console.log`, `console_mp.log`, `assert_mp.log` and in the XEX binaries).

## Executables / symbols

| Build (internal)   | XEX                          | MAP                    | PDB                  | MAP timestamp        | XEX size   | MAP symbols | decoded string literals |
|--------------------|------------------------------|------------------------|----------------------|----------------------|------------|-------------|--------------------------|
| nx1mp_Test         | 2-nx1mp.xex                  | 2-nx1mp.map            | (none)               | Sun Dec 18 21:03:12 2011 | 11,014,144 | 76,895      | 17,871 |
| nx1mp_Demo         | 5-nx1mp_demo.xex             | 5-nx1mp_demo.map       | 5-nx1mp_demo.pdb     | Thu Jan 05 11:44:44 2012 | 6,803,456  | 44,393      | 7,366 |
| nx1mp_Demo         | 0-Convoy Test 1_5.mp.xex     | 0-Convoy Test 1_5.mp.map | 0-Convoy Test 1_5.mp.pdb | Thu Jan 05 11:44:44 2012 | 6,803,456 | 44,393 | 7,366 |
| nx1mp_FastServer   | 6-nx1mp_fast_server.xex      | 6-nx1mp_fast_server.map | 6-nx1mp_fast_server.pdb | Sun Jan 08 22:04:50 2012 | 10,686,464 | 77,897 | 17,875 |
| nx1mp_FastServer   | 0-Nightly MP maps.mp.xex     | 0-Nightly MP maps.mp.map | 0-Nightly MP maps.mp.pdb | Sun Jan 08 22:04:50 2012 | 10,686,464 | 77,897 | 17,875 |
| nx1sp_Test         | 1-nx1sp.xex                  | 1-nx1sp.map            | (none)               | Sun Dec 18 21:02:54 2011 | 9,498,624  | -           | - |
| nx1sp_FastServer   | 3-nx1sp_fast_server.xex      | 3-nx1sp_fast_server.map | (none)              | Sun Dec 18 21:04:05 2011 | 8,253,440  | -           | - |
| nx1sp_Demo         | 4-nx1sp_demo.xex             | 4-nx1sp_demo.map       | (none)               | Wed Nov 30 10:47:36 2011 | 6,599,660  | -           | - |

Notes:
- `0-Convoy Test 1_5.mp.*` is byte-identical in content to `5-nx1mp_demo.*` (same size, same internal name `nx1mp_Demo`, same timestamp).
- `0-Nightly MP maps.mp.*` is the same build as `6-nx1mp_fast_server.*` (internal name `nx1mp_FastServer`).
- A separate `6-nx1mp_fast_server.pe` (10,643,456 bytes, `MZ` PE header) exists - a Windows/x86 build artifact of the fast server.

## Multiplayer feature parity

A keyword scan of the decoded string literals in the MP MAP files shows the MP feature set is
**present in every MP build** (`2-nx1mp.map`, `5-nx1mp_demo.map`, `6-nx1mp_fast_server.map`,
`0-Nightly MP maps.mp.map`):

escort, escortplus, ugv, trophy, mtdm, convoy, specialty_moonsuit, specialty_jetsuit,
specialty_stealthsuit, vacuum_railgun, vacuum_shotgun, lidar, riotshield, motiontracker,
portableradar, scar2, asmk27, xm108, glo_reflex, lunarrifle, moon, lunar, cloaking.

## Real differences

1. **Demo build is smaller.** `nx1mp_Demo` has ~44k symbols / 7.4k decoded literals vs ~77k / ~17.9k
   for `nx1mp_Test` and `nx1mp_FastServer`. The missing literals are almost entirely
   **assertion / debug / Demonware (bd*) networking strings**, not gameplay data. The demo build is
   effectively a stripped/assertion-light build.
2. **Social strings only in FastServer.** `BD_FACEBOOK_*` and `BD_TWITTER_*` field strings are present
   in `6-nx1mp_fast_server.map` but absent from `2-nx1mp.map`. (Facebook/Twitter integration added by
   Jan 08 2012.)
3. **Script-debugger strings** (`$CBg_debugExprMem`, `$CBg_debuggerMem`, `$CBarrayIndex != ...`,
   `$CBIS_NAN ...`) are richer in `nx1mp_Test` than in `nx1mp_FastServer` (build config difference).
4. **Runtime-only features.** The following appear only in `console_mp.log` (a runtime dvar dump), not in
   the executable symbol strings: `hvt` gametype, `cwtest` gametype, `scr_gasCloud*` (gas grenade),
   `scr_airdrop_exosuit`. These are data-driven (fastfile/config) rather than compiled symbols, so their
   absence from the executables is expected.
5. **No fastfile is bound to a specific build.** All 28 MP map fastfiles (`mp_nx_*.ff/.ffm`) and the
   shared MP fastfiles (`common_mp.ffm`, `ui_mp.ffm`, `code_post_gfx_mp.ffm`, `development_mp.ffm`,
   `patch_mp.ffm`, `ez_common_mp.ffm`, `ez_ui_mp.ffm`) live in the same root and are loaded by any MP
   build; the loaded set is chosen at runtime (`console_mp.log` shows `mp_nx_skylab` loaded).

## SP vs MP

- MP builds link `*_mp` object files (`bg_perks_mp.obj`, `bg_animation_mp.obj`, `cg_main_mp.obj`,
  `cg_scoreboard_mp.obj`, `cg_vehicles_mp.obj`, `cg_newDraw_mp.obj`, `cg_draw_mp.obj`,
  `aim_target_mp.obj`) and MP fastfiles.
- The SP builds do **not** include the MP object files or the `specialty_*` perk table in their maps,
  but the SP `.ffm` files (`nx_*.ffm`) and `common_sound_*` files are separate from the MP ones.
- Some MP data is shared with SP (e.g. the `bg_` / `cg_` weapon and animation code, `lunar`/`moon`
  mechanics that originate in the SP lunar level).
