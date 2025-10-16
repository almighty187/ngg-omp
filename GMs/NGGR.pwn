#define MIXED_SPELLINGS

#include <open.mp>

#define SERVER_GM_TEXT "NG:GR v3.2.1"
#define CGEN_MEMORY 65536
#define YSI_NO_HEAP_MALLOC
#define AC_MAX_CONNECTS_FROM_IP 100  // for testing
#define DISCORD_ENABLED

forward OnCheatDetected(playerid, ip_address[], type, code);

new bool:registrationEnabled = true;

#include <a_mysql>
#include <samp_bcrypt>
#include <streamer>
#include <yom_buttons>
#include <zcmd>
#include <sscanf2>
#include <crashdetect>
#include <YSI_Coding\y_timers>
#include <YSI_Core\y_utils>
#include <YSI_Players\y_android>
#include <YSI_Coding\y_va>
#include <pawn.raknet>
#include <nex-ac_en.lang>
#include <nex-ac>
#include <mSelection>
#include <gvar>
#include <geo_ip>
#include <easyDialog>
#include <callbacks>
#include <attachments>

#if defined DISCORD_ENABLED
	#include <discord-connector>
#endif

#if defined SOCKET_ENABLED
	#include <socket>
#endif

#include "./includes/defines.pwn"
#include "./includes/enums.pwn"
#include "./includes/variables.pwn"
#include "./includes/wrappers.pwn"
#include "./includes/timers.pwn"
#include "./includes/functions.pwn"
#include "./includes/mysql.pwn"
#include "./includes/OnPlayerLoad.pwn"
#include "./includes/callbacks.pwn"
#include "./includes/textdraws.pwn"
#include "./includes/streamer.pwn"
#include "./includes/OnDialogResponse.pwn"
#include "./includes/DBLog.pwn"
#include "./includes/walkstyle.pwn"
#include "./includes/raknet.pwn"

#if defined DISCORD_ENABLED
	#include "./includes/discord.pwn"
#endif

#if defined AREA_DEBUG
#include "./includes/areadebug.pwn"
#endif

// anticheat includes
#include "./includes/anticheat/nex_ac_integration.pwn"

//streamer includes
#include "./includes/streamer/removebuildings.pwn"
#include "./includes/streamer/areas.pwn"
#include "./includes/streamer/buttons.pwn"
#include "./includes/streamer/objects.pwn"
#include "./includes/streamer/pickups.pwn"
#include "./includes/streamer/textlabels.pwn"
#include "./includes/streamer/vehicles.pwn"
#include "./includes/streamer/OnPlayerEditDynamicObject.pwn"

//admin includes
#include "./includes/admin/admin.pwn"
#include "./includes/admin/advisory.pwn"
#include "./includes/admin/auctionsystem.pwn"
#include "./includes/admin/bugreport.pwn"
#include "./includes/admin/flags.pwn"
#include "./includes/admin/gift.pwn"
#include "./includes/admin/reportsystem.pwn"
#include "./includes/admin/serveroffences.pwn"
#include "./includes/admin/vouchers.pwn"
#include "./includes/admin/watchdogs.pwn"
#include "./includes/admin/intlist.pwn"
#include "./includes/admin/anticheat.pwn"
#include "./includes/admin/spectate.pwn"
#include "./includes/admin/teleport.pwn"
#include "./includes/admin/watch.pwn"
#include "./includes/admin/newbie.pwn"
#include "./includes/admin/ban.pwn"
#include "./includes/admin/newstaffban.pwn"

#include "./includes/furnituretextures.pwn"
#include "./includes/furniture.pwn"

//business includes
#include "./includes/business/247items.pwn"
#include "./includes/business/ammunation.pwn"
#include "./includes/business/businesscore.pwn"
#include "./includes/business/mailsystem.pwn"

//core includes
#include "./includes/core/acceptcancel.pwn"
#include "./includes/core/advertisements.pwn"
#include "./includes/core/ATMs.pwn"
#include "./includes/core/anticbug.pwn"
#include "./includes/core/banking.pwn"
#include "./includes/core/Banks.pwn"
#include "./includes/core/chat.pwn"
#include "./includes/core/entexit.pwn"
#include "./includes/core/fireworks.pwn"
#include "./includes/core/helpcmds.pwn"
#include "./includes/core/hospital.pwn"
#include "./includes/core/lotto.pwn"
#include "./includes/core/lselevator.pwn"
#include "./includes/core/marriage.pwn"
#include "./includes/core/namechange.pwn"
#include "./includes/core/payphones.pwn"
#include "./includes/core/phone.pwn"
#include "./includes/core/phone_new.pwn"
#include "./includes/core/Player_Interact.pwn"
#include "./includes/core/radio.pwn"
#include "./includes/core/service.pwn"
#include "./includes/core/storage.pwn"
#include "./includes/core/tutorial.pwn"
#include "./includes/core/upgrades.pwn"
#include "./includes/core/vactions.pwn"
#include "./includes/core/weapons.pwn"
#include "./includes/core/damage.pwn"
#include "./includes/core/health.pwn"
#include "./includes/core/teams.pwn"
#include "./includes/core/stats.pwn"
#include "./includes/core/timefuncs.pwn"
#include "./includes/core/camerafuncs.pwn"
#include "./includes/core/clearcheckpoint.pwn"
#include "./includes/core/maintenance.pwn"
#include "./includes/core/countrycheck.pwn"
#include "./includes/core/countdown.pwn"
#include "./includes/core/filehandle.pwn"
#include "./includes/core/initgamemode.pwn"
#include "./includes/core/login.pwn"
#include "./includes/core/bcrypt_auth.pwn"
#include "./includes/core/miscload.pwn"
#include "./includes/core/proxdetector.pwn"
#include "./includes/core/setplayerspawn.pwn"
#include "./includes/core/stats.pwn"
#include "./includes/core/streamprep.pwn"
#include "./includes/core/emailcheck.pwn"
#include "./includes/core/AccountSettings.pwn"
#include "./includes/core/deluxegps.pwn"
#include "./includes/core/vending.pwn"
#include "./includes/core/minigame.pwn"

