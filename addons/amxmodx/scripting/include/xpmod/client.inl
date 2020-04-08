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