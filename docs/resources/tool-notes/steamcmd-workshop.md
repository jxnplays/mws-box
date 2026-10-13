# steamcmd-workshop

**Purpose:** Download GMod Workshop items via SteamCMD.
**GMod app id:** 4000

## Command

```
steamcmd +login anonymous +workshop_download_item 4000 <publishedfileid> +quit
```

## Expected IO

- **Input:** `publishedfileid` from a GMod Workshop URL.
- **Output:** Downloaded `.gma` and extracted files under `steamapps\workshop\content\4000\<publishedfileid>\`.

## Notes

- SteamCMD not installed on this machine. Download URL: https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip
- Do not install if it requires long interactive setup. Document and stop.
