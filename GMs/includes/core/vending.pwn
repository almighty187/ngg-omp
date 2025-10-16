/*
If a vending machine says "you are not at a candy/spunk vending machine" when pressing F and the animation starts, you need to add it's coordinate.
Vending Machine coordinates are located in callbacks.inc at like 216. You also need to specify if it's a Candy or Sprunk machine. Make sure to update callbacks.inc on Github when updating.
*/

public OnPlayerUseVending(playerid, type) {
    if(!IsPlayerNearVending(playerid, type)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You're not near a %s machine!", (type == 1) ? ("Sprunk") : ("Candy"));
    new Float:healtha;
    GetHealth(playerid, healtha);
    if(gettime() - LastShot[playerid] < 60) return SendClientMessageEx(playerid, COLOR_GRAD2, "You have been injured within the last 60 seconds, you cannot use the vending machine");
  	if((PlayerInfo[playerid][pConnectHours] > 5 && GetPlayerCash(playerid) < 750)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You need at least $750 to buy %s!", (type == 1) ? ("a Sprunk") : ("some Candy")), ClearAnimationsEx(playerid);
    if((PlayerInfo[playerid][pConnectHours] < 5 && GetPlayerCash(playerid) < 150)) return SendClientMessageEx(playerid, COLOR_GRAD1, "You need at least $150 to buy %s!", (type == 1) ? ("a Sprunk") : ("some Candy")), ClearAnimationsEx(playerid);
  	if((healtha > 99.0)) return SendClientMessageEx(playerid, COLOR_GRAD2, "Your health is already at 100");
//    if((healtha + 35.0) > 100.0) SetHealth(playerid, 100);
//    else SetHealth(playerid, healtha+35);
  	SetTimerEx("SprunkTimer", 3000, false, "i", playerid); 
    if((PlayerInfo[playerid][pConnectHours] > 5)) {
    	SendClientMessageEx(playerid, COLOR_GRAD1, "You paid $750 for %s!", (type == 1) ? ("a Sprunk") : ("some Candy"));
    	GivePlayerCash(playerid, -750);
    }
    if((PlayerInfo[playerid][pConnectHours] < 5)) {
    	SendClientMessageEx(playerid, COLOR_GRAD1, "You paid $150 for %s!", (type == 1) ? ("a Sprunk") : ("some Candy"));
    	GivePlayerCash(playerid, -150);
    }
    return 1;
}  


forward SprunkTimer(playerid);
public SprunkTimer(playerid)
{
	new Float:healtha;
    GetHealth(playerid, healtha);
    if((healtha + 35.0) > 100.0) SetHealth(playerid, 100);
    else SetHealth(playerid, healtha+35);
	return 1;
}