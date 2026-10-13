# plutonium-scan

**Purpose:** Inventory Plutonium storage folders (read-only).
**Method:** Get-ChildItem only.

## Commands

```powershell
# List iw5 usermaps
Get-ChildItem "[local path] -Directory

# List iw5 mods
Get-ChildItem "[local path] -Directory

# List all storage folders
Get-ChildItem "[local path] -Directory
```

## Expected IO

- **Input:** Plutonium storage path.
- **Output:** Folder names + file counts.

## Notes

- Read-only. No edits, no deletes, no copies.
- Plutonium is a reference tree for mws&box — not a game client to install or run.
- See `projects\mws-and-box\notes\plutonium-iw5-usermap-inventory.md` for full inventory.
