# Future Warfare (NX1)

NX1 is treated as a namespace / DLC category. It does not fork the core render path.

## Current state

| Component | % | Notes |
| --- | --- | --- |
| Namespace / DLC plumbing | 100% | Top-level category. SCAR Mod 2 selectable. |
| .cast mesh reader | 100% | Skeleton, geometry, tags. |
| .cast animation reader | 100% | All 59 clips for the test weapon parse. |
| .cast material reader | 100% | Surfaces and PNG maps extracted. |
| Animation binding | 100% | Clips bound, including idle. |
| Viewmodel rig | 100% | NX1 hands placed and in the draw plan. |
| Playable in game | ~95% | Renders, aims, fires, reloads, swaps. |
| NX1 textures on gun | ~40% | Reader and loader work. Binding still uses donor textures. |
| NX1 sounds | 0% | WAVs staged, not wired. |
| Generalise to all guns | ~10% | Reader is gun-agnostic. Wiring is still specific to the test weapon. |
| Maps | 0% | Not started. |

One playable weapon is roughly 70% complete. The reusable reader and converter work is roughly 90% complete. The main open problem is texture binding in first-person view.
