# MW2 Missing Systems Inventory

What IW4L (and this fork) still lacks for a complete MW2 multiplayer experience. Built from the October 4 playtest and the upstream IW4L state. Each item is a Rust rewrite in its own crate. Ordered by impact.

## 1. Killstreaks — NOT BUILT

- MW2's killstreak system: earn score, select a streak, call it in, see the effect.
- Includes: UAV, Counter-UAV, Sentry Gun, Predator Missile, AC-130, EMP, Chopper Gunner, and the rest of the MW2 roster.
- New crate: `crates/killstreak_iw4`.
- Blocks: the in-game progression loop. Without it, MW2 multiplayer has no reward structure.

## 2. Camos — NOT WIRED

- MW2's 8 camos: Desert, Arctic, Woodland, Digital, Urban, Blue Tiger, Red Tiger, Fall.
- The customization screen reads BO1's 18 from statstable.csv. MW2's table is not read.
- Create-a-class camo picker is a separate code path from the customization browser — same gap as the BO1 perk bug before c3590df.
- New crate or module: `crates/camo_iw4`.
- The 18 rows the owner saw (gunmetal through black) are BO1's list including extras. MW2's 8 are a different table.

## 3. Perks — PARTIAL

- MW2 perk effects in-game are incomplete. The tabs show names; the effects are not fully wired.
- BO1's 31 perks from statstable.csv work in the tabs (c3590df). MW2's perk table may not be read the same way.
- Extend the existing perk wiring. Do not rebuild.

## 4. Spec Ops — NOT BUILT

- MW2's co-op mode. Requires the killstreak and perk systems first.
- Later in the MW2 phase.

## 5. Scoreboard / killcam — NOT BUILT

- The in-game HUD that shows kills, deaths, and the killcam replay.
- Extend existing HUD work.

## 6. In-game HUD — PARTIAL

- Some HUD elements exist. The full MW2 HUD (compass, minimap, score feed) is not complete.
- Extend existing HUD crates.

## What works (do not rebuild)

- 26 of 36 MW2 maps with images. 10 are image gaps.
- All MW2 guns in create-a-class with images.
- Movement, viewmodels, attachments: the IW4L runtime core.
- Create-a-class menu: three-game tabs, All view, allowlist.
- The three-game menu structure: MW2, MW3, BO1 tabs and All view.

## The order

1. Killstreaks (biggest gap, blocks progression).
2. Camos (data exists, wiring is the gap).
3. Perks (extend existing).
4. Spec Ops (after 1-3).
5. Scoreboard / killcam (extend existing HUD).
6. In-game HUD (extend existing).

After MW2's baseline is playable: MW3, then BO1, then custom maps.
