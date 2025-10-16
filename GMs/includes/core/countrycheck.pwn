new bool:cCheck = false;

// Variables to store geo data temporarily
new geoCountry[MAX_PLAYERS][128];
new geoCity[MAX_PLAYERS][128];
new geoRegion[MAX_PLAYERS][128];

// Command to toggle country check system
CMD:togcountrycheck(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1337) return 0;
	if(cCheck)
		cCheck = false, SendClientMessageEx(playerid, -1, "Country Check System: Disabled");
	else
		cCheck = true, SendClientMessageEx(playerid, -1, "Country Check System: Enabled");
	return 1;
}

// Command to check any player's country (Admin only)
CMD:checkcountry(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2)
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "You don't have permission to use this command.");
		return 1;
	}

	new targetid;
	if(sscanf(params, "u", targetid))
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /checkcountry [playerid/name]");
		return 1;
	}

	if(!IsPlayerConnected(targetid))
	{
		SendClientMessageEx(playerid, COLOR_GRAD2, "Invalid player specified.");
		return 1;
	}

	new IPAddress[32];
	GetPlayerIp(targetid, IPAddress, sizeof(IPAddress));

	// Check if localhost
	if(!strcmp(IPAddress, "127.0.0.1", true))
	{
		SendClientMessageEx(playerid, COLOR_YELLOW, "Player: %s (ID: %d) | IP: %s", GetPlayerNameEx(targetid), targetid, IPAddress);
		SendClientMessageEx(playerid, COLOR_WHITE, "Location: Localhost (Local Connection)");
		return 1;
	}

	// Store who requested the check
	SetPVarInt(targetid, "geoCheckRequester", playerid);

	// Make API request
	new apiUrl[256];
	format(apiUrl, sizeof(apiUrl), "http://ip-api.com/json/%s?fields=status,message,country,countryCode,region,regionName,city,query", IPAddress);
	HTTP(targetid, HTTP_GET, apiUrl, "", "OnCheckCountryResponse");

	SendClientMessageEx(playerid, COLOR_YELLOW, "Checking location for %s (ID: %d)...", GetPlayerNameEx(targetid), targetid);
	return 1;
}

// Country check function using ip-api.com (free API)
CountryCheck(playerid)
{
	if(cCheck == false) return 1;

	new IPAddress[32];
	GetPlayerIp(playerid, IPAddress, sizeof(IPAddress));

	// Check if localhost
	if(!strcmp(IPAddress, "127.0.0.1", true))
	{
		printf("GEOCHECK: %s connected from localhost, allowing login.", GetPlayerNameEx(playerid));
		return 1;
	}

	// Clear previous geo data
	geoCountry[playerid][0] = 0;
	geoCity[playerid][0] = 0;
	geoRegion[playerid][0] = 0;

	// Make API request to ip-api.com (free, no key required)
	new apiUrl[256];
	format(apiUrl, sizeof(apiUrl), "http://ip-api.com/json/%s?fields=status,message,country,countryCode,region,regionName,city,query", IPAddress);
	HTTP(playerid, HTTP_GET, apiUrl, "", "CountryCheckResponse");

	return 1;
}

// Response handler for country check command
forward OnCheckCountryResponse(playerid, response_code, data[]);
public OnCheckCountryResponse(playerid, response_code, data[])
{
	new requesterid = GetPVarInt(playerid, "geoCheckRequester");
	DeletePVar(playerid, "geoCheckRequester");

	if(!IsPlayerConnected(requesterid))
		return 1;

	new IPAddress[32];
	GetPlayerIp(playerid, IPAddress, sizeof(IPAddress));

	szMiscArray[0] = 0;
	format(szMiscArray, sizeof(szMiscArray), "Player: %s (ID: %d) | IP: %s", GetPlayerNameEx(playerid), playerid, IPAddress);
	SendClientMessageEx(requesterid, COLOR_YELLOW, szMiscArray);

	if(response_code == 200)
	{
		// Parse JSON response
		new country[128], city[128], region[128], status[32];

		// Extract status
		new idx = strfind(data, "\"status\":\"");
		if(idx != -1)
		{
			idx += 10;
			new endIdx = strfind(data, "\"", false, idx);
			if(endIdx != -1)
			{
				strmid(status, data, idx, endIdx, sizeof(status));
			}
		}

		if(!strcmp(status, "success", true))
		{
			// Extract country
			idx = strfind(data, "\"country\":\"");
			if(idx != -1)
			{
				idx += 11;
				new endIdx = strfind(data, "\"", false, idx);
				if(endIdx != -1)
				{
					strmid(country, data, idx, endIdx, sizeof(country));
				}
			}

			// Extract region
			idx = strfind(data, "\"regionName\":\"");
			if(idx != -1)
			{
				idx += 14;
				new endIdx = strfind(data, "\"", false, idx);
				if(endIdx != -1)
				{
					strmid(region, data, idx, endIdx, sizeof(region));
				}
			}

			// Extract city
			idx = strfind(data, "\"city\":\"");
			if(idx != -1)
			{
				idx += 8;
				new endIdx = strfind(data, "\"", false, idx);
				if(endIdx != -1)
				{
					strmid(city, data, idx, endIdx, sizeof(city));
				}
			}

			// Display location
			format(szMiscArray, sizeof(szMiscArray), "Location: %s%s%s%s%s",
				city, strlen(city) ? ", " : "",
				region, strlen(region) ? ", " : "",
				country);
			SendClientMessageEx(requesterid, COLOR_WHITE, szMiscArray);
		}
		else
		{
			SendClientMessageEx(requesterid, COLOR_WHITE, "Location: Unable to determine (API Error)");
		}
	}
	else
	{
		SendClientMessageEx(requesterid, COLOR_WHITE, "Location: API request failed");
	}

	return 1;
}

