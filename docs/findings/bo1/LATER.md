# BO1 Retail Folder Findings

Source folder: `[local path] of Duty Black Ops`

No usermaps, mods, plutonium, or t5m detected. Clean retail install.

Multiplayer only. Zombies out of scope.

## Retail MP Map Zones

| Map Stem | Zone File Read |
|----------|----------------|
| mp_array | zone\Common\mp_array.ff |
| mp_cairo | zone\Common\mp_cairo.ff |
| mp_cosmodrome | zone\Common\mp_cosmodrome.ff |
| mp_cracked | zone\Common\mp_cracked.ff |
| mp_crisis | zone\Common\mp_crisis.ff |
| mp_duga | zone\Common\mp_duga.ff |
| mp_firingrange | zone\Common\mp_firingrange.ff |
| mp_hanoi | zone\Common\mp_hanoi.ff |
| mp_havoc | zone\Common\mp_havoc.ff |
| mp_mountain | zone\Common\mp_mountain.ff |
| mp_nuked | zone\Common\mp_nuked.ff |
| mp_radiation | zone\Common\mp_radiation.ff |
| mp_russianbase | zone\Common\mp_russianbase.ff |
| mp_villa | zone\Common\mp_villa.ff |

## DLC Map Zones

| Map Stem | Zone File Read |
|----------|----------------|
| mp_area51 | zone\Common\mp_area51.ff |
| mp_berlinwall2 | zone\Common\mp_berlinwall2.ff |
| mp_discovery | zone\Common\mp_discovery.ff |
| mp_drivein | zone\Common\mp_drivein.ff |
| mp_golfcourse | zone\Common\mp_golfcourse.ff |
| mp_gridlock | zone\Common\mp_gridlock.ff |
| mp_hotel | zone\Common\mp_hotel.ff |
| mp_kowloon | zone\Common\mp_kowloon.ff |
| mp_outskirts | zone\Common\mp_outskirts.ff |
| mp_silo | zone\Common\mp_silo.ff |
| mp_stadium | zone\Common\mp_stadium.ff |
| mp_zoo | zone\Common\mp_zoo.ff |

Retail is 14 zones, DLC is 12 zones, 26 total. Every zone has a localization
companion at `zone\English\en_<stem>.ff`. The install ships the corrected stems
`mp_cairo`, `mp_golfcourse`, `mp_silo`, `mp_zoo`.

## Table Files

| Table | Path |
|-------|------|
| Weapon table | not in source |
| Attachment table | not in source |
| Perk table | not in source |
| Equipment / Lethal / Tactical table | not in source |
| Killstreak table | not in source |
| Camo table | not in source |
| Gametype scripts / gametype table | not in source |
| Create-a-class table | not in source |

No MP data table exists as a standalone file under the folder. All of them are
string-table assets compiled inside the `zone\Common\*.ff` fastfiles, so there is
no path to list for any row.

Verified read-only, no parser:

- A full file listing of the folder returns only `.ff`, `.iwd`, `.bik`, `.mp3`,
  `.tif`, `.bmp`, `.exe`, `.dll`, `.cab`, `.vdf`, `.txt`. No `.csv`, `.gsc`,
  `.csc`, or `*table*` file.
- The `.iwd` archives are plain ZIPs (read the central directory only). Their
  non-media entries are `weapons/mp/*` asset blobs, `accuracy/aivsai/*.accu`,
  and `*.cfg`. The only `.csv` entries are `configure.csv` and `configure_mp.csv`
  (settings auto-detect, not game tables).

Documented embedded asset names (inside the fastfiles, not files under the
folder; not re-measured here): `mp/statstable.csv`, `mp/attachmenttable.csv`,
`mp/weaponoptions.csv`, `mp/gametypestable.csv`. BO1 ships no
`mp/perktable.csv`, `mp/killstreaktable.csv`, `mp/camotable.csv`, or
`mp/classtable.csv`. Rows are not in source; no parser was written.

---

## Non-Map Zones in `zone\Common`

Every file in `zone\Common` that is not an `mp_<stem>.ff` map zone — 60 files.
Names only, not opened.

