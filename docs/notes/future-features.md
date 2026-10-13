# Future features

Logged 2026-10-04 by owner during the 666244f playtest. Long-term, not current tasks. Do not assign to any agent tonight.

## Akimbo on every weapon

Owner wants every weapon in the game to support akimbo, including snipers (Intervention) and launchers (RPG). Sounds absurd; owner is explicit that this is the goal.

- Akimbo is a weapon flag in the GSC weapon table. The engine already dual-wields when the flag is set; MW2's akimbo system is the flag plus a second viewmodel.
- Flipping the flag on every weapon is a data change, not a rewrite.
- The real cost is viewmodels: every gun needs a second-hand model, and most do not have one. That is the work.

## Tactical knife on every handgun

Owner wants the MW2 pistol-plus-knife off-hand setup available on all handguns.

- MW2's tactical knife is a weapon attachment that swaps the off-hand model.
- Making it available on every handgun is another flag/attachment availability change.
- The knife model already exists in the game files.

## Notes

- Neither blocks menu fixes. Both are engine-level, not menu-level.
- When an agent is assigned either, it starts from the weapon table and the existing akimbo/knife attachment code, not from scratch.
