# crowbar

**Purpose:** Decompile Source `.mdl` -> `.smd` + `.qc`.
**Tool:** Crowbar (Source engine decompiler)

## Command

```
crowbar decompile <path-to-.mdl>
```

## Expected IO

- **Input:** `.mdl` file (Source engine model).
- **Output:** `.smd` (skeleton/mesh data) + `.qc` (model compile script).

## Notes

- Crowbar not installed. Download: https://github.com/ZeqMacaw/Crowbar/releases
- `.smd` files can be imported into Blender or converted to glTF.
- `.qc` contains bone hierarchy, attachment points, and compile settings.
