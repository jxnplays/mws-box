# zone-scan

**Purpose:** List `zone\` / `usermaps\` map ids without launching the game.

## Method

1. For base maps: list files in `<game>\zone\` — each `.ff` or `.iwd` file is a map asset.
2. For usermaps: list folders in `<game>\usermaps\` — each folder is a map id.
3. For MW2 usermaps on G: — 97 folders found (see `projects\mws-and-box\notes\usermap-inventory.md`).

## Expected IO

- **Input:** Game install path.
- **Output:** List of map ids + asset files.

## Notes

- IW4L loads zones from the `zone\` directory. Usermaps are loaded from `usermaps\`.
- The `.arena` file in each usermap folder contains map metadata (name, author, etc.).
- No `.zone` files found in usermap folders — they may be generated at runtime or stored elsewhere.