```text
zone\Common\code_post_gfx.ff
zone\Common\code_post_gfx_mp.ff
zone\Common\code_pre_gfx.ff
zone\Common\code_pre_gfx_mp.ff
zone\Common\common.ff
zone\Common\common_mp.ff
zone\Common\common_zombie.ff
zone\Common\common_zombie_patch.ff
zone\Common\creek_1.ff
zone\Common\cuba.ff
zone\Common\flashpoint.ff
zone\Common\frontend.ff
zone\Common\fullahead.ff
zone\Common\hue_city.ff
zone\Common\int_escape.ff
zone\Common\khe_sanh.ff
zone\Common\kowloon.ff
zone\Common\outro.ff
zone\Common\patch.ff
zone\Common\patch_mp.ff
zone\Common\patch_ui_mp.ff
zone\Common\pentagon.ff
zone\Common\pow.ff
zone\Common\rebirth.ff
zone\Common\river.ff
zone\Common\so_narrative1_frontend.ff
zone\Common\so_narrative2_frontend.ff
zone\Common\so_narrative3_frontend.ff
zone\Common\so_narrative4_frontend.ff
zone\Common\so_narrative5_frontend.ff
zone\Common\so_narrative6_frontend.ff
zone\Common\terminal.ff
zone\Common\ui_mp.ff
zone\Common\ui_viewer_mp.ff
zone\Common\underwaterbase.ff
zone\Common\vorkuta.ff
zone\Common\wmd.ff
zone\Common\wmd_sr71.ff
zone\Common\zombie_coast.ff
zone\Common\zombie_coast_patch.ff
zone\Common\zombie_cod5_asylum.ff
zone\Common\zombie_cod5_asylum_patch.ff
zone\Common\zombie_cod5_factory.ff
zone\Common\zombie_cod5_factory_patch.ff
zone\Common\zombie_cod5_prototype.ff
zone\Common\zombie_cod5_prototype_patch.ff
zone\Common\zombie_cod5_sumpf.ff
zone\Common\zombie_cod5_sumpf_patch.ff
zone\Common\zombie_cosmodrome.ff
zone\Common\zombie_cosmodrome_patch.ff
zone\Common\zombie_moon.ff
zone\Common\zombie_moon_patch.ff
zone\Common\zombie_pentagon.ff
zone\Common\zombie_pentagon_patch.ff
zone\Common\zombie_temple.ff
zone\Common\zombie_temple_patch.ff
zone\Common\zombie_theater.ff
zone\Common\zombie_theater_patch.ff
zone\Common\zombietron.ff
zone\Common\zombietron_patch.ff
```

## `.iwd` `weapons/mp` Entries

Every `weapons/mp` entry name in the `.iwd` archives — 409 entries, all in
`main\iw_00.iwd`, read from the ZIP central directory only, not extracted.
Grouped by folder.

### `weapons/mp/`

