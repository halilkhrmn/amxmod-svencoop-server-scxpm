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