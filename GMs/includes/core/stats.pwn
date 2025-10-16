#if defined _INC_stats
	#endinput
#endif
#define _INC_stats

// An attempt at the original code
/* ShowStats(playerid,targetid)
{
	if(IsPlayerConnected(targetid)) {
		SendClientMessageEx(playerid, COLOR_GREEN,"___________________________________________________________________________________________________");
		new cash =  GetPlayerCash(targetid);
		new sext[16], std[20], employer[64], rank[64], division[64], jtext2[20], jtext[20], jtext3[20], pnumber[20], facfam[20], nation[24], badge[32], biz[128];
		if(PlayerInfo[targetid][pPnumber] == 0) pnumber = "None"; else format(pnumber, sizeof(pnumber), "%d", PlayerInfo[targetid][pPnumber]);
		if(PlayerInfo[targetid][pSex] == 1) { sext = "Male"; } else { sext = "Female"; }
		switch(GetPVarInt(targetid, "STD"))
		{
			case 1: std = "Chlamydia";
			case 2: std = "Gonorrhea";
			case 3: std = "Syphilis";
			default: std = "None";
		}
		// Get nation
		switch(PlayerInfo[targetid][pNation])
		{
			case 0: nation = "San Andreas";
			case 1: nation = "New Robada";
			case 2: nation = "None";
			default: nation = "None";
		}
		// Get group/faction info
		if(PlayerInfo[targetid][pMember] != INVALID_GROUP_ID)
		{
			GetPlayerGroupInfo(targetid, rank, division, employer);
			facfam = "Group";
			if(arrGroupData[PlayerInfo[targetid][pMember]][g_iGroupType] != GROUP_TYPE_CRIMINAL) format(badge, sizeof(badge), "%s", PlayerInfo[targetid][pBadge]);
			else format(badge, sizeof(badge), "N/A");
		}
		else
		{
			format(employer, sizeof(employer), "None");
			format(rank, sizeof(rank), "None");
			format(division, sizeof(division), "None");
			format(badge, sizeof(badge), "N/A");
			facfam = "Group";
		}
		// Get business info
		if(PlayerInfo[targetid][pBusiness] != INVALID_BUSINESS_ID) format(biz, sizeof(biz), "%s (Rank: %s)", Businesses[PlayerInfo[targetid][pBusiness]][bName], GetBusinessRankName(PlayerInfo[targetid][pBusinessRank]));
		else format(biz, sizeof(biz), "None");
		switch(PlayerInfo[targetid][pJob])
		{
			case 1: jtext = "Detective";
			case 2: jtext = "Lawyer";
			case 3: jtext = "Whore";
			case 4: jtext = "Drugs Dealer";
			//case 5: jtext = "Car Jacker";
			case 6: jtext = "News Reporter";
			case 7: jtext = "Car Mechanic";
			case 8: jtext = "Bodyguard";
			case 9: jtext = "Arms Dealer";
			case 10: jtext = "Car Dealer";
			case 12: jtext = "Boxer";
			case 14: jtext = "Drug Smuggler";
			case 15: jtext = "Paper Boy";
			case 16: jtext = "Trucker";
			case 17: jtext = "Taxi Driver";
			case 18: jtext = "Craftsman";
			case 19: jtext = "Bartender";
			case 20: jtext = "Trucker";
			case 21: jtext = "Pizza Boy";
			default: jtext = "None";
		}
		switch(PlayerInfo[targetid][pJob2])
		{
			case 1: jtext2 = "Detective";
			case 2: jtext2 = "Lawyer";
			case 3: jtext2 = "Whore";
			case 4: jtext2 = "Drugs Dealer";
			//case 5: jtext2 = "Car Jacker";
			case 6: jtext2 = "News Reporter";
			case 7: jtext2 = "Car Mechanic";
			case 8: jtext2 = "Bodyguard";
			case 9: jtext2 = "Arms Dealer";
			case 10: jtext2 = "Car Dealer";
			case 12: jtext2 = "Boxer";
			case 14: jtext2 = "Drug Smuggler";
			case 15: jtext2 = "Paper Boy";
			case 16: jtext2 = "Trucker";
			case 17: jtext2 = "Taxi Driver";
			case 18: jtext2 = "Craftsman";
			case 19: jtext2 = "Bartender";
			case 20: jtext2 = "Trucker";
			case 21: jtext2 = "Pizza Boy";
			default: jtext2 = "None";
		}
		switch(PlayerInfo[targetid][pJob3])
		{
			case 1: jtext3 = "Detective";
			case 2: jtext3 = "Lawyer";
			case 3: jtext3 = "Whore";
			case 4: jtext3 = "Drugs Dealer";
			//case 5: jtext3 = "Car Jacker";
			case 6: jtext3 = "News Reporter";
			case 7: jtext3 = "Car Mechanic";
			case 8: jtext3 = "Bodyguard";
			case 9: jtext3 = "Arms Dealer";
			case 10: jtext3 = "Car Dealer";
			case 12: jtext3 = "Boxer";
			case 14: jtext3 = "Drug Smuggler";
			case 15: jtext3 = "Paper Boy";
			case 16: jtext3 = "Trucker";
			case 17: jtext3 = "Taxi Driver";
			case 18: jtext3 = "Craftsman";
			case 19: jtext3 = "Bartender";
			case 20: jtext3 = "Trucker";
			case 21: jtext3 = "Pizza Boy";
			default: jtext3 = "None";
		}
		new jlevel, jlevel2, jlevel3;
		switch(PlayerInfo[targetid][pJob])
		{
			case 1:
			{
					new skilllevel = PlayerInfo[targetid][pDetSkill];
					if(skilllevel >= 0 && skilllevel <= 50) { jlevel = 1; }
					else if(skilllevel >= 51 && skilllevel <= 100) { jlevel = 2; }
					else if(skilllevel >= 101 && skilllevel <= 200) { jlevel = 3; }
					else if(skilllevel >= 201 && skilllevel <= 400) { jlevel = 4; }
					else if(skilllevel >= 401) { jlevel = 5; }
			}
			case 2:
			{
					new skilllevel = PlayerInfo[targetid][pLawSkill];
					if(skilllevel >= 0 && skilllevel <= 50) { jlevel = 1; }
					else if(skilllevel >= 51 && skilllevel <= 100) { jlevel = 2; }
					else if(skilllevel >= 101 && skilllevel <= 200) { jlevel = 3; }
					else if(skilllevel >= 201 && skilllevel <= 400) { jlevel = 4; }
					else if(skilllevel >= 401) { jlevel = 5; }
			}
			case 3:
			{
					new skilllevel = PlayerInfo[targetid][pSexSkill];
					if(skilllevel >= 0 && skilllevel <= 50) { jlevel = 1; }
					else if(skilllevel >= 51 && skilllevel <= 100) { jlevel = 2; }
					else if(skilllevel >= 101 && skilllevel <= 200) { jlevel = 3; }
					else if(skilllevel >= 201 && skilllevel <= 400) { jlevel = 4; }
					else if(skilllevel >= 401) { jlevel = 5; }
			}
			case 4:
			{
					new skilllevel = PlayerInfo[targetid][pDrugSmuggler];
					if(skilllevel >= 0 && skilllevel <= 50) { jlevel = 1; }
					else if(skilllevel >= 51 && skilllevel <= 100) { jlevel = 2; }
					else if(skilllevel >= 101 && skilllevel <= 200) { jlevel = 3; }
					else if(skilllevel >= 201 && skilllevel <= 400) { jlevel = 4; }
					else if(skilllevel >= 401) { jlevel = 5; }
			}
			  case 7:
			{
					new skilllevel = PlayerInfo[targetid][pMechSkill];
					if(skilllevel >= 0 && skilllevel <= 50) { jlevel = 1; }
					else if(skilllevel >= 51 && skilllevel <= 100) { jlevel = 2; }
					else if(skilllevel >= 101 && skilllevel <= 200) { jlevel = 3; }
					else if(skilllevel >= 201 && skilllevel <= 400) { jlevel = 4; }
					else if(skilllevel >= 401) { jlevel = 5; }
			}
			case 9:
			{
					new skilllevel = PlayerInfo[targetid][pArmsSkill];
					if(skilllevel >= 0 && skilllevel < 50) { jlevel = 1; }
					else if(skilllevel >= 50 && skilllevel < 100) { jlevel = 2; }
					else if(skilllevel >= 100 && skilllevel < 200) { jlevel = 3; }
					else if(skilllevel >= 200 && skilllevel < 400) { jlevel = 4; }
					else if(skilllevel >= 400) { jlevel = 5; }
			}
			case 12:
			{
					new skilllevel = PlayerInfo[targetid][pBoxSkill];
					if(skilllevel >= 0 && skilllevel <= 50) { jlevel = 1; }
					else if(skilllevel >= 51 && skilllevel <= 100) { jlevel = 2; }
					else if(skilllevel >= 101 && skilllevel <= 200) { jlevel = 3; }
					else if(skilllevel >= 201 && skilllevel <= 400) { jlevel = 4; }
					else if(skilllevel >= 401) { jlevel = 5; }
			}
			case 14: jlevel = 1;
			case 20:
			{
					new skilllevel = PlayerInfo[targetid][pTruckSkill];
					if(skilllevel >= 0 && skilllevel <= 50) { jlevel = 1; }
					else if(skilllevel >= 51 && skilllevel <= 100) { jlevel = 2; }
					else if(skilllevel >= 101 && skilllevel <= 200) { jlevel = 3; }
					else if(skilllevel >= 201 && skilllevel <= 400) { jlevel = 4; }
					else if(skilllevel >= 401) { jlevel = 5; }
			}
			default: jlevel = 0;
		}
		switch(PlayerInfo[targetid][pJob2])
		{
			case 1:
			{
					new skilllevel = PlayerInfo[targetid][pDetSkill];
					if(skilllevel >= 0 && skilllevel <= 50) { jlevel2 = 1; }
					else if(skilllevel >= 51 && skilllevel <= 100) { jlevel2 = 2; }
					else if(skilllevel >= 101 && skilllevel <= 200) { jlevel2 = 3; }
					else if(skilllevel >= 201 && skilllevel <= 400) { jlevel2 = 4; }
					else if(skilllevel >= 401) { jlevel2 = 5; }
			}
			case 2:
			{
					new skilllevel = PlayerInfo[targetid][pLawSkill];
					if(skilllevel >= 0 && skilllevel <= 50) { jlevel2 = 1; }
					else if(skilllevel >= 51 && skilllevel <= 100) { jlevel2 = 2; }
					else if(skilllevel >= 101 && skilllevel <= 200) { jlevel2 = 3; }
					else if(skilllevel >= 201 && skilllevel <= 400) { jlevel2 = 4; }
					else if(skilllevel >= 401) { jlevel2 = 5; }
			}
			case 3:
			{
					new skilllevel = PlayerInfo[targetid][pSexSkill];
					if(skilllevel >= 0 && skilllevel <= 50) { jlevel2 = 1; }
					else if(skilllevel >= 51 && skilllevel <= 100) { jlevel2 = 2; }
					else if(skilllevel >= 101 && skilllevel <= 200) { jlevel2 = 3; }
					else if(skilllevel >= 201 && skilllevel <= 400) { jlevel2 = 4; }
					else if(skilllevel >= 401) { jlevel2 = 5; }
			}
			case 4:
			{
					new skilllevel = PlayerInfo[targetid][pDrugSmuggler];
					if(skilllevel >= 0 && skilllevel <= 50) { jlevel2 = 1; }
					else if(skilllevel >= 51 && skilllevel <= 100) { jlevel2 = 2; }
					else if(skilllevel >= 101 && skilllevel <= 200) { jlevel2 = 3; }
					else if(skilllevel >= 201 && skilllevel <= 400) { jlevel2 = 4; }
					else if(skilllevel >= 401) { jlevel2 = 5; }
			}
			  case 7:
			{
					new skilllevel = PlayerInfo[targetid][pMechSkill];
					if(skilllevel >= 0 && skilllevel <= 50) { jlevel2 = 1; }
					else if(skilllevel >= 51 && skilllevel <= 100) { jlevel2 = 2; }
					else if(skilllevel >= 101 && skilllevel <= 200) { jlevel2 = 3; }
					else if(skilllevel >= 201 && skilllevel <= 400) { jlevel2 = 4; }
					else if(skilllevel >= 401) { jlevel2 = 5; }
			}
			case 9:
			{
					new skilllevel = PlayerInfo[targetid][pArmsSkill];
					if(skilllevel >= 0 && skilllevel < 50) { jlevel2 = 1; }
					else if(skilllevel >= 50 && skilllevel < 100) { jlevel2 = 2; }
					else if(skilllevel >= 100 && skilllevel < 200) { jlevel2 = 3; }
					else if(skilllevel >= 200 && skilllevel < 400) { jlevel2 = 4; }
					else if(skilllevel >= 400) { jlevel2 = 5; }
			}
			case 12:
			{
					new skilllevel = PlayerInfo[targetid][pBoxSkill];
					if(skilllevel >= 0 && skilllevel <= 50) { jlevel2 = 1; }
					else if(skilllevel >= 51 && skilllevel <= 100) { jlevel2 = 2; }
					else if(skilllevel >= 101 && skilllevel <= 200) { jlevel2 = 3; }
					else if(skilllevel >= 201 && skilllevel <= 400) { jlevel2 = 4; }
					else if(skilllevel >= 401) { jlevel2 = 5; }
			}
			case 14: jlevel2 = 1;
			case 20:
			{
					new skilllevel = PlayerInfo[targetid][pTruckSkill];
					if(skilllevel >= 0 && skilllevel <= 50) { jlevel2 = 1; }
					else if(skilllevel >= 51 && skilllevel <= 100) { jlevel2 = 2; }
					else if(skilllevel >= 101 && skilllevel <= 200) { jlevel2 = 3; }
					else if(skilllevel >= 201 && skilllevel <= 400) { jlevel2 = 4; }
					else if(skilllevel >= 401) { jlevel2 = 5; }
			}
			default: jlevel2 = 0;
		}
		switch(PlayerInfo[targetid][pJob3])
		{
			case 1:
			{
					new skilllevel = PlayerInfo[targetid][pDetSkill];
					if(skilllevel >= 0 && skilllevel <= 50) { jlevel3 = 1; }
					else if(skilllevel >= 51 && skilllevel <= 100) { jlevel3 = 2; }
					else if(skilllevel >= 101 && skilllevel <= 200) { jlevel3 = 3; }
					else if(skilllevel >= 201 && skilllevel <= 400) { jlevel3 = 4; }
					else if(skilllevel >= 401) { jlevel3 = 5; }
			}
			case 2:
			{
					new skilllevel = PlayerInfo[targetid][pLawSkill];
					if(skilllevel >= 0 && skilllevel <= 50) { jlevel3 = 1; }
					else if(skilllevel >= 51 && skilllevel <= 100) { jlevel3 = 2; }
					else if(skilllevel >= 101 && skilllevel <= 200) { jlevel3 = 3; }
					else if(skilllevel >= 201 && skilllevel <= 400) { jlevel3 = 4; }
					else if(skilllevel >= 401) { jlevel3 = 5; }
			}
			case 3:
			{
					new skilllevel = PlayerInfo[targetid][pSexSkill];
					if(skilllevel >= 0 && skilllevel <= 50) { jlevel3 = 1; }
					else if(skilllevel >= 51 && skilllevel <= 100) { jlevel3 = 2; }
					else if(skilllevel >= 101 && skilllevel <= 200) { jlevel3 = 3; }
					else if(skilllevel >= 201 && skilllevel <= 400) { jlevel3 = 4; }
					else if(skilllevel >= 401) { jlevel3 = 5; }
			}
			case 4:
			{
					new skilllevel = PlayerInfo[targetid][pDrugSmuggler];
					if(skilllevel >= 0 && skilllevel <= 50) { jlevel3 = 1; }
					else if(skilllevel >= 51 && skilllevel <= 100) { jlevel3 = 2; }
					else if(skilllevel >= 101 && skilllevel <= 200) { jlevel3 = 3; }
					else if(skilllevel >= 201 && skilllevel <= 400) { jlevel3 = 4; }
					else if(skilllevel >= 401) { jlevel3 = 5; }
			}
			  case 7:
			{
					new skilllevel = PlayerInfo[targetid][pMechSkill];
					if(skilllevel >= 0 && skilllevel <= 50) { jlevel3 = 1; }
					else if(skilllevel >= 51 && skilllevel <= 100) { jlevel3 = 2; }
					else if(skilllevel >= 101 && skilllevel <= 200) { jlevel3 = 3; }
					else if(skilllevel >= 201 && skilllevel <= 400) { jlevel3 = 4; }
					else if(skilllevel >= 401) { jlevel3 = 5; }
			}
			case 9:
			{
					new skilllevel = PlayerInfo[targetid][pArmsSkill];
					if(skilllevel >= 0 && skilllevel < 50) { jlevel3 = 1; }
					else if(skilllevel >= 50 && skilllevel < 100) { jlevel3 = 2; }
					else if(skilllevel >= 100 && skilllevel < 200) { jlevel3 = 3; }
					else if(skilllevel >= 200 && skilllevel < 400) { jlevel3 = 4; }
					else if(skilllevel >= 400) { jlevel3 = 5; }
			}
			case 12:
			{
					new skilllevel = PlayerInfo[targetid][pBoxSkill];
					if(skilllevel >= 0 && skilllevel <= 50) { jlevel3 = 1; }
					else if(skilllevel >= 51 && skilllevel <= 100) { jlevel3 = 2; }
					else if(skilllevel >= 101 && skilllevel <= 200) { jlevel3 = 3; }
					else if(skilllevel >= 201 && skilllevel <= 400) { jlevel3 = 4; }
					else if(skilllevel >= 401) { jlevel3 = 5; }
			}
			case 14: jlevel3 = 1;
			case 20:
			{
					new skilllevel = PlayerInfo[targetid][pTruckSkill];
					if(skilllevel >= 0 && skilllevel <= 50) { jlevel3 = 1; }
					else if(skilllevel >= 51 && skilllevel <= 100) { jlevel3 = 2; }
					else if(skilllevel >= 101 && skilllevel <= 200) { jlevel3 = 3; }
					else if(skilllevel >= 201 && skilllevel <= 400) { jlevel3 = 4; }
					else if(skilllevel >= 401) { jlevel3 = 5; }
			}
			default: jlevel3 = 0;
		}
		new drank[20];
		switch(PlayerInfo[targetid][pDonateRank])
		{
			case 1: drank = "Bronze";
			case 2: drank = "Silver";
			case 3: drank = "Gold";
			case 4: drank = "Platinum";
			case 5: drank = "Moderator";
			default: drank = "None";
		}
		new insur[20];
		switch(PlayerInfo[targetid][pInsurance])
		{
			case 1: insur = "County General";
			case 2: insur = "All Saints";
			case 3: insur = "Red County";
			case 4: insur = "Fort Carson";
			case 5: insur = "San Fierro";
			case 6: insur = "Club VIP";
			case 7: insur = "Home care";
			case 9: insur = "El Quabrados";
			case 10: insur = "Demorgan";
			default: insur = "None";
		}
		new married[MAX_PLAYER_NAME];
		format(married, sizeof(married), "%s", PlayerInfo[targetid][pMarriedName]);
		new upgradep = PlayerInfo[targetid][gPupgrade];
		new ptime = PlayerInfo[targetid][pConnectHours];
		new bigfish = PlayerInfo[targetid][pBiggestFish];
		new crimes = PlayerInfo[targetid][pCrimes];
		new arrests = PlayerInfo[targetid][pArrested];
		//new mats = PlayerInfo[targetid][pMats];
		new wanted = PlayerInfo[targetid][pWantedLevel];
		new level = PlayerInfo[targetid][pLevel];
		new exp = PlayerInfo[targetid][pExp];
		new account = PlayerInfo[targetid][pAccount];
		new nxtlevel = PlayerInfo[targetid][pLevel]+1;
		new expamount = nxtlevel*4;
		new costlevel = nxtlevel*25000;//10k for testing purposes
		new housekey = PlayerInfo[targetid][pPhousekey];
		new housekey2 = PlayerInfo[targetid][pPhousekey2];
		new rentkey = PlayerInfo[targetid][pRenting];
		new radiofreq = PlayerInfo[targetid][pRadioFreq];
		new intir = GetPlayerInterior(targetid);
		new tokens = PlayerInfo[targetid][pTokens];
		new ptokens = PlayerInfo[targetid][pPaintTokens];
		//new checks = PlayerInfo[targetid][pChecks];
		new Float:shealth = PlayerInfo[targetid][pSHealth];
		new Float:health, Float:armor;
		//new packages = GetPVarInt(targetid, "Packages");
		//new crates = PlayerInfo[targetid][pCrates];
		new //rope = PlayerInfo[targetid][pRope],
			//cigars = PlayerInfo[targetid][pCigar],
			//sprunk = PlayerInfo[targetid][pSprunk],
			//spray = PlayerInfo[targetid][pSpraycan],
			realvw = GetPlayerVirtualWorld(targetid),
			vw = PlayerInfo[targetid][pVW],
			warns = PlayerInfo[targetid][pWarns],
			jailt = PlayerInfo[targetid][pJailTime],
			wjailt = PlayerInfo[targetid][pBeingSentenced];
		GetPlayerHealth(targetid,health);
		GetPlayerArmour(targetid,armor);
		new Float:px,Float:py,Float:pz;
		GetPlayerPos(targetid, px, py, pz);
		new zone[MAX_ZONE_NAME];
		GetPlayer3DZone(targetid, zone, sizeof(zone));
		new fitness = PlayerInfo[targetid][pFitness];
		new dedicatedhours = PlayerInfo[targetid][pDedicatedHours];
		new totalwealth;
		new name[MAX_PLAYER_NAME];
		GetPlayerName(targetid, name, sizeof(name));
		new nmutes = PlayerInfo[targetid][pNMuteTotal];
		new admutes = PlayerInfo[targetid][pADMuteTotal];
		totalwealth = account + cash;
		if(PlayerInfo[targetid][pPhousekey] != INVALID_HOUSE_ID && strcmp(name, HouseInfo[PlayerInfo[targetid][pPhousekey]][hOwnerName], true) == 0) totalwealth += HouseInfo[PlayerInfo[targetid][pPhousekey]][hSafeMoney];
		if(PlayerInfo[targetid][pPhousekey2] != INVALID_HOUSE_ID && strcmp(name, HouseInfo[PlayerInfo[targetid][pPhousekey2]][hOwnerName], true) == 0) totalwealth += HouseInfo[PlayerInfo[targetid][pPhousekey2]][hSafeMoney];
		// Get staff ranks and special titles
		new staffrank[64], famedrank[64], dprank[64], svipmod[40];
		if(PlayerInfo[targetid][pHelper] > 0 || PlayerInfo[targetid][pWatchdog] > 0 || PlayerInfo[targetid][pSEC] > 0 || PlayerInfo[targetid][pAdmin] == 1 || (PlayerInfo[targetid][pAdmin] > 1 && PlayerInfo[playerid][pAdmin] <= PlayerInfo[targetid][pAdmin])) format(staffrank, sizeof(staffrank), "%s", GetStaffRank(targetid));
		else staffrank = "None";
		// Get famed rank
		switch(PlayerInfo[targetid][pFamed])
		{
			case 1: famedrank = "Old-School";
			case 2: famedrank = "Chartered Old-School";
			case 3: famedrank = "Famed";
			case 4: famedrank = "Famed Commissioner";
			case 5: famedrank = "Famed Moderator";
			case 6: famedrank = "Famed Vice-Chairman";
			case 7: famedrank = "Famed Chairman";
			default: famedrank = "None";
		}
		// Get dedicated player rank
		switch(PlayerInfo[targetid][pDedicatedPlayer])
		{
			case 1: dprank = "Tier 1 Dedicated Player";
			case 2: dprank = "Tier 2 Dedicated Player";
			case 3: dprank = "Tier 3 Dedicated Player";
			case 4: dprank = "Dedicated Moderator";
			default: dprank = "None";
		}
		// Get VIP Moderator rank
		switch(PlayerInfo[targetid][pVIPMod])
		{
			case 1: svipmod = "VIP Moderator";
			case 2: svipmod = "Senior VIP Moderator";
			default: svipmod = "None";
		}
		new coordsstring[256];
		// Display special ranks (if any)
		if(strcmp(staffrank, "None", true) != 0 || strcmp(famedrank, "None", true) != 0 || strcmp(dprank, "None", true) != 0 || strcmp(svipmod, "None", true) != 0)
		{
			format(coordsstring, sizeof(coordsstring), "Staff: %s | Famed: %s | Dedicated: %s | VIP Mod: %s", staffrank, famedrank, dprank, svipmod);
			SendClientMessageEx(playerid, COLOR_WHITE, coordsstring);
		}
		// Basic info line
		format(coordsstring, sizeof(coordsstring),"%s - Level %d | %s | DOB: %s | Nation: %s",GetPlayerNameEx(targetid), level, sext, PlayerInfo[targetid][pBirthDate], nation);
		SendClientMessageEx(playerid, COLOR_WHITE,coordsstring);
		// Location, health, armor
		format(coordsstring, sizeof(coordsstring), "Location: %s (%.2f, %.2f, %.2f) | Health: %.1f | Armor: %.1f", zone, px, py, pz, health, armor);
		SendClientMessageEx(playerid, COLOR_WHITE,coordsstring);
		// Wealth and time info
		format(coordsstring, sizeof(coordsstring), "Total wealth: $%d | Cash: $%d | Bank: $%d | Playing hours: %d | Dedicated hours: %d", totalwealth, cash, account, ptime, dedicatedhours);
		SendClientMessageEx(playerid, COLOR_WHITE,coordsstring);
		// Experience and upgrade info
		format(coordsstring, sizeof(coordsstring), "Upgrade points: %d | Fitness: %d | Spawn armor: %.0f | Next level: %d/%d hours ($%d)", upgradep, fitness, shealth, exp, expamount, costlevel);
		SendClientMessageEx(playerid, COLOR_WHITE,coordsstring);
		// Group/faction and business info
		format(coordsstring, sizeof(coordsstring), "%s: %s | Rank: %s (%d) | Division: %s | Badge: %s | Business: %s", facfam, employer, rank, PlayerInfo[targetid][pRank], division, badge, biz);
		SendClientMessageEx(playerid, COLOR_WHITE,coordsstring);
		// Jobs info
		format(coordsstring, sizeof(coordsstring), "Job: %s (level: %d) | Job 2: %s (level: %d) | Job 3: %s (level: %d)", jtext,jlevel,jtext2, jlevel2, jtext3, jlevel3);
		SendClientMessageEx(playerid, COLOR_WHITE,coordsstring);
		// Personal info
		format(coordsstring, sizeof(coordsstring), "Married to: %s | Phone: %s | Biggest fish: %d | Radio freq: %d khz", married, pnumber, bigfish, radiofreq);
		SendClientMessageEx(playerid, COLOR_WHITE,coordsstring);
		// Criminal record
		format(coordsstring, sizeof(coordsstring), "Crimes: %d | Arrests: %d | Wanted level: %d | Insurance: %s | STD: %s",crimes,arrests, wanted, insur, std);
		SendClientMessageEx(playerid, COLOR_WHITE,coordsstring);
		// VIP and tokens
		format(coordsstring, sizeof(coordsstring), "VIP: %s | VIP tokens: %d | Paintball tokens: %d | EXP Tokens: %d | EXP Hours: %d",drank, tokens, ptokens, PlayerInfo[targetid][pEXPToken], PlayerInfo[targetid][pDoubleEXP]);
		SendClientMessageEx(playerid, COLOR_WHITE,coordsstring);
		// Account punishments and restrictions
		format(coordsstring, sizeof(coordsstring), "Warnings: %d | ADMutes: %d | NMutes: %d | RMutes: %d | Weapons Restricted: %d | Gang Warns: %d", warns, admutes, nmutes, PlayerInfo[targetid][pRMutedTotal],PlayerInfo[targetid][pWRestricted], PlayerInfo[targetid][pGangWarn]);
		SendClientMessageEx(playerid, COLOR_WHITE,coordsstring);
		if (PlayerInfo[playerid][pAdmin] >= 2)
		{
			format(coordsstring, sizeof(coordsstring), "House: %d | House 2: %d | Renting: %d | Int: %d | VW: %d | Real VW: %d | Jail: %d sec | WJail: %d sec | VIPM: %i | GVip: %i", housekey,housekey2,rentkey,intir,vw,realvw,jailt,wjailt, PlayerInfo[targetid][pVIPM], PlayerInfo[targetid][pGVip]);
			SendClientMessageEx(playerid, COLOR_LIGHTRED,coordsstring);
			format(coordsstring, sizeof(coordsstring), "Reward Hours: %.2f | Computer Drawing: %d | Gift Box Tokens: %d", PlayerInfo[targetid][pRewardHours],PlayerInfo[targetid][pRewardDrawChance],PlayerInfo[targetid][pGoldBoxTokens]);
			SendClientMessageEx(playerid, COLOR_LIGHTRED,coordsstring);
		}
		if (PlayerInfo[playerid][pAdmin] >= 1337)
		{
			if(PlayerInfo[targetid][pAdmin] >= 2 && PlayerInfo[playerid][pAdmin] >= 2)
			{
				format(coordsstring, sizeof(coordsstring), "Accepted reports: %d | Trashed reports: %d", PlayerInfo[targetid][pAcceptReport], PlayerInfo[targetid][pTrashReport]);
				SendClientMessageEx(playerid, COLOR_LIGHTRED,coordsstring);
			}
			if(PlayerInfo[targetid][pHelper] >= 2 && PlayerInfo[playerid][pAdmin] >= 2)
			{
				format(coordsstring, sizeof(coordsstring), "Hours on duty: %d | Accepted help requests: %d", PlayerInfo[targetid][pDutyHours], PlayerInfo[targetid][pAcceptedHelp]);
				SendClientMessageEx(playerid, COLOR_LIGHTRED,coordsstring);
			}
		}
		SendClientMessageEx(playerid, COLOR_GREEN,"___________________________________________________________________________________________________");
	}
	return 1;
}*/

