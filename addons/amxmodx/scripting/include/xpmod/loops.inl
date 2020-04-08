// Explicit customization to use only certain skills when loading the loop check - idea and design by swampdog, to cut down processing needed and to stop breaking sven coop maps
// see main.inl for combinations (combinatorics mathemtatics)
// new loop check designed by swampdog - July 12, 2016
public scxpm_regen(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
				if(rarmor[id]>0)
					APRegen(id)
				if(rammo[id]>0)
					AmmoHPAP(id)
				if(dist[id]>0)
					AmmoTPHPAP(id)
#if defined EVENT_DMG				
			}
#endif
			if(dodge[id]>0)
				BlockAttack(id)
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
#if defined NEW_LOOP
// hp, ap, ammo, tp
public scxpm_regen2(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
				if(rarmor[id]>0)
					APRegen(id)
				if(rammo[id]>0)
					AmmoHPAP(id)
				if(dist[id]>0)
					AmmoTPHPAP(id)
#if defined EVENT_DMG				
			}
#endif
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// hp, ap, ammo
public scxpm_regen3(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
				if(rarmor[id]>0)
					APRegen(id)
				if(rammo[id]>0)
					AmmoHPAP(id)
#if defined EVENT_DMG				
			}
#endif
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// hp, ap
public scxpm_regen4(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
				if(rarmor[id]>0)
					APRegen(id)
#if defined EVENT_DMG				
			}
#endif
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// hp
public scxpm_regen5(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
#if defined EVENT_DMG				
			}
#endif
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// ap, ammo, tp, block
public scxpm_regen6(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rarmor[id]>0)
					APRegen(id)
				if(rammo[id]>0)
					AmmoAP(id)
				if(dist[id]>0)
					AmmoTPAP(id)
#if defined EVENT_DMG				
			}
#endif
			if(dodge[id]>0)
				BlockAttack(id)
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// ap, ammo, tp
public scxpm_regen7(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rarmor[id]>0)
					APRegen(id)
				if(rammo[id]>0)
					AmmoAP(id)
				if(dist[id]>0)
					AmmoTPAP(id)
#if defined EVENT_DMG				
			}
#endif
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// ap, ammo
public scxpm_regen8(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rarmor[id]>0)
					APRegen(id)
				if(rammo[id]>0)
					AmmoAP(id)
#if defined EVENT_DMG				
			}
#endif
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// ap
public scxpm_regen9(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rarmor[id]>0)
					APRegen(id)
#if defined EVENT_DMG				
			}
#endif
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// ammo, tp, block
public scxpm_regen10(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rammo[id]>0)
					AmmoOnly(id)
				if(dist[id]>0)
					AmmoTP(id)
#if defined EVENT_DMG				
			}
#endif
			if(dodge[id]>0)
			{
				BlockAttack(id)
			}
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// ammo, tp
public scxpm_regen11(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rammo[id]>0)
					AmmoOnly(id)
				if(dist[id]>0)
					AmmoTP(id)
#if defined EVENT_DMG				
			}
#endif
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// ammo
public scxpm_regen12(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rammo[id]>0)
					AmmoOnly(id)
#if defined EVENT_DMG				
			}
#endif
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// tp, block
public scxpm_regen13(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(dist[id]>0)
					TeamPower(id)
#if defined EVENT_DMG				
			}
#endif
			if(dodge[id]>0)
				BlockAttack(id)
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// tp
public scxpm_regen14(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(dist[id]>0)
					TeamPower(id)
#if defined EVENT_DMG				
			}
