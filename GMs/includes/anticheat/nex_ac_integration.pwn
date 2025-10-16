#include <YSI_Coding\y_hooks>

bool:IsSevereCheat(cheat_code);

new PlayerACViolations[MAX_PLAYERS][53];
new PlayerACWarnings[MAX_PLAYERS];
new bool:PlayerACBanned[MAX_PLAYERS];

#if !defined MAX_AC_WARNINGS
    #define MAX_AC_WARNINGS 3
#endif

#if !defined AC_BAN_EXEMPT_LEVEL
    #define AC_BAN_EXEMPT_LEVEL 2
#endif

stock InitializeNexACIntegration() {
    print("[ANTICHEAT] Nex-AC integration system initialized");

}

public OnCheatDetected(playerid, ip_address[], type, code)
{
    if(type == 1) {
        printf("[NEX-AC] IP attack detected: %s (Code: #%03d)", ip_address, code);
        return 1;
    }

    if(IsPlayerNPC(playerid) || PlayerInfo[playerid][pAdmin] >= AC_BAN_EXEMPT_LEVEL ||
       PlayerACBanned[playerid]) {
        return 0;
    }

    PlayerACViolations[playerid][code]++;
    PlayerACWarnings[playerid]++;

    new cheat_name[64];
    GetCheatName(code, cheat_name);

    new string[256];
    format(string, sizeof(string), "[NEX-AC] %s (ID: %d) detected using %s (Code: #%03d) - Violation #%d",
           GetPlayerNameEx(playerid), playerid, cheat_name, code, PlayerACViolations[playerid][code]);

    foreach(new i : Player) {
        if(PlayerInfo[i][pAdmin] >= 1) {
            SendClientMessageEx(i, COLOR_LIGHTRED, string);
        }
    }

    ApplyACPunishment(playerid, code, cheat_name);

    return 0;
}

stock ApplyACPunishment(playerid, cheat_code, cheat_name[]) {
    if(IsSevereCheat(cheat_code)) {
        BanPlayerForCheat(playerid, cheat_name, cheat_code);
        return;
    }

    if(PlayerACWarnings[playerid] >= MAX_AC_WARNINGS) {
        BanPlayerForCheat(playerid, cheat_name, cheat_code);
    }
}

stock bool:IsSevereCheat(cheat_code) {
    switch(cheat_code) {
        case 0:  return true;  // AirBreak (onfoot)
        case 1:  return true;  // AirBreak (in vehicle)
        case 2:  return true;  // Teleport (onfoot)
        case 3:  return true;  // Teleport (in vehicle)
        case 4:  return true;  // Teleport (into/between vehicles)
        case 7:  return true;  // FlyHack (onfoot)
        case 8:  return true;  // FlyHack (in vehicle)
        case 9:  return true;  // SpeedHack (onfoot)
        case 10: return true;  // SpeedHack (in vehicle)
        case 12: return true;  // Health hack (onfoot)
        case 13: return true;  // Armour hack
        case 15: return true;  // Weapon hack
        case 16: return true;  // Ammo hack (add)
        case 17: return true;  // Ammo hack (infinite)
        case 18: return true;  // Special actions hack
        case 19: return true;  // GodMode from bullets (onfoot)
        case 20: return true;  // GodMode from bullets (in vehicle)
        case 21: return true;  // Invisible hack
        case 23: return true;  // Tuning hack
        case 25: return true;  // Quick turn
        case 26: return true;  // Rapid fire
        case 27: return true;  // FakeSpawn
        case 28: return true;  // FakeKill
        case 29: return true;  // Pro Aim
        case 30: return true;  // CJ run
        case 31: return true;  // CarShot
        case 33: return true;  // UnFreeze
        case 34: return true;  // AFK Ghost
        case 35: return true;  // Full Aiming
        case 36: return true;  // Fake NPC
        case 37: return true;  // Reconnect hack
        case 40: return true;  // Sandbox protection
        case 42: return true;  // Rcon hack
        case 43: return true;  // Tuning crasher
        case 44: return true;  // Invalid seat crasher
        case 45: return true;  // Dialog crasher
        case 46: return true;  // Attached object crasher
        case 47: return true;  // Weapon crasher
        case 48: return true;  // Connection flood
        case 49: return true;  // Callback flood
        case 50: return true;  // Seat change flood
        case 51: return true;  // DoS attack
        case 52: return true;  // NOP hack
    }
    return false;
}

