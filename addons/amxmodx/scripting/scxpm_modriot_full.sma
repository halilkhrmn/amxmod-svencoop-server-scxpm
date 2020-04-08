/* SCXPM Version 17.0 by Silencer
** Edited by Wrd, Version 17.31
** 	Wrd thanks supergreg for his suggestions
**
** Edited by PythEch, Version 17.31.4
**
** Special Thanks to:
**
** VEN			For heavily improving my Scripting-Skills.  ;p
** darkghost9999	For his great Ideas!
**
**
** Thanks to:
**
** ThomasNguyen
** `666
** g3x
** Hitman (Warchild)
**
*/
/*
SCXPM Version 17.31.28 edited by Swamp Dog @ ModRiot.com
Permutations system designed by Swamp Dog (with math help from J-M & Effor)
Further Credits from Sven Coop 5.0 development by players from ModRiot.com will be included in "scxpm_credits.txt"
*/
#include <amxmodx>
#include <amxmisc>
#include <fakemeta>
#include <fun>
#include <sqlx>
#include <bit>
#pragma dynamic 32768
//for semi-colon syntax
//#pragma semi-colon
/*
New Loop checking system designed with combinatorics mathematics by Swamp Dog
Comment #define NEW_LOOP in define.inl to remove this feature
This is specifically designed to be able to load a certain loop with the experience mod plugin on map start
This is used to disable skills in scxpm_regen original loop, which are disabled by using per-map config files "mapname.cfg" in "amxmodx/configs/maps/"
The design idea was to prevent SCXPM from breaking maps in Sven Co-op 5.0, because it does break maps.
Based on cvars combinations - see "main.inl" for more information on combinations
*/
// comment the #define USING_CS if you don't use cs
//#define USING_CS
// comment the #define USING_GW if you don't use GangWars
// #define USING_GW
// added for Sven Coop specific loading - comment when using with other games/mods
#define USING_SVEN
// I need to add bot checks for when client connects and such - for use with CS - comment to disable bots
#define ALLOW_BOTS
// comment to remove Bot Event registry (register_event ResetHUD and Damage) - may be useful for svencoop not to have to do the check
#define ALLOW_BOT_EVENT
// comment the #define ARMOR_TP to turn off Team Power Armor - swmpdg
#define ARMOR_TP
// comment to remove damage event code
#define EVENT_DMG
// comment to remove Ammo Regeneration Team Power functionality
#define AMMO_TP
// comment to remove Speed Control design by swmpdg - Counter-Strike seems to need it disabled - only useful for trying to stop speed running in Sven Coop?
// will need to use differently for CS...for now, turn off.
#define SPEED_CTRL
// comment to remove Gravity Damage control (player is set with high gravity if attacked)
#define GRAV_DMG
// comment to remove monstermod + random monsters fun support (needs ham sandwich, likely unstable with sven coop)
//#define ALLOW_MONSTERS
// comment to use hard-coded defined SQL DB info
#define SQLCVAR
// comment to remove "Frag Bonus" and winning medals
#define FRAGBONUS
// comment to disallow trading of XP / Medals
#define ALLOW_TRADE
// comment to remove count-control for showdata and reexp - make count control pcvars? - turn off for cs? may want to use in cs...
#define COUNT_CTRL
// comment to remove check for if player is above level 0 to run code
#define PLYR_CTRL
// comment to use old regen system
#define NEW_LOOP
// skills control defines for Sven Co-op 5 - comment the skill to disable the control cvars being compiled
// Strength
#define HEALTH_CTRL
// Superior Armor
#define ARMOR_CTRL
// Health Regen
#define HPREGEN_CTRL
// Nano Armor
#define NANO_CTRL
// Ammo reincarnation
#define AMMO_CTRL
//#define GRAVITY_CTRL // Anti-Gravity
//#define AWARE_CTRL // Awareness
 // Team Power
#define TP_CTRL
// Block Attack
#define BLOCK_CTRL
// define to use Testing Team Power
//#define TEST_TP
// used to check for entity if it exists, and if it does it will disable certain skills before the calculation loads a loop - test
// Entities currently checked for: game_player_equip, trigger_gravity (reason: SCXPM breaks the function of these entities)
#define ENTITY_CHECK
#if defined ENTITY_CHECK
#include <engine>
#endif
 // to be used for controlling if Medals give additional HP, Armor, etc.