```text
acoustic_sensor_mp
airstrike_mp
ak47_acog_mp
ak47_dualclip_mp
ak47_elbit_mp
ak47_extclip_mp
ak47_ft_mp
ak47_gl_mp
ak47_ir_mp
ak47_mk_mp
ak47_mp
ak47_reflex_mp
ak47_silencer_mp
ak74u_acog_grip_mp
ak74u_acog_mp
ak74u_dualclip_mp
ak74u_elbit_mp
ak74u_extclip_mp
ak74u_gl_mp
ak74u_grip_dualclip_mp
ak74u_grip_extclip_mp
ak74u_grip_mp
ak74u_mp
ak74u_reflex_mp
ak74u_rf_mp
ak74u_silencer_mp
asp_mp
aspdw_mp
asplh_mp
aug_acog_mp
aug_dualclip_mp
aug_elbit_mp
aug_extclip_mp
aug_ft_mp
aug_gl_mp
aug_ir_mp
aug_mk_mp
aug_mp
aug_reflex_mp
aug_silencer_mp
auto_gun_turret_mp
auto_tow_mp
autoturret_mp
berlinwall_turret_mp
bomber_mp
briefcase_bomb_defuse_mp
briefcase_bomb_mp
camera_spike_mp
china_lake_mp
claymore_mp
cobra_20mm_comlink_mp
cobra_20mm_mp
cobra_FFAR_mp
commando_acog_mp
commando_dualclip_mp
commando_elbit_mp
commando_extclip_mp
commando_ft_mp
commando_gl_mp
commando_ir_mp
commando_mk_mp
commando_mp
commando_reflex_mp
commando_silencer_mp
concussion_grenade_mp
counteruav_mp
crossbow_explosive_mp
crossbow_mp
cz75_auto_mp
cz75_extclip_mp
cz75_mp
cz75_silencer_mp
cz75_upgradesight_mp
cz75dw_mp
cz75lh_mp
defaultweapon_mp
DELETEMELATER_saw_bipod_crouch_mp
DELETEMELATER_saw_bipod_prone_mp
DELETEMELATER_saw_bipod_stand_mp
destructible_car_mp
dog_bite_mp
dogs_mp
dragunov_acog_mp
dragunov_extclip_mp
dragunov_ir_mp
dragunov_mp
dragunov_silencer_mp
dragunov_vzoom_mp
enfield_acog_mp
enfield_dualclip_mp
enfield_elbit_mp
enfield_extclip_mp
enfield_ft_mp
enfield_gl_mp
enfield_ir_mp
enfield_mk_mp
enfield_mp
enfield_reflex_mp
enfield_silencer_mp
explodable_barrel_mp
explosive_bolt_mp
famas_acog_mp
famas_dualclip_mp
famas_elbit_mp
famas_extclip_mp
famas_ft_mp
famas_gl_mp
famas_ir_mp
famas_mk_mp
famas_mp
famas_reflex_mp
famas_silencer_mp
flame_firstperson_mp
flame_thirdperson_mp
flash_grenade_mp
fnfal_acog_mp
fnfal_dualclip_mp
fnfal_elbit_mp
fnfal_extclip_mp
fnfal_ft_mp
fnfal_gl_mp
fnfal_ir_mp
fnfal_mk_mp
fnfal_mp
fnfal_reflex_mp
fnfal_silencer_mp
frag_grenade_mp
frag_grenade_short_mp
ft_ak47_mp
ft_aug_mp
ft_commando_mp
ft_enfield_mp
ft_famas_mp
ft_fnfal_mp
ft_galil_mp
ft_m14_mp
ft_m16_mp
g11_lps_mp
g11_mp
g11_vzoom_mp
galil_acog_mp
galil_dualclip_mp
galil_elbit_mp
galil_extclip_mp
galil_ft_mp
galil_gl_mp
galil_ir_mp
galil_mk_mp
galil_mp
galil_reflex_mp
galil_silencer_mp
gl_ak47_mp
gl_ak74u_mp
gl_aug_mp
gl_commando_mp
gl_enfield_mp
gl_famas_mp
gl_fnfal_mp
gl_galil_mp
gl_m14_mp
gl_m16_mp
hatchet_mp
helicopter_comlink_mp
helicopter_gunner_mp
helicopter_mp
helicopter_player_firstperson_mp
helicopter_player_mp
helicopter_x2_mp
hind_FFAR_mp
hind_minigun_pilot_2_mp
hind_minigun_pilot_firstperson_mp
hind_minigun_pilot_mp
hind_rockets_firstperson_mp
hind_rockets_mp
hk21_acog_mp
hk21_elbit_mp
hk21_extclip_mp
hk21_ir_mp
hk21_mp
hk21_reflex_mp
hs10_mp
hs10dw_mp
hs10lh_mp
huey_minigun_gunner_mp
humvee_50cal_mp
ithaca_grip_mp
ithaca_mp
kiparis_acog_grip_mp
kiparis_acog_mp
kiparis_elbit_mp
kiparis_extclip_mp
kiparis_grip_extclip_mp
kiparis_grip_mp
kiparis_mp
kiparis_reflex_mp
kiparis_rf_mp
kiparis_silencer_mp
kiparisdw_mp
kiparislh_mp
knife_ballistic_mp
knife_mp
ks23_mp
l96a1_acog_mp
l96a1_extclip_mp
l96a1_ir_mp
l96a1_mp
l96a1_silencer_mp
l96a1_vzoom_mp
m14_acog_grip_mp
m14_acog_mp
m14_elbit_mp
m14_extclip_mp
m14_ft_mp
m14_gl_mp
m14_grip_mp
m14_ir_grip_mp
m14_ir_mp
m14_mk_mp
m14_mp
m14_reflex_mp
m14_silencer_mp
m16_acog_mp
m16_dualclip_mp
m16_elbit_mp
m16_extclip_mp
m16_ft_mp
m16_gl_mp
m16_ir_mp
m16_mk_mp
m16_mp
m16_reflex_mp
m16_silencer_mp
m1911_extclip_mp
m1911_mp
m1911_silencer_mp
m1911_upgradesight_mp
m1911dw_mp
m1911lh_mp
m2_flamethrower_mp
m202_flash_drop_mp
m202_flash_mp
m202_flash_wager_mp
m220_tow_drop_mp
m220_tow_killstreak_mp
m220_tow_mp
m220_tow_wager_mp
m60_acog_grip_mp
m60_acog_mp
m60_elbit_mp
m60_extclip_mp
m60_grip_mp
m60_ir_grip_mp
m60_ir_mp
m60_mp
m60_reflex_mp
m72_law_mp
mac11_elbit_mp
mac11_extclip_mp
mac11_grip_mp
mac11_mp
mac11_reflex_mp
mac11_rf_mp
mac11_silencer_mp
mac11dw_mp
mac11lh_mp
makarov_extclip_mp
makarov_mp
makarov_silencer_mp
makarov_upgradesight_mp
makarovdw_mp
makarovlh_mp
minigun_drop_mp
minigun_mp
minigun_turret_mp
minigun_wager_mp
mk_ak47_mp
mk_aug_mp
mk_commando_mp
mk_enfield_mp
mk_famas_mp
mk_fnfal_mp
mk_galil_mp
mk_m14_mp
mk_m16_mp
mk82_mp
mortar_mp
mp40_blinged_mp
mp40_drop_mp
mp40_mp
mp5k_acog_mp
mp5k_elbit_mp
mp5k_extclip_mp
mp5k_mp
mp5k_reflex_mp
mp5k_rf_mp
mp5k_silencer_mp
mpl_acog_grip_mp
mpl_acog_mp
mpl_dualclip_mp
mpl_elbit_mp
mpl_grip_mp
mpl_mp
mpl_reflex_mp
mpl_rf_mp
mpl_silencer_mp
napalm_mp
napalmblob_mp
napalmground_lg_mp
napalmground_sm_mp
nightingale_mp
pm63_extclip_mp
pm63_grip_mp
pm63_mp
pm63_rf_mp
pm63dw_mp
pm63lh_mp
psg1_acog_mp
psg1_extclip_mp
psg1_ir_mp
psg1_mp
psg1_silencer_mp
psg1_vzoom_mp
python_acog_mp
python_mp
python_snub_mp
python_speed_mp
pythondw_mp
pythonlh_mp
radar_mp
radardirection_mp
radartime_mp
radarupdate_mp
rc_car_weapon_mp
rcbomb_mp
rottweil72_mp
rpg_mp
rpk_acog_mp
rpk_dualclip_mp
rpk_elbit_mp
rpk_extclip_mp
rpk_ir_mp
rpk_mp
rpk_reflex_mp
satchel_charge_mp
scavenger_item_mp
scrambler_mp
shovel_mp
skorpion_extclip_mp
skorpion_grip_mp
skorpion_mp
skorpion_rf_mp
skorpion_silencer_mp
skorpiondw_mp
skorpionlh_mp
smoke_center_mp
smoke_fx_mp
smoke_large_mp
smoke_medium_mp
smoke_small_mp
smoke_tiny_mp
spas_mp
spas_silencer_mp
spectre_acog_grip_mp
spectre_acog_mp
spectre_elbit_mp
spectre_extclip_mp
spectre_grip_mp
spectre_mp
spectre_reflex_mp
spectre_rf_mp
spectre_silencer_mp
sticky_grenade_mp
stoner63_acog_mp
stoner63_elbit_mp
stoner63_extclip_mp
stoner63_ir_mp
stoner63_mp
stoner63_reflex_mp
strela_mp
supplydrop_mp
supplystation_mp
syrette_mp
tabun_center_mp
tabun_fx_mp
tabun_gas_mp
tabun_large_mp
tabun_medium_mp
tabun_small_mp
tabun_tiny_mp
tactical_insertion_mp
tow_turret_drop_mp
tow_turret_mp
turret_drop_mp
uzi_acog_grip_mp
uzi_acog_mp
uzi_elbit_mp
uzi_extclip_mp
uzi_grip_mp
uzi_mp
uzi_reflex_mp
uzi_rf_mp
uzi_silencer_mp
wa2000_acog_mp
wa2000_extclip_mp
wa2000_ir_mp
wa2000_mp
wa2000_silencer_mp
wa2000_vzoom_mp
willy_pete_mp
```

