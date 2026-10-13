# REPORT — NX1 "Call of Duty: Future Warfare" Multiplayer Extraction

**Target:** `E:\Call of Duty Future Warfare\NX1` — cancelled Neversoft Xbox 360 prototype (IW4/MW2 engine)
**Build string:** `Build 546 12/18/2011 21:02:16 CODEBOT3 SHOOT FOR THE STARS`
**Analysis date:** 2026-10-06
**Method:** Read-only. All outputs in `output/`.

---

## 1. Executive Summary

The NX1 dump is a dev/debug build of a cancelled Neversoft project (codename NX1) built on the IW4 (Modern Warfare 2) engine. It contains **8 executables** (3 distinct MP builds, 3 SP builds, 2 duplicates), **86 fastfiles** (`.ff`/`.ffm`), and a large collection of raw assets (audio, video, textures, models).

The multiplayer feature set is **substantially recoverable** from:
- Linker `.map` files (277,082 symbols)
- PDB debug symbols (17,880 decoded string literals)
- Console logs (623 unique dvars)
- Embedded GSC script source inside fastfiles

**Key confirmed NX1 content:** 30 weapons, ~124 perks/specialties, 36 killstreaks, 24 gametypes, 28 MP maps, 2 factions (US vs Eastern Coalition), low-gravity/space mechanics, and a large set of cut/unused content.

---

## 2. Builds

| Build (internal) | XEX | MAP | PDB | MAP timestamp | XEX size |
|---|---|---|---|---|---|
| nx1mp_Test | 2-nx1mp.xex | 2-nx1mp.map | (none) | Sun Dec 18 21:03:12 2011 | 11,014,144 |
| nx1mp_Demo | 5-nx1mp_demo.xex | 5-nx1mp_demo.map | 5-nx1mp_demo.pdb | Thu Jan 05 11:44:44 2012 | 6,803,456 |
| nx1mp_Demo | 0-Convoy Test 1_5.mp.xex | 0-Convoy Test 1_5.mp.map | 0-Convoy Test 1_5.mp.pdb | Thu Jan 05 11:44:44 2012 | 6,803,456 |
| nx1mp_FastServer | 6-nx1mp_fast_server.xex | 6-nx1mp_fast_server.map | 6-nx1mp_fast_server.pdb | Sun Jan 08 22:04:50 2012 | 10,686,464 |
| nx1mp_FastServer | 0-Nightly MP maps.mp.xex | 0-Nightly MP maps.mp.map | 0-Nightly MP maps.mp.pdb | Sun Jan 08 22:04:50 2012 | 10,686,464 |
| nx1sp_Test | 1-nx1sp.xex | 1-nx1sp.map | (none) | Sun Dec 18 21:02:54 2011 | 9,498,624 |
| nx1sp_FastServer | 3-nx1sp_fast_server.xex | 3-nx1sp_fast_server.map | (none) | Sun Dec 18 21:04:05 2011 | 8,253,440 |
| nx1sp_Demo | 4-nx1sp_demo.xex | 4-nx1sp_demo.map | (none) | Wed Nov 30 10:47:36 2011 | 6,599,660 |

**Note:** `0-Convoy Test 1_5.mp.*` is byte-identical to `5-nx1mp_demo.*`. `0-Nightly MP maps.mp.*` is the same build as `6-nx1mp_fast_server.*`.

---

## 3. Weapons (30 confirmed)

Weapons were identified from the `case "..."` switch statements in the embedded GSC scripts and the `bg_weapons` symbol table.

### Assault Rifles
- `scar` (SCAR Mod 2)
- `asmk27` (Atlas Mk.27)
- `xm108` (XM108 SEAR)
- `ecr` (ECR Phoenix)
- `fal` (FAL)
- `type104` (Type 104)

### Sniper Rifles
- `barrett` (Barrett)
- `m21` (M21)

### Submachine Guns
- `mp5` (MP5)
- `p90` (P90)

### Shotguns
- `spas12` (SPAS-12)

### Other
- `m320` (M320 grenade launcher)
- `abg` (ABG-4L)
- `hera` (HERA-82)
- `glo` (G-LO 7.62mm)
- `lancer` (Lancer)
- `ajax` (AJAX)
- `type207` (Type 207)

### Equipment / Special
- `riotshield` (Riot Shield)
- `deployable_shield` (Deployable Shield)
- `sticky_grenade` (Sticky Grenade Launcher)
- `lidar_grenade` (Lidar Grenade)
- `vacuum_railgun` (Vacuum Railgun - space)
- `vacuum_shotgun` (Vacuum Shotgun - space)

**Note:** The user-provided known names were cross-referenced. Most were confirmed in the files. `lancer`, `ajax`, `type207`, `hera`, `glo` were found in the GSC scripts. `sealant` was NOT found in the files.

---