stock GetCheatName(cheat_code, output[]) {
    switch(cheat_code) {
        case 0:  format(output, 64, "AirBreak (onfoot)");
        case 1:  format(output, 64, "AirBreak (in vehicle)");
        case 2:  format(output, 64, "Teleport (onfoot)");
        case 3:  format(output, 64, "Teleport (in vehicle)");
        case 4:  format(output, 64, "Teleport (into/between vehicles)");
        case 5:  format(output, 64, "Teleport (vehicle to player)");
        case 6:  format(output, 64, "Teleport (pickups)");
        case 7:  format(output, 64, "FlyHack (onfoot)");
        case 8:  format(output, 64, "FlyHack (in vehicle)");
        case 9:  format(output, 64, "SpeedHack (onfoot)");
        case 10: format(output, 64, "SpeedHack (in vehicle)");
        case 11: format(output, 64, "Health hack (in vehicle)");
        case 12: format(output, 64, "Health hack (onfoot)");
        case 13: format(output, 64, "Armour hack");
        case 14: format(output, 64, "Money hack");
        case 15: format(output, 64, "Weapon hack");
        case 16: format(output, 64, "Ammo hack (add)");
        case 17: format(output, 64, "Ammo hack (infinite)");
        case 18: format(output, 64, "Special actions hack");
        case 19: format(output, 64, "GodMode from bullets (onfoot)");
        case 20: format(output, 64, "GodMode from bullets (in vehicle)");
        case 21: format(output, 64, "Invisible hack");
        case 22: format(output, 64, "Lagcomp-spoof");
        case 23: format(output, 64, "Tuning hack");
        case 24: format(output, 64, "Parkour mod");
        case 25: format(output, 64, "Quick turn");
        case 26: format(output, 64, "Rapid fire");
        case 27: format(output, 64, "FakeSpawn");
        case 28: format(output, 64, "FakeKill");
        case 29: format(output, 64, "Pro Aim");
        case 30: format(output, 64, "CJ run");
        case 31: format(output, 64, "CarShot");
        case 32: format(output, 64, "CarJack");
        case 33: format(output, 64, "UnFreeze");
        case 34: format(output, 64, "AFK Ghost");
        case 35: format(output, 64, "Full Aiming");
        case 36: format(output, 64, "Fake NPC");
        case 37: format(output, 64, "Reconnect hack");
        case 38: format(output, 64, "High ping");
        case 39: format(output, 64, "Dialog hack");
        case 40: format(output, 64, "Sandbox protection");
        case 41: format(output, 64, "Invalid version");
        case 42: format(output, 64, "Rcon hack");
        case 43: format(output, 64, "Tuning crasher");
        case 44: format(output, 64, "Invalid seat crasher");
        case 45: format(output, 64, "Dialog crasher");
        case 46: format(output, 64, "Attached object crasher");
        case 47: format(output, 64, "Weapon crasher");
        case 48: format(output, 64, "Connection flood");
        case 49: format(output, 64, "Callback flood");
        case 50: format(output, 64, "Seat change flood");
        case 51: format(output, 64, "DoS attack");
        case 52: format(output, 64, "NOP hack");
        default: format(output, 64, "Unknown cheat #%d", cheat_code);
    }
}

stock BanPlayerForCheat(playerid, cheat_name[], cheat_code) {

    if(PlayerACBanned[playerid]) return;
    PlayerACBanned[playerid] = true;

    new ban_reason[128];
    format(ban_reason, sizeof(ban_reason), "Nex-AC: %s (Code: #%03d)", cheat_name, cheat_code);
    CreateBan(INVALID_PLAYER_ID, PlayerInfo[playerid][pId], playerid, PlayerInfo[playerid][pIP], ban_reason, 180, 1); // Silent ban
}

hook OnPlayerConnect(playerid) {
    for(new i = 0; i < 53; i++) {
        PlayerACViolations[playerid][i] = 0;
    }
    PlayerACWarnings[playerid] = 0;
    PlayerACBanned[playerid] = false;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    for(new i = 0; i < 53; i++) {
        PlayerACViolations[playerid][i] = 0;
    }
    PlayerACWarnings[playerid] = 0;
    PlayerACBanned[playerid] = false;
    return 1;
}