# Weapon Porting — Resource Notes

## Current state

- IW4L already pulls IW5/T5 weapon bundles in the match-load walk
- No additional weapon porting work needed for MW3/BO1

## Notes

- Weapons are loaded as part of the match-load walk in IW4L
- IW5 (MW3) and T5 (BO1) weapon assets are read alongside map assets
- Do not implement custom weapon loading — it already works
