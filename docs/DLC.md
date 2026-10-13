# DLC workflow

Each additional title is developed on its own branch so work can land without risking the stable main branch.

## Rules

- `main` stays clean: latest upstream IW4L + project docs and branding only.
- Do not commit game-specific readers, converters, or integration code directly to `main`.
- Each title gets a branch named `dlc/<short-name>`.
- Merge into `main` only when the title is in a working, reviewable state and does not break the base client.

## Branch list

| Branch | Title |
| --- | --- |
| `dlc/cod3` | Call of Duty 3 |
| `dlc/cod4` | Call of Duty 4 |
| `dlc/waw` | World at War |
| `dlc/bo1` | Black Ops |
| `dlc/mw3` | Modern Warfare 3 |
| `dlc/bo2` | Black Ops 2 |
| `dlc/aw` | Advanced Warfare |
| `dlc/codo` | Call of Duty Online |
| `dlc/bo3` | Black Ops 3 |
| `dlc/iw` | Infinite Warfare |
| `dlc/nx1` | Future Warfare (NX1) |

## Starting work on a title

```bash
git checkout main
git pull
git checkout -b dlc/nx1   # or the title you are working on
# ... make changes ...
git push -u origin dlc/nx1
```

Open a pull request into `main` when ready. Keep the branch rebased on `main` so upstream IW4L updates stay easy to pull in.

## Upstream updates

```bash
git checkout main
git fetch upstream
git merge upstream/master
git push origin main
```

Then rebase or merge `main` into active `dlc/*` branches as needed.
