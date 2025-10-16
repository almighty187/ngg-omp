forward OnPasswordHashed(playerid, hashid);
public OnPasswordHashed(playerid, hashid)
{
	new hash[BCRYPT_HASH_LENGTH];
	bcrypt_get_hash(hash);

	new string[300];
	mysql_format(MainPipeline, string, sizeof(string),
		"INSERT INTO `accounts` (`RegiDate`, `LastLogin`, `Username`, `Key`, `Salt`) VALUES (NOW(), NOW(), '%s', '%s', '')",
		GetPlayerNameExt(playerid), hash);
	mysql_tquery(MainPipeline, string, "OnQueryFinish", "iii", REGISTER_THREAD, playerid, g_arrQueryHandle{playerid});
	return 1;
}

forward OnPasswordVerified(playerid, bool:success);
public OnPasswordVerified(playerid, bool:success)
{
	if(!success)
	{
		ShowMainMenuDialog(playerid, 3);
		HideNoticeGUIFrame(playerid);
		if(++gPlayerLogTries[playerid] == 2)
		{
			SendClientMessage(playerid, COLOR_RED, "SERVER: Wrong password, you have been kicked out automatically.");
			SetTimerEx("KickEx", 1000, false, "i", playerid);
		}
		return 1;
	}

	new password[65];
	GetPVarString(playerid, "PassAuth", password, sizeof(password));

	if(PassComplexCheck && CheckPasswordComplexity(password) != 1)
		ShowLoginDialogs(playerid, 0);

	GetPVarString(playerid, "PassAuth", PlayerInfo[playerid][pLastPass], 65);
	DeletePVar(playerid, "PassAuth");
	HideNoticeGUIFrame(playerid);
	g_mysql_LoadAccount(playerid);
	return 1;
}

forward OnPasswordChangeHashed(playerid, hashid);
public OnPasswordChangeHashed(playerid, hashid)
{
	new hash[BCRYPT_HASH_LENGTH];
	bcrypt_get_hash(hash);

	new string[256];
	mysql_format(MainPipeline, string, sizeof(string),
		"UPDATE `accounts` SET `Key` = '%s', `Salt` = '' WHERE `id` = %d",
		hash, PlayerInfo[playerid][pId]);
	mysql_tquery(MainPipeline, string);

	// Reset the force password change flag
	if(PlayerInfo[playerid][pForcePasswordChange] == 1)
	{
		PlayerInfo[playerid][pForcePasswordChange] = 0;
		mysql_format(MainPipeline, string, sizeof(string), "UPDATE `accounts` SET `ForcePasswordChange` = '0' WHERE `id` = '%i'", PlayerInfo[playerid][pId]);
		mysql_tquery(MainPipeline, string);
	}

	SendClientMessage(playerid, COLOR_WHITE, "Your password has been successfully changed!");
	return 1;
}

forward OnMigrationPasswordHashed(playerid, hashid);
public OnMigrationPasswordHashed(playerid, hashid)
{
	new hash[BCRYPT_HASH_LENGTH];
	bcrypt_get_hash(hash);

	new string[256];
	mysql_format(MainPipeline, string, sizeof(string),
		"UPDATE `accounts` SET `Key` = '%s', `Salt` = '' WHERE `id` = %d",
		hash, PlayerInfo[playerid][pId]);
	mysql_tquery(MainPipeline, string);

	new password[65];
	GetPVarString(playerid, "PassAuth", password, sizeof(password));
	if(PassComplexCheck && CheckPasswordComplexity(password) != 1)
		ShowLoginDialogs(playerid, 0);

	GetPVarString(playerid, "PassAuth", PlayerInfo[playerid][pLastPass], 65);
	DeletePVar(playerid, "PassAuth");
	HideNoticeGUIFrame(playerid);
	g_mysql_LoadAccount(playerid);
	return 1;
}

forward OnAdminChangeUserPassword(playerid, hashid);
public OnAdminChangeUserPassword(playerid, hashid)
{
	new hash[BCRYPT_HASH_LENGTH];
	bcrypt_get_hash(hash);

	new accountName[24], query[512];
	GetPVarString(playerid, "AdminChangeUserName", accountName, sizeof(accountName));

	mysql_format(MainPipeline, query, sizeof(query),
		"UPDATE `accounts` SET `Key`='%s', `Salt`='' WHERE `Username`='%s' AND `AdminLevel` < 2",
		hash, accountName);
	mysql_tquery(MainPipeline, query, "OnChangeUserPassword", "i", playerid);

	DeletePVar(playerid, "AdminChangeUserName");
	DeletePVar(playerid, "AdminChangeUserPass");
	return 1;
}

forward OnPinNumberHashed(playerid, hashid);
public OnPinNumberHashed(playerid, hashid)
{
	new hash[BCRYPT_HASH_LENGTH];
	bcrypt_get_hash(hash);

	new query[256];
	mysql_format(MainPipeline, query, sizeof(query),
		"UPDATE `accounts` SET `Pin`='%s' WHERE `id` = %d",
		hash, GetPlayerSQLId(playerid));
	mysql_tquery(MainPipeline, query, "OnQueryFinish", "ii", SENDDATA_THREAD, playerid);

	DeletePVar(playerid, "NewPinNumber");
	return 1;
}