#endif
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// block
public scxpm_regen15(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
			if(dodge[id]>0)
				BlockAttack(id)
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// hp, ammo, tp, block
public scxpm_regen16(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
				if(rammo[id]>0)
					AmmoHP(id)
				if(dist[id]>0)
					AmmoTPHP(id)
#if defined EVENT_DMG				
			}
#endif
			if(dodge[id]>0)
				BlockAttack(id)
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// hp, ammo, tp
public scxpm_regen17(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
				if(rammo[id]>0)
					AmmoHP(id)
				if(dist[id]>0)
					AmmoTPHP(id)
#if defined EVENT_DMG				
			}
#endif
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// hp, ammo
public scxpm_regen18(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
				if(rammo[id]>0)
					AmmoHP(id)
#if defined EVENT_DMG				
			}
#endif
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// hp, ap, tp, block
public scxpm_regen19(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
				if(rarmor[id]>0)
					APRegen(id)
				if(dist[id]>0)
					TeamHPAP(id)
#if defined EVENT_DMG				
			}
#endif
			if(dodge[id]>0)
				BlockAttack(id)
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// hp, ap, tp
public scxpm_regen20(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
				if(rarmor[id]>0)
					APRegen(id)
				if(dist[id]>0)
					TeamHPAP(id)
#if defined EVENT_DMG				
			}
#endif
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// ap, tp, block
public scxpm_regen21(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rarmor[id]>0)
					APRegen(id)
				if(dist[id]>0)
					TeamAP(id)
#if defined EVENT_DMG				
			}
#endif
			if(dodge[id]>0)
				BlockAttack(id)
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// ap, tp
public scxpm_regen22(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rarmor[id]>0)
					APRegen(id)
				if(dist[id]>0)
					TeamAP(id)
#if defined EVENT_DMG				
			}
#endif
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// hp, ap, ammo, block
public scxpm_regen23(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
				if(rarmor[id]>0)
					APRegen(id)
				if(rammo[id]>0)
					AmmoHPAP(id)
#if defined EVENT_DMG				
			}
#endif

			if(dodge[id]>0)
				BlockAttack(id)
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// ap, ammo, block
public scxpm_regen24(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rarmor[id]>0)
					APRegen(id)
				if(rammo[id]>0)
					AmmoAP(id)
#if defined EVENT_DMG				
			}
#endif
			if(dodge[id]>0)
				BlockAttack(id)
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// hp, ap, block
public scxpm_regen25(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
				if(rarmor[id]>0)
					APRegen(id)
#if defined EVENT_DMG				
			}
#endif

			if(dodge[id]>0)
				BlockAttack(id)
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// hp, block
public scxpm_regen26(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
#if defined EVENT_DMG				
			}
#endif
			if(dodge[id]>0)
				BlockAttack(id)
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// ap, block
public scxpm_regen27(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rarmor[id]>0)
					APRegen(id)
#if defined EVENT_DMG				
			}
#endif
			if(dodge[id]>0)
				BlockAttack(id)
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// hp, tp, block
public scxpm_regen28(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
				if(dist[id]>0)
					TeamHP(id)
#if defined EVENT_DMG				
			}
#endif
			if(dodge[id]>0)
				BlockAttack(id)
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// hp, tp
public scxpm_regen29(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
				if(dist[id]>0)
					TeamHP(id)
#if defined EVENT_DMG				
			}
#endif
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// hp, ammo, block
public scxpm_regen30(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rhealth[id]>0)
					HPRegen(id)
				if(rammo[id]>0)
					AmmoHP(id)
#if defined EVENT_DMG				
			}
#endif
			if(dodge[id]>0)
				BlockAttack(id)
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
// ammo, block
public scxpm_regen31(id) {
	if(is_user_alive(id))
	{
#if defined PLYR_CTRL
		if(playerlevel[id]>0)
		{
#endif
#if defined EVENT_DMG
			if (!PlayerIsHurt[id])
			{
#endif
#if defined LUCK_CTRL
				if(is_lucky(id))
					isLucky[id] = true;
				else
					isLucky[id] = false;
#endif
				if(rammo[id]>0)
					AmmoOnly(id)
#if defined EVENT_DMG				
			}
#endif
			if(dodge[id]>0)
				BlockAttack(id)
#if defined COUNT_CTRL
			count_func(id);
#endif
#if defined PLYR_CTRL
		}
		else
			zerocheck(id);
#endif
	}
}
#endif // NEW_LOOP