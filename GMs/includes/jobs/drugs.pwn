/*CMD:useheroin(playerid, params[])
{
	if(PlayerInfo[playerid][pHospital])
		return SendClientMessageEx(playerid, COLOR_GREY, "You cannot do this at this time.");
	if(PlayerInfo[playerid][pHeroin] < 10)
	    return SendClientMessageEx(playerid, COLOR_GREY, "You need at least 10 milligrams of heroin.");

	if(PlayerInfo[playerid][pSyringes] == 0)
	    return SendClientMessageEx(playerid, COLOR_GREY, "You don't have any syringes.");

    if(gettime()-GetPVarInt(playerid, "HeroinLastUsed") < 300)
		return SendClientMessageEx(playerid, COLOR_GRAD2, "You can only use heroin once every 5 minutes.");
	
	if(GetPVarType(playerid, "AttemptingLockPick")) 
		return SendClientMessageEx(playerid, COLOR_WHITE, "You are attempting a lockpick, please wait.");
	
    if(GetPVarInt(playerid, "Injured") != 1) {
		new szMessage[128];

		SetPVarInt(playerid, "HeroinLastUsed", gettime());
		PlayerInfo[playerid][pHeroin] -= 10;
		PlayerInfo[playerid][pSyringes] -= 1;

		SetPVarInt(playerid, "InjectHeroinStanding", SetTimerEx("InjectHeroinStanding", 5000, 0, "i", playerid));

		SendClientMessageEx(playerid, COLOR_GREEN, "You have injected heroin into yourself, the effects will begin in 5 seconds.");
		format(szMessage, sizeof(szMessage), "* %s injects heroin into himself.", GetPlayerNameEx(playerid));
		ProxDetector(25.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);

		if(!IsPlayerInAnyVehicle(playerid)) ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);

        return 1;
	}

	new szMessage[128];

	SetPVarInt(playerid, "HeroinLastUsed", gettime());
	PlayerInfo[playerid][pHeroin] -= 10;
	PlayerInfo[playerid][pSyringes] -= 1;

	SetPVarInt(playerid, "Health", 30);
	SetPVarInt(playerid, "InjectHeroin", SetTimerEx("InjectHeroin", 5000, 0, "i", playerid));

	SendClientMessageEx(playerid, COLOR_GREEN, "You have injected heroin into yourself, the effects will begin in 5 seconds.");
	format(szMessage, sizeof(szMessage), "* %s injects heroin into himself.", GetPlayerNameEx(playerid));
	ProxDetector(25.0, playerid, szMessage, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	return 1;
}*/
