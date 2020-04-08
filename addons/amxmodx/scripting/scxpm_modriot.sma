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
SCXPM Version 17.31.35 edited by Swamp Dog @ ModRiot.com
Cvar Combintion system designed by Swamp Dog (with math help from J-M & Effor)
Further Credits from Sven Coop 5.0 development by players from ModRiot.com will be included in "scxpm_credits.txt"

inline file categorizing by Swamp Dog to attempt to organize code, and make it easier to read

New Loop checking system designed with combinatorics mathematics by Swamp Dog
Comment #define NEW_LOOP in define.inl to remove this feature
This is specifically designed to be able to load a certain loop with the experience mod plugin on map start 
This is used to disable skills in scxpm_regen original loop, which are disabled by using per-map config files "mapname.cfg" in "amxmodx/configs/maps/"
The design idea was to prevent SCXPM from breaking maps in Sven Co-op 5.0, because it does break maps.
Based on cvars combinations - see "main.inl" for more information on combinations 
*/
#include <amxmodx>
#include <amxmisc>
#include <fakemeta>
#include <fun>
#include <sqlx>
#include <bit>
#include <engine>

#pragma dynamic 32768

//for semi-colon syntax
//#pragma semi-colon

#include "xpmod/define.inl" 	// Defines
#include <scxpm_stocks>			// Stocks
#include "xpmod/client.inl" 	// Client code
#include "xpmod/event.inl"		// Game Events system
#include "xpmod/menu.inl" 		// Menu system
#include "xpmod/hud.inl" 		// HUD system
#include "xpmod/skillfuncs.inl"	// Skill functions for new loop system to cut down on all code needed, created new functions instead of copy pasting loop code
#include "xpmod/cmd.inl" 		// Commands
#include "xpmod/main.inl" 		// Main functions - redesigned SCXPM concepts for custom loading with Sven Co-op 5.0
#if defined NEW_LOOP
#include "xpmod/loopcalc.inl"	// Calculates which loop should be loaded for scxpm_regen based on cvars
#endif
#include "xpmod/xp.inl" 		// XP system, related functions
#include "xpmod/db.inl" 		// Database code
#include "xpmod/loops.inl"		// Skill system extension for controlling skills w/ cvars (so Sven Co-op maps wont break from skill-related bugging) - loops-new
#include "xpmod/teampower.inl"	// new file for team power to cut down on amount of code in 1 file, and to organize easier
#include "xpmod/ammo_skill.inl" // Ammo reincarnation switch, to cut down on amount of code in 1 file and to reorganize
/*
Credits for this code to "SuperHero Mod Monster XP v2.1 plugin" by Sam Tsuki
Integrated into SCXPM by Swamp Dog
https://forums.alliedmods.net/showthread.php?t=75535?t=75535
*/
#if defined ALLOW_MONSTERS
#include "xpmod/mxp.inl"
#endif
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