# Gaps

From the 2026-10-03 four-review pass. A gap is not a task claim. Owner is unset until a lead takes it.

| Gap | Evidence | Status |
|---|---|---|
| Create-a-class gun tabs MW2-only on the owner screen | Playtest of `039b125`. Contract at `setup.rs` around 590–606. | Open. Log first. |
| Skip log not in the tree | Phone contract and all four reviews. | Open. After offer-count log. |
| Offer count before `categories_for` not logged | Claude review. Super Bunny: nothing logs weapon families per namespace. | Open. First code change. |
| MW3 and BO1 guns not_spawnable even if tabs appear | Claude. Two milestones. | Open. After tabs. |
| No owner playtest of three gun tabs | All four reviews. | Open. |
| `docs/PROGRESS.md` names tip `039b125` | Branch tip in review was `3887778`. | Open. Stamp, do not mark fixed. |
| Emblems 202 counted, owner saw 0 | Playtest. Commits `97cbb73`, `4bb5704` not owner-seen. | Open. |
| Strike packages empty | `strike_packages_available()` false. | Known. Do not invent a menu. |
| Camos 18 counted, not on screen | `PROGRESS.md`. | Open. |
| Readers 0 of 7 with a name list | `cod-readers` board, per LongCat. | Known. Not this pass. |
| ERR-049 load window | 158–221 s, or about ten minutes in one run. | Open. Gate on menu claims. |
| ERR-060 image misses | 24/166 weapons, 319/778 attachments. | Open. |
| No GSC interpreter | ERR-050. | Known. Blocks five tracked ideas. |
| Brain dates lie | `ERRORS.md` 2026-09-29. `SYNC-STATE.md` 2026-09-30. | Known. Do not quote as current. |
| Phone contract only on public slice | `k7-slice-1844`. | Copy into brain before that repo is deleted. |

Scores against this list, 2026-10-03, tip `3887778`: finished product 12–15, visible client 30–35. Judgments, not measurements.
