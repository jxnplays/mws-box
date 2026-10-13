# Unresolved Files and Formats

## XEX Executables (default.xex, codmp_xenonf.xex)

**Status:** Could not be fully parsed

**Reason:** The XEX2 format executables appear to be encrypted or compressed. String extraction yielded very few readable strings (only 2 weapon-related strings found in codmp_xenonf.xex). The XEX2 header was partially parsed but the main executable data is not directly readable.

**Next steps:**
1. Use a XEX2 decryption tool (e.g., XEXTool, XeXDecrypt) to decrypt the executable
2. After decryption, use a disassembler (IDA Pro, Ghidra) to analyze the code
3. Look for weapon stat tables, gametype configurations, and class definitions in the decrypted code
4. Search for floating-point constants that represent damage values, fire rates, etc.

**Attempted:** No - requires XEX2 decryption tool

## KAPF Fastfile Format (.cod files)

**Status:** Partially parsed

**Reason:** The KAPF (FPAK reversed) fastfile format used by CoD3 is not fully documented. The header structure was identified but the asset table format is not completely understood. The format appears to use a section-based structure with sections like "CODLOCS", "AUDIO", "FLI", etc.

**What was extracted:**
- File headers (magic, version, asset counts)
- Asset names (strings within the fastfiles)
- Weapon names and file references
- Gametype names
- Class names
- Map names
- Vehicle names
- Rank names
- HUD/menu asset names

**What could not be extracted:**
- Weapon stat values (damage, fire rate, clip size, etc.) - these are likely stored in binary format within the fastfile
- Gametype configuration details (score limits, time limits, etc.)
- Class loadout details
- XP thresholds
- Dvar default values

**Next steps:**
1. Reverse-engineer the KAPF asset table format by comparing multiple files
2. Look for patterns in the binary data that correspond to known weapon stats
3. Use a hex editor to examine the structure of individual assets
4. Compare with CoD4 fastfile format documentation for clues
5. Look for existing CoD3 modding tools or documentation

**Attempted:**
- Step 2: Searched for weapon stat patterns in binary data. Found "damage", "spread", "reload", "ads" as strings in weapusge.cod, but not "fire_rate", "clip_size", "range", "penetration", "radius". Conclusion: Weapon stat names are not stored as plain text.
- Step 4: Compared with CoD4 fastfile format documentation. CoD4 uses a different format (no KAPF magic, different header structure). Not directly applicable to CoD3.
- Step 5: Searched for existing CoD3 modding tools. No CoD3-specific tools found. Existing tools support CoD4, WaW, MW2, and later games, but NOT CoD3.

**Not attempted (require KAPF reader):**
- Step 1: Reverse-engineer the KAPF asset table format
- Step 3: Use a hex editor to examine the structure of individual assets

## Weapon Stat Values

**Status:** Not found in plain text

**Reason:** Weapon statistics (damage, fire rate, clip size, reserve ammo, reload times, spread, recoil, ADS time, move speed modifiers, penetration, explosive radius) are likely stored in binary format within the fastfiles, not as plain text strings.

**What was found:**
- Weapon file names (w_ prefix)
- Weapon type classifications
- HUD icon names for weapons
- Animation file names for weapons
- Particle effect names for weapons

**Specific fastfiles that likely hold weapon stats:**
- `mp/weapusge.cod` (50,200,576 bytes) - weapon usage/stats data, contains weapon file references and animation names
- `mp/global.cod` (18,022,400 bytes) - global MP data, contains weapon names and HUD icons

**Next steps:**
1. Parse the binary weapon data structures within the fastfiles using a KAPF reader
2. Look for floating-point values that correspond to known weapon stats
3. Compare weapon file sizes to estimate the amount of data per weapon
4. Use a hex editor to examine the weapon data structure

**Attempted:** No - requires KAPF reader to parse binary weapon data structures

## Gametype Configuration Details

**Status:** Partially found

**Reason:** Gametype names were found in the fastfiles, but detailed configuration (score limits, time limits, spawn rules, win conditions) are likely stored in binary format or in script files that are embedded in the fastfiles.

**What was found:**
- Gametype names: Deathmatch, Team Deathmatch, Capture the Flag, Headquarters, Search and Destroy, Domination, Battle, Team Battle
- Gametype-related strings and icons
- Scoreboard-related strings