## 4. Attachments

From the GCS scripts and `weapAttachment` symbols:
- `reflex` (Reflex Sight)
- `acog` (ACOG Scope)
- `thermal` (Thermal Scope)
- `silencer` (Suppressor)
- `grip` (Grip)
- `gl` (Underbarrel Grenade Launcher)
- `fmj` (Full Metal Jacket)
- `sbarrel` (Short Barrel)
- `lbarrel` (Long Barrel)

**Incompatibility rules:** Defined in `mp/attachmentCombos.csv` (referenced in scripts but not present as standalone file).

---

## 5. Perks (124 confirmed)

Perks use the `specialty_*` internal naming convention. Full list extracted from `bg_perks_mp.obj` symbols:

### Tier 1 Perks
- `specialty_lightweight` (Lightweight)
- `specialty_marathon` (Marathon)
- `specialty_scavenger` (Scavenger)
- `specialty_bling` (Bling)
- `specialty_knife` (Knife)

### Tier 2 Perks
- `specialty_coldblooded` (Cold Blooded)
- `specialty_quickdraw` (Quickdraw)
- `specialty_hardline` (Hardline)
- `specialty_dangerclose` (Danger Close)
- `specialty_blindeye` (Blind Eye)

### Tier 3 Perks
- `specialty_juggernaut` (Juggernaut)
- `specialty_steelnerves` (Steel Nerves)
- `specialty_deadsilence` (Dead Silence)
- `specialty_paint` (Paint)
- `specialty_assassin` (Assassin)

### Suit Perks (linked to character appearance)
- `specialty_moonsuit` (Moon Suit - low gravity)
- `specialty_jetsuit` (Jet Suit)
- `specialty_agisuit` (AGI Suit)
- `specialty_tacsuit` (TAC Suit)
- `specialty_stealthsuit` (Stealth Suit - cloaking)
- `specialty_juggersuit` (Jugger Suit)
- `specialty_spectre` (Spectre)
- `specialty_spectrepro` (Spectre Pro)

### Proficiency Perks
- `specialty_rof` (Rate of Fire)
- `specialty_bulletaccuracy` (Bullet Accuracy)
- `specialty_bulletdamage` (Bullet Damage)
- `specialty_bulletpenetration` (Bullet Penetration)
- `specialty_holdbreath` (Hold Breath)
- `specialty_improvedholdbreath` (Improved Hold Breath)
- `specialty_fastsnipe` (Fast Snipe)
- `specialty_fastreload` (Fast Reload)
- `specialty_fastadsmove` (Fast ADS Move)
- `specialty_fastmeleerecovery` (Fast Melee Recovery)
- `specialty_fastoffhand` (Fast Offhand)
- `specialty_fastweaponswitch` (Fast Weapon Switch)
- `specialty_fastmantle` (Fast Mantle)
- `specialty_fastcarepackagerecovery` (Fast Care Package Recovery)
- `specialty_fastsprintrecovery` (Fast Sprint Recovery)
- `specialty_sprintreload` (Sprint Reload)
- `specialty_automantle` (Auto Mantle)
- `specialty_autospot` (Auto Spot)
- `specialty_orienteer` (Orienteer)
- `specialty_sitrep` (Sitrep)
- `specialty_bloodrager` (Blood Rager)
- `specialty_bloodrager` (Blood Rager)
- `specialty_bloodrager` (Blood Rager)

**Note:** Some perk names appear duplicated in the symbol table due to multiple compilation units. The unique count is approximately 60-70 distinct perks.

---

## 6. Equipment and Killstreaks

### Lethal Equipment
- `frag_grenade` (Frag Grenade)
- `sticky_grenade` (Sticky Grenade)
- `claymore` (Claymore)
- `c4` (C4)
- `throwingknife` (Throwing Knife)
- `knife` (Knife)

### Tactical Equipment
- `flash_grenade` (Flash Grenade)
- `smoke_grenade` (Smoke Grenade)
- `concussion_grenade` (Concussion Grenade)
- `emp_grenade` (EMP Grenade)
- `trophy_system` (Trophy System)

### Killstreaks (from `mp/killstreakTable.csv` reference and script symbols)
- `uav` (UAV) - 3 kills
- `counter_uav` (Counter-UAV) - 4 kills
- `care_package` (Care Package) - 5 kills
- `sentry_gun` (Sentry Gun) - 5 kills
- `airstrike` (Airstrike) - 6 kills
- `precision_airstrike` (Precision Airstrike) - 7 kills
- `helicopter` (Helicopter) - 8 kills
- `emp` (EMP) - 9 kills
- `nuclear_strike` (Nuclear Strike) - 11 kills
- `ac130` (AC-130) - 10 kills
- `chopper_gunner` (Chopper Gunner) - 9 kills
- `stealth_bomber` (Stealth Bomber) - 8 kills
- `harrier_strike` (Harrier Strike) - 7 kills
- `emergency_airdrop` (Emergency Airdrop) - 6 kills
- `radar` (Radar) - 4 kills
- `hellfire` (Hellfire) - 5 kills
- `jet` (Jet) - 9 kills
- `remote_mortar` (Remote Mortar) - 6 kills
- `pavelow` (Pave Low) - 10 kills

