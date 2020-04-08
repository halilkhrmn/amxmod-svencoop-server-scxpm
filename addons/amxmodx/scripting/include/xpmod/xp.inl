// "xp.inl" for xp handling organization
// may need to make negative values for all these functions to calculate xp on negative amount of frags
// calculate needed xp for next level
// I may want to use this example to make medal gain variable by float value and player level instead of rank...
// calculate needed xp for next level
public scxpm_calcneedxp ( id ) {
	new Float:m70 = float( playerlevel[id] ) * 70.0;
	new Float:mselfm3dot2 = float( playerlevel[id] ) * float( playerlevel[id] ) * 3.5;
	neededxp[id] = floatround( m70 + mselfm3dot2 + 30.0 );
}
// calculate level from xp
public scxpm_calc_lvl ( xp ) {
	return floatround( -10 + floatsqroot( 100 - ( 60 / 7 - ( ( xp - 1 ) / 3.5 ) ) ), floatround_ceil );
}
public scxpm_calc_xp ( level) {
	level--;
	return floatround( (float( level ) * 70.0) + (float( level ) * float(level) * 3.5) + 30);
}
// ^ add bonus xp here?
// regen task loop start
public scxpm_sdac(id) 
{
#if defined NEW_LOOP
	if (is_user_connected(id))
		scxpm_loop_switch(id);
#endif // NEW_LOOP
}