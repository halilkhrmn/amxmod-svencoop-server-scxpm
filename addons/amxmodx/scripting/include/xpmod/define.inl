// Definition Inline file configuration by Swamp Dog - May 2016
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