ShowStats(playerid,targetid)
{
	if(IsPlayerConnected(targetid))
	{
		new resultline[1024], header[65], org[128], employer[GROUP_MAX_NAME_LEN], rank[GROUP_MAX_RANK_LEN], division[GROUP_MAX_DIV_LEN];
		new sext[16], std[20], nation[24], biz[128];
		if(PlayerInfo[targetid][pSex] == 1) { sext = "Male"; } else { sext = "Female"; }
		switch(GetPVarInt(targetid, "STD"))
		{
		    case 1: std = "Chlamydia";
		    case 2: std = "Gonorrhea";
		    case 3: std = "Syphilis";
		    default: std = "None";
		}
		if(PlayerInfo[targetid][pMember] != INVALID_GROUP_ID)
		{
			GetPlayerGroupInfo(targetid, rank, division, employer);
			format(org, sizeof(org), "Group: %s (%d)\nRank: %s (%d)\nDivision: %s (%d)\n", employer, PlayerInfo[targetid][pMember], rank, PlayerInfo[targetid][pRank], division, PlayerInfo[targetid][pDivision]);
			if(arrGroupData[PlayerInfo[targetid][pMember]][g_iGroupType] != GROUP_TYPE_CRIMINAL) format(org, sizeof(org), "%sBadge Number: %s\n", org, PlayerInfo[targetid][pBadge]);
		}
		else format(org, sizeof(org), "");
		if(PlayerInfo[targetid][pBusiness] != INVALID_BUSINESS_ID) format(biz, sizeof(biz), "Business: %s (%d)\nRank: %s (%d)\n", Businesses[PlayerInfo[targetid][pBusiness]][bName], PlayerInfo[targetid][pBusiness], GetBusinessRankName(PlayerInfo[targetid][pBusinessRank]), PlayerInfo[targetid][pBusinessRank]);
		else format(biz, sizeof(biz), "");
		switch(PlayerInfo[targetid][pNation])
		{
			case 0: nation = "San Andreas";
			case 1: nation = "New Robada";
			case 2: nation = "None";
		}
		new insur[32];
		insur = GetHospitalName(PlayerInfo[targetid][pInsurance]);

		new staffrank[64];
		if(PlayerInfo[targetid][pHelper] > 0 || PlayerInfo[targetid][pWatchdog] > 0 || PlayerInfo[targetid][pSEC] > 0 || PlayerInfo[targetid][pAdmin] == 1 || (PlayerInfo[targetid][pAdmin] > 1 && PlayerInfo[playerid][pAdmin] <= PlayerInfo[targetid][pAdmin])) format(staffrank, sizeof(staffrank), "%s", GetStaffRank(targetid));
		else staffrank = "";
		new drank[64];
		if(PlayerInfo[targetid][pDonateRank] > 0)
		{
			switch(PlayerInfo[targetid][pDonateRank])
			{
				case 1: drank = "{800080}Bronze VIP{FFFFFF}\n";
				case 2: drank = "{800080}Silver VIP{FFFFFF}\n";
				case 3: drank = "{FFD700}Gold VIP{FFFFFF}\n";
				case 4: drank = "{E5E4E2}Platinum VIP{FFFFFF}\n";
			}
		}
		new svipmod[40];
		if(PlayerInfo[targetid][pVIPMod])
		{
			switch(PlayerInfo[targetid][pVIPMod])
			{
				case 1: svipmod = "{800080}VIP Moderator{FFFFFF}\n";
				case 2: svipmod = "{800080}Senior VIP Moderator{FFFFFF}\n";
			}
		}
		new famedrank[64];
		if(PlayerInfo[targetid][pFamed] > 0)
		{
			switch(PlayerInfo[targetid][pFamed])
			{
				case 1: famedrank = "{228B22}Old-School{FFFFFF}\n";
				case 2: famedrank = "{FF7F00}Chartered Old-School{FFFFFF}\n";
				case 3: famedrank = "{ADFF2F}Famed{FFFFFF}\n";
				case 4: famedrank = "{8F00FF}Famed Commissioner{FFFFFF}\n";
				case 5: famedrank = "{8F00FF}Famed Moderator{FFFFFF}\n";
				case 6: famedrank = "{8F00FF}Famed Vice-Chairman{FFFFFF}\n";
				case 7: famedrank = "{8F00FF}Famed Chairman{FFFFFF}\n";
			}
		}
		new dprank[64];
		if(PlayerInfo[targetid][pDedicatedPlayer] > 0)
		{
			switch(PlayerInfo[targetid][pDedicatedPlayer])
			{
				case 1: dprank = "{336600}Tier 1 Dedicated Player{FFFFFF}\n";
				case 2: dprank = "{336600}Tier 2 Dedicated Player{FFFFFF}\n";
				case 3: dprank = "{336600}Tier 3 Dedicated Player{FFFFFF}\n";
				case 4: dprank = "{336600}Dedicated Moderator{FFFFFF}\n";
			}
		}
		if(PlayerInfo[targetid][pMarriedID] == -1) format(PlayerInfo[targetid][pMarriedName], MAX_PLAYER_NAME, "Nobody");
		new nxtlevel = PlayerInfo[targetid][pLevel]+1;
		new expamount = nxtlevel*4;
		new Float:health, Float:armor;
		GetHealth(targetid, health);
		GetArmour(targetid, armor);
		new Float:px,Float:py,Float:pz;
		GetPlayerPos(targetid, px, py, pz);
		new zone[MAX_ZONE_NAME];
		GetPlayer3DZone(targetid, zone, sizeof(zone));
		new fifstr[128];
		if(FIFEnabled)
		{
			format(fifstr, sizeof(fifstr), "{FF8000}FIF Hours:{FFFFFF} %d\n{FF8000}FIF Chances:{FFFFFF} %d\n", FIFInfo[targetid][FIFHours], FIFInfo[targetid][FIFChances]);
		}
		SetPVarInt(playerid, "ShowStats", targetid);
		format(header, sizeof(header), "Showing Statistics of %s", GetPlayerNameEx(targetid));
		format(resultline, sizeof(resultline),"%s\n\
			%s\
			%s\
			%s\
			%s\
			%s\
			{FFFFFF}Level: %d\n\
			Gender: %s\n\
			Date of Birth: %s\n\
			Current Location: %s (%0.2f, %0.2f, %0.2f)\n\
			Married To: %s\n\
			Health: %.1f\n\
			Armor: %.1f\n\
			Playing Hours: %s\n\
			Dedicated Hours: %s\n\
			Fitness: %d\n\
			Upgrade Points: %s\n\
			Next Level: %s{303030}/{FFFFFF}%s hours\n\
			Nation: %s\n\
			%s\
			%s\
			Job: %s (Level: %d)\n\
			Job 2: %s (Level: %d)\n\
			Job 3: %s (Level: %d)\n\
			Insurance: %s",
			staffrank,
			famedrank,
			dprank,
			drank,
			svipmod,
			fifstr,
			PlayerInfo[targetid][pLevel],
			sext,
			PlayerInfo[targetid][pBirthDate],
			zone, px, py, pz,
			PlayerInfo[targetid][pMarriedName],
			health,
			armor,
			number_format(PlayerInfo[targetid][pConnectHours]),
			number_format(PlayerInfo[targetid][pDedicatedHours]),
			PlayerInfo[targetid][pFitness],
			number_format(PlayerInfo[targetid][gPupgrade]),
			number_format(PlayerInfo[targetid][pExp]),
			number_format(expamount),
			nation,
			org,
			biz,
			GetJobName(PlayerInfo[targetid][pJob]),
			GetJobLevel(targetid, PlayerInfo[targetid][pJob]),
			GetJobName(PlayerInfo[targetid][pJob2]),
			GetJobLevel(targetid, PlayerInfo[targetid][pJob2]),
			GetJobName(PlayerInfo[targetid][pJob3]),
			GetJobLevel(targetid, PlayerInfo[targetid][pJob3]),
			insur);
		ShowPlayerDialogEx(playerid, DISPLAY_STATS, DIALOG_STYLE_MSGBOX, header, resultline, "Next Page", "Close");
	}
	return 1;
}