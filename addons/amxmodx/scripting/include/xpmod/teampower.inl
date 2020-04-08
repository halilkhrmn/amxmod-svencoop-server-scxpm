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