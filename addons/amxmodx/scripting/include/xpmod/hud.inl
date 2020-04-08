// show players data
#if !defined USING_SVEN
public scxpm_showdata(id) {
	set_hudmessage(50,135,180,0.7,0.04,0,1.0,255.0,0.0,0.0,get_pcvar_num(pcvar_hud_channel))
	if(playerlevel[id]<get_pcvar_num(pcvar_maxlevel))
	{
		if ( get_user_health( id ) > 250 || get_user_armor( id ) > 250)
		{
			if (skillpoints[id]<1)
			{
				show_hudmessage(id,"Exp.:   %i / %i  (+%i)^nLevel:   %i / %i^nRank:   %s^nMedals:   %i / 15^nHealth:   %i^nArmor:   %i", xp[id],neededxp[id],neededxp[id]-xp[id],playerlevel[id],get_pcvar_num( pcvar_maxlevel ),ranks[rank[id]],medals[id]-1, get_user_health( id ), get_user_armor( id ))
			}
			else
			{
				show_hudmessage(id,"Exp.:   %i / %i  (+%i)^nLevel:   %i / %i^nRank:   %s^nMedals:   %i / 15^nHealth:   %i^nArmor:   %i^nPoints:   %i", xp[id],neededxp[id],neededxp[id]-xp[id],playerlevel[id],get_pcvar_num( pcvar_maxlevel ),ranks[rank[id]],medals[id]-1, get_user_health( id ), get_user_armor( id ), skillpoints[id])
			}
		}
		else
		{
			if (skillpoints[id]<1)
			{
				show_hudmessage(id,"Exp.:   %i / %i  (+%i)^nLevel:   %i / %i^nRank:   %s^nMedals:   %i / 15", xp[id],neededxp[id],neededxp[id]-xp[id],playerlevel[id],get_pcvar_num( pcvar_maxlevel ),ranks[rank[id]],medals[id]-1)
			}
			else
			{
				show_hudmessage(id,"Exp.:   %i / %i  (+%i)^nLevel:   %i / %i^nRank:   %s^nMedals:   %i / 15^nPoints:   %i", xp[id],neededxp[id],neededxp[id]-xp[id],playerlevel[id],get_pcvar_num( pcvar_maxlevel ),ranks[rank[id]],medals[id]-1, skillpoints[id])
			}
		}
	}
	else if ( playerlevel[id] >= get_pcvar_num( pcvar_maxlevel ) ) {
		if ( get_user_health( id ) > 250 || get_user_armor( id ) > 250)
		{
			show_hudmessage(id,"Exp.:   %i^nLevel:   %i / %i^nRank:   %s^nMedals:   %i / 15^nHealth:   %i^nArmor:   %i", xp[id],playerlevel[id],get_pcvar_num( pcvar_maxlevel ),ranks[rank[id]],medals[id]-1, get_user_health( id ), get_user_armor( id ))
		}
		else
		{
			show_hudmessage(id,"Exp.:   %i^nLevel:   %i / %i^nRank:   %s^nMedals:   %i / 15", xp[id],playerlevel[id],get_pcvar_num( pcvar_maxlevel ),ranks[rank[id]],medals[id]-1)
		}
	}

}
#else
public scxpm_showdata(id) {
	//set_hudmessage(50,135,180,0.7,0.04,0,1.0,11.0,0.0,0.0,get_pcvar_num(pcvar_hud_channel)) // trying to reduce time this is on screen...unneeded for 255.0 seconds? - task time of scxpm_regen counter sets to 10-11 seconds, so perhaps set this to 12?...
	set_hudmessage(50,135,180,0.7,0.04,0,1.0,255.0,0.0,0.0,get_pcvar_num(pcvar_hud_channel))
	if(playerlevel[id]<get_pcvar_num(pcvar_maxlevel))
	{
		if (skillpoints[id]<1)
		{
			show_hudmessage(id,"Exp.:   %i / %i  (+%i)^nLevel:   %i / %i^nRank:   %s^nMedals:   %i / 15", xp[id],neededxp[id],neededxp[id]-xp[id],playerlevel[id],get_pcvar_num( pcvar_maxlevel ),ranks[rank[id]],medals[id]-1)
		}
		else
		{
			show_hudmessage(id,"Exp.:   %i / %i  (+%i)^nLevel:   %i / %i^nRank:   %s^nMedals:   %i / 15^nPoints:   %i", xp[id],neededxp[id],neededxp[id]-xp[id],playerlevel[id],get_pcvar_num( pcvar_maxlevel ),ranks[rank[id]],medals[id]-1, skillpoints[id])
		}
	}
	else 
	{
		if (skillpoints[id]<1)
		{
			show_hudmessage(id,"Exp.:   %i^nLevel:   %i / %i^nRank:   %s^nMedals:   %i / 15", xp[id],playerlevel[id],get_pcvar_num( pcvar_maxlevel ),ranks[rank[id]],medals[id]-1)
		}
		else
		{
			show_hudmessage(id,"Exp.:   %i^nLevel:   %i / %i^nRank:   %s^nMedals:   %i / 15^nPoints:   %i", xp[id],playerlevel[id],get_pcvar_num( pcvar_maxlevel ),ranks[rank[id]],medals[id]-1, skillpoints[id])
		}
	}
}
#endif
