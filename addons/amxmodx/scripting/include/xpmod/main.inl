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