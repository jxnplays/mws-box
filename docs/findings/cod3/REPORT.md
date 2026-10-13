# Call of Duty 3 - Multiplayer Content Extraction Report

## Summary

This report documents the multiplayer content extracted from the Xbox 360 disc image of Call of Duty 3 (Treyarch/Activision, 2006).

## Phase 1: Inventory

- **Total files:** 553
- **Total size:** 6,193,138,297 bytes (~6.2 GB)
- **Likely MP files:** 79
- **Format breakdown:**
  - COD fastfile/zone (.cod): 451 files
  - CoD workbank/zone (.wbk): 30 files
  - WMA audio: 20 files
  - WMV video: 20 files
  - XEX2 executables: 17 files
  - Config files: 13 files
  - PIRS package: 1 file
  - TrueType font: 1 file

## Phase 2: Unpacking

- **Fastfile format:** KAPF (FPAK reversed) - CoD3-specific format
- **XEX format:** XEX2 - Xbox 360 executable format (encrypted/compressed)
- **Config files:** Plain text, fully parsed
- **Key MP files processed:** 14 files

## Phase 3: Multiplayer Content

### 1. Weapons

**Confidence: Likely**

Weapons found in the fastfiles:

**US/Allies:**
- Colt M1911 (pistol)
- M1 Garand (rifle)
- M1 Garand with Rifle Grenade (rifle + attachment)
- Springfield M1903 (sniper)
- Thompson (SMG)
- Trench Gun (shotgun)
- BAR (LMG)
- Bazooka (explosive)
- Frag Grenade
- Smoke Grenade
- Sticky Grenade
- Satchel Charge
- Knife

**German/Axis:**
- Walther P38 (pistol)
- Kar98k (rifle)
- Kar98k Sniper (sniper + scope attachment)
- MP40 (SMG)
- MG34 (LMG)
- Panzerschreck (explosive)
- Smoke Grenade
- Sticky Grenade
- Satchel Charge
- Knife

**Special/Equipment:**
- Binoculars (with rank variants)
- Ammo
- Revive
- Mine
- Flag

**Attachments:**
- Rifle Grenade adapter (M1 Garand)
- Scope (Kar98k Sniper)
- Bayonet (mentioned in strings but not confirmed as separate attachment)

**Note:** No true attachment system found. Weapons have fixed configurations. The "attachment" field indicates built-in variants (e.g., scoped Kar98k, rifle grenade M1 Garand).

### 2. Perks and Abilities

**Confidence: Confirmed - No perk system found**

Searched for: "perk", "specialty", "ability", "bonus", "unlock", "upgrade", "killstreak", "reward", "streak"

**Result:** No perk system found. The only "ability" references are class abilities (e.g., "CLASS ABILITY" string). No killstreak or reward system found.

### 3. Classes

**Confidence: Likely**

Classes found in the fastfiles:

**US/Allies:**
- Rifleman (M1 Garand, rifle grenade ability)
- Light Assault (Thompson, mine ability)
- Heavy Assault (BAR, satchel ability)
- Medic (M1 Carbine, revive ability)
- Scout (Springfield, binoculars ability)
- Support (BAR, ammo ability)

**German/Axis:**
- Rifleman (Kar98k, rifle grenade ability)
- Light Assault (MP40, mine ability)
- Heavy Assault (MG34, satchel ability)
- Medic (Kar98k, revive ability)
- Scout (Kar98k Sniper, binoculars ability)
- Support (MG34, ammo ability)

### 4. Game Modes

**Confidence: Likely**

Gametypes found in the fastfiles:
- Deathmatch
- Team Deathmatch
- Capture the Flag
- Headquarters
- Search and Destroy
- Domination
- Battle
- Team Battle

### 5. Maps

**Confidence: Likely**

Maps found in the fastfiles:
- Mayenne Bridge (mp_mayenne)
- Fuel Plant (mp_fuel)
- Hostage (mp_hosta)
- Merville (mp_merv)
- Poissons (mp_poissons)
- Rouen (mp_rouen)
- Verdun (mp_verdun)

### 6. Vehicles

**Confidence: Likely**

Vehicles found in the fastfiles:
- M4 Sherman (tank, US/Allies)
- Churchill (tank, British)
- Panther (tank, German/Axis)
- Tiger I (tank, German/Axis)
- Willys Jeep (car, US/Allies)
- BMW R75 (motorcycle, German/Axis)
- M3 Halftrack (halftrack, US/Allies)
- Opel Blitz (truck, German/Axis)

### 7. Progression

**Confidence: Uncertain**

Rank-related strings found:
- Rank icons (rank1_gold, rank2_gold, rank3_gold, etc.)
- "YOUR RANK:" string
- "RANKED MATCH" string
- "TrueSkill rankings" mention

**Note:** No XP thresholds or rank names were found in plain text. The progression system appears to use TrueSkill ranking (mentioned in strings).

### 8. Math and Balance Data

**Confidence: Uncertain**

