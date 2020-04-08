// plugin for gamename fakemeta on map _server_start load for scxpm
#define VERSION "17.31.35"
#include <amxmodx>
#include <fakemeta>
new pcvar_gamename;
public plugin_init()
{
	log_amx( "[SCXPM] %s _server_start", VERSION );
	register_plugin("fm_gamename",VERSION,"Silencer");
	register_forward(FM_GetGameDescription,"scxpm_gn");
	// there is no need to change the name
	pcvar_gamename = register_cvar("fm_gamename","1");
}
// set gamename
public scxpm_gn() { 
	if( get_pcvar_num(pcvar_gamename) >= 1 )
	{
		new g[32];
		format( g, 31, "SCXPM %s", VERSION );
		forward_return( FMV_STRING, g);
		return FMRES_SUPERCEDE;
	}
	return PLUGIN_HANDLED;
}
