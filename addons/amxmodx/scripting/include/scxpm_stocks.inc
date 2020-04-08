// stock configuration by Swamp Dog @ ModRiot.com, August 2016
stock get_max_hp(id)
{
	maxhealth[id] = 100+health[id]+speed[id]+(medals[id]-1)
	//new plyr_max_hp = maxhealth[id]
	max_health = get_pcvar_num(pcvar_maxhealth)
	if(max_health != 0)
	{
		if(maxhealth[id] > max_health)
		{
			maxhealth[id] = max_health
			//plyr_max_hp = maxhealth[id]
		}
	}
	//return plyr_max_hp
}
stock get_max_ap(id)
{
	maxarmor[id] = 100+armor[id]+speed[id]+(medals[id]-1)
	//new plyr_max_ap = armor[id]
	max_armor = get_pcvar_num(pcvar_maxarmor)
	if(max_armor != 0)
	{
		if(maxarmor[id] > max_armor)
		{
			maxarmor[id] = max_armor
			//plyr_max_ap = maxarmor[id]
		}
	}
	//return plyr_max_ap
}
stock max_hp_check(id)
{
	new healthcap = get_pcvar_num(pcvar_maxhealth)
	if(healthcap != 0)
	{
		if(get_user_health(id)>healthcap)
			set_user_health(id,healthcap)
	}
	else if(get_user_health(id) > 645)
		set_user_health(id, 645)
	//return healthcap
}
stock max_ap_check(id)
{
	new armorcap = get_pcvar_num(pcvar_maxarmor)
	if(armorcap != 0)
	{
		if(get_user_armor(id)>armorcap)
#if defined USING_CS
		cs_set_user_armor(id, armorcap, CS_ARMOR_VESTHELM)
#else
		set_user_armor( id, armorcap)
#endif			
	}
	else if(get_user_armor(id) > 645)
#if defined USING_CS
		cs_set_user_armor(id, 645, CS_ARMOR_VESTHELM)
#else
		set_user_armor( id, 645)
#endif
	//return armorcap
}
stock set_player_loop(id)
{
	switch(loopcheck)
	{
		case 1:
			set_task(1.0, "scxpm_regen", id, "", 0, "b")
		case 2:
			set_task(1.0, "scxpm_regen2", id, "", 0, "b")
		case 3:
			set_task(1.0, "scxpm_regen3", id, "", 0, "b")
		case 4:
			set_task(1.0, "scxpm_regen4", id, "", 0, "b")
		case 5:
			set_task(1.0, "scxpm_regen5", id, "", 0, "b")
		case 6:
			set_task(1.0, "scxpm_regen6", id, "", 0, "b")
		case 7:
			set_task(1.0, "scxpm_regen7", id, "", 0, "b")
		case 8:
			set_task(1.0, "scxpm_regen8", id, "", 0, "b")
		case 9:
			set_task(1.0, "scxpm_regen9", id, "", 0, "b")
		case 10:
			set_task(1.0, "scxpm_regen10", id, "", 0, "b")
		case 11:
			set_task(1.0, "scxpm_regen11", id, "", 0, "b")
		case 12:
			set_task(1.0, "scxpm_regen12", id, "", 0, "b")
		case 13:
			set_task(1.0, "scxpm_regen13", id, "", 0, "b")
		case 14:
			set_task(1.0, "scxpm_regen14", id, "", 0, "b")
		case 15:
			set_task(1.0, "scxpm_regen15", id, "", 0, "b")
		case 16:
			set_task(1.0, "scxpm_regen16", id, "", 0, "b")
		case 17:
			set_task(1.0, "scxpm_regen17", id, "", 0, "b")
		case 18:
			set_task(1.0, "scxpm_regen18", id, "", 0, "b")
		case 19:
			set_task(1.0, "scxpm_regen19", id, "", 0, "b")
		case 20:
			set_task(1.0, "scxpm_regen20", id, "", 0, "b")
		case 21:
			set_task(1.0, "scxpm_regen21", id, "", 0, "b")
		case 22:
			set_task(1.0, "scxpm_regen22", id, "", 0, "b")
		case 23:
			set_task(1.0, "scxpm_regen23", id, "", 0, "b")
		case 24:
			set_task(1.0, "scxpm_regen24", id, "", 0, "b")
		case 25:
			set_task(1.0, "scxpm_regen25", id, "", 0, "b")
		case 26:
			set_task(1.0, "scxpm_regen26", id, "", 0, "b")
		case 27:
			set_task(1.0, "scxpm_regen27", id, "", 0, "b")
		case 28:
			set_task(1.0, "scxpm_regen28", id, "", 0, "b")
		case 29:
			set_task(1.0, "scxpm_regen29", id, "", 0, "b")
		case 30:
			set_task(1.0, "scxpm_regen30", id, "", 0, "b")
		case 31:
			set_task(1.0, "scxpm_regen31", id, "", 0, "b")
		/*
		case 0:
		{
			if(get_pcvar_num(pcvar_debug) > 0)
				log_amx("[SCXPM DEBUG] There is an incorrect combination of cvars, loading default loop with all skills");
			set_task(1.0, "scxpm_regen", id, "", 0, "b")
		}
		*/
	}
	//return 0
}
#if defined ENTITY_CHECK
stock check_for_entities()
{
// only available in versions of AMXX > 1.8.2 stable
#if AMXX_VERSION_NUM >= 183
#if defined USING_SVEN
	// game player equip means that health and armor regen won't work properly - counts up and down constantly (desertcircle as an example)
	if(has_map_ent_class("game_player_equip" == true)
	{
		if(get_pcvar_num(pcvar_debug) > 0)
			log_amx("%s game_player_equip entity found, setting skills accordingly",DEBUG)
		set_pcvar_num(pcvar_hpregen, 0)
		set_pcvar_num(pcvar_nano, 0)
	}
	if(has_map_ent_class("trigger_gravity" == true)
	{
		if(get_pcvar_num(pcvar_debug) > 0)
			log_amx("%s trigger_gravity entity found, setting skills accordingly",DEBUG)
		set_pcvar_num(pcvar_hpregen, 0)
		set_pcvar_num(pcvar_nano, 0)
	}
#endif
#else
#if defined USING_SVEN
	// allow entity check to be done by cvar?
	new ent = 0;
	new ent2 = 0;
	//while ((entity = find_ent_by_class(entity, "armoury_entity")))
	if((ent = find_ent_by_class(ent, "game_player_equip")))
	{
		set_pcvar_num(pcvar_hpregen, 0)
		set_pcvar_num(pcvar_nano, 0)
		set_pcvar_num(pcvar_ammo, 0)
// with new "team power" code, it may not be necessary to turn this off if other skills are unloaded
//		set_pcvar_num(pcvar_teampower, 0)
// we may want to set the cap for health and armor here, but possibly not needed for all maps (like desertcircle)
		set_pcvar_num(pcvar_health, 0)
		set_pcvar_num(pcvar_armor, 0)
#if defined HEALTH_CTRL
		set_pcvar_num(pcvar_maxhealth, 100)
#endif
#if defined ARMOR_CTRL
		set_pcvar_num(pcvar_maxarmor, 100)
#endif
		if(get_pcvar_num(pcvar_debug) > 0)
			log_amx("%s game_player_equip entity found, automatically disabling skills",DEBUG)
	}
	if((ent2 = find_ent_by_class(ent2, "trigger_gravity")))
	{
		set_pcvar_num(pcvar_gravity, 0)
		if(get_pcvar_num(pcvar_debug) > 0)
			log_amx("%s trigger_gravity entity found, automatically disabling %s device",DEBUG,Grav)
	}
#endif
#endif
}
#endif
stock get_hprate(id)
{
	new hprate=rhealth[id]+speed[id]+(medals[id]-1)
	return hprate
}
// retrieves the rate of armor regeneration
stock get_aprate(id)
{
	new aprate=rarmor[id]+speed[id]+(medals[id]-1)
	return aprate
}
// retrieves the rate of ammo regeneration
stock get_ammorate(id)
{
	new ammorate=rammo[id]+speed[id]+(medals[id]-1)
	return ammorate
}