// "menu.inl" 

// show skill calculation
public SCXPMSkill( id ) {
	// the default value for the increment is 1
	skillIncrement[id] = 1;
#if defined ALLOW_BOTS
	if (skillpoints[id] > 20 )
#else
	if (skillpoints[id] > 20 && !is_user_bot(id))
#endif
		SCXPMIncrementMenu( id );
#if !defined ALLOW_BOTS
	else if(!is_user_bot(id))
#else
	else
#endif
		SCXPMSkillMenu( id );
}
// show the skills menu
public SCXPMSkillMenu( id ) {
	new menuBody[1024];
	format(menuBody,1023,"%L",LANG_SERVER,"L_MENU_SKILL_BODY",skillpoints[id],Stre,health[id],SupArm,armor[id],HPRe,rhealth[id],APRe,rarmor[id],AmmoRe,rammo[id],Grav,gravity[id],Aware,speed[id],TeamP,dist[id],Block,dodge[id]);
	show_menu(id,(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)|(1<<7)|(1<<8)|(1<<9),menuBody,13,"select_skill");
}
// show the increment menu
public SCXPMIncrementMenu( id ) {
	new menuBody[1024];
	if (skillpoints[id] >= 20 && skillpoints[id] < 50)
		format(menuBody,1023,"%L",LANG_SERVER,"L_MENU_INCREMENT1");
	else if (skillpoints[id] >= 50 && skillpoints[id] < 100)
		format(menuBody,1023,"%L",LANG_SERVER,"L_MENU_INCREMENT2");	
	else if (skillpoints[id] >= 100)
		format(menuBody,1023,"%L",LANG_SERVER,"L_MENU_INCREMENT3");
	show_menu(id,(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5),menuBody,13,"select_increment");
}
public SCXPMIncrementChoice( id, key ) {
	switch(key)
	{
		case 0:
			skillIncrement[id] = 1;
		case 1:
			skillIncrement[id] = 5;
		case 2:
			skillIncrement[id] = 10;
		case 3:
			skillIncrement[id] = 25;
		case 4:
			skillIncrement[id] = 50;
		case 5:
			skillIncrement[id] = 100;
	}
	SCXPMSkillMenu( id );
}
// choose a skill
public SCXPMSkillChoice( id, key ) {
	switch(key)
	{
		case 0:
		{
			if(skillpoints[id]>0)
			{
				if(health[id]<450)
				{
					if(get_pcvar_num(pcvar_health))
					{
						if (skillIncrement[id] + health[id] >= 450) 
							skillIncrement[id] = 450 - health[id];
						if (skillpoints[id] >= skillIncrement[id])
						{
							skillpoints[id] -= skillIncrement[id];
							health[id] += skillIncrement[id];
#if defined HEALTH_CTRL
							get_max_hp(id);
#endif
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],Stre,health[id]);
							if(is_user_alive(id))
							{
								set_user_health(id, get_user_health(id) + skillIncrement[id]);
#if defined HEALTH_CTRL
								max_hp_check(id);
#else
								if(get_user_health(id) > 645)
									set_user_health(id, 645)
#endif
							}
						}
						else
						{
							skillIncrement[id] = skillpoints[id];
							skillpoints[id] -= skillIncrement[id];
							health[id] += skillIncrement[id];
#if defined HEALTH_CTRL
							get_max_hp(id);						
#endif
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],Stre,health[id]);
							if(is_user_alive(id))
							{
								set_user_health(id, get_user_health(id) + skillIncrement[id]);
#if defined HEALTH_CTRL
								max_hp_check(id);
#else
								if(get_user_health(id) > 645)
									set_user_health(id, 645)
#endif
							}
						}
#if defined HEALTH_CTRL
					}
					else
						client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG2",SCXPM,Stre);
#endif
				}
				else
					client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG3",SCXPM,Stre);
				if(skillpoints[id]>0)
					SCXPMSkill(id);
			}
			else
				client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG4",SCXPM,Stre);
		}
		case 1:
		{
			if(skillpoints[id]>0)
			{
				if(armor[id]<450)
				{
#if defined ARMOR_CTRL
					if(get_pcvar_num(pcvar_armor))
					{
#endif
						if (skillIncrement[id] + armor[id] >= 450) 
							skillIncrement[id] = 450 - armor[id];
						if (skillpoints[id] >= skillIncrement[id])
						{
							skillpoints[id]-= skillIncrement[id];
							armor[id] += skillIncrement[id];
#if defined ARMOR_CTRL
							get_max_ap(id);
#endif
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],SupArm,armor[id]);
							if(is_user_alive(id))
							{
#if defined USING_CS
								cs_set_user_armor(id,get_user_armor(id)+skillIncrement[id], CS_ARMOR_VESTHELM);
#else
								set_user_armor(id,get_user_armor(id)+skillIncrement[id]);
#endif
#if defined ARMOR_CTRL
								max_ap_check(id);
#else
								if(get_user_armor(id)>645)
#if defined USING_CS
									cs_set_user_armor(id, 645, CS_ARMOR_VESTHELM);
#else
									set_user_armor(id, 645);
#endif
#endif
							}
						}
						else
						{
							skillIncrement[id] = skillpoints[id];
							skillpoints[id]-= skillIncrement[id];
							armor[id] += skillIncrement[id];
#if defined ARMOR_CTRL
							get_max_ap(id);
#endif
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],SupArm,armor[id]);
							if(is_user_alive(id))
							{
#if defined USING_CS
								cs_set_user_armor(id,get_user_armor(id)+skillIncrement[id], CS_ARMOR_VESTHELM);
#else
								set_user_armor(id,get_user_armor(id)+skillIncrement[id]);
#endif
#if defined ARMOR_CTRL
								max_ap_check(id);
#else
								if(get_user_armor(id)>645)
#if defined USING_CS
									cs_set_user_armor(id, 645, CS_ARMOR_VESTHELM);
#else
									set_user_armor(id, 645);
#endif
#endif
							}
						}
