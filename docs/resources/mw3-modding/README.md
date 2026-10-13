# MW3 Modding — Resource Notes

## Engine

- IW5 engine
- IW4L maps MW3 into `asset_iw4` IR via `fastfile_iw5`
- Same IR as MW2 — assets are shared where possible

## Install location

- MW3: `[local path] of Duty Modern Warfare 3`

## Zone structure

- `zone\` — Fastfile assets
- IW5 fastfiles are read by `fastfile_iw5` crate
- MW3 maps must load and show loading-screen/lobby images (current product task)
