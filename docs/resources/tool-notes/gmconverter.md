# gmconverter

**Purpose:** Read Source MDL, write glTF/GLB with skeleton + weights.
**Repo:** `brain/repos/gmconverter` (cloned this session)

## Command

```
gmconverter <input.mdl> <output.glb>
```

## Expected IO

- **Input:** `.mdl` + `.vvd` + `.vtx` (`.dx90.vtx`) + `.phy` + `.vtf`/`.vmt`.
- **Output:** `.glb` or `.gltf` with full skeleton, weights, and textures.

## Notes

- GMConverter is the primary tool for the GMod -> skate character pipeline.
- Output glTF/GLB can be retargeted onto the skate skeleton in `skate/rig.rs`.
- If GMConverter fails, fallback: Crowbar decompile -> Blender import -> glTF export.
