# Parked-game findings — Call of Duty 3, Future Warfare, Ghosts

Opened 2026-10-06. Report slot only. Not a reader, not an allowlist, and not a task for the MW2 agent.

`FUTURE-WARFARE-INVENTORY.md` holds the 2026-10-04 image census. Do not copy it here.

## Where the data goes

Local dump, one folder per game. Do not write inside the Steam install.

```text
[local path]
[local path]
[local path]
```

Each folder gets `REPORT.md`, `unresolved.md`, `inventory.csv`, and the category csv files. Unpacked zones stay in that folder. They are not committed.

Brain copy, summary only: commit `REPORT.md` and `unresolved.md` under `findings/<game>/` in `jxnplays/mws-and-box-brain`, and paste the commit here. A chat message that lists perks is not a report.

## Rules

- Read only. Never modify the game folder. No commits to `jxnplays/mws-and-box`. No exe rebuild.
- One game per agent. Do not scan MW2, MW3, or Black Ops 1 in the same pass.
- Do not touch anti-cheat, DRM, or online play.
- Every value is tagged `observed` (file and offset), `documented` (named source and date), or `not in source`. Wiki numbers are not file numbers. If they disagree, record both and say which is which.
- Do not reuse an IW4 magic or header. Ghosts is IW6. Call of Duty 3 and Future Warfare are claimed extracted Xbox 360 discs until a file on disk says otherwise.
- A missing file stays missing.

## Call of Duty 3

- Status: no folder report yet.
- Path: pending, owner sends it.
- Dump: `[local path]
- Report: not in source

## Future Warfare

- Status: image census exists. Disc-tree report is not in this file yet.
- Path: pending, owner sends it.
- Dump: `[local path]
- Prior census: `FUTURE-WARFARE-INVENTORY.md`
- Report: not in source

## Ghosts

- Status: no folder report yet.
- Path: `[local path] of Duty Ghosts`
- Dump: `[local path]
- Engine claim: IW6. Not verified until the report cites a file.
- Report: not in source

## Review

Grok reviews a committed `REPORT.md` before any reader or menu row is proposed. A filled section is not permission to load the game.
