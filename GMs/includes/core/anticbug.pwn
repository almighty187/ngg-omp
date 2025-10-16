#include <YSI_Coding\y_hooks>

#pragma warning disable 213

enum E_CBUG_SHOT_INFO {
	       e_Tick,
	       e_Weapon,
	       e_HitType,
	       e_HitId,
	       e_Hits,
	 Float:e_X,
	 Float:e_Y,
	 Float:e_Z,
	 Float:e_OX,
	 Float:e_OY,
	 Float:e_OZ,
	 Float:e_HX,
	 Float:e_HY,
	 Float:e_HZ,
	 Float:e_Length,
	  bool:e_Valid
};

static bool:s_CbugGlobal = false;
static bool:s_CbugAllowed[MAX_PLAYERS] = {false, ...};
static s_CbugFroze[MAX_PLAYERS];
static s_LastShot[MAX_PLAYERS][E_CBUG_SHOT_INFO];
static bool:s_IsDying[MAX_PLAYERS] = {false, ...};

forward WC_CbugPunishment(playerid, weapon);
stock Float:AngleBetweenPoints(Float:x1, Float:y1, Float:x2, Float:y2);
stock CbugFreezeSyncPacket(playerid, bool:toggle);

hook OnPlayerConnect(playerid) {
	s_CbugAllowed[playerid] = s_CbugGlobal;
	s_CbugFroze[playerid] = 0;
	s_LastShot[playerid][e_Tick] = 0;
	s_IsDying[playerid] = false;
	return 1;
}

stock AnticbugTrackShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ) {
	new Float:fOriginX, Float:fOriginY, Float:fOriginZ, Float:fHitPosX, Float:fHitPosY, Float:fHitPosZ;
	GetPlayerLastShotVectors(playerid, fOriginX, fOriginY, fOriginZ, fHitPosX, fHitPosY, fHitPosZ);

	new tick = GetTickCount();

	s_LastShot[playerid][e_Tick] = tick;
	s_LastShot[playerid][e_Weapon] = weaponid;
	s_LastShot[playerid][e_HitType] = hittype;
	s_LastShot[playerid][e_HitId] = hitid;
	s_LastShot[playerid][e_X] = fX;
	s_LastShot[playerid][e_Y] = fY;
	s_LastShot[playerid][e_Z] = fZ;
	s_LastShot[playerid][e_OX] = fOriginX;
	s_LastShot[playerid][e_OY] = fOriginY;
	s_LastShot[playerid][e_OZ] = fOriginZ;
	s_LastShot[playerid][e_HX] = fHitPosX;
	s_LastShot[playerid][e_HY] = fHitPosY;
	s_LastShot[playerid][e_HZ] = fHitPosZ;
	s_LastShot[playerid][e_Valid] = (hittype != BULLET_HIT_TYPE_NONE);

	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	new animlib[32], animname[32];

	if ((newkeys & KEY_FIRE) && !(oldkeys & KEY_FIRE)) {
		new weaponid = GetPlayerWeapon(playerid);
		if (weaponid >= 22 && weaponid <= 38) {
			s_LastShot[playerid][e_Tick] = GetTickCount();
			s_LastShot[playerid][e_Weapon] = weaponid;
		}
	}

	if (!s_CbugAllowed[playerid] && !s_IsDying[playerid] && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {
		if (newkeys & KEY_CROUCH) {
			new tick = GetTickCount(), diff = tick - s_LastShot[playerid][e_Tick];

			if (s_LastShot[playerid][e_Tick] && diff < 1200 && !s_CbugFroze[playerid]) {
				PlayerPlaySound(playerid, 1055, 0.0, 0.0, 0.0);

				if (s_LastShot[playerid][e_Valid] && floatabs(s_LastShot[playerid][e_HX]) > 1.0 && floatabs(s_LastShot[playerid][e_HY]) > 1.0) {
					SetPlayerFacingAngle(playerid, AngleBetweenPoints(
						s_LastShot[playerid][e_HX],
						s_LastShot[playerid][e_HY],
						s_LastShot[playerid][e_OX],
						s_LastShot[playerid][e_OY]
					));
				}

				new w, a;
				GetPlayerWeaponData(playerid, 0, w, a);

				animlib = "PED", animname = "IDLE_stance";
				ClearAnimations(playerid, 1);
				ApplyAnimation(playerid, animlib, animname, 4.1, true, false, false, false, 0, 1);
				CbugFreezeSyncPacket(playerid, true);
				SetPlayerArmedWeapon(playerid, w);
				SetTimerEx("WC_CbugPunishment", 600, false, "ii", playerid, GetPlayerWeapon(playerid));

				s_CbugFroze[playerid] = tick;
			}
		}
	}

	return 1;
}

public WC_CbugPunishment(playerid, weapon) {
	if(!IsPlayerConnected(playerid)) return 0;

	CbugFreezeSyncPacket(playerid, false);
	SetPlayerArmedWeapon(playerid, weapon);

	if (!s_IsDying[playerid]) {
		ClearAnimations(playerid, 1);
	}

	s_CbugFroze[playerid] = 0;

	return 1;
}

stock Float:AngleBetweenPoints(Float:x1, Float:y1, Float:x2, Float:y2) {
	new Float:angle = atan2(y2 - y1, x2 - x1) - 90.0;
	if (angle < 0.0) angle += 360.0;
	return angle;
}

stock CbugFreezeSyncPacket(playerid, bool:toggle) {
	if (toggle) {
		SetPVarInt(playerid, "CbugFrozen", 1);
		TogglePlayerControllable(playerid, 0);
	} else {
		DeletePVar(playerid, "CbugFrozen");
		TogglePlayerControllable(playerid, 1);
	}
	return 1;
}

stock SetCbugAllowed(bool:enabled, playerid = INVALID_PLAYER_ID) {
	if (playerid == INVALID_PLAYER_ID) {
		s_CbugGlobal = enabled;
		foreach (new i : Player) {
			s_CbugAllowed[i] = enabled;
		}
	} else {
		s_CbugAllowed[playerid] = enabled;
	}
	return enabled;
}

stock AC_SetPlayerPos(playerid, Float:x, Float:y, Float:z) {
	return acc_SetPlayerPos(playerid, x, y, z);
}

#if defined _ALS_SetPlayerPos
	#undef SetPlayerPos
#else
	#define _ALS_SetPlayerPos
#endif
#define SetPlayerPos AC_SetPlayerPos

stock AC_SetPlayerPosFindZ(playerid, Float:x, Float:y, Float:z) {
	return acc_SetPlayerPosFindZ(playerid, x, y, z);
}

#if defined _ALS_SetPlayerPosFindZ
	#undef SetPlayerPosFindZ
#else
	#define _ALS_SetPlayerPosFindZ
#endif
#define SetPlayerPosFindZ AC_SetPlayerPosFindZ