# loadscreen-gen

**Purpose:** Generate placeholder loadscreen images for maps that lack them.
**Output:** PNG images (to be converted to `.iwi` for injection into `.ff` IWD).

## Usage

```powershell
# Generate placeholder for a single map
.\loadscreen-gen.ps1 -MapName "mp_dust2"

# Generate placeholders for all maps lacking art
.\loadscreen-gen.ps1 -All

# List maps that need loadscreen art
.\loadscreen-gen.ps1 -ListOnly
```

## Expected IO

- **Input:** Map name(s) from union inventory.
- **Output:** PNG files at `brain/assets/placeholders/loadscreen_<mapname>.png`.

## Notes

- IW4L's `decode_map_preview` extracts loadscreens from `.ff` file IWD sections.
- The `.iwi` format is IW4's proprietary image format. PNG must be converted to `.iwi` before injection.
- Placeholder images are 1024x512 solid color with map name text.
- This is a stopgap — real art should replace placeholders later.
- See `brain/ERRORS.md` ERR-001 for full defect description.