#if defined ARMOR_CTRL
					}
					else
						client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG2",SCXPM,SupArm);
#endif					
				}
				else
					client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG3",SCXPM,SupArm);
				if(skillpoints[id]>0)
					SCXPMSkill(id)
			}
			else
				client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG4",SCXPM,SupArm);
		}
		case 2:
		{
			if(skillpoints[id]>0)
			{
				if(rhealth[id]<300)
				{
#if defined HPREGEN_CTRL
					if(get_pcvar_num(pcvar_hpregen))
					{
#endif
						if (skillIncrement[id] + rhealth[id] >= 300)
							skillIncrement[id] = 300 - rhealth[id];
						if (skillpoints[id] >= skillIncrement[id])
						{
							skillpoints[id] -= skillIncrement[id];
							rhealth[id] += skillIncrement[id];
							rhealthwait[id]=rhealth[id];
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],HPRe,rhealth[id]);
						}
						else
						{
							skillIncrement[id] = skillpoints[id];
							skillpoints[id] -= skillIncrement[id];
							rhealth[id] += skillIncrement[id];
							rhealthwait[id]=rhealth[id]
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],HPRe,rhealth[id]);
						}
#if defined HPREGEN_CTRL
					}
					else
						client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG2",SCXPM,HPRe);
#endif
				}
				else
					client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG3",SCXPM,HPRe);
				if(skillpoints[id]>0)
					SCXPMSkill(id)
			}
			else
				client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG4",SCXPM,HPRe);
		}
		case 3:
		{
			if(skillpoints[id]>0)
			{
				if(rarmor[id]<300)
				{
#if defined NANO_CTRL
					if(get_pcvar_num(pcvar_nano))
					{
#endif
						if (skillIncrement[id] + rarmor[id] >= 300)
							skillIncrement[id] = 300 - rarmor[id];
						if (skillpoints[id] >= skillIncrement[id])
						{
							skillpoints[id] -= skillIncrement[id];
							rarmor[id] += skillIncrement[id];
							rarmorwait[id]=rarmor[id]
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],APRe,rarmor[id]);
						}
						else
						{
							skillIncrement[id] = skillpoints[id]
							skillpoints[id] -= skillIncrement[id];
							rarmor[id] += skillIncrement[id];
							rarmorwait[id]=rarmor[id];
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],APRe,rarmor[id]);
						}
#if defined NANO_CTRL
					}
					else
						client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG2",SCXPM,APRe);
#endif
				}
				else
					client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG3",SCXPM,APRe);
				if(skillpoints[id]>0)
					SCXPMSkill(id)
			}
			else
				client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG4",SCXPM,APRe);
		}
		case 4:
		{
			if(skillpoints[id]>0)
			{
				if(rammo[id]<30)
				{
#if defined AMMO_CTRL
					if(get_pcvar_num(pcvar_ammo))
					{
#endif
						if (skillIncrement[id] + rammo[id] >= 30)
							skillIncrement[id] = 30 - rammo[id];
						if (skillpoints[id] >= skillIncrement[id])
						{
							skillpoints[id] -= skillIncrement[id];
							rammo[id] += skillIncrement[id];
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],AmmoRe,rammo[id]);
						}
						else
						{
							skillIncrement[id] = skillpoints[id];
							skillpoints[id] -= skillIncrement[id];
							rammo[id] += skillIncrement[id];
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],AmmoRe,rammo[id]);
						}
					}
