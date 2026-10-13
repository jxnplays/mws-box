# Learning — two game enums, and why a Ghosts menu row was impossible

**Date:** 2026-10-02
**Project:** mws&box
**Tags:** ui, catalog, zone-game, namespace, ghosts, menu
**Discovered by:** Space Bunny

## Summary

The product has **two** game enums that look interchangeable and are not. `ZoneGame`
has four variants including Ghosts; `AssetNamespace` has three, and converting Ghosts
returns `None` **deliberately**. Every per-game menu in the tree keys its row axis on
`AssetNamespace`, so a per-game Ghosts row was not missing work — it was structurally
impossible until the row axis moved to `ZoneGame`.

## Detail

| enum | variants | means | lives in |
|---|---|---|---|
| `ZoneGame` | `Iw4`, `Iw5`, `T5`, **`Ghosts`** | an envelope this build *recognises* | `asset_core::zone_game` |
| `AssetNamespace` | `Iw4`, `Iw5`, `T5` | a game we have an asset *pipeline* for | `asset_core::asset_key` |

`AssetNamespace::from_zone_game(ZoneGame::Ghosts) == None`, and `zone_game.rs` says why
in the type docs: `AssetNamespace` keys the decoded-asset cache, so mapping Ghosts onto
`Iw4` would let a Ghosts zone look decodable when it is not.

The consequence nobody had written down: **`groups::game_title` takes
`AssetNamespace`.** So it has no arm for Ghosts and cannot be given one without lying
about which enum it means. The map list already emits a `ghosts:mp_*` pack — it just had
no title to show, because the function that titles rows cannot represent it.

The fix is not "add a Ghosts arm". It is keying the **row axis** on `ZoneGame` (which
must be able to *name* a recognised game) and leaving **asset lookups** on
`AssetNamespace` (which must only ever name a readable one). `ui/src/frontend/catalog.rs`
does this, and `game_title` there is a projection of the one `zone_game_title` table so
the namespace-keyed picker and the envelope-keyed axis cannot drift.

A test asserts the `None` still holds. If it ever becomes `Some`, the two enums have
been merged and the whole split needs rethinking — that is the point of pinning it.

### The same hazard, three times over

`"MODERN WARFARE 2"` appears in **three** places: `catalog::zone_game_title`,
`discover::pack_label`, and `console::class_menu::game_title`. Two are deliberate
(catalog is retail-uppercase for the row axis; discovery is sentence-case because the
working map screen shows it). The third — `class_menu` — is a private duplicate that
nobody has migrated. Three copies of a title table is how one of them ends up naming a
game the other two have never heard of. Left alone deliberately: it drives the live
class picker and this session does not deploy.

### `Custom Maps` is not a game

`discover::pack_label` emits `"Custom Maps"` as a pack label alongside the four real
ones. It is a **bucket**, not a title. `catalog::pack_game("Custom Maps") == None`, so
it never gets a game row — giving it one would answer "which game is this?" with a
non-answer. It passes through to the row axis unchanged.

## Related files

- `crates/asset_core/src/zone_game.rs` — the `is_loadable` gate and why Ghosts is `None`
- `crates/ui/src/frontend/catalog.rs` — the row axis and the refusal model
- `crates/asset_transport/src/discover.rs` — `pack_label`, and the load gate
- `brain/ERRORS.md` ERR-053 (`ui_games_root` root cause) — same family of confusion

## Status

open — `console::class_menu::game_title` still needs migrating onto the one table, and
that needs a deploy to be safe.