// Response handler for automatic country check on login
forward CountryCheckResponse(playerid, response_code, data[]);
public CountryCheckResponse(playerid, response_code, data[])
{
	if(response_code == 200)
	{
		// Parse JSON response
		new country[128], city[128], region[128], status[32];

		// Extract status
		new idx = strfind(data, "\"status\":\"");
		if(idx != -1)
		{
			idx += 10;
			new endIdx = strfind(data, "\"", false, idx);
			if(endIdx != -1)
			{
				strmid(status, data, idx, endIdx, sizeof(status));
			}
		}

		if(!strcmp(status, "success", true))
		{
			// Extract country
			idx = strfind(data, "\"country\":\"");
			if(idx != -1)
			{
				idx += 11;
				new endIdx = strfind(data, "\"", false, idx);
				if(endIdx != -1)
				{
					strmid(country, data, idx, endIdx, sizeof(country));
					format(geoCountry[playerid], 128, "%s", country);
				}
			}

			// Extract region
			idx = strfind(data, "\"regionName\":\"");
			if(idx != -1)
			{
				idx += 14;
				new endIdx = strfind(data, "\"", false, idx);
				if(endIdx != -1)
				{
					strmid(region, data, idx, endIdx, sizeof(region));
					format(geoRegion[playerid], 128, "%s", region);
				}
			}

			// Extract city
			idx = strfind(data, "\"city\":\"");
			if(idx != -1)
			{
				idx += 8;
				new endIdx = strfind(data, "\"", false, idx);
				if(endIdx != -1)
				{
					strmid(city, data, idx, endIdx, sizeof(city));
					format(geoCity[playerid], 128, "%s", city);
				}
			}

			// Log the connection
			szMiscArray[0] = 0;
			format(szMiscArray, sizeof(szMiscArray), "LOGIN: %s(%d) connected from %s, %s, %s (IP: %s)",
				GetPlayerNameEx(playerid),
				GetPVarInt(playerid, "pSQLID"),
				city,
				region,
				country,
				PlayerInfo[playerid][pIP]);
			Log("logs/geocheck.log", szMiscArray);

			printf("GEOCHECK: %s logged in from %s, %s, %s", GetPlayerNameEx(playerid), city, region, country);

			// Optional: Add country mismatch check here if you store expected countries in your database
			/*
			if(PlayerInfo[playerid][pCountry][0] != 0) // If player has a registered country
			{
				if(strcmp(country, PlayerInfo[playerid][pCountry], true) != 0) // Country mismatch
				{
					format(szMiscArray, sizeof(szMiscArray), "{AA3333}AdmWarning{FFFF00}: %s (IP:%s) connected from %s but registered country is %s",
						GetPlayerNameEx(playerid), PlayerInfo[playerid][pIP], country, PlayerInfo[playerid][pCountry]);
					ABroadCast(COLOR_YELLOW, szMiscArray, 2);

					format(szMiscArray, sizeof(szMiscArray), "WARNING: %s(%d) (IP:%s) country mismatch: Current=%s, Registered=%s",
						GetPlayerNameEx(playerid), GetPVarInt(playerid, "pSQLID"), PlayerInfo[playerid][pIP], country, PlayerInfo[playerid][pCountry]);
					Log("logs/geocheck.log", szMiscArray);

					SendClientMessage(playerid, COLOR_YELLOW, "WARNING: You are connecting from a different country than usual.");
					SendClientMessage(playerid, COLOR_YELLOW, "If this is not you, please contact an administrator immediately.");
				}
			}
			*/
		}
		else
		{
			printf("GEOCHECK WARNING: API returned error for %s (IP: %s)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pIP]);
		}
	}
	else
	{
		printf("GEOCHECK WARNING: API request failed for %s (IP: %s) - Response code: %d", GetPlayerNameEx(playerid), PlayerInfo[playerid][pIP], response_code);
	}

	return 1;
}