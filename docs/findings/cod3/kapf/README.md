# KAPF Reader for CoD3

A simple KAPF fastfile reader for Call of Duty 3 Xbox 360.

## Usage

```bash
python kapf_reader.py
```

## Output

The reader opens `mp/mpmaynne/mpmaynne.cod` and writes:

- `asset_names.txt` - List of asset names found in the fastfile
- `collision_chunks.txt` - Collision/brush chunk data (if found)
- `spawn_points.txt` - Spawn-point records (if found)
- `summary.json` - Summary of the fastfile structure

## Header Structure (verified)

- Magic: `KAPF` (bytes 0-3)
- Version flags: `0x4003d70a` (bytes 4-7)
- Section table offset: `0x00000030` (bytes 8-11)
- Version: `3` (bytes 12-15)
- Asset count: `568` (bytes 16-19)
- Asset table size: `21116` (bytes 20-23)
- Data offset: `0x0000d978` (bytes 24-27)
- Section name: `CODLOCS` (bytes 28-35)

## Sections Found

- `CODLOCS` at offset 0x00001c
- `AUDIO` at offset 0x000048
- `FLI` at offset 0x000060

## Limitations

- Does not parse the asset table format (not fully understood)
- Does not extract binary data structures
- Only reads what the header and section table expose
- If a section is not readable, writes the offset and first 64 bytes, then stops
