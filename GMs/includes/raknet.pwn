new bool:PlayerWidescreen[MAX_PLAYERS];
new Float:PlayerAspectRatio[MAX_PLAYERS];

stock bool:IsPlayerUsingWidescreen(playerid)
{
    if(!IsPlayerConnected(playerid)) return false;
    return PlayerWidescreen[playerid];
}

stock Float:GetPlayerAspectRatio(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0.0;
    return PlayerAspectRatio[playerid];
}

IPacket:203(playerid, BitStream:bs)
{
    new BitStream:bsCopy = BS_NewCopy(bs);

    new aimData[PR_AimSync];

    BS_IgnoreBits(bsCopy, 8);
    BS_ReadAimSync(bsCopy, aimData);

    BS_Delete(bsCopy);

    new Float:aspectRatio = BS_UnpackAspectRatio(aimData[PR_aspectRatio]);

    if(aspectRatio > 0.0)
    {
        PlayerAspectRatio[playerid] = aspectRatio;

        if(aspectRatio >= 1.5)
        {
            PlayerWidescreen[playerid] = true;
        }
        else
        {
            PlayerWidescreen[playerid] = false;
        }
    }

    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    PlayerWidescreen[playerid] = false;
    PlayerAspectRatio[playerid] = 0.0;
    return 1;
}

hook OnPlayerConnect(playerid)
{
    PlayerWidescreen[playerid] = false;
    PlayerAspectRatio[playerid] = 0.0;
    return 1;
}

CMD:aspectratio(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 2)
    {
        SendClientMessageEx(playerid, COLOR_GRAD1, "You are not authorized to use this command.");
        return 1;
    }

    new giveplayerid;
    if(sscanf(params, "u", giveplayerid))
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /aspectratio [player]");
        return 1;
    }

    if(!IsPlayerConnected(giveplayerid))
    {
        SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
        return 1;
    }

    new string[128], targetName[MAX_PLAYER_NAME];
    GetPlayerName(giveplayerid, targetName, sizeof(targetName));

    new Float:ratio = GetPlayerAspectRatio(giveplayerid);
    new bool:isWidescreen = IsPlayerUsingWidescreen(giveplayerid);

    if(ratio == 0.0)
    {
        format(string, sizeof(string), "%s's aspect ratio: Not yet detected (waiting for aim data)", targetName);
        SendClientMessageEx(playerid, COLOR_WHITE, string);
    }
    else
    {
        format(string, sizeof(string), "%s's aspect ratio: %.3f (%s)",
            targetName, ratio, isWidescreen ? ("Widescreen") : ("Standard/4:3"));
        SendClientMessageEx(playerid, COLOR_WHITE, string);
    }

    return 1;
}