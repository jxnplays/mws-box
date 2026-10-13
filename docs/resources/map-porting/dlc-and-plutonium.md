# DLC and Plutonium — Map Porting Notes

## DLC maps

- MW2 DLC map packs live in `zone\DLC*\` folders within the game tree.
- DLC maps have `.ff` files and are discovered by `list_mp_map_packs` (which reads the `DLC` folder name from the path).
- Plutonium iw5 usermaps include DLC-style maps (2 `.iwd` + 2 `.arena` + 4 `.ff` layout).

## Plutonium as a porting source

- Plutonium iw5 usermaps are proper fastfiles — they can be loaded directly by IW4L if the path is in `IW4L_GAMES`.
- No conversion needed for Plutonium -> IW4L (same fastfile format).
- G: usermaps would need `.ff` packaging to be IW4L-compatible.

## Loading screens

- Only `mp_bloc_2` (Plutonium) and `mp_backlot_snow` (G:) have loadscreen images.
- 146/148 union maps lack loading-screen art.
- IW4L handles missing loadscreens gracefully (solid color background, not a failure).

## Path split

- Clean MW2: `F:\SteamLibrary\steamapps\common\Call of Duty Modern Warfare 2`
- G: usermaps: `G:\SteamLibrary\steamapps\common\Call of Duty Modern Warfare 2\usermaps`
- Plutonium iw5: `[local path]
- Do not merge folders on disk.
