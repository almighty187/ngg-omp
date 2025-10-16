CMD:tow(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid))
	{
		new
			carid = GetPlayerVehicleID(playerid);

		if(IsATowTruck(carid))
		{
			new
				closestcar = GetClosestCar(playerid, carid);

			foreach(new i: Player)
			{
				if(arr_Towing[i] == closestcar || (GetPlayerVehicleID(i) == closestcar && GetPlayerState(i) == PLAYER_STATE_DRIVER)) return SendClientMessageEx(playerid, COLOR_GREY, "You can't tow a vehicle which is occupied, or in tow.");
			}

			if(GetDistanceToCar(playerid,closestcar) <= 8 && !IsTrailerAttachedToVehicle(carid)) {
				foreach(new i: Player)
				{
					if(IsAPlane(closestcar) || IsABike(closestcar) || IsASpawnedTrain(closestcar) || IsATrain(closestcar) || IsAHelicopter(closestcar)) {
						return SendClientMessageEx(playerid, COLOR_GRAD2, "You cannot tow this type of vehicle.");
					}
					if(GetPlayerVehicle(i, closestcar) != -1) {

						new
							hKey;

						if(((hKey = PlayerInfo[i][pPhousekey]) != INVALID_HOUSE_ID) && IsPlayerInRangeOfPoint(playerid, 50.0, HouseInfo[hKey][hExteriorX], HouseInfo[hKey][hExteriorY], HouseInfo[hKey][hExteriorZ])
						||((hKey = PlayerInfo[i][pPhousekey2]) != INVALID_HOUSE_ID) && IsPlayerInRangeOfPoint(playerid, 50.0, HouseInfo[hKey][hExteriorX], HouseInfo[hKey][hExteriorY], HouseInfo[hKey][hExteriorZ])
						||((hKey = PlayerInfo[i][pPhousekey3]) != INVALID_HOUSE_ID) && IsPlayerInRangeOfPoint(playerid, 50.0, HouseInfo[hKey][hExteriorX], HouseInfo[hKey][hExteriorY], HouseInfo[hKey][hExteriorZ])) {
							return SendClientMessageEx(playerid, COLOR_GREY, "This vehicle doesn't need to be towed.");
						}
						RemoveVehicleFromMeter(closestcar);
						arr_Towing[playerid] = closestcar;
						SendClientMessageEx(playerid, COLOR_GRAD2, "This vehicle is available for impounding.");
						return AttachTrailerToVehicle(closestcar,carid);
					}
				}	
				SendClientMessageEx(playerid, COLOR_GRAD2, "This vehicle has no registration, it is available for impounding.");
				AttachTrailerToVehicle(closestcar,carid);
				arr_Towing[playerid] = closestcar;
				RemoveVehicleFromMeter(closestcar);
				return 1;
			}
		}
		else if(IsAAircraftTowTruck(carid)) //Tug
		{
			new
				closestcar = GetClosestCar(playerid, carid);
				
			foreach(new i: Player)
			{
				if(arr_Towing[i] == closestcar || (GetPlayerVehicleID(i) == closestcar && GetPlayerState(i) == PLAYER_STATE_DRIVER)) return SendClientMessageEx(playerid, COLOR_GREY, "You can't tow a vehicle which is occupied, or in tow.");
			}
			
			if(GetDistanceToCar(playerid,closestcar) <= 8 && !IsTrailerAttachedToVehicle(carid))
			{
				foreach(new i: Player)
				{
					if(IsAPlane(closestcar))
					{
						if(GetPlayerVehicle(i, closestcar) != -1)
						{
							RemoveVehicleFromMeter(closestcar);
							arr_Towing[playerid] = closestcar;
							SendClientMessageEx(playerid, COLOR_GRAD2, "This vehicle is available for impounding.");
							return AttachTrailerToVehicle(closestcar,carid);
						}
					}
					else return SendClientMessageEx(playerid, COLOR_GRAD2, "You can only tow aircrafts with this vehicle!");
				}	
				SendClientMessageEx(playerid, COLOR_GRAD2, "This vehicle has no registration, it is available for impounding.");
				AttachTrailerToVehicle(closestcar,carid);
				arr_Towing[playerid] = closestcar;
				RemoveVehicleFromMeter(closestcar);
			}
		}
		else SendClientMessageEx(playerid, COLOR_GRAD2, "You are not authorized to tow with this vehicle.");
	}
	else SendClientMessageEx(playerid, COLOR_GRAD2, "You need to be inside a vehicle to use this command!");
	return 1;
}

CMD:untow(playerid, params[])
{
	if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
	{
		SendClientMessageEx(playerid, COLOR_GRAD1, "You have unhooked the vehicle that you were towing.");
		arr_Towing[playerid] = INVALID_VEHICLE_ID;
		DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
	}
	else SendClientMessageEx(playerid, COLOR_GRAD1, "You are currently not towing anything.");
	return 1;
}