---

## OAT T5 Unlinker run (2026-10-06)

Tool: **OpenAssetTools Unlinker v0.33.0** —
`[local path]

Files opened (these two only):

- `[local path] of Duty Black Ops\zone\Common\common_mp.ff`
- `[local path] of Duty Black Ops\zone\Common\patch_mp.ff`

Command:

```text
Unlinker.exe -o "<out>\?zone?" "zone\Common\common_mp.ff" "zone\Common\patch_mp.ff"
```

Output path: `[local path] [local path]\Local\Temp\opencode\oat-bo1\`
with subfolders `common_mp\` and `patch_mp\`.
Run result: `Finished with 0 warnings, 1 errors` — the error is
`ERROR: Unsupported IWI format: 9` on one image, not a table.

### What the tool actually wrote

| Table row | Written by this run | Output path |
|-----------|---------------------|-------------|
| Gametype scripts / table | yes (scripts) | `common_mp\maps\mp\gametypes\*.gsc` (73), `patch_mp\maps\mp\gametypes\*.gsc` (8) |
| Weapon table | not in source | — |
| Attachment table | not in source | — |
| Perk table | not in source | — |
| Equipment / Lethal / Tactical table | not in source | — |
| Killstreak table | not in source | — |
| Camo table | not in source | — |
| Create-a-class table | not in source | — |

Only string tables written by these two zones: `common_mp\mp\gridpointstable.csv`
and `common_mp\scrubbingrules.csv` (plus `common_mp\mp\configstrings\*.csv`).
None of them is a weapon, attachment, perk, equipment, killstreak, camo,
gametype, or create-a-class table.

Gametype scripts written — `common_mp\maps\mp\gametypes\`: `ctf.gsc`, `dem.gsc`,
`dm.gsc`, `dom.gsc`, `gun.gsc`, `hlnd.gsc`, `koth.gsc`, `oic.gsc`, `sab.gsc`,
`sd.gsc`, `shrp.gsc`, `sur.gsc`, `tdm.gsc`, `twar.gsc`, and the `_*.gsc` support
set (`_class.gsc`, `_customclasses.gsc`, `_weapons.gsc`,
`_killstreak_weapons.gsc`, `_globallogic_*.gsc`, ...). `patch_mp\maps\mp\gametypes\`:
`ctf.gsc`, `dem.gsc`, `dom.gsc`, `koth.gsc`, `sab.gsc`, `_globallogic_player.gsc`,
`_globallogic_score.gsc`, `_spawning.gsc`.

The documented names `mp/statstable.csv`, `mp/attachmenttable.csv`,
`mp/weaponoptions.csv`, and `mp/gametypestable.csv` were **not** written by
unlinking these two zones. They stay documented, not read.

## OAT T5 Unlinker run — ui_mp.ff + patch_ui_mp.ff (2026-10-06)

Tool: **OpenAssetTools Unlinker v0.33.0** —
`[local path]

