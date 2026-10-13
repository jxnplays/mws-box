# vtf

**Purpose:** Convert `.vtf` <-> PNG.
**Tools:** VTFEdit / VTFCmd

## Commands

```
vtf2png <path-to.vtf> <output.png>
png2vtf <path-to.png> <output.vtf>
```

## Expected IO

- **Input:** `.vtf` (Valve Texture Format) or `.png`.
- **Output:** `.png` or `.vtf`.

## Notes

- VTFEdit: https://github.com/NeilJed/VTFLib
- VTFCmd: command-line alternative.
- `.vtf` files are Source engine textures. `.vmt` files are the material scripts that reference them.
- For GMod import, textures usually need to be PNG before glTF conversion.