#if defined AMMO_CTRL
					else
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG2",SCXPM,AmmoRe);
#endif
				}
				else
					client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG3",SCXPM,AmmoRe);
				if(skillpoints[id]>0)
					SCXPMSkill(id)
			}
			else
				client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG4",SCXPM,AmmoRe);
		}
		case 5:
		{
			if(skillpoints[id]>0)
			{
				if(gravity[id]<40)
				{
					if (get_pcvar_num(pcvar_gravity) >= 1)
					{
						if (skillIncrement[id] + gravity[id] >= 40)
							skillIncrement[id] = 40 - gravity[id];
						if (skillpoints[id] >= skillIncrement[id])
						{
							skillpoints[id] -= skillIncrement[id];
							gravity[id] += skillIncrement[id];
							if (is_user_alive(id))
								gravity_enable(id);
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],Grav,gravity[id]);
						}
						else
						{
							skillIncrement[id] = skillpoints[id];
							skillpoints[id] -= skillIncrement[id];
							gravity[id] += skillIncrement[id];
							if (is_user_alive(id))
								gravity_enable(id);
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],Grav,gravity[id]);
						}
					}
					else
						client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG2",SCXPM,Grav);
				}
				else
					client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG3",SCXPM,Grav);
				if(skillpoints[id]>0)
					SCXPMSkill(id)
			}
			else
				client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG4",SCXPM,Grav);
		}
		case 6:
		{
			if(skillpoints[id]>0)
			{
				if(speed[id]<80)
				{
					if (skillIncrement[id] + speed[id] >= 80)
						skillIncrement[id] = 80 - speed[id];
					if (skillpoints[id] >= skillIncrement[id])
					{
						skillpoints[id] -= skillIncrement[id];
						speed[id] += skillIncrement[id];
						client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],Aware,speed[id]);
					}
					else
					{
						skillIncrement[id] = skillpoints[id];
						skillpoints[id] -= skillIncrement[id];
						speed[id] += skillIncrement[id];
						client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],Aware,speed[id]);
					}
#if defined ARMOR_CTRL
					get_max_ap(id);
#endif
#if defined HEALTH_CTRL
					get_max_hp(id);
#endif
				}
				else
					client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG3",SCXPM,Aware);
				if(skillpoints[id]>0)
					SCXPMSkill(id)
			}
			else
				client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG4",SCXPM,Aware);
		}
		case 7:
		{
			if(skillpoints[id]>0)
			{
				if(dist[id]<60)
				{
#if defined TP_CTRL
					if(get_pcvar_num(pcvar_teampower))
					{
#endif
						if (skillIncrement[id] + dist[id] >= 60)
							skillIncrement[id] = 60 - dist[id];
						if (skillpoints[id] >= skillIncrement[id])
						{
							skillpoints[id] -= skillIncrement[id];
							dist[id] += skillIncrement[id];
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],TeamP,dist[id]);
						}
						else
						{
							skillIncrement[id] = skillpoints[id];
							skillpoints[id] -= skillIncrement[id];
							dist[id] += skillIncrement[id];
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],TeamP,dist[id]);
						}
#if defined TP_CTRL
					}
					else
						client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG2",SCXPM,TeamP);
#endif
				}
				else
					client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG3",SCXPM,TeamP);
				if(skillpoints[id]>0)
					SCXPMSkill(id)
			}
			else
				client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG4",SCXPM,TeamP);
		}
		case 8:
		{
			if(skillpoints[id]>0)
			{
				if(dodge[id]<90)
				{
#if defined BLOCK_CTRL
					if(get_pcvar_num(pcvar_block))
					{
#endif
						if (skillIncrement[id] + dodge[id] >= 90)
							skillIncrement[id] = 90 - dodge[id];
						if (skillpoints[id] >= skillIncrement[id])
						{
							skillpoints[id] -= skillIncrement[id];
							dodge[id] += skillIncrement[id];
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],Block,dodge[id]);
						}
						else
						{
							skillIncrement[id] = skillpoints[id];
							skillpoints[id] -= skillIncrement[id];
							dodge[id] += skillIncrement[id];
							client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG1",SCXPM,skillIncrement[id],Block,dodge[id]);
						}
#if defined BLOCK_CTRL
					}
					else
						client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG2",SCXPM,Block);
#endif
				}
				else
					client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG3",SCXPM,Block);
				if(skillpoints[id]>0)
					SCXPMSkill(id)
			}
			else
				client_print(id, print_chat, "%L", LANG_SERVER,"SKILLMSG4",SCXPM,Block);
		}
		case 9:
		{
		}
	}
	return PLUGIN_HANDLED;
}