Files opened (these two only):

- `[local path] of Duty Black Ops\zone\Common\ui_mp.ff`
- `[local path] of Duty Black Ops\zone\Common\patch_ui_mp.ff`

Command:

```text
Unlinker.exe -o "<out>\?zone?" "zone\Common\ui_mp.ff" "zone\Common\patch_ui_mp.ff"
```

Output path: `[local path] [local path]\Local\Temp\opencode\oat-bo1-ui\`
with subfolders `ui_mp\` and `patch_ui_mp\`.
Run result: `Finished with 0 warnings, 0 errors`.

### What the tool actually wrote

No table of any requested kind was written. The run produced only materials
(`.json`), images (`.dds`), shader binaries (`.cso`), techniques/techsets, and
two rawfiles (`ui_mp`, `patch_ui_mp`).

| Table row | Written by this run | Output path |
|-----------|---------------------|-------------|
| Weapon table | not in source | — |
| Attachment table | not in source | — |
| Perk table | not in source | — |
| Equipment / Lethal / Tactical table | not in source | — |
| Killstreak table | not in source | — |
| Camo table | not in source | — |
| Gametype scripts / table | not in source | — |
| Create-a-class table | not in source | — |

Named tables checked, none written:

- `mp/statstable.csv` — not written
- `mp/attachmenttable.csv` — not written
- `mp/weaponoptions.csv` — not written
- `mp/gametypestable.csv` — not written

## OAT T5 Unlinker run — code_post_gfx_mp.ff (2026-10-06)

Tool: **OpenAssetTools Unlinker v0.33.0** —
`[local path]

File opened (this one only): `zone\Common\code_post_gfx_mp.ff`

Command:

```text
Unlinker.exe -o "<out>\?zone?" "zone\Common\code_post_gfx_mp.ff"
```

