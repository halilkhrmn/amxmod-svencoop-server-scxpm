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