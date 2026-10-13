# Plutonium Reference

**Read-only reference.** No edits, no deletes, no full-tree copies, no Plutonium client clone.

## Paths

| Role | Path |
|---|---|
| Plutonium root | `[local path] |
| IW5 usermaps | `storage\iw5\usermaps` (63 maps) |
| IW5 mods | `storage\iw5\mods` (1 folder: cj) |
| T4 storage | `storage\t4\` |
| T5 storage | `storage\t5\` |
| T6 storage | `storage\t6\` |

## Relevance to mws&box

- Plutonium iw5 usermaps are a second usermap source alongside G:.
- Plutonium maps have `.ff` (fastfile) format — proper IW4L-compatible zones.
- G: usermaps lack `.ff` files — they are raw `.iwd` + `.arena` folders.
- If Plutonium path were added to `IW4L_GAMES`, its maps would be discovered by `list_mp_map_packs`.
- Plutonium is NOT a game client for mws&box — it is a reference tree only.

## What Plutonium is NOT

- Not a source of truth for the playable game.
- Not a replacement for the Steam installs.
- Not a tool to clone or install.