Output path: `[local path] [local path]\Local\Temp\opencode\oat-bo1-codepost\code_post_gfx_mp\`
Run result: `Finished with 0 warnings, 1 errors` — the error is
`ERROR: Unsupported IWI format: 7` on one image, not a table. It did not crash,
and it did write tables (42 string tables).

### The four named tables — all written

| Table | Written | Output path |
|-------|---------|-------------|
| `mp/statstable.csv` | yes | `code_post_gfx_mp\mp\statstable.csv` |
| `mp/attachmenttable.csv` | yes | `code_post_gfx_mp\mp\attachmenttable.csv` |
| `mp/weaponoptions.csv` | yes | `code_post_gfx_mp\mp\weaponoptions.csv` |
| `mp/gametypestable.csv` | yes | `code_post_gfx_mp\mp\gametypestable.csv` |

### The eight category rows

| Row | Written by this run | Output path |
|-----|---------------------|-------------|
| Weapon table | yes | `code_post_gfx_mp\mp\statstable.csv` |
| Attachment table | yes | `code_post_gfx_mp\mp\attachmenttable.csv` |
| Perk table | not in source | no `mp/perktable.csv` written |
| Equipment / Lethal / Tactical table | not in source | no dedicated table written |
| Killstreak table | not in source | no `mp/killstreaktable.csv` written |
| Camo table | yes | `code_post_gfx_mp\mp\weaponoptions.csv` |
| Gametype scripts / table | yes (table) | `code_post_gfx_mp\mp\gametypestable.csv` |
| Create-a-class table | not in source | no `mp/classtable.csv` written |

Note: BO1 ships no file literally named `weapon`/`camo`/`perk`/`killstreak`/`class`
table. The tool wrote `mp/statstable.csv` (its weapon/stat table, which also
carries the perk/specialty rows), `mp/weaponoptions.csv` (its camo source), and
`mp/gametypestable.csv` (its gametype table). No `mp/perktable.csv`,
`mp/killstreaktable.csv`, `mp/camotable.csv`, or `mp/classtable.csv` was written.

### All 42 string tables the tool wrote

```text
code_post_gfx_mp\level_dependencies.csv
code_post_gfx_mp\mp\attachmenttable.csv
code_post_gfx_mp\mp\attributestable.csv
code_post_gfx_mp\mp\bodyheadtable.csv
code_post_gfx_mp\mp\challengetable.csv
code_post_gfx_mp\mp\challengetable_tier1.csv
code_post_gfx_mp\mp\challengetable_tier2.csv
code_post_gfx_mp\mp\challengetable_tier3.csv
code_post_gfx_mp\mp\challengetable_tier4.csv
code_post_gfx_mp\mp\challengetable_tier5.csv
code_post_gfx_mp\mp\challengetable_tier6.csv
code_post_gfx_mp\mp\challengetable_tier7.csv
code_post_gfx_mp\mp\challengetable_tier8.csv
code_post_gfx_mp\mp\challengetable_tier9.csv
code_post_gfx_mp\mp\challengetable_tier10.csv
code_post_gfx_mp\mp\challengetable_tier11.csv
code_post_gfx_mp\mp\challengetable_tier12.csv
code_post_gfx_mp\mp\clantagfeatures.csv
code_post_gfx_mp\mp\classbonustable.csv
code_post_gfx_mp\mp\defaultstringtable.csv
code_post_gfx_mp\mp\didyouknow.csv
code_post_gfx_mp\mp\didyouknow_theater.csv
code_post_gfx_mp\mp\didyouknow_wager.csv
code_post_gfx_mp\mp\filesharetags.csv
code_post_gfx_mp\mp\gametypestable.csv
code_post_gfx_mp\mp\globalcounterrefs.csv
code_post_gfx_mp\mp\globalcounters.csv
code_post_gfx_mp\mp\mapstable.csv
code_post_gfx_mp\mp\medaltable.csv
code_post_gfx_mp\mp\personalbests.csv
code_post_gfx_mp\mp\rankicontable.csv
code_post_gfx_mp\mp\ranktable.csv
code_post_gfx_mp\mp\reportuser.csv
code_post_gfx_mp\mp\statsmilestones1.csv
code_post_gfx_mp\mp\statsmilestones2.csv
code_post_gfx_mp\mp\statsmilestones3.csv
code_post_gfx_mp\mp\statsmilestones4.csv
code_post_gfx_mp\mp\statstable.csv
code_post_gfx_mp\mp\tickerweights.csv
code_post_gfx_mp\mp\ui_viewer_camera.csv
code_post_gfx_mp\mp\wagercpmedaltable.csv
code_post_gfx_mp\mp\weaponoptions.csv
```