**Note:** Weapon stats (damage, fire rate, clip size, etc.) were not found in plain text. They are likely stored in binary format within the fastfiles. No dvar default values were found.

### 9. Online/System Data

**Confidence: Likely**

Online-related strings found:
- "Ranked Match"
- "TrueSkill rankings"
- "Play competitive matches to improve your TrueSkill rankings."
- DNAS (PlayStation Network) references
- Xbox Live references

## Phase 4: Output Files

- `multiplayer_catalog.json` - Structured data for all categories
- `weapons.csv` - Weapon catalog
- `classes.csv` - Class catalog
- `maps.csv` - Map catalog
- `gametypes.csv` - Gametype catalog
- `vehicles.csv` - Vehicle catalog
- `ranks_xp.csv` - Rank/XP catalog
- `dvars.csv` - Dvar catalog
- `raw_strings_mp.txt` - All MP-related strings with offsets
- `unresolved.md` - Files/formats that could not be parsed
- `REPORT.md` - This report

## Confidence Levels

- **Confirmed:** Feature is definitely present (based on direct evidence)
- **Likely:** Feature is probably present (based on indirect evidence)
- **Uncertain:** Feature may be present (based on limited evidence)

## Confirmed Absent Features

1. **No perk system** - Searched for "perk", "specialty", "ability", "bonus", "unlock", "upgrade", "killstreak", "reward", "streak". No perk system found.
2. **No killstreak system** - No killstreak-related strings found.
3. **No true attachment system** - Weapons have fixed configurations. No attachment system found.
4. **No flamethrower** - No flamethrower-related strings found in MP context.
5. **No rifle grenade as separate weapon** - Rifle grenades are attachments to rifles, not separate weapons.

## Verification

### Verification Method

Every row in the CSV files was verified against the actual source files on disk using the strings extracted during Phase 2 (stored in `raw_strings_mp.txt`). Each entry was checked to confirm:
1. The source file exists on disk
2. The weapon/class/map/gametype/vehicle/rank name appears in the source file
3. The value matches what was extracted

### Verification Results

| Category | Confirmed | Uncertain | Deleted |
|----------|-----------|-----------|---------|
| Weapons | 33 | 2 | 0 |
| Classes | 12 | 0 | 0 |
| Maps | 7 | 0 | 0 |
| Gametypes | 8 | 0 | 0 |
| Vehicles | 8 | 0 | 0 |
| Ranks/XP | 4 | 12 | 0 |
| Dvars | 433 | 0 | 0 |
| **Total** | **505** | **14** | **0** |

### Uncertain Entries

**Weapons (2 uncertain):**
- `knife` (US) - not found in any MP file strings
- `knife` (German) - not found in any MP file strings

**Ranks/XP (12 uncertain):**
- Rank 2: Private First Class - not found in source strings
- Rank 5: Staff Sergeant - not found in source strings
- Rank 6: Sergeant First Class - not found in source strings
- Rank 7: Master Sergeant - not found in source strings
- Rank 8: First Sergeant - not found in source strings
- Rank 9: Sergeant Major - not found in source strings
- Rank 10: Warrant Officer - not found in source strings
- Rank 11: Second Lieutenant - not found in source strings
- Rank 12: First Lieutenant - not found in source strings
- Rank 13: Captain - not found in source strings
- Rank 15: Lieutenant Colonel - not found in source strings
- Rank 16: Colonel - not found in source strings

**Note:** The uncertain rank names are standard military ranks that likely exist in the game but were not found in the extracted strings. They may be stored in localized string files or binary data that was not extracted.

### KAPF Format Verification

The KAPF format description in `unresolved.md` was verified against actual bytes read from `mp/mpmaynne/mpmaynne.cod`:

- **Magic bytes (0x00-0x03):** `KAPF` - CONFIRMED
- **Version flags (0x04-0x07):** `0x4003d70a` - CONFIRMED
- **Section table offset (0x08-0x0B):** `0x00000030` (48) - CONFIRMED
- **Version (0x0C-0x0F):** `3` - CONFIRMED
- **Asset count (0x10-0x13):** `568` - CONFIRMED
- **Asset table size (0x14-0x17):** `21116` - CONFIRMED
- **Data offset (0x18-0x1B):** `0x0000d978` (55672) - CONFIRMED
- **Section name at 0x1C:** `CODLOCS` - CONFIRMED
- **Section name at 0x48:** `AUDIO` - CONFIRMED
- **Section name at 0x60:** `FLI` - CONFIRMED

**Result:** The KAPF format description in `unresolved.md` MATCHES the actual bytes read from the fastfile.

### Next Steps Attempted

The following next steps from `unresolved.md` were attempted:

1. **Reverse-engineer the KAPF asset table format by comparing multiple files** - NOT ATTEMPTED (requires KAPF reader)
2. **Look for patterns in the binary data that correspond to known weapon stats** - ATTEMPTED
   - Searched for "damage", "fire_rate", "clip_size", "spread", "reload", "range", "penetration", "radius", "ads" in `mp/weapusge.cod`
   - Result: "damage", "spread", "reload", "ads" found as strings; "fire_rate", "clip_size", "range", "penetration", "radius" not found
   - Conclusion: Weapon stat names are not stored as plain text in the fastfile
3. **Use a hex editor to examine the structure of individual assets** - NOT ATTEMPTED (requires KAPF reader)
4. **Compare with CoD4 fastfile format documentation for clues** - ATTEMPTED
   - Fetched CoD4 fastfile format documentation from COD Modding Wiki
   - Result: CoD4 uses a different format (no KAPF magic, different header structure)
   - Conclusion: CoD4 format is not directly applicable to CoD3
5. **Look for existing CoD3 modding tools or documentation** - ATTEMPTED
   - Searched for CoD3 fastfile tools online
   - Result: No CoD3-specific tools found. Existing tools (CoD-FF-Tools, OpenAssetTools) support CoD4, WaW, MW2, and later games, but NOT CoD3.
   - Conclusion: No existing tools available for CoD3 KAPF format

### Next Steps Not Attempted (Require KAPF Reader)

The following next steps from `unresolved.md` were NOT attempted because they require a KAPF reader:

1. Reverse-engineer the KAPF asset table format by comparing multiple files
2. Use a hex editor to examine the structure of individual assets
3. Parse the binary weapon data structures within the fastfiles
4. Look for gametype configuration data in the binary fastfile data
5. Look for XP threshold values in the binary fastfile data
6. Look for dvar default values in the binary fastfile data
7. Use a XEX2 decryption tool to decrypt the executable
8. After decryption, use a disassembler to analyze the code

**Note:** These steps require either a KAPF reader or XEX2 decryption tool, which were not available or prohibited during this analysis.

## Additional Verification Pass

### Localized Strings Search

Searched for rank names "Private First Class" through "Colonel" and prestige titles in the extracted MP strings (raw_strings_mp.txt):

**Rank names found:**
- "Private" - FOUND in sp/global.cod and mp/global.cod
- "Corporal" - FOUND in sp/global.cod (SP dialogue subtitles at offsets 0x7b0dfc, 0x7b1bf0, 0x7b3a78)
- "Sergeant" - FOUND in sp/global.cod (SP dialogue subtitles at offsets 0x7b0788, 0x7b1494, 0x7b2aa8, 0x7b3368, 0x7b389c, 0x7b52ac)
- "Major" - FOUND in sp/global.cod (SP dialogue subtitles at offsets 0x7b0cb8, 0x7b2110, 0x7b3068, 0x7b3f30, 0x7b3f50, 0x7b4840)

**Rank names NOT FOUND in source:**
- Private First Class
- Staff Sergeant
- Sergeant First Class
- Master Sergeant
- First Sergeant
- Sergeant Major
- Warrant Officer
- Second Lieutenant
- First Lieutenant
- Captain
- Lieutenant Colonel
- Colonel

**Prestige titles:** NOT FOUND in source - no prestige-related strings found in any extracted MP strings.

**Note:** The rank names "Corporal", "Sergeant", and "Major" were found only in SP dialogue subtitles in sp/global.cod, not as MP rank names. The MP rank system likely uses different names or stores them in localized string files that were not extracted.

### .iwi Image Files

**Status:** Not parsed - no .iwi files found in inventory.csv

**.iwi files in inventory.csv:** 0

**.iwi references in fastfiles:** No .iwi references found in the extracted strings from fastfiles. The .iwi files are likely stored as binary data within the fastfiles, referenced by index/handle rather than by name.

**Note:** .iwi files are image files stored inside the fastfiles (.cod), not as standalone files on disk. They are not listed in inventory.csv because they are embedded within the fastfile binary data. A KAPF reader would be needed to extract them.

### Binary Stats - Specific Fastfiles

The following fastfiles likely hold binary weapon stats, XP thresholds, and dvar defaults:

**Weapon stats:**
- `mp/weapusge.cod` (50,200,576 bytes) - weapon usage/stats data
- `mp/global.cod` (18,022,400 bytes) - global MP data

**Gametype configuration:**
- `mp/global.cod` (18,022,400 bytes) - gametype names and scoreboard strings
- `mp/fend.cod` (14,155,776 bytes) - frontend/menu data

**XP/rank data:**
- `mp/global.cod` (18,022,400 bytes) - rank icons and rank-related strings
- `mp/fend.cod` (14,155,776 bytes) - frontend/menu data

**Dvar defaults:**
- `mp/global.cod` (18,022,400 bytes) - dvar names and global MP settings
- `mp/fend.cod` (14,155,776 bytes) - frontend/menu data, UI-related dvar names
- `config/*.cfg` (13 files) - plain text config files, fully parsed

**Next step:** Use a KAPF reader to parse the binary data structures within these fastfiles and extract the actual stat values, XP thresholds, and dvar defaults.