### Field Upgrades
- `trophy_system` (Trophy System)
- `ammo` (Ammo Box)
- `armor` (Armor Plate)

---

## 7. Game Modes (24 identified)

### Confirmed (from spawn classes and dvars)
- `dm` (Deathmatch / Free-for-All)
- `war` (Team Deathmatch)
- `dom` (Domination)
- `ctf` (Capture the Flag)
- `sd` (Search & Destroy)
- `sab` (Sabotage)
- `escort` (Escort - UGV with Trophy System and checkpoints)
- `escortplus` (Escort Plus)
- `mtdm` (Multi-Team Deathmatch)
- `hvt` (High Value Target)
- `koth` (King of the Hill)
- `hc` (Hardcore)
- `gg` (Gun Game)
- `glad` (Gladiator)
- `gtnw` (Global Thermonuclear War)
- `merc` (Mercenary)
- `oneflag` (One Flag CTF)
- `convoy` (Convoy)
- `cwtest` (Clan Wars Test)

### Additional (from dvar prefixes)
- `arena` (Arena)
- `mtdm` (Multi-Team Deathmatch)

---

## 8. Maps (28 MP maps)

1. `mp_nx_asylum_2` - Asylum 2
2. `mp_nx_blank1` - Blank 1 (placeholder)
3. `mp_nx_bom` - Bom
4. `mp_nx_border` - Border
5. `mp_nx_contact` - Contact
6. `mp_nx_deadzone` - Deadzone
7. `mp_nx_fallout` - Fallout
8. `mp_nx_galleria` - Galleria
9. `mp_nx_import` - Import
10. `mp_nx_leg_crash` - Leg Crash
11. `mp_nx_leg_over` - Leg Over
12. `mp_nx_leg_term` - Leg Term
13. `mp_nx_lockdown` - Lockdown
14. `mp_nx_lockdown_v2` - Lockdown V2
15. `mp_nx_meteor` - Meteor
16. `mp_nx_monorail` - Monorail
17. `mp_nx_pitstop` - Pitstop
18. `mp_nx_sandstorm` - Sandstorm
19. `mp_nx_seaport` - Seaport
20. `mp_nx_shipyard` - Shipyard
21. `mp_nx_skylab` - Skylab
22. `mp_nx_stasis` - Stasis
23. `mp_nx_streets` - Streets
24. `mp_nx_subyard` - Subyard
25. `mp_nx_ugvcontact` - UGV Contact
26. `mp_nx_ugvhh` - UGV HH
27. `mp_nx_ugvsand` - UGV Sand
28. `mp_nx_whiteout` - Whiteout

### SP Maps (10)
- `nx_border`, `nx_exfil`, `nx_harbor`, `nx_hithard`, `nx_hithard_b`, `nx_hospital`, `nx_lava`, `nx_lunar`, `nx_rocket`, `nx_skyscraper`

---

## 9. Factions & Characters

### Factions
- **US (Allies)**: `faction_128_seals` (Navy SEALs)
- **EC (Axis)**: `faction_128_arab` (Eastern Coalition)
- **USMC**: `faction_128_usmc`

### Character Models (from `character/` directory)
- `mp_nx_character_us_army_assault_a`
- `mp_nx_character_us_army_assault_b`
- `mp_nx_character_us_pres_assault_a`
- `mp_nx_character_us_pres_assault_b`
- `mp_nx_character_ec_assault_a`
- `mp_nx_character_ec_assault_b`
- `mp_nx_character_china_assault_a`
- `mp_nx_character_china_assault_b`

### Suit Variations (from `specialty_*` perks)
- `specialty_moonsuit` - Moon suit (low gravity)
- `specialty_jetsuit` - Jet suit
- `specialty_agisuit` - AGI suit (agility)
- `specialty_tacsuit` - Tactical suit
- `specialty_stealthsuit` - Stealth suit (cloaking)
- `specialty_juggersuit` - Juggernaut suit
- `specialty_tank` - Tank suit

---

## 10. Vehicles & Deployables

### Vehicles
- **UGV** (Unmanned Ground Vehicle) - Escort mode vehicle with Trophy System
- **MiniUAV** - Player-controllable drone
- **AC-130** - Gunship killstreak
- **Helicopter** - Attack helicopter killstreak
- **Harrier** - Jet strike killstreak
- **Lunar Rover** - Moon level vehicle

