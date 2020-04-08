/*
* The table create code is too long to compile so table have to be created manually
CREATE TABLE IF NOT EXISTS `scxpm_stats` (
	`id` int(11) NOT NULL auto_increment,
	`uniqueid` varchar(50) NOT NULL,
	`authid` varchar(24) NOT NULL,
	`ip` varchar(24) NOT NULL,
	`nick` varchar(50) NOT NULL,
	`xp` bigint(20) NOT NULL default '0',
	`playerlevel` int(11) NOT NULL default '0',
	`skillpoints` int(11) NOT NULL default '0',
	`medals` tinyint(4) NOT NULL default '4',
	`health` int(11) NOT NULL default '0',
	`armor` int(11) NOT NULL default '0',
	`rhealth` int(11) NOT NULL default '0',
	`rarmor` int(11) NOT NULL default '0',
	`rammo` int(11) NOT NULL default '0',
	`gravity` int(11) NOT NULL default '0',
	`speed` int(11) NOT NULL default '0',
	`dist` int(11) NOT NULL default '0',
	`dodge` int(11) NOT NULL default '0',
	`lastUpdated` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
	PRIMARY KEY  (`id`),
	UNIQUE KEY `uniqueid` (`uniqueid`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
*/
/*
*	Future Features
*	if you want new features ask it on: http://forums.alliedmods.net/showthread.php?t=44168
*	------------------
*	- pruning database with the `lastUpdated` field
*	- cuicide penalty
*
*/
/*
** Queries 
*/
/*
#define QUERY_SELECT_SKILLS "SELECT `xp`, `playerlevel`, `skillpoints`, `medals`, `health`, `armor`, `rhealth`, `rarmor`, `rammo`, `gravity`, `speed`, `dist`, `dodge` FROM `%s` WHERE %s"
#define QUERY_UPDATE_SKILLS "INSERT INTO %s (uniqueid) VALUES ('%s') ON DUPLICATE KEY UPDATE authid ='%s',nick='%s',ip='%s',xp='%d',playerlevel='%d',skillpoints='%d',medals='%d',health='%d',armor='%d',rhealth='%d',rarmor='%d',rammo='%d',gravity='%d',speed='%d',dist='%d',dodge='%d'"
*/
// init the sql, check if the sql table exist
public sql_init() {
	if ( get_pcvar_num( pcvar_save ) >= 2 && !dbc)
	{
		if (get_pcvar_num( pcvar_debug ) == 1 )
			log_amx( "%s Begin Init the sql",DEBUG);
#if defined SQLCVAR		
		new host[64], username[64], password[64], dbname[64];
		get_pcvar_string( pcvar_sql_host, host, 64 );
		get_pcvar_string( pcvar_sql_user, username, 64 );
		get_pcvar_string( pcvar_sql_pass, password, 64 );
		get_pcvar_string( pcvar_sql_db, dbname, 64 );
#endif
		get_pcvar_string( pcvar_sql_table, sql_table, 64 );
		SQL_SetAffinity( "mysql" );
#if defined SQLCVAR
		dbc = SQL_MakeDbTuple( host, username, password, dbname );
#else
		dbc = SQL_MakeDbTuple( DATABASE_HOST, DATABASE_USERNAME, DATABASE_PASSWORD, DATABASE_DATABASE );
#endif
		// check if the table exist
		formatex( g_Cache, 1023, "show tables like '%s'", sql_table );
		SQL_ThreadQuery( dbc, "ShowTableHandle", g_Cache);	
		if (get_pcvar_num( pcvar_debug ) == 1 )
			log_amx( "%s End Init the sql",DEBUG);
	}
}
// load empty skills for new player or faulty load
public LoadEmptySkills( id ) {
#if !defined ALLOW_BOTS
	if (is_user_connected(id) && !is_user_bot(id))
#else
	if (is_user_connected(id))
#endif
	{
#if defined FREE_LEVELS
		scxpm_levelcheck(id);
#else
		xp[id] = 0;
		playerlevel[id] = 0;
		scxpm_calcneedxp( id );
		scxpm_getrank( id );
		skillpoints[id] = 0;
		firstLvl[id]=0;
#endif
		medals[id] = 4;
		health[id] = 0;
		armor[id] = 0;
		rhealth[id] = 0;
		rarmor[id] = 0;
		rammo[id] = 0;
		gravity[id] = 0;
		speed[id] = 0;
		dist[id] = 0;
		dodge[id] = 0;
#if defined LUCK
		luck[id] = 0;
#endif
		lastfrags[id] = 0;
#if defined FRAGBONUS
		medal_limit[id]=get_pcvar_num(pcvar_bonuslimit);
#endif
#if defined ALLOW_TRADE
		trade_limit[id]=get_pcvar_num(pcvar_tradelimit);
#endif
	}
}
// save and load
//
// load player data
public LoadPlayerData( id )
{
	new save = get_pcvar_num( pcvar_save );
	new debug_on = get_pcvar_num( pcvar_debug );
	if (plugin_ended == false)
	{
		if ( debug_on ){
			if(!is_user_bot(id) && !is_user_hltv(id))
			{
				new nickname[35];
				get_user_name( id, nickname, 34 );
				log_amx( "%s Loading data for: %s",DEBUG,nickname );
			}
		}
#if defined ALLOW_BOTS
		if(!is_user_hltv(id) && is_user_connected(id))
#else
		if(!is_user_bot(id) && !is_user_hltv(id) && is_user_connected(id))
#endif
		{
			if ( save <= 0 ){
				set_task(5.0, "LoadEmptySkills", id);
			}else if ( save == 1 ){
				scxpm_loadxp_file( id );
			}else if ( save >= 2 ){
				if ( !dbc ) sql_init();
				scxpm_loadxp_mysql( id );
			}else{
				if ( debug_on ){
					new nickname[35];
					get_user_name( id, nickname, 34 );
					log_amx( "%s Data already loaded, don't load data for: %s",DEBUG,nickname );
				}
			}
			// experimental loading spot here
			set_task(1.5, "plyr_loaded", id);
		}
	}
	else {
		if ( debug_on )
			log_amx( "%s Plugin already ended, don't load data",DEBUG);
	}
}
// save player data - may not need all these hltv checks in sven coop anymore
public SavePlayerData( id ) {
	new debug_on = get_pcvar_num( pcvar_debug );
	if(plugin_ended == true) 
	{
		if ( debug_on)
			log_amx( "%s Plugin already ended, don't save data",DEBUG);
		return PLUGIN_HANDLED;
	}
	else
	{
		new save = get_pcvar_num( pcvar_save );

#if defined ALLOW_BOTS
		if ( save == 0 || is_user_hltv(id) || !is_user_connected(id)) return PLUGIN_CONTINUE;
#else
		if ( save == 0 || is_user_bot(id) || is_user_hltv(id) || !is_user_connected(id)) return PLUGIN_CONTINUE;
#endif
		if (is_player_flag_set(loaddata,id))
		{
			if(playerlevel[id] > 0)
			{
				if ( debug_on ){
					new nickname[35];
					get_user_name( id, nickname, 34 );
					log_amx( "%s Saving data for: %s",DEBUG,nickname ); 
				}
				// 0 = will not be saved
				// 1 = save to file
				// 2 = save to mysql
				if ( save == 1 )
					scxpm_savexp_file( id );
				else{
					if ( !dbc )
					{
						sql_init();
					}
					scxpm_savexp_mysql( id );
				}
			}
			else
			{
				if ( debug_on )
				{
					new nickname[35];
					get_user_name( id, nickname, 34 );
					log_amx( "%s level less than 1, don't save data for: %s",DEBUG,nickname );
				}
			}
		}
		else 
		{
			if ( debug_on ){
				new nickname[35];
				get_user_name( id, nickname, 34 );
				log_amx( "%s Data not loaded, don't save data for: %s",DEBUG,nickname );
			}
		}
	}
	return PLUGIN_CONTINUE;
}
// load player data from file
public scxpm_loadxp_file( id ) {
	new savestyle = get_pcvar_num(pcvar_savestyle);
	new authid[35];
	switch(savestyle){
		case 0 : {
			get_user_authid(id, authid, 34)
			if ( containi(authid,"STEAM_ID_PENDING") !=-1 ){
				set_task(5.0, "LoadEmptySkills", id);
				return PLUGIN_CONTINUE;
			}
		}
		case 1:
			get_user_ip(id, authid, 34, 1);
		case 2:
			get_user_name(id, authid, 34);
	}
	new vaultkey[64], vaultdata[96];
	format(vaultkey,63,"%s-scxpm",authid);
	if ( vaultdata_exists(vaultkey) )
	{
		get_vaultdata(vaultkey,vaultdata,95);
		replace_all(vaultdata,95,"#"," ");
#if defined LUCK
		new pre_xp[16],pre_playerlevel[8],pre_skillpoints[8],pre_medals[8],pre_health[8],pre_armor[8],pre_rhealth[8],pre_rarmor[8],pre_rammo[8],pre_gravity[8],pre_speed[8],pre_dist[8],pre_dodge[8],pre_luck[8];
		parse(vaultdata,pre_xp,15,pre_playerlevel,7,pre_skillpoints,7,pre_medals,7,pre_health,7,pre_armor,7,pre_rhealth,7,pre_rarmor,7,pre_rammo,7,pre_gravity,7,pre_speed,7,pre_dist,7,pre_dodge,7,pre_luck,7);
#else
		new pre_xp[16],pre_playerlevel[8],pre_skillpoints[8],pre_medals[8],pre_health[8],pre_armor[8],pre_rhealth[8],pre_rarmor[8],pre_rammo[8],pre_gravity[8],pre_speed[8],pre_dist[8],pre_dodge[8];
		parse(vaultdata,pre_xp,15,pre_playerlevel,7,pre_skillpoints,7,pre_medals,7,pre_health,7,pre_armor,7,pre_rhealth,7,pre_rarmor,7,pre_rammo,7,pre_gravity,7,pre_speed,7,pre_dist,7,pre_dodge,7);
#endif
		xp[id] = str_to_num(pre_xp);
		playerlevel[id] = str_to_num(pre_playerlevel);
		skillpoints[id] = str_to_num(pre_skillpoints);
		medals[id] = str_to_num(pre_medals);
		health[id] = str_to_num(pre_health);
		armor[id] = str_to_num(pre_armor);
		rhealth[id] = str_to_num(pre_rhealth);
		rarmor[id] = str_to_num(pre_rarmor);
		rammo[id] = str_to_num(pre_rammo);
		gravity[id] = str_to_num(pre_gravity);
		speed[id] = str_to_num(pre_speed);
		dist[id] = str_to_num(pre_dist);
		dodge[id] = str_to_num(pre_dodge);
#if defined LUCK
		luck[id] = str_to_num(pre_luck);
#endif
	}
	else
	{
		log_amx("%s Start from level 0",SCXPM);
		set_task(1.0, "LoadEmptySkills", id);
	}
	set_player_flag(loaddata, id);
	return PLUGIN_CONTINUE;
}
// save player data to file
public scxpm_savexp_file( id ) {
	new savestyle = get_pcvar_num(pcvar_savestyle);
	new authid[35];
	switch(savestyle){
		case 0 : {
			get_user_authid( id, authid, 34 );
			if ( containi(authid,"STEAM_ID_PENDING") !=-1 )
				return PLUGIN_CONTINUE;
		}
		case 1:
			get_user_ip( id, authid, 34, 1 );
		case 2:
			get_user_name( id, authid, 34 );
	}
	new vaultkey[64], vaultdata[96];
	format( vaultdata, 95, "%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i",xp[id],playerlevel[id],skillpoints[id],medals[id],health[id],armor[id],rhealth[id],rarmor[id],rammo[id],gravity[id],speed[id],dist[id],dodge[id]);
	set_vaultdata( vaultkey, vaultdata );
	return PLUGIN_CONTINUE;
}
// save player data to a database
public scxpm_savexp_mysql( id ) {
	if(!is_user_connecting(id))
	{
		new savestyle = get_pcvar_num(pcvar_savestyle);
		new authid[35];
		new ip[35];
		new nickname[128];
		new where_statement[1024];
		get_user_authid(id, authid, 34);
		get_user_ip(id, ip, 34, 1);
		get_user_name(id, nickname, 63);
		if ( equali(ip, "") || equali(nickname, "") ) {
			if ( get_pcvar_num( pcvar_debug ) == 1 )
				log_amx( "%s Empty ip or nickname, don't save data.",DEBUG);
			return PLUGIN_CONTINUE;
		}
		replace_all(nickname,127,"'","\'");
		switch(savestyle){
			case 0 : {
				if ( containi(authid,"STEAM_ID_PENDING") !=-1 || equali(authid, "") ){
					if ( get_pcvar_num( pcvar_debug ) == 1 )
						log_amx( "%s Empty or invalid steamid, don't save data.",DEBUG);
					return PLUGIN_CONTINUE;
				}
				formatex( g_Cache, 1023, QUERY_UPDATE_SKILLS, sql_table, authid, authid, nickname, ip, xp[id], playerlevel[id], skillpoints[id], medals[id], health[id], armor[id], rhealth[id], rarmor[id], rammo[id], gravity[id], speed[id], dist[id], dodge[id], where_statement );
			}
			case 1:
				formatex( g_Cache, 1023, QUERY_UPDATE_SKILLS, sql_table, ip, authid, nickname, ip, xp[id], playerlevel[id], skillpoints[id], medals[id], health[id], armor[id], rhealth[id], rarmor[id], rammo[id], gravity[id], speed[id], dist[id], dodge[id], where_statement );
			case 2:
				formatex( g_Cache, 1023, QUERY_UPDATE_SKILLS, sql_table, nickname, authid, nickname, ip, xp[id], playerlevel[id], skillpoints[id], medals[id], health[id], armor[id], rhealth[id], rarmor[id], rammo[id], gravity[id], speed[id], dist[id], dodge[id], where_statement );
		}
		SQL_ThreadQuery( dbc, "QueryHandle", g_Cache );
	}
	return PLUGIN_CONTINUE;
}
// load player data from a database
public scxpm_loadxp_mysql( id ) {
	new savestyle = get_pcvar_num(pcvar_savestyle);
	if (get_pcvar_num(pcvar_debug) == 1)
	{
		if (!is_user_bot(id) && !is_user_hltv(id))
			log_amx( "%s Entered public scxpm_loadxp_mysql( id )",DEBUG);
	}
#if defined ALLOW_BOTS
	if(!is_user_hltv(id) && is_user_connected(id))
#else
	if(!is_user_bot(id) && !is_user_hltv(id) && is_user_connected(id))
#endif
	{
		new where_statement[1024];
		new authid[35];
		new ip[35];
		new nickname[128];
		get_user_authid( id, authid, 34 );
		get_user_ip( id, ip, 34, 1 );
		get_user_name( id, nickname, 63 );
		replace_all(nickname,127,"'","\'"); //avoiding sql errors with ' in name
		switch(savestyle){
			case 0 : {
				if ( containi(authid,"STEAM_ID_PENDING") !=-1 || equali(authid, "") ){
					set_task(5.0, "LoadEmptySkills", id)
					return PLUGIN_CONTINUE;
				}
				format(where_statement, 199, "`uniqueid` = '%s'", authid);
			}
			case 1:
				format(where_statement, 49, "`uniqueid` = '%s'", ip);
			case 2:
				format(where_statement, 199, "`uniqueid` = '%s'", nickname);
		}
		formatex( g_Cache, 1023, QUERY_SELECT_SKILLS, sql_table, where_statement);
		new send_id[1];
		send_id[0] = id;
		SQL_ThreadQuery( dbc, "LoadDataHandle", g_Cache, send_id, 1 );
	}
	return PLUGIN_CONTINUE;
}
// sql handles
//
// handle default queries
public QueryHandle( FailState, Handle:Query, Error[], Errcode, Data[], DataSize ) {
	new debug_on = get_pcvar_num( pcvar_debug );
	if (debug_on)	{
		log_amx( "%s Begin QueryHandle",DEBUG);
		new sql[1024];
		SQL_GetQueryString ( Query, sql, 1024 );
		log_amx( "%s executed query: %s",DEBUG,sql );
	}
	// lots of error checking
	if ( FailState == TQUERY_CONNECT_FAILED ) {
		log_amx( "%s Could not connect to SQL database.",SQL);
		return set_fail_state("[SCXPM SQL] Could not connect to SQL database.");
	}
	else if ( FailState == TQUERY_QUERY_FAILED ) {
		new sql[1024];
		SQL_GetQueryString ( Query, sql, 1024 );
		log_amx( "%s SQL Query failed: %s",SQL,sql);
		return set_fail_state("[SCXPM SQL] SQL Query failed.");
	}
	if ( Errcode )
		return log_amx("%s SQL Error on query: %s",SQL,Error);
	if ( debug_on )
		log_amx( "%s End QueryHandle",DEBUG);
	return PLUGIN_CONTINUE;
}
// check if table exist
public ShowTableHandle(FailState,Handle:Query,Error[],Errcode,Data[],DataSize) {
	new debug_on = get_pcvar_num( pcvar_debug );
	if (debug_on) {
		log_amx("%s Begin ShowTableHandle",DEBUG);
		new sql[1024];
		SQL_GetQueryString ( Query, sql, 1024 );
		log_amx( "%s executed query: %s",DEBUG,sql);
	}
	if(FailState==TQUERY_CONNECT_FAILED){
		log_amx( "%s Could not connect to SQL database.",SQL);
		log_amx( "%s Switching to: scxpm_save 0",SQL);
		log_amx( "%s Stats won't be saved",SQL);
		set_pcvar_num ( pcvar_save, 0 );
		return PLUGIN_CONTINUE;
	}
	else if (FailState == TQUERY_QUERY_FAILED) {
		log_amx( "%s Query failed.",SQL);
		log_amx( "%s Switching to: scxpm_save 0",SQL);
		log_amx( "%s Stats won't be saved",SQL);
		set_pcvar_num ( pcvar_save, 0 );
		return PLUGIN_CONTINUE;
	}
	if (Errcode) {
		log_amx( "%s Error on query: %s",SQL,Error);
		log_amx( "%s Switching to: scxpm_save 0",SQL);
		log_amx( "%s Stats won't be saved",SQL);
		set_pcvar_num ( pcvar_save, 0 );
		return PLUGIN_CONTINUE;
	}
	if (SQL_NumResults(Query) > 0) {
		if (get_pcvar_num( pcvar_debug ) == 1 )
			log_amx( "%s Database table found: %s",DEBUG,sql_table);
	}
	else {
		log_amx( "%s Could not find the table: %s",SQL,sql_table );
		log_amx( "%s Switching to: scxpm_save 0",SQL);
		log_amx( "%s Stats won't be saved",SQL);
		set_pcvar_num ( pcvar_save, 0 );
	}
	if (debug_on)
		log_amx( "%s End ShowTableHandle",DEBUG);
	return PLUGIN_CONTINUE;
}
// load player data
public LoadDataHandle(FailState,Handle:Query,Error[],Errcode,Data[],DataSize) {
	new debug_on = get_pcvar_num( pcvar_debug );
	if (debug_on){
		log_amx( "%s Begin LoadDataHandle",DEBUG);
		new sql[1024];
		SQL_GetQueryString ( Query, sql, 1024 );
		log_amx( "%s executed query: %s",DEBUG,sql);
	}
	if (FailState == TQUERY_CONNECT_FAILED)
		return set_fail_state("Could not connect to SQL database.");
	else if (FailState == TQUERY_QUERY_FAILED)
		return set_fail_state("Query failed.");
	if (Errcode)
		return log_amx("Error on query: %s",Error);
	new id = Data[0];
	set_player_flag(loaddata, id);
	if (SQL_NumResults(Query) >= 1) {
		if (SQL_NumResults(Query) > 1) {
			if (get_pcvar_num( pcvar_debug ) == 1 )
				log_amx( "%s more than one entry found. just take the first one",DEBUG);
		}
		xp[id] = SQL_ReadResult(Query, 0);
		playerlevel[id] = SQL_ReadResult(Query, 1);
		skillpoints[id] = SQL_ReadResult( Query, 2 );
		medals[id] = SQL_ReadResult(Query, 3);
		health[id] = SQL_ReadResult(Query, 4);
		armor[id] = SQL_ReadResult(Query, 5);
		rhealth[id] = SQL_ReadResult(Query, 6); 
		rarmor[id] = SQL_ReadResult(Query, 7);
		rammo[id] = SQL_ReadResult(Query, 8);
		gravity[id] = SQL_ReadResult(Query, 9); 
		speed[id] = SQL_ReadResult(Query, 10);
		dist[id] = SQL_ReadResult(Query, 11);
		dodge[id] = SQL_ReadResult(Query, 12);
#if defined LUCK
		luck[id] = SQL_ReadResult(Query, 13); // incomplete, don't use yet
#endif
	}
	else if (SQL_NumResults(Query) < 1)
		set_task(1.0, "LoadEmptySkills", id)
	if (debug_on)
		log_amx( "%s End LoadDataHandle",DEBUG);
	return PLUGIN_CONTINUE;
}