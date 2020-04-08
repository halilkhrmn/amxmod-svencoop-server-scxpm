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
