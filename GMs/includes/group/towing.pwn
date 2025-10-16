CMD:impound(playerid, params[]) {
	if(IsACop(playerid) || IsATowman(playerid)) {
		if(!IsAtImpoundingPoint(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You are not near the impound point, you can't impound!");
		if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid))) {
			new veh = -1, iVehTowed = GetVehicleTrailer(GetPlayerVehicleID(playerid)), szMessage[128];
			if(!GetVehicleModel(iVehTowed)) return SendClientMessageEx(playerid, COLOR_GREY, "The vehicle in tow has been desynced and therefore cannot be impounded.");
			// Player Vehicle.
			foreach(new i: Player) {
				if((veh = GetPlayerVehicle(i, iVehTowed)) != -1) {
					new iCost = (((PlayerVehicleInfo[i][veh][pvPrice] / 20 + PlayerVehicleInfo[i][veh][pvTicket]) / 100) * 30);
					SetGroupBudget(PlayerInfo[playerid][pMember], iCost);
					--PlayerCars;
					VehicleSpawned[i]--;
					PlayerVehicleInfo[i][veh][pvImpounded] = 1;
					PlayerVehicleInfo[i][veh][pvSpawned] = 0;
					PlayerVehicleInfo[i][veh][pvFuel] = VehicleFuel[iVehTowed];
					GetVehicleHealth(PlayerVehicleInfo[i][veh][pvId], PlayerVehicleInfo[i][veh][pvHealth]);
					DetachTrailerFromVehicle(iVehTowed);
					DestroyVehicle(iVehTowed);
					if(IsValidDynamicArea(iVehEnterAreaID[iVehTowed])) DestroyDynamicArea(iVehEnterAreaID[iVehTowed]);
					PlayerVehicleInfo[i][veh][pvId] = INVALID_PLAYER_VEHICLE_ID;
					g_mysql_SaveVehicle(playerid, veh);

					format(szMessage, sizeof(szMessage),"* You have impounded %s's %s.",GetPlayerNameEx(i), VehicleName[PlayerVehicleInfo[i][veh][pvModelId] - 400]);
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);

					format(szMessage, sizeof(szMessage), "Your %s has been impounded. You may release it at the DMV in Dillimore.", VehicleName[PlayerVehicleInfo[i][veh][pvModelId] - 400]);
					SendClientMessageEx(i, COLOR_LIGHTBLUE, szMessage);

					format(szMessage, sizeof(szMessage), "HQ: %s has impounded %s's %s ($%s unpaid tickets).", GetPlayerNameEx(playerid), GetPlayerNameEx(i), VehicleName[PlayerVehicleInfo[i][veh][pvModelId] - 400], number_format(PlayerVehicleInfo[i][veh][pvTicket]));
					SendGroupMessage(arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType], RADIO, szMessage);
					
					format(szMessage, sizeof(szMessage), "IMPOUND: %s has impounded %s's %s and gained $%s", GetPlayerNameEx(playerid), GetPlayerNameEx(i), VehicleName[PlayerVehicleInfo[i][veh][pvModelId] - 400], number_format(iCost));
					GroupLog(PlayerInfo[playerid][pMember], szMessage);
					break;
				}
			}
			// Crate Vehicle.
			if((veh = IsDynamicCrateVehicle(iVehTowed)) != -1) {
				if(ValidGroup(CrateVehicle[veh][cvGroupID])) {
					if(PlayerInfo[playerid][pMember] == CrateVehicle[veh][cvGroupID]) return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* Your group owns this vehicle you can't impound it!");
					new iCost = (((2000000 / 20 + CrateVehicle[veh][cvTickets]) / 100) * 30), Float:vHealth;
					SetGroupBudget(PlayerInfo[playerid][pMember], iCost);
					GetVehicleHealth(CrateVehicle[veh][cvSpawnID], vHealth);
					CrateVehicle[veh][cvHealth] = vHealth;
					CrateVehicle[veh][cvFuel] = VehicleFuel[CrateVehicle[veh][cvSpawnID]];
					CrateVehicle[veh][cvImpound] = 1;
					DetachTrailerFromVehicle(iVehTowed);
					if(CreateCount(veh) > 0) AnnounceRespawn(CrateVehicle[veh][cvGroupID], "impounded", veh, CreateCount(veh));
					DestroyVehicle(CrateVehicle[veh][cvSpawnID]);
					CrateVehicle[veh][cvSpawned] = 0;
					CrateVehicle[veh][cvSpawnID] = INVALID_VEHICLE_ID;
					CrateVehCheck(veh); // Ensure we check for crates!
					SaveCrateVehicle(veh);

					format(szMessage, sizeof(szMessage), "* Your %s has been impounded you can recover it from your garage. (( /cvstorage ))", VehicleName[CrateVehicle[veh][cvModel] - 400]);
					foreach(new i: Player) {
						if(PlayerInfo[i][pLeader] == CrateVehicle[veh][cvGroupID]) {
							ChatTrafficProcess(i, arrGroupData[CrateVehicle[veh][cvGroupID]][g_hRadioColour] * 256 + 255, szMessage, 12);
						}
					}

					format(szMessage, sizeof(szMessage),"* You have impounded %s's %s.", arrGroupData[CrateVehicle[veh][cvGroupID]][g_szGroupName], VehicleName[CrateVehicle[veh][cvModel] - 400]);
					SendClientMessageEx(playerid, COLOR_LIGHTBLUE, szMessage);

					format(szMessage, sizeof(szMessage), "HQ: %s has impounded %s's %s ($%s unpaid tickets).", GetPlayerNameEx(playerid), arrGroupData[CrateVehicle[veh][cvGroupID]][g_szGroupName], VehicleName[CrateVehicle[veh][cvModel] - 400], number_format(CrateVehicle[veh][cvTickets]));
					SendGroupMessage(arrGroupData[PlayerInfo[playerid][pMember]][g_iGroupType], RADIO, szMessage);

					format(szMessage, sizeof(szMessage), "IMPOUND: %s has impounded %s's %s and gained $%s", GetPlayerNameEx(playerid), arrGroupData[CrateVehicle[veh][cvGroupID]][g_szGroupName], VehicleName[CrateVehicle[veh][cvModel] - 400], number_format(iCost));
					GroupLog(PlayerInfo[playerid][pMember], szMessage);

				}
				else veh = -1;
			}
			if(veh == -1) {
				SendClientMessageEx(playerid, COLOR_GRAD1, "The impound administration could not find any registration on the vehicle and has returned it.");
				DetachTrailerFromVehicle(iVehTowed);
				SetVehicleToRespawn(iVehTowed);
			}
			arr_Towing[playerid] = INVALID_VEHICLE_ID;
		}
	}
	return 1;
}