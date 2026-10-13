# gltfpack

**Purpose:** Optimize GLB files.
**Tool:** gltfpack (meshoptimizer)

## Command

```
gltfpack -i <input.glb> -o <output.glb> -cc
```

## Expected IO

- **Input:** `.glb` file.
- **Output:** Optimized `.glb` with compressed meshes.

## Notes

- gltfpack: https://github.com/zeux/meshoptimizer
- Use `-cc` for mesh compression, `-tc` for texture compression.
- Useful for reducing GMod character model size before loading into IW4L.