//dynamic core includes
#include "./includes/dynamic/doors.pwn"
#include "./includes/dynamic/garages.pwn"
#include "./includes/dynamic/gates.pwn"
#include "./includes/dynamic/houses.pwn"
#include "./includes/dynamic/mapicons.pwn"
#include "./includes/dynamic/motds.pwn"
#include "./includes/dynamic/paynsprays.pwn"
#include "./includes/dynamic/textlabels.pwn"
#include "./includes/dynamic/impound.pwn"
#include "./includes/dynamic/speedcamera.pwn"
#include "./includes/dynamic/arrestpoints.pwn"
#include "./includes/dynamic/dynsu.pwn"
#include "./includes/dynamic/housemarket.pwn"
#include "./includes/dynamic/ddsale.pwn"
#include "./includes/dynamic/parking.pwn"
#include "./includes/dynamic/MetalDetectors.pwn"
#include "./includes/dynamic/points.pwn"

//vehicle system includes
#include "./includes/vehsystem/vehiclecore.pwn"
#include "./includes/vehsystem/drivingtest.pwn"
#include "./includes/vehsystem/Server_DMV.pwn"
#include "./includes/vehsystem/speedo.pwn"
#include "./includes/vehsystem/tow.pwn"
#include "./includes/vehsystem/VLP.pwn"
#include "./includes/vehsystem/helmet.pwn"
#include "./includes/vehsystem/groupvehs.pwn"
#include "./includes/vehsystem/playervehs.pwn"
#include "./includes/vehsystem/cratevehicles.pwn"
#include "./includes/vehsystem/vehauto.pwn"

//event kernels includes
#include "./includes/events/event.pwn"
#include "./includes/events/eventpoints.pwn"
#include "./includes/events/fif.pwn"
#include "./includes/events/findtheflag.pwn"
#include "./includes/events/hungergames.pwn"
#include "./includes/events/paintball.pwn"
#include "./includes/events/rewardplay.pwn"
#include "./includes/events/rfl.pwn"
#include "./includes/events/xmas.pwn"
#include "./includes/events/zombies.pwn"
#include "./includes/events/valentine.pwn"

//dynamic group system includes
#include "./includes/group/callsign.pwn"
#include "./includes/group/citizenship.pwn"
#include "./includes/group/elections.pwn"
#include "./includes/group/hitman.pwn"
#include "./includes/group/gov.pwn"
#include "./includes/group/groupcore.pwn"
#include "./includes/group/judicial.pwn"
#include "./includes/group/lea.pwn"
#include "./includes/group/medic.pwn"
#include "./includes/group/news.pwn"
#include "./includes/prison_system.pwn"
#include "./includes/group/racing.pwn"
#include "./includes/group/rivalry.pwn"
#include "./includes/group/taxi.pwn"
#include "./includes/group/towing.pwn"
#include "./includes/group/turfs.pwn"
#include "./includes/group/cratesystem.pwn"
#include "./includes/group/callsystem.pwn"
#include "./includes/group/GovArms.pwn"
#include "./includes/group/grouppay.pwn"
#include "./includes/group/gangtags.pwn"
#include "./includes/group/GunLicense.pwn"
#include "./includes/group/sanews.pwn"
#include "./includes/group/casefile.pwn"
#include "./includes/group/groupweapons.pwn"

//job system includes
#include "./includes/jobs/bartender.pwn"
#include "./includes/jobs/bodyguard.pwn"
#include "./includes/jobs/boxing.pwn"
#include "./includes/jobs/craftsman.pwn"
#include "./includes/jobs/detective.pwn"
#include "./includes/jobs/drugs.pwn"
#include "./includes/garbagesystem.pwn"
#include "./includes/fishingsystem.pwn"
#include "./includes/jobs/jobcore.pwn"
#include "./includes/jobs/dynjobcore.pwn"
#include "./includes/jobs/lawyer.pwn"
#include "./includes/jobs/mechanic.pwn"
#include "./includes/jobs/pizzaboy.pwn"
#include "./includes/jobs/shipment.pwn"
#include "./includes/jobs/taxi.pwn"
#include "./includes/jobs/treasure.pwn"
#include "./includes/jobs/whore.pwn"
#include "./includes/jobs/armsdealer.pwn"
#include "./includes/core/drugcore.pwn"

//perk system includes
#include "./includes/perks/boombox.pwn"
#include "./includes/perks/backpack.pwn"
#include "./includes/perks/dedicated.pwn"
#include "./includes/perks/famed.pwn"
#include "./includes/perks/poker.pwn"
#include "./includes/perks/shopcore.pwn"
#include "./includes/perks/tokens.pwn"
#include "./includes/perks/toys.pwn"
#include "./includes/perks/vipcore.pwn"
#include "./includes/perks/casino.pwn"
#include "./includes/perks/horsey.pwn"

main(){}

public OnGameModeInit()
{
	print("Preparing the gamemode, please wait...");
	g_mysql_Init();
	InitializeNexACIntegration();
	return 1;
}

public OnGameModeExit()
{
	print("Exiting the gamemode, please wait...");
    g_mysql_Exit();
	return 1;
}

AntiDeAMX()
{
    new a[][] = {
        "Unarmed (Fist)",
        "Brass K"
    };
    #pragma unused a
}