forward OnAdminChangeUserPin(playerid, hashid);
public OnAdminChangeUserPin(playerid, hashid)
{
	new hash[BCRYPT_HASH_LENGTH];
	bcrypt_get_hash(hash);

	new accountName[24], query[512];
	GetPVarString(playerid, "AdminChangePinName", accountName, sizeof(accountName));

	mysql_format(MainPipeline, query, sizeof(query),
		"UPDATE `accounts` SET `Pin`='%s' WHERE `Username`='%s' AND `AdminLevel` < 2",
		hash, accountName);
	mysql_tquery(MainPipeline, query, "OnChangeUserPassword", "i", playerid);

	SetPVarString(playerid, "OnChangeUserPassword", accountName);
	DeletePVar(playerid, "AdminChangePinName");
	DeletePVar(playerid, "AdminChangePinValue");
	return 1;
}

forward OnPinVerified(playerid, bool:success);
public OnPinVerified(playerid, bool:success)
{
	if(success)
	{
		SetPVarInt(playerid, "PinConfirmed", 1);
		SendClientMessageEx(playerid, COLOR_CYAN, "Pin confirmed, you will now be able to spend credits.");
		switch(GetPVarInt(playerid, "OpenShop"))
		{
			case 1:
			{
				new szDialog[1024];
				format(szDialog, sizeof(szDialog), "Poker Table (Credits: {FFD700}%s{A9C4E4})\nBoombox (Credits: {FFD700}%s{A9C4E4})\n100 Paintball Tokens (Credits: {FFD700}%s{A9C4E4})\nEXP Token (Credits: {FFD700}%s{A9C4E4})\nFireworks x5 (Credits: {FFD700}%s{A9C4E4})\nCustom License Plate (Credits: {FFD700}%s{A9C4E4})",
				number_format(ShopItems[6][sItemPrice]), number_format(ShopItems[7][sItemPrice]), number_format(ShopItems[8][sItemPrice]), number_format(ShopItems[9][sItemPrice]),
				number_format(ShopItems[10][sItemPrice]), number_format(ShopItems[22][sItemPrice]));
				format(szDialog, sizeof(szDialog), "%s\nRestricted Last Name (NEW) (Credits: {FFD700}%s{A9C4E4})\nRestricted Last Name (CHANGE) (Credits: {FFD700}%s{A9C4E4})\nCustom User Title (NEW) (Credits: {FFD700}%s{A9C4E4})\nCustom User Title (CHANGE) (Credits: {FFD700}%s{A9C4E4})\nTeamspeak User Channel (Credits: {FFD700}%s{A9C4E4})\nBackpacks\nDeluxe Car Alarm (Credits: {FFD700}%s{A9C4E4})",
				szDialog, number_format(ShopItems[31][sItemPrice]), number_format(ShopItems[32][sItemPrice]), number_format(ShopItems[33][sItemPrice]), number_format(ShopItems[34][sItemPrice]), number_format(ShopItems[35][sItemPrice]), number_format(ShopItems[39][sItemPrice]));
				ShowPlayerDialogEx(playerid, DIALOG_MISCSHOP, DIALOG_STYLE_LIST, "Misc Shop", szDialog, "Select", "Cancel");
			}
			case 2: SetPVarInt(playerid, "RentaCar", 1), ShowModelSelectionMenu(playerid, CarList2, "Rent a Car!");
			case 3: ShowModelSelectionMenu(playerid, CarList2, "Car Shop");
			case 4: ShowPlayerDialogEx(playerid, DIALOG_HOUSESHOP, DIALOG_STYLE_LIST, "House Shop", "Purchase House\nHouse Interior Change\nHouse Move\nGarage - Small\nGarage - Medium\nGarage - Large\nGarage - Extra Large","Select", "Exit" );
			case 5: ShowPlayerDialogEx(playerid, DIALOG_VIPSHOP, DIALOG_STYLE_LIST, "VIP Shop", "Purchase VIP\nRenew Gold VIP","Continue", "Exit" );
			case 6: ShowPlayerDialogEx(playerid, DIALOG_SHOPBUSINESS, DIALOG_STYLE_LIST, "Businesses Shop", "Purchase Business\nRenew Business", "Select", "Exit");
			case 7: ShowModelSelectionMenu(playerid, PlaneList, "Plane Shop");
			case 8: ShowModelSelectionMenu(playerid, BoatList, "Boat Shop");
			case 9: ShowModelSelectionMenu(playerid, CarList3, "Restricted Car Shop");
			case 10: cmd_changename(playerid);
			case 11: cmd_microshop(playerid);
		}
		DeletePVar(playerid, "OpenShop");
	}
	else
	{
		ShowPlayerDialogEx(playerid, DIALOG_ENTERPIN, DIALOG_STYLE_INPUT, "Pin Number", "(INVALID PIN)\n\nEnter your pin number to access credit shops.", "Confirm", "Exit");
	}
	DeletePVar(playerid, "PinNumber");
	DeletePVar(playerid, "StoredPinHash");
	return 1;
}