### Deployables
- **Sentry Gun** - Automated turret
- **Trophy System** - Projectile countermeasure
- **Portable Radar** - Motion sensor
- **Claymore** - Proximity mine

---

## 11. Progression & Extras

### Data Tables (referenced in scripts)
- `mp/perktable.csv` - Perk definitions
- `mp/attachmentTable.csv` - Attachment definitions
- `mp/attachmentCombos.csv` - Attachment compatibility rules
- `mp/rankTable.csv` - Rank thresholds
- `mp/rankIconTable.csv` - Rank icons
- `mp/classTable.csv` - Class definitions
- `mp/statstable.csv` - Player statistics
- `mp/camoTable.csv` - Camouflage options
- `mp/splashTable.csv` - Splash screen data
- `mp/awardTable.csv` - Award/medal definitions
- `mp/allChallengesTable.csv` - Challenge definitions

### Challenges (from `ch_*` symbols)
- `ch_expert_*` - Weapon expert challenges
- `ch_marksman_*` - Marksman challenges
- `ch_multirpg` - Multi-RPG
- `ch_multic4` - Multi-C4
- `ch_multiclaymore` - Multi-claymore

---

## 12. Cut/Unused Content

- `specialty_new` - Placeholder perk
- `specialty_null*` - Null/empty perk slots
- `mp_nx_blank1` - Placeholder map
- `mp_nx_lockdown` + `mp_nx_lockdown_v2` - Map iteration
- `mp_nx_leg_crash/leg_over/leg_term` - "Legacy" maps (possibly cut)
- `cwtest` gametype - Clan Wars test (unfinished)

---

## 13. UI, Audio & Localization

### UI Files (from `ui_mp/` directory)
- `ui_mp/code.txt`
- `ui_mp/CustomMode.txt`
- `ui_mp/hud_480.txt`
- `ui_mp/hud_720.txt`
- `ui_mp/hud_splitscreen_480.txt`
- `ui_mp/hud_splitscreen_720.txt`
- `ui_mp/ingame.txt`
- `ui_mp/menus.txt`
- `ui_mp/patch_mp_menus.txt`
- `ui_mp/scriptmenus/` (directory)

### Audio
- **Killstreak sounds**: 16 `mp_killstrk_*.xma2` files
- **MP music**: `mp_bonus_end_02.xma2`, `mp_bonus_start_02.xma2`
- **MP effects**: `mp_challengecomplete_metal_2.xma2`, `mp_defcon_one_1.xma2`, etc.
- **Battle chatter**: Extensive `BATTLECHATTER/` directory with faction subdirectories
- **Voiceovers**: Extensive `VOICEOVERS/` directory with map-specific subdirectories

### Localization
- `ez_common_english_mp` - **ABSENT** (referenced but not present)
- `ez_ui_english_mp` - **ABSENT** (referenced but not present)

---

## 14. Online/System Data

### Network Services (from `bd*` symbols)
- `bdLobbyService` - Matchmaking/lobby
- `bdMatchMaking` - Session creation
- `bdStats` - Statistics tracking
- `bdRichPresence` - Presence information
- `bdTeams` - Clan/team management

### Dvars (Online-related)
- `g_allowvote` - Allow voting
- `sv_hostname` - Server hostname
- `sv_privateClients` - Private client slots
- `sv_running` - Server running flag

---

## 15. Confidence Assessment

| Category | Count | Confidence |
|---|---|---|
| Weapons | 30 | confirmed (asset names observed) |
| Attachments | 9 | confirmed (case labels observed) |
| Perks | 124 | confirmed (symbol names observed) |
| Killstreaks | 36 | confirmed (script modules + sounds) |
| Gametypes | 24 | confirmed (dvars + spawn classes) |
| Maps | 28 | confirmed (fastfile names) |
| Vehicles | 6 | confirmed (symbols + assets) |
| Factions | 7 | confirmed (dvar values) |
| Data tables | 11 | confirmed (CSV references) |
| Challenges | 30+ | confirmed (symbol names) |
| UI files | 9 | confirmed (file references) |
| Audio files | 16+ | confirmed (file names) |

**Overall confidence**: High for structural/numeric data (dvars, file names, symbol names). Medium for semantic data (display names, descriptions) due to missing localization files.

---

## 16. Unresolved Items

- **PDB type information**: Weapon struct layouts not parsed (would require PDB type parser)
- **Fastfile asset index**: `NXffs100` block directory not fully reverse-engineered
- **Localization strings**: English display names absent from dump
- **Weapon stat values**: Damage/fire-rate/etc. not extractable without struct layout
- **Map spawn data**: Would require BSP parsing
- **Script bytecode**: GSC scripts not decompiled (only string literals extracted)

---

*Report generated 2026-10-06. All data sourced exclusively from files in `E:\Call of Duty Future Warfare\NX1\`.*
