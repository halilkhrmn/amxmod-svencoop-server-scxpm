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
