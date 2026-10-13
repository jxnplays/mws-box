# iwi-gen

**Purpose:** Generate IWI v8 loadscreen images for maps that lack them.
**Output:** `.iwi` files at `brain/assets/iwi/loadscreen_<mapname>.iwi`.

## Usage

```powershell
# Generate for a single map
.\iwi-gen.ps1 -MapName "mp_crash"

# Generate for all maps lacking art
.\iwi-gen.ps1 -All

# List maps that need loadscreen art
.\iwi-gen.ps1 -ListOnly
```

## IWI v8 format

- Header: 32 bytes, little-endian
- Magic: `IWi`, version: 8, flags: 0, usage: 0, format: 1 (BGRA8)
- Dimensions: 1024x1024, depth: 1
- picmip[0] = file size, picmip[1] = 32, picmip[2] = 0, picmip[3] = 0
- Payload: raw BGRA pixels immediately after header

## Expected IO

- **Input:** Map name(s) from union inventory.
- **Output:** `.iwi` files at `brain/assets/iwi/loadscreen_<mapname>.iwi`.

## Notes

- IW4L's `decode_map_preview` looks for `images/loadscreen_<mapname>.iwi` inside `.iwd` files in a `main/` directory.
- These `.iwi` files are ready to be injected into `.iwd` archives (ZIP) at `images/loadscreen_<mapname>.iwi`.
- This is a stopgap — real art should replace placeholders later.
- See `brain/ERRORS.md` ERR-001 for full defect description.
