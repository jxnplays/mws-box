# Reverse-engineer queue

Opened 2026-10-07. This file is not an order for the client.

Lead and co-lead on `jxnplays/mws-and-box` do not open `findings/`. A finished chunk here does not unlock a menu row, a reader, or a crate.

## Loop

One agent, one game, one chunk. No second agent on the same QUEUE.md.

1. Pull `jxnplays/mws-and-box-brain`.
2. Open only `findings/<your-game>/QUEUE.md`.
3. Take the first chunk that is not `done`.
4. Read the install. Do not modify it. Do not edit `jxnplays/mws-and-box`. Do not rebuild an exe.
5. Append the result under that chunk: file path, byte range or name list, and one tag (`observed`, `documented`, or `not in source`). A number with no file is `not in source`.
6. Mark the chunk `done` and put the brain commit hash on it. Leave the next chunk unchecked.
7. Commit only your game's QUEUE.md and its REPORT.md. Stop. The next check-in is the next unchecked chunk. Do not wait for a new prompt.

If the install path is missing, mark the chunk `blocked` and stop. Do not guess a path.

## Who is already busy

Future Warfare has a live pass. Do not restart it. That agent finishes the open task, then takes chunk 1 in `findings/future-warfare/QUEUE.md`.

## Games

| Game | Queue | Client status |
|---|---|---|
| Modern Warfare 2 campaign / spec ops | findings/mw2/QUEUE.md | Parked. MP client is a different session. |
| Modern Warfare 3 spec ops / survival | findings/mw3/QUEUE.md | Parked. |
| Black Ops 1 campaign / zombies | findings/bo1/QUEUE.md | Parked. |
| Ghosts | findings/ghosts/QUEUE.md | Parked. |
| Infinite Warfare | findings/infinite-warfare/QUEUE.md | Parked. |
| Black Ops 2 | findings/bo2/QUEUE.md | Parked. |
| World at War | findings/waw/QUEUE.md | Parked. |
| Call of Duty 3 | findings/cod3/QUEUE.md | Parked. Path not sent. |
| Future Warfare | findings/future-warfare/QUEUE.md | Parked. Live pass finishes first. |
