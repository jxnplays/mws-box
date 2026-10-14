# `.cast` mesh reader — transform bugs and the bind-pose invariant

Public research notes. No game assets are included.

**Scope:** `crates/asset_model/src/cast_xmodel.rs`. The bugs below are properties of the
**`.cast` mesh format**, not of any particular weapon. The reader contains no
weapon-specific logic.

---

## Why this is a format-level note

The `.cast` reader is used for viewmodel meshes, world meshes and animation clips alike. It
parses skeleton, geometry, materials and tags, and it does not know which weapon it is
reading. Every defect described here applies to any `.cast` file the reader accepts.

That distinction matters when triaging a rendering fault: a bug in this reader will
reproduce on every mesh, while a bug in weapon wiring will not.

---

## 1. The file states both local and world transforms — use the world one

### Symptom

Skinned geometry rendered at wildly incorrect positions. Individual bones were displaced
by large distances rather than subtly skewed: one bone sat roughly 152 cm (60 in) from
where the file placed it. Of 66 hand bones and 35 weapon bones in the sample, 63 and 18
respectively were wrong.

### Cause

The `.cast` bone record carries **two** transform pairs, and the file states both:

| Pair | Meaning |
| --- | --- |
| `lp`, `lr` | local — parent-relative |
| `wp`, `wr` | world |

The reader was reading `lp`/`lr` and storing the result as though it were a world
transform. The value it read was correct; the space it was interpreted in was not.

### Why it was not obvious

`lp` and `wp` are structurally identical — same field layout, same types, same counts. A
reader that stores the local pair into a world-typed slot produces plausible numbers that
are wrong by a translation and a rotation. Nothing in the data signals the mistake; the
two interpretations differ only in what they mean.

### Detecting it without launching the game

The bind-pose invariant below catches this class of error outright. At bind pose every
skin matrix must be identity. A parent-relative transform read as a world transform is
almost never identity, and the failure appears as a large residual across many bones
rather than as a single suspicious value.

---

## 2. Translation components were assembled in the wrong order

### Symptom

A translation known to be on one axis appeared on another. A bone whose stored offset was
`tag_player tz = -152.4` was being displaced along a different axis entirely.

### Cause

The three translation components were read into an array as `[ty, tz, tx]` instead of
`[tx, ty, tz]`.

### Why it was not obvious

The assembled array is structurally valid. Every component is a plausible float in a
plausible range, and the vector is a legitimate offset. Only the axis assignment is wrong,
and that is invisible to any check that validates ranges or lengths.

This is the most cheaply detectable defect of the three: a one-line component-order error
with no runtime symptom that reads as an error.

---

## 3. The bind-pose invariant

**At bind pose, every skin matrix must be identity.**

This is a property of the format's definition of bind pose, and it holds for every
`.cast` mesh — viewmodel, world model or animation source.

### Why it is worth encoding

Both bugs above are placement errors, and placement errors share one signature: at bind
pose, the skinning matrices are not identity. Both were found without a running game by
checking the invariant directly, and both would have been caught immediately by it.

The residual is also diagnostic. Absolute error is not very informative — it depends on
the mesh. The distribution is. A single large residual points at one bad bone or a bad
index. A broad spread points at a systematic error in the transform itself.

### Residual tolerance

Quantisation matters here. One bone at bind pose carries a measured residual of
`0.000005`, another `0.000007`, while a third reaches `0.007169` at depth 9.

The larger figure is **not** a bug. Quaternions are stored as 16-bit values, so a deep
bone accumulates a small quantisation error that is inherent to the format rather than a
defect in the reader. A tolerance that rejects `0.007169` would reject correct data.

Two things are worth keeping distinct:

- the **quantised** quaternion path used at runtime
- the **exact** path

A test that measures against the wrong one produces a small, stable, entirely spurious
residual — which is worse than no test, because it trains you to ignore the number.

---

## Summary

| # | Defect | Signal at bind pose | Caught by invariant |
| --- | --- | --- | --- |
| 1 | local transform read as world | large residual across most bones | yes |
| 2 | translation components out of order | moderate, systematic | yes |
| 3 | quantisation, not a defect | ~0.007 at depth 9 | no — expected |

The third row is the reason the invariant needs a tolerance rather than an equality check.