**Specific fastfiles that likely hold gametype configuration:**
- `mp/global.cod` (18,022,400 bytes) - contains gametype names and scoreboard strings
- `mp/fend.cod` (14,155,776 bytes) - frontend/menu data, may contain gametype settings

**Next steps:**
1. Look for gametype configuration data in the binary fastfile data using a KAPF reader
2. Search for script files (.gsc) within the fastfiles
3. Look for floating-point and integer values that correspond to score limits and time limits

**Attempted:** No - requires KAPF reader to parse binary gametype data

## XP and Rank Thresholds

**Status:** Not found in plain text

**Reason:** XP thresholds and rank names are likely stored in binary format or in localized string files within the fastfiles.

**What was found:**
- Rank icon names (rank1_gold, rank2_gold, rank3_gold, etc.)
- Rank-related strings ("YOUR RANK:", "RANKED MATCH", etc.)
- Leaderboard-related strings

**Rank name search results:**
- "Private" - FOUND in sp/global.cod and mp/global.cod
- "Private First Class" - NOT FOUND in source
- "Corporal" - FOUND in sp/global.cod (SP dialogue subtitles, not MP rank name)
- "Sergeant" - FOUND in sp/global.cod (SP dialogue subtitles, not MP rank name)
- "Staff Sergeant" - NOT FOUND in source
- "Sergeant First Class" - NOT FOUND in source
- "Master Sergeant" - NOT FOUND in source
- "First Sergeant" - NOT FOUND in source
- "Sergeant Major" - NOT FOUND in source
- "Warrant Officer" - NOT FOUND in source
- "Second Lieutenant" - NOT FOUND in source
- "First Lieutenant" - NOT FOUND in source
- "Captain" - NOT FOUND in source
- "Major" - FOUND in sp/global.cod (SP dialogue subtitles, not MP rank name)
- "Lieutenant Colonel" - NOT FOUND in source
- "Colonel" - NOT FOUND in source

**Prestige titles:** NOT FOUND in source - no prestige-related strings found in any extracted MP strings.

**Specific fastfiles that likely hold XP/rank data:**
- `mp/global.cod` (18,022,400 bytes) - contains rank icons and rank-related strings
- `mp/fend.cod` (14,155,776 bytes) - frontend/menu data, may contain rank display settings

**Next steps:**
1. Look for XP threshold values in the binary fastfile data using a KAPF reader
2. Search for localized string files within the fastfiles
3. Look for integer values that correspond to XP thresholds

**Attempted:** No - requires KAPF reader to parse binary XP/rank data

## Dvar Default Values

**Status:** Not found in plain text

**Reason:** Dvar default values are likely stored in binary format or in configuration files that are embedded in the fastfiles.

**What was found:**
- Dvar names (scr_*, g_*, player_*, cg_*, mp_*, sv_*, cl_*, ui_*)
- Configuration-related strings

**Specific fastfiles that likely hold dvar defaults:**
- `mp/global.cod` (18,022,400 bytes) - contains dvar names and global MP settings
- `mp/fend.cod` (14,155,776 bytes) - frontend/menu data, contains UI-related dvar names
- `config/*.cfg` (13 files) - plain text config files, fully parsed but may not contain all dvars

**Next steps:**
1. Look for dvar default values in the binary fastfile data using a KAPF reader
2. Search for configuration files within the fastfiles
3. Look for integer and floating-point values that correspond to dvar defaults

**Attempted:** No - requires KAPF reader to parse binary dvar data

## .iwi Image Files

**Status:** Not parsed

**Reason:** .iwi files are image files stored inside the fastfiles (.cod), not as standalone files on disk. They are not listed in inventory.csv because they are embedded within the fastfile binary data.

**What was found:**
- No .iwi files in inventory.csv (they are inside fastfiles, not standalone files)
- No .iwi references found in the extracted strings from fastfiles
- .iwi files are likely stored as binary data within the fastfiles, referenced by index/handle rather than by name

**Next steps:**
1. Parse the KAPF fastfile format to extract .iwi image data
2. Use a KAPF reader to identify and extract image assets
3. Convert .iwi files to standard image formats (PNG, TGA) for viewing

**Attempted:** No - requires KAPF reader to extract .iwi image data