//#define MEDAL_CTRL
// Cheats - God Mode and No-Clip enabled by define
//#define CHEATS_ALLOWED
// Reset Skills check so players can't exploit resetting skills
// #define RESETCHECK
// Free levels - or experience points increase?
#define FREE_LEVELS
// define to add luck into the mix - wont compile - need to make new table for credits + luck
//#define LUCK_CTRL
// define to add spawn health and armor
#define SPAWN_CTRL
// regen rate control
//#define RATE_CTRL
// loop speed control
//#define LOOP_CTRL
#if defined LUCK_CTRL
#include <luck>
#endif
#if defined USING_CS
#include <cstrike>
#endif
#if defined ALLOW_MONSTERS
#include <hamsandwich>
#endif
#define VERSION "17.31.35"
#define LASTUPDATE "21 August 2016"
#if !defined SQLCVAR
#define DATABASE_HOST "127.0.0.1"
#define DATABASE_USERNAME "root"
#define DATABASE_PASSWORD "password"
#define DATABASE_DATABASE "database_name"
#endif
/*
*	Future Features
*	if you want new features ask it on: http://forums.alliedmods.net/showthread.php?t=44168
*	------------------
*	- pruning database with the `lastUpdated` field
*	- cuicide penalty
*
*/
/*
** Queries
*/
#define QUERY_SELECT_SKILLS "SELECT `xp`, `playerlevel`, `skillpoints`, `medals`, `health`, `armor`, `rhealth`, `rarmor`, `rammo`, `gravity`, `speed`, `dist`, `dodge` FROM `%s` WHERE %s"
#define QUERY_UPDATE_SKILLS "INSERT INTO %s (uniqueid) VALUES ('%s') ON DUPLICATE KEY UPDATE authid ='%s',nick='%s',ip='%s',xp='%d',playerlevel='%d',skillpoints='%d',medals='%d',health='%d',armor='%d',rhealth='%d',rarmor='%d',rammo='%d',gravity='%d',speed='%d',dist='%d',dodge='%d'"
new const Stre[] = "Strength";
new const SupArm[] = "Superior Armor";
new const HPRe[] = "Health Regeneration";
new const APRe[] = "Nano Armor";
new const AmmoRe[] = "Ammo Reincarnation";
new const Grav[] = "Anti-Gravity Device";
new const Aware[] = "Awareness";
new const TeamP[] = "Team Power";
new const Block[] = "Block Attack";
new const Medals[] = "Medals";
new const SCXPM[] = "[SCXPM]";
new const DEBUG[] = "[SCXPM DEBUG]";
new const SQL[] = "[SCXPM SQL]";
#if defined USING_SVEN
new const Ammo9mm[] = "ammo_9mmAR";
new const AmmoBS[] = "ammo_buckshot";
new const Ammo357[] = "ammo_357";
new const AmmoCB[] = "ammo_crossbow";
new const AmmoSC[] = "ammo_sporeclip";
new const AmmoRPG[] = "ammo_rpgclip";
new const AmmoGC[] = "ammo_gaussclip";
new const Ammo556[] = "ammo_556";
new const Ammo762[] = "ammo_762";
new const AmmoARG[] = "ammo_ARgrenades";
#endif
new const WaitMsg[]= "Please wait for skills to be loaded first.";
// added for mysql support
new Handle:dbc;
new g_Cache[1024];
new sql_table[64];
// check so data is only saved when data is loaded
new loaddata;
new bool:plugin_ended;
#if defined USING_CS
new ammotype[7][15];
#endif
new const ranks[23][] = {
	"Frightened Civilian",
	"Civilian",
	"Fighter",
	"Private Third Class",
	"Private Second Class",
	"Private First Class",
	"Free Agent",
	"Professional Free Agent",
	"Professional Force Member",
	"Professional Force Leader",
	"Special Force Member",
	"Special Force Leader",
	"United Forces Member",
	"United Forces Leader",
	"Hidden Operations Member",
	"Hidden Operations Scheduler",
	"Hidden Operations Leader",
	"General",
	"Top 30 of most famous Leaders",
	"Top 15 of most famous Leaders",
	"Highest Force Member",
	"Highest Force Leader",
	"Loading..."
}
new xp[33],neededxp[33],playerlevel[33],rank[33];
new skillpoints[33],medals[35], health[33],armor[33];
new rhealth[33],rarmor[33],rammo[33],gravity[33];
new speed[33],dist[33],dodge[33],rarmorwait[33];
new rhealthwait[33],ammowait[33],lastfrags[33],firstLvl[33];
#if defined LUCK_CTRL
//new luck[33];
new bool:isLucky[33] = false;
#endif
#if defined COUNT_CTRL
new count_reexp[33],count_save[33],maxlvl_count[33];
#endif
new skillIncrement[33], iPlayers[32], iNum;
#if defined FRAGBONUS
new medal_limit[33];
#endif
#if defined ALLOW_TRADE
new trade_limit[33];
#endif
#if defined RESETCHECK
new resetcheck[33];
#endif
//#if defined LUCK_CTRL
//new bool:isLucky[33] = false;
//new luck
//#endif
//new has_godmode, iNum;
#if !defined USING_SVEN
new pcvar_gamename, pcvar_save, pcvar_debug, pcvar_savestyle, pcvar_minplaytime;
#else
new pcvar_save, pcvar_debug, pcvar_savestyle, pcvar_minplaytime;
#endif
#if !defined SQLCVAR
new pcvar_sql_table;
#else
new pcvar_sql_host, pcvar_sql_user, pcvar_sql_pass, pcvar_sql_db, pcvar_sql_table;
#endif
new pcvar_hud_channel, pcvar_save_frequent, pcvar_xpgain, pcvar_maxlevel;
#if !defined USING_CS
new pcvar_maxlevelup_enabled,pcvar_maxlevelup,pcvar_maxlevelup_limit;
#endif
#if defined FRAGBONUS
new pcvar_fraglimit, pcvar_bonus;
#endif
#if defined HEALTH_CTRL
new pcvar_health,pcvar_maxhealth,max_health;
new maxhealth[33];
#endif
#if defined ARMOR_CTRL
new pcvar_armor,pcvar_maxarmor,max_armor;
new maxarmor[33];
#endif
#if defined HPREGEN_CTRL
new pcvar_hpregen;
#endif
#if defined NANO_CTRL
new pcvar_nano;
#endif
#if defined AMMO_CTRL
new pcvar_ammo;
#endif
new pcvar_gravity;
#if defined AWARE_CTRL
new pcvar_awareness;
#endif
#if defined TP_CTRL
new pcvar_teampower;
#endif
#if defined BLOCK_CTRL
new pcvar_block;
#endif
#if defined COUNT_CTRL
#if defined USING_CS
new pcvar_counter;
#else
new pcvar_counter, pcvar_savectrl;
#endif
#endif
// can do check if player stats loaded yet...
new bool:isLoaded[33] = false;
#if defined EVENT_DMG
//thx to jonnyboy0719 for this idea and code from his RPG Mod
new bool:PlayerIsHurt[33] = false;
#endif
#if defined PLYR_CTRL
new bool:onecount[33] = false;
#endif
new bool:spawnmenu[33] = false;
new distanceRange;
#if defined FRAGBONUS
new fragcount, resetfrags, fragbonus, pcvar_bonuslimit;
#endif
#if defined SPEED_CTRL
new bool:g_hasSpeed[33] = false;
new bool:g_punished[33] = false;
new pcvar_speedctrl, pcvar_reduce;
#endif
#if defined ALLOW_MONSTERS
new AgrXP, ApaXP, BarXP, BigXP, BulXP, ConXP, GarXP, HeaXP, HouXP, HasXP, HgrXP, SciXP, IslXP, SnaXP, ZomXP
#endif
#if defined NEW_LOOP
new loopcheck;
#endif
#if defined ALLOW_TRADE
new pcvar_tradelimit, pcvar_tradevalue, tradevalue;
#endif
#if defined FREE_LEVELS
new pcvar_givefree, pcvar_freelevels;
#endif
#if defined SPAWN_CTRL
new pcvar_spawnctrl;
#endif
#if defined RATE_CTRL
new hrate, nrate, arate;
#endif
#if defined LOOP_CTRL
new lrate;
#endif
#include <scxpm_stocks>
public plugin_init()
{
	// Silencer original author, with work added by others - Any changes beyond version 17.31.3 is work soley done by Swamp Dog
	register_plugin("SCXPM",VERSION,"Silencer");
#if AMXX_VERSION_NUM >= 183
	register_dictionary("scxpm183.txt");
#else
	register_dictionary("scxpm.txt");
#endif
	register_menucmd(register_menuid("select_skill"),(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)|(1<<7)|(1<<8)|(1<<9),"SCXPMSkillChoice");
	register_menucmd(register_menuid("select_increment"),(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5),"SCXPMIncrementChoice");
#if !defined USING_SVEN
	register_forward(FM_GetGameDescription,"scxpm_gn");
#endif
	// allow for bots in ResetHUD?
#if !defined ALLOW_BOT_EVENT // needed a new define, because ALLOW_BOTS is not enough control here
#if defined EVENT_DMG
	register_event("Damage", "EVENT_Damage", "bef");
#endif
	register_event("ResetHUD", "on_ResetHUD", "bef"); // bef - b = only single client, e = alive, and f = only humans
#else
#if defined EVENT_DMG
	register_event("Damage", "EVENT_Damage", "be");
#endif
	register_event("ResetHUD", "on_ResetHUD", "be"); // bef - b = only single client, e = alive
#endif
	register_concmd("amx_setlvl","scxpm_setlvl", ADMIN_LEVEL_B,"Playername Value - Will set Players Level");
	register_concmd("amx_addmedal","scxpm_addmedal", ADMIN_LEVEL_B,"Playername - Will award Player with a Medal");
	register_concmd("amx_removemedal","scxpm_removemedal", ADMIN_LEVEL_B,"Playername - Will remove a Medal of a Player");
	register_concmd("amx_addxp","scxpm_addxp", ADMIN_LEVEL_B,"Playername Value - Will add xp to Players xp");
	register_concmd("amx_removexp","scxpm_removexp", ADMIN_LEVEL_B,"Playername Value - Will remove xp from Players xp");
	// for debug reasons
	// register_concmd("say savedata","scxpm_savexp_all_mysql",ADMIN_IMMUNITY,"- Will save your SCXPM data");
#if defined CHEATS_ALLOWED
	register_concmd("amx_godmode","scxpm_godmode", ADMIN_LEVEL_B,"Playername - Toggle Players God Mode On or Off.");
	register_concmd("amx_noclipmode","scxpm_noclipmode", ADMIN_LEVEL_B,"Playername - Toggle Players noclip Mode On or Off.");
#endif
#if defined SPEED_CTRL
	register_concmd("amx_speedctrl", "scxpm_speed", ADMIN_LEVEL_A, "<#userid,nick,SteamID> - Turn speed control on or off for player");
#endif
	register_clcmd("say", "say_hook");
	register_clcmd("say_team", "say_hook");
	// console commands don't work anymore in Sven Co-op?
	register_concmd("selectskills","SCXPMSkill",0,"- Opens the Skill Choice Menu, if you have Skillpoints available");
	register_concmd("selectskill","SCXPMSkill",0,"- Opens the Skill Choice Menu, if you have Skillpoints available");
	register_concmd("resetskills","scxpm_reset",0,"- Will reset your Skills so you can rechoose them");
	// register_concmd("playerskills","scxpm_others",0,"- Will print Other Players Stats");
	register_concmd("skillsinfo","scxpm_info",0,"- Will print Information about all Skills");
	register_concmd("skillsinfo","scxpm_skillsinfo",0,"- Will print Information about all Skills");
	register_concmd("scxpminfo","scxpm_version",0,"- Will print Information about SCXPM");
#if !defined USING_SVEN
	pcvar_gamename = register_cvar("scxpm_gamename","1");
#endif
	// may decide to use this in CS or other mods, but I doubt it at this point.
#if !defined USING_CS
	/* If enabled, it will try to prevent players using bugs to boost their XP in maps like of4a4
	** 0 = Disabled
	** 1 = Enabled
	*/
	pcvar_maxlevelup_enabled = register_cvar("scxpm_maxlevelup_enabled", "1");
	// Maximum level can be gained per map (Default:20)
	pcvar_maxlevelup = register_cvar("scxpm_maxlevelup", "20");
	// Players will be able to level up without limitations if they're under the specified level (Default:100)
	pcvar_maxlevelup_limit = register_cvar("scxpm_maxlevelup_limit", "100");
#endif
#if defined HEALTH_CTRL
	// to stop scxpm from breaking maps - disable Health skill on certain maps in "mapname.cfg" in configs/maps dir
	// set to 0 to disable Health skill
	pcvar_health = register_cvar("scxpm_health", "1");
	// set to value you want maxhealth of players to be for the map if scxpm_health is 0 (set to 0 to disable, or set to the value you want max health to be):
	pcvar_maxhealth = register_cvar("scxpm_maxhealth", "0");
#endif
#if defined ARMOR_CTRL
	// to stop scxpm from breaking maps - disable Superior Armor skill on certain maps in "mapname.cfg" in configs/maps dir
	// set to 0 to disable Superior Armor skill
	pcvar_armor = register_cvar("scxpm_armor", "1");
	// set to value you want maxhealth of players to be for the map if scxpm_armor is 0 (set to 0 to disable, or set to the value you want max armor to be):
	pcvar_maxarmor = register_cvar("scxpm_maxarmor", "0");
#endif
#if defined HPREGEN_CTRL
	// to stop scxpm from breaking maps - disable Health Regeneration skill on certain maps in "mapname.cfg" in configs/maps dir
	// set to 0 to disable Health Regeneration skill
	pcvar_hpregen = register_cvar("scxpm_hpregen", "1");
#endif
#if defined NANO_CTRL
	// to stop scxpm from breaking maps - disable Nano Armor skill on certain maps in "mapname.cfg" in configs/maps dir
	// set to 0 to disable Nano Armor skill
	pcvar_nano = register_cvar("scxpm_nano", "1");
#endif
#if defined AMMO_CTRL
	// to stop scxpm from breaking maps - disable Ammo Reincarnation skill on certain maps in "mapname.cfg" in configs/maps dir
	// set to 0 to disable Ammo Reincarnation skill
	pcvar_ammo = register_cvar("scxpm_ammo", "1");
#endif
	// to stop scxpm from breaking maps - disable Anti-Gravity skill on certain maps in "mapname.cfg" in configs/maps dir
	// set to 0 to disable Anti-Gravity
	pcvar_gravity = register_cvar("scxpm_gravity", "1");
#if defined AWARE_CTRL
	// to stop scxpm from breaking maps - disable Awareness skill on certain maps in "mapname.cfg" in configs/maps dir
	// set to 0 to disable Awareness
	pcvar_awareness = register_cvar("scxpm_awareness", "1");
#endif
#if defined TP_CTRL
	// to stop scxpm from breaking maps - disable Team Power skill on certain maps in "mapname.cfg" in configs/maps dir
	// set to 0 to disable Team Power
	pcvar_teampower = register_cvar("scxpm_teampower", "1");
#endif
#if defined BLOCK_CTRL
	// to stop scxpm from breaking maps - disable Block Attack skill on certain maps in "mapname.cfg" in configs/maps dir
	// set to 0 to disable Block Attack
	pcvar_block = register_cvar("scxpm_block", "1");
#endif
#if defined FRAGBONUS
	pcvar_fraglimit = register_cvar("scxpm_fraglimit", "100");
	// bonus is scxpm_bonus*rank[id], so level 20 would be 20*100. May still be too high, but it is a medal...
	// sell medal for same prices as scxpm_bonus*rank[id]
	pcvar_bonus = register_cvar("scxpm_bonus", "100");
#endif
#if defined SPEED_CTRL
	pcvar_speedctrl = register_cvar("scxpm_speedctrl","1");// set to 1 to enable, 0 to disable
	pcvar_reduce = register_cvar("scxpm_speedamt", "100"); // added to stop speed running for the most part - needs mathematical equation explained
#endif
#if defined COUNT_CTRL
	// controls rate of how fast the counter goes for reexp and showdata (from 0-5, 4=5 seconds at regen rate of 1.0 second loop)
	pcvar_counter = register_cvar("scxpm_counter", "4");
#if !defined USING_CS
	// controls rate (counter) of saving data if player does not gain a level - value of "60" with regen loop running once every second = once a minute.
	pcvar_savectrl = register_cvar("scxpm_savectrl", "1");
#endif
#endif
#if defined SPAWN_CTRL
	// should player spawn with health and armor on ResetHUD?
	pcvar_spawnctrl = register_cvar("scxpm_spawn", "0");
#endif
#if defined RATE_CTRL
	// health regenreation limit to count to - 380 is default (approximately 1hp per second currently) - will likely incorporate luck
	hrate = register_cvar("scxpm_hprlimit", "380");
	// nano armor limit to count to - 380 is default (approximately 1hp per second currently) - will likely incorporate luck
	nrate = register_cvar("scxpm_arlimit", "380");
	// ammo reincarnation limit to count to - 1000 is default (approximately 10 seconds inbetween ammo giving) - will likely incorporate luck
	arate = register_cvar("scxpm_amrate", "1000");
#endif
#if defined LOOP_CTRL
	// controls how often the loop repeats - 1.0 is default (once a second - original scxpm was once every half-second)
	lrate = register_cvar("scxpm_loop", "1.0");
#endif
	/*
	** set the save style
	** 0 = not saved
	** 1 = save in a file
	** 2 = save in mysql
	*/
	pcvar_save = register_cvar("scxpm_save","2");
	// for debug information in the logfile set this to 1
	pcvar_debug = register_cvar("scxpm_debug","0");
	/*
	** what to save on
	** 0 = id
	** 1 = ip address
	** 2 = nickname
	*/
	//register_cvar("scxpm_savestyle", "0")
	// if sv_lan is on save stuff on the nickname - doesn't work for vault in amxx 1.8.2?
	if (get_cvar_num("sv_lan") == 1)
		pcvar_savestyle = register_cvar("scxpm_savestyle", "2");
	else
		pcvar_savestyle = register_cvar("scxpm_savestyle", "0");
#if defined ALLOW_TRADE
	// limit of trading medals for xp, or xp for medals (per map)
	pcvar_tradelimit = register_cvar("scxpm_tradelimit", "1");
	// value of rank[id] * scxpm_tradevalue = xp given / taken for trading medal or xp
	pcvar_tradevalue = register_cvar("scxpm_tradevalue", "100");
#endif
#if defined FRAGBONUS
	// limit to amount of how many frags bonus can occur (per map)
	pcvar_bonuslimit = register_cvar("scxpm_bonuslimit", "1");
#endif
	// minimum play time before saving data in seconds, 0 = always save (will changing this to 60 stop the empty data from being saved? 60 seconds) - more like 120
	pcvar_minplaytime = register_cvar("scxpm_minplaytime", "120");
	// mysql
#if defined SQLCVAR
	pcvar_sql_host	= register_cvar("scxpm_sql_host", "127.0.0.1");
	pcvar_sql_user	= register_cvar("scxpm_sql_user", "NOTSET");
	pcvar_sql_pass	= register_cvar("scxpm_sql_pass", "NOTSET");
	pcvar_sql_db	= register_cvar("scxpm_sql_db", "NOTSET");
#endif
	pcvar_sql_table	= register_cvar("scxpm_sql_table", "scxpm_stats");
#if !defined USING_SVEN
#if !defined USING_CS
#if !defined SQLCVAR
	new configsDir[64];
	get_configsdir(configsDir, 63);
	server_cmd("exec %s/xp-sql.cfg", configsDir);
#endif
#endif
#endif
#if defined USING_CS
	ammotype[0] = "ammo_9mm";// glock18, elite, mp5navy, tmp
	ammotype[1] = "ammo_50ae";// deagle
	ammotype[2] = "ammo_buckshot";// m3, xm1014
	ammotype[3] = "ammo_57mm";// p90, fiveseven
	ammotype[4] = "ammo_45acp";// usp, mac10, ump45
	ammotype[5] = "ammo_556nato";// famas, sg552, m4a1, aug, sg550
	ammotype[6] = "ammo_9mm";// glock18, elite, mp5navy, tmp
#endif
	// hud message fix if it conflicts with other plugins
	pcvar_hud_channel = register_cvar("scxpm_hud_channel", "0");
	// to enable frequent savestyle
	// if set to 1 players data will be saved as soon it gains xp
	pcvar_save_frequent = register_cvar("scxpm_save_frequent", "0");
	pcvar_xpgain = register_cvar( "scxpm_xpgain", "5.0" ); // default 10, changed to 5
	// possibility to cap the max level
	pcvar_maxlevel = register_cvar( "scxpm_maxlevel", "1800" );
#if defined FREE_LEVELS
	// To turn on free levels, set "scxpm_givefree" to "1" (default 0)
	pcvar_givefree = register_cvar("scxpm_givefree", "0")
	// If free level giving is turned on, how many free levels should it give? set "scxpm_freelevels" to the number of levels (default 100)
	pcvar_freelevels = register_cvar("scxpm_freelevels", "100")
#endif
	// moved to plugin_cfg for svencoop - need to do same for cs, to load in client_putinserver...
/*
#if !defined USING_SVEN
	// no roundstart in svencoop - CS might need this if ResetHUD does not work at right times
	register_logevent("roundstart", 2, "0=World triggered", "1=Round_Start");
#endif
*/
#if defined USING_CS
	register_event("DeathMsg","death","a");
#endif
	// added monster xp support
#if defined ALLOW_MONSTERS
	// DO NOT EDIT THIS FILE TO CHANGE CVARS, USE THE "amxx.cfg"
	AgrXP = register_cvar("mxp_agrunt_xp", "15");
	ApaXP = register_cvar("mxp_apache_xp", "20");
	BarXP = register_cvar("mxp_barney_xp", "15");
	BigXP = register_cvar("mxp_bigmomma_xp", "25");
	BulXP = register_cvar("mxp_bullsquid_xp", "5");
	ConXP = register_cvar("mxp_controller_xp", "15");
	GarXP = register_cvar("mxp_gargantua_xp", "50");
	HeaXP = register_cvar("mxp_headcrab_xp", "3");
	HouXP = register_cvar("mxp_houndeye_xp", "5");
	HasXP = register_cvar("mxp_hassassin_xp", "15");
	HgrXP = register_cvar("mxp_hgrunt_xp", "15");
	SciXP = register_cvar("mxp_scientist_xp", "1");
	IslXP = register_cvar("mxp_islave_xp", "10");
	SnaXP = register_cvar("mxp_snark_xp", "1");
	ZomXP = register_cvar("mxp_zombie_xp", "10");
	//HAMSANDWICH
	RegisterHam(Ham_Killed, "func_wall", "monster_killed", 1);
#endif
}
// "main.inl" - may need to move some functions to "xp.inl" for xp handling organization
public plugin_end() {
	if (get_pcvar_num( pcvar_debug ) == 1 )
	{
		log_amx( "%s plugin_end",DEBUG);
	}
	if ( dbc ) {
		SQL_FreeHandle( dbc );
	}
	plugin_ended = true;
	return PLUGIN_HANDLED;
}
#if !defined USING_SVEN
// set gamename
public scxpm_gn() { 
	if( get_pcvar_num(pcvar_gamename) >= 1 )
	{
		new g[32];
		format( g, 31, "SCXPM %s", VERSION );
		forward_return( FMV_STRING, g);
		return FMRES_SUPERCEDE;
	}
	return PLUGIN_HANDLED;
}
#endif
//#if defined USING_SVEN
// added by swmpdg to slow down connection attempt
public plugin_cfg()
{
	// this seems to be very important here, loaded before sql_init - swmpdg
	for( new i = 0; i<33 ;i++ )
	{
		clear_player_flag(loaddata, i);
	}
	plugin_ended = false;
#if defined SQLCVAR
//#if defined USING_SVEN
	new configsDir[64];
	get_configsdir(configsDir, 63);
	server_cmd("exec %s/xp-sql.cfg", configsDir);
//#endif
#endif
	if (get_pcvar_num(pcvar_debug) == 1)
	{
		log_amx( "%s Loading Sven Coop XP Mod version %s",SCXPM,VERSION);
	}
	// incrementally changing task time seconds to load after map loads completely in logs
	set_task( 1.0, "sql_init" ); // timer for sql init - after plugin completely loads instead of in plugin_init
#if defined USING_SVEN
	if (get_pcvar_num( pcvar_debug ) == 1 )
	{
		set_task(10.0, "gravity_check"); // check for gravity to be loaded or unloaded - 5 seconds not long enough, may need 10-15 seconds?
	}
#endif
	// set so only loads data after client connects and is put in server...
	// set to load at least .4 seconds after - allowing sql_init to load?
#if defined NEW_LOOP
	set_task(9.1, "cvar_loopcalc"); // needs to be 7.2 seconds (1.1 + 6.1 in admin_sql_sc.sma delayed load for map cfg) - 7.2 seconds not long enough - loopcalc hopefully more efficient than loopcheck
	// changed to 9.1 for amxx bans
#endif
}
public gravity_check()
{
// doesn't load cvar fast enough... even 5 seconds is not long enough for the set_task
	if (get_pcvar_num( pcvar_gravity ) == 0 )
		log_amx("%s %s has been disabled on this map",DEBUG,Grav);
	else if (get_pcvar_num( pcvar_gravity ) == 1 )
		log_amx("%s %s has been enabled on this map",DEBUG,Grav)
}
public plyr_loaded(id)
{
	if (is_user_connected(id))
	{
#if defined HEALTH_CTRL
		get_max_hp(id);
#endif
#if defined ARMOR_CTRL
		get_max_ap(id);
#endif
#if defined FREE_LEVELS
		if(get_pcvar_num(pcvar_givefree))
			//set_task(0.2, "scxpm_levelcheck", id);
			scxpm_levelcheck(id);
		else
		{
			if(playerlevel[id]==0)
			{
				xp[id] = 0;
				playerlevel[id] = 0;
				skillpoints[id] = 0;
				firstLvl[id]=0;
			}
			scxpm_calcneedxp(id);
			scxpm_getrank(id);	
		}
#else
		scxpm_calcneedxp( id );
		scxpm_getrank( id );
#endif
		isLoaded[id] = true;
		// need to use this for cs as well if I want hp to load on first player spawn quickly
#if defined SPAWN_CTRL
		if(get_pcvar_num(pcvar_spawnctrl))
			load_hpap(id);
#endif
		if (get_pcvar_num( pcvar_gravity ) == 0 )
			client_print(id, print_chat, "%s An alien force disabed your %s on this map. Your skills have been loaded.",SCXPM,Grav);
		else
		{
			gravity_enable(id);
			client_print(id, print_chat, "%s %s has been enabled on this map. Your skills have been loaded.",SCXPM,Grav);
		}
		set_task(5.0, "scxpm_newbiehelp", id)
	}
}
#if defined FREE_LEVELS
// loading too fast - load after gravity_msg?
public scxpm_levelcheck(id)
{
	if(is_user_connected(id))
	{
		if(playerlevel[id] < get_pcvar_num(pcvar_freelevels))
		{
			new freelvlcount = get_pcvar_num(pcvar_freelevels)
			playerlevel[id] = freelvlcount
			skillpoints[id] = freelvlcount
			new helpvar = freelvlcount - 1;
			new Float:m70b = float( helpvar ) * 70.0;
			new Float:mselfm3dot2b = float( helpvar ) * float(helpvar) * 3.5;
			xp[id] = floatround( m70b + mselfm3dot2b + 30.0);
			if(firstLvl[id]==0)
				firstLvl[id]=freelvlcount;
			if(is_user_alive(id))
				SCXPMSkill(id);
			client_print(id, print_chat, "%s You have been given %d free levels.",SCXPM,freelvlcount)
		}
		scxpm_calcneedxp(id);
		scxpm_getrank(id);
	}
}
#endif
#if defined SPAWN_CTRL
public load_hpap(id)
{
	if(is_user_connected(id) && is_user_alive(id))
	{
#if defined HEALTH_CTRL
		if (get_pcvar_num(pcvar_health) > 0)
		{
			if(get_user_health(id) < maxhealth[id])
				set_user_health(id, maxhealth[id])
		}
#endif
#if defined ARMOR_CTRL
		if (get_pcvar_num(pcvar_armor) > 0)
		{
			if(get_user_armor(id) < maxarmor[id])
#if defined USING_CS
				cs_set_user_armor(id, maxarmor[id], CS_ARMOR_VESTHELM)
#else
				set_user_armor( id, maxarmor[id])
#endif				
		}
#endif
	}
}
#endif
public gravity_enable(id)
{
	if(is_user_alive(id) && is_user_connected(id) && gravity[id] > 0 && medals[id]>1)
	{
		set_user_gravity( id, 1.0 - ( 0.015 * gravity[id] ) - ( 0.001 * medals[id]) );
	}
	else if(is_user_alive(id) && is_user_connected(id) && gravity[id] > 0)
	{
		set_user_gravity( id, 1.0 - ( 0.015 * gravity[id] ));
	}
}
#if defined SPEED_CTRL
public UserSpeed(id)
{
	// trying to add "is_user_alive" and "is_user_connected" here to prevent FUN Runtime Error 10? ("invalid player")
	if (g_hasSpeed[id] && is_user_alive(id) && is_user_connected(id))
	{
		// may not need float value here???
		new Float:oldSpeedValue = get_user_maxspeed(id)
		new reducedSpeed = get_pcvar_num(pcvar_reduce)
		set_user_maxspeed(id, oldSpeedValue-reducedSpeed)
	}
	else if (!g_hasSpeed[id] && is_user_alive(id) && is_user_connected(id))
	{
		new Float:oldSpeedValue = get_user_maxspeed(id)
		new reducedSpeed = get_pcvar_num(pcvar_reduce)
		set_user_maxspeed(id, oldSpeedValue+reducedSpeed)
	}
	return PLUGIN_CONTINUE
}
#endif
#if defined COUNT_CTRL
public count_func(id)
{
	// counts towards scxpm_reexp, should be at least every 2 seconds?
	// scxpm_regen runs every 1.0 seconds as of right now, maybe hard-code a frequency? #define REGENFREQ 1.0
	// could use switch here as a counter for level 0 players...
	if (count_reexp[id]>=get_pcvar_num(pcvar_counter)) 
	{
#if defined USING_SVEN
		// adding isLoaded to this hopefully to stop xp gain before stats loaded
		if(maxlvl_count[id]!=1 && isLoaded[id])
			// only sven coop needs scxpm_reexp
			// maxlvl_count is for pcvar_maxlevel - if set to 1, it will not run scxpm_reexp. Max level player will only run scxpm_reexp once.
			scxpm_reexp(id)
#endif
		// reset counter
		count_reexp[id] = 0
#if defined USING_BOTS
		if(!is_user_bot(id))
			// showdata to client here - updated every 1*get_pcvar_num(pcvar_counter) seconds
			scxpm_showdata(id)
#else
		scxpm_showdata(id)
#endif
	}
	else
		count_reexp[id]+=1
}
#endif
#if defined PLYR_CTRL
public zerocheck(id)
{
	if(playerlevel[id]==0 && rank[id]==0)
	{
		if (!onecount[id])
			onecount[id] = true
		else
		{
#if defined USING_SVEN
			scxpm_reexp(id); // reads experience and updates if they gain experience
#endif
#if defined USING_BOTS
			if(!is_user_bot(id))
				scxpm_showdata(id); // shows data on screen in hud for level 0 player
#else
			scxpm_showdata(id); // shows data on screen in hud for level 0 player
#endif
			onecount[id] = false;
		}
	}
	// don't give xp until scxpm is loaded
	else if(playerlevel[id]==0 && rank[id]==22 && !is_user_bot(id))
	{
		if (!onecount[id])
			onecount[id] = true
		else
		{
			scxpm_showdata(id);
			onecount[id] = false;
		}
	}
}
#endif
// This ammo_skill.inl file handles all of the ammo reincarnation
public scxpm_randomammo( id ) {
	new number = random_num(0,6)
#if defined USING_CS
	give_item(id, ammotype[number]);
#else
	new clip,ammo
	if(number==0)
	{
		get_user_ammo(id,2,clip,ammo)
		if(ammo<250)
		{
			give_item(id,Ammo9mm)
			give_item(id,Ammo9mm)
		}
		else
			number=1
	}
	if(number==1)
	{
		get_user_ammo(id,3,clip,ammo)
		if(ammo<36)
		{
			give_item(id,Ammo357)
			give_item(id,Ammo357)
			give_item(id,Ammo357)
		}
		else
			number=2
	}
	if(number==2)
	{
		get_user_ammo(id,7,clip,ammo)
		if(ammo<125)
		{
			give_item(id,AmmoBS)
			give_item(id,AmmoBS)
			give_item(id,AmmoBS)
		}
		else
			number=3
	}
	if(number==3)
	{
		get_user_ammo(id,9,clip,ammo)
		if(ammo<100)
		{
			give_item(id,AmmoGC)
			give_item(id,AmmoGC)
		}
		else
			number=4
	}
	if(number==4)
	{
		get_user_ammo(id,6,clip,ammo)
		if(ammo<50)
		{
			give_item(id,AmmoCB)
			give_item(id,AmmoCB)
		}
		else
			number=5
	}
	if(number==5)
	{
		get_user_ammo(id,8,clip,ammo)
		if(ammo<5)
			give_item(id,AmmoRPG)
		else
			number=6
	}
	if(number==6)
	{
		get_user_ammo(id,23,clip,ammo)
		if(ammo<15)
		{
			give_item(id,Ammo762)
			give_item(id,Ammo762)
			give_item(id,Ammo556)
			give_item(id,Ammo556)
			give_item(id,AmmoSC)
			give_item(id,AmmoSC)
			give_item(id,AmmoSC)
			give_item(id,AmmoSC)
			give_item(id,AmmoSC)
		}
	}
#endif
}
#if defined USING_CS
cs_hp_weapon(id)
{
	new clip,ammo
	switch(get_user_weapon(id,clip,ammo))
	{
		case 1: /* P228 */
		{
			get_user_ammo(id,21,clip,ammo)
			if(ammo<rammo[id]+13)
			{
				give_item(id,"ammo_357sig")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		// no weapon 2 index in counter-strike
		case 3: /* SCOUT */
		{							
			get_user_ammo(id,3,clip,ammo)
			if(ammo<20)
			{
				give_item(id,"ammo_762nato")
			}
			else
			{
				scxpm_randomammo(id)
			}									
		}
		case 4: /* HEGRENADE */
		{
			scxpm_randomammo(id)
		}
		case 5: /* XM1014 */
		{
			get_user_ammo(id,5,clip,ammo)
			if(ammo<21)
			{
				give_item(id,"ammo_buckshot")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 6: /* C4 */
		{
			scxpm_randomammo(id)
		}
		case 7: /* MAC10 */
		{
			get_user_ammo(id,7,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_45acp")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 8: /* AUG */
		{
			get_user_ammo(id,8,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 9: /* SMOKEGRENADE */
		{
			scxpm_randomammo(id)
		}
		case 10: /* ELITES */
		{
			get_user_ammo(id,10,clip,ammo)
			if(ammo<100)
			{
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 11: /* FIVESEVEN */
		{
			get_user_ammo(id,11,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_57mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 12: /* UMP45 */
		{
			get_user_ammo(id,12,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_45acp")
				give_item(id, "ammo_45acp")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 13: /* SG550 */
		{
			get_user_ammo(id,13,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 14: /* GALIL */ 
		{
			get_user_ammo(id,14,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 15: /* FAMAS */ 
		{
			get_user_ammo(id,15,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 16: /* USP */
		{
			get_user_ammo(id,16,clip,ammo)
			if(ammo<250)
			{
				give_item(id,"ammo_45acp")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 17: /* GLOCK18 */
		{
			get_user_ammo(id,17,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 18: /* AWP */
		{
			get_user_ammo(id,18,clip,ammo)
			if(ammo<20)
			{
				give_item(id,"ammo_338magnum")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 19: /* MP5NAVY */
		{
			get_user_ammo(id,19,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 20: /* M249 */
		{
			get_user_ammo(id,20,clip,ammo)
			if(ammo<100+rammo[id])
			{
				give_item(id,"ammo_556natobox")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 21: /* M3 */
		{
			get_user_ammo(id,21,clip,ammo)
			if(ammo<24)
			{
				give_item(id,"ammo_buckshot")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 22: /* M4A1 */
		{
			get_user_ammo(id,22,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 23: /* TMP */
		{
			// can go up to 120...
			get_user_ammo(id,23,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_9mm")
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 24: /* G3SG1 */
		{
			get_user_ammo(id,24,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_762nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 25: /* FLASHBANG */
		{
			scxpm_randomammo(id)
		}
		case 26: /* DEAGLE */
		{
			get_user_ammo(id,26,clip,ammo)
			if(ammo<21)
			{
				give_item(id,"ammo_50ae")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 27: /* SG552 */
		{
			get_user_ammo(id,27,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 28: /* AK47 */
		{
			get_user_ammo(id,27,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id,"ammo_762nato")	
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 29: /* KNIFE */
		{
			scxpm_randomammo(id)
		}
		case 30: /* P90 */
		{
			get_user_ammo(id,30,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id,"ammo_57mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
	}
}
// armor regeneration in ammo skill
cs_ap_weapon(id)
{
	// support of reading CS weapons for ammo added by swmpdg - may 07 2016
	new clip,ammo
	switch(get_user_weapon(id,clip,ammo))
	{
		case 1: /* P228 */
		{
			get_user_ammo(id,21,clip,ammo)
			if(ammo<rammo[id]+13)
			{
				give_item(id,"ammo_357sig")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		// no weapon 2 index in counter-strike
		case 3: /* SCOUT */
		{							
			get_user_ammo(id,3,clip,ammo)
			if(ammo<20)
			{
				give_item(id,"ammo_762nato")
			}
			else
			{
				scxpm_randomammo(id)
			}									
		}
		case 4: /* HEGRENADE */
		{
			scxpm_randomammo(id)
		}
		case 5: /* XM1014 */
		{
			get_user_ammo(id,5,clip,ammo)
			if(ammo<21)
			{
				give_item(id,"ammo_buckshot")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 6: /* C4 */
		{
			scxpm_randomammo(id)
		}
		case 7: /* MAC10 */
		{
			get_user_ammo(id,7,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_45acp")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 8: /* AUG */
		{
			get_user_ammo(id,8,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 9: /* SMOKEGRENADE */
		{
			scxpm_randomammo(id)
		}
		case 10: /* ELITES */
		{
			get_user_ammo(id,10,clip,ammo)
			if(ammo<100)
			{
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 11: /* FIVESEVEN */
		{
			get_user_ammo(id,11,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_57mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 12: /* UMP45 */
		{
			get_user_ammo(id,12,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_45acp")
				give_item(id, "ammo_45acp")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 13: /* SG550 */
		{
			get_user_ammo(id,13,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 14: /* GALIL */ 
		{
			get_user_ammo(id,14,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 15: /* FAMAS */ 
		{
			get_user_ammo(id,15,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 16: /* USP */
		{
			get_user_ammo(id,16,clip,ammo)
			if(ammo<250)
			{
				give_item(id,"ammo_45acp")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 17: /* GLOCK18 */
		{
			get_user_ammo(id,17,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 18: /* AWP */
		{
			get_user_ammo(id,18,clip,ammo)
			if(ammo<20)
			{
				give_item(id,"ammo_338magnum")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 19: /* MP5NAVY */
		{
			get_user_ammo(id,19,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 20: /* M249 */
		{
			get_user_ammo(id,20,clip,ammo)
			if(ammo<100+rammo[id])
			{
				give_item(id,"ammo_556natobox")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 21: /* M3 */
		{
			get_user_ammo(id,21,clip,ammo)
			if(ammo<24)
			{
				give_item(id,"ammo_buckshot")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 22: /* M4A1 */
		{
			get_user_ammo(id,22,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 23: /* TMP */
		{
			// can go up to 120...
			get_user_ammo(id,23,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_9mm")
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 24: /* G3SG1 */
		{
			get_user_ammo(id,24,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_762nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 25: /* FLASHBANG */
		{
			scxpm_randomammo(id)
		}
		case 26: /* DEAGLE */
		{
			get_user_ammo(id,26,clip,ammo)
			if(ammo<21)
			{
				give_item(id,"ammo_50ae")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 27: /* SG552 */
		{
			get_user_ammo(id,27,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 28: /* AK47 */
		{
			get_user_ammo(id,27,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id,"ammo_762nato")	
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 29: /* KNIFE */
		{
			scxpm_randomammo(id)
		}
		case 30: /* P90 */
		{
			get_user_ammo(id,30,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id,"ammo_57mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
	}
}
cs_hpap_weapon(id)
{
	// support of reading CS weapons for ammo added by swmpdg - may 07 2016
	new clip,ammo
	switch(get_user_weapon(id,clip,ammo))
	{
		case 1: /* P228 */
		{
			get_user_ammo(id,21,clip,ammo)
			if(ammo<rammo[id]+13)
			{
				give_item(id,"ammo_357sig")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		// no weapon 2 index in counter-strike
		case 3: /* SCOUT */
		{							
			get_user_ammo(id,3,clip,ammo)
			if(ammo<20)
			{
				give_item(id,"ammo_762nato")
			}
			else
			{
				scxpm_randomammo(id)
			}									
		}
		case 4: /* HEGRENADE */
		{
			scxpm_randomammo(id)
		}
		case 5: /* XM1014 */
		{
			get_user_ammo(id,5,clip,ammo)
			if(ammo<21)
			{
				give_item(id,"ammo_buckshot")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 6: /* C4 */
		{
			scxpm_randomammo(id)
		}
		case 7: /* MAC10 */
		{
			get_user_ammo(id,7,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_45acp")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 8: /* AUG */
		{
			get_user_ammo(id,8,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 9: /* SMOKEGRENADE */
		{
			scxpm_randomammo(id)
		}
		case 10: /* ELITES */
		{
			get_user_ammo(id,10,clip,ammo)
			if(ammo<100)
			{
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 11: /* FIVESEVEN */
		{
			get_user_ammo(id,11,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_57mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 12: /* UMP45 */
		{
			get_user_ammo(id,12,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_45acp")
				give_item(id, "ammo_45acp")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 13: /* SG550 */
		{
			get_user_ammo(id,13,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 14: /* GALIL */ 
		{
			get_user_ammo(id,14,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 15: /* FAMAS */ 
		{
			get_user_ammo(id,15,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 16: /* USP */
		{
			get_user_ammo(id,16,clip,ammo)
			if(ammo<250)
			{
				give_item(id,"ammo_45acp")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 17: /* GLOCK18 */
		{
			get_user_ammo(id,17,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 18: /* AWP */
		{
			get_user_ammo(id,18,clip,ammo)
			if(ammo<20)
			{
				give_item(id,"ammo_338magnum")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 19: /* MP5NAVY */
		{
			get_user_ammo(id,19,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 20: /* M249 */
		{
			get_user_ammo(id,20,clip,ammo)
			if(ammo<100+rammo[id])
			{
				give_item(id,"ammo_556natobox")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 21: /* M3 */
		{
			get_user_ammo(id,21,clip,ammo)
			if(ammo<24)
			{
				give_item(id,"ammo_buckshot")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 22: /* M4A1 */
		{
			get_user_ammo(id,22,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 23: /* TMP */
		{
			// can go up to 120...
			get_user_ammo(id,23,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_9mm")
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 24: /* G3SG1 */
		{
			get_user_ammo(id,24,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_762nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 25: /* FLASHBANG */
		{
			scxpm_randomammo(id)
		}
		case 26: /* DEAGLE */
		{
			get_user_ammo(id,26,clip,ammo)
			if(ammo<21)
			{
				give_item(id,"ammo_50ae")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 27: /* SG552 */
		{
			get_user_ammo(id,27,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 28: /* AK47 */
		{
			get_user_ammo(id,27,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id,"ammo_762nato")	
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 29: /* KNIFE */
		{
			scxpm_randomammo(id)
		}
		case 30: /* P90 */
		{
			get_user_ammo(id,30,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id,"ammo_57mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
	}	
}
cs_only_weapon(id)
{
	new clip,ammo
	switch(get_user_weapon(id,clip,ammo))
	{
		case 1: /* P228 */
		{
			get_user_ammo(id,21,clip,ammo)
			if(ammo<rammo[id]+13)
			{
				give_item(id,"ammo_357sig")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 3: /* SCOUT */
		{							
			get_user_ammo(id,3,clip,ammo)
			if(ammo<20)
			{
				give_item(id,"ammo_762nato")
			}
			else
			{
				scxpm_randomammo(id)
			}									
		}
		case 4: /* HEGRENADE */
		{
			scxpm_randomammo(id)
		}
		case 5: /* XM1014 */
		{
			get_user_ammo(id,5,clip,ammo)
			if(ammo<21)
			{
				give_item(id,"ammo_buckshot")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 6: /* C4 */
		{
			scxpm_randomammo(id)
		}
		case 7: /* MAC10 */
		{
			get_user_ammo(id,7,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_45acp")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 8: /* AUG */
		{
			get_user_ammo(id,8,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 9: /* SMOKEGRENADE */
		{
			scxpm_randomammo(id)
		}
		case 10: /* ELITES */
		{
			get_user_ammo(id,10,clip,ammo)
			if(ammo<100)
			{
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 11: /* FIVESEVEN */
		{
			get_user_ammo(id,11,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_57mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 12: /* UMP45 */
		{
			get_user_ammo(id,12,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_45acp")
				give_item(id, "ammo_45acp")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 13: /* SG550 */
		{
			get_user_ammo(id,13,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 14: /* GALIL */ 
		{
			get_user_ammo(id,14,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 15: /* FAMAS */ 
		{
			get_user_ammo(id,15,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 16: /* USP */
		{
			get_user_ammo(id,16,clip,ammo)
			if(ammo<250)
			{
				give_item(id,"ammo_45acp")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 17: /* GLOCK18 */
		{
			get_user_ammo(id,17,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 18: /* AWP */
		{
			get_user_ammo(id,18,clip,ammo)
			if(ammo<20)
			{
				give_item(id,"ammo_338magnum")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 19: /* MP5NAVY */
		{
			get_user_ammo(id,19,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 20: /* M249 */
		{
			get_user_ammo(id,20,clip,ammo)
			if(ammo<100+rammo[id])
			{
				give_item(id,"ammo_556natobox")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 21: /* M3 */
		{
			get_user_ammo(id,21,clip,ammo)
			if(ammo<24)
			{
				give_item(id,"ammo_buckshot")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 22: /* M4A1 */
		{
			get_user_ammo(id,22,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 23: /* TMP */
		{
			// can go up to 120...
			get_user_ammo(id,23,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_9mm")
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 24: /* G3SG1 */
		{
			get_user_ammo(id,24,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_762nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 25: /* FLASHBANG */
		{
			scxpm_randomammo(id)
		}
		case 26: /* DEAGLE */
		{
			get_user_ammo(id,26,clip,ammo)
			if(ammo<21)
			{
				give_item(id,"ammo_50ae")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 27: /* SG552 */
		{
			get_user_ammo(id,27,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 28: /* AK47 */
		{
			get_user_ammo(id,27,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id,"ammo_762nato")	
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 29: /* KNIFE */
		{
			scxpm_randomammo(id)
		}
		case 30: /* P90 */
		{
			get_user_ammo(id,30,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id,"ammo_57mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
	}	
}
#endif
#if defined USING_SVEN
// hp regen in ammo skill
sc_hp_weapon(id)
{
	new clip,ammo
	switch(get_user_weapon(id,clip,ammo))
	{
		case 1: /* Crowbar */
			scxpm_randomammo(id)
		case 2: /* 9mm Handgun */
		{
			get_user_ammo(id,2,clip,ammo)
			if(ammo<250)
				give_item(id,Ammo9mm)
			else
				scxpm_randomammo(id)
		}
		case 3: /* 357 (Revolver) */
		{
			get_user_ammo(id,3,clip,ammo)
			if(ammo<36)
			{
				give_item(id,Ammo357)
				give_item(id,Ammo357)
			}
			else
				scxpm_randomammo(id)
		}
		case 4: /* 9mm AR = MP5 */
		{
			get_user_ammo(id,4,clip,ammo)
			if(ammo<250)
			{
				give_item(id,Ammo9mm)
				give_item(id,Ammo9mm)
			}
			else
				scxpm_randomammo(id)
		}
		case 6: /* Crossbow */
		{
			get_user_ammo(id,6,clip,ammo)
			if(ammo<50)
			{
				give_item(id,AmmoCB)
				give_item(id,AmmoCB)
			}
			else
				scxpm_randomammo(id)
		}
		case 7: /* Shotgun */
		{
			get_user_ammo(id,7,clip,ammo)
			if(ammo<125)
			{
				give_item(id,AmmoBS)
				give_item(id,AmmoBS)
			}
			else
				scxpm_randomammo(id)
		}
		case 8: /* RPG Launcher */
		{
			get_user_ammo(id,8,clip,ammo)
			if(ammo<5)
				give_item(id,AmmoRPG)
			else
				scxpm_randomammo(id)
		}
		case 9: /* Gauss Cannon */
		{
			get_user_ammo(id,9,clip,ammo)
			if(ammo<100)
			{
				give_item(id,AmmoGC)
				give_item(id,AmmoGC)
			}
			else
				scxpm_randomammo(id)
		}
		case 10: /* Egon */
		{
			get_user_ammo(id,10,clip,ammo)
			if(ammo<100)
			{
				give_item(id,AmmoGC)
				give_item(id,AmmoGC)
			}
			else
				scxpm_randomammo(id)
		}
		case 11: /* Hornetgun */
			scxpm_randomammo(id)
		case 12: /* Handgrenade */
			scxpm_randomammo(id)
		case 13: /* Tripmine */
			scxpm_randomammo(id)
		case 14: /* Satchels */ // fixed, was 13
			scxpm_randomammo(id)
		case 15: /* Snarks */ // fixed, was 13
			scxpm_randomammo(id)
		case 16: /* Uzi Akimbo */
		{
			get_user_ammo(id,16,clip,ammo)
			if(ammo<250)
			{
				give_item(id,Ammo9mm)
				give_item(id,Ammo9mm)
			}
			else
				scxpm_randomammo(id)
		}
		case 17: /* Uzi */
		{
			get_user_ammo(id,17,clip,ammo)
			if(ammo<100)
			{
				give_item(id,Ammo9mm)
				give_item(id,Ammo9mm)
			}
			else
				scxpm_randomammo(id)
		}
		case 18: /* Medkit */
		{
			scxpm_randomammo(id)
			if(rhealth[id] > 0)
			{
				if(get_user_health(id)<100)
					set_user_health(id,get_user_health(id)+1)
#if defined HEALTH_CTRL
				else if(get_user_health(id)<maxhealth[id])
#else
				else if(get_user_health(id)<health[id]+100+(medals[id]-1)+speed[id])
#endif
#if defined LUCK_CTRL
					if(isLucky[id])
						set_user_health(id, get_user_health(id)+1)
					else
						rhealthwait[id]+=get_hprate(id)
#else
					rhealthwait[id]+=get_hprate(id)
#endif // luck
			}
		}
		case 20: /* Pipewrench */
			scxpm_randomammo(id)
		case 21: /* Minigun */
		{
			get_user_ammo(id,21,clip,ammo)
			if(ammo<100)
			{
				give_item(id,Ammo556)
				give_item(id,Ammo556)
			}
			else
				scxpm_randomammo(id)
		}
		case 22: /* Grapple */
			scxpm_randomammo(id)
		case 23: /* Sniper Rifle */
		{
			get_user_ammo(id,23,clip,ammo)
			if(ammo<15)
			{
				give_item(id,Ammo762)
				give_item(id,Ammo762)
			}
			else
				scxpm_randomammo(id)
		}
		case 24: /* M249 Saw */
		{
			get_user_ammo(id,24,clip,ammo)
			//if(ammo<600)
			if(ammo<100)
			{
				give_item(id,Ammo556)
				give_item(id,Ammo556)
			}
			else
				scxpm_randomammo(id)
		}
		case 25: /* M16 */
		{
			get_user_ammo(id,25,clip,ammo)
			if(ammo<600)
			{
				give_item(id,Ammo556)
				give_item(id,AmmoARG)
			}
			else if(ammo>=600)
			{
				give_item(id,AmmoARG)
				scxpm_randomammo(id)
			}
		}
		case 26: /* Spore Launcher */
		{
			get_user_ammo(id,26,clip,ammo)
			if(ammo<30)
			{
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
			}
			else
				scxpm_randomammo(id)
		}
		case 27: /* Desert Eagle */
		{
			get_user_ammo(id,27,clip,ammo)
			if(ammo<36)
			{
				give_item(id,Ammo357)
				give_item(id,Ammo357)
				give_item(id,Ammo357)
			}
			else
				scxpm_randomammo(id)
		}
		case 28: /* Shock Roach */
			// removed battery, because it "falls through map" on Escape Series...??
			scxpm_randomammo(id)
	}
}
sc_ap_weapon(id)
{
	new clip,ammo
	switch(get_user_weapon(id,clip,ammo))
	{
		case 1: /* Crowbar */
		{
			scxpm_randomammo(id)
			if(rarmor[id] > 0)
			{
				if (get_user_armor(id) < 100)
					set_user_armor(id, get_user_armor(id)+1)
#if defined ARMOR_CTRL
				else if (get_user_armor(id)<maxarmor[id])
#else
				else if (get_user_armor(id) < 100+armor[id]+(medals[id]-1)+speed[id])
#endif
#if defined LUCK_CTRL
					if(isLucky[id])
						set_user_armor(id, get_user_armor(id)+1)
					else
						rarmorwait[id]+=get_aprate(id)
#else
					rarmorwait[id]+=get_aprate(id)
#endif // luck
			}
		}
		case 2: /* 9mm Handgun */
		{
			get_user_ammo(id,2,clip,ammo)
			if(ammo<250)
			{
				give_item(id,Ammo9mm)
			}
			else
				scxpm_randomammo(id)
		}
		case 3: /* 357 (Revolver) */
		{
			get_user_ammo(id,3,clip,ammo)
			if(ammo<36)
			{
				give_item(id,Ammo357)
				give_item(id,Ammo357)
			}
			else
				scxpm_randomammo(id)
		}
		case 4: /* 9mm AR = MP5 */
		{
			get_user_ammo(id,4,clip,ammo)
			if(ammo<250)
			{
				give_item(id,Ammo9mm)
				give_item(id,Ammo9mm)
			}
			else
				scxpm_randomammo(id)
		}
		case 6: /* Crossbow */
		{
			get_user_ammo(id,6,clip,ammo)
			if(ammo<50)
			{
				give_item(id,AmmoCB)
				give_item(id,AmmoCB)
			}
			else
				scxpm_randomammo(id)
		}
		case 7: /* Shotgun */
		{
			get_user_ammo(id,7,clip,ammo)
			if(ammo<125)
			{
				give_item(id,AmmoBS)
				give_item(id,AmmoBS)
			}
			else
				scxpm_randomammo(id)
		}
		case 8: /* RPG Launcher */
		{
			get_user_ammo(id,8,clip,ammo)
			if(ammo<5)
				give_item(id,AmmoRPG)
			else
				scxpm_randomammo(id)
		}
		case 9: /* Gauss Cannon */
		{
			get_user_ammo(id,9,clip,ammo)
			if(ammo<100)
			{
				give_item(id,AmmoGC)
				give_item(id,AmmoGC)
			}
			else
				scxpm_randomammo(id)
		}
		case 10: /* Egon */
		{
			get_user_ammo(id,10,clip,ammo)
			if(ammo<100)
			{
				give_item(id,AmmoGC)
				give_item(id,AmmoGC)
			}
			else
				scxpm_randomammo(id)
		}
		case 11: /* Hornetgun */
			scxpm_randomammo(id)
		case 12: /* Handgrenade */
			scxpm_randomammo(id)
		case 13: /* Tripmine */
			scxpm_randomammo(id)
		case 14: /* Satchels */
			scxpm_randomammo(id)
		case 15: /* Snarks */
			scxpm_randomammo(id)
		case 16: /* Uzi Akimbo */
		{
			get_user_ammo(id,16,clip,ammo)
			if(ammo<250)
			{
				give_item(id,Ammo9mm)
				give_item(id,Ammo9mm)
			}
			else
				scxpm_randomammo(id)
		}
		case 17: /* Uzi */
		{
			get_user_ammo(id,17,clip,ammo)
			if(ammo<100)
			{
				give_item(id,Ammo9mm)
				give_item(id,Ammo9mm)
			}
			else
				scxpm_randomammo(id)
		}
		case 18: /* Medkit */
			scxpm_randomammo(id)
		case 20: /* Pipewrench */
		{
			scxpm_randomammo(id)
			if(rarmor[id] > 0)
			{
				if (get_user_armor(id) < 100)
					set_user_armor(id, get_user_armor(id)+1)
#if defined ARMOR_CTRL
				else if (get_user_armor(id)<maxarmor[id])
#else
				else if (get_user_armor(id) < 100+armor[id]+(medals[id]-1)+speed[id])
#endif
#if defined LUCK_CTRL
					if(isLucky[id])
						set_user_armor(id, get_user_armor(id)+1)
					else
						rarmorwait[id]+=get_aprate(id)
#else
					rarmorwait[id]+=get_aprate(id)
#endif // luck
			}
		}
		case 21: /* Minigun */
		{
			get_user_ammo(id,21,clip,ammo)
			if(ammo<100)
			{
				give_item(id,Ammo556)
				give_item(id,Ammo556)
			}
			else
				scxpm_randomammo(id)
		}
		case 22: /* Grapple */
			scxpm_randomammo(id)
		case 23: /* Sniper Rifle */
		{
			get_user_ammo(id,23,clip,ammo)
			if(ammo<15)
			{
				give_item(id,Ammo762)
				give_item(id,Ammo762)
			}
			else
				scxpm_randomammo(id)
		}
		case 24: /* M249 Saw */
		{
			get_user_ammo(id,24,clip,ammo)
			//if(ammo<600)
			if(ammo<100)
			{
				give_item(id,Ammo556)
				give_item(id,Ammo556)
			}
			else
				scxpm_randomammo(id)
		}
		case 25: /* M16 */
		{
			get_user_ammo(id,25,clip,ammo)
			if(ammo<600)
			{
				give_item(id,Ammo556)
				give_item(id,AmmoARG)
			}
			else if(ammo>=600)
			{
				give_item(id,AmmoARG)
				scxpm_randomammo(id)
			}
		}
		case 26: /* Spore Launcher */
		{
			get_user_ammo(id,26,clip,ammo)
			if(ammo<30)
			{
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
			}
			else
				scxpm_randomammo(id)
		}
		case 27: /* Desert Eagle */
		{
			get_user_ammo(id,27,clip,ammo)
			if(ammo<36)
			{
				give_item(id,Ammo357)
				give_item(id,Ammo357)
				give_item(id,Ammo357)
			}
			else
				scxpm_randomammo(id)
		}
		case 28: /* Shock Roach */
			scxpm_randomammo(id)
	}
}
sc_hpap_weapon(id)
{
	new clip,ammo
	switch(get_user_weapon(id,clip,ammo))
	{
		case 1: /* Crowbar */
		{
			scxpm_randomammo(id)
			if(rarmor[id] > 0)
			{
				if (get_user_armor(id) < 100)
					set_user_armor(id, get_user_armor(id)+1)
#if defined ARMOR_CTRL
				else if (get_user_armor(id)<maxarmor[id])
#else
				else if (get_user_armor(id) < 100+armor[id]+(medals[id]-1)+speed[id])	
#endif
#if defined LUCK_CTRL
					if(isLucky[id])
						set_user_armor(id, get_user_armor(id)+1)
					else
						rarmorwait[id]+=get_aprate(id)
#else
					rarmorwait[id]+=get_aprate(id)
#endif // luck
			}
		}
		case 2: /* 9mm Handgun */
		{
			get_user_ammo(id,2,clip,ammo)
			if(ammo<250)
			{
				give_item(id,Ammo9mm)
			}
			else
				scxpm_randomammo(id)
		}
		case 3: /* 357 (Revolver) */
		{
			get_user_ammo(id,3,clip,ammo)
			if(ammo<36)
			{
				give_item(id,Ammo357)
				give_item(id,Ammo357)
			}
			else
				scxpm_randomammo(id)
		}
		case 4: /* 9mm AR = MP5 */
		{
			get_user_ammo(id,4,clip,ammo)
			if(ammo<250)
			{
				give_item(id,Ammo9mm)
				give_item(id,Ammo9mm)
			}
			else
				scxpm_randomammo(id)
		}
		case 6: /* Crossbow */
		{
			get_user_ammo(id,6,clip,ammo)
			if(ammo<50)
			{
				give_item(id,AmmoCB)
				give_item(id,AmmoCB)
			}
			else
				scxpm_randomammo(id)
		}
		case 7: /* Shotgun */
		{
			get_user_ammo(id,7,clip,ammo)
			if(ammo<125)
			{
				give_item(id,AmmoBS)
				give_item(id,AmmoBS)
			}
			else
				scxpm_randomammo(id)
		}
		case 8: /* RPG Launcher */
		{
			get_user_ammo(id,8,clip,ammo)
			if(ammo<5)
			{
				give_item(id,AmmoRPG)
			}
			else
				scxpm_randomammo(id)
		}
		case 9: /* Gauss Cannon */
		{
			get_user_ammo(id,9,clip,ammo)
			if(ammo<100)
			{
				give_item(id,AmmoGC)
				give_item(id,AmmoGC)
			}
			else
				scxpm_randomammo(id)
		}
		case 10: /* Egon */
		{
			get_user_ammo(id,10,clip,ammo)
			if(ammo<100)
			{
				give_item(id,AmmoGC)
				give_item(id,AmmoGC)
			}
			else
				scxpm_randomammo(id)
		}
		case 11: /* Hornetgun */
			scxpm_randomammo(id)
		case 12: /* Handgrenade */
			scxpm_randomammo(id)
		case 13: /* Tripmine */
			scxpm_randomammo(id)
		case 14: /* Satchels */
			scxpm_randomammo(id)
		case 15: /* Snarks */
			scxpm_randomammo(id)
		case 16: /* Uzi Akimbo */
		{
			get_user_ammo(id,16,clip,ammo)
			if(ammo<250)
			{
				give_item(id,Ammo9mm)
				give_item(id,Ammo9mm)
			}
			else
				scxpm_randomammo(id)
		}
		case 17: /* Uzi */
		{
			get_user_ammo(id,17,clip,ammo)
			if(ammo<100)
			{
				give_item(id,Ammo9mm)
				give_item(id,Ammo9mm)
			}
			else
				scxpm_randomammo(id)
		}
		case 18: /* Medkit */
		{
			scxpm_randomammo(id)
			if(rhealth[id] > 0)
			{
				if(get_user_health(id)<100+health[id])
					set_user_health(id,get_user_health(id)+1)
#if defined HEALTH_CTRL
				else if(get_user_health(id)<maxhealth[id])
#else
				else if(get_user_health(id)<health[id]+100+(medals[id]-1)+speed[id])
#endif
#if defined LUCK_CTRL
					if(isLucky[id])
						set_user_health(id,get_user_health(id)+1)
					else
						rhealthwait[id]+=get_hprate(id)
#else
					rhealthwait[id]+=get_hprate(id)
#endif // luck
			}
		}
		case 20: /* Pipewrench */
		{
			scxpm_randomammo(id)
			if(rarmor[id] > 0)
			{
				if (get_user_armor(id) < 100)
					set_user_armor(id, get_user_armor(id)+1)
#if defined ARMOR_CTRL
				else if (get_user_armor(id)<maxarmor[id])
#else
				else if (get_user_armor(id) < 100+armor[id]+(medals[id]-1)+speed[id])
#endif
#if defined LUCK_CTRL
					if(isLucky[id])
						set_user_armor(id, get_user_armor(id)+1)
					else
						rarmorwait[id]+=get_aprate(id)
#else
					rarmorwait[id]+=get_aprate(id)
#endif // luck
			}
		}
		case 21: /* Minigun */
		{
			get_user_ammo(id,21,clip,ammo)
			if(ammo<100)
			{
				give_item(id,Ammo556)
				give_item(id,Ammo556)
			}
			else
				scxpm_randomammo(id)
		}
		case 22: /* Grapple */
			scxpm_randomammo(id)
		case 23: /* Sniper Rifle */
		{
			get_user_ammo(id,23,clip,ammo)
			if(ammo<15)
			{
				give_item(id,Ammo762)
				give_item(id,Ammo762)
			}
			else
				scxpm_randomammo(id)
		}
		case 24: /* M249 Saw */
		{
			get_user_ammo(id,24,clip,ammo)
			//if(ammo<600)
			if(ammo<100)
			{
				give_item(id,Ammo556)
				give_item(id,Ammo556)
			}
			else
				scxpm_randomammo(id)
		}
		case 25: /* M16 */
		{
			get_user_ammo(id,25,clip,ammo)
			if(ammo<600)
			{
				give_item(id,Ammo556)
				give_item(id,AmmoARG)
			}
			else if(ammo>=600)
			{
				give_item(id,AmmoARG)
				scxpm_randomammo(id)
			}
		}
		case 26: /* Spore Launcher */
		{
			get_user_ammo(id,26,clip,ammo)
			if(ammo<30)
			{
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
			}
			else
				scxpm_randomammo(id)
		}
		case 27: /* Desert Eagle */
		{
			get_user_ammo(id,27,clip,ammo)
			if(ammo<36)
			{
				give_item(id,Ammo357)
				give_item(id,Ammo357)
				give_item(id,Ammo357)
			}
			else
				scxpm_randomammo(id)
		}
		case 28: /* Shock Roach */
			scxpm_randomammo(id)
	}	
}
sc_only_weapon(id)
{
	new clip,ammo
	switch(get_user_weapon(id,clip,ammo))
	{
		case 1: /* Crowbar */
			scxpm_randomammo(id)
		case 2: /* 9mm Handgun */
		{
			get_user_ammo(id,2,clip,ammo)
			if(ammo<250)
				give_item(id,Ammo9mm)
			else
				scxpm_randomammo(id)
		}
		case 3: /* 357 (Revolver) */
		{
			get_user_ammo(id,3,clip,ammo)
			if(ammo<36)
			{
				give_item(id,Ammo357)
				give_item(id,Ammo357)
			}
			else
				scxpm_randomammo(id)
		}
		case 4: /* 9mm AR = MP5 */
		{
			get_user_ammo(id,4,clip,ammo)
			if(ammo<250)
			{
				give_item(id,Ammo9mm)
				give_item(id,Ammo9mm)
			}
			else
				scxpm_randomammo(id)
		}
		case 6: /* Crossbow */
		{
			get_user_ammo(id,6,clip,ammo)
			if(ammo<50)
			{
				give_item(id,AmmoCB)
				give_item(id,AmmoCB)
			}
			else
				scxpm_randomammo(id)
		}
		case 7: /* Shotgun */
		{
			get_user_ammo(id,7,clip,ammo)
			if(ammo<125)
			{
				give_item(id,AmmoBS)
				give_item(id,AmmoBS)
			}
			else
				scxpm_randomammo(id)
		}
		case 8: /* RPG Launcher */
		{
			get_user_ammo(id,8,clip,ammo)
			if(ammo<5)
				give_item(id,AmmoRPG)
			else
				scxpm_randomammo(id)
		}
		case 9: /* Gauss Cannon */
		{
			get_user_ammo(id,9,clip,ammo)
			if(ammo<100)
			{
				give_item(id,AmmoGC)
				give_item(id,AmmoGC)
			}
			else
				scxpm_randomammo(id)
		}
		case 10: /* Egon */
		{
			get_user_ammo(id,10,clip,ammo)
			if(ammo<100)
			{
				give_item(id,AmmoGC)
				give_item(id,AmmoGC)
			}
			else
				scxpm_randomammo(id)
		}
		case 11: /* Hornetgun */
			scxpm_randomammo(id)
		case 12: /* Handgrenade */
			scxpm_randomammo(id)
		case 13: /* Tripmine */
			scxpm_randomammo(id)
		case 14: /* Satchels */
			scxpm_randomammo(id)
		case 15: /* Snarks */
			scxpm_randomammo(id)
		case 16: /* Uzi Akimbo */
		{
			get_user_ammo(id,16,clip,ammo)
			if(ammo<250)
			{
				give_item(id,Ammo9mm)
				give_item(id,Ammo9mm)
			}
			else
				scxpm_randomammo(id)
		}
		case 17: /* Uzi */
		{
			get_user_ammo(id,17,clip,ammo)
			if(ammo<100)
			{
				give_item(id,Ammo9mm)
				give_item(id,Ammo9mm)
			}
			else
				scxpm_randomammo(id)
		}
		case 18: /* Medkit */
			scxpm_randomammo(id)
		case 20: /* Pipewrench */
			scxpm_randomammo(id)
		case 21: /* Minigun */
		{
			get_user_ammo(id,21,clip,ammo)
			if(ammo<100)
			{
				give_item(id,Ammo556)
				give_item(id,Ammo556)
			}
			else
				scxpm_randomammo(id)
		}
		case 22: /* Grapple */
			scxpm_randomammo(id)
		case 23: /* Sniper Rifle */
		{
			get_user_ammo(id,23,clip,ammo)
			if(ammo<15)
			{
				give_item(id,Ammo762)
				give_item(id,Ammo762)
			}
			else
				scxpm_randomammo(id)
		}
		case 24: /* M249 Saw */
		{
			get_user_ammo(id,24,clip,ammo)
			//if(ammo<600)
			if(ammo<100)
			{
				give_item(id,Ammo556)
				give_item(id,Ammo556)
			}
			else
				scxpm_randomammo(id)
		}
		case 25: /* M16 */
		{
			get_user_ammo(id,25,clip,ammo)
			if(ammo<600)
			{
				give_item(id,Ammo556)
				give_item(id,AmmoARG)
			}
			else if(ammo>=600)
			{
				give_item(id,AmmoARG)
				scxpm_randomammo(id)
			}
		}
		case 26: /* Spore Launcher */
		{
			get_user_ammo(id,26,clip,ammo)
			if(ammo<30)
			{
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
			}
			else
				scxpm_randomammo(id)
		}
		case 27: /* Desert Eagle */
		{
			get_user_ammo(id,27,clip,ammo)
			if(ammo<36)
			{
				give_item(id,Ammo357)
				give_item(id,Ammo357)
				give_item(id,Ammo357)
			}
			else
				scxpm_randomammo(id)
		}
		case 28: /* Shock Roach */
			scxpm_randomammo(id)
	}
}
#endif
// get the different ranks
public scxpm_getrank( id ) {
	new rid;
	new pl = playerlevel[id];
	if(pl>=1800){
		rid = 21;
		neededxp[id] = 0
	}
	else if((pl>=1700)&&(pl<=1799))
		rid = 20;
	else if((pl>=1600)&&(pl<=1699))
		rid = 19;
	else if((pl>=1500)&&(pl<=1599))
		rid = 18;
	else if((pl>=1400)&&(pl<=1499))
		rid = 17;
	else if((pl>=1300)&&(pl<=1399))
		rid = 16;
	else if((pl>=1200)&&(pl<=1299))
		rid = 15;
	else if((pl>=1100)&&(pl<=1199))
		rid = 14;
	else if((pl>=1000)&&(pl<=1099))
		rid = 13;
	else if((pl>=900)&&(pl<=999))
		rid = 12;
	else if((pl>=800)&&(pl<=899))
		rid = 11;
	else if((pl>=700)&&(pl<=799))
		rid = 10;
	else if((pl>=600)&&(pl<=699))
		rid = 9;
	else if((pl>=500)&&(pl<=599))
		rid = 8;
	else if((pl>=400)&&(pl<=499))
		rid = 7;
	else if((pl>=300)&&(pl<=399))
		rid = 6;
	else if((pl>=200)&&(pl<=299))
		rid = 5;
	else if((pl>=100)&&(pl<=199))
		rid = 4;
	else if((pl>=50)&&(pl<=99))
		rid = 3;
	else if((pl>=20)&&(pl<=49))
		rid = 2;
	else if((pl>=5)&&(pl<=19))
		rid = 1;
	else
		rid = 0;
	rank[id] = rid;
}
// give extra info for beginners
// changed by swmpdg until fixing other commands - removed skillsinfo and playerskills
public scxpm_newbiehelp( id ) {
	if ( is_user_connected( id ) )
	{
		client_print( id, print_chat, "%s Commands: ^"'say selectskill', 'say selectskills', 'say resetskills', 'say scxpminfo', 'say skillsinfo'^"", SCXPM);
#if defined ALLOW_TRADE
		client_print( id, print_chat, "%s Commands: ^"'say trademedal', 'say tradexp', 'say spawnmenu', 'say skills'^"",SCXPM);
#endif
	}
}
public scxpm_skillsinfo(id)
{
	client_print( id, print_chat, "%s Skill Information: ^"'say strength', 'say armor', 'say health', 'say nanoarmor','say ammo'^"",SCXPM);
	client_print( id, print_chat, "%s Skill Information: ^"'say gravity', 'say awareness', 'say teampower', 'say block', 'say medals'^"",SCXPM);
	client_print( id, print_chat, "%s Skill Information: ^"'say skills'^" to see which skills are enabled or disabled for this map",SCXPM);
}
public scxpm_skillhelp(id)
{
	client_print(id, print_chat, "%s Skills: Enabled = 1, Disabled = 0",SCXPM);
	client_print(id, print_chat, "%s %s: %d, %s: %d, %s: %d, %s: %d, %s: %d,",SCXPM,Stre,get_pcvar_num(pcvar_health),SupArm,get_pcvar_num(pcvar_armor),HPRe,get_pcvar_num(pcvar_hpregen),APRe,get_pcvar_num(pcvar_nano),AmmoRe,get_pcvar_num(pcvar_ammo));
	client_print(id, print_chat, "%s %s: %d, %s: %d, %s: %d, %s: %d, %s: %d",SCXPM,Grav,get_pcvar_num(pcvar_gravity),Aware,1,TeamP,get_pcvar_num(pcvar_teampower),Block,get_pcvar_num(pcvar_block),Medals,1);
}
public client_connect( id ) {
	if (get_pcvar_num( pcvar_debug ) == 1 )
	{
		if(!is_user_bot(id) && !is_user_hltv(id) )
		{
			log_amx( "%s Begin client_connect",DEBUG);
			new name[64];
			get_user_name( id, name, 63);
			log_amx( "%s %s connected",DEBUG,name);
		}
	}
}
public load_wait(id)
{
	if(is_user_connected(id))
		set_task(5.0, "LoadPlayerData", id);
}
public scxpm_dataload(id)
{
	if(is_user_connected(id))
	{
		set_task(5.0, "scxpm_sdac", id);
		set_task(10.0, "load_wait", id);
	}
}
// hopefully called before ResetHUD? I don't think it does sometimes? Very interesting...
public client_putinserver(id)
{
#if !defined ALLOW_BOTS
	if (!is_user_hltv(id) && is_user_connected(id) && !is_user_bot(id))
#else
	if (!is_user_hltv(id) && is_user_connected(id))
#endif
	{
		if (get_pcvar_num( pcvar_debug ) == 1 )
			log_amx( "%s Begin client_putinserver",DEBUG);
		lastfrags[ id ] = 0;
		clear_player_flag(loaddata, id);
		isLoaded[id] = false;
#if !defined USING_SVEN
#if !defined USING_CS
		if ( get_pcvar_num( pcvar_save ) < 2 )
			LoadPlayerData( id );
#endif
#endif
#if defined LUCK_CTRL
		isLucky[id] = false;
#endif
		spawnmenu[id] = true;
#if defined PLYR_CTRL
		onecount[id] = false;
#endif
		rank[id] = 22;
		medals[id] = 1;
		playerlevel[id] = 0;
#if defined HEALTH_CTRL
		maxhealth[id] = 0;
#endif
#if defined ARMOR_CTRL
		maxarmor[id] = 0;
#endif
		set_task(5.0, "scxpm_dataload", id);
		// LoadPlayerData( id ); // originally set here to load after client_authorized, but still not loading fast enough for steam ID to be validated.
#if defined EVENT_DMG
		PlayerIsHurt[id] = false;
#endif
// add cvars for Frag Bonus and Trade Limit
#if defined FRAGBONUS
		medal_limit[id]=get_pcvar_num(pcvar_bonuslimit);
#endif
#if defined ALLOW_TRADE
		trade_limit[id]=get_pcvar_num(pcvar_tradelimit);
#endif
#if defined SPEED_CTRL
		if(get_pcvar_num(pcvar_speedctrl))
		{
			g_hasSpeed[id] = false;
			g_punished[id] = false;
		}
#endif
#if defined COUNT_CTRL
		count_reexp[id] = get_pcvar_num(pcvar_counter);
		count_save[id] = 0;
		maxlvl_count[id] = 0;
#endif
	}
}
// clear data on client disconnect
public client_disconnect( id ) {
	if (get_pcvar_num( pcvar_debug ) == 1 )
	{
		if(!is_user_bot(id) && !is_user_hltv(id) )
		{
			log_amx( "%s Begin client_disconnect",DEBUG);
			new name[64];
			get_user_name( id, name, 63);
			log_amx( "%s %s disconnected",DEBUG,name);
		}
	}
#if defined ALLOW_BOTS
	if(!is_user_hltv(id) )
#else
	if(!is_user_bot(id) && !is_user_hltv(id) )
#endif
	{
		if(task_exists(id))
		{
			remove_task(id)
			if (get_pcvar_num( pcvar_debug ) == 1 )
				log_amx("Task Removed")
		}
		if ( get_pcvar_num( pcvar_minplaytime ) == 0 || get_pcvar_num( pcvar_minplaytime ) <= get_user_time( id ) ) {
			SavePlayerData( id );
		}
		else {
			if (get_pcvar_num( pcvar_debug ) == 1 ) {
				log_amx( "%s did not play for %d seconds, don't save stats",DEBUG, get_pcvar_num(pcvar_minplaytime));
			}
		}
		isLoaded[id] = false;
#if defined LUCK_CTRL
		isLucky[id] = false;
#endif
#if defined HEALTH_CTRL
		maxhealth[id] = 0;
#endif
#if defined ARMOR_CTRL
		maxarmor[id] = 0;
#endif
		spawnmenu[id] = false;
		xp[id] = 0;
		neededxp[id] = 0;
		playerlevel[id] = 0;
		skillpoints[id] = 0;
		medals[id] = 0;
		health[id] = 0;
		armor[id] = 0;
		rhealth[id] = 0;
		rarmor[id] = 0;
		rammo[id] = 0;
		gravity[id] = 0;
		speed[id] = 0;
		dist[id] = 0;
		dodge[id] = 0;
		rarmorwait[id] = 0;
		rhealthwait[id] = 0;
		ammowait[id] = 0;
#if defined FRAGBONUS
		medal_limit[id]=0;
#endif
#if defined ALLOW_TRADE
		trade_limit[id]=0;
#endif
#if defined SPEED_CTRL
		if (get_pcvar_num(pcvar_speedctrl))
		{
			g_hasSpeed[id] = false;
			g_punished[id] = false;
		}
#endif
#if defined EVENT_DMG
		PlayerIsHurt[id] = false;
#endif
		rank[id] = sizeof ranks-1;
		clear_player_flag(loaddata, id);
#if !defined USING_CS
#if defined COUNT_CTRL
		count_reexp[id] = 0;
		count_save[id] = 0;
		maxlvl_count[id] = 0;
#endif
#if defined PLYR_CTRL
		onecount[id] = false;
#endif
#endif
	}
	if (get_pcvar_num( pcvar_debug ) == 1 )
		if(!is_user_bot(id) && !is_user_hltv(id) )
			log_amx( "%s End client_disconnect", DEBUG);
}
// idea to manually save experience when it is ready with "take cover" command key (default: X)... allow for saving when counter is ready
#if defined SPEED_CTRL
public scxpm_speed(id,level,cid)
{
	if (!cmd_access(id, level, cid, 2))
		return PLUGIN_HANDLED
	if (!get_pcvar_num(pcvar_speedctrl))
	{
		if (id == 0)
			server_print("%s Speed changing is disabled!",SCXPM)
		else 
			console_print(id, "%s Speed changing is disabled!",SCXPM)
		return PLUGIN_HANDLED
	}
	// new arga[32], argb[8]
	new arga[32]
	read_argv(1, arga, 31)
	//read_argv(2, argb, 7)
	new admin[32], plName[32]
	get_user_name(id, admin, 31)	
	new player = cmd_target(id, arga, 2)
	if (!player)
		return PLUGIN_HANDLED
	get_user_name(player, plName, 31)
	if (g_hasSpeed[player])
	{
		g_hasSpeed[player] = false
		g_punished[player] = false
		UserSpeed(player)
		log_amx("%s %s set %s 's speed control off",SCXPM,admin,plName)
	}
	else if (!g_hasSpeed[player])
	{
		g_hasSpeed[player] = true
		g_punished[player] = true
		UserSpeed(player)
		log_amx("%s %s set %s 's speed control on",SCXPM,admin,plName)
	}
	return PLUGIN_HANDLED
}
#endif
// give xp to player
public scxpm_addxp( id, level, cid ) {
#if defined ALLOW_BOTS
	if ( !cmd_access( id, ADMIN_LEVEL_B, cid, 3 ) || is_user_hltv(id) )
#else	
	if ( !cmd_access( id, ADMIN_LEVEL_B, cid, 3 ) || is_user_bot(id) || is_user_hltv(id) )
#endif
		return PLUGIN_HANDLED;
	new targetarg[32];
	read_argv(1, targetarg, 31);
	new target = cmd_target( id, targetarg, 11 );
	if ( !target )
		return PLUGIN_HANDLED;
	if(!isLoaded[target])
	{
		client_print(id, print_chat,"%s %s",SCXPM,WaitMsg);
		return PLUGIN_HANDLED;
	}
	new xparg[32];
	read_argv( 2, xparg, 31 );
	new addxp = str_to_num( xparg );
	new name[32];
	get_user_name( target, name, 31 );
	if ( addxp + xp[target] > scxpm_calc_xp ( get_pcvar_num( pcvar_maxlevel ) ) )
		addxp = scxpm_calc_xp ( get_pcvar_num( pcvar_maxlevel ) ) - xp[target];
	// should be impossible but why not
	if ( addxp + xp[target] < 0 )
		xp[target] = 0;
	// now add the xp to the current xp
	xp[target] += addxp;
	// now save the stats
	scxpm_getrank( target );
	SavePlayerData( target );
#if defined COUNT_CTRL
	if(maxlvl_count[target]!=0)
		maxlvl_count[target] = 0;
#endif
	if (get_pcvar_num( pcvar_debug ) == 1 )
	{
		// for logging purposes
		new adminname[32];
		new adminid[32];
		get_user_name( id, adminname, 31 );
		get_user_authid(id, adminid, 31 );
		log_amx("%s %s %s gave %s %i xp ",SCXPM,adminname, adminid, name, addxp );
		console_print( id, "%s gained %i xp. New xp: %i", name, addxp, xp[target] );
	}
	return PLUGIN_HANDLED;
}
// remove xp from player
public scxpm_removexp( id, level, cid ) {
	if ( !cmd_access( id, ADMIN_LEVEL_B, cid, 3 ) )
		return PLUGIN_HANDLED;
	new targetarg[32];
	read_argv(1, targetarg, 31);
	new target = cmd_target( id, targetarg, 11 );
	if( !target )
		return PLUGIN_HANDLED;
	if(!isLoaded[target])
	{
		client_print(id, print_chat,"%s %s",SCXPM,WaitMsg);
		return PLUGIN_HANDLED;
	}
	new xparg[32];
	read_argv( 2, xparg, 31 );
	new removexp = str_to_num( xparg );
	new name[32];
	get_user_name( target, name, 31 );
	// if players xp minus remove xp is higher than the max xp
	// changing max xp to maxlevel xp
	if ( xp[target] - removexp > 11453365 )
		removexp = xp[target] - 11453365;
	// now remove the xp from the current xp
	xp[target] -= removexp;
	if ( xp[target] < 0 )
		xp[target] = 0;
	// level needs to be recalculated
	playerlevel[target] = scxpm_calc_lvl ( xp[target] );
	//if there are too many skills some should be removed
	while ( playerlevel[target] < health[target] + armor[target] + rhealth[target] + rarmor[target] + rammo[target] + gravity[target] + speed[target] + dist[target] + dodge[target] + skillpoints[target] )
	{
		if ( health[target] > 0  )
			health[target]--;
		else if ( armor[target] > 0 )
			armor[target]--;
		else if ( rhealth[target] > 0 )
			rhealth[target]--;
		else if ( rarmor[target] > 0 )
			rarmor[target]--;
		else if ( rammo[target] > 0 )
			rammo[target]--;
		else if ( gravity[target] > 0 )
			gravity[target]--;
		else if ( speed[target] > 0 )
			speed[target]--;
		else if ( dist[target] > 0 )
			dist[target]--;
		else if ( dodge[target] > 0 )
			dodge[target]--;
	}
	// recalculate needed xp
	scxpm_calcneedxp ( target );
	// now save the stats
	scxpm_getrank( target );
	SavePlayerData( target );
#if defined COUNT_CTRL
	if(maxlvl_count[target]!=0)
		maxlvl_count[target] = 0;
#endif
	// for logging purposes
	new adminname[32];
	new adminid[32];
	get_user_name( id, adminname, 31 );
	get_user_authid(id, adminid, 31 );
	log_amx("%s %s %s removed %s %i xp ",SCXPM,adminname, adminid, name, removexp );
	console_print( id, "%s lost %i xp. New xp: %i", name, removexp, xp[target] );
	return PLUGIN_HANDLED
}
// set players level
public scxpm_setlvl( id, level, cid ) {
	if ( !cmd_access( id, ADMIN_LEVEL_B, cid, 3 ) )
		return PLUGIN_HANDLED;
	new targetarg[32];
	read_argv(1, targetarg, 31);
	new target = cmd_target( id, targetarg, 11 );
	if( !target )
		return PLUGIN_HANDLED;
	if(!isLoaded[target])
	{
		client_print(id, print_chat,"%s %s",SCXPM,WaitMsg);
		return PLUGIN_HANDLED;
	}
	new lvlarg[32];
	read_argv( 2, lvlarg, 31 );
	new nowlvl = str_to_num( lvlarg );
	new name[32];
	get_user_name( target, name, 31 );
	if( nowlvl >= get_pcvar_num( pcvar_maxlevel ) )
		nowlvl = get_pcvar_num( pcvar_maxlevel );
	if ( nowlvl < 0 )
		nowlvl = 0;
	if ( nowlvl == playerlevel[target] )
	{
		if ( target == id )
			console_print( id, "%s Your Level is already %i.",SCXPM,nowlvl);
		else
			console_print(id, "%s %s's Level is already %i.",SCXPM,name,nowlvl);
		return PLUGIN_HANDLED
	}
	else
	{
		if ( nowlvl >= 1800 )
		{
			nowlvl = 1800;
			xp[target] = 11453365;
		}
		else
		{
			if ( nowlvl <= 0 )
			{
				nowlvl = 0;
				xp[target] = 0;
			}
			else
			{
				new helpvar = nowlvl - 1;
				new Float:m70b = float( helpvar ) * 70.0;
				new Float:mselfm3dot2b = float( helpvar ) * float(helpvar) * 3.5;
				xp[target] = floatround( m70b + mselfm3dot2b + 30.0);
			}
		}
	}
	if ( playerlevel[target] > nowlvl )
	{
		playerlevel[target] = nowlvl;
		if (target == id )
			console_print( id, "%s You lowered your Level to %i. Calling Skill Reset!",SCXPM,playerlevel[target]);
		else
			console_print( id, "%s You lowered %s's Level to %i.",SCXPM,name,playerlevel[target]);
		if (  nowlvl > 0 )
		{
			if ( target != id )
				client_print( target, print_chat, "%s An Admin has lowered your Level to %i! Calling Skill Reset!",SCXPM,playerlevel[target]);
			scxpm_reset( target );
		}
		else
		{
			if ( target != id )
				client_print( target, print_chat, "%s An Admin has lowered your Level to 0! You lost all Skills!",SCXPM);
			health[target] = 0;
			armor[target] = 0;
			rhealth[target] = 0;
			rarmor[target] = 0;
			rammo[target] = 0;
			gravity[target] = 0;
			speed[target] = 0;
			dist[target] = 0;
			dodge[target] = 0;
			skillpoints[target] = 0;
#if defined HEALTH_CTRL
//			maxhealth[target] = 100;
			get_max_hp(target);
			if ( get_user_health( target ) > maxhealth[target] && get_pcvar_num(pcvar_health))
				set_user_health( target, maxhealth[target] );
#else
			if ( get_user_health( target ) > 100 )
				set_user_health( target, 100 );
#endif
#if defined ARMOR_CTRL
			//maxarmor[id] = 100;
			get_max_ap(target);
#if defined USING_CS
			if (get_user_armor( target ) > maxarmor[target])
				cs_set_user_armor( target, maxarmor[target], CS_ARMOR_VESTHELM );
#else
			if (get_user_armor( target ) > maxarmor[target])
				set_user_armor( target, maxarmor[target]);
#endif
#else
#if defined USING_CS
			if (get_user_armor( target ) > 100 )
				cs_set_user_armor( target, 100, CS_ARMOR_VESTHELM );
#else
			if (get_user_armor( target ) > 100 )
				set_user_armor( target, 100 );
#endif
#endif
			if(get_pcvar_num( pcvar_gravity ) >= 1 && is_user_alive(target))
				set_user_gravity(id, 1.0)
		}
	}
	else
	{
		if ( nowlvl < 1800 )
		{
			skillpoints[target] = skillpoints[target] + nowlvl - playerlevel[target];
			playerlevel[target] = nowlvl;
			if ( target == id )
				console_print( id, "%s You raised your Level to %i.",SCXPM,playerlevel[target]);
			else
			{
				console_print( id, "%s You raised %s's Level to %i.",SCXPM,name,playerlevel[target]);
				client_print( target, print_chat, "%s An Admin has raised your Level to %i! Calling Skill Menu!",SCXPM,playerlevel[target]);
			}
			SCXPMSkill( target );
		}
		else
		{
			health[target] = 450;
			armor[target] = 450;
			rhealth[target] = 300;
			rarmor[target] = 300;
			rammo[target] = 30;
			gravity[target] = 40;
			speed[target] = 80;
			dist[target] = 60;
			dodge[target] = 90;
			skillpoints[target] = 0;
			playerlevel[target] = 1800;
#if defined HEALTH_CTRL
			get_max_hp(target);
			if(get_pcvar_num(pcvar_health) && get_user_health(target)<maxhealth[target])
				set_user_health(target, maxhealth[target])
#else
			set_user_health( target, get_user_health( target ) + 450 - health[target] );
#endif
#if defined ARMOR_CTRL
			get_max_ap(target);
#if defined USING_CS
			if(get_pcvar_num(pcvar_armor) && get_user_health(target)<maxhealth[target])
				cs_set_user_armor( target, maxarmor[target], CS_ARMOR_VESTHELM );
#else
				set_user_armor( target, maxarmor[target]);
#endif
#else  // ARMORCTRL
#if defined USING_CS
			cs_set_user_armor( target, get_user_armor( target ) + 450 - armor[target], CS_ARMOR_VESTHELM );
#else
			set_user_armor( target, get_user_armor( target ) + 450 - armor[target] );
#endif
#endif // ARMOR_CTRL
			if ( target == id )
				console_print( id, "%s You raised your Level to 1800.",SCXPM);
			else
			{
				console_print( id, "%s You raised %s's Level to 1800.",SCXPM,name);
				client_print( target, print_chat, "%s An Admin has raised your Level to 1800! You got all Skills!",SCXPM);
			}
			if (get_pcvar_num( pcvar_gravity ) >= 1 && is_user_alive(target))
				gravity_enable(target);
		}
	}
	scxpm_calcneedxp( target );
	scxpm_getrank( target );
	SavePlayerData( target );
	firstLvl[target] = nowlvl;
#if defined COUNT_CTRL
	if(maxlvl_count[target]!=0)
		maxlvl_count[target] = 0;
#endif
	new adminname[32];
	new adminid[32];
	get_user_name( id, adminname, 31 );
	get_user_authid(id, adminid, 31 );
	log_amx( "%s %s %s setlvl %s to level %i  ",SCXPM,adminname,adminid,name,playerlevel[target]);
	return PLUGIN_HANDLED;
}
// give player a medal
public scxpm_addmedal( id, level, cid) {
	if ( !cmd_access( id, ADMIN_LEVEL_B, cid, 2 ) )
		return PLUGIN_HANDLED;
	new targetarg[32];
	read_argv(1, targetarg, 31);
	new target = cmd_target( id, targetarg, 11 );
	if ( !target )
		return PLUGIN_HANDLED;
	if(!isLoaded[target])
	{
		client_print(id, print_chat,"%s %s",SCXPM,WaitMsg);
		return PLUGIN_HANDLED;
	}
	new name[32];
	get_user_name( target, name, 31 );
	if ( medals[target] < 16 )
	{
		medals[target]+=1;
#if defined HEALTH_CTRL
		get_max_hp(id);
#endif
#if defined ARMOR_CTRL
		get_max_ap(id);
#endif
		console_print( id, "You awarded %s with a Medal.", name );
		client_print( 0, print_chat, "%s %s was awarded with a Medal! (He now has %i Medals)",SCXPM,name,medals[target] - 1);
	}
	else
		console_print( id, "%s already has 15 Medals.", name );
	new adminname[32];
	new adminid[32];
	get_user_name( id, adminname, 31 );
	get_user_authid(id, adminid, 31 );
	log_amx( "%s %s %s addmedal to %s",SCXPM,adminname,adminid,name);
	return PLUGIN_HANDLED;
}
// remove players medal
public scxpm_removemedal( id, level, cid ) {
	if ( !cmd_access( id, ADMIN_LEVEL_B, cid, 2 ) )
	{
		return PLUGIN_HANDLED;
	}
	new targetarg[32];
	read_argv( 1, targetarg, 31);
	new target = cmd_target( id, targetarg, 11 );
	if( !target )
		return PLUGIN_HANDLED;
	if(!isLoaded[target])
	{
		client_print(id, print_chat,"%s %s",SCXPM,WaitMsg);
		return PLUGIN_HANDLED;
	}
	new name[32];
	get_user_name( target, name, 31 );
	if ( medals[target] > 1 )
	{
		medals[target]-=1;
#if defined HEALTH_CTRL
		get_max_hp(id);
#endif
#if defined ARMOR_CTRL
		get_max_ap(id);
#endif
		console_print( id, "You took a Medal of %s.", name );
		client_print( 0, print_chat, "%s %s lost a Medal! (He now has %i Medals)",SCXPM,name,medals[target] - 1);
	}
	else
	{
		console_print( id, "%s already has no Medals.", name );
	}
	new adminname[32];
	new adminid[32];
	get_user_name( id, adminname, 31 );
	get_user_authid(id, adminid, 31 );
	log_amx( "%s %s %s removemedal from %s",SCXPM,adminname,adminid,name);
	return PLUGIN_HANDLED;
}
#if defined CHEATS_ALLOWED
// toggle godmode
public scxpm_godmode(id,level,cid) {
	if ( !cmd_access( id, ADMIN_LEVEL_B, cid, 2 ) )
	{
		return PLUGIN_HANDLED;
	}
	new godmode_arg[32];
	read_argv( 1, godmode_arg, 31 );
	new godmode_target = cmd_target( id, godmode_arg, 0 );
	if ( godmode_target )
	{
		new godmode_name[32];
		get_user_name( godmode_target, godmode_name, 31);
		if ( !is_user_alive( godmode_target ) )
		{
			console_print( id, "%s The User %s is currently dead!",SCXPM,godmode_name);
			return PLUGIN_HANDLED;
		}
		if(get_user_godmode(godmode_target))
		{
			set_user_godmode( godmode_target );
			if ( godmode_target == id )
				console_print(id,"%s You disabled God Mode on yourself!",SCXPM);
			else
			{
				console_print( id, "%s The User %s lost his God Mode!",SCXPM,godmode_name);
				client_print( godmode_target, print_chat, "%s An Admin has disabled God Mode on you!",SCXPM);
			}
		}
		else
		{
			set_user_godmode( godmode_target, 1 );
			if ( godmode_target == id )
				console_print( id, "%s You enabled God Mode on yourself!",SCXPM);
			else
			{
				console_print( id, "%s The User %s now has God Mode!",SCXPM,godmode_name);
				client_print( godmode_target, print_chat, "%s An Admin has enabled God Mode on you!",SCXPM);
			}
		}
	}
	return PLUGIN_HANDLED;
}
// toggle noclip
public scxpm_noclipmode( id, level, cid ) {
	if ( !cmd_access( id, ADMIN_LEVEL_B, cid, 2 ) )
		return PLUGIN_HANDLED;
	new noclipmode_arg[32];
	read_argv( 1, noclipmode_arg, 31 );
	new noclipmode_target = cmd_target( id, noclipmode_arg, 0 );
	if ( noclipmode_target )
	{
		new noclipmode_name[32];
		get_user_name( noclipmode_target, noclipmode_name, 31 );
		if ( !is_user_alive( noclipmode_target ) )
		{
			console_print( id, "%s The User %s is currently dead!",SCXPM,noclipmode_name);
			return PLUGIN_HANDLED;
		}
		if ( get_user_noclip( noclipmode_target ) )
		{
			set_user_noclip( noclipmode_target );
			if ( noclipmode_target == id )
				console_print( id, "%s You disabled Noclip Mode on yourself",SCXPM);
			else
			{
				console_print( id, "%s The User %s lost his Noclip Mode!",SCXPM,noclipmode_name);
				client_print( noclipmode_target, print_chat, "%s An Admin has disabled Noclip Mode on you!",SCXPM);
			}
		}
		else
		{
			set_user_noclip( noclipmode_target, 1 );
			if ( noclipmode_target == id )
				console_print( id, "%s You enabled Noclip Mode on yourself!",SCXPM);
			else
			{
				console_print( id, "%s The User %s now has Noclip Mode!",SCXPM,noclipmode_name);
				client_print( noclipmode_target, print_chat, "%s An Admin has enabled Noclip Mode on you!",SCXPM);
			}
		}
	}
	return PLUGIN_HANDLED;
}
#endif
// reset players skills
public scxpm_reset(id) {
	health[id] = 0;
	armor[id] = 0;
	rhealth[id] = 0;
	rarmor[id] = 0;
	rammo[id] = 0;
	gravity[id] = 0;
	speed[id] = 0;
	dist[id] = 0;
	dodge[id] = 0;
	skillpoints[id] = playerlevel[id];
#if defined HEALTH_CTRL
	get_max_hp(id);
	if (get_user_health( id )>maxhealth[id])
	{
		if(get_pcvar_num(pcvar_health) > 0)
			set_user_health(id,maxhealth[id])
		else
			set_user_health(id, 100)
	}
#else
	if ( get_user_health( id ) > 100 + medals[id]-1 )
		set_user_health( id, 100 + medals[id]-1 )
#endif
#if defined ARMOR_CTRL
	get_max_ap(id);
#if defined USING_CS
		if(get_pcvar_num(pcvar_armor) > 0)
			cs_set_user_armor(id,maxarmor[id], CS_ARMOR_VESTHELM)
		else
			cs_set_user_armor( id, 100, CS_ARMOR_VESTHELM )	
#else
		if(get_pcvar_num(pcvar_armor) > 0)
			set_user_armor(id,maxarmor[id])
		else
			set_user_armor(id, 100)
#endif
#else // ARMOR_CTRL
	if ( get_user_armor(id) > 100 + medals[id]-1 )
#if defined USING_CS
		cs_set_user_armor( id, 100 + medals[id]-1, CS_ARMOR_VESTHELM )
#else
		set_user_armor( id, 100 + medals[id]-1 )
#endif
#endif
	if (get_pcvar_num( pcvar_gravity ) >= 1 )
		set_user_gravity( id, 1.0 )
	if ( skillpoints[id] > 0 )
	{
		client_print( id, print_chat, "%s All your Skills have been set back. Please choose...",SCXPM);
		SCXPMSkill( id );
	}
	else
		client_print( id, print_chat, "%s You have no Skills to reset.",SCXPM);
}
// show plugin info
public scxpm_version( id ) {
	new allinfo[1023];
	format( allinfo, 1022, "Plugin Name: SCXPM (Sven Cooperative Experience Mod)^nPlugin Type: Running under AMXModX (www.amxmodx.org)^nAuthor: Silencer^nVersion: %s^nLast Update: %s^nExperience Multiplier (Server Side): %f^nInformation: http://forums.alliedmods.net/showthread.php?t=44168", VERSION, LASTUPDATE, get_pcvar_float( pcvar_xpgain ) );
	show_motd( id, allinfo, "SCXPM Information" );
}
// adding by swmpdg to work properly with svencoop? - made scxpm.txt to handle this, copying bleach motd code - length too long?
/*
public scxpm_info(id)
{
//	static motd_header[64];
	// new motd_body[4096],len;
	new motd_body[4096];
//	len += formatex(motd_body[len],2047-len,html_header);
	// formatex(motd_header,63,"%L",id,"L_MOTD_TITLE_ATTRIBUTES");
	//formatex(motd_header,63,"%L",id,"L_MOTD_TITLE_ATTRIBUTES");
	// len += formatex(motd_body[len],2047-len,"%L",id,"L_MOTD_ATTRIBUTES");
	// len += formatex(motd_body[len],2047-len,"%L",id,"L_MOTD_ATTRIBUTES");
	// len += formatex(motd_body[len],4095-len,"%L",id,"L_MOTD_ATTRIBUTES");
	formatex(motd_body[4095],4094,"%L",id,"L_MOTD_ATTRIBUTES");
//	len += formatex(motd_body[len],2047-len,html_footer);
	//show_motd(id,motd_body,motd_header);
	show_motd(id,motd_body,"SCXPM Skills Info");
	return PLUGIN_HANDLED;
}
*/
// show players skill data
// disable until fixed - swmpdg
/*
public scxpm_info( id ) {
	#if defined USING_CS
	new allskills[1023] = "1. Strength:<br />   Starthealth + 1 * Strengthlevel.<br />";
	format(allskills,1022,"%s<br />2. Superior Armor:<br />   Startarmor + 1 * Armorlevel.<br />",allskills);
	format(allskills,1022,"%s<br />3. Regeneration:<br />   One HP every (150.5-(Regenerationlevel/2)) Seconds<br />   + Bonus Chance every 0.5 Seconds.<br />",allskills);
	format(allskills,1022,"%s<br />4. Nano Armor:<br />   One AP every (150.5-(Nanoarmorlevel/2)) Seconds<br />   + Bonus Chance every 0.5 Seconds.<br />",allskills);
	format(allskills,1022,"%s<br />5. Ammunition Reincarnation:<br />   Ammunition for current Weapon every (90-(Ammolevel*2.5)) Seconds.<br />",allskills);
	format(allskills,1022,"%s<br />6. Anti Gravity Device:<br />   Lowers your Gravity by (1.5)%% per Level. Hold Jump-Key!<br />",allskills);
	format(allskills,1022,"%s<br />7. Awareness:<br />   Generic Skill which is enhancing many other Skills a bit.<br />",allskills);
	format(allskills,1022,"%s<br />8. Team Power:<br />   Supports nearby Teammates with HP and AP<br />   and also yourself on higher Level.<br />",allskills);
	format(allskills,1022,"%s<br />9. Block Attack:<br />   Chance on fully blocking any Attack of (Blocklevel/3)%%.<br />",allskills);
	format(allskills,1022,"%s<br />Special - Medals:<br />   Given by an Admin, Shows your Importance.<br />   (Minimal Ability Support)",allskills);
	#else
	new allskills[1023] = "1. Strength:^n   Starthealth + 1 * Strengthlevel.^n";
	format(allskills,1022,"%s^n2. Superior Armor:^n   Startarmor + 1 * Armorlevel.^n",allskills);
	format(allskills,1022,"%s^n3. Regeneration:^n   One HP every (150.5-(Regenerationlevel/2)) Seconds^n   + Bonus Chance every 0.5 Seconds.^n",allskills);
	format(allskills,1022,"%s^n4. Nano Armor:^n   One AP every (150.5-(Nanoarmorlevel/2)) Seconds^n   + Bonus Chance every 0.5 Seconds.^n",allskills);
	format(allskills,1022,"%s^n5. Ammunition Reincarnation:^n   Ammunition for current Weapon every (90-(Ammolevel*2.5)) Seconds.^n",allskills);
	format(allskills,1022,"%s^n6. Anti Gravity Device:^n   Lowers your Gravity by (1.5)%% per Level. Hold Jump-Key!^n",allskills);
	format(allskills,1022,"%s^n7. Awareness:^n   Generic Skill which is enhancing many other Skills a bit.^n",allskills);
	format(allskills,1022,"%s^n8. Team Power:^n   Supports nearby Teammates with HP and AP^n   and also yourself on higher Level.^n",allskills);
	format(allskills,1022,"%s^n9. Block Attack:^n   Chance on fully blocking any Attack of (Blocklevel/3)%%.^n",allskills);
	format(allskills,1022,"%s^nSpecial - Medals:^n   Given by an Admin, Shows your Importance.^n   (Minimal Ability Support)",allskills);
	#endif
	show_motd(id,allskills,"Skills Information")
}
*/
public scxpm_info(id)
{
	console_print(id, "**********Skills Information For Sven Co-op Experience Mod**********")
	console_print(id, "--------------------------------------------------------------------")
	console_print(id, "1. Strength: Starthealth + 1 * Strengthlevel")
	console_print(id, "2. Superior Armor: Startarmor + 1 * Armorlevel")
	console_print(id, "3. Regeneration: Regenerate up to 100+Strength+Awareness+Medals (max 645 HP)")
	console_print(id, "4. Nano Armor: Regenerate up to 100+Superior Armor+Awareness+Medals (max 645 AP)")
	console_print(id, "5. Ammunition Reincarnation: Regenerate Ammunition for current Weapon")
	console_print(id, "6. Anti Gravity Device: Lowers your Gravity. Medals slightly increase the power of the Anti-Gravity Device")
	console_print(id, "7. Awareness: A powerful skill that increases power of every other skill")
	console_print(id, "8. Team Power: Supports nearby Teammates with HP and/or AP and/or Ammo")
	console_print(id, "9. Block Attack: Chance on fully blocking any attack (chance increased by Awareness and medals)")
	console_print(id, "Special - Medals: Earned with frags, trading XP, or given by an Admin. Increases power of some skills.")
}
/*
// show all connected players skills
// remove until fixed - swmpdg
public scxpm_others( id ) {
	new alldata[2048];
	#if defined USING_CS
		alldata="<html><head><title>Players levels</title></head><body><table border='1'><tr><th width='200' align='left' cellpadding='5'>Playername</th><th width='40'>Level</th><th width='40'>Medals</th></tr>"
		new iPlayers[32],iNum
		get_players(iPlayers,iNum)
		for(new g=0;g<iNum;g++)
		{
			new i=iPlayers[g]
			if(is_user_connected(i))
			{
				new name[20]
				get_user_name(i,name,19)
				format(alldata,2047,"%s<tr><td>%s</td><td align='center'>%i</td><td align='center'>%i</td>",alldata,name,playerlevel[i],medals[i]-1)
			}
		}
		format(alldata,2047,"%s</table></body></html>",alldata)
	#else
		alldata="Playername            Level  Medals^n"
		new iPlayers[32],iNum
		get_players(iPlayers,iNum)
		for(new g=0;g<iNum;g++)
		{
			new i=iPlayers[g]
			if(is_user_connected(i))
			{
				new name[20]
				get_user_name(i,name,19)
				new toadd=20-strlen(name)
				new spaces[20]=""
				add(spaces,19,"                   ",toadd)
				format(alldata,2047,"%s^n%s %s %i     %i",alldata,name,spaces,playerlevel[i],medals[i]-1)
			}
		}
	#endif
	show_motd( id, alldata, "Players Data" );
}
*/
// updated by swmpdg - remove certain commands until fixed, and add selectskill command
// added medal trading - may 01, 2016 - swmpdg
public say_hook(id){
	new command[15];
	read_argv(1,command,sizeof command-1);
	if(equali(command,"selectskills") || equali(command,"/selectskills") || equali(command,"selectskill") || equali(command,"/selectskill")){
		if(isLoaded[id])
			SCXPMSkill(id);
		else
			client_print(id,print_chat,"%s %s",SCXPM,WaitMsg)
		return PLUGIN_HANDLED;
	}
	else if(equali(command,"skills") || equali(command,"/skills")){
		scxpm_skillhelp(id);
		return PLUGIN_HANDLED;
	}
	else if(equali(command,"resetskills") || equali(command,"/resetskills")){
#if defined RESETCHECK
		if(is_user_alive(id))
		{
			if(resetcheck[id])
				client_print(id, print_chat, "You musst die before being able to reset your skills again.")
			else
			{
				resetcheck[id] = 1;
				scxpm_reset(id);
			}
		}
		else
		{
			client_print(id, print_chat, "You cannot reset your skills while you are dead")
		}
#else
		if(is_user_alive(id))
			if(isLoaded[id])
				scxpm_reset(id);
			else
				client_print(id,print_chat,"%s %s",SCXPM,WaitMsg)
		else
			client_print(id, print_chat, "You cannot reset your skills while you are dead")
#endif
		return PLUGIN_HANDLED;
	}
#if defined ALLOW_TRADE
	else if(equali(command,"trademedal") || equali(command,"/trademedal")){
		if(isLoaded[id])
			medal_trade(id);
		else
			client_print(id,print_chat,"%s %s",SCXPM,WaitMsg);
		return PLUGIN_HANDLED;
	}
	else if(equali(command,"tradexp") || equali(command,"/tradexp")){
		if(isLoaded[id])
			xp_trade(id);
		else
			client_print(id,print_chat,"%s %s",SCXPM,WaitMsg);
		return PLUGIN_HANDLED;
	}
#endif
	else if(equali(command,"spawnmenu") || equali(command,"/spawnmenu")){
		if(spawnmenu[id])
		{
			client_print( id, print_chat, "%s Spawn Skills Menu turned off.",SCXPM);
			spawnmenu[id] = false;
		}
		else
		{
			client_print( id, print_chat, "%s Spawn Skills Menu turned on.",SCXPM);
			spawnmenu[id] = true;
		}
		return PLUGIN_HANDLED;
	}
	else if(equali(command,"removegravity") || equali(command,"/removegravity")){
		if(get_pcvar_num(pcvar_gravity) == 0 && gravity[id] > 0)
		{
			new oldGravity = gravity[id];
			skillpoints[id]+=gravity[id];
			gravity[id]=0;
			client_print( id, print_chat, "%s You removed %i %s skill points, and have %i skill points available.",SCXPM,oldGravity,Grav,skillpoints[id]);
			SCXPMSkill(id);
		}
		else if(get_pcvar_num(pcvar_gravity) == 0 && gravity[id] < 1)
			client_print( id, print_chat, "%s You currently do not have any %s skill points available.",SCXPM,Grav);
		else if(get_pcvar_num(pcvar_gravity) == 1 && gravity[id] > 0)
		{
			if(isLoaded[id])
			{
				new oldGravity = gravity[id];
				skillpoints[id]+=gravity[id];
				gravity[id]=0;
				client_print( id, print_chat, "%s You removed %i %s skill points, and have %i skill points available.",SCXPM,oldGravity,Grav,skillpoints[id]);
				SCXPMSkill(id);
				if(is_user_alive(id) && is_user_connected(id))
					set_user_gravity(id, 1.0)
			}
			else
				client_print(id,print_chat,"%s %s",SCXPM,WaitMsg);
		}
		else if(get_pcvar_num(pcvar_gravity) == 1 && gravity[id] < 1)
			client_print( id, print_chat, "%s You currently do not have any %s skill points available.",SCXPM,Grav);
		return PLUGIN_HANDLED;
	}
	/*
	else if(equali(command,"playerskills") || equali(command,"/playerskills")){
		scxpm_others(id);
		return PLUGIN_HANDLED;
	}
	*/
	else if(equali(command,"skillsinfo") || equali(command,"/skillsinfo")){
		scxpm_info(id);
		return PLUGIN_HANDLED;
	}
	else if(equali(command,"scxpminfo") || equali(command,"/scxpminfo")){
		scxpm_version(id);
		return PLUGIN_HANDLED;
	}
	else if(equali(command,"strength") || equali(command,"/strength")){
		client_print( id, print_chat, "%s %s: %s adds HP.",SCXPM,Stre,Stre);
		return PLUGIN_HANDLED;
	}
	else if(equali(command,"armor") || equali(command,"/armor")){
		client_print( id, print_chat, "%s %s: %s adds Armor.",SCXPM,SupArm,SupArm);
		return PLUGIN_HANDLED;
	}
	else if(equali(command,"nanoarmor") || equali(command,"/nanoarmor")){
		client_print( id, print_chat, "%s %s: %s regenerates armor.",SCXPM,APRe,APRe);
		return PLUGIN_HANDLED;
	}
	else if(equali(command,"ammo") || equali(command,"/ammo")){
		client_print( id, print_chat, "%s %s: %s gives Ammo.",SCXPM,AmmoRe,AmmoRe);
		return PLUGIN_HANDLED;
	}
	else if(equali(command,"awareness") || equali(command,"/awarenesss")){
		client_print( id, print_chat, "%s %s: %s enhances many other Skills.",SCXPM,Aware,Aware);
		return PLUGIN_HANDLED;
	}
	else if(equali(command,"teampower") || equali(command,"/teampower")){
		client_print( id, print_chat, "%s %s: %s strengthens nearby Teammates.",SCXPM,TeamP,TeamP);
		return PLUGIN_HANDLED;
	}
	else if(equali(command,"gravity") || equali(command,"/gravity")){
		if (get_pcvar_num( pcvar_gravity ) >= 1 )
			client_print( id, print_chat, "%s %s: %s Lowers Gravity.",SCXPM,Grav,Grav);
		return PLUGIN_HANDLED;
	}
	else if(equali(command,"block") || equali(command,"/block")){
		client_print( id, print_chat, "%s %s: %s randomly blocks attacks when low on HP & AP.",SCXPM,Block,Block);
		return PLUGIN_HANDLED;
	}
	else if(equali(command,"medals") || equali(command,"/medals")){
		client_print( id, print_chat, "%s %s: %s increase skill power.",SCXPM,Medals,Medals);
		return PLUGIN_HANDLED;
	}
	else if(equali(command,"health") || equali(command,"/health")){
		client_print( id, print_chat, "%s %s: %s heals HP.",SCXPM,HPRe,HPRe);
		return PLUGIN_HANDLED;
	}
	else if(equali(command,"skillsinfo") || equali(command,"/skillsinfo")){
		scxpm_skillsinfo(id);
		return PLUGIN_HANDLED;
	}
	return PLUGIN_CONTINUE;
}
/*
* The table create code is too long to compile so table have to be created manually
CREATE TABLE IF NOT EXISTS `scxpm_stats` (
	`id` int(11) NOT NULL auto_increment,
	`uniqueid` varchar(50) NOT NULL,
	`authid` varchar(24) NOT NULL,
	`ip` varchar(24) NOT NULL,
	`nick` varchar(50) NOT NULL,
	`xp` bigint(20) NOT NULL default '0',
	`playerlevel` int(11) NOT NULL default '0',
	`skillpoints` int(11) NOT NULL default '0',
	`medals` tinyint(4) NOT NULL default '4',
	`health` int(11) NOT NULL default '0',
	`armor` int(11) NOT NULL default '0',
	`rhealth` int(11) NOT NULL default '0',
	`rarmor` int(11) NOT NULL default '0',
	`rammo` int(11) NOT NULL default '0',
	`gravity` int(11) NOT NULL default '0',
	`speed` int(11) NOT NULL default '0',
	`dist` int(11) NOT NULL default '0',
	`dodge` int(11) NOT NULL default '0',
	`lastUpdated` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
	PRIMARY KEY  (`id`),
	UNIQUE KEY `uniqueid` (`uniqueid`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
*/
/*
*	Future Features
*	if you want new features ask it on: http://forums.alliedmods.net/showthread.php?t=44168
*	------------------
*	- pruning database with the `lastUpdated` field
*	- cuicide penalty
*
*/
/*
** Queries 
*/
/*
#define QUERY_SELECT_SKILLS "SELECT `xp`, `playerlevel`, `skillpoints`, `medals`, `health`, `armor`, `rhealth`, `rarmor`, `rammo`, `gravity`, `speed`, `dist`, `dodge` FROM `%s` WHERE %s"
#define QUERY_UPDATE_SKILLS "INSERT INTO %s (uniqueid) VALUES ('%s') ON DUPLICATE KEY UPDATE authid ='%s',nick='%s',ip='%s',xp='%d',playerlevel='%d',skillpoints='%d',medals='%d',health='%d',armor='%d',rhealth='%d',rarmor='%d',rammo='%d',gravity='%d',speed='%d',dist='%d',dodge='%d'"
*/
// init the sql, check if the sql table exist
public sql_init() {
	if ( get_pcvar_num( pcvar_save ) >= 2 && !dbc)
	{
		if (get_pcvar_num( pcvar_debug ) == 1 )
			log_amx( "%s Begin Init the sql",DEBUG);
#if defined SQLCVAR		
		new host[64], username[64], password[64], dbname[64];
		get_pcvar_string( pcvar_sql_host, host, 64 );
		get_pcvar_string( pcvar_sql_user, username, 64 );
		get_pcvar_string( pcvar_sql_pass, password, 64 );
		get_pcvar_string( pcvar_sql_db, dbname, 64 );
#endif
		get_pcvar_string( pcvar_sql_table, sql_table, 64 );
		SQL_SetAffinity( "mysql" );
#if defined SQLCVAR
		dbc = SQL_MakeDbTuple( host, username, password, dbname );
#else
		dbc = SQL_MakeDbTuple( DATABASE_HOST, DATABASE_USERNAME, DATABASE_PASSWORD, DATABASE_DATABASE );
#endif
		// check if the table exist
		formatex( g_Cache, 1023, "show tables like '%s'", sql_table );
		SQL_ThreadQuery( dbc, "ShowTableHandle", g_Cache);	
		if (get_pcvar_num( pcvar_debug ) == 1 )
			log_amx( "%s End Init the sql",DEBUG);
	}
}
// load empty skills for new player or faulty load
public LoadEmptySkills( id ) {
#if !defined ALLOW_BOTS
	if (is_user_connected(id) && !is_user_bot(id))
#else
	if (is_user_connected(id))
#endif
	{
#if defined FREE_LEVELS
		scxpm_levelcheck(id);
#else
		xp[id] = 0;
		playerlevel[id] = 0;
		scxpm_calcneedxp( id );
		scxpm_getrank( id );
		skillpoints[id] = 0;
		firstLvl[id]=0;
#endif
		medals[id] = 4;
		health[id] = 0;
		armor[id] = 0;
		rhealth[id] = 0;
		rarmor[id] = 0;
		rammo[id] = 0;
		gravity[id] = 0;
		speed[id] = 0;
		dist[id] = 0;
		dodge[id] = 0;
#if defined LUCK
		luck[id] = 0;
#endif
		lastfrags[id] = 0;
#if defined FRAGBONUS
		medal_limit[id]=get_pcvar_num(pcvar_bonuslimit);
#endif
#if defined ALLOW_TRADE
		trade_limit[id]=get_pcvar_num(pcvar_tradelimit);
#endif
	}
}
// save and load
//
// load player data
public LoadPlayerData( id )
{
	new save = get_pcvar_num( pcvar_save );
	new debug_on = get_pcvar_num( pcvar_debug );
	if (plugin_ended == false)
	{
		if ( debug_on ){
			if(!is_user_bot(id) && !is_user_hltv(id))
			{
				new nickname[35];
				get_user_name( id, nickname, 34 );
				log_amx( "%s Loading data for: %s",DEBUG,nickname );
			}
		}
#if defined ALLOW_BOTS
		if(!is_user_hltv(id) && is_user_connected(id))
#else
		if(!is_user_bot(id) && !is_user_hltv(id) && is_user_connected(id))
#endif
		{
			if ( save <= 0 ){
				set_task(5.0, "LoadEmptySkills", id);
			}else if ( save == 1 ){
				scxpm_loadxp_file( id );
			}else if ( save >= 2 ){
				if ( !dbc ) sql_init();
				scxpm_loadxp_mysql( id );
			}else{
				if ( debug_on ){
					new nickname[35];
					get_user_name( id, nickname, 34 );
					log_amx( "%s Data already loaded, don't load data for: %s",DEBUG,nickname );
				}
			}
			// experimental loading spot here
			set_task(1.5, "plyr_loaded", id);
		}
	}
	else {
		if ( debug_on )
			log_amx( "%s Plugin already ended, don't load data",DEBUG);
	}
}
// save player data - may not need all these hltv checks in sven coop anymore
public SavePlayerData( id ) {
	new debug_on = get_pcvar_num( pcvar_debug );
	if(plugin_ended == true) 
	{
		if ( debug_on)
			log_amx( "%s Plugin already ended, don't save data",DEBUG);
		return PLUGIN_HANDLED;
	}
	else
	{
		new save = get_pcvar_num( pcvar_save );
#if defined ALLOW_BOTS
		if ( save == 0 || is_user_hltv(id) || !is_user_connected(id)) return PLUGIN_CONTINUE;
#else
		if ( save == 0 || is_user_bot(id) || is_user_hltv(id) || !is_user_connected(id)) return PLUGIN_CONTINUE;
#endif
		if (is_player_flag_set(loaddata,id))
		{
			if(playerlevel[id] > 0)
			{
				if ( debug_on ){
					new nickname[35];
					get_user_name( id, nickname, 34 );
					log_amx( "%s Saving data for: %s",DEBUG,nickname ); 
				}
				// 0 = will not be saved
				// 1 = save to file
				// 2 = save to mysql
				if ( save == 1 )
					scxpm_savexp_file( id );
				else{
					if ( !dbc )
					{
						sql_init();
					}
					scxpm_savexp_mysql( id );
				}
			}
			else
			{
				if ( debug_on )
				{
					new nickname[35];
					get_user_name( id, nickname, 34 );
					log_amx( "%s level less than 1, don't save data for: %s",DEBUG,nickname );
				}
			}
		}
		else 
		{
			if ( debug_on ){
				new nickname[35];
				get_user_name( id, nickname, 34 );
				log_amx( "%s Data not loaded, don't save data for: %s",DEBUG,nickname );
			}
		}
	}
	return PLUGIN_CONTINUE;
}
// load player data from file
public scxpm_loadxp_file( id ) {
	new savestyle = get_pcvar_num(pcvar_savestyle);
	new authid[35];
	switch(savestyle){
		case 0 : {
			get_user_authid(id, authid, 34)
			if ( containi(authid,"STEAM_ID_PENDING") !=-1 ){
				set_task(5.0, "LoadEmptySkills", id);
				return PLUGIN_CONTINUE;
			}
		}
		case 1:
			get_user_ip(id, authid, 34, 1);
		case 2:
			get_user_name(id, authid, 34);
	}
	new vaultkey[64], vaultdata[96];
	format(vaultkey,63,"%s-scxpm",authid);
	if ( vaultdata_exists(vaultkey) )
	{
		get_vaultdata(vaultkey,vaultdata,95);
		replace_all(vaultdata,95,"#"," ");
#if defined LUCK
		new pre_xp[16],pre_playerlevel[8],pre_skillpoints[8],pre_medals[8],pre_health[8],pre_armor[8],pre_rhealth[8],pre_rarmor[8],pre_rammo[8],pre_gravity[8],pre_speed[8],pre_dist[8],pre_dodge[8],pre_luck[8];
		parse(vaultdata,pre_xp,15,pre_playerlevel,7,pre_skillpoints,7,pre_medals,7,pre_health,7,pre_armor,7,pre_rhealth,7,pre_rarmor,7,pre_rammo,7,pre_gravity,7,pre_speed,7,pre_dist,7,pre_dodge,7,pre_luck,7);
#else
		new pre_xp[16],pre_playerlevel[8],pre_skillpoints[8],pre_medals[8],pre_health[8],pre_armor[8],pre_rhealth[8],pre_rarmor[8],pre_rammo[8],pre_gravity[8],pre_speed[8],pre_dist[8],pre_dodge[8];
		parse(vaultdata,pre_xp,15,pre_playerlevel,7,pre_skillpoints,7,pre_medals,7,pre_health,7,pre_armor,7,pre_rhealth,7,pre_rarmor,7,pre_rammo,7,pre_gravity,7,pre_speed,7,pre_dist,7,pre_dodge,7);
#endif
		xp[id] = str_to_num(pre_xp);
		playerlevel[id] = str_to_num(pre_playerlevel);
		skillpoints[id] = str_to_num(pre_skillpoints);
		medals[id] = str_to_num(pre_medals);
		health[id] = str_to_num(pre_health);
		armor[id] = str_to_num(pre_armor);
		rhealth[id] = str_to_num(pre_rhealth);
		rarmor[id] = str_to_num(pre_rarmor);
		rammo[id] = str_to_num(pre_rammo);
		gravity[id] = str_to_num(pre_gravity);
		speed[id] = str_to_num(pre_speed);
		dist[id] = str_to_num(pre_dist);
		dodge[id] = str_to_num(pre_dodge);
#if defined LUCK
		luck[id] = str_to_num(pre_luck);
#endif
	}
	else
	{
		log_amx("%s Start from level 0",SCXPM);
		set_task(1.0, "LoadEmptySkills", id);
	}
	set_player_flag(loaddata, id);
	return PLUGIN_CONTINUE;
}
// save player data to file
public scxpm_savexp_file( id ) {
	new savestyle = get_pcvar_num(pcvar_savestyle);
	new authid[35];
	switch(savestyle){
		case 0 : {
			get_user_authid( id, authid, 34 );
			if ( containi(authid,"STEAM_ID_PENDING") !=-1 )
				return PLUGIN_CONTINUE;
		}
		case 1:
			get_user_ip( id, authid, 34, 1 );
		case 2:
			get_user_name( id, authid, 34 );
	}
	new vaultkey[64], vaultdata[96];
	format( vaultdata, 95, "%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i",xp[id],playerlevel[id],skillpoints[id],medals[id],health[id],armor[id],rhealth[id],rarmor[id],rammo[id],gravity[id],speed[id],dist[id],dodge[id]);
	set_vaultdata( vaultkey, vaultdata );
	return PLUGIN_CONTINUE;
}
// save player data to a database
public scxpm_savexp_mysql( id ) {
	if(!is_user_connecting(id))
	{
		new savestyle = get_pcvar_num(pcvar_savestyle);
		new authid[35];
		new ip[35];
		new nickname[128];
		new where_statement[1024];
		get_user_authid(id, authid, 34);
		get_user_ip(id, ip, 34, 1);
		get_user_name(id, nickname, 63);
		if ( equali(ip, "") || equali(nickname, "") ) {
			if ( get_pcvar_num( pcvar_debug ) == 1 )
				log_amx( "%s Empty ip or nickname, don't save data.",DEBUG);
			return PLUGIN_CONTINUE;
		}
		replace_all(nickname,127,"'","\'");
		switch(savestyle){
			case 0 : {
				if ( containi(authid,"STEAM_ID_PENDING") !=-1 || equali(authid, "") ){
					if ( get_pcvar_num( pcvar_debug ) == 1 )
						log_amx( "%s Empty or invalid steamid, don't save data.",DEBUG);
					return PLUGIN_CONTINUE;
				}
				formatex( g_Cache, 1023, QUERY_UPDATE_SKILLS, sql_table, authid, authid, nickname, ip, xp[id], playerlevel[id], skillpoints[id], medals[id], health[id], armor[id], rhealth[id], rarmor[id], rammo[id], gravity[id], speed[id], dist[id], dodge[id], where_statement );
			}
			case 1:
				formatex( g_Cache, 1023, QUERY_UPDATE_SKILLS, sql_table, ip, authid, nickname, ip, xp[id], playerlevel[id], skillpoints[id], medals[id], health[id], armor[id], rhealth[id], rarmor[id], rammo[id], gravity[id], speed[id], dist[id], dodge[id], where_statement );
			case 2:
				formatex( g_Cache, 1023, QUERY_UPDATE_SKILLS, sql_table, nickname, authid, nickname, ip, xp[id], playerlevel[id], skillpoints[id], medals[id], health[id], armor[id], rhealth[id], rarmor[id], rammo[id], gravity[id], speed[id], dist[id], dodge[id], where_statement );
		}
		SQL_ThreadQuery( dbc, "QueryHandle", g_Cache );
	}
	return PLUGIN_CONTINUE;
}
// load player data from a database
public scxpm_loadxp_mysql( id ) {
	new savestyle = get_pcvar_num(pcvar_savestyle);
	if (get_pcvar_num(pcvar_debug) == 1)
	{
		if (!is_user_bot(id) && !is_user_hltv(id))
			log_amx( "%s Entered public scxpm_loadxp_mysql( id )",DEBUG);
	}
#if defined ALLOW_BOTS
	if(!is_user_hltv(id) && is_user_connected(id))
#else
	if(!is_user_bot(id) && !is_user_hltv(id) && is_user_connected(id))
#endif
	{
		new where_statement[1024];
		new authid[35];
		new ip[35];
		new nickname[128];
		get_user_authid( id, authid, 34 );
		get_user_ip( id, ip, 34, 1 );
		get_user_name( id, nickname, 63 );
		replace_all(nickname,127,"'","\'"); //avoiding sql errors with ' in name
		switch(savestyle){
			case 0 : {
				if ( containi(authid,"STEAM_ID_PENDING") !=-1 || equali(authid, "") ){
					set_task(5.0, "LoadEmptySkills", id)
					return PLUGIN_CONTINUE;
				}
				format(where_statement, 199, "`uniqueid` = '%s'", authid);
			}
			case 1:
				format(where_statement, 49, "`uniqueid` = '%s'", ip);
			case 2:
				format(where_statement, 199, "`uniqueid` = '%s'", nickname);
		}
		formatex( g_Cache, 1023, QUERY_SELECT_SKILLS, sql_table, where_statement);
		new send_id[1];
		send_id[0] = id;
		SQL_ThreadQuery( dbc, "LoadDataHandle", g_Cache, send_id, 1 );
	}
	return PLUGIN_CONTINUE;
}
// sql handles
//
// handle default queries
public QueryHandle( FailState, Handle:Query, Error[], Errcode, Data[], DataSize ) {
	new debug_on = get_pcvar_num( pcvar_debug );
	if (debug_on)	{
		log_amx( "%s Begin QueryHandle",DEBUG);
		new sql[1024];
		SQL_GetQueryString ( Query, sql, 1024 );
		log_amx( "%s executed query: %s",DEBUG,sql );
	}
	// lots of error checking
	if ( FailState == TQUERY_CONNECT_FAILED ) {
		log_amx( "%s Could not connect to SQL database.",SQL);
		return set_fail_state("[SCXPM SQL] Could not connect to SQL database.");
	}
	else if ( FailState == TQUERY_QUERY_FAILED ) {
		new sql[1024];
		SQL_GetQueryString ( Query, sql, 1024 );
		log_amx( "%s SQL Query failed: %s",SQL,sql);
		return set_fail_state("[SCXPM SQL] SQL Query failed.");
	}
	if ( Errcode )
		return log_amx("%s SQL Error on query: %s",SQL,Error);
	if ( debug_on )
		log_amx( "%s End QueryHandle",DEBUG);
	return PLUGIN_CONTINUE;
}
// check if table exist
public ShowTableHandle(FailState,Handle:Query,Error[],Errcode,Data[],DataSize) {
	new debug_on = get_pcvar_num( pcvar_debug );
	if (debug_on) {
		log_amx("%s Begin ShowTableHandle",DEBUG);
		new sql[1024];
		SQL_GetQueryString ( Query, sql, 1024 );
		log_amx( "%s executed query: %s",DEBUG,sql);
	}
	if(FailState==TQUERY_CONNECT_FAILED){
		log_amx( "%s Could not connect to SQL database.",SQL);
		log_amx( "%s Switching to: scxpm_save 0",SQL);
		log_amx( "%s Stats won't be saved",SQL);
		set_pcvar_num ( pcvar_save, 0 );
		return PLUGIN_CONTINUE;
	}
	else if (FailState == TQUERY_QUERY_FAILED) {
		log_amx( "%s Query failed.",SQL);
		log_amx( "%s Switching to: scxpm_save 0",SQL);
		log_amx( "%s Stats won't be saved",SQL);
		set_pcvar_num ( pcvar_save, 0 );
		return PLUGIN_CONTINUE;
	}
	if (Errcode) {
		log_amx( "%s Error on query: %s",SQL,Error);
		log_amx( "%s Switching to: scxpm_save 0",SQL);
		log_amx( "%s Stats won't be saved",SQL);
		set_pcvar_num ( pcvar_save, 0 );
		return PLUGIN_CONTINUE;
	}
	if (SQL_NumResults(Query) > 0) {
		if (get_pcvar_num( pcvar_debug ) == 1 )
			log_amx( "%s Database table found: %s",DEBUG,sql_table);
	}
	else {
		log_amx( "%s Could not find the table: %s",SQL,sql_table );
		log_amx( "%s Switching to: scxpm_save 0",SQL);
		log_amx( "%s Stats won't be saved",SQL);
		set_pcvar_num ( pcvar_save, 0 );
	}
	if (debug_on)
		log_amx( "%s End ShowTableHandle",DEBUG);
	return PLUGIN_CONTINUE;
}
// load player data
public LoadDataHandle(FailState,Handle:Query,Error[],Errcode,Data[],DataSize) {
	new debug_on = get_pcvar_num( pcvar_debug );
	if (debug_on){
		log_amx( "%s Begin LoadDataHandle",DEBUG);
		new sql[1024];
		SQL_GetQueryString ( Query, sql, 1024 );
		log_amx( "%s executed query: %s",DEBUG,sql);
	}
	if (FailState == TQUERY_CONNECT_FAILED)
		return set_fail_state("Could not connect to SQL database.");
	else if (FailState == TQUERY_QUERY_FAILED)
		return set_fail_state("Query failed.");
	if (Errcode)
		return log_amx("Error on query: %s",Error);
	new id = Data[0];
	set_player_flag(loaddata, id);
	if (SQL_NumResults(Query) >= 1) {
		if (SQL_NumResults(Query) > 1) {
			if (get_pcvar_num( pcvar_debug ) == 1 )
				log_amx( "%s more than one entry found. just take the first one",DEBUG);
		}
		xp[id] = SQL_ReadResult(Query, 0);
		playerlevel[id] = SQL_ReadResult(Query, 1);
		skillpoints[id] = SQL_ReadResult( Query, 2 );
		medals[id] = SQL_ReadResult(Query, 3);
		health[id] = SQL_ReadResult(Query, 4);
		armor[id] = SQL_ReadResult(Query, 5);
		rhealth[id] = SQL_ReadResult(Query, 6); 
		rarmor[id] = SQL_ReadResult(Query, 7);
		rammo[id] = SQL_ReadResult(Query, 8);
		gravity[id] = SQL_ReadResult(Query, 9); 
		speed[id] = SQL_ReadResult(Query, 10);
		dist[id] = SQL_ReadResult(Query, 11);
		dodge[id] = SQL_ReadResult(Query, 12);
#if defined LUCK
		luck[id] = SQL_ReadResult(Query, 13); // incomplete, don't use yet
#endif
	}
	else if (SQL_NumResults(Query) < 1)
		set_task(1.0, "LoadEmptySkills", id)
	if (debug_on)
		log_amx( "%s End LoadDataHandle",DEBUG);
	return PLUGIN_CONTINUE;
}
// why is this Health message needed - for the HUD?
public on_ResetHUD( id )
{
#if defined EVENT_DMG
	PlayerIsHurt[id] = false;
#endif
#if defined SPEED_CTRL
#if defined EVENT_DMG
	if (get_pcvar_num(pcvar_speedctrl) && !PlayerIsHurt[id] && g_hasSpeed[id] && !g_punished[id])
#else
	if (get_pcvar_num(pcvar_speedctrl) && g_hasSpeed[id] && !g_punished[id])
#endif
	{
		g_hasSpeed[id] = false
		UserSpeed(id)
	}
#endif
#if !defined USING_CS
#if defined COUNT_CTRL
	count_reexp[id]=get_pcvar_num(pcvar_counter)-1;
#endif
#endif
	if (get_pcvar_num(pcvar_gravity) >= 1 && gravity[id]>0)
	{
		gravity_enable(id);
	}
	else if(get_pcvar_num(pcvar_gravity) == 0 && gravity[id]>0)
	{
		if(!is_user_bot(id))
		{
			client_print(id, print_chat, "%s %s is disabled. %i skill points are available for you to use on another skill.",SCXPM,Grav,gravity[id])
			client_print(id, print_chat, "%s Say /removegravity to remove your %s skill points",SCXPM,Grav)
		}
	}
#if defined SPAWN_CTRL
	if(get_pcvar_num(pcvar_spawnctrl))
		load_hpap(id)
#endif
	if(skillpoints[id] > 0)
	{
		if (spawnmenu[id])
		{
			client_print(id,print_chat,"%s You have %i skillpoints available to use. \
			Say /spawnmenu to disable or enable skills menu on spawn.",SCXPM,skillpoints[id])
			SCXPMSkill(id);
		}
	}
#if defined RESETCHECK
	resetcheck[id]=0;
#endif
}
#if defined USING_SVEN
public scxpm_reexp(id) {
	if(is_user_connected(id))
	{
		if(playerlevel[id]<get_pcvar_num(pcvar_maxlevel))
		{
			if(firstLvl[id] == 0)
			{
				firstLvl[id] = playerlevel[id];
			}
			if (get_pcvar_num(pcvar_maxlevelup_enabled) == 0 || playerlevel[id] <= get_pcvar_num(pcvar_maxlevelup_limit) || (playerlevel[id] - firstLvl[id]) < get_pcvar_num(pcvar_maxlevelup))
			{
				new Float:helpvar = float(xp[id])/5.0/get_pcvar_float(pcvar_xpgain)+float(get_user_frags(id))-float(lastfrags[id]);
				xp[id]=floatround(helpvar*5.0*get_pcvar_float(pcvar_xpgain));
			}
			if ( get_pcvar_num( pcvar_save_frequent ) == 1 ) 
			{
				SavePlayerData( id );
			}
			lastfrags[id] = get_user_frags(id);
#if defined FRAGBONUS
			if (lastfrags[id]>=(get_pcvar_num(pcvar_fraglimit)) && medal_limit[id]!=0)
			{
				count_frags(id);
			}
#endif
			if( neededxp[id] > 0 )
			{
				if(xp[id] >= neededxp[id])
				{
					new playerlevelOld = playerlevel[id];
					playerlevel[id] = scxpm_calc_lvl(xp[id]);
					skillpoints[id] += playerlevel[id] - playerlevelOld;
					scxpm_calcneedxp(id);
					new name[32];
					get_user_name( id, name, 31 );
					if (playerlevel[id] < get_pcvar_num(pcvar_maxlevel) && playerlevel[id] > 0)
					{
						client_print(id,print_chat,"%s Congratulations, %s, you are now Level %i - Next Level: %i XP - Needed: %i XP",SCXPM,name,playerlevel[id],neededxp[id],neededxp[id]-xp[id])
						if (get_pcvar_num( pcvar_debug ) == 1 )
						{
							log_amx("%s Player %s reached level %i!",SCXPM,name,playerlevel[id]);
						}
						scxpm_getrank(id);
						SCXPMSkill(id);
#if defined COUNT_CTRL
						if(rank[id]>=3)
						{
							SavePlayerData(id);
							if(count_save[id] != 0)
								count_save[id] = 0
						}
						else if (rank[id]<3 && count_save[id]<get_pcvar_num(pcvar_savectrl))
						{
							count_save[id]+=1
						}
						else if (rank[id]<3 && count_save[id]>=get_pcvar_num(pcvar_savectrl))
						{
							//if(playerlevel[id]>0)
							SavePlayerData( id );
							count_save[id] = 0;
						}
#else
						SavePlayerData(id);
#endif
					}
					else if(playerlevel[id] == get_pcvar_num(pcvar_maxlevel))
					{
						client_print(0,print_chat,"%s Everyone say ^"Congratulations!!!^" to %s, who has reached Level %i!",SCXPM,name,get_pcvar_num(pcvar_maxlevel))
						log_amx("%s Player %s reached level %i!",SCXPM,name,get_pcvar_num(pcvar_maxlevel));
						scxpm_getrank(id);
						SCXPMSkill(id);
						SavePlayerData( id );
#if defined COUNT_CTRL
						count_save[id] = 0;
#endif
					}
				}
			}
		}
		else if(playerlevel[id]==get_pcvar_num(pcvar_maxlevel) && maxlvl_count[id]==0)
		{
			xp[id] = scxpm_calc_xp( playerlevel[id] );
			maxlvl_count[id]=1;
			scxpm_showdata(id);
		}
	}
}
#endif
#if !defined USING_SVEN
public scxpm_kill( id ) {
	xp[id] += floatround( 5.0 * get_pcvar_float( pcvar_xpgain ) );
	if ( get_pcvar_num( pcvar_save_frequent ) == 1 && !is_user_hltv(id) )
	{
		SavePlayerData( id );
	}
	scxpm_calcneedxp(id);
	lastfrags[id] = get_user_frags(id);
#if defined FRAGBONUS
	if (lastfrags[id]>=(get_pcvar_num(pcvar_fraglimit)) && medal_limit[id]!=0)
	{
		count_frags(id);
	}
#endif	
	if( neededxp[id] > 0 && !is_user_hltv(id))
	{
		if( xp[id] >= neededxp[id] )
		{
			new playerlevelOld = playerlevel[id];
			playerlevel[id] = scxpm_calc_lvl( xp[id] );
			skillpoints[id] += playerlevel[id] - playerlevelOld;
			scxpm_calcneedxp( id );
			new name[64];
			get_user_name( id, name, 63 );
			if ( playerlevel[id] == 1800 )
			{
				client_print(0,print_chat,"%s Everyone say ^"Congratulations!!!^" to %s, who has reached Level 1800!",SCXPM,name)
				log_amx("%s Player %s reached level 1800!",SCXPM,name);
			}
			else
			{
				client_print(id,print_chat,"%s Congratulations, %s, you are now Level %i - Next Level: %i XP - Needed: %i XP",SCXPM,name,playerlevel[id],neededxp[id],neededxp[id]-xp[id])
				if (get_pcvar_num( pcvar_debug ) == 1 )
				{
					log_amx("%s Player %s reached level %i!",SCXPM,name,playerlevel[id]);
				}
			}
			scxpm_getrank( id );
			SCXPMSkill( id );
			SavePlayerData(id);
		}
	}
}
#endif
#if !defined USING_SVEN
public death() {
	// possibility to save bots' data by using scxpm_save or scxpm_savestyle to set to save with names instead of steamid or ip
//#if !defined USING_SVEN
	new killerId, victimId;
	//weaponId;
	killerId = read_data(1);
	victimId = read_data(2);
	//weaponId = read_data(3);
//#else
//	new victimId;
//	victimId = read_data(2);
//#endif
	if ( get_pcvar_num( pcvar_debug ))
	{
		new nickname[35];
		log_amx( "%s death is triggered.",DEBUG);
#if !defined USING_SVEN
		server_print( "%s killerId: %d",DEBUG,killerId);
		get_user_name(killerId,nickname,34);
		server_print( "%s killer name: %s",DEBUG,nickname);
#endif
		log_amx("%s victimId: %d",DEBUG,victimId);
		get_user_name(victimId,nickname,34);
		log_amx("%s victim name: %s",DEBUG,nickname);
	}
/*
#if defined DEBUG
	new players[32],
		num,
		i;
	get_players(players, num)
	for (i = 0; i<num; i++)
	{
		if (is_user_connected(players[i])
			&& is_user_admin(players[i])
			&& get_pcvar_num(pcvar_debug) >= 1)
		{
			client_print ( players[i], print_console, "Killer: %d", killer )
			client_print ( players[i], print_console, "Victim: %d", victim )
			client_print ( players[i], print_console, "Weapon: %s", weapon )
		}
	}
#endif
*/
#if !defined USING_SVEN
#if defined ALLOW_BOTS
    if (!is_user_connected(killerId) || killerId == victimId ) //  it is trying to register all the bots at once...
#else
	if (!is_user_connected(killerId) || killerId == victimId || is_user_bot(killerId)) // plugin_handled for bot
#endif			
	{
		// turning scxpm_debug off will stop this message from showing up when a bot kills a player or another bot
        if ( get_pcvar_num( pcvar_debug ) == 1 )
        {
            log_amx("%s Suicide or invalid killer/victim, dont award xp for kill",DEBUG);
			// can remove xp for suicide here?
        }
        return PLUGIN_HANDLED;
    }
	if ( playerlevel[killerId] < get_pcvar_num( pcvar_maxlevel ) )
	{
        scxpm_kill( killerId );
    }
#endif
#if defined EVENT_DMG
	PlayerIsHurt[victimId] = false;
#endif
#if defined SPEED_CTRL
	if (get_pcvar_num(pcvar_speedctrl) == 1 && !g_punished[victimId])
	{
		g_hasSpeed[victimId] = false
	}
#endif
	//return PLUGIN_HANDLED;
	return PLUGIN_CONTINUE;
} 
#endif
#if defined EVENT_DMG
//------------------
//	EVENT_Damage()
//------------------
public EVENT_Damage(id)
{
#if defined ALLOW_BOTS
	if (!PlayerIsHurt[id] && is_user_alive(id) && is_user_connected(id))
#else
	// adding "is_user_alive" and "is_user_connected" check to hopefully stop FUN Runtime Error 10 Invalid Player
	if(!PlayerIsHurt[id] && !is_user_bot(id) && is_user_alive(id) && is_user_connected(id))
#endif
	{
		PlayerIsHurt[id] = true
#if defined SPEED_CTRL
		if(get_pcvar_num(pcvar_speedctrl))
		{
			if (!g_punished[id])
			{
				g_hasSpeed[id] = true
				UserSpeed(id)
			}
		}
#endif
#if defined GRAV_DMG
		if(gravity[id]>0 && get_pcvar_num(pcvar_gravity))
			set_user_gravity(id, 1.0)
#endif
#if defined SPEED_CTRL
		if (!g_punished[id])
			set_task(5.0, "reset_status", id)
		else
			set_task(5.0, "reset_regen", id)
#else
		set_task(5.0, "reset_regen", id)
#endif
	}
	return PLUGIN_CONTINUE;
}
public reset_status(id)
{
	PlayerIsHurt[id] = false
#if defined SPEED_CTRL
	if (get_pcvar_num(pcvar_speedctrl) == 1)
	{
		g_hasSpeed[id] = false
		UserSpeed(id)
	}
#endif
#if defined GRAV_DMG
	if (gravity[id]>0 && get_pcvar_num(pcvar_gravity) == 1)
		gravity_enable(id)
#endif
}
public reset_regen(id)
{
	// this function is only for "punished" players
	PlayerIsHurt[id] = false
#if defined GRAV_DMG
	if (gravity[id]>0 && get_pcvar_num(pcvar_gravity) == 1)
	{
		gravity_enable(id)
	}
#endif
}
#endif
#if defined ALLOW_TRADE
public medal_trade(id)
{
	if (trade_limit[id]!=0)
	{
		if (medals[id]>1)
		{
			tradevalue = (get_pcvar_num(pcvar_tradevalue)*(rank[id]+1))
			if(playerlevel[id]<get_pcvar_num(pcvar_maxlevel))
			{
				xp[id] += tradevalue;
				medals[id]-=1
				trade_limit[id]-=1
				new oldLevel = playerlevel[id];
				// now save the stats
				// hopefully adding this here will properly calculate level for player
				playerlevel[id] = scxpm_calc_lvl ( xp[id] );
				scxpm_calcneedxp(id);
				if (playerlevel[id]>=get_pcvar_num(pcvar_maxlevel))
					if(maxlvl_count[id]!=0)
						maxlvl_count[id] = 0
				SavePlayerData( id );
				if (playerlevel[id] > oldLevel && skillpoints[id] > 0)
					SCXPMSkill( id );
				if (get_pcvar_num( pcvar_debug ) == 1 )
				{
					new tradename[32];
					new tradeid[32];
					get_user_name( id, tradename, 31 );
					get_user_authid(id, tradeid, 31 );
					log_amx("%s %s %s traded %i XP and has %i %s remaining.",SCXPM,tradename,tradeid,tradevalue,medals[id]-1,Medals);
					console_print( id, "%s gained %i xp. New xp: %i", tradename,tradevalue, xp[id] );
				}
				client_print(id, print_chat, "%s You traded a Medal for %i XP. You have %i Medals remaining.",SCXPM,tradevalue,medals[id]-1)
			}
			else
				client_print(id, print_chat, "%s You are already at the maximum level.",SCXPM)
		}
		else
		{
			client_print(id, print_chat, "%s You do not have any %s to trade",SCXPM,Medals)
		}
	}
	else
	{
		client_print(id, print_chat, "%s You have already reached the maximum trade limit for this map",SCXPM)
	}
}
public xp_trade(id)
{
	if (trade_limit[id]!=0)
	{
		tradevalue = (get_pcvar_num(pcvar_tradevalue)*(rank[id]+1))
		if (medals[id]<16 && xp[id]>=tradevalue)
		{
			xp[id] -= tradevalue;
			medals[id]+=1;
			trade_limit[id]-=1;
			new oldLevel = playerlevel[id]
			playerlevel[id] = scxpm_calc_lvl ( xp[id] );
			scxpm_calcneedxp(id);
			scxpm_getrank( id );
			SavePlayerData( id );
			if (oldLevel < playerlevel[id])
			{
				SCXPMSkill( id );
			}
			else if (oldLevel > playerlevel[id])
			{
				//new random_skill=random_num(1, 9)
				if(health[id] > 0)
					health[id]-=1;
				else if (armor[id] > 0)
					armor[id]-=1;
				else if (rhealth[id] > 0)
					rhealth[id]-=1;
				else if (rarmor[id]>0)
					rarmor[id]-=1;
				else if (rammo[id]>0)
					rammo[id]-=1;
				else if (gravity[id]>0)
					gravity[id]-=1;
				else if (speed[id]>0)
					speed[id]-=1;
				else if (dist[id]>0)
					dist[id]-=1;
				else if (dodge[id]>0)
					dodge[id]-=1;
			}
			if (playerlevel[id]>=get_pcvar_num(pcvar_maxlevel))
			{
				if(maxlvl_count[id]!=0)
					maxlvl_count[id] = 0
			}
			if (get_pcvar_num( pcvar_debug ) == 1 )
			{
				// for logging purposes
				new tradename[32];
				new tradeid[32];
				get_user_name( id, tradename, 31 );
				get_user_authid(id, tradeid, 31 );
				log_amx("%s %s %s traded %i XP for a Medal.",SCXPM,tradename,tradeid,tradevalue);
				console_print( id, "%s traded %i xp. New xp: %i", tradename, tradevalue, xp[id] );
			}
#if defined HEALTH_CTRL
			get_max_hp(id);
#endif
#if defined ARMOR_CTRL
			get_max_ap(id);
#endif
			client_print(id, print_chat, "%s You traded %i XP for a medal. You now have %i %s.",SCXPM,tradevalue,medals[id]-1,Medals)
		}
		else if(medals[id]==16 && xp[id]>=tradevalue)
			client_print(id, print_chat, "%s You already have 15 %s.",SCXPM,Medals)
		else
			client_print(id, print_chat, "%s You do not have enough XP to trade for a Medal.",SCXPM)
	}
	else
		client_print(id, print_chat, "%s You have already reached the maximum trade limit for this map",SCXPM)
}
#endif
#if defined FRAGBONUS
// going to use scxpm_reexp as the function to trigger the medal giving?
// idea to increase pcvar_fraglimit by a multiplier of levels based on player level or rank - costs more frags to get medal, but also gives more xp when buying xp with medal?
public count_frags(id)
{
	if (medals[id]<16&&medals[id]>=1)
	{
		fragcount = (get_pcvar_num(pcvar_fraglimit))
		if(lastfrags[id] >= fragcount)
		{
			resetfrags = (lastfrags[id]-fragcount);
			medals[id]+=1
#if defined HEALTH_CTRL
			get_max_hp(id);
#endif
#if defined ARMOR_CTRL
			get_max_ap(id);
#endif
			client_print(id, print_chat, "%s You won a Medal for getting %i frags. Your frags will be reset to %i.",SCXPM,fragcount,resetfrags)
			medal_limit[id]-=1
			set_user_frags(id, resetfrags);
			lastfrags[id] = resetfrags;
			if (get_pcvar_num( pcvar_debug ) == 1 )
			{
				new tradename[32];
				new tradeid[32];
				get_user_name( id, tradename, 31 );
				get_user_authid(id, tradeid, 31 );
				log_amx("%s %s %s won a Medal for getting %i frags. Frags will be reset to %i.",SCXPM,tradename,tradeid,fragcount,resetfrags);
			}
		}
		else
		{
			if (get_pcvar_num( pcvar_debug ) == 1 )
			{
				new tradename[32];
				new tradeid[32];
				get_user_name( id, tradename, 31 );
				get_user_authid(id, tradeid, 31 );
				new fragcount=((get_pcvar_num(pcvar_fraglimit)+rank[id])-(get_pcvar_num(pcvar_fraglimit)))
				client_print(id, print_chat, "%s You need %i more frags to get a Medal.",SCXPM,fragcount-lastfrags[id])
				log_amx("%s %s needs %i more frags to get a Medal.", tradename, tradeid, fragcount-lastfrags[id])
			}
		}
	}
	else if(medals[id]==16)
	{
		fragcount = (get_pcvar_num(pcvar_fraglimit))
		if (lastfrags[id] >= fragcount)
		{
			fragbonus = (get_pcvar_num(pcvar_bonus)*(rank[id]+1))
			resetfrags = (lastfrags[id]-fragcount)
			medal_limit[id]-=1
			xp[id] += fragbonus;
			set_user_frags(id, resetfrags)
			client_print(id, print_chat, "%s You already have %i %s and cannot hold any more",SCXPM,medals[id]-1,fragbonus,Medals)
			client_print(id, print_chat, "%s %i XP will be credited for getting %i frags. Your frags will be reset to %i.",SCXPM,fragbonus, fragcount, resetfrags)
			if (get_pcvar_num( pcvar_debug ) == 1 )
			{
				// for logging purposes
				new tradename[32];
				new tradeid[32];
				get_user_name( id, tradename, 31 );
				get_user_authid(id, tradeid, 31 );
				log_amx("%s %s %s already has %i Medals and cannot hold any more.",SCXPM,tradename,tradeid,medals[id]-1);
				log_amx("%s %i XP will be credited to %s for getting %i frags.",SCXPM,fragbonus,tradename,fragcount);
				// console_print( id, "%s gained %i xp. New xp: %i", tradename, fragbonus, xp[id] );
			}
		}
	}
	// BUG FIX!! LOL Forgot to do the check about for if player has 15 medals.
	// Actually, this causes a bug? change to 0 from 1
	// error check
	else if(medals[id]<=0)
	{
		medals[id]=1
#if defined HEALTH_CTRL
		get_max_hp(id);
#endif
#if defined ARMOR_CTRL
		get_max_ap(id);
#endif
	}
/*
else
{
	client_print(id, print_chat, "You already won a medal in this map.")
	if (get_pcvar_num( pcvar_debug ) == 1 )
	{
		// for logging purposes
		new tradename[32];
		new tradeid[32];
		get_user_name( id, tradename, 31 );
		get_user_authid(id, tradeid, 31 );
		log_amx("[SCXPM] %s %s already won a Medal on this map.", tradename, tradeid);
		// console_print( id, "%s gained %i xp. New xp: %i", tradename, fragbonus, xp[id] );
	}
}
*/
}
#endif
// show players data
#if !defined USING_SVEN
public scxpm_showdata(id) {
	set_hudmessage(50,135,180,0.7,0.04,0,1.0,255.0,0.0,0.0,get_pcvar_num(pcvar_hud_channel))
	if(playerlevel[id]<get_pcvar_num(pcvar_maxlevel))
	{
		if ( get_user_health( id ) > 250 || get_user_armor( id ) > 250)
		{
			if (skillpoints[id]<1)
			{
				show_hudmessage(id,"Exp.:   %i / %i  (+%i)^nLevel:   %i / %i^nRank:   %s^nMedals:   %i / 15^nHealth:   %i^nArmor:   %i", xp[id],neededxp[id],neededxp[id]-xp[id],playerlevel[id],get_pcvar_num( pcvar_maxlevel ),ranks[rank[id]],medals[id]-1, get_user_health( id ), get_user_armor( id ))
			}
			else
			{
				show_hudmessage(id,"Exp.:   %i / %i  (+%i)^nLevel:   %i / %i^nRank:   %s^nMedals:   %i / 15^nHealth:   %i^nArmor:   %i^nPoints:   %i", xp[id],neededxp[id],neededxp[id]-xp[id],playerlevel[id],get_pcvar_num( pcvar_maxlevel ),ranks[rank[id]],medals[id]-1, get_user_health( id ), get_user_armor( id ), skillpoints[id])
			}
		}
		else
		{
			if (skillpoints[id]<1)
			{
				show_hudmessage(id,"Exp.:   %i / %i  (+%i)^nLevel:   %i / %i^nRank:   %s^nMedals:   %i / 15", xp[id],neededxp[id],neededxp[id]-xp[id],playerlevel[id],get_pcvar_num( pcvar_maxlevel ),ranks[rank[id]],medals[id]-1)
			}
			else
			{
				show_hudmessage(id,"Exp.:   %i / %i  (+%i)^nLevel:   %i / %i^nRank:   %s^nMedals:   %i / 15^nPoints:   %i", xp[id],neededxp[id],neededxp[id]-xp[id],playerlevel[id],get_pcvar_num( pcvar_maxlevel ),ranks[rank[id]],medals[id]-1, skillpoints[id])
			}
		}
	}
	else if ( playerlevel[id] >= get_pcvar_num( pcvar_maxlevel ) ) {
		if ( get_user_health( id ) > 250 || get_user_armor( id ) > 250)
		{
			show_hudmessage(id,"Exp.:   %i^nLevel:   %i / %i^nRank:   %s^nMedals:   %i / 15^nHealth:   %i^nArmor:   %i", xp[id],playerlevel[id],get_pcvar_num( pcvar_maxlevel ),ranks[rank[id]],medals[id]-1, get_user_health( id ), get_user_armor( id ))
		}
		else
		{
			show_hudmessage(id,"Exp.:   %i^nLevel:   %i / %i^nRank:   %s^nMedals:   %i / 15", xp[id],playerlevel[id],get_pcvar_num( pcvar_maxlevel ),ranks[rank[id]],medals[id]-1)
		}
	}
}
#else
public scxpm_showdata(id) {
	//set_hudmessage(50,135,180,0.7,0.04,0,1.0,11.0,0.0,0.0,get_pcvar_num(pcvar_hud_channel)) // trying to reduce time this is on screen...unneeded for 255.0 seconds? - task time of scxpm_regen counter sets to 10-11 seconds, so perhaps set this to 12?...
	set_hudmessage(50,135,180,0.7,0.04,0,1.0,255.0,0.0,0.0,get_pcvar_num(pcvar_hud_channel))
	if(playerlevel[id]<get_pcvar_num(pcvar_maxlevel))
	{
		if (skillpoints[id]<1)
		{
			show_hudmessage(id,"Exp.:   %i / %i  (+%i)^nLevel:   %i / %i^nRank:   %s^nMedals:   %i / 15", xp[id],neededxp[id],neededxp[id]-xp[id],playerlevel[id],get_pcvar_num( pcvar_maxlevel ),ranks[rank[id]],medals[id]-1)
		}
		else
		{
			show_hudmessage(id,"Exp.:   %i / %i  (+%i)^nLevel:   %i / %i^nRank:   %s^nMedals:   %i / 15^nPoints:   %i", xp[id],neededxp[id],neededxp[id]-xp[id],playerlevel[id],get_pcvar_num( pcvar_maxlevel ),ranks[rank[id]],medals[id]-1, skillpoints[id])
		}
	}
	else 
	{
		if (skillpoints[id]<1)
		{
			show_hudmessage(id,"Exp.:   %i^nLevel:   %i / %i^nRank:   %s^nMedals:   %i / 15", xp[id],playerlevel[id],get_pcvar_num( pcvar_maxlevel ),ranks[rank[id]],medals[id]-1)
		}
		else
		{
			show_hudmessage(id,"Exp.:   %i^nLevel:   %i / %i^nRank:   %s^nMedals:   %i / 15^nPoints:   %i", xp[id],playerlevel[id],get_pcvar_num( pcvar_maxlevel ),ranks[rank[id]],medals[id]-1, skillpoints[id])
		}
	}
}
#endif
// "loopcalc.inl"
// new loop check designed by Swamp Dog - July 12, 2016 - August ??, 2016
//To reduce amount of checks in a loop every second, it is desirable to make a function for each possible combination of cvars - combinatorics
#if defined NEW_LOOP
public scxpm_loop_switch(id)
{
#if defined ALLOW_BOTS
	if(is_user_connected(id))
#else
	if(is_user_connected(id) && !is_user_bot(id))
#endif
	{
		client_print(id, print_chat, "%s Please wait for your skills to be loaded.",SCXPM);
#if defined COUNT_CTRL
		if (playerlevel[id]<get_pcvar_num(pcvar_maxlevel) && count_save[id]!=0)
			count_save[id] = 0
#endif
		set_player_loop(id)
		if(get_pcvar_num(pcvar_debug) > 0)
		{
			client_print(id, print_chat, "%s Skills loaded: %s: %i %s: %i %s: %i %s: %i %s: %i",DEBUG,HPRe,get_pcvar_num(pcvar_hpregen),APRe,get_pcvar_num(pcvar_nano), AmmoRe,get_pcvar_num(pcvar_ammo),TeamP,get_pcvar_num(pcvar_teampower),Block,get_pcvar_num(pcvar_block));
			client_print(id, print_chat, "%s Loop loaded = %i",DEBUG,loopcheck)
		}
	}
}
// needs to be loaded at least 7.2 seconds after server starts because of admin_sql_sc settings to delay load - swmpdg
// Thanks to J-M for his help finding duplicates and learnin' me somethin' - Swamp Dog
// can possibly make this better by only checking 1 cvar at a time instead of 5 at a time.
public cvar_loopcalc()
{
#if defined ENTITY_CHECK
	check_for_entities();
#endif
	if(get_pcvar_num(pcvar_hpregen))
	{
		if(get_pcvar_num(pcvar_nano))
			if (get_pcvar_num(pcvar_ammo))
				if(get_pcvar_num(pcvar_teampower))
					// full skills: hp, ap, ammo, tp, block
					if(get_pcvar_num(pcvar_block))
						loopcheck=1;
					else
						// hp, ap, ammo, tp
						loopcheck=2;
				else
					//hp, ap, ammo, block
					if(get_pcvar_num(pcvar_block))
						loopcheck=23;
					else
						// hp, ap, ammo
						loopcheck=3;
			else
				if(get_pcvar_num(pcvar_teampower))
					//hp, ap, tp, block
					if(get_pcvar_num(pcvar_block))
						loopcheck=19;
					else
						// hp, ap, tp
						loopcheck=20;
				else
					// hp, ap, block
					if(get_pcvar_num(pcvar_block))
						loopcheck=25;
					else
						// hp, ap
						loopcheck=4;
		else
			if(get_pcvar_num(pcvar_ammo))
				if(get_pcvar_num(pcvar_teampower))
					// hp, ammo, tp, block
					if(get_pcvar_num(pcvar_block))
						loopcheck=16;
					else
						// hp, ammo, tp
						loopcheck=17;
				else
					// hp, ammo, block
					if(get_pcvar_num(pcvar_block))
						loopcheck=30;
					else
						// hp, ammo
						loopcheck=18;
			else
				if(get_pcvar_num(pcvar_teampower))
					// hp, tp, block
					if(get_pcvar_num(pcvar_block))
						loopcheck=28;
					else
						// hp, tp
						loopcheck=29;
				else
					// hp, block
					if(get_pcvar_num(pcvar_block))
						loopcheck=26;
					else
						// hp
						loopcheck=5;
	}
	else if(get_pcvar_num(pcvar_nano))
	{
		if (get_pcvar_num(pcvar_ammo))
			if(get_pcvar_num(pcvar_teampower))
				// ap, ammo, tp, block
				if(get_pcvar_num(pcvar_block))
					loopcheck=6;
				else
					// ap, ammo, tp
					loopcheck=7;
			else
				// ap, ammo, block
				if(get_pcvar_num(pcvar_block))
					loopcheck=24;
				else
					// ap, ammo
					loopcheck=8;
		else
			if(get_pcvar_num(pcvar_teampower))
				// ap, tp, block
				if(get_pcvar_num(pcvar_block))
					loopcheck=21;
				else
					// ap, tp
					loopcheck=22;
			else
				// ap, block
				if(get_pcvar_num(pcvar_block))
					loopcheck=27;
				else
					// ap
					loopcheck=9;
	}
	else if(get_pcvar_num(pcvar_ammo))
	{
		if(get_pcvar_num(pcvar_teampower))
			// ammo, tp, block
			if(get_pcvar_num(pcvar_block))
				loopcheck=10;
			else
				// ammo, tp
				loopcheck=11;
		else
			// ammo, block
			if(get_pcvar_num(pcvar_block))
				loopcheck=31;
			else
				// ammo
				loopcheck=12;
	}
	else if(get_pcvar_num(pcvar_teampower))
	{
		// tp, block
		if(get_pcvar_num(pcvar_block))
			loopcheck=13;
		else
			// tp
			loopcheck=14;
	}
	else if (get_pcvar_num(pcvar_block))
			// block
			loopcheck=15;
	else
	{
		log_amx("%s There was an error loading SCXPM skill control cvars",SCXPM)
		loopcheck=1;
	}
	if(get_pcvar_num(pcvar_debug) > 0)
	{
		log_amx("%s Skills loaded: %s: %i %s: %i %s: %i %s: %i %s: %i",DEBUG,HPRe,get_pcvar_num(pcvar_hpregen),APRe,get_pcvar_num(pcvar_nano),AmmoRe,get_pcvar_num(pcvar_ammo),TeamP,get_pcvar_num(pcvar_teampower),Block,get_pcvar_num(pcvar_block));
		log_amx("%s Loop loaded: loopcheck = %i",DEBUG,loopcheck)
	}
}
#endif
// Explicit customization to use only certain skills when loading the loop check - idea and design by swampdog, to cut down processing needed and to stop breaking sven coop maps
// see main.inl for combinations (combinatorics mathemtatics)
// new loop check designed by swampdog - July 12, 2016
public scxpm_regen(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
				if(rarmor[id]>0)
					APRegen(id)
				if(rammo[id]>0)
					AmmoHPAP(id)
				if(dist[id]>0)
					AmmoTPHPAP(id)
#if defined EVENT_DMG				
			}
#endif
			if(dodge[id]>0)
				BlockAttack(id)
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
#if defined NEW_LOOP
// hp, ap, ammo, tp
public scxpm_regen2(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
				if(rarmor[id]>0)
					APRegen(id)
				if(rammo[id]>0)
					AmmoHPAP(id)
				if(dist[id]>0)
					AmmoTPHPAP(id)
#if defined EVENT_DMG				
			}
#endif
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// hp, ap, ammo
public scxpm_regen3(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
				if(rarmor[id]>0)
					APRegen(id)
				if(rammo[id]>0)
					AmmoHPAP(id)
#if defined EVENT_DMG				
			}
#endif
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// hp, ap
public scxpm_regen4(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
				if(rarmor[id]>0)
					APRegen(id)
#if defined EVENT_DMG				
			}
#endif
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// hp
public scxpm_regen5(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
#if defined EVENT_DMG				
			}
#endif
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// ap, ammo, tp, block
public scxpm_regen6(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rarmor[id]>0)
					APRegen(id)
				if(rammo[id]>0)
					AmmoAP(id)
				if(dist[id]>0)
					AmmoTPAP(id)
#if defined EVENT_DMG				
			}
#endif
			if(dodge[id]>0)
				BlockAttack(id)
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// ap, ammo, tp
public scxpm_regen7(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rarmor[id]>0)
					APRegen(id)
				if(rammo[id]>0)
					AmmoAP(id)
				if(dist[id]>0)
					AmmoTPAP(id)
#if defined EVENT_DMG				
			}
#endif
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// ap, ammo
public scxpm_regen8(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rarmor[id]>0)
					APRegen(id)
				if(rammo[id]>0)
					AmmoAP(id)
#if defined EVENT_DMG				
			}
#endif
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// ap
public scxpm_regen9(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rarmor[id]>0)
					APRegen(id)
#if defined EVENT_DMG				
			}
#endif
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// ammo, tp, block
public scxpm_regen10(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rammo[id]>0)
					AmmoOnly(id)
				if(dist[id]>0)
					AmmoTP(id)
#if defined EVENT_DMG				
			}
#endif
			if(dodge[id]>0)
			{
				BlockAttack(id)
			}
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// ammo, tp
public scxpm_regen11(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rammo[id]>0)
					AmmoOnly(id)
				if(dist[id]>0)
					AmmoTP(id)
#if defined EVENT_DMG				
			}
#endif
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// ammo
public scxpm_regen12(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rammo[id]>0)
					AmmoOnly(id)
#if defined EVENT_DMG				
			}
#endif
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// tp, block
public scxpm_regen13(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(dist[id]>0)
					TeamPower(id)
#if defined EVENT_DMG				
			}
#endif
			if(dodge[id]>0)
				BlockAttack(id)
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// tp
public scxpm_regen14(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(dist[id]>0)
					TeamPower(id)
#if defined EVENT_DMG				
			}
#endif
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// block
public scxpm_regen15(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
			if(dodge[id]>0)
				BlockAttack(id)
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// hp, ammo, tp, block
public scxpm_regen16(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
				if(rammo[id]>0)
					AmmoHP(id)
				if(dist[id]>0)
					AmmoTPHP(id)
#if defined EVENT_DMG				
			}
#endif
			if(dodge[id]>0)
				BlockAttack(id)
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// hp, ammo, tp
public scxpm_regen17(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
				if(rammo[id]>0)
					AmmoHP(id)
				if(dist[id]>0)
					AmmoTPHP(id)
#if defined EVENT_DMG				
			}
#endif
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// hp, ammo
public scxpm_regen18(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
				if(rammo[id]>0)
					AmmoHP(id)
#if defined EVENT_DMG				
			}
#endif
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// hp, ap, tp, block
public scxpm_regen19(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
				if(rarmor[id]>0)
					APRegen(id)
				if(dist[id]>0)
					TeamHPAP(id)
#if defined EVENT_DMG				
			}
#endif
			if(dodge[id]>0)
				BlockAttack(id)
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// hp, ap, tp
public scxpm_regen20(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
				if(rarmor[id]>0)
					APRegen(id)
				if(dist[id]>0)
					TeamHPAP(id)
#if defined EVENT_DMG				
			}
#endif
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// ap, tp, block
public scxpm_regen21(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rarmor[id]>0)
					APRegen(id)
				if(dist[id]>0)
					TeamAP(id)
#if defined EVENT_DMG				
			}
#endif
			if(dodge[id]>0)
				BlockAttack(id)
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// ap, tp
public scxpm_regen22(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rarmor[id]>0)
					APRegen(id)
				if(dist[id]>0)
					TeamAP(id)
#if defined EVENT_DMG				
			}
#endif
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// hp, ap, ammo, block
public scxpm_regen23(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
				if(rarmor[id]>0)
					APRegen(id)
				if(rammo[id]>0)
					AmmoHPAP(id)
#if defined EVENT_DMG				
			}
#endif
			if(dodge[id]>0)
				BlockAttack(id)
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// ap, ammo, block
public scxpm_regen24(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rarmor[id]>0)
					APRegen(id)
				if(rammo[id]>0)
					AmmoAP(id)
#if defined EVENT_DMG				
			}
#endif
			if(dodge[id]>0)
				BlockAttack(id)
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// hp, ap, block
public scxpm_regen25(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
				if(rarmor[id]>0)
					APRegen(id)
#if defined EVENT_DMG				
			}
#endif
			if(dodge[id]>0)
				BlockAttack(id)
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// hp, block
public scxpm_regen26(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
#if defined EVENT_DMG				
			}
#endif
			if(dodge[id]>0)
				BlockAttack(id)
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// ap, block
public scxpm_regen27(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rarmor[id]>0)
					APRegen(id)
#if defined EVENT_DMG				
			}
#endif
			if(dodge[id]>0)
				BlockAttack(id)
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// hp, tp, block
public scxpm_regen28(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
				if(dist[id]>0)
					TeamHP(id)
#if defined EVENT_DMG				
			}
#endif
			if(dodge[id]>0)
				BlockAttack(id)
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// hp, tp
public scxpm_regen29(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
				if(dist[id]>0)
					TeamHP(id)
#if defined EVENT_DMG				
			}
#endif
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// hp, ammo, block
public scxpm_regen30(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
				if(rammo[id]>0)
					AmmoHP(id)
#if defined EVENT_DMG				
			}
#endif
			if(dodge[id]>0)
				BlockAttack(id)
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// ammo, block
public scxpm_regen31(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rammo[id]>0)
					AmmoOnly(id)
#if defined EVENT_DMG				
			}
#endif
			if(dodge[id]>0)
				BlockAttack(id)
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
#endif // NEW_LOOP
// "menu.inl" 
// show skill calculation
public SCXPMSkill( id ) {
	// the default value for the increment is 1
	skillIncrement[id] = 1;
#if defined ALLOW_BOTS
	if (skillpoints[id] > 20 )
#else
	if (skillpoints[id] > 20 && !is_user_bot(id))
#endif
		SCXPMIncrementMenu( id );
#if !defined ALLOW_BOTS
	else if(!is_user_bot(id))
#else
	else
#endif
		SCXPMSkillMenu( id );
}
// show the skills menu
public SCXPMSkillMenu( id ) {
	new menuBody[1024];
	format(menuBody,1023,"%L",LANG_SERVER,"L_MENU_SKILL_BODY",skillpoints[id],Stre,health[id],SupArm,armor[id],HPRe,rhealth[id],APRe,rarmor[id],AmmoRe,rammo[id],Grav,gravity[id],Aware,speed[id],TeamP,dist[id],Block,dodge[id]);
	show_menu(id,(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)|(1<<7)|(1<<8)|(1<<9),menuBody,13,"select_skill");
}
// show the increment menu
public SCXPMIncrementMenu( id ) {
	new menuBody[1024];
	if (skillpoints[id] >= 20 && skillpoints[id] < 50)
		format(menuBody,1023,"%L",LANG_SERVER,"L_MENU_INCREMENT1");
	else if (skillpoints[id] >= 50 && skillpoints[id] < 100)
		format(menuBody,1023,"%L",LANG_SERVER,"L_MENU_INCREMENT2");	
	else if (skillpoints[id] >= 100)
		format(menuBody,1023,"%L",LANG_SERVER,"L_MENU_INCREMENT3");
	show_menu(id,(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5),menuBody,13,"select_increment");
}
public SCXPMIncrementChoice( id, key ) {
	switch(key)
	{
		case 0:
			skillIncrement[id] = 1;
		case 1:
			skillIncrement[id] = 5;
		case 2:
			skillIncrement[id] = 10;
		case 3:
			skillIncrement[id] = 25;
		case 4:
			skillIncrement[id] = 50;
		case 5:
			skillIncrement[id] = 100;
	}
	SCXPMSkillMenu( id );
}
// choose a skill
public SCXPMSkillChoice( id, key ) {
	switch(key)
	{
		case 0:
		{
			if(skillpoints[id]>0)
			{
				if(health[id]<450)
				{
					if(get_pcvar_num(pcvar_health))
					{
						if (skillIncrement[id] + health[id] >= 450) 
							skillIncrement[id] = 450 - health[id];
						if (skillpoints[id] >= skillIncrement[id])
						{
							skillpoints[id] -= skillIncrement[id];
							health[id] += skillIncrement[id];
#if defined HEALTH_CTRL
							get_max_hp(id);
#endif
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],Stre,health[id]);
							if(is_user_alive(id))
							{
								set_user_health(id, get_user_health(id) + skillIncrement[id]);
#if defined HEALTH_CTRL
								max_hp_check(id);
#else
								if(get_user_health(id) > 645)
									set_user_health(id, 645)
#endif
							}
						}
						else
						{
							skillIncrement[id] = skillpoints[id];
							skillpoints[id] -= skillIncrement[id];
							health[id] += skillIncrement[id];
#if defined HEALTH_CTRL
							get_max_hp(id);						
#endif
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],Stre,health[id]);
							if(is_user_alive(id))
							{
								set_user_health(id, get_user_health(id) + skillIncrement[id]);
#if defined HEALTH_CTRL
								max_hp_check(id);
#else
								if(get_user_health(id) > 645)
									set_user_health(id, 645)
#endif
							}
						}
#if defined HEALTH_CTRL
					}
					else
						client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG2",SCXPM,Stre);
#endif
				}
				else
					client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG3",SCXPM,Stre);
				if(skillpoints[id]>0)
					SCXPMSkill(id);
			}
			else
				client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG4",SCXPM,Stre);
		}
		case 1:
		{
			if(skillpoints[id]>0)
			{
				if(armor[id]<450)
				{
#if defined ARMOR_CTRL
					if(get_pcvar_num(pcvar_armor))
					{
#endif
						if (skillIncrement[id] + armor[id] >= 450) 
							skillIncrement[id] = 450 - armor[id];
						if (skillpoints[id] >= skillIncrement[id])
						{
							skillpoints[id]-= skillIncrement[id];
							armor[id] += skillIncrement[id];
#if defined ARMOR_CTRL
							get_max_ap(id);
#endif
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],SupArm,armor[id]);
							if(is_user_alive(id))
							{
#if defined USING_CS
								cs_set_user_armor(id,get_user_armor(id)+skillIncrement[id], CS_ARMOR_VESTHELM);
#else
								set_user_armor(id,get_user_armor(id)+skillIncrement[id]);
#endif
#if defined ARMOR_CTRL
								max_ap_check(id);
#else
								if(get_user_armor(id)>645)
#if defined USING_CS
									cs_set_user_armor(id, 645, CS_ARMOR_VESTHELM);
#else
									set_user_armor(id, 645);
#endif
#endif
							}
						}
						else
						{
							skillIncrement[id] = skillpoints[id];
							skillpoints[id]-= skillIncrement[id];
							armor[id] += skillIncrement[id];
#if defined ARMOR_CTRL
							get_max_ap(id);
#endif
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],SupArm,armor[id]);
							if(is_user_alive(id))
							{
#if defined USING_CS
								cs_set_user_armor(id,get_user_armor(id)+skillIncrement[id], CS_ARMOR_VESTHELM);
#else
								set_user_armor(id,get_user_armor(id)+skillIncrement[id]);
#endif
#if defined ARMOR_CTRL
								max_ap_check(id);
#else
								if(get_user_armor(id)>645)
#if defined USING_CS
									cs_set_user_armor(id, 645, CS_ARMOR_VESTHELM);
#else
									set_user_armor(id, 645);
#endif
#endif
							}
						}
#if defined ARMOR_CTRL
					}
					else
						client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG2",SCXPM,SupArm);
#endif					
				}
				else
					client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG3",SCXPM,SupArm);
				if(skillpoints[id]>0)
					SCXPMSkill(id)
			}
			else
				client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG4",SCXPM,SupArm);
		}
		case 2:
		{
			if(skillpoints[id]>0)
			{
				if(rhealth[id]<300)
				{
#if defined HPREGEN_CTRL
					if(get_pcvar_num(pcvar_hpregen))
					{
#endif
						if (skillIncrement[id] + rhealth[id] >= 300)
							skillIncrement[id] = 300 - rhealth[id];
						if (skillpoints[id] >= skillIncrement[id])
						{
							skillpoints[id] -= skillIncrement[id];
							rhealth[id] += skillIncrement[id];
							rhealthwait[id]=rhealth[id];
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],HPRe,rhealth[id]);
						}
						else
						{
							skillIncrement[id] = skillpoints[id];
							skillpoints[id] -= skillIncrement[id];
							rhealth[id] += skillIncrement[id];
							rhealthwait[id]=rhealth[id]
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],HPRe,rhealth[id]);
						}
#if defined HPREGEN_CTRL
					}
					else
						client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG2",SCXPM,HPRe);
#endif
				}
				else
					client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG3",SCXPM,HPRe);
				if(skillpoints[id]>0)
					SCXPMSkill(id)
			}
			else
				client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG4",SCXPM,HPRe);
		}
		case 3:
		{
			if(skillpoints[id]>0)
			{
				if(rarmor[id]<300)
				{
#if defined NANO_CTRL
					if(get_pcvar_num(pcvar_nano))
					{
#endif
						if (skillIncrement[id] + rarmor[id] >= 300)
							skillIncrement[id] = 300 - rarmor[id];
						if (skillpoints[id] >= skillIncrement[id])
						{
							skillpoints[id] -= skillIncrement[id];
							rarmor[id] += skillIncrement[id];
							rarmorwait[id]=rarmor[id]
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],APRe,rarmor[id]);
						}
						else
						{
							skillIncrement[id] = skillpoints[id]
							skillpoints[id] -= skillIncrement[id];
							rarmor[id] += skillIncrement[id];
							rarmorwait[id]=rarmor[id];
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],APRe,rarmor[id]);
						}
#if defined NANO_CTRL
					}
					else
						client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG2",SCXPM,APRe);
#endif
				}
				else
					client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG3",SCXPM,APRe);
				if(skillpoints[id]>0)
					SCXPMSkill(id)
			}
			else
				client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG4",SCXPM,APRe);
		}
		case 4:
		{
			if(skillpoints[id]>0)
			{
				if(rammo[id]<30)
				{
#if defined AMMO_CTRL
					if(get_pcvar_num(pcvar_ammo))
					{
#endif
						if (skillIncrement[id] + rammo[id] >= 30)
							skillIncrement[id] = 30 - rammo[id];
						if (skillpoints[id] >= skillIncrement[id])
						{
							skillpoints[id] -= skillIncrement[id];
							rammo[id] += skillIncrement[id];
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],AmmoRe,rammo[id]);
						}
						else
						{
							skillIncrement[id] = skillpoints[id];
							skillpoints[id] -= skillIncrement[id];
							rammo[id] += skillIncrement[id];
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],AmmoRe,rammo[id]);
						}
					}
#if defined AMMO_CTRL
					else
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG2",SCXPM,AmmoRe);
#endif
				}
				else
					client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG3",SCXPM,AmmoRe);
				if(skillpoints[id]>0)
					SCXPMSkill(id)
			}
			else
				client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG4",SCXPM,AmmoRe);
		}
		case 5:
		{
			if(skillpoints[id]>0)
			{
				if(gravity[id]<40)
				{
					if (get_pcvar_num(pcvar_gravity) >= 1)
					{
						if (skillIncrement[id] + gravity[id] >= 40)
							skillIncrement[id] = 40 - gravity[id];
						if (skillpoints[id] >= skillIncrement[id])
						{
							skillpoints[id] -= skillIncrement[id];
							gravity[id] += skillIncrement[id];
							if (is_user_alive(id))
								gravity_enable(id);
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],Grav,gravity[id]);
						}
						else
						{
							skillIncrement[id] = skillpoints[id];
							skillpoints[id] -= skillIncrement[id];
							gravity[id] += skillIncrement[id];
							if (is_user_alive(id))
								gravity_enable(id);
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],Grav,gravity[id]);
						}
					}
					else
						client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG2",SCXPM,Grav);
				}
				else
					client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG3",SCXPM,Grav);
				if(skillpoints[id]>0)
					SCXPMSkill(id)
			}
			else
				client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG4",SCXPM,Grav);
		}
		case 6:
		{
			if(skillpoints[id]>0)
			{
				if(speed[id]<80)
				{
					if (skillIncrement[id] + speed[id] >= 80)
						skillIncrement[id] = 80 - speed[id];
					if (skillpoints[id] >= skillIncrement[id])
					{
						skillpoints[id] -= skillIncrement[id];
						speed[id] += skillIncrement[id];
						client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],Aware,speed[id]);
					}
					else
					{
						skillIncrement[id] = skillpoints[id];
						skillpoints[id] -= skillIncrement[id];
						speed[id] += skillIncrement[id];
						client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],Aware,speed[id]);
					}
#if defined ARMOR_CTRL
					get_max_ap(id);
#endif
#if defined HEALTH_CTRL
					get_max_hp(id);
#endif
				}
				else
					client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG3",SCXPM,Aware);
				if(skillpoints[id]>0)
					SCXPMSkill(id)
			}
			else
				client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG4",SCXPM,Aware);
		}
		case 7:
		{
			if(skillpoints[id]>0)
			{
				if(dist[id]<60)
				{
#if defined TP_CTRL
					if(get_pcvar_num(pcvar_teampower))
					{
#endif
						if (skillIncrement[id] + dist[id] >= 60)
							skillIncrement[id] = 60 - dist[id];
						if (skillpoints[id] >= skillIncrement[id])
						{
							skillpoints[id] -= skillIncrement[id];
							dist[id] += skillIncrement[id];
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],TeamP,dist[id]);
						}
						else
						{
							skillIncrement[id] = skillpoints[id];
							skillpoints[id] -= skillIncrement[id];
							dist[id] += skillIncrement[id];
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],TeamP,dist[id]);
						}
#if defined TP_CTRL
					}
					else
						client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG2",SCXPM,TeamP);
#endif
				}
				else
					client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG3",SCXPM,TeamP);
				if(skillpoints[id]>0)
					SCXPMSkill(id)
			}
			else
				client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG4",SCXPM,TeamP);
		}
		case 8:
		{
			if(skillpoints[id]>0)
			{
				if(dodge[id]<90)
				{
#if defined BLOCK_CTRL
					if(get_pcvar_num(pcvar_block))
					{
#endif
						if (skillIncrement[id] + dodge[id] >= 90)
							skillIncrement[id] = 90 - dodge[id];
						if (skillpoints[id] >= skillIncrement[id])
						{
							skillpoints[id] -= skillIncrement[id];
							dodge[id] += skillIncrement[id];
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],Block,dodge[id]);
						}
						else
						{
							skillIncrement[id] = skillpoints[id];
							skillpoints[id] -= skillIncrement[id];
							dodge[id] += skillIncrement[id];
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],Block,dodge[id]);
						}
#if defined BLOCK_CTRL
					}
					else
						client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG2",SCXPM,Block);
#endif
				}
				else
					client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG3",SCXPM,Block);
				if(skillpoints[id]>0)
					SCXPMSkill(id)
			}
			else
				client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG4",SCXPM,Block);
		}
		case 9:
		{
		}
	}
	return PLUGIN_HANDLED;
}
#if defined ALLOW_MONSTERS
public monster_killed(monster, attacker, shouldgib)
{
	if ( pev(monster, pev_flags) & FL_MONSTER && pev(monster, pev_max_health) != 5 && is_user_alive(attacker) && !is_user_bot(attacker) ) {
		new monsterModel[32], monsterName[15], mxp
		pev(monster, pev_model, monsterModel, charsmax(monsterModel))
		if ( equal(monsterModel, "models/agrunt.mdl") ) {
			monsterName = "Alien Grunt"
			mxp = get_pcvar_num(AgrXP)
		}
		else if ( equal(monsterModel, "models/apache.mdl") ) {
			monsterName = "Apache"
			mxp = get_pcvar_num(ApaXP)
		}
		else if ( equal(monsterModel, "models/barney.mdl") ) {
			monsterName = "Barney"
			mxp = get_pcvar_num(BarXP)
		}
		else if ( equal(monsterModel, "models/big_mom.mdl") ) {
			monsterName = "Big Momma"
			mxp = get_pcvar_num(BigXP)
		}
		else if ( equal(monsterModel, "models/bullsquid.mdl") ) {
			monsterName = "Bull Squid"
			mxp = get_pcvar_num(BulXP)
		}
		else if ( equal(monsterModel, "models/controller.mdl") ) {
			monsterName = "Controller"
			mxp = get_pcvar_num(ConXP)
		}
		else if ( equal(monsterModel, "models/garg.mdl") ) {
			monsterName = "Gargantua"
			mxp = get_pcvar_num(GarXP)
		}
		else if ( equal(monsterModel, "models/headcrab.mdl") ) {
			monsterName = "Head Crab"
			mxp = get_pcvar_num(HeaXP)
		}
		else if ( equal(monsterModel, "models/houndeye.mdl") ) {
			monsterName = "Hound Eye"
			mxp = get_pcvar_num(HouXP)
		}
		else if ( equal(monsterModel, "models/hassassin.mdl") ) {
			monsterName = "Human Assassin"
			mxp = get_pcvar_num(HasXP)
		}
		else if ( equal(monsterModel, "models/hgrunt.mdl") ) {
			monsterName = "Human Grunt"
			mxp = get_pcvar_num(HgrXP)
		}
		else if ( equal(monsterModel, "models/scientist.mdl") ) {
			monsterName = "Scientist"
			mxp = get_pcvar_num(SciXP)
		}
		else if ( equal(monsterModel, "models/islave.mdl") ) {
			monsterName = "Slave"
			mxp = get_pcvar_num(IslXP)
		}
		else if ( equal(monsterModel, "models/w_squeak.mdl") ) {
			monsterName = "Snark"
			mxp = get_pcvar_num(SnaXP)
		}
		else if ( equal(monsterModel, "models/zombie.mdl") ) {
			monsterName = "Zombie"
			mxp = get_pcvar_num(ZomXP)
		}
		else {
			return
		}
		if ( mxp <= 0 ) return
		new namea[32]
		get_user_name(attacker, namea, charsmax(namea))
//		sh_set_user_xp(attacker, xp, true)
		xp[attacker]+=mxp
		// sh_chat_message(attacker, -1, "You got %d XP for killing a %s", xp, monsterName)
		client_print(0, print_chat,  "%s killed a %s (%d XP)", namea, monsterName, mxp)
	}
}
#endif
// Functions for reducing amount of code that is needed for all the loops
HPRegen(id)
{
	if (rhealthwait[id]>=380)
	{
#if defined HEALTH_CTRL
		if(get_user_health(id)<maxhealth[id])
#else
		if(get_user_health(id)<health[id]+100+(medals[id]-1)+speed[id])
#endif
		{
#if defined LUCK_CTRL
			if(isLucky[id])
				set_user_health(id,get_user_health(id)+2)
			else
				set_user_health(id,get_user_health(id)+1)
#else
				set_user_health(id,get_user_health(id)+1)
#endif
			rhealthwait[id]=get_hprate(id)
		}
	}
	else
		rhealthwait[id]+=get_hprate(id)
}
APRegen(id)
{
	if(rarmorwait[id]>=380)
	{
#if defined ARMOR_CTRL
		if(get_user_armor(id)<maxarmor[id])
#else
		if(get_user_armor(id)<100+armor[id]+(medals[id]-1)+speed[id])
#endif
		{
#if defined LUCK_CTRL
			if(isLucky[id])
#if defined USING_CS
				cs_set_user_armor(id,get_user_armor(id)+2, CS_ARMOR_VESTHELM)
			else
				cs_set_user_armor(id,get_user_armor(id)+1, CS_ARMOR_VESTHELM)
#else
				set_user_armor(id,get_user_armor(id)+2)
			else
				set_user_armor(id,get_user_armor(id)+1)
#endif
#else
#if defined USING_CS
			cs_set_user_armor(id,get_user_armor(id)+1, CS_ARMOR_VESTHELM)
#else
			set_user_armor(id,get_user_armor(id)+1)
#endif
#endif
			rarmorwait[id]=get_aprate(id)
		}
	}
	else
		rarmorwait[id]+=get_aprate(id)
}
AmmoHP(id)
{
	if (ammowait[id]>=1000)
	{
#if defined USING_CS
		cs_hp_weapon(id)
#endif
#if defined USING_SVEN
		sc_hp_weapon(id)
#endif
		ammowait[id]=rammo[id]
	}
	else
		ammowait[id]+=get_ammorate(id)
}
AmmoAP(id)
{
	if (ammowait[id]>=1000)
	{
#if defined USING_CS					
		cs_ap_weapon(id)
#endif
#if defined USING_SVEN
		sc_ap_weapon(id)
#endif
		ammowait[id]=rammo[id]
	}
	else
		ammowait[id]+=get_ammorate(id)
}
AmmoHPAP(id)
{
	if (ammowait[id]>=1000)
	{
#if defined USING_CS					
		cs_hpap_weapon(id)
#endif
#if defined USING_SVEN
		sc_hpap_weapon(id)
#endif
		ammowait[id]=rammo[id]
	}
	else
		ammowait[id]+=get_ammorate(id)
}
AmmoOnly(id)
{
	if (ammowait[id]>=1000)
	{
#if defined USING_CS					
		cs_only_weapon(id)
#endif
#if defined USING_SVEN
		sc_only_weapon(id)
#endif
		ammowait[id]=rammo[id]
	}
	else
		ammowait[id]+=get_ammorate(id)
}
AmmoTPHPAP(id)
{
	get_players(iPlayers,iNum)
#if defined TEST_TP
	if(iNum>=1)
#else
	if(iNum>1)
#endif
	{
#if defined USING_CS
		cs_tp_hpapammo(id)
#endif
#if defined USING_SVEN
		sc_tp_hpapammo(id)
#endif
	}
}
AmmoTPAP(id)
{
	get_players(iPlayers,iNum)
#if defined TEST_TP
	if(iNum>=1)
#else
	if(iNum>1)
#endif
	{
#if defined USING_CS
		cs_tp_apammo(id)
#endif
#if defined USING_SVEN
		sc_tp_apammo(id)
#endif
	}
}
AmmoTPHP(id)
{
	get_players(iPlayers,iNum)
#if !defined USING_CS
#if defined TEST_TP
	if(iNum>=1)
#else
	if(iNum>1)
#endif
	{
#if defined USING_CS
		cs_tp_hpammo(id)
#endif
#if defined USING_SVEN
		sc_tp_hpammo(id)
#endif
	}
}
AmmoTP(id)
{
	get_players(iPlayers,iNum)
#if defined TEST_TP
	if(iNum>=1)
#else
	if(iNum>1)
#endif
	{
#if defined USING_CS
		cs_tp_ammo(id)
#endif
#if defined USING_SVEN
		sc_tp_ammo(id)
#endif
	}
}
TeamPower(id)
{
	get_players(iPlayers,iNum)
#if defined TEST_TP
	if(iNum>=1)
#else
	if(iNum>1)
#endif
	{
#if defined USING_CS
		cs_tp_only(id)
#endif
#if defined USING_SVEN
		sc_tp_only(id)
#endif
	}
}
TeamHP(id)
{
	get_players(iPlayers,iNum)
#if defined TEST_TP
	if(iNum>=1)
#else
	if(iNum>1)
#endif
	{
#if defined USING_CS
		cs_tp_hp(id)
#endif
#if defined USING_SVEN
		sc_tp_hp(id)
#endif
	}
}
TeamAP(id)
{
	get_players(iPlayers,iNum)
#if defined TEST_TP
	if(iNum>=1)
#else
	if(iNum>1)
#endif
	{
#if defined USING_CS
		cs_tp_ap(id)
#endif
#if defined USING_SVEN
		sc_tp_ap(id)
#endif
	}
#endif
}
TeamHPAP(id)
{
	get_players(iPlayers,iNum)
#if defined TEST_TP
	if(iNum>=1)
#else
	if(iNum>1)
#endif
	{
#if defined USING_CS
		cs_tp_hpap(id)
#endif
#if defined USING_SVEN
		sc_tp_hpap(id)
#endif
	}
}
BlockAttack(id)
{
#if defined HEALTH_CTRL
	if(is_user_connected(id) && is_user_alive(id) && !get_user_godmode(id) && get_user_health(id) < maxhealth[id])
#else
	if(is_user_connected(id) && is_user_alive(id) && !get_user_godmode(id))
#endif
	{
		new lucky=random_num(0,250+dodge[id]+(medals[id]-1)+speed[id])
#if !defined HEALTH_CTRL
		new health_values = 100+speed[id]+(medals[id]-1)
#endif
#if defined HEALTH_CTRL
		if (lucky >= 200)
#else
		if (get_user_health(id) < health_values && lucky >= 200)
#endif
		{
			set_task(0.1, "godmode_on", id)
		}
	}
}
public godmode_on(id)
{
	if (is_user_connected(id) && is_user_alive(id))
	{
		set_user_godmode(id,1)
		set_task(0.5, "godmode_off", id)
	}
}
public godmode_off(id)
{
	if (is_user_connected(id) && is_user_alive(id))
		set_user_godmode(id)
}
#if defined USING_CS
cs_tp_hpapammo(id)
{
	for(new h=0;h<iNum+1;h++)
	{
		new i=iPlayers[h]
#if defined TEST_TP
		if(id==i)
#else
		if(id!=i)
#endif
		{
#if defined EVENT_DMG
			if(is_user_alive(i) && !PlayerIsHurt[i])
#else
			if(is_user_alive(i))
#endif
			{
				new teama[32]
				new teamb[32]
				get_user_team(id,teama,31)
				get_user_team(i,teamb,31)
				if(equali(teama,teamb))
				{
					distanceRange = 600+speed[id]+dist[id]+medals[id]
					new Float:origin_i[3]
					pev(i,pev_origin,origin_i)
					new Float:origin_id[3]
					pev(id,pev_origin,origin_id)
					if(get_distance_f(origin_i,origin_id)<=distanceRange)
					{
#if defined HEALTH_CTRL
						if(get_user_health(i)<maxhealth[id])
							set_user_health(i,get_user_health(i)+1)
#endif
#if defined ARMOR_TP
#if defined ARMOR_CTRL
						if(get_user_armor(i)<maxarmor[id])
							cs_set_user_armor( i, get_user_armor(i)+1, CS_ARMOR_VESTHELM );
#endif
#endif
#if defined AMMO_TP
						if (rammo[i]>0)
							ammowait[i]+=medals[i]+medals[id]
#endif
#if defined LUCK_CTRL
						if(isLucky[i])
						{
							if(get_user_health(i) < maxhealth[i])
								set_user_health(i, get_user_health(i) + 1)
							if(get_user_armor(i) < maxarmor[i])
								cs_set_user_armor( i, get_user_armor(i)+1, CS_ARMOR_VESTHELM );
						}
#endif
					}
				}
			}
		}
	}
}
cs_tp_apammo(id)
{
	for(new h=0;h<iNum+1;h++)
	{
		new i=iPlayers[h]
#if defined TEST_TP
		if(id==i)
#else
		if(id!=i)
#endif
		{
#if defined EVENT_DMG
			if(is_user_alive(i) && !PlayerIsHurt[i])
#else
			if(is_user_alive(i))
#endif
			{
				new teama[32]
				new teamb[32]
				get_user_team(id,teama,31)
				get_user_team(i,teamb,31)
				if(equali(teama,teamb))
				{
					distanceRange = 600+speed[id]+dist[id]+medals[id]
					new Float:origin_i[3]
					pev(i,pev_origin,origin_i)
					new Float:origin_id[3]
					pev(id,pev_origin,origin_id)
					if(get_distance_f(origin_i,origin_id)<=distanceRange)
					{
#if defined ARMOR_TP
#if defined ARMOR_CTRL
						if(get_user_armor(i)<maxarmor[id])
							cs_set_user_armor( i, get_user_armor(i)+1, CS_ARMOR_VESTHELM );
#endif
#endif
#if defined AMMO_TP
						if (rammo[i]>0)
							ammowait[i]+=medals[i]+medals[id]
#endif
#if defined LUCK_CTRL
						if(isLucky[i])
						{
							if(get_user_armor(i) < maxarmor[i])
								cs_set_user_armor( i, get_user_armor(i)+1, CS_ARMOR_VESTHELM );
						}
#endif
					}
				}
			}
		}
	}
}
cs_tp_hpammo(id)
{
	for(new h=0;h<iNum+1;h++)
	{
		new i=iPlayers[h]
#if defined TEST_TP
		if(id==i)
#else
		if(id!=i)
#endif
		{
#if defined EVENT_DMG
			if(is_user_alive(i) && !PlayerIsHurt[i])
#else
			if(is_user_alive(i))
#endif
			{
				new teama[32]
				new teamb[32]
				get_user_team(id,teama,31)
				get_user_team(i,teamb,31)
				if(equali(teama,teamb))
				{
					distanceRange = 600+speed[id]+dist[id]+medals[id]
					new Float:origin_i[3]
					pev(i,pev_origin,origin_i)
					new Float:origin_id[3]
					pev(id,pev_origin,origin_id)
					if(get_distance_f(origin_i,origin_id)<=distanceRange)
					{
#if defined HEALTH_CTRL
						if(get_user_health(i)<maxhealth[id])
							set_user_health(i,get_user_health(i)+1)
#endif
#if defined AMMO_TP
						if (rammo[i]>0)
							ammowait[i]+=medals[i]+medals[id]
#endif
#if defined LUCK_CTRL
						if(isLucky[i])
						{
							if(get_user_health(i) < maxhealth[i])
								set_user_health(i, get_user_health(i) + 1)
						}
#endif
					}
				}
			}
		}
	}
}
cs_tp_ammo(id)
{
	for(new h=0;h<iNum+1;h++)
	{
		new i=iPlayers[h]
#if defined TEST_TP
		if(id==i)
#else
		if(id!=i)
#endif
		{
#if defined EVENT_DMG
			if(is_user_alive(i) && !PlayerIsHurt[i])
#else
			if(is_user_alive(i))
#endif
			{
				new teama[32]
				new teamb[32]
				get_user_team(id,teama,31)
				get_user_team(i,teamb,31)
				if(equali(teama,teamb))
				{
					distanceRange = 600+speed[id]+dist[id]+medals[id]
					new Float:origin_i[3]
					pev(i,pev_origin,origin_i)
					new Float:origin_id[3]
					pev(id,pev_origin,origin_id)
					if(get_distance_f(origin_i,origin_id)<=distanceRange)
					{
#if defined HEALTH_CTRL
						if(get_user_health(i)<maxhealth[id])
							set_user_health(i,get_user_health(i)+1)
#else
						new health_values = get_user_health(id);
						if(get_user_health(i)<health_values)
							set_user_health(i,get_user_health(i)+1)
#endif
#if defined ARMOR_TP
#if defined ARMOR_CTRL
						if(get_user_armor(i)<maxarmor[id])
							cs_set_user_armor( i, get_user_armor(i)+1, CS_ARMOR_VESTHELM );
#else
						new armor_values = get_user_armor(id);
						if(get_user_armor(i)<armor_values)
							cs_set_user_armor( i, get_user_armor(i)+1, CS_ARMOR_VESTHELM );
#endif
#endif
#if defined AMMO_TP
						if (rammo[i]>0)
							ammowait[i]+=medals[i]+medals[id]
#endif
					}
				}
			}
		}
	}
}
cs_tp_only(id)
{
	for(new h=0;h<iNum+1;h++)
	{
		new i=iPlayers[h]
#if defined TEST_TP
		if(id==i)
#else
		if(id!=i)
#endif
		{
#if defined EVENT_DMG
			if(is_user_alive(i) && !PlayerIsHurt[i])
#else
			if(is_user_alive(i))
#endif
			{
				new teama[32]
				new teamb[32]
				get_user_team(id,teama,31)
				get_user_team(i,teamb,31)
				if(equali(teama,teamb))
				{
					distanceRange = 600+speed[id]+dist[id]+medals[id]
					new Float:origin_i[3]
					pev(i,pev_origin,origin_i)
					new Float:origin_id[3]
					pev(id,pev_origin,origin_id)
					if(get_distance_f(origin_i,origin_id)<=distanceRange)
					{
#if defined HEALTH_CTRL
						if(get_user_health(i)<maxhealth[id])
							set_user_health(i,get_user_health(i)+1)
#else
						new health_values = get_user_health(id);
						if(get_user_health(i)<health_values)
							set_user_health(i,get_user_health(i)+1)
#endif
#if defined ARMOR_TP
#if defined ARMOR_CTRL
						if(get_user_armor(i)<maxarmor[id])
							cs_set_user_armor( i, get_user_armor(i)+1, CS_ARMOR_VESTHELM );
#else
						new armor_values = get_user_armor(id);
						if(get_user_armor(i)<armor_values)
							cs_set_user_armor( i, get_user_armor(i)+1, CS_ARMOR_VESTHELM );
#endif
#endif
					}
				}	
			}
		}
	}
}
cs_tp_hp(id)
{
	for(new h=0;h<iNum+1;h++)
	{
		new i=iPlayers[h]
#if defined TEST_TP
		if(id==i)
#else
		if(id!=i)
#endif
		{
#if defined EVENT_DMG
			if(is_user_alive(i) && !PlayerIsHurt[i])
#else
			if(is_user_alive(i))
#endif
			{
				new teama[32]
				new teamb[32]
				get_user_team(id,teama,31)
				get_user_team(i,teamb,31)
				if(equali(teama,teamb))
				{
					distanceRange = 600+speed[id]+dist[id]+medals[id]
					new Float:origin_i[3]
					pev(i,pev_origin,origin_i)
					new Float:origin_id[3]
					pev(id,pev_origin,origin_id)
					if(get_distance_f(origin_i,origin_id)<=distanceRange)
					{
#if defined HEALTH_CTRL
						if(get_user_health(i)<maxhealth[id])
							set_user_health(i,get_user_health(i)+1)
#endif
#if defined LUCK_CTRL
						if(isLucky[i])
						{
							if(get_user_health(i) < maxhealth[i])
								set_user_health(i, get_user_health(i) + 1)
						}
#endif
					}
				}	
			}
		}
	}
}
cs_tp_ap(id)
{
	for(new h=0;h<iNum+1;h++)
	{
		new i=iPlayers[h]
#if defined TEST_TP
		if(id==i)
#else
		if(id!=i)
#endif
		{
#if defined EVENT_DMG
			if(is_user_alive(i) && !PlayerIsHurt[i])
#else
			if(is_user_alive(i))
#endif
			{
				new teama[32]
				new teamb[32]
				get_user_team(id,teama,31)
				get_user_team(i,teamb,31)
				if(equali(teama,teamb))
				{
					distanceRange = 600+speed[id]+dist[id]+medals[id]
					new Float:origin_i[3]
					pev(i,pev_origin,origin_i)
					new Float:origin_id[3]
					pev(id,pev_origin,origin_id)
					if(get_distance_f(origin_i,origin_id)<=distanceRange)
					{
#if defined ARMOR_TP
#if defined ARMOR_CTRL
						if(get_user_armor(i)<maxarmor[id])
							cs_set_user_armor( i, get_user_armor(i)+1, CS_ARMOR_VESTHELM );
#endif
#endif
#if defined LUCK_CTRL
						if(isLucky[i])
						{
							if(get_user_armor(i) < maxarmor[i])
								cs_set_user_armor( i, get_user_armor(i)+1, CS_ARMOR_VESTHELM );
						}
#endif
					}
				}
			}
		}
	}
}
cs_tp_hpap(id)
{
	for(new h=0;h<iNum+1;h++)
	{
		new i=iPlayers[h]
#if defined TEST_TP
		if(id==i)
#else
		if(id!=i)
#endif
		{
#if defined EVENT_DMG
			if(is_user_alive(i) && !PlayerIsHurt[i])
#else
			if(is_user_alive(i))
#endif
			{
				new teama[32]
				new teamb[32]
				get_user_team(id,teama,31)
				get_user_team(i,teamb,31)
				if(equali(teama,teamb))
				{
					distanceRange = 600+speed[id]+dist[id]+medals[id];
					new Float:origin_i[3];
					pev(i,pev_origin,origin_i);
					new Float:origin_id[3];
					pev(id,pev_origin,origin_id);
					if(get_distance_f(origin_i,origin_id)<=distanceRange)
					{
#if defined HEALTH_CTRL
						if(get_user_health(i)<maxhealth[id])
							set_user_health(i,get_user_health(i)+1)
#endif
#if defined ARMOR_TP
#if defined ARMOR_CTRL
						if(get_user_armor(i)<maxarmor[id])
							cs_set_user_armor( i, get_user_armor(i)+1, CS_ARMOR_VESTHELM );
#endif
#endif
#if defined LUCK_CTRL
						if(isLucky[i])
						{
							if(get_user_health(i) < maxhealth[i])
								set_user_health(i, get_user_health(i) + 1)
							if(get_user_armor(i) < maxarmor[i])
								cs_set_user_armor( i, get_user_armor(i)+1, CS_ARMOR_VESTHELM );
						}
#endif
					}
				}
			}
		}
	}	
}
#endif
#if defined USING_SVEN
sc_tp_hpapammo(id)
{
	for(new h=0;h<iNum+1;h++)
	{
		new i=iPlayers[h]
#if defined TEST_TP
		if(id==i)
#else
		if(id!=i)
#endif
		{
#if defined EVENT_DMG
			if(is_user_alive(i) && !PlayerIsHurt[i])
#else
			if(is_user_alive(i))
#endif
			{
				distanceRange = 600+speed[id]+dist[id]+medals[id]
				new Float:origin_i[3]
				pev(i,pev_origin,origin_i)
				new Float:origin_id[3]
				pev(id,pev_origin,origin_id)
				if(get_distance_f(origin_i,origin_id)<=distanceRange)
				{
#if defined HEALTH_CTRL
					if(get_user_health(i)<maxhealth[id])
						set_user_health(i,get_user_health(i)+1)
#endif
#if defined ARMOR_TP
#if defined ARMOR_CTRL
					if(get_user_armor(i)<maxarmor[id])
						set_user_armor( i, get_user_armor(i)+1);
#endif
#endif
#if defined AMMO_TP
					if (rammo[i]>0)
						ammowait[i]+=medals[i]+medals[id]
#endif
#if defined LUCK_CTRL
					if(isLucky[i])
					{
						if(get_user_health(i) < maxhealth[i])
							set_user_health(i, get_user_health(i) + 1)
						if(get_user_armor(i) < maxarmor[i])
							set_user_armor(i, get_user_armor(i) + 1)
					}
#endif
				}
			}
		}
	}
}
sc_tp_apammo(id)
{
	for(new h=0;h<iNum+1;h++)
	{
		new i=iPlayers[h]
#if defined TEST_TP
		if(id==i)
#else
		if(id!=i)
#endif
		{
#if defined EVENT_DMG
			if(is_user_alive(i) && !PlayerIsHurt[i])
#else
			if(is_user_alive(i))
#endif
			{
				distanceRange = 600+speed[id]+dist[id]+medals[id]
				new Float:origin_i[3]
				pev(i,pev_origin,origin_i)
				new Float:origin_id[3]
				pev(id,pev_origin,origin_id)
				if(get_distance_f(origin_i,origin_id)<=distanceRange)
				{
#if defined ARMOR_TP
#if defined ARMOR_CTRL
					if(get_user_armor(i)<maxarmor[id])
						set_user_armor( i, get_user_armor(i)+1);
#endif
#endif
#if defined AMMO_TP
					if (rammo[i]>0)
						ammowait[i]+=medals[i]+medals[id]
#endif
#if defined LUCK_CTRL
					if(isLucky[i])
					{
						if(get_user_armor(i) < maxarmor[i])
							set_user_armor(i, get_user_armor(i) + 1)
					}
#endif
				}
			}
		}
	}
}
sc_tp_hpammo(id)
{
	for(new h=0;h<iNum+1;h++)
	{
		new i=iPlayers[h]
#if defined TEST_TP
		if(id==i)
#else
		if(id!=i)
#endif
		{
#if defined EVENT_DMG
			if(is_user_alive(i) && !PlayerIsHurt[i])
#else
			if(is_user_alive(i))
#endif
			{
				distanceRange = 600+speed[id]+dist[id]+medals[id]
				new Float:origin_i[3]
				pev(i,pev_origin,origin_i)
				new Float:origin_id[3]
				pev(id,pev_origin,origin_id)
				if(get_distance_f(origin_i,origin_id)<=distanceRange)
				{
#if defined HEALTH_CTRL
					if(get_user_health(i)<maxhealth[id])
						set_user_health(i, get_user_health(i) + 1)
#endif
#if defined AMMO_TP
					if (rammo[i]>0)
						ammowait[i]+=medals[i]+medals[id]
#endif
#if defined LUCK_CTRL
					if(isLucky[i])
					{
						if(get_user_health(i) < maxhealth[i])
							set_user_health(i, get_user_health(i) + 1)
					}
#endif
				}
			}
		}
	}
}
sc_tp_ammo(id)
{
	for(new h=0;h<iNum+1;h++)
	{
		new i=iPlayers[h]
#if defined TEST_TP
		if(id==i)
#else
		if(id!=i)
#endif
		{
#if defined EVENT_DMG
			if(is_user_alive(i) && !PlayerIsHurt[i])
#else
			if(is_user_alive(i))
#endif
			{
				distanceRange = 600+speed[id]+dist[id]+medals[id]
				new Float:origin_i[3]
				pev(i,pev_origin,origin_i)
				new Float:origin_id[3]
				pev(id,pev_origin,origin_id)
				if(get_distance_f(origin_i,origin_id)<=distanceRange)
				{
#if defined HEALTH_CTRL
					if(get_user_health(i)<maxhealth[id])
						set_user_health(i,get_user_health(i)+1)
#else
					new health_values = get_user_health(id);
					if(get_user_health(i)<health_values)
						set_user_health(i,get_user_health(i)+1)
#endif
#if defined ARMOR_TP
#if defined ARMOR_CTRL
					if(get_user_armor(i)<maxarmor[id])
						set_user_armor( i, get_user_armor(i)+1);
#else
					new armor_values = get_user_armor(id);
					if(get_user_armor(i)<armor_values)
						set_user_armor( i, get_user_armor(i)+1);
#endif
#endif
#if defined AMMO_TP
					if (rammo[i]>0)
						ammowait[i]+=medals[i]+medals[id]
#endif
				}
			}
		}
	}
}
sc_tp_only(id)
{
	for(new h=0;h<iNum+1;h++)
	{
		new i=iPlayers[h]
#if defined TEST_TP
		if(id==i)
#else
		if(id!=i)
#endif
		{
#if defined EVENT_DMG
			if(is_user_alive(i) && !PlayerIsHurt[i])
#else
			if(is_user_alive(i))
#endif
			{
				distanceRange = 600+speed[id]+dist[id]+medals[id]
				new Float:origin_i[3]
				pev(i,pev_origin,origin_i)
				new Float:origin_id[3]
				pev(id,pev_origin,origin_id)
				if(get_distance_f(origin_i,origin_id)<=distanceRange)
				{
#if defined HEALTH_CTRL
					if(get_user_health(i)<maxhealth[id])
						set_user_health(i,get_user_health(i)+1)
#else
					new health_values = get_user_health(id);
					if(get_user_health(i)<health_values)
						set_user_health(i,get_user_health(i)+1)
#endif
#if defined ARMOR_TP
#if defined ARMOR_CTRL
					if(get_user_armor(i)<maxarmor[id])
						set_user_armor( i, get_user_armor(i)+1);
#else
					new armor_values = get_user_armor(id);
					if(get_user_armor(i)<armor_values)
						set_user_armor( i, get_user_armor(i)+1);
#endif
#endif
				}
			}
		}
	}
}
sc_tp_hp(id)
{
	for(new h=0;h<iNum+1;h++)
	{
		new i=iPlayers[h]
#if defined TEST_TP
		if(id==i)
#else
		if(id!=i)
#endif
		{
#if defined EVENT_DMG
			if(is_user_alive(i) && !PlayerIsHurt[i])
#else
			if(is_user_alive(i))
#endif
			{
				distanceRange = 600+speed[id]+dist[id]+medals[id]
				new Float:origin_i[3]
				pev(i,pev_origin,origin_i)
				new Float:origin_id[3]
				pev(id,pev_origin,origin_id)
				if(get_distance_f(origin_i,origin_id)<=distanceRange)
				{
#if defined HEALTH_CTRL
					if(get_user_health(i)<maxhealth[id])
						set_user_health(i,get_user_health(i)+1)
#endif
#if defined LUCK_CTRL
					if(isLucky[i])
					{
						if(get_user_health(i) < maxhealth[i])
							set_user_health(i, get_user_health(i) + 1)
					}
#endif
				}
			}
		}
	}	
}
sc_tp_ap(id)
{
	for(new h=0;h<iNum+1;h++)
	{
		new i=iPlayers[h]
#if defined TEST_TP
		if(id==i)
#else
		if(id!=i)
#endif
		{
#if defined EVENT_DMG
			if(is_user_alive(i) && !PlayerIsHurt[i])
#else
			if(is_user_alive(i))
#endif
			{
				distanceRange = 600+speed[id]+dist[id]+medals[id]
				new Float:origin_i[3]
				pev(i,pev_origin,origin_i)
				new Float:origin_id[3]
				pev(id,pev_origin,origin_id)
				if(get_distance_f(origin_i,origin_id)<=distanceRange)
				{
#if defined ARMOR_TP
#if defined ARMOR_CTRL
					if(get_user_armor(i)<maxarmor[id])
						set_user_armor(i, get_user_armor(i) + 1)
#endif
#endif
#if defined LUCK_CTRL
					if(isLucky[i])
					{
						if(get_user_armor(i) < maxarmor[i])
							set_user_armor(i, get_user_armor(i) + 1)
					}
#endif
				}
			}
		}
	}
}
sc_tp_hpap(id)
{
		for(new h=0;h<iNum+1;h++)
		{
			new i=iPlayers[h]
#if defined TEST_TP
			if(id==i)
#else
			if(id!=i)
#endif
			{
#if defined EVENT_DMG
				if(is_user_alive(i) && !PlayerIsHurt[i])
#else
				if(is_user_alive(i))
#endif
				{
					distanceRange = 600+speed[id]+dist[id]+medals[id]
					new Float:origin_i[3]
					pev(i,pev_origin,origin_i)
					new Float:origin_id[3]
					pev(id,pev_origin,origin_id)
					if(get_distance_f(origin_i,origin_id)<=distanceRange)
					{
#if defined HEALTH_CTRL
						if(get_user_health(i)<maxhealth[id])
							set_user_health(i,get_user_health(i)+1)
#endif
#if defined ARMOR_TP
#if defined ARMOR_CTRL
						if(get_user_armor(i)<maxarmor[id])
							set_user_armor( i, get_user_armor(i)+1);
#endif
#endif
#if defined LUCK_CTRL
						if(isLucky[i])
						{
							if(get_user_health(i) < maxhealth[i])
								set_user_health(i, get_user_health(i) + 1)
							if(get_user_armor(i) < maxarmor[i])
								set_user_armor( i, get_user_armor(i)+1);
						}
#endif
					}
				}
			}
		}
}
#endif
// "xp.inl" for xp handling organization
// calculate needed xp for next level
public scxpm_calcneedxp ( id ) {
	new Float:m70 = float( playerlevel[id] ) * 70.0;
	new Float:mselfm3dot2 = float( playerlevel[id] ) * float( playerlevel[id] ) * 3.5;
	neededxp[id] = floatround( m70 + mselfm3dot2 + 30.0 );
}
// calculate level from xp
public scxpm_calc_lvl ( xp ) {
	return floatround( -10 + floatsqroot( 100 - ( 60 / 7 - ( ( xp - 1 ) / 3.5 ) ) ), floatround_ceil );
}
public scxpm_calc_xp ( level) {
	level--;
	return floatround( (float( level ) * 70.0) + (float( level ) * float(level) * 3.5) + 30);
}
// ^ add bonus xp here?
// regen task loop start
public scxpm_sdac(id) 
{
#if defined NEW_LOOP
	if (is_user_connected(id))
		scxpm_loop_switch(id);
#endif // NEW_LOOP
}