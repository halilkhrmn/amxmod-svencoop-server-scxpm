// This ammo_skill.inl file handles all of the ammo reincarnation
public scxpm_randomammo( id ) {
	new number = random_num(0,6)
#if defined USING_CS
	give_item(id, ammotype[number]);
#else
	new clip,ammo
	if(number==0)
	{
		get_user_ammo(id,2,clip,ammo)
		if(ammo<250)
		{
			give_item(id,Ammo9mm)
			give_item(id,Ammo9mm)
		}
		else
			number=1
	}
	if(number==1)
	{
		get_user_ammo(id,3,clip,ammo)
		if(ammo<36)
		{
			give_item(id,Ammo357)
			give_item(id,Ammo357)
			give_item(id,Ammo357)
		}
		else
			number=2
	}
	if(number==2)
	{
		get_user_ammo(id,7,clip,ammo)
		if(ammo<125)
		{
			give_item(id,AmmoBS)
			give_item(id,AmmoBS)
			give_item(id,AmmoBS)
		}
		else
			number=3
	}
	if(number==3)
	{
		get_user_ammo(id,9,clip,ammo)
		if(ammo<100)
		{
			give_item(id,AmmoGC)
			give_item(id,AmmoGC)
		}
		else
			number=4
	}
	if(number==4)
	{
		get_user_ammo(id,6,clip,ammo)
		if(ammo<50)
		{
			give_item(id,AmmoCB)
			give_item(id,AmmoCB)
		}
		else
			number=5
	}
	if(number==5)
	{
		get_user_ammo(id,8,clip,ammo)
		if(ammo<5)
			give_item(id,AmmoRPG)
		else
			number=6
	}
	if(number==6)
	{
		get_user_ammo(id,23,clip,ammo)
		if(ammo<15)
		{
			give_item(id,Ammo762)
			give_item(id,Ammo762)
			give_item(id,Ammo556)
			give_item(id,Ammo556)
			give_item(id,AmmoSC)
			give_item(id,AmmoSC)
			give_item(id,AmmoSC)
			give_item(id,AmmoSC)
			give_item(id,AmmoSC)
		}
	}
#endif
}
#if defined USING_CS
cs_hp_weapon(id)
{
	new clip,ammo
	switch(get_user_weapon(id,clip,ammo))
	{
		case 1: /* P228 */
		{
			get_user_ammo(id,21,clip,ammo)
			if(ammo<rammo[id]+13)
			{
				give_item(id,"ammo_357sig")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		// no weapon 2 index in counter-strike
		case 3: /* SCOUT */
		{							
			get_user_ammo(id,3,clip,ammo)
			if(ammo<20)
			{
				give_item(id,"ammo_762nato")
			}
			else
			{
				scxpm_randomammo(id)
			}									
		}
		case 4: /* HEGRENADE */
		{
			scxpm_randomammo(id)
		}
		case 5: /* XM1014 */
		{
			get_user_ammo(id,5,clip,ammo)
			if(ammo<21)
			{
				give_item(id,"ammo_buckshot")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 6: /* C4 */
		{
			scxpm_randomammo(id)
		}
		case 7: /* MAC10 */
		{
			get_user_ammo(id,7,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_45acp")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 8: /* AUG */
		{
			get_user_ammo(id,8,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 9: /* SMOKEGRENADE */
		{
			scxpm_randomammo(id)
		}
		case 10: /* ELITES */
		{
			get_user_ammo(id,10,clip,ammo)
			if(ammo<100)
			{
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 11: /* FIVESEVEN */
		{
			get_user_ammo(id,11,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_57mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 12: /* UMP45 */
		{
			get_user_ammo(id,12,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_45acp")
				give_item(id, "ammo_45acp")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 13: /* SG550 */
		{
			get_user_ammo(id,13,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 14: /* GALIL */ 
		{
			get_user_ammo(id,14,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 15: /* FAMAS */ 
		{
			get_user_ammo(id,15,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 16: /* USP */
		{
			get_user_ammo(id,16,clip,ammo)
			if(ammo<250)
			{
				give_item(id,"ammo_45acp")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 17: /* GLOCK18 */
		{
			get_user_ammo(id,17,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 18: /* AWP */
		{
			get_user_ammo(id,18,clip,ammo)
			if(ammo<20)
			{
				give_item(id,"ammo_338magnum")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 19: /* MP5NAVY */
		{
			get_user_ammo(id,19,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 20: /* M249 */
		{
			get_user_ammo(id,20,clip,ammo)
			if(ammo<100+rammo[id])
			{
				give_item(id,"ammo_556natobox")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 21: /* M3 */
		{
			get_user_ammo(id,21,clip,ammo)
			if(ammo<24)
			{
				give_item(id,"ammo_buckshot")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 22: /* M4A1 */
		{
			get_user_ammo(id,22,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 23: /* TMP */
		{
			// can go up to 120...
			get_user_ammo(id,23,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_9mm")
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 24: /* G3SG1 */
		{

			get_user_ammo(id,24,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_762nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 25: /* FLASHBANG */
		{
			scxpm_randomammo(id)
		}
		case 26: /* DEAGLE */
		{
			get_user_ammo(id,26,clip,ammo)
			if(ammo<21)
			{
				give_item(id,"ammo_50ae")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 27: /* SG552 */
		{
			get_user_ammo(id,27,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 28: /* AK47 */
		{
			get_user_ammo(id,27,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id,"ammo_762nato")	
			}
			else
			{
				scxpm_randomammo(id)
			}
			
		}
		case 29: /* KNIFE */
		{
			scxpm_randomammo(id)
		}
		case 30: /* P90 */
		{
			get_user_ammo(id,30,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id,"ammo_57mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
	}
}
// armor regeneration in ammo skill
cs_ap_weapon(id)
{
	// support of reading CS weapons for ammo added by swmpdg - may 07 2016
	new clip,ammo
	switch(get_user_weapon(id,clip,ammo))
	{
		case 1: /* P228 */
		{
			get_user_ammo(id,21,clip,ammo)
			if(ammo<rammo[id]+13)
			{
				give_item(id,"ammo_357sig")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		// no weapon 2 index in counter-strike
		case 3: /* SCOUT */
		{							
			get_user_ammo(id,3,clip,ammo)
			if(ammo<20)
			{
				give_item(id,"ammo_762nato")
			}
			else
			{
				scxpm_randomammo(id)
			}									
		}
		case 4: /* HEGRENADE */
		{
			scxpm_randomammo(id)
		}
		case 5: /* XM1014 */
		{
			get_user_ammo(id,5,clip,ammo)
			if(ammo<21)
			{
				give_item(id,"ammo_buckshot")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 6: /* C4 */
		{
			scxpm_randomammo(id)
		}
		case 7: /* MAC10 */
		{
			get_user_ammo(id,7,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_45acp")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 8: /* AUG */
		{
			get_user_ammo(id,8,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 9: /* SMOKEGRENADE */
		{
			scxpm_randomammo(id)
		}
		case 10: /* ELITES */
		{
			get_user_ammo(id,10,clip,ammo)
			if(ammo<100)
			{
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 11: /* FIVESEVEN */
		{
			get_user_ammo(id,11,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_57mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 12: /* UMP45 */
		{
			get_user_ammo(id,12,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_45acp")
				give_item(id, "ammo_45acp")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 13: /* SG550 */
		{
			get_user_ammo(id,13,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 14: /* GALIL */ 
		{
			get_user_ammo(id,14,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 15: /* FAMAS */ 
		{
			get_user_ammo(id,15,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 16: /* USP */
		{
			get_user_ammo(id,16,clip,ammo)
			if(ammo<250)
			{
				give_item(id,"ammo_45acp")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 17: /* GLOCK18 */
		{
			get_user_ammo(id,17,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 18: /* AWP */
		{
			get_user_ammo(id,18,clip,ammo)
			if(ammo<20)
			{
				give_item(id,"ammo_338magnum")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 19: /* MP5NAVY */
		{
			get_user_ammo(id,19,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 20: /* M249 */
		{
			get_user_ammo(id,20,clip,ammo)
			if(ammo<100+rammo[id])
			{
				give_item(id,"ammo_556natobox")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 21: /* M3 */
		{
			get_user_ammo(id,21,clip,ammo)
			if(ammo<24)
			{
				give_item(id,"ammo_buckshot")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 22: /* M4A1 */
		{
			get_user_ammo(id,22,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 23: /* TMP */
		{
			// can go up to 120...
			get_user_ammo(id,23,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_9mm")
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 24: /* G3SG1 */
		{

			get_user_ammo(id,24,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_762nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 25: /* FLASHBANG */
		{
			scxpm_randomammo(id)
		}
		case 26: /* DEAGLE */
		{
			get_user_ammo(id,26,clip,ammo)
			if(ammo<21)
			{
				give_item(id,"ammo_50ae")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 27: /* SG552 */
		{
			get_user_ammo(id,27,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 28: /* AK47 */
		{
			get_user_ammo(id,27,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id,"ammo_762nato")	
			}
			else
			{
				scxpm_randomammo(id)
			}
			
		}
		case 29: /* KNIFE */
		{
			scxpm_randomammo(id)
		}
		case 30: /* P90 */
		{
			get_user_ammo(id,30,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id,"ammo_57mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
	}
}
cs_hpap_weapon(id)
{
	// support of reading CS weapons for ammo added by swmpdg - may 07 2016
	new clip,ammo
	switch(get_user_weapon(id,clip,ammo))
	{
		case 1: /* P228 */
		{
			get_user_ammo(id,21,clip,ammo)
			if(ammo<rammo[id]+13)
			{
				give_item(id,"ammo_357sig")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		// no weapon 2 index in counter-strike
		case 3: /* SCOUT */
		{							
			get_user_ammo(id,3,clip,ammo)
			if(ammo<20)
			{
				give_item(id,"ammo_762nato")
			}
			else
			{
				scxpm_randomammo(id)
			}									
		}
		case 4: /* HEGRENADE */
		{
			scxpm_randomammo(id)
		}
		case 5: /* XM1014 */
		{
			get_user_ammo(id,5,clip,ammo)
			if(ammo<21)
			{
				give_item(id,"ammo_buckshot")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 6: /* C4 */
		{
			scxpm_randomammo(id)
		}
		case 7: /* MAC10 */
		{
			get_user_ammo(id,7,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_45acp")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 8: /* AUG */
		{
			get_user_ammo(id,8,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 9: /* SMOKEGRENADE */
		{
			scxpm_randomammo(id)
		}
		case 10: /* ELITES */
		{
			get_user_ammo(id,10,clip,ammo)
			if(ammo<100)
			{
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 11: /* FIVESEVEN */
		{
			get_user_ammo(id,11,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_57mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 12: /* UMP45 */
		{
			get_user_ammo(id,12,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_45acp")
				give_item(id, "ammo_45acp")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 13: /* SG550 */
		{
			get_user_ammo(id,13,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 14: /* GALIL */ 
		{
			get_user_ammo(id,14,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 15: /* FAMAS */ 
		{
			get_user_ammo(id,15,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 16: /* USP */
		{
			get_user_ammo(id,16,clip,ammo)
			if(ammo<250)
			{
				give_item(id,"ammo_45acp")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 17: /* GLOCK18 */
		{
			get_user_ammo(id,17,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 18: /* AWP */
		{
			get_user_ammo(id,18,clip,ammo)
			if(ammo<20)
			{
				give_item(id,"ammo_338magnum")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 19: /* MP5NAVY */
		{
			get_user_ammo(id,19,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 20: /* M249 */
		{
			get_user_ammo(id,20,clip,ammo)
			if(ammo<100+rammo[id])
			{
				give_item(id,"ammo_556natobox")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 21: /* M3 */
		{
			get_user_ammo(id,21,clip,ammo)
			if(ammo<24)
			{
				give_item(id,"ammo_buckshot")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 22: /* M4A1 */
		{
			get_user_ammo(id,22,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 23: /* TMP */
		{
			// can go up to 120...
			get_user_ammo(id,23,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_9mm")
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 24: /* G3SG1 */
		{

			get_user_ammo(id,24,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_762nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 25: /* FLASHBANG */
		{
			scxpm_randomammo(id)
		}
		case 26: /* DEAGLE */
		{
			get_user_ammo(id,26,clip,ammo)
			if(ammo<21)
			{
				give_item(id,"ammo_50ae")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 27: /* SG552 */
		{
			get_user_ammo(id,27,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 28: /* AK47 */
		{
			get_user_ammo(id,27,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id,"ammo_762nato")	
			}
			else
			{
				scxpm_randomammo(id)
			}
			
		}
		case 29: /* KNIFE */
		{
			scxpm_randomammo(id)
		}
		case 30: /* P90 */
		{
			get_user_ammo(id,30,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id,"ammo_57mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
	}	
}
cs_only_weapon(id)
{
	new clip,ammo
	switch(get_user_weapon(id,clip,ammo))
	{
		case 1: /* P228 */
		{
			get_user_ammo(id,21,clip,ammo)
			if(ammo<rammo[id]+13)
			{
				give_item(id,"ammo_357sig")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 3: /* SCOUT */
		{							
			get_user_ammo(id,3,clip,ammo)
			if(ammo<20)
			{
				give_item(id,"ammo_762nato")
			}
			else
			{
				scxpm_randomammo(id)
			}									
		}
		case 4: /* HEGRENADE */
		{
			scxpm_randomammo(id)
		}
		case 5: /* XM1014 */
		{
			get_user_ammo(id,5,clip,ammo)
			if(ammo<21)
			{
				give_item(id,"ammo_buckshot")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 6: /* C4 */
		{
			scxpm_randomammo(id)
		}
		case 7: /* MAC10 */
		{
			get_user_ammo(id,7,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_45acp")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 8: /* AUG */
		{
			get_user_ammo(id,8,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 9: /* SMOKEGRENADE */
		{
			scxpm_randomammo(id)
		}
		case 10: /* ELITES */
		{
			get_user_ammo(id,10,clip,ammo)
			if(ammo<100)
			{
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 11: /* FIVESEVEN */
		{
			get_user_ammo(id,11,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_57mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 12: /* UMP45 */
		{
			get_user_ammo(id,12,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_45acp")
				give_item(id, "ammo_45acp")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 13: /* SG550 */
		{
			get_user_ammo(id,13,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 14: /* GALIL */ 
		{
			get_user_ammo(id,14,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 15: /* FAMAS */ 
		{
			get_user_ammo(id,15,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id, "ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 16: /* USP */
		{
			get_user_ammo(id,16,clip,ammo)
			if(ammo<250)
			{
				give_item(id,"ammo_45acp")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 17: /* GLOCK18 */
		{
			get_user_ammo(id,17,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 18: /* AWP */
		{
			get_user_ammo(id,18,clip,ammo)
			if(ammo<20)
			{
				give_item(id,"ammo_338magnum")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 19: /* MP5NAVY */
		{
			get_user_ammo(id,19,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 20: /* M249 */
		{
			get_user_ammo(id,20,clip,ammo)
			if(ammo<100+rammo[id])
			{
				give_item(id,"ammo_556natobox")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 21: /* M3 */
		{
			get_user_ammo(id,21,clip,ammo)
			if(ammo<24)
			{
				give_item(id,"ammo_buckshot")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 22: /* M4A1 */
		{
			get_user_ammo(id,22,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 23: /* TMP */
		{
			// can go up to 120...
			get_user_ammo(id,23,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_9mm")
				give_item(id,"ammo_9mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 24: /* G3SG1 */
		{

			get_user_ammo(id,24,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_762nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 25: /* FLASHBANG */
		{
			scxpm_randomammo(id)
		}
		case 26: /* DEAGLE */
		{
			get_user_ammo(id,26,clip,ammo)
			if(ammo<21)
			{
				give_item(id,"ammo_50ae")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 27: /* SG552 */
		{
			get_user_ammo(id,27,clip,ammo)
			if(ammo<60+rammo[id])
			{
				give_item(id,"ammo_556nato")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
		case 28: /* AK47 */
		{
			get_user_ammo(id,27,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id,"ammo_762nato")	
			}
			else
			{
				scxpm_randomammo(id)
			}
			
		}
		case 29: /* KNIFE */
		{
			scxpm_randomammo(id)
		}
		case 30: /* P90 */
		{
			get_user_ammo(id,30,clip,ammo)
			if (ammo<60+rammo[id])
			{
				give_item(id,"ammo_57mm")
			}
			else
			{
				scxpm_randomammo(id)
			}
		}
	}	
}
#endif

#if defined USING_SVEN
// hp regen in ammo skill
sc_hp_weapon(id)
{
	new clip,ammo
	switch(get_user_weapon(id,clip,ammo))
	{
		case 1: /* Crowbar */
			scxpm_randomammo(id)
		case 2: /* 9mm Handgun */
		{
			get_user_ammo(id,2,clip,ammo)
			if(ammo<250)
				give_item(id,Ammo9mm)
			else
				scxpm_randomammo(id)
		}
		case 3: /* 357 (Revolver) */
		{
			get_user_ammo(id,3,clip,ammo)
			if(ammo<36)
			{
				give_item(id,Ammo357)
				give_item(id,Ammo357)
			}
			else
				scxpm_randomammo(id)
		}
		case 4: /* 9mm AR = MP5 */
		{
			get_user_ammo(id,4,clip,ammo)
			if(ammo<250)
			{
				give_item(id,Ammo9mm)
				give_item(id,Ammo9mm)
			}
			else
				scxpm_randomammo(id)
		}
		case 6: /* Crossbow */
		{
			get_user_ammo(id,6,clip,ammo)
			if(ammo<50)
			{
				give_item(id,AmmoCB)
				give_item(id,AmmoCB)
			}
			else
				scxpm_randomammo(id)
		}
		case 7: /* Shotgun */
		{
			get_user_ammo(id,7,clip,ammo)
			if(ammo<125)
			{
				give_item(id,AmmoBS)
				give_item(id,AmmoBS)
			}
			else
				scxpm_randomammo(id)
		}
		case 8: /* RPG Launcher */
		{
			get_user_ammo(id,8,clip,ammo)
			if(ammo<5)
				give_item(id,AmmoRPG)
			else
				scxpm_randomammo(id)
		}
		case 9: /* Gauss Cannon */
		{
			get_user_ammo(id,9,clip,ammo)
			if(ammo<100)
			{
				give_item(id,AmmoGC)
				give_item(id,AmmoGC)
			}
			else
				scxpm_randomammo(id)
		}
		case 10: /* Egon */
		{
			get_user_ammo(id,10,clip,ammo)
			if(ammo<100)
			{
				give_item(id,AmmoGC)
				give_item(id,AmmoGC)
			}
			else
				scxpm_randomammo(id)
		}
		case 11: /* Hornetgun */
			scxpm_randomammo(id)
		case 12: /* Handgrenade */
			scxpm_randomammo(id)
		case 13: /* Tripmine */
			scxpm_randomammo(id)
		case 14: /* Satchels */ // fixed, was 13
			scxpm_randomammo(id)
		case 15: /* Snarks */ // fixed, was 13
			scxpm_randomammo(id)
		case 16: /* Uzi Akimbo */
		{
			get_user_ammo(id,16,clip,ammo)
			if(ammo<250)
			{
				give_item(id,Ammo9mm)
				give_item(id,Ammo9mm)
			}
			else
				scxpm_randomammo(id)
		}
		case 17: /* Uzi */
		{
			get_user_ammo(id,17,clip,ammo)
			if(ammo<100)
			{
				give_item(id,Ammo9mm)
				give_item(id,Ammo9mm)
			}
			else
				scxpm_randomammo(id)
		}
		case 18: /* Medkit */
		{
			scxpm_randomammo(id)
			if(rhealth[id] > 0)
			{
				if(get_user_health(id)<100)
					set_user_health(id,get_user_health(id)+1)
#if defined HEALTH_CTRL
				else if(get_user_health(id)<maxhealth[id])
#else
				else if(get_user_health(id)<health[id]+100+(medals[id]-1)+speed[id])
#endif
#if defined LUCK_CTRL
					if(isLucky[id])
						set_user_health(id, get_user_health(id)+1)
					else
						rhealthwait[id]+=get_hprate(id)
#else
					rhealthwait[id]+=get_hprate(id)
#endif // luck
			}
		}
		case 20: /* Pipewrench */
			scxpm_randomammo(id)
		case 21: /* Minigun */
		{
			get_user_ammo(id,21,clip,ammo)
			if(ammo<100)
			{
				give_item(id,Ammo556)
				give_item(id,Ammo556)
			}
			else
				scxpm_randomammo(id)
		}
		case 22: /* Grapple */
			scxpm_randomammo(id)
		case 23: /* Sniper Rifle */
		{
			get_user_ammo(id,23,clip,ammo)
			if(ammo<15)
			{
				give_item(id,Ammo762)
				give_item(id,Ammo762)
			}
			else
				scxpm_randomammo(id)
		}
		case 24: /* M249 Saw */
		{

			get_user_ammo(id,24,clip,ammo)
			//if(ammo<600)
			if(ammo<100)
			{
				give_item(id,Ammo556)
				give_item(id,Ammo556)
			}
			else
				scxpm_randomammo(id)
		}
		case 25: /* M16 */
		{
			get_user_ammo(id,25,clip,ammo)
			if(ammo<600)
			{
				give_item(id,Ammo556)
				give_item(id,AmmoARG)
			}
			else if(ammo>=600)
			{
				give_item(id,AmmoARG)
				scxpm_randomammo(id)
			}
		}
		case 26: /* Spore Launcher */
		{
			get_user_ammo(id,26,clip,ammo)
			if(ammo<30)
			{
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
			}
			else
				scxpm_randomammo(id)
		}
		case 27: /* Desert Eagle */
		{
			get_user_ammo(id,27,clip,ammo)
			if(ammo<36)
			{
				give_item(id,Ammo357)
				give_item(id,Ammo357)
				give_item(id,Ammo357)
			}
			else
				scxpm_randomammo(id)
		}
		case 28: /* Shock Roach */
			// removed battery, because it "falls through map" on Escape Series...??
			scxpm_randomammo(id)
	}
}
sc_ap_weapon(id)
{
	new clip,ammo
	switch(get_user_weapon(id,clip,ammo))
	{
		case 1: /* Crowbar */
		{
			scxpm_randomammo(id)
			if(rarmor[id] > 0)
			{
				if (get_user_armor(id) < 100)
					set_user_armor(id, get_user_armor(id)+1)
#if defined ARMOR_CTRL
				else if (get_user_armor(id)<maxarmor[id])
#else
				else if (get_user_armor(id) < 100+armor[id]+(medals[id]-1)+speed[id])
#endif
#if defined LUCK_CTRL
					if(isLucky[id])
						set_user_armor(id, get_user_armor(id)+1)
					else
						rarmorwait[id]+=get_aprate(id)
#else
					rarmorwait[id]+=get_aprate(id)
#endif // luck
			}
		}
		case 2: /* 9mm Handgun */
		{
			get_user_ammo(id,2,clip,ammo)
			if(ammo<250)
			{
				give_item(id,Ammo9mm)
			}
			else
				scxpm_randomammo(id)
		}
		case 3: /* 357 (Revolver) */
		{
			get_user_ammo(id,3,clip,ammo)
			if(ammo<36)
			{
				give_item(id,Ammo357)
				give_item(id,Ammo357)
			}
			else
				scxpm_randomammo(id)
		}
		case 4: /* 9mm AR = MP5 */
		{
			get_user_ammo(id,4,clip,ammo)
			if(ammo<250)
			{
				give_item(id,Ammo9mm)
				give_item(id,Ammo9mm)
			}
			else
				scxpm_randomammo(id)
		}
		case 6: /* Crossbow */
		{
			get_user_ammo(id,6,clip,ammo)
			if(ammo<50)
			{
				give_item(id,AmmoCB)
				give_item(id,AmmoCB)
			}
			else
				scxpm_randomammo(id)
		}
		case 7: /* Shotgun */
		{
			get_user_ammo(id,7,clip,ammo)
			if(ammo<125)
			{
				give_item(id,AmmoBS)
				give_item(id,AmmoBS)
			}
			else
				scxpm_randomammo(id)
		}
		case 8: /* RPG Launcher */
		{
			get_user_ammo(id,8,clip,ammo)
			if(ammo<5)
				give_item(id,AmmoRPG)
			else
				scxpm_randomammo(id)
		}
		case 9: /* Gauss Cannon */
		{
			get_user_ammo(id,9,clip,ammo)
			if(ammo<100)
			{
				give_item(id,AmmoGC)
				give_item(id,AmmoGC)
			}
			else
				scxpm_randomammo(id)
		}
		case 10: /* Egon */
		{
			get_user_ammo(id,10,clip,ammo)
			if(ammo<100)
			{
				give_item(id,AmmoGC)
				give_item(id,AmmoGC)
			}
			else
				scxpm_randomammo(id)
		}
		case 11: /* Hornetgun */
			scxpm_randomammo(id)
		case 12: /* Handgrenade */
			scxpm_randomammo(id)
		case 13: /* Tripmine */
			scxpm_randomammo(id)
		case 14: /* Satchels */
			scxpm_randomammo(id)
		case 15: /* Snarks */
			scxpm_randomammo(id)
		case 16: /* Uzi Akimbo */
		{
			get_user_ammo(id,16,clip,ammo)
			if(ammo<250)
			{
				give_item(id,Ammo9mm)
				give_item(id,Ammo9mm)
			}
			else
				scxpm_randomammo(id)
		}
		case 17: /* Uzi */
		{
			get_user_ammo(id,17,clip,ammo)
			if(ammo<100)
			{
				give_item(id,Ammo9mm)
				give_item(id,Ammo9mm)
			}
			else
				scxpm_randomammo(id)

		}
		case 18: /* Medkit */
			scxpm_randomammo(id)
		case 20: /* Pipewrench */
		{
			scxpm_randomammo(id)
			if(rarmor[id] > 0)
			{
				if (get_user_armor(id) < 100)
					set_user_armor(id, get_user_armor(id)+1)
#if defined ARMOR_CTRL
				else if (get_user_armor(id)<maxarmor[id])
#else
				else if (get_user_armor(id) < 100+armor[id]+(medals[id]-1)+speed[id])
#endif
#if defined LUCK_CTRL
					if(isLucky[id])
						set_user_armor(id, get_user_armor(id)+1)
					else
						rarmorwait[id]+=get_aprate(id)
#else
					rarmorwait[id]+=get_aprate(id)
#endif // luck
			}
		}
		case 21: /* Minigun */
		{
			get_user_ammo(id,21,clip,ammo)
			if(ammo<100)
			{
				give_item(id,Ammo556)
				give_item(id,Ammo556)
			}
			else
				scxpm_randomammo(id)
		}
		case 22: /* Grapple */
			scxpm_randomammo(id)
		case 23: /* Sniper Rifle */
		{
			get_user_ammo(id,23,clip,ammo)
			if(ammo<15)
			{
				give_item(id,Ammo762)
				give_item(id,Ammo762)
			}
			else
				scxpm_randomammo(id)
		}
		case 24: /* M249 Saw */
		{

			get_user_ammo(id,24,clip,ammo)
			//if(ammo<600)
			if(ammo<100)
			{
				give_item(id,Ammo556)
				give_item(id,Ammo556)
			}
			else
				scxpm_randomammo(id)
		}
		case 25: /* M16 */
		{
			get_user_ammo(id,25,clip,ammo)
			if(ammo<600)
			{
				give_item(id,Ammo556)
				give_item(id,AmmoARG)
			}
			else if(ammo>=600)
			{
				give_item(id,AmmoARG)
				scxpm_randomammo(id)
			}
		}
		case 26: /* Spore Launcher */
		{
			get_user_ammo(id,26,clip,ammo)
			if(ammo<30)
			{
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
			}
			else
				scxpm_randomammo(id)
		}
		case 27: /* Desert Eagle */
		{
			get_user_ammo(id,27,clip,ammo)
			if(ammo<36)
			{
				give_item(id,Ammo357)
				give_item(id,Ammo357)
				give_item(id,Ammo357)
			}
			else
				scxpm_randomammo(id)
		}
		case 28: /* Shock Roach */
			scxpm_randomammo(id)
	}
}
sc_hpap_weapon(id)
{
	new clip,ammo
	switch(get_user_weapon(id,clip,ammo))
	{
		case 1: /* Crowbar */
		{
			scxpm_randomammo(id)
			if(rarmor[id] > 0)
			{
				if (get_user_armor(id) < 100)
					set_user_armor(id, get_user_armor(id)+1)
#if defined ARMOR_CTRL
				else if (get_user_armor(id)<maxarmor[id])
#else
				else if (get_user_armor(id) < 100+armor[id]+(medals[id]-1)+speed[id])	
#endif
#if defined LUCK_CTRL
					if(isLucky[id])
						set_user_armor(id, get_user_armor(id)+1)
					else
						rarmorwait[id]+=get_aprate(id)
#else
					rarmorwait[id]+=get_aprate(id)
#endif // luck
			}
		}
		case 2: /* 9mm Handgun */
		{
			get_user_ammo(id,2,clip,ammo)
			if(ammo<250)
			{
				give_item(id,Ammo9mm)
			}
			else
				scxpm_randomammo(id)
		}
		case 3: /* 357 (Revolver) */
		{
			get_user_ammo(id,3,clip,ammo)
			if(ammo<36)
			{
				give_item(id,Ammo357)
				give_item(id,Ammo357)
			}
			else
				scxpm_randomammo(id)
		}
		case 4: /* 9mm AR = MP5 */
		{
			get_user_ammo(id,4,clip,ammo)
			if(ammo<250)
			{
				give_item(id,Ammo9mm)
				give_item(id,Ammo9mm)
			}
			else
				scxpm_randomammo(id)
		}
		case 6: /* Crossbow */
		{
			get_user_ammo(id,6,clip,ammo)
			if(ammo<50)
			{
				give_item(id,AmmoCB)
				give_item(id,AmmoCB)
			}
			else
				scxpm_randomammo(id)
		}
		case 7: /* Shotgun */
		{
			get_user_ammo(id,7,clip,ammo)
			if(ammo<125)
			{
				give_item(id,AmmoBS)
				give_item(id,AmmoBS)
			}
			else
				scxpm_randomammo(id)
		}
		case 8: /* RPG Launcher */
		{
			get_user_ammo(id,8,clip,ammo)
			if(ammo<5)
			{
				give_item(id,AmmoRPG)
			}
			else
				scxpm_randomammo(id)
		}
		case 9: /* Gauss Cannon */
		{
			get_user_ammo(id,9,clip,ammo)
			if(ammo<100)
			{
				give_item(id,AmmoGC)
				give_item(id,AmmoGC)
			}
			else
				scxpm_randomammo(id)
		}
		case 10: /* Egon */
		{
			get_user_ammo(id,10,clip,ammo)
			if(ammo<100)
			{
				give_item(id,AmmoGC)
				give_item(id,AmmoGC)
			}
			else
				scxpm_randomammo(id)
		}
		case 11: /* Hornetgun */
			scxpm_randomammo(id)
		case 12: /* Handgrenade */
			scxpm_randomammo(id)
		case 13: /* Tripmine */
			scxpm_randomammo(id)
		case 14: /* Satchels */
			scxpm_randomammo(id)
		case 15: /* Snarks */
			scxpm_randomammo(id)
		case 16: /* Uzi Akimbo */
		{
			get_user_ammo(id,16,clip,ammo)
			if(ammo<250)
			{
				give_item(id,Ammo9mm)
				give_item(id,Ammo9mm)
			}
			else
				scxpm_randomammo(id)
		}
		case 17: /* Uzi */
		{
			get_user_ammo(id,17,clip,ammo)
			if(ammo<100)
			{
				give_item(id,Ammo9mm)
				give_item(id,Ammo9mm)
			}
			else
				scxpm_randomammo(id)
		}
		case 18: /* Medkit */
		{
			scxpm_randomammo(id)
			if(rhealth[id] > 0)
			{
				if(get_user_health(id)<100+health[id])
					set_user_health(id,get_user_health(id)+1)
#if defined HEALTH_CTRL
				else if(get_user_health(id)<maxhealth[id])
#else
				else if(get_user_health(id)<health[id]+100+(medals[id]-1)+speed[id])
#endif

#if defined LUCK_CTRL
					if(isLucky[id])
						set_user_health(id,get_user_health(id)+1)
					else
						rhealthwait[id]+=get_hprate(id)
#else
					rhealthwait[id]+=get_hprate(id)
#endif // luck
			}
		}
		case 20: /* Pipewrench */
		{
			scxpm_randomammo(id)
			if(rarmor[id] > 0)
			{
				if (get_user_armor(id) < 100)
					set_user_armor(id, get_user_armor(id)+1)
#if defined ARMOR_CTRL
				else if (get_user_armor(id)<maxarmor[id])
#else
				else if (get_user_armor(id) < 100+armor[id]+(medals[id]-1)+speed[id])
#endif
#if defined LUCK_CTRL
					if(isLucky[id])
						set_user_armor(id, get_user_armor(id)+1)
					else
						rarmorwait[id]+=get_aprate(id)
#else
					rarmorwait[id]+=get_aprate(id)
#endif // luck
			}
		}
		case 21: /* Minigun */
		{
			get_user_ammo(id,21,clip,ammo)
			if(ammo<100)
			{
				give_item(id,Ammo556)
				give_item(id,Ammo556)
			}
			else
				scxpm_randomammo(id)
		}
		case 22: /* Grapple */
			scxpm_randomammo(id)
		case 23: /* Sniper Rifle */
		{
			get_user_ammo(id,23,clip,ammo)
			if(ammo<15)
			{
				give_item(id,Ammo762)
				give_item(id,Ammo762)
			}
			else
				scxpm_randomammo(id)
		}
		case 24: /* M249 Saw */
		{

			get_user_ammo(id,24,clip,ammo)
			//if(ammo<600)
			if(ammo<100)
			{
				give_item(id,Ammo556)
				give_item(id,Ammo556)
			}
			else
				scxpm_randomammo(id)
		}
		case 25: /* M16 */
		{
			get_user_ammo(id,25,clip,ammo)
			if(ammo<600)
			{
				give_item(id,Ammo556)
				give_item(id,AmmoARG)
			}
			else if(ammo>=600)
			{
				give_item(id,AmmoARG)
				scxpm_randomammo(id)
			}
		}
		case 26: /* Spore Launcher */
		{
			get_user_ammo(id,26,clip,ammo)
			if(ammo<30)
			{
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
			}
			else
				scxpm_randomammo(id)
		}
		case 27: /* Desert Eagle */
		{
			get_user_ammo(id,27,clip,ammo)
			if(ammo<36)
			{
				give_item(id,Ammo357)
				give_item(id,Ammo357)
				give_item(id,Ammo357)
			}
			else
				scxpm_randomammo(id)
		}
		case 28: /* Shock Roach */
			scxpm_randomammo(id)
	}	
}
sc_only_weapon(id)
{
	new clip,ammo
	switch(get_user_weapon(id,clip,ammo))
	{
		case 1: /* Crowbar */
			scxpm_randomammo(id)
		case 2: /* 9mm Handgun */
		{
			get_user_ammo(id,2,clip,ammo)
			if(ammo<250)
				give_item(id,Ammo9mm)
			else
				scxpm_randomammo(id)
		}
		case 3: /* 357 (Revolver) */
		{
			get_user_ammo(id,3,clip,ammo)
			if(ammo<36)
			{
				give_item(id,Ammo357)
				give_item(id,Ammo357)
			}
			else
				scxpm_randomammo(id)
		}
		case 4: /* 9mm AR = MP5 */
		{
			get_user_ammo(id,4,clip,ammo)
			if(ammo<250)
			{
				give_item(id,Ammo9mm)
				give_item(id,Ammo9mm)
			}
			else
				scxpm_randomammo(id)
		}
		case 6: /* Crossbow */
		{
			get_user_ammo(id,6,clip,ammo)
			if(ammo<50)
			{
				give_item(id,AmmoCB)
				give_item(id,AmmoCB)
			}
			else
				scxpm_randomammo(id)
		}
		case 7: /* Shotgun */
		{
			get_user_ammo(id,7,clip,ammo)
			if(ammo<125)
			{
				give_item(id,AmmoBS)
				give_item(id,AmmoBS)
			}
			else
				scxpm_randomammo(id)
		}
		case 8: /* RPG Launcher */
		{
			get_user_ammo(id,8,clip,ammo)
			if(ammo<5)
				give_item(id,AmmoRPG)
			else
				scxpm_randomammo(id)
		}
		case 9: /* Gauss Cannon */
		{
			get_user_ammo(id,9,clip,ammo)
			if(ammo<100)
			{
				give_item(id,AmmoGC)
				give_item(id,AmmoGC)
			}
			else
				scxpm_randomammo(id)
		}
		case 10: /* Egon */
		{
			get_user_ammo(id,10,clip,ammo)
			if(ammo<100)
			{
				give_item(id,AmmoGC)
				give_item(id,AmmoGC)
			}
			else
				scxpm_randomammo(id)
		}
		case 11: /* Hornetgun */
			scxpm_randomammo(id)
		case 12: /* Handgrenade */
			scxpm_randomammo(id)
		case 13: /* Tripmine */
			scxpm_randomammo(id)
		case 14: /* Satchels */
			scxpm_randomammo(id)
		case 15: /* Snarks */
			scxpm_randomammo(id)
		case 16: /* Uzi Akimbo */
		{
			get_user_ammo(id,16,clip,ammo)
			if(ammo<250)
			{
				give_item(id,Ammo9mm)
				give_item(id,Ammo9mm)
			}
			else
				scxpm_randomammo(id)
		}
		case 17: /* Uzi */
		{
			get_user_ammo(id,17,clip,ammo)
			if(ammo<100)
			{
				give_item(id,Ammo9mm)
				give_item(id,Ammo9mm)
			}
			else
				scxpm_randomammo(id)
		}
		case 18: /* Medkit */
			scxpm_randomammo(id)
		case 20: /* Pipewrench */
			scxpm_randomammo(id)
		case 21: /* Minigun */
		{
			get_user_ammo(id,21,clip,ammo)
			if(ammo<100)
			{
				give_item(id,Ammo556)
				give_item(id,Ammo556)
			}
			else
				scxpm_randomammo(id)
		}
		case 22: /* Grapple */
			scxpm_randomammo(id)
		case 23: /* Sniper Rifle */
		{
			get_user_ammo(id,23,clip,ammo)
			if(ammo<15)
			{
				give_item(id,Ammo762)
				give_item(id,Ammo762)
			}
			else
				scxpm_randomammo(id)
		}
		case 24: /* M249 Saw */
		{

			get_user_ammo(id,24,clip,ammo)
			//if(ammo<600)
			if(ammo<100)
			{
				give_item(id,Ammo556)
				give_item(id,Ammo556)
			}
			else
				scxpm_randomammo(id)
		}
		case 25: /* M16 */
		{
			get_user_ammo(id,25,clip,ammo)
			if(ammo<600)
			{
				give_item(id,Ammo556)
				give_item(id,AmmoARG)
			}
			else if(ammo>=600)
			{
				give_item(id,AmmoARG)
				scxpm_randomammo(id)
			}
		}
		case 26: /* Spore Launcher */
		{
			get_user_ammo(id,26,clip,ammo)
			if(ammo<30)
			{
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
				give_item(id,AmmoSC)
			}
			else
				scxpm_randomammo(id)
		}
		case 27: /* Desert Eagle */
		{
			get_user_ammo(id,27,clip,ammo)
			if(ammo<36)
			{
				give_item(id,Ammo357)
				give_item(id,Ammo357)
				give_item(id,Ammo357)
			}
			else
				scxpm_randomammo(id)
		}
		case 28: /* Shock Roach */
			scxpm_randomammo(id)
	}
}
#endif