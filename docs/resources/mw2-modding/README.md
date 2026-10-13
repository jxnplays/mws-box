# MW2 Modding — Resource Notes

## Engine

- IW4 engine (IW4x lineage)
- IW4L reads MW2 zones natively via `fastfile_iw4`
- Assets go through `asset_iw4` IR

## Install locations

- Clean MW2: `[local path] of Duty Modern Warfare 2`
- Usermaps: `[local path] of Duty Modern Warfare 2\usermaps` (97 maps)

## Zone structure

- `zone\` — Fastfile assets (`.ff`, `.iwd`)
- `usermaps\` — User-created maps (each folder = one map)
- `.arena` — Map settings/UI data (present in all usermaps)
- `.iwd` — Image asset archives (present in most usermaps)

## Loading screens

- Only 1 of 97 usermaps has a loadscreen image
- This is a known blocker — see `projects\mws-and-box\notes\usermap-inventory.md`
