# BO1 Modding — Resource Notes

## Engine

- T5 engine (Black Ops 1)
- IW4L reads BO1 via `fastfile_t5` crate
- Maps into same `asset_iw4` IR as MW2/MW3

## Install location

- BO1: `[local path] of Duty Black Ops`

## Zone structure

- `zone\` — Fastfile assets
- T5 fastfiles are read by `fastfile_t5` crate
- BO1 maps must load and show loading-screen/lobby images (current product task)
