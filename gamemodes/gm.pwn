//++++NOTES+++++++++++++++++++++++++++++++++++++++
// 
//====INCLUDES====================================
#include <a_samp>
#include <a_mysql>
#include <dutils>
#include <GeoIP_Plugin>	
#include <streamer>
#include <zcmd>
#include <sscanf2>
#include <foreach>
#include <v_handler>
#include <colors>
//====DEFINES=====================================
//------------------------------------------------------------------------------
// Uncomment the line below if you want to use debugging
#define                 DEBUG
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
#define 					POCKETMONEY					 	2500
#define 					MAX_GIVECASH					100000
#define 					MIN_PLAYER_CASH					-1000000
#define 					MAX_BANK_SAVE 					5000000
#define 					MAX_PLAYER_SPAWNCASH			1000000
#define 					INACTIVE_PLAYER_ID 				255
#define 					MAX_BOUNTY						500000
//----Utilities-----------------------------------------------------------------
#define 					MAX_UTILITIES 					10
#define 					U_SFTRAIN						1000
#define 					U_LSTRAIN						1001
#define 					U_LVTRAIN						1002
#define 					U_UNTRAIN       				1003
#define 					U_LINTRAIN      				1004
#define 					U_BANK 							1005
#define 					U_PIRATE 						1006
#define 					U_AMMU         					1007
#define 					U_PAUZE							1008
#define 					U_DISH							1009
//----Server Info---------------------------------------------------------------
#define                     DEVELOPMENT_VERSION             "1.0.0"
#define                     SERVER_NAME                     "WG FreeRoam/deathmatch"
#define                     SERVER_SHORT_NAME               "WG "
#define 					MAX_SERVER_NAMES 				10
//----Spawnweapons--------------------------------------------------------------
#define 					MAX_WEAPONS 					8
#define 					MAX_WEAPON_NAME					32
//----Gangs---------------------------------------------------------------------
#define 					MAX_GANGS 						10
#define 					MAX_GANG_MEMBERS				10
#define 					MAX_GANG_NAME       			16
#define 					GANG_NONE						999
//----Areas---------------------------------------------------------------------
#define 					CP_NONE							9999
//----Password defines----------------------------------------------------------
#define      				MIN_PASSWORD_LENGTH					(6)
#define             		MAX_PASSWORD_LENGTH         		(128)
#define                     MAX_INCORRECT_PASSWORD_ATTEMPTS     (3)
//----Bug Report Defines----------------------------------------------------------
#define      				MIN_BUG_LENGTH						(6)
#define             		MAX_BUG_LENGTH  		       		(256)
//----Dialog defines------------------------------------------------------------
#define                     DIALOG_LOGIN                        (1)
#define                     DIALOG_REGISTER                     (2)
#define                     DIALOG_TAXI                         (3)
#define                     DIALOG_CRANBERRY                    (4)
#define                     DIALOG_UNITY                        (5)
#define                     DIALOG_MARKET                       (6)
#define                     DIALOG_LINDEN                       (7)
#define                     DIALOG_YBELL                        (8)
#define                     DIALOG_BANK                         (9)
#define                     DIALOG_DEPOSIT                      (10)
#define                     DIALOG_WITHDRAW                     (11)
#define                     DIALOG_BALANCE                      (12)
#define                		DIALOG_MSGBOX						(13)
#define 					DIALOG_GANG_DEPOSIT					(14)
#define  					DIALOG_GANG_WITHDRAW				(15)
#define 					DIALOG_GANG							(16)
#define 					DIALOG_GANG_CREATE					(17)
#define						DIALOG_GANG_JOIN					(18)
#define 					DIALOG_GANG_INVITE					(19)
#define 					DIALOG_GANG_QUIT					(20)
#define 					DIALOG_PLAY 						(21)
#define 					DIALOG_RULES 						(22)
#define                     DIALOG_REGISTER2                    (23)
#define 					DIALOG_SPEED 						(24)
#define 					DIALOG_BUG_REPORT					(25)
#define 					DIALOG_GMX              			(26)
//----Mysql threads-------------------------------------------------------------
#define                     THREAD_USERNAME_LOOKUP              (1)
#define 					THREAD_USERNAME_REGISTER			(2)
#define						THREAD_REGISTER_SPAWN				(3)
#define 					THREAD_NO_RESULT     				(4)
#define                     THREAD_CHANGE_NAME                  (5)
#define                     THREAD_CHECK_IP                     (6)
//#define						THREAD_LOADSERVER_INFO              (7)//i will use this laters
#define 					THREAD_LOAD_GANGS					(8)
//----Player Status------------------------------------------------------------
#define   					STATUS_TEMP							994	
#define 					STATUS_NOTLOGGEDIN  				995
#define 					STATUS_JAILED						996
#define 					STATUS_PAUSED						997
#define 					STATUS_NONE							999//999 = NOTHING!
//--Rankings--------------------------------------------------------------------
#define 					RANK_STARTER						0
#define 					RANK_ADDICT							1
#define 					RANK_MASTER							2
#define 					RANK_PRO							3
#define 					RANK_EXPERT							4
#define 					RANK_ELITE							5
#define 					RANK_FREAK							6
//--Various Wait Timers--------------------------------------------------------------------
#define 					TAXI_WAIT_TIME 						120000 // Time it takes until player can use taxi again.
//--Music Defines---------------------------------------------------------------
#define SOUND_CLASSSELECT       "http://pamp3.site40.net/sampfs/aggrosantoscandy.mp3"// Sound: Played during class selection.yep i stole this link
//----speedup-------------------------------------------------------------------
#define SPEED_MULTIPLIER 1.025// The speed will be multiplied by this value was 1.025
#define SPEED_THRESHOLD  0.4// The speed will only be increased if velocity is larger than this value
//====FORWARDS====================================
forward PausePlayer(playerid);
forward OnPlayerEnterUnPauseCheckpoint(playerid);
forward CheckPlayerAFK();
forward CountDownFunction();
forward OperationSaveTheWorld();
forward MoneyScoreUpdate();
forward MainTimer();
forward LoginPlayer(playerid);
forward RegisterPlayer(playerid);
forward RegisterPlayedPlayer(playerid);
forward Playerplay(playerid);
forward IsPlayerLoggedIn(playerid);
forward TrainPlayer(playerid,newlocation);
forward TaxiPlayer(playerid,newlocation);
forward SetupPlayerForClassSelection(playerid);
forward BankInterest();
forward GangChat(playerid, text[]);
forward PlayerLeaveGang(playerid);
forward PlayerJoinGang(playerid);
forward PlayerInviteToGang(playerid, giveplayerid);
forward PlayerCreateGang(playerid, name[]);
forward IsPlayerInThisCheckpoint(playerid,checkpoint);
forward IsPlayerInTrainCheckpoint(playerid);
forward SetPlayerRandomSpawn(playerid);
forward OnPlayerDeathInInterior(playerid, killerid, reason);
forward OnPlayerDeathInJail(playerid, killerid, reason);
forward OnPlayerDeathOnShip(playerid, killerid, reason);
forward OnPlayerPrivmsg(playerid, recipientid, text[]);
forward AreaCheckFunc();
forward IsPlayerInArea3D(playerid, Float:x1, Float:y1, Float:x2, Float:y2, Float:z1, Float:z2);
forward IsPlayerInArea(playerid, Float:x1, Float:y1, Float:x2, Float:y2);
forward CheckPlayerRank(playerid);
forward ReturnPlayerStats(playerid,giveplayerid);
forward UpdateIngameTimes();
forward SetPlayerJailSpawn(playerid);
forward JailTimeUpdate();
forward IsPlayerJailed(playerid);
forward UnJail(playerid,guilty);
forward Jail(playerid, time);
forward IsPlayerPaused(playerid);
forward MoneyCheatDetection();
forward LoginAreaCheck(playerid);
forward JailAreaCheck(playerid);
forward OnPlayerDeathByCheatkill(playerid, killerid, reason);
forward Float:GetDistance(Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2);
forward ResetMoney(playerid);
forward GiveMoney(playerid, money);
forward VehicleDriver(vehicleid) ;
forward UnlockEmptyVehicles();
forward IsPlayerInInterior(playerid);
forward SaveSaveablePlayerInfo(playerid);
forward LoadSaveablePlayerInfo(playerid);
forward ResetPlayerInfo(playerid);
forward news(message[]);
forward KickPublic(playerid);
forward ReSpawnVehicles();
forward ServerNameUpdate();
forward PlayerTaxiTimer(playerid);
forward AllowTaxi(playerid);
forward PlayerGiveCashDelay(playerid);
forward OnQueryFinish(query[], resultid, extraid, connectionHandle);
//ship stuff
forward IsPlayerOnShip(cplayerID, Float:data[4]);
forward isPlayerInArea( playerID, Float:data[4] );
forward SafeZone();
forward IsPlayerInVeh(playerid);
//car stuff
forward update_zones();
forward HidePlayerTextDraw(i);
forward HideZoneName(playerid);
//speed-up
forward SpeedUp();
//!!!!!!!!!!!will change this later!!!!!!!!!!!!!
//gmx
forward restartTimer();
//====ENUMERATIONS & DECLARATIONS=================
//====ENUMERATIONS================================
enum GangInfoEnum
{
	GangID,
	GangName[MAX_GANG_NAME],
	GangMembers,
	GangColor,
	GangBank
};


enum ePlayerData
{
	PlayerName[MAX_PLAYER_NAME],
	pIP[32],
	pPassword[MAX_PASSWORD_LENGTH],
	pDBID, // This is a unique ID in the database for our player. We'll make great use of this later.
	RegDate,
	pMoney,
	Bank,
	Bounty,
	JailTime,
	IngameTime,
	Kills,
	Deaths,
	Jails,
	Kicks,
	Skin,
	UseSkin,
	PlayerStatus,
	Checkpoint,
	GangInvite,
	Gang,
	Float:BackPos[3],
	WatchingPlayer,
	Money,
	PlayerMute,
	NotLoggedInTime,
	FirstTimeSpawned,
	PlayerRanking,
	MaxBank,
	Health,
	Float:PlayerSavedPos[3],
	ResetToBackPos,
	Speed,
	PmStatus,
	radio
}

enum ServerPricesEnum
{
	Taxi,
	Skydive,
}

enum zoneinfo 
{
	zone_name[28],
	Float:zone_minx,
	Float:zone_miny,
	Float:zone_minz,
	Float:zone_maxx,
	Float:zone_maxy,
	Float:zone_maxz
}

enum connectionE 
{
	szDatabaseName[32],
	szDatabaseHostname[32],
	szDatabaseUsername[32],
	szDatabasePassword[64],
}

enum AdvancedTimersEnum
{
	TenSecTimer,
	MinTimer,
	FiveMinTimer,
	TenMinTimer,
	FithTeenMinTimer,
	TimeTimer,
	AreaTimer,
	CountDownTimer,
}
//====DECLARATIONS================================
new RandomColors[127] = //playerColors
{
	0x4F5152D4,0xFF8C13FF,0xC715FFFF,0x20B2AAFF,0xDC143CFF,0x6495EDFF,0xf0e68cFF,0xEE82EEFF,0xFF1493FF,
	0xFFD720FF,0x8b4513FF,0x4949A0FF,0x148b8bFF,0x14ff7fFF,0x556b2fFF,0x0FD9FAFF,0x10DC29FF,0xF4A460FF,
	0x534081FF,0x0495CDFF,0xEF6CE8FF,0xBD34DAFF,0x247C1BFF,0x0C8E5DFF,0x635B03FF,0xCB7ED3FF,0x65ADEBFF,
	0x5C1ACCFF,0xF2F853FF,0x11F891FF,0x7B39AAFF,0x53EB10FF,0x54137DFF,0x275222FF,0xF09F5BFF,0x3D0A4FFF,
	0x22F767FF,0xD63034FF,0x9A6980FF,0xDFB935FF,0x3793FAFF,0x90239DFF,0xE9AB2FFF,0xAF2FF3FF,0x057F94FF,
	0xB98519FF,0x388EEAFF,0x028151FF,0xA55043FF,0x0DE018FF,0x93AB1CFF,0x95BAF0FF,0x369976FF,0x18F71FFF,
	0x4B8987FF,0x491B9EFF,0x829DC7FF,0xBCE635FF,0xCEA6DFFF,0x20D4ADFF,0x2D74FDFF,0x3C1C0DFF,0x12D6D4FF,
	0x48C000FF,0x2A51E2FF,0xE3AC12FF,0xFC42A8FF,0x2FC827FF,0x1A30BFFF,0xB740C2FF,0x42ACF5FF,0x2FD9DEFF,
	0xFAFB71FF,0x05D1CDFF,0xC471BDFF,0x94436EFF,0xC1F7ECFF,0xCE79EEFF,0xBD1EF2FF,0x93B7E4FF,0x3214AAFF,
	0x184D3BFF,0xAE4B99FF,0x7E49D7FF,0x4C436EFF,0xFA24CCFF,0xCE76BEFF,0xA04E0AFF,0x9F945CFF,0xDCDE3DFF,
	0x10C9C5FF,0x70524DFF,0x0BE472FF,0x8A2CD7FF,0x6152C2FF,0xCF72A9FF,0xE59338FF,0xEEDC2DFF,0xD8C762FF,
	0x778899FF,0xFF8080FF,0xFFFF80FF,0x80FF80FF,0x00FF80FF,0x80FFFFFF,0x0080FFFF,0xFF80C0FF,0xFF80FFFF,
	0xFF0000FF,0xFFFF00FF,0x80FF00FF,0x00FF40FF,0x00FFFFFF,0x0080C0FF,0x8080C0FF,0xFF0080FF,0xFF8040FF,
	0x0000FFFF,0x0000A0FF,0x800080FF,0x8000FFFF,0x808000FF,0x808040FF,0x808080FF,0x408080FF,0xC0C0C0FF,
	0xFFFFFFFF
};

#include includes/spawns.inc

new ListPlayerClasses[] = 
{
	0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,
	32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,
	61,62,63,64,65,66,67,68,69,70,71,72,73,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,
	91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,
	115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,
	137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,
	159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,
	181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,
	203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,
	225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,
	247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,265,266,267,268,269,
	270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,
	292,293,294,295,296,297,298,299
};

new ServerPrice[ServerPricesEnum] =
{
	50,//was 20
	5000,
};
//Server Name Changer-well sounded like a good idea at the time
new CurrentServerName;
new MainServerName[64] = "World-Gamerz Test Server";
new ServerNames[MAX_SERVER_NAMES][64]=
{
	"World-Gamerz Freeroam DM Server",
	"* Main",
	"World-Gamerz FreeRoam DM Gangs Server",
	"* Main",
	"World-Gamerz Opening Soon",
	"* Main",
	"World-Gamerz Testing Server",
	"* Main",
	"World-Gamerz More Coming Soon",
	"* Main"
};
//--Checkpoints-------------------------------------------------------------------------------------------------------
new CP1,CP2,CP3,CP4,CP5,CP6,CP7,CP8,CP9,CP10,CP11;

#include includes/zones.pwn

new 
	dConnect, // We want a connection handle for the database, so we can close it later.
	connectionInfo[connectionE],
	shipDisarm[MAX_PLAYERS],
	SavedPlayerWeaps[MAX_PLAYERS][14][2],
	g_SpeedUpTimer = -1,////speed-up
    Float:g_SpeedThreshold,
    PLAYER_SLOTS,
	Float:areaShip[4] = {1995.0,1515.0,2006.0,1570.0}, //Pitate Ship
	Float:areaRamp[4] = {2006.0,1540.1,2024.3,1550.3}, // Ramp area
	GangInfo[MAX_GANGS][GangInfoEnum],
	playerVariables[MAX_PLAYERS][ePlayerData],
	TickCount[AdvancedTimersEnum],
	iSpawnSet[MAX_PLAYERS],
	sPlayerClasses[400],
	Text:InfoBar = Text:INVALID_TEXT_DRAW,
	Text:MainMenu[4],
	zoneupdates[MAX_PLAYERS],
	player_zone[MAX_PLAYERS],
	lstring[28],
	Text:ZoneText[MAX_PLAYERS],
	ZnameTimer[MAX_PLAYERS],
	PlayerTaxi[MAX_PLAYERS],
	PlayerGiveCash[MAX_PLAYERS],
	InfoBarText[6][68]=
{
		{"~y~/help~b~ - General help dialog"},
		{"~y~/commands~b~ - Main commands list"},
		{"~y~/taxi~b~ - Taxi locations to various places"},
		{"~y~/rules~b~ - The server rules - read so you don't get kicked!"},
		{"~y~/stats~b~ - Information on your stats"},
		{"~y~Visit The Forum: ~b~www.world-gamerz.com"}
},
	HORIZONTAL_RULE[]=
	{"-------------------------------------------------------------------------------------------------------------------------"};
new const KEY_VEHICLE_FORWARD  = 0b001000,
          KEY_VEHICLE_BACKWARD = 0b100000;
static playerSafe[MAX_PLAYERS];//ship stuff
static seenSafeMsg[MAX_PLAYERS];
//---i have put this here to change later
//gmx	
new iGMXTimer,
	iGMXTick;
//================================================
native WP_Hash(buffer[], len, const str[]);
//================================================
main()
{
	printf("|---------------------------------------------|");
	printf("|                Introduction                 |");
	printf("|            OoO World-Gamerz OoO             |");
	printf("|        %s v%s        |",SERVER_NAME, DEVELOPMENT_VERSION);
	printf("|  *****************************************  |");
	printf("|                 Coded By                    |");
	printf("|  *****************************************  |");
	printf("|                fubar 2007                   |");
	#if defined DEBUG
	printf("|                                             |");
	printf("|  SERVER IS RUNNING DEBUG MODE,RUNAWAY!!!!!  |");
	printf("|                                             |");
	#else
		printf("|                                             |");
	#endif
	printf("|---------------------------------------------|");
	printf("\n");
}
//================================================
public OnGameModeInit()
{
//---MySql Database Connection----------------------
	mySQL_init();		
//-------------------------
	SetGameModeText(SERVER_SHORT_NAME " " DEVELOPMENT_VERSION);
	UsePlayerPedAnims();
	ShowPlayerMarkers(1);
	ShowNameTags(1);
		
	CreateDynamicMapIcon(2193.2351, 1990.9645, 12.2969, 52, 0 );//bank
	CreateDynamicMapIcon(2097.6602, 2223.3584, 11.0234, 52, 0 );//bank
	CreateDynamicMapIcon(1936.5438, 2307.1543, 10.8203, 52, 0 );//bank
	CreateDynamicMapIcon(2546.6885, 1971.7012, 10.8203, 52, 0 );//bank
	CreateDynamicMapIcon(2452.4104, 2064.3025, 10.8203, 52, 0 );//bank
	CreateDynamicMapIcon(2247.6313, 2397.0142, 10.8203, 52, 0 );//bank
	CreateDynamicMapIcon(2886.1011, 2452.4561, 11.0690, 52, 0 );//bank
	CreateDynamicMapIcon(1316.0446,-886.8361, 45.2266, 52, 0 );//bank
	CreateDynamicMapIcon(1840.2257,-1842.6796, 17.0780, 52, 0 );//bank
	CreateDynamicMapIcon(1352.4622,-1764.6715, 19.0781, 52, 0 );//bank
	CreateDynamicMapIcon(-1560.6624,-2728.3330, 53.7284, 52, 0 );//bank
	CreateDynamicMapIcon(-176.4104,1035.3038,24.0391, 52, 0 );//bank
	CreateDynamicMapIcon(2548.7024,2083.8706,15.6720, 6, 0); // Ammunation
	CreateDynamicMapIcon(2167.4358,941.3749,15.6720, 6, 0); // Ammunation
	CreateDynamicMapIcon(1373.2310,-1283.7960,33.5206, 6, 0); // Ammunation
	CreateDynamicMapIcon(244.8323,-179.1947,10.0963, 6, 0); // Ammunation
	CreateDynamicMapIcon(2332.5359,61.9584,32.0074, 6, 0); // Ammunation
	CreateDynamicMapIcon(773.8597,1873.7456,8.0957, 6, 0); // Ammunation
	CreateDynamicMapIcon(2637.6235,1849.7252,18.9774, 29, 0); // Well Stacked Pizza
	CreateDynamicMapIcon(2757.4653,2478.0925,17.6719, 29, 0); // Well Stacked Pizza
	CreateDynamicMapIcon(2352.1042,2536.3425,15.8785, 29, 0); // Well Stacked Pizza
	CreateDynamicMapIcon(2083.0996,2225.3306,21.1128, 29, 0); // Well Stacked Pizza
	CreateDynamicMapIcon(2639.3535,1671.2888,19.5971, 14, 0); // Cluckin' Bell	
	CreateDynamicMapIcon(2836.7253,2407.6592,17.6719, 14, 0); // Cluckin' Bell
	CreateDynamicMapIcon(2388.1992,2041.1128,20.5781, 14, 0); // Cluckin' Bell
	CreateDynamicMapIcon(2101.2788,2229.1450,21.1077, 14, 0); // Cluckin' Bell
	CreateDynamicMapIcon(1872.3909,2076.2988,18.4428, 10, 0); // Burger Shot
	CreateDynamicMapIcon(1154.4572,2075.4822,21.6273, 10, 0); // Burger Shot
	CreateDynamicMapIcon(2168.5938,2799.0249,21.3774, 10, 0); // Burger Shot
	CreateDynamicMapIcon(2473.3037,2032.2058,16.0938, 10, 0); // Burger Shot
	CreateDynamicMapIcon(2368.3657,2073.5598,20.5502, 10, 0); // Burger Shot
	
	CP1 = CreateDynamicCP(-1972.8381,118.6403,27.6940,3.0); // SF TRAIN
	CP2 = CreateDynamicCP(825.1868,-1354.8761,13.5398,3.0); //LS TRAIN
	CP3 = CreateDynamicCP(1743.0839,-1861.7540,13.5771,3.0); // UNITY STATION
	CP4 = CreateDynamicCP(2844.0889,1289.9536,11.3906,3.0); // LINDEN STATION
	CP5 = CreateDynamicCP(1432.8281,2641.1072,11.3926,3.0); // //LV TRAIN
	CP6 = CreateDynamicCP(-22.2549,-55.6575,1003.5469,2.0);  //BANK
	CP7 = CreateDynamicCP(2000.3132,1538.6012,13.5859,2.0); //PIRATE
	CP8 = CreateDynamicCP(2000.8953,1554.2316,14.4390,2.0); //CHILLIDOGS
	CP9 = CreateDynamicCP(291.0004,-84.5168,1001.515,2.0); //AMMUNATION
	CP10 = CreateDynamicCP(-795.0849,490.5323,1376.1953,2.0); //PAUZE
	CP11 = CreateDynamicCP(-362.6898,1585.7404,76.5326,3.0); // S-DISH
//---new player classes
	for ( new i = 0; i < sizeof ( ListPlayerClasses ); i++ )
	{
		sPlayerClasses [ i ] = ListPlayerClasses [ i ];
		AddPlayerClass ( ListPlayerClasses [ i ] , 1958.3783, 1343.1572, 15.3746,269.1425, 0, 0, 24, 300, -1, -1 );
		}
	
#include includes/spawn_car.pwn	
#include includes/objects.pwn	
#include includes/pickups.pwn

	SetTimer("MainTimer", 1000, 1);
	LoadTextDraws();
	
    PLAYER_SLOTS = GetMaxPlayers();//speed-up
    g_SpeedUpTimer = SetTimer("SpeedUp", 220, true);
    g_SpeedThreshold = SPEED_THRESHOLD * SPEED_THRESHOLD;    // Cache this value for speed,This can not be done during compilation because of a limitation with float values

	return 1;
}
//------------------------------------------------------------------------------
public OnGameModeExit()
{
	mysql_close(dConnect);// Close the handle. We're done here.
	KillTimer(g_SpeedUpTimer);//speed-up
}
//------------------------------------------------------------------------------
public OnPlayerRequestClass(playerid, classid)
{
	SetupPlayerForClassSelection(playerid);
	return 1;
}
//------------------------------------------------------------------------------
public SetupPlayerForClassSelection(playerid)
{
	PlayerPlaySound(playerid, 1185, 1679.6365,1448.2153,47.7813);//Cool
//	PlayAudioStreamForPlayer(playerid, SOUND_CLASSSELECT);
	SetPlayerInterior(playerid,2);
	SetPlayerPos(playerid,1221.1898,8.5500,1001.3356);
	SetPlayerFacingAngle(playerid, 135.0);
	SetPlayerCameraPos(playerid,1216.6071,4.9896,1001.5141);
	SetPlayerCameraLookAt(playerid,1221.1898,8.5500,1001.3356);
	new dance = random(13);
	switch(dance)
	{
    case 0: ApplyAnimation(playerid,"DANCING","DNCE_M_A",4.0,1,0,0,0,-1);
    case 1: ApplyAnimation(playerid,"DANCING","DNCE_M_B",4.0,1,0,0,0,-1);
    case 2: ApplyAnimation(playerid,"DANCING","DNCE_M_C",4.0,1,0,0,0,-1);
    case 3: ApplyAnimation(playerid,"DANCING","DNCE_M_D",4.0,1,0,0,0,-1);
    case 4: ApplyAnimation(playerid,"DANCING","DNCE_M_E",4.0,1,0,0,0,-1);
    case 5: ApplyAnimation(playerid,"benchpress","gym_bp_celebrate",4.0,1,0,0,0,-1);
    case 6: ApplyAnimation( playerid,"STRIP","strip_A",4.1,1,1,1,1,1);
    case 7: ApplyAnimation( playerid,"STRIP","strip_B",4.1,1,1,1,1,1);
    case 8: ApplyAnimation( playerid,"STRIP","strip_C",4.1,1,1,1,1,1);
    case 9: ApplyAnimation( playerid,"STRIP","strip_D",4.1,1,1,1,1,1);
    case 10: ApplyAnimation( playerid,"STRIP","strip_E",4.1,1,1,1,1,1);
    case 11: ApplyAnimation( playerid,"STRIP","strip_F",4.1,1,1,1,1,1);
    case 12: ApplyAnimation( playerid,"STRIP","strip_G",4.1,1,1,1,1,1);
	}
}
//------------------------------------------------------------------------------
public OnPlayerConnect(playerid)
{
	ToggleMainMenu(playerid, 1);
    GameTextForPlayer(playerid,"~w~World-Gamerz: ~r~San Andreas ~g~FreeRoam",5000,5);
	ResetPlayerVariables(playerid);
	SetPlayerColor(playerid,COLOR_WHITE);
	
	ZoneText[playerid] = TextDrawCreate(630.0, 380.0, "__");
	TextDrawAlignment(ZoneText[playerid], 3);
	TextDrawBackgroundColor(ZoneText[playerid], 255);
	TextDrawLetterSize(ZoneText[playerid], 0.880, 2.500);
	TextDrawSetProportional(ZoneText[playerid], 1);
	TextDrawColor(ZoneText[playerid],-1);
	TextDrawFont(ZoneText[playerid], 0);
	TextDrawSetOutline(ZoneText[playerid], 0);
	TextDrawSetProportional(ZoneText[playerid], 1);
	TextDrawSetShadow(ZoneText[playerid], 1);
	TextDrawHideForPlayer(playerid, ZoneText[playerid]);	

	return 1;
}
//------------------------------------------------------------------------------
public OnPlayerDisconnect(playerid, reason)
{
	new lStr[120],name[MAX_PLAYER_NAME];
	GetPlayerName(playerid,name,MAX_PLAYER_NAME);
	switch(reason){
		case 0: format(lStr,sizeof(lStr), ""#CBLUE"%s "#CDGREEN"Has Left The Server "#CRED"(Reason: Timed out/Crash)",name);
		case 1: format(lStr,sizeof(lStr), ""#CBLUE"%s "#CDGREEN"Has Left The Server "#CRED"(Reason: Leaving)",name);
		case 2: format(lStr,sizeof(lStr), ""#CBLUE"%s "#CDGREEN"Has Left The Server "#CRED"(Reason: Kicked/Banned)",name);}
	SendClientMessageToAll(COLOR_SLATEBLUE, lStr);
	
	if(IsPlayerLoggedIn(playerid))
	{
		SaveSaveablePlayerInfo(playerid);
		PlayerLeaveGang(playerid);
		ResetPlayerVariables(playerid);
	}
//car text draws
	TextDrawHideForPlayer(playerid, ZoneText[playerid]);
	zoneupdates[playerid] =0;
//end of car text draws
	return 1;
}
//------------------------------------------------------------------------------
public OnPlayerSpawn(playerid)
{
	ToggleMainMenu(playerid, 0);
	PlayerPlaySound(playerid, 1184,-752.7885,464.6060,1369.0648);
	if(playerVariables[playerid][UseSkin] == 1)
	{
		SetPlayerSkin(playerid,playerVariables[playerid][Skin]);
	}	
	if(!IsPlayerLoggedIn(playerid))
	{
		PlayerPlaySound(playerid, 1184,-752.7885,464.6060,1369.0648);
//		StopAudioStreamForPlayer(playerid);
		SetPlayerInterior(playerid, 12);
		SetPlayerVirtualWorld(playerid,((playerid % 50) + 1 ));
		SetPlayerFacingAngle(playerid, 0.0);
		SetCameraBehindPlayer(playerid);
		SetPlayerPos(playerid,2324.33,-1144.79,1050.71);
		SetPlayerHealth(playerid, 999999);
		playerVariables[playerid][FirstTimeSpawned] = 0;
		new szQuery[128];
		format(szQuery, sizeof(szQuery), "SELECT * FROM players WHERE Username = '%s'", playerVariables[playerid][PlayerName]);
		mysql_query(szQuery, THREAD_USERNAME_LOOKUP, playerid, dConnect);
		return 1;
	}
	
	SetPlayerInterior(playerid,0);
	// in jail?
	if(IsPlayerJailed(playerid))
	{
		SetPlayerJailSpawn(playerid);
		return 1;
	}
	//was player killed ???
	if(playerVariables[playerid][ResetToBackPos] == 1)
	{
		SetPlayerPos(playerid,playerVariables[playerid][BackPos][0], playerVariables[playerid][BackPos][1], playerVariables[playerid][BackPos][2]);
		playerVariables[playerid][ResetToBackPos] = 0;
	}
	else
	{
		SetPlayerRandomSpawn(playerid);
	}
	GiveMoney(playerid,playerVariables[playerid][pMoney]);
	if(GetPlayerMoney(playerid) <= 0)
	{
		GiveMoney(playerid, POCKETMONEY);
	}
	
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid,24,300);
	TextDrawShowForPlayer(playerid, InfoBar);
	return 1;
}
//------------------------------------------------------------------------------
public SetPlayerRandomSpawn(playerid)
{
	if (iSpawnSet[playerid] == 1)
	{
		new rand = random(sizeof(gCopPlayerSpawns));
		SetPlayerPos(playerid,
		gCopPlayerSpawns[rand][0],
		gCopPlayerSpawns[rand][1],
		gCopPlayerSpawns[rand][2]); // Warp the player
		SetPlayerFacingAngle(playerid,gCopPlayerSpawns[rand][3]);
		SetPlayerVirtualWorld(playerid,0);
    }
    else if (iSpawnSet[playerid] == 0)
    {
        new rand = random(sizeof(gRandomPlayerSpawns));
        SetPlayerPos(playerid,
		gRandomPlayerSpawns[rand][0],
		gRandomPlayerSpawns[rand][1],
		gRandomPlayerSpawns[rand][2]);// Warp the player
		SetPlayerFacingAngle(playerid,gRandomPlayerSpawns[rand][3]);
		SetPlayerVirtualWorld(playerid,0);
    }
    return 1;
}
//------------------------------------------------------------------------------
public OnPlayerDeath(playerid, killerid, reason)
{
	if(OnPlayerDeathByCheatkill(playerid, killerid, reason)) return 1;
	if(OnPlayerDeathInJail(playerid, killerid, reason)) return 1;
	if(OnPlayerDeathInInterior(playerid, killerid, reason)) return 1;
	if(OnPlayerDeathOnShip(playerid,killerid,reason)) return 1;
	new 
	playercash,
	string[90];
	
	playercash = GetPlayerMoney(playerid);
	if(playercash > 0)
	{
		ResetMoney(playerid);
	}
	SendDeathMessage(killerid,playerid,reason);
	playerVariables[playerid][Deaths]++;
		
	
	if(killerid == INVALID_PLAYER_ID) return 1;
	else
	{
		
		playerVariables[killerid][Kills]++;
		
		SetPlayerScore(killerid,GetPlayerScore(killerid)+1);
		
		if(playercash > 0 )
		{
			GiveMoney(killerid, playercash);
		}
		if(playerVariables[playerid][Bounty] > 0)
		{
			format(string, sizeof(string), "You have collected a bounty of $%d for killing %s.", playerVariables[playerid][Bounty], playerVariables[playerid][PlayerName]);
			SendClientMessage(killerid, COLOR_BLUEVIOLET, string);
			format(string, sizeof(string), "%s has collected a bounty of $%d for killing %s.", playerVariables[killerid][PlayerName], playerVariables[playerid][Bounty], playerVariables[playerid][PlayerName]);
			news(string);
			GiveMoney(killerid, playerVariables[playerid][Bounty]);
			playerVariables[playerid][Bounty] = 0;
		}
	}
	playerVariables[playerid][pMoney] = 0 ;
	TextDrawHideForPlayer(playerid, ZoneText[playerid]);//car & Zone stuff	
	zoneupdates[playerid] =0;
	return 1;
}
//------------------------------------------------------------------------------
public OnPlayerDeathInJail(playerid, killerid, reason)//PlayerDeathSpawn
{
	if(IsPlayerJailed(playerid))
	{
		SendDeathMessage(killerid,playerid,reason);
		if(killerid == INVALID_PLAYER_ID)
		{
			return 1;
		}
		else
		{
			SendClientMessage(playerid, COLOR_FIREBRICK, "You Killer has been jailed for longer.");
			Jail(killerid, 999);
			return 1;
		}
	}
	return 0;
}
//------------------------------------------------------------------------------
public OnPlayerDeathInInterior(playerid, killerid, reason)//PlayerDeathSpawn
{
	if(IsPlayerLoggedIn(playerid))
	{
		if(IsPlayerInInterior(playerid))
		{
			SendDeathMessage(killerid,playerid,reason);
			
			if(killerid == INVALID_PLAYER_ID)
			{
				if(GetPlayerMoney(playerid) > 0)
				{
					ResetMoney(playerid);
				}
				return 1;
			}
			else
			{
				SendClientMessage(playerid, COLOR_GREENYELLOW, "Your killer is put in prison.");
				Jail(killerid, 999);
				return 1;
			}
		}
	}
	return 0;
}
//------------------------------------------------------------------------------
public OnPlayerDeathOnShip(playerid,killerid,reason)//PlayerDeathSpawn
{
	if ((IsPlayerOnShip(playerid, areaShip) || isPlayerInArea(killerid, areaShip)) ||  (isPlayerInArea(playerid, areaRamp) || isPlayerInArea(killerid, areaRamp))) 
	{
		SendDeathMessage(killerid,playerid,reason);
		
		if(killerid == INVALID_PLAYER_ID)
		{
			if(GetPlayerMoney(playerid) > 0)
			{
				ResetMoney(playerid);
			}
			return 1;
		}
		else
		{
			SendClientMessage(playerid, COLOR_LAWNGREEN, "Because you where killed on the ship you can keep your money, ");
			SendClientMessage(playerid, COLOR_LAWNGREEN, "and go back to where you were and your killer goes to jail!");
			Jail(killerid, 999);
			GetPlayerPos(playerid, playerVariables[playerid][BackPos][0], playerVariables[playerid][BackPos][1], playerVariables[playerid][BackPos][2]);
			playerVariables[playerid][ResetToBackPos] = 1;
			return 1;
		}
	}
	return 0;
}
//------------------------------------------------------------------------------
public OnVehicleSpawn(vehicleid)
{
	return 1;
}
//------------------------------------------------------------------------------
public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}
//------------------------------------------------------------------------------
public OnPlayerText(playerid, text[])
{
	if(text[0] == '!') 
	{
		GangChat(playerid, text);
		return 0;
	}

	if(!IsPlayerLoggedIn(playerid)) 
	{
		SendClientMessage(playerid, COLOR_MAGENTA,"You can not talk until you are logged in.");
		return 0;
	}
	return 1;
}
//------------------------------------------------------------------------------
public OnPlayerCommandText(playerid, cmdtext[])
{
	return 0;
}
//------------------------------------------------------------------------------
public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
    if(!success) return SendClientMessage(playerid, COLOR_PALEGOLDENROD, "Even harry potter could'nt make that command work,try /help instead.");
	return 1;
}
//------------------------------------------------------------------------------
public OnPlayerPrivmsg(playerid, recipientid, text[])
{
	new outputmessage[256];
	
	format(outputmessage, sizeof(outputmessage),"PM to %s (%d): %s", playerVariables[recipientid][PlayerName], recipientid, text);
	SendClientMessage(playerid, COLOR_LORANGE, outputmessage);
	
	format(outputmessage, sizeof(outputmessage),"PM from %s (%d): %s", playerVariables[playerid][PlayerName], playerid, text);
	SendClientMessage(recipientid, COLOR_ORANGERED, outputmessage);
	
	return 0;
}
//------------------------------------------------------------------------------
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}
//------------------------------------------------------------------------------
public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}
//------------------------------------------------------------------------------
public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)// play an internet radio stream when they are in a vehicle
	{
	}
	else if(oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER)	// stop the internet stream
	{
		playerVariables[playerid][Speed] = 0;
	}
	if(oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER) // Player entered a vehicle as a driver	//car stuff
	{
	    carname(playerid);
	}
	if(newstate == PLAYER_STATE_ONFOOT)
	{
	}
}
//------------------------------------------------------------------------------
public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}
//------------------------------------------------------------------------------
public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}
//------------------------------------------------------------------------------
public OnRconCommand(cmd[])
{
	return 1;
}
//------------------------------------------------------------------------------
public OnPlayerRequestSpawn(playerid)
{
	return 1;
}
//------------------------------------------------------------------------------
public OnObjectMoved(objectid)
{
	return 1;
}
//------------------------------------------------------------------------------
public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}
//------------------------------------------------------------------------------
public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}
//------------------------------------------------------------------------------
public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}
//------------------------------------------------------------------------------
public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}
//------------------------------------------------------------------------------
public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}
//------------------------------------------------------------------------------
public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}
//------------------------------------------------------------------------------
public OnPlayerExitedMenu(playerid)
{
	return 1;
}
//------------------------------------------------------------------------------
public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}
//------------------------------------------------------------------------------
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}
//------------------------------------------------------------------------------
public OnRconLoginAttempt(ip[], password[], success)
{
	if(!success)
	{
		printf("FAILED RCON LOGIN BY IP %s USING PASSWORD %s",ip, password);
		new pip[16],
			reason[55];
		foreach(Player, i)
		{
			GetPlayerIp(i, pip, sizeof(pip));
			if(!strcmp(ip, pip, true))
			{
			reason = "Wrong Rcon Password so you got owned :D! FUCKER!!";
			KickPlayer(i, reason);//Maybe change to ban,when i have made one :-)
			}
		}
	}
	return 1;
}
//------------------------------------------------------------------------------
public OnPlayerUpdate(playerid)
{
	return 1;
}
//------------------------------------------------------------------------------
public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}
//------------------------------------------------------------------------------
public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}
//------------------------------------------------------------------------------
public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}
//------------------------------------------------------------------------------
public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}
//------------------------------------------------------------------------------
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
	new
	szMessage[128], 
	szMessage1[150];
	
	switch(dialogid)
	{
		case DIALOG_PLAY://If they dont want to register,well hell just let them play
		{
			if(response) // if they clicked play
			{
            format(szMessage1, sizeof(szMessage1), "SERVER RULES:\nDONT BUG ABUSE.\nCHEATS ARE NOT ALLOWED.\nNO KILLING IN INTERIORS.\nTHE SHIP IS A SAFE ZONE,NO KILLING\nUSE ENGLISH IN MAIN CHAT");
			ShowPlayerDialog(playerid, DIALOG_RULES, DIALOG_STYLE_MSGBOX, "Welcome To World-Gamerz", szMessage1, "Play","Cancel");
			}
			else // they clicked register
			{
            format(szMessage1, sizeof(szMessage1), "This account name (%s) is not yet registered. Please enter a password to register a new account.", playerVariables[playerid][PlayerName]);
			ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "SERVER: Register", szMessage1, "Register", "Cancel");
			}
			}
		case DIALOG_REGISTER:
		{
			if(!response)
			{
			format(szMessage, sizeof(szMessage), "SERVER: You have cancelled registration for user name (%s).", playerVariables[playerid][PlayerName]);
			SendClientMessage(playerid, COLOR_RED, szMessage);
			return 1;
			}				
			if(strlen(inputtext) > MAX_PASSWORD_LENGTH || strlen(inputtext) < MIN_PASSWORD_LENGTH) 
			{
				format(szMessage, sizeof(szMessage), "SERVER: Your password must be under %d and above %d characters.", MAX_PASSWORD_LENGTH, MIN_PASSWORD_LENGTH);
				SendClientMessage(playerid, COLOR_RED, szMessage);
				format(szMessage, sizeof(szMessage), "SERVER: This account (%s) is not yet registered. Please enter a password to register a new account.", playerVariables[playerid][PlayerName]);
				ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "SERVER: Register", szMessage, "Register", "Cancel");
				} 
				else
				{
				new	szQuery[256];
				WP_Hash(playerVariables[playerid][pPassword], 129, inputtext);
				GetPlayerIp(playerid, playerVariables[playerid][pIP], 32);
				new string[64],Year, Month, Day;
				getdate(Year, Month, Day);
				format(string, sizeof(string), "%02d,%s,%d", Day, GetMonth(Month), Year);
				format(szQuery, sizeof(szQuery), "INSERT INTO players (Username, Password, IP, DateRegistered) VALUES ('%s', '%s', '%s', '%s')", playerVariables[playerid][PlayerName], playerVariables[playerid][pPassword], playerVariables[playerid][pIP],string);
				mysql_query(szQuery, THREAD_USERNAME_REGISTER, playerid, dConnect);
			}
		}
		case DIALOG_REGISTER2://i realy dont know why i made 2 register's,i will check out at a later date
		{
			if(!response)
			{
			format(szMessage, sizeof(szMessage), "SERVER: You have cancelled registration for user name (%s).", playerVariables[playerid][PlayerName]);
			SendClientMessage(playerid, COLOR_RED, szMessage);
			return 1;
			}
			if(strlen(inputtext) > MAX_PASSWORD_LENGTH || strlen(inputtext) < MIN_PASSWORD_LENGTH) 
			{
				format(szMessage, sizeof(szMessage), "SERVER: Your password must be under %d and above %d characters.", MAX_PASSWORD_LENGTH, MIN_PASSWORD_LENGTH);
				SendClientMessage(playerid, COLOR_RED, szMessage);
				format(szMessage, sizeof(szMessage), "SERVER: This account (%s) is not yet registered. Please enter a password to register a new account.", playerVariables[playerid][PlayerName]);
				ShowPlayerDialog(playerid, DIALOG_REGISTER2, DIALOG_STYLE_PASSWORD, "SERVER: Register", szMessage, "Register", "Cancel");
				} 
				else
				{
				new	szQuery[256];
				WP_Hash(playerVariables[playerid][pPassword], 129, inputtext);
				GetPlayerIp(playerid, playerVariables[playerid][pIP], 32);
				new string[64],Year, Month, Day;
				getdate(Year, Month, Day);
				format(string, sizeof(string), "%02d,%s,%d", Day, GetMonth(Month), Year);
				format(szQuery, sizeof(szQuery), "INSERT INTO players (Username, Password, IP, DateRegistered) VALUES ('%s', '%s', '%s', '%s')", playerVariables[playerid][PlayerName], playerVariables[playerid][pPassword], playerVariables[playerid][pIP],string);
				mysql_query(szQuery, THREAD_NO_RESULT, playerid, dConnect);
				RegisterPlayedPlayer(playerid);
			}
		}
		case DIALOG_LOGIN:
		{
			if(!response)
			{
            new reason[50];
			reason = "You have failed to login idiot.";
			KickPlayer(playerid, reason);
			}			
			new HashedPassword[129];
			WP_Hash(HashedPassword, 129, inputtext);
			if(!strcmp(playerVariables[playerid][pPassword], HashedPassword, true, 128))
			{
				playerVariables[playerid][PlayerStatus] = 1;
				clearScreen(playerid);
				SendClientMessage(playerid, COLOR_TOMATO, "SERVER: You have now logged in to the server.");
				LoginPlayer(playerid);
				} 
				else
				{
				SetPVarInt(playerid, "IPA", GetPVarInt(playerid, "IPA") + 1);
				
				if(GetPVarInt(playerid, "IPA") == MAX_INCORRECT_PASSWORD_ATTEMPTS) 
				{
					SendClientMessage(playerid, COLOR_MEDIUMPURPLE, "SERVER: You have entered an incorrect password too many times. You'll now be banned.");
					Ban(playerid);
					printf("%s has been banned for reaching %d failed login attempts.", playerVariables[playerid][PlayerName], MAX_INCORRECT_PASSWORD_ATTEMPTS);
					} 
					else
					{
					format(szMessage, sizeof(szMessage), "SERVER: You have %d attempts left before you're banned.", MAX_INCORRECT_PASSWORD_ATTEMPTS - GetPVarInt(playerid, "IPA"));
					SendClientMessage(playerid, COLOR_MEDIUMPURPLE, szMessage);
					format(szMessage, sizeof(szMessage), "This account (%s) is registered.\n\nPlease enter the account password to login.\n\nIf you did not register this account , please pick another name.", playerVariables[playerid][PlayerName]);
					ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "SERVER: Login", szMessage, "Login", "Cancel");
				}
			}
		}
		case DIALOG_RULES:
		{
			if(response) // if they clicked play
			{
            SendClientMessage(playerid, COLOR_MEDIUMVIOLETRED, "Thank you for agreeing to the server rules!");
			Playerplay(playerid);
			}
			else // Pressed ESC or clicked cancel
			{
            new reason[50];
			reason = "You MUST agree to the server rules to play here.";
			KickPlayer(playerid, reason);
			}
			}
 		case DIALOG_CRANBERRY:// Cranberry Station
		{
			if(!response)
			{
				return SendClientMessage(playerid,COLOR_MEDIUMVIOLETRED,"Train Ticket Cancelled!");
			}
			switch(listitem)
			{
				case 0:// Yellow Bell Station
				{
					TrainPlayer(playerid,0);
				}
				case 1: // Linden Station(LV)
				{
					TrainPlayer(playerid,1);
				}
				case 2: // Market Station(LS)
				{
					TrainPlayer(playerid,2);
				}
				case 3: // Unity Station(LS)
				{
					TrainPlayer(playerid,3);
				}
			}
			
		}
		case DIALOG_UNITY:// Unity Station(LS)
		{
			if(!response)
			{
				return SendClientMessage(playerid,COLOR_MEDIUMVIOLETRED,"Train Ticket Cancelled!");
			}
			switch(listitem)
			{
				case 0:// Yellow Bell Station
				{
					TrainPlayer(playerid,0);
				}
				case 1: // Linden Station(LV)
				{
					TrainPlayer(playerid,1);
				}
				case 2: // Market Station(LS)
				{
					TrainPlayer(playerid,2);
				}
				case 3: // Cranberry Station
				{
					TrainPlayer(playerid,4);
				}
			}
			
		}
		case DIALOG_MARKET:// Market Station(LS)
		{
			if(!response)
			{
				return SendClientMessage(playerid,COLOR_MEDIUMVIOLETRED,"Train Ticket Cancelled!");
			}
			switch(listitem)
			{
				case 0:// Yellow Bell Station
				{
					TrainPlayer(playerid,0);
				}
				case 1: // Linden Station(LV)
				{
					TrainPlayer(playerid,1);
				}
				case 2: // Unity Station(LS)
				{
					TrainPlayer(playerid,3);
				}
				case 3: // Cranberry Station
				{
					TrainPlayer(playerid,4);
				}
			}
			
		}
		case DIALOG_LINDEN:// Linden Station(LV)
		{
			if(!response)
			{
				return SendClientMessage(playerid,COLOR_MEDIUMVIOLETRED,"Train Ticket Cancelled!");
			}
			switch(listitem)
			{
				case 0:// Yellow Bell Station
				{
					TrainPlayer(playerid,0);
				}
				case 1: // Market Station(LS)
				{
					TrainPlayer(playerid,2);
				}
				case 2: // Unity Station(LS)
				{
					TrainPlayer(playerid,3);
				}
				case 3: // Cranberry Station
				{
					TrainPlayer(playerid,4);
				}
			}
			
		}
		case DIALOG_YBELL:// Yellow Bell Station
		{
			if(!response)
			{
				return SendClientMessage(playerid,COLOR_MEDIUMVIOLETRED,"Train Ticket Cancelled!");
			}
			switch(listitem)
			{
				case 0:// Linden Station(LV)
				{
					TrainPlayer(playerid,1);
				}
				case 1: // Market Station(LS)
				{
					TrainPlayer(playerid,2);
				}
				case 2: // Unity Station(LS)
				{
					TrainPlayer(playerid,3);
				}
				case 3: // Cranberry Station
				{
					TrainPlayer(playerid,4);
				}
			}
		}
		case DIALOG_TAXI:// San Andreas Taxi's
		{
			if(!response)
			{
				return SendClientMessage(playerid,COLOR_MEDIUMVIOLETRED,"Taxi Cancelled!");
			}
			switch(listitem)
			{
				case 0:// Pirate ship
				{
					TaxiPlayer(playerid,0);
				}
				case 1: // Yellow Bell Station(LV)
				{
					TaxiPlayer(playerid,1);
				}
				case 2: // Linden Station(LV)
				{
					TaxiPlayer(playerid,2);
				}
				case 3: // Market Station(LS)
				{
					TaxiPlayer(playerid,3);
				}
				case 4:// Unity Station(LS)
				{
					TaxiPlayer(playerid,4);
				}
				case 5: // Cranberry Station(SF)
				{
					TaxiPlayer(playerid,5);
				}
				case 6: // Las Venturas Airport
				{
					TaxiPlayer(playerid,6);
				}
				case 7: // prison
				{
					TaxiPlayer(playerid,7);
				}
				case 8:// Grove Street
				{
					TaxiPlayer(playerid,8);
				}
				case 9: // Wang Cars
				{
					TaxiPlayer(playerid,9);
				}
				case 10: // Mount Chilliad
				{
					TaxiPlayer(playerid,10);
				}
				case 11: // unknnown
				{
					TaxiPlayer(playerid,11);
				}
				case 12:// Ammunition
				{
					TaxiPlayer(playerid,12);
				}
				case 13: // Ammunition2
				{
					TaxiPlayer(playerid,13);
				}
				case 14: // Area 69
				{
					TaxiPlayer(playerid,14);
				}
				case 15: // Airstrip
				{
					TaxiPlayer(playerid,15);
				}
				case 16:// Fort Carson
				{
					TaxiPlayer(playerid,16);
				}
				case 17: // Las Barrancas
				{
					TaxiPlayer(playerid,17);
				}
				case 18: // El Quebrados
				{
					TaxiPlayer(playerid,18);
				}
				case 19: // Las Payasadas
				{
					TaxiPlayer(playerid,19);
				}
				case 20:// Bayside
				{
					TaxiPlayer(playerid,20);
				}
				case 21: // Palomino Creek
				{
					TaxiPlayer(playerid,21);
				}
				case 22: // Hampton Barns
				{
					TaxiPlayer(playerid,22);
				}
				case 23: // Blueberry
				{
					TaxiPlayer(playerid,23);
				}
				case 24:// Dillimore
				{
					TaxiPlayer(playerid,24);
				}
				case 25: // Leafy Hollow
				{
					TaxiPlayer(playerid,25);
				}
				case 26: // Los Santos Airport
				{
					TaxiPlayer(playerid,26);
				}
				case 27: // KACC Military Fuels
				{
					TaxiPlayer(playerid,27);
				}
				case 28:// Angel Pine
				{
					TaxiPlayer(playerid,28);
				}
				case 29: // Easter Bay Airport
				{
					TaxiPlayer(playerid,29);
				}
				case 30: // San Fierro Airport
				{
					TaxiPlayer(playerid,31);
				}
				case 31: // Downtown Los Santos
				{
					TaxiPlayer(playerid,32);
				}
				case 32:// Los Santos Basejumping
				{
					TaxiPlayer(playerid,33);
				}
				case 33: // for extra taxi points
				{
					//					TaxiPlayer(playerid,?);
				}
				case 34: //
				{
					//					TaxiPlayer(playerid,?);
				}
				case 35: //
				{
					//					TaxiPlayer(playerid,?);
				}
			}
			
		}
		case DIALOG_BANK:// San Andreas Bank
		{
			if(!response)
			{
				return SendClientMessage(playerid,COLOR_MEDIUMVIOLETRED,"You Have Cancelled The Bank Transation!");
			}
			switch(listitem)
			{
				case 0:// Deposit
				{
					new string[60];
					format(string, sizeof(string),"\nDeposit Money \n\n Please Type How Much To Deposit Here.");
					ShowPlayerDialog(playerid, DIALOG_DEPOSIT, DIALOG_STYLE_INPUT,"Ammount to Deposit", string, "Process", "Cancel");
				}
				case 1: // withdraw
				{
					new string[60];
					format(string, sizeof(string),"\nWithdraw Money \n\n Please Type How Much You Want to Withdraw.");
					ShowPlayerDialog(playerid, DIALOG_WITHDRAW, DIALOG_STYLE_INPUT,"Ammount to withdraw", string, "Process", "Cancel");
				}
				case 2: // balance
				{
					new string[60];
					format(string, sizeof(string), "You have $%d in the bank.", playerVariables[playerid][Bank]);
					ShowPlayerDialog(playerid, DIALOG_BALANCE, DIALOG_STYLE_MSGBOX, "San Andreas bank", string, "Close", "");
				}
				case 3: // Gang Deposit
				{
					if(playerVariables[playerid][Gang]==999)
					{
						SendClientMessage(playerid, COLOR_MEDIUMVIOLETRED, "You're not in a gang!");
						return 1;
					}
					new string[60];
					format(string, sizeof(string),"\nDeposit Gang Money \n\n Please Type How Much To Deposit Here.");
					ShowPlayerDialog(playerid, DIALOG_GANG_DEPOSIT, DIALOG_STYLE_INPUT,"Ammount to Deposit", string, "Process", "Cancel");
				}
				case 4: // Gang Withdraw
				{
					if(playerVariables[playerid][Gang]==999)
					{
						SendClientMessage(playerid, COLOR_MEDIUMVIOLETRED, "You're not in a gang!");
						return 1;
					}
					new string[60];
					format(string, sizeof(string),"\nWithdraw Gang Money \n\n Please Type How Much To withdraw Here.");
					ShowPlayerDialog(playerid, DIALOG_GANG_WITHDRAW, DIALOG_STYLE_INPUT,"Ammount to withdraw", string, "Process", "Cancel");
					
				}
				case 5: // Gang balance
				{
					if(playerVariables[playerid][Gang]==999)
					{
						SendClientMessage(playerid, COLOR_MEDIUMVIOLETRED, "You're not in a gang!");
						return 1;
					}
					new string[60];
					format(string, sizeof(string), "You're gang has $%d in the bank.", GangInfo[playerVariables[playerid][Gang]][GangBank]);
					ShowPlayerDialog(playerid, DIALOG_BALANCE, DIALOG_STYLE_MSGBOX, "San Andreas bank", string, "Close", "");
				}
			}
		}
		case DIALOG_DEPOSIT://Deposit
		{
			if(response)
			{
				if(playerVariables[playerid][PlayerStatus] == 0)
				{
					SendClientMessage(playerid, COLOR_MEDIUMVIOLETRED, "You must be logged in to use this command");
					return 1;
				}
				
				new tmp[256],moneys,idx,string[80];
				tmp = strtok(inputtext, idx);
				moneys = strval(tmp);
				
				if(moneys < 1) 
				{
					SendClientMessage(playerid, COLOR_MEDIUMVIOLETRED, "Say what are you doing?");
					return 1;
				}
				
				if(GetPlayerMoney(playerid) < moneys) 
				{
					moneys = GetPlayerMoney(playerid);
				}
				
				GiveMoney(playerid, -moneys);
				playerVariables[playerid][Bank] +=moneys;
				format(string, sizeof(string), "You have Deposited $%d in youre bank.\n\n Your bank balance is now $%d.", moneys ,playerVariables[playerid][Bank]);
				ShowPlayerDialog(playerid, DIALOG_MSGBOX, DIALOG_STYLE_MSGBOX, "San Andreas bank", string, "Close", "");
				return 1;
			}
			return 1;
		}
		
		case DIALOG_WITHDRAW://Bank Withdraw
		{
			if(response)
			{
				if(playerVariables[playerid][PlayerStatus] == 0)
				{
					SendClientMessage(playerid, COLOR_MEDIUMVIOLETRED, "You must be logged in to use this command");
					return 1;
				}
				new tmp[256],moneys,idx,string[80];
				tmp = strtok(inputtext, idx);
				moneys = strval(tmp);
				
				if(moneys < 1)
				{
					SendClientMessage(playerid, COLOR_MEDIUMVIOLETRED, "Say what are you doing?");
					return 1;
				}
				
				{
					if(moneys > playerVariables[playerid][Bank])
						moneys = playerVariables[playerid][Bank];
				}
				
				GiveMoney(playerid, moneys);
				playerVariables[playerid][Bank] -= moneys;
				format(string, sizeof(string), "you Have Withdrawn $%d from youre bank, your balance is now $%d.", moneys, playerVariables[playerid][Bank]);
				ShowPlayerDialog(playerid, DIALOG_MSGBOX, DIALOG_STYLE_MSGBOX, "San Andreas bank", string, "Close", "");
				return 1;
			}
			return 1;
		}
		
		case DIALOG_GANG_DEPOSIT://Gang Bank Deposit
		{
			if(response)
			{
				if(playerVariables[playerid][PlayerStatus] == 0)
				{
					SendClientMessage(playerid, COLOR_MEDIUMVIOLETRED, "You must be logged in to use this command");
					return 1;
				}
				if(playerVariables[playerid][Gang]==999)
				{
					SendClientMessage(playerid, COLOR_MEDIUMVIOLETRED, "You're not in a gang!");
					return 1;
				}
				
				new tmp[256],moneys,idx,string[80];
				tmp = strtok(inputtext, idx);
				moneys = strval(tmp);
				
				if(moneys < 1) 
				{
					SendClientMessage(playerid, COLOR_MEDIUMVIOLETRED, "Say what are you doing?");
					return 1;
				}
				
				if(GetPlayerMoney(playerid) < moneys)
				{
					moneys = GetPlayerMoney(playerid);
				}
				
				GiveMoney(playerid, -moneys);
				GangInfo[playerVariables[playerid][Gang]][GangBank]+=moneys;
				format(string, sizeof(string), "You have Deposited $%d in youre gang bank.\n\n Your gang bank balance is now $%d.", moneys, GangInfo[playerVariables[playerid][Gang]][GangBank]);
				ShowPlayerDialog(playerid, DIALOG_MSGBOX, DIALOG_STYLE_MSGBOX, "San Andreas bank", string, "Close", "");
				return 1;
			}
			return 1;
		}
		
		case DIALOG_GANG_WITHDRAW://Gang Bank Withdraw
		{
			if(response)
			{
				if(playerVariables[playerid][PlayerStatus] == 0)
				{
					SendClientMessage(playerid, COLOR_MEDIUMVIOLETRED, "You must be logged in to use this command");
					return 1;
				}
				new tmp[256],moneys,idx,string[80];
				tmp = strtok(inputtext, idx);
				moneys = strval(tmp);
				
				if(moneys < 1) 
				{
					SendClientMessage(playerid, COLOR_MEDIUMVIOLETRED, "Say what are you doing?");
					return 1;
				}
				
				{
					if(moneys > GangInfo[playerVariables[playerid][Gang]][GangBank])
						moneys = GangInfo[playerVariables[playerid][Gang]][GangBank];
				}
				
				GiveMoney(playerid, moneys);
				GangInfo[playerVariables[playerid][Gang]][GangBank] -= moneys;
				format(string, sizeof(string), "you Have Withdrawn $%d from youre gangbank, your gang balance is now $%d.", moneys, playerVariables[playerid][Bank]);
				ShowPlayerDialog(playerid, DIALOG_MSGBOX, DIALOG_STYLE_MSGBOX, "San Andreas bank", string, "Close", "");
				return 1;
			}
			return 1;
		}
		//--GANGS--------------------------------------------------------------------------------------------------
		case DIALOG_GANG:// San Andreas Gang
		{
			if(!response)
			{
				return SendClientMessage(playerid,COLOR_MEDIUMVIOLETRED,"You Have Cancelled The Gang Commands!");
			}
			switch(listitem)
			{
				case 0:// Gang create
				{
					new string[60];
					format(string, sizeof(string),"\nCreate A New Gang \n\n Please Type The Gang Name Here.");
					ShowPlayerDialog(playerid, DIALOG_GANG_CREATE, DIALOG_STYLE_INPUT,"Gang Name", string, "Process", "Cancel");
				}
				case 1: // Gang join
				{
					new string[70];
					format(string, sizeof(string),"\nJoin A Gang \n\n Please Type The Gang Name Here You Want To Join.");
					ShowPlayerDialog(playerid, DIALOG_GANG_JOIN, DIALOG_STYLE_INPUT,"Gang Join", string, "Process", "Cancel");
				}
				case 2: // Gang invite
				{
					new string[118];
					format(string, sizeof(string),"\nInvite A New Gang Member \n\n Please Type The PlayerID Here You Want To Invite\n(use tab button to find PlayerID).");
					ShowPlayerDialog(playerid, DIALOG_GANG_INVITE, DIALOG_STYLE_INPUT,"Gang Invite", string, "Process", "Cancel");
				}
				case 3: // Gang quit
				{
					new string[130];
					format(string, sizeof(string),"\nLeave Your Gang \n\nSo your going to leave your gang \n\nTo quit press the quit button \n\nor to cancel,just press cancel.");
					ShowPlayerDialog(playerid, DIALOG_GANG_QUIT, DIALOG_STYLE_MSGBOX, "Gang quit", string, "Quit", "Cancel");
				}
			}
		}
		case DIALOG_GANG_CREATE://Gang create
		{
			if(response)
			{
				new tmp[256],idx;
				tmp = strtok(inputtext, idx);
				PlayerCreateGang(playerid, tmp);
				return 1;
			}
			return 1;
		}
		case DIALOG_GANG_JOIN://Gang join
		{
			if(response)
			{
				new tmp[256],idx;
				tmp = strtok(inputtext, idx);
				PlayerJoinGang(playerid);
				return 1;
			}
			return 1;
		}
		case DIALOG_GANG_INVITE://Gang invite
		{
			if(response)
			{
				new tmp[256],idx;
				tmp = strtok(inputtext, idx);
				new giveplayerid = strval(tmp);
				PlayerInviteToGang(playerid, giveplayerid);
				return 1;
			}
			return 1;
		}
		case DIALOG_GANG_QUIT://Gang quit
		{
			if(response)
			{
				new tmp[256],idx;
				tmp = strtok(inputtext, idx);
				PlayerLeaveGang(playerid);
				return 1;
			}
			return 1;
		}
		case DIALOG_SPEED:// Speed Boost
		{
				if(!response)
				{
					return SendClientMessage(playerid,COLOR_YELLOW,"Vehicle Speed Control Canceled!");
				}
				switch(listitem)
				{
					case 0:// Vehicle Speed Normal
					{
						playerVariables[playerid][Speed] = 0;
					}
					case 1: //Vehicle Speed Faster
					{
						playerVariables[playerid][Speed] = 1;
					}
				}
			}
		case DIALOG_BUG_REPORT: 
		{
				if(!response)
				{
					format(szMessage, sizeof(szMessage), "SERVER: You have cancelled the bug report.");
					SendClientMessage(playerid, COLOR_MEDIUMVIOLETRED, szMessage);
					return 1;
				}
				if(strlen(inputtext) > MAX_BUG_LENGTH || strlen(inputtext) < MIN_BUG_LENGTH)
				{
					format(szMessage, sizeof(szMessage), "SERVER: Your report must be under %d and above %d characters.", MAX_BUG_LENGTH, MIN_BUG_LENGTH);
					SendClientMessage(playerid, COLOR_MEDIUMVIOLETRED, szMessage);
					format(szMessage, sizeof(szMessage), "SERVER: Your about to submit a bug report,make sure you give clear description on what bug your reporting.");
					ShowPlayerDialog(playerid, DIALOG_BUG_REPORT, DIALOG_STYLE_INPUT, "SERVER: Bug Report", szMessage, "Submit", "Cancel");
				}
				else
				{
					new szQuery[512],string[64],Hour, Minute, Second,Year, Month, Day,time[128],playername[MAX_PLAYER_NAME];
					gettime(Hour, Minute, Second);
					getdate(Year, Month, Day);
					GetPlayerName(playerid, playername, sizeof(playername));
					new SQL_name[MAX_PLAYER_NAME];
					mysql_real_escape_string(playername, SQL_name);
					format(time, sizeof(time), "%02d:%02d:%02d on %02d/%02d/%d", Hour, Minute, Second, Day, Month, Year);
					format(szQuery, sizeof(szQuery), "INSERT INTO bugs (Time, Reason, Name) VALUES ('%s', '%s', '%s')",time,inputtext,playername);
					mysql_query(szQuery, THREAD_NO_RESULT, playerid, dConnect);
					format(string, sizeof(string), "Your Bug Report has been collected. Thank You");
					SendClientMessage(playerid, COLOR_ORCHID, string);
				}
			}
		case DIALOG_GMX:
		{
			if(IsPlayerAdmin(playerid))
			{
				if(!response)
					return SendClientMessage(playerid, COLOR_GREY, "Restart attempt canned.");
				SendClientMessage(playerid, COLOR_YELLOW, "---- SERVER RESTART ----");
				SendClientMessage(playerid, COLOR_WHITE, "Restarting timer activated.");
				iGMXTick = 11;
				iGMXTimer = SetTimer("restartTimer", 1000, true);
				return SendClientMessage(playerid, COLOR_YELLOW, "---- SERVER RESTART ----");
			}
		}
		}
	return 1;
}
//------------------------------------------------------------------------------
public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
//------------------------------------------------------------------------------
public OnQueryFinish(query[], resultid, extraid, connectionHandle)
{
	new szMessage[193],szQuery[256];              // Increase based on the size of queries you write
	#pragma unused szQuery
	
	switch(resultid)
	{
		case THREAD_USERNAME_LOOKUP:
		{
			mysql_store_result(connectionHandle);
			if(mysql_num_rows(connectionHandle) > 0)
			{
				mysql_retrieve_row();
				new szReturn[256];//128
				mysql_fetch_field_row(playerVariables[extraid][pPassword], "Password", connectionHandle);
				
				mysql_fetch_field_row(szReturn, "ID", connectionHandle);
				playerVariables[extraid][pDBID] = strval(szReturn);
				
				mysql_fetch_field_row(szReturn, "DateRegistered", connectionHandle);
				playerVariables[extraid][RegDate] = strval(szReturn);
				
				mysql_fetch_field_row(szReturn, "cash", connectionHandle);
				playerVariables[extraid][pMoney] = strval(szReturn);
				
				mysql_fetch_field_row(szReturn, "bank", connectionHandle);
				playerVariables[extraid][Bank] = strval(szReturn);
				
				mysql_fetch_field_row(szReturn, "jailTime", connectionHandle);
				playerVariables[extraid][JailTime] = strval(szReturn);
				
				mysql_fetch_field_row(szReturn, "ingameTime", connectionHandle);
				playerVariables[extraid][IngameTime] = strval(szReturn);
				
				mysql_fetch_field_row(szReturn, "kills", connectionHandle);
				playerVariables[extraid][Kills] = strval(szReturn);
				
				mysql_fetch_field_row(szReturn, "deaths", connectionHandle);
				playerVariables[extraid][Deaths] = strval(szReturn);
				
				mysql_fetch_field_row(szReturn, "jails", connectionHandle);
				playerVariables[extraid][Jails] = strval(szReturn);
				
				mysql_fetch_field_row(szReturn, "kicks", connectionHandle);
				playerVariables[extraid][Kicks] = strval(szReturn);
				
				mysql_fetch_field_row(szReturn, "skin", connectionHandle);
				playerVariables[extraid][Skin] = strval(szReturn);
				
				mysql_fetch_field_row(szReturn, "useskin", connectionHandle);
				playerVariables[extraid][UseSkin] = strval(szReturn);
				
				playerVariables[extraid][PlayerStatus] = 2;
				mysql_free_result(connectionHandle);
				format(szMessage, sizeof(szMessage), "This account name (%s) is registered.\n\nPlease enter the account password to login.\n\nIf you did not register this account \n\nbeforehand, please pick another name.", playerVariables[extraid][PlayerName]);
				ShowPlayerDialog(extraid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "SERVER: Login", szMessage, "Login", "Cancel");
			}
			else 
			{
				new playerIP[32],queryString[128];//check to see if ip is already registered
				GetPlayerIp(extraid, playerIP, sizeof(playerIP));
				format(queryString, sizeof(queryString), "SELECT `IP` FROM `players` WHERE `IP` = '%s'", playerIP);
				mysql_query(queryString, THREAD_CHECK_IP, extraid,dConnect);
				//end of check carry on
				// Not registered? Let's tell them.
				format(szMessage, sizeof(szMessage), "SERVER: This Account name (%s) is not yet registered. You can register This account or \njust play without registering.", playerVariables[extraid][PlayerName]);
				ShowPlayerDialog(extraid, DIALOG_PLAY, DIALOG_STYLE_MSGBOX, "SERVER: Play or Register Account", szMessage, "Play", "Register");
			}
		}
		case THREAD_USERNAME_REGISTER:
		{
			playerVariables[extraid][pDBID] = mysql_insert_id(dConnect);
			
			new szFormulateQuery[64];
			
			format(szFormulateQuery, sizeof(szFormulateQuery), "SELECT * FROM players WHERE ID = %d", playerVariables[extraid][pDBID]);
			mysql_query(szFormulateQuery, THREAD_REGISTER_SPAWN, extraid, dConnect);
		}
		
		case THREAD_REGISTER_SPAWN:
		{
			mysql_store_result(dConnect);
			mysql_retrieve_row();
			new szReturn[64];

			mysql_fetch_field_row(szReturn, "cash", connectionHandle);
			playerVariables[extraid][pMoney] = strval(szReturn);
			
			mysql_fetch_field_row(szReturn, "bank", connectionHandle);
			playerVariables[extraid][Bank] = strval(szReturn);
			
			mysql_fetch_field_row(szReturn, "jailTime", connectionHandle);
			playerVariables[extraid][JailTime] = strval(szReturn);
			
			mysql_fetch_field_row(szReturn, "ingameTime", connectionHandle);
			playerVariables[extraid][IngameTime] = strval(szReturn);
			
			mysql_fetch_field_row(szReturn, "kills", connectionHandle);
			playerVariables[extraid][Kills] = strval(szReturn);
			
			mysql_fetch_field_row(szReturn, "deaths", connectionHandle);
			playerVariables[extraid][Deaths] = strval(szReturn);
			
			mysql_fetch_field_row(szReturn, "jails", connectionHandle);
			playerVariables[extraid][Jails] = strval(szReturn);
			
			mysql_fetch_field_row(szReturn, "kicks", connectionHandle);
			playerVariables[extraid][Kicks] = strval(szReturn);
			
			mysql_fetch_field_row(szReturn, "gang", connectionHandle);
			playerVariables[extraid][Gang] = strval(szReturn);
			
			mysql_fetch_field_row(szReturn, "skin", connectionHandle);
			playerVariables[extraid][Skin] = strval(szReturn);
				
			mysql_fetch_field_row(szReturn, "useskin", connectionHandle);
			playerVariables[extraid][UseSkin] = strval(szReturn);			
			
			mysql_free_result(dConnect);
			
			clearScreen(extraid);
			playerVariables[extraid][PlayerStatus] = 1;
			CheckPlayerRank(extraid);
			RegisterPlayer(extraid);
		}
		case THREAD_NO_RESULT:
		{
		}
		case THREAD_CHANGE_NAME:
		{
			new oldName[MAX_PLAYER_NAME];
			
			GetPVarString(extraid, "oldName", oldName, sizeof(oldName));
			
			SetPlayerName(extraid, playerVariables[extraid][PlayerName]);
			
			format(szMessage, sizeof(szMessage), "You've changed %s's name to %s.", oldName, playerVariables[extraid][PlayerName]);
			SendClientMessage(GetPVarInt(extraid, "changeBy"), COLOR_LIGHTSLATEGRAY, szMessage);
			
			format(szMessage, sizeof(szMessage), "Your name has been changed to %s by %s.", playerVariables[extraid][PlayerName], playerVariables[GetPVarInt(extraid, "changeBy")][PlayerName]);
			SendClientMessage(extraid, COLOR_LIGHTSEAGREEN, szMessage);
			
			DeletePVar(extraid, "oldName");
			DeletePVar(extraid, "changeBy");
			
		}
		case THREAD_CHECK_IP:
		{
			mysql_store_result(connectionHandle);
			if(mysql_num_rows() >= 2) {
				new reason[110];
				reason = "This ip is already registered on this server,Please use your other account \nor ask for help on the forum.";
				KickPlayer(extraid, reason);
			}
			else
			{
			//lets do nothing,i like
			}
			
			mysql_free_result(connectionHandle);
		}
	}
	return 1;
}
//------------------------------------------------------------------------------
public news(message[])//news-message/im going to send this to irc @ some point
{
	new string[256];
	SendClientMessageToAll(COLOR_LIME, HORIZONTAL_RULE);	
	format(string,sizeof(string), "* {WG} News: %s", message);
	SendClientMessageToAll(COLOR_WHITE, string);
	SendClientMessageToAll(COLOR_LIME, HORIZONTAL_RULE);
	return 1;
}
//------------------------------------------------------------------------------
public IsPlayerInInterior(playerid)
{
	if (IsPlayerConnected(playerid))
	{
		new Float:x, Float:y, Float:z;
		
		GetPlayerPos(playerid, x, y, z);
		
		if(z > 950.0000)
		{
			return 1;
		}
	}
	return 0;
}
//------------------------------------------------------------------------------
public UnlockEmptyVehicles()
{
	for(new i=0;i<MAX_VEHICLES;i++)
	{
		if(VehicleDriver(i) == -1)
		{
			foreach(Player, j)
			{
				if(i > 49)
				{
					SetVehicleParamsForPlayer(i,j, 0, 0);
				}
			}
		}
	}
}
//------------------------------------------------------------------------------
public VehicleDriver(vehicleid)
{
	foreach(Player, i)
	{
		if ((GetPlayerVehicleID(i)==vehicleid)&&(GetPlayerState(i)==PLAYER_STATE_DRIVER))
		{
			return i;
		}
	}
	return -1;
}
//------------------------------------------------------------------------------
public GiveMoney(playerid, money)
{
	new old_money = GetPlayerMoney(playerid);
	new new_money = old_money + money;
	
	if(new_money > old_money)
	{
		playerVariables[playerid][Money] = new_money;
		GivePlayerMoney(playerid, money);
	}
	else if(new_money < old_money)
	{
		GivePlayerMoney(playerid, money);
		playerVariables[playerid][Money] = new_money;
	}
	else
	{
		//nothing!
	}
}
//------------------------------------------------------------------------------
public ResetMoney(playerid)
{
	new old_money = GetPlayerMoney(playerid);
	new new_money = 0;
	
	if(new_money > old_money)
	{
		playerVariables[playerid][Money] = new_money;
		ResetPlayerMoney(playerid);
	}
	else if(new_money < old_money)
	{
		ResetPlayerMoney(playerid);
		playerVariables[playerid][Money] = new_money;
	}
	else
	{
		playerVariables[playerid][Money] = new_money;
		ResetPlayerMoney(playerid);
		//nothing!
	}
}
//------------------------------------------------------------------------------
public Float:GetDistance(Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2)
{
	return floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
}
//------------------------------------------------------------------------------
public update_zones() 
{
    new
        line1[10],
        line2[10];

	foreach(Player,i)
	{
        if(IsPlayerConnected(i) && zoneupdates[i] == 1) 
		{
            if(IsPlayerInZone(i,player_zone[i])) 
			{
            }
            else {
                new
                    player_zone_before;

                player_zone_before = player_zone[i];
                player_zone[i] = -1;

                for(new j=0; j<sizeof(zones);j++) 
				{
                    if(IsPlayerInZone(i,j) && player_zone[i] == -1) 
					{
                        if(player_zone_before == -1)
                        {
							zonename(i, j);
                        }
                        else if(strcmp(zones[j][zone_name],zones[player_zone_before][zone_name],true) != 0)
                        {
							zonename(i, j);
                        }

                        player_zone[i] = j;
                        format(line1,10,"p%dzone",i);
                        format(line2,10,"%d",j);

                    }
                }
                if(player_zone[i] == -1) player_zone[i] = player_zone_before;
            }
        }
    }
}
//------------------------------------------------------------------------------
public HideZoneName(playerid)
{
    TextDrawHideForPlayer(playerid, ZoneText[playerid]);
    return 1;
}
//------------------------------------------------------------------------------
IsPlayerInZone(playerid, zoneid)
{
 	if(zoneid == -1) return 0;
 	new Float:x, Float:y, Float:z;
 	GetPlayerPos(playerid,x,y,z);
	if(x >= zones[zoneid][zone_minx] && x < zones[zoneid][zone_maxx]
	&& y >= zones[zoneid][zone_miny] && y < zones[zoneid][zone_maxy]
	&& z >= zones[zoneid][zone_minz] && z < zones[zoneid][zone_maxz]
	&& z < 1200.0000) return 1;
 	return 0;
}
//------------------------------------------------------------------------------
public SpeedUp() {//speed-up
    new vehicleid,keys,Float:vx,Float:vy,Float:vz;
   
    for (new playerid = 0; playerid < PLAYER_SLOTS; playerid++)
	{
        if (IsPlayerConnected(playerid) && playerVariables[playerid][Speed] == 0)
            continue;
        if ((vehicleid = GetPlayerVehicleID(playerid)))
		{
            GetPlayerKeys(playerid, keys, _:vx, _:vx);
            if ((keys & (KEY_VEHICLE_FORWARD | KEY_VEHICLE_BACKWARD | KEY_HANDBRAKE)) == KEY_VEHICLE_FORWARD)
			{
                GetVehicleVelocity(vehicleid, vx, vy, vz);
                if (vx * vx + vy * vy < g_SpeedThreshold)
                    continue;
                vx *= SPEED_MULTIPLIER;
                vy *= SPEED_MULTIPLIER;
                if (vz > 0.04 || vz < -0.04)
                    vz -= 0.020;
                SetVehicleVelocity(vehicleid, vx, vy, vz);
            }
        }
    }
}
//------------------------------------------------------------------------------
public OnPlayerDeathByCheatkill(playerid, killerid, reason)
{
	if(killerid == INVALID_PLAYER_ID)
	{
		return 0;
	}
	else
	{
		if(reason == WEAPON_KATANA || reason == WEAPON_GRENADE || reason == WEAPON_TEARGAS || reason == WEAPON_MOLTOV || reason == WEAPON_RIFLE || reason == WEAPON_SNIPER || reason == WEAPON_ROCKETLAUNCHER || reason == WEAPON_HEATSEEKER || reason == WEAPON_FLAMETHROWER || reason == WEAPON_MINIGUN || reason == WEAPON_SATCHEL || reason == WEAPON_BOMB || reason == WEAPON_SPRAYCAN)
		{
			SendDeathMessage(killerid,playerid,reason);
			return 1;
		}
		if(IsPlayerInInterior(playerid))
		{
			if(reason != 0)
			{
				SendDeathMessage(killerid,playerid,reason);
				return 1;
			}
		}
	}
	return 0;
}
//------------------------------------------------------------------------------
public JailAreaCheck(playerid)
{
	new Float:x, Float:y, Float:z;
	new PlayerState = GetPlayerState(playerid);
	GetPlayerPos(playerid, x, y, z);
	
	if(PlayerState != PLAYER_STATE_WASTED && PlayerState != PLAYER_STATE_SPAWNED)
	{
		if(z<1000)
		{
		//maybe some admin action here.laters
		}
	}
}
//------------------------------------------------------------------------------
public LoginAreaCheck(playerid)
{
	new Float:x, Float:y, Float:z;
	new PlayerState = GetPlayerState(playerid);
	GetPlayerPos(playerid, x, y, z);
	
	if(PlayerState != PLAYER_STATE_WASTED && PlayerState != PLAYER_STATE_SPAWNED && playerVariables[playerid][FirstTimeSpawned] == 0)
	{
		if(z<1000)
		{
		//maybe some admin action here.laters
		}
	}
}
//------------------------------------------------------------------------------
public MoneyCheatDetection()
{
	foreach(Player, i)
	{
			new player_info_money = playerVariables[i][Money];
			new player_money = GetPlayerMoney(i);
			
			if((player_money - player_info_money) > 25000)
			{
			//maybe some admin action here.laters	
			}
	}
}
//------------------------------------------------------------------------------
public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
	if(checkpointid == CP1)// CRANBERRY STATION 
	{
		if(IsPlayerInDynamicCP(playerid, CP1))
		{
			ShowPlayerDialog(playerid, DIALOG_CRANBERRY, DIALOG_STYLE_LIST, "Welcome To Cranberry Station", "Yellow Bell Station\nLinden Station(LV)\nMarket Station(LS) \nUnity Station(LS)", "Ticket", "Cancel");
		}
	}
	if(checkpointid == CP2)// MARKET STATION
	{
		if(IsPlayerInDynamicCP(playerid, CP2))
		{
			ShowPlayerDialog(playerid, DIALOG_MARKET, DIALOG_STYLE_LIST, "Welcome To Market Station", "Yellow Bell Station \nLinden Station(LV) \nUnity Station(LS) \nCranberry Station", "Ticket", "Cancel");
		}
	}
	if(checkpointid == CP3)// UNITY STATION
	{
		if(IsPlayerInDynamicCP(playerid, CP3)) 
		{
			ShowPlayerDialog(playerid, DIALOG_UNITY, DIALOG_STYLE_LIST, "Welcome To Unity Station", "Yellow Bell Station \nLinden Station(LV) \nMarket Station(LS) \nCranberry Station", "Ticket", "Cancel");
		}
	}
	if(checkpointid == CP4)// LINDEN STATION
	{
		if(IsPlayerInDynamicCP(playerid, CP4))
		{
			ShowPlayerDialog(playerid, DIALOG_LINDEN, DIALOG_STYLE_LIST, "Welcome To Linden Station", "Yellow Bell Station \nMarket Station(LS) \nUnity Station(LS) \nCranberry Station", "Ticket", "Cancel");
		}
	}
	if(checkpointid == CP5)//YELLOW BELL STATION
	{
		if(IsPlayerInDynamicCP(playerid, CP5))
		{
			ShowPlayerDialog(playerid, DIALOG_YBELL, DIALOG_STYLE_LIST, "Welcome To Yellow Bell Station", "Linden Station(LV) \nMarket Station(LS) \nUnity Station(LS) \nCranberry Station", "Ticket", "Cancel");
		}
	}
	if(checkpointid == CP6)//BANK
	{
		if(IsPlayerInRangeOfPoint(playerid, 3, -22.2549, -55.6575, 1003.5469))
		{
			ShowPlayerDialog(playerid, DIALOG_BANK, DIALOG_STYLE_LIST, "Welcome To San Andreas Bank", "Deposit \nWithdraw \nBalance \nGang Deposit \nGang Withdraw \nGang balance", "Proceed", "Cancel");
		}
	}
	if(checkpointid == CP7)//PIRATE
	{
		if(IsPlayerInDynamicCP(playerid, CP7))
		{
			new
			string[95];
			format(string, sizeof(string), "You can stay on the ship to make money and remember the ship is a safe zone.");
			ShowPlayerDialog(playerid, DIALOG_MSGBOX, DIALOG_STYLE_MSGBOX, "World-Gamerz Info", string, "Close", "");
		}
	}
	if(checkpointid == CP8)//CHILLIDOGS
	{
		if(IsPlayerInDynamicCP(playerid, CP8))
		{
			SendClientMessage(playerid, COLOR_LIGHTSALMON, "Fresh chilli dogs, 50 percent more health! Type: /chillidog.");
		}
	}
	if(checkpointid == CP9)//AMMUNATION
	{
		if(IsPlayerInRangeOfPoint(playerid, 3, 291.0004,-84.5168,1001.515))
		{
			new
			string[95];
			format(string, sizeof(string), "Coming Soon SpawnWeapons\nYou can buy weapons that you spawn every time you spawn.");
			ShowPlayerDialog(playerid, DIALOG_MSGBOX, DIALOG_STYLE_MSGBOX, "World-Gamerz Info", string, "Close", "");
		}
	}
	if(checkpointid == CP10)//PAUZE
	{
		if(IsPlayerInDynamicCP(playerid, CP10)) 
		{
			OnPlayerEnterUnPauseCheckpoint(playerid);
		}
	}
	if(checkpointid == CP11)// S-DISH
	{
		if(IsPlayerInDynamicCP(playerid, CP11))
		{
			new
			string[95];
			format(string, sizeof(string), "Because you are standing in this checkpoint \nyou can now listen in on other players pm's.");
			ShowPlayerDialog(playerid, DIALOG_MSGBOX, DIALOG_STYLE_MSGBOX, "World-Gamerz Info", string, "Close", "");
		}
	}
	
	return 1;
}
//------------------------------------------------------------------------------
public PausePlayer(playerid)
{
	RemovePlayerFromVehicle(playerid);
	
	GetPlayerPos(playerid, playerVariables[playerid][BackPos][0], playerVariables[playerid][BackPos][1], playerVariables[playerid][BackPos][2]);
	if( playerVariables[playerid][BackPos][2] > 100 ){ //interior
		playerVariables[playerid][BackPos][0] = 2024.8190;
		playerVariables[playerid][BackPos][1] = 1917.9425;
		playerVariables[playerid][BackPos][2] = 12.3386;
	}
	SetPlayerInterior(playerid, 1);
	SetPlayerFacingAngle(playerid, 0.0);
	new Float:x = -796.1 + float(random(24)/10);
	new Float:y = 492.3 + float(random(3));
	
	DisablePlayerCheckpoint(playerid);
	SetPlayerPos(playerid,x,y,1376.1953);
	
	new Float:playerHealth;
	GetPlayerHealth(playerid,playerHealth);
	playerVariables[playerid][Health] = floatround(playerHealth, floatround_floor);
	
	SetPlayerHealth(playerid, 999999);
	playerVariables[playerid][PlayerStatus] = STATUS_PAUSED;
	
	ResetPlayerWeapons(playerid);
	for(new weapSlot = 0; weapSlot != 13; weapSlot++)
	{
    GetPlayerWeaponData(playerid, weapSlot, SavedPlayerWeaps[playerid][weapSlot][0], SavedPlayerWeaps[playerid][weapSlot][1]);
    }	
	
	new string[190];
	format(string, sizeof(string), "You are now paused and your commands wont work while paused, \nYou can walk into the checkpoint behind you to play again. \nIt's forbidden to fight or harass each other while paused.");
	ShowPlayerDialog(playerid, DIALOG_MSGBOX, DIALOG_STYLE_MSGBOX, "World-Gamerz Info", string, "Close", "");
	
}
//------------------------------------------------------------------------------
public OnPlayerEnterUnPauseCheckpoint(playerid)
{
	if(IsPlayerPaused(playerid))
	{
		SetPlayerHealth(playerid, playerVariables[playerid][Health]);
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid, playerVariables[playerid][BackPos][0], playerVariables[playerid][BackPos][1], playerVariables[playerid][BackPos][2]);
		playerVariables[playerid][PlayerStatus] = STATUS_NONE;
		
		ResetPlayerWeapons(playerid);
		for(new weapSlot = 0; weapSlot != 13; weapSlot++)
		{
		GivePlayerWeapon(playerid, SavedPlayerWeaps[playerid][weapSlot][0], SavedPlayerWeaps[playerid][weapSlot][1]);
		}
		
		SendClientMessage(playerid, COLOR_LIME, "You can now play again!");
	}
}
//------------------------------------------------------------------------------
public IsPlayerPaused(playerid)
{
	if (IsPlayerConnected(playerid))
	{
		if (playerVariables[playerid][PlayerStatus] == STATUS_PAUSED)
		{
			return 1;
		}
	}
	return 0;
}
//------------------------------------------------------------------------------
//---------PlayerStatistics-----------------------
public UpdateIngameTimes()
{
	foreach(Player, i)
	{
		if(!IsPlayerPaused(i))
		{
			playerVariables[i][IngameTime]++;
			CheckPlayerRank(i);
			#if defined DEBUG
			printf("* CheckPlayerRank  *");
			#endif
		}
	}
}
//------------------------------------------------------------------------------
//---------PlayerStatistics-----------------------
public ReturnPlayerStats(playerid,giveplayerid)
{
	new outputmessage[64];
	SendClientMessage(playerid, COLOR_LIME, HORIZONTAL_RULE);
	format(outputmessage, sizeof(outputmessage),"statistics for %s since %02d :", playerVariables[giveplayerid][PlayerName],playerVariables[giveplayerid][RegDate]);
	SendClientMessage(playerid, COLOR_YELLOW, outputmessage);
	
	new 
	hours = 0,
	minutes = 0,
	rank[16],
	allranks = playerVariables[giveplayerid][PlayerRanking];

	
	if(playerVariables[giveplayerid][IngameTime] > 60)
	{
		hours = floatround(playerVariables[giveplayerid][IngameTime]/60, floatround_floor);
	}
	minutes = playerVariables[giveplayerid][IngameTime] - (hours*60);
	
	format(outputmessage, sizeof(outputmessage),"- total of %d hour(s) and %d minutes online", hours, minutes);
	SendClientMessage(playerid, COLOR_YELLOW, outputmessage);
	
	switch(allranks)
	{
		case RANK_STARTER:
		{
			rank = "Starter";
		}
		case RANK_ADDICT:
		{
			rank = "go-getter";
		}
		case RANK_MASTER:
		{
			rank = "master";
		}
		case RANK_PRO:
		{
			rank = "Pro";
		}
		case RANK_EXPERT:
		{
			rank = "Expert";
		}
		case RANK_ELITE:
		{
			rank = "Elite";
		}
		case RANK_FREAK:
		{
			rank = "Freak";
		}
	}
	
	format(outputmessage, sizeof(outputmessage),"- rank: %s", rank);
	SendClientMessage(playerid, COLOR_YELLOW, outputmessage);
	
	new Float:fKills = float(playerVariables[giveplayerid][Kills]);
	new Float:fDeaths = float(playerVariables[giveplayerid][Deaths]);
	new Float:fRatio;
	
	if(playerVariables[giveplayerid][Deaths] == 0)
	{
		fRatio = 1.0000;
	}
	else
	{
		fRatio = floatdiv(fKills, fDeaths);
	}
	
	
	format(outputmessage, sizeof(outputmessage),"- %d kills, %d deaths, ratio: %.2f", playerVariables[giveplayerid][Kills], playerVariables[giveplayerid][Deaths],fRatio);
	SendClientMessage(playerid, COLOR_YELLOW, outputmessage);
	format(outputmessage, sizeof(outputmessage),"- %d times jailed, %d times kicked", playerVariables[giveplayerid][Jails], playerVariables[giveplayerid][Kicks]);
	SendClientMessage(playerid, COLOR_YELLOW, outputmessage);
	SendClientMessage(playerid, COLOR_LIME, HORIZONTAL_RULE);
	return 1;
}
//------------------------------------------------------------------------------
//---------PlayerStatistics-----------------------
public CheckPlayerRank(playerid)
{
	if(playerVariables[playerid][IngameTime] >= 600 && playerVariables[playerid][IngameTime] < 1200)// Between 10 and 20 hours
	{
		playerVariables[playerid][PlayerRanking] = RANK_ADDICT;
		playerVariables[playerid][MaxBank] = 1000000;
		if(playerVariables[playerid][IngameTime] == 600)
		{
			SendClientMessage(playerid, COLOR_YELLOWGREEN, "Congratulations, your rank is upgraded to Addict!");
		}
	}
	else if(playerVariables[playerid][IngameTime] >= 1200 && playerVariables[playerid][IngameTime] < 1800)// Between 20 and 30 hours
	{
		playerVariables[playerid][PlayerRanking] = RANK_MASTER;
		playerVariables[playerid][MaxBank] = 2500000;
		if(playerVariables[playerid][IngameTime] == 1200)
		{
			SendClientMessage(playerid, COLOR_YELLOWGREEN, "Congratulations, your rank is upgraded to Master!");
		}
	}
	else if(playerVariables[playerid][IngameTime] >= 1800 && playerVariables[playerid][IngameTime] < 2400)// Between 30 and 40 hours
	{
		playerVariables[playerid][PlayerRanking] = RANK_PRO;
		playerVariables[playerid][MaxBank] = 5000000;
		if(playerVariables[playerid][IngameTime] == 1800)
		{
			SendClientMessage(playerid, COLOR_YELLOWGREEN, "Congratulations, your rank was upgraded to Pro!");
		}
	}
	else if(playerVariables[playerid][IngameTime] >= 2400 && playerVariables[playerid][IngameTime] < 3000)// Between 40 and 50 hours
	{
		playerVariables[playerid][PlayerRanking] = RANK_EXPERT;
		playerVariables[playerid][MaxBank] = 10000000;
		if(playerVariables[playerid][IngameTime] == 2400)
		{
			SendClientMessage(playerid, COLOR_YELLOWGREEN, "Congratulations, your rank was upgraded to Expert!");
		}
	}
	else if(playerVariables[playerid][IngameTime] >= 3000 && playerVariables[playerid][IngameTime] < 6000)// Between 50 and 100 hours
	{
		playerVariables[playerid][PlayerRanking] = RANK_ELITE;
		playerVariables[playerid][MaxBank] = 25000000;
		if(playerVariables[playerid][IngameTime] == 3000)
		{
			SendClientMessage(playerid, COLOR_YELLOWGREEN, "Congratulations, your rank was upgraded to Elite!");
		}
	}
	else if(playerVariables[playerid][IngameTime] >= 6000)// More than 100 hours
	{
		playerVariables[playerid][PlayerRanking] = RANK_FREAK;
		playerVariables[playerid][MaxBank] = 50000000;
		if(playerVariables[playerid][IngameTime] == 6000)
		{
			SendClientMessage(playerid, COLOR_YELLOWGREEN, "incredible, your rank is now Freak!");
		}
	}
	return 1;
}
//------------------------------------------------------------------------------
//---------AreaHandler----------------------------
public IsPlayerInArea(playerid, Float:x1, Float:y1, Float:x2, Float:y2)
{
	new Float:X, Float:Y, Float:Z;
	
	GetPlayerPos(playerid, X, Y, Z);
	if(X >= x1 && X <= x2 && Y >= y1 && Y <= y2)
	{
		return 1;
	}
	return 0;
}
//------------------------------------------------------------------------------
//---------AreaHandler----------------------------
public IsPlayerInArea3D(playerid, Float:x1, Float:y1, Float:x2, Float:y2, Float:z1, Float:z2)
{
	new Float:X, Float:Y, Float:Z;
	
	GetPlayerPos(playerid, X, Y, Z);
	if(X >= x1 && X <= x2 && Y >= y1 && Y <= y2 && Z >= z1 && Z <= z2) 
	{
		return 1;
	}
	return 0;
}
//------------------------------------------------------------------------------
//---------AreaHandler----------------------------
public AreaCheckFunc()
{
	foreach(Player, i)
	{
			if(IsPlayerJailed(i))
			{
				JailAreaCheck(i);
			}
			if(!IsPlayerLoggedIn(i))
			{
				LoginAreaCheck(i);
			}
			if(!IsPlayerJailed(i))
			{
				if(IsPlayerInArea3D(i, 1995.5000,1518.0000,2006.0000,1569.0000,0.0000,200.0000)) //Pirate ship area
				{
					GiveMoney(i, 100);
				}
			}
	}
}
//------------------------------------------------------------------------------
//----Ship Stuff----------------------------------
IsPlayerOnShip(cplayerID, Float:data[4])
{
    new Float:X, Float:Y, Float:Z;
    GetPlayerPos(cplayerID, X, Y, Z);
    if (X >= data[0] && X <= data[2] && Y >= data[1] && Y <= data[3]) 
	{
        return 1;
    }
    return 0;
}
//------------------------------------------------------------------------------
//----Ship Stuff----------------------------------
public isPlayerInArea( playerID, Float:data[ 4 ] )
{
    new Float:X, Float:Y, Float:Z;
    GetPlayerPos(playerID, X, Y, Z);
    if (X >= data[0] && X <= data[2] && Y >= data[1] && Y <= data[3]) 
	{
        return 1;
    }
    return 0;
}
//------------------------------------------------------------------------------
//--------CPHandler-------------------------------
public IsPlayerInTrainCheckpoint(playerid)
{
	if(IsPlayerInCheckpoint(playerid) && playerVariables[playerid][Checkpoint] == U_SFTRAIN)
	{
		return 1;
	}
	if(IsPlayerInCheckpoint(playerid) && playerVariables[playerid][Checkpoint] == U_UNTRAIN)
	{
		return 1;
	}
	if(IsPlayerInCheckpoint(playerid) && playerVariables[playerid][Checkpoint] == U_LSTRAIN)
	{
		return 1;
	}
	if(IsPlayerInCheckpoint(playerid) && playerVariables[playerid][Checkpoint] == U_LVTRAIN)
	{
		return 1;
	}
	if(IsPlayerInCheckpoint(playerid) && playerVariables[playerid][Checkpoint] == U_LINTRAIN)
	{
		return 1;
	}
	return 0;
}
//------------------------------------------------------------------------------
//--------CPHandler-------------------------------
public IsPlayerInThisCheckpoint(playerid,checkpoint)
{
	if(IsPlayerInCheckpoint(playerid) && playerVariables[playerid][Checkpoint] == checkpoint)
	{
		return 1;
	}
	return 0;
}
//------------------------------------------------------------------------------
//---------Checkpoints----------------------------
public OnPlayerEnterCheckpoint(playerid)
{
	return 0;
}
//------------------------------------------------------------------------------
public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}
//------------------------------------------------------------------------------
//---------GangHandler----------------------------
public PlayerCreateGang(playerid, name[])
{
	new
	string[120];
	
	if(playerVariables[playerid][Gang]!=GANG_NONE) 
	{
		SendClientMessage(playerid, COLOR_TOMATO, "You're already in a gang!");
	}
	else
	{
		for(new i = 0; i < MAX_GANGS; i++) 
		{
			if(GangInfo[i][GangMembers]==0) 
			{
		    	//name gang
		    	format(GangInfo[i][GangName], MAX_GANG_NAME, name);
				//There is one member
				GangInfo[i][GangMembers] = 1;
				//Gang color is player's color
				GangInfo[i][GangColor]=RandomColors[playerid];

				//Player is the first gang member
				playerVariables[playerid][Gang] = i;
				format(string, sizeof(string),"You have created the gang '%s' (id: %d)", GangInfo[i][GangName], i);
				SendClientMessage(playerid, COLOR_POWDERBLUE, string);
			
				return 1;
			}
		}
	}
	return 1;
}
//------------------------------------------------------------------------------
//---------GangHandler----------------------------
public PlayerInviteToGang(playerid, giveplayerid)
{
	new 
	string[90];
	new gangid = playerVariables[playerid][Gang];
	
	if(gangid==GANG_NONE)
	{
		SendClientMessage(playerid, COLOR_RED, "You're not in a gang!");
	}
	else{
		if(IsPlayerConnected(giveplayerid)) 
		{
			playerVariables[giveplayerid][GangInvite] = gangid;
			format(string, sizeof(string),"You have a current invitation sent to: %s.", playerVariables[giveplayerid][PlayerName]);
			SendClientMessage(playerid, COLOR_LIGHTRED, string);
			format(string, sizeof(string),"You have a current invitation from %s for the gang: '%s'", playerVariables[playerid][PlayerName], GangInfo[gangid][GangName],gangid);
			SendClientMessage(giveplayerid, COLOR_LIGHTRED, string);
			format(string, sizeof(string),"Type / gang join %d to get in this gang", gangid);
			SendClientMessage(giveplayerid, COLOR_LIGHTRED, string);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, "That player does not exist!");
		}
	}
}
//------------------------------------------------------------------------------
//---------GangHandler----------------------------
public PlayerJoinGang(playerid)
{
	new 
	string[75],
	gangid = playerVariables[playerid][GangInvite];
	
	if(playerVariables[playerid][Gang]!=GANG_NONE)
	{
		SendClientMessage(playerid, COLOR_RED, "You're already in a gang!");
	}
	else
	{
		if(gangid==GANG_NONE) 
		{
			SendClientMessage(playerid, COLOR_RED, "You are not invited to a gang.");
		}
		else
		{
			if(GangInfo[gangid][GangMembers] < MAX_GANG_MEMBERS)
			{
				playerVariables[playerid][GangInvite] = GANG_NONE;
				foreach(Player, i)
				{
					if(playerVariables[i][Gang] == gangid)
					{
						format(string, sizeof(string),"%s is now in your gang.", playerVariables[playerid][PlayerName]);
						SendClientMessage(i, COLOR_PALEVIOLETRED, string);
					}
				}
				
				GangInfo[gangid][GangMembers]++;
				playerVariables[playerid][Gang] = gangid;
				
				SetPlayerColor(playerid,GangInfo[gangid][GangColor]);
				
				format(string, sizeof(string),"You are now in the gang '%s' (id: %d)", GangInfo[gangid][GangName], gangid);
				SendClientMessage(playerid, COLOR_PALEVIOLETRED, string);
			}
			else
			{
				SendClientMessage(playerid, COLOR_PALEGOLDENROD, "The gang is full.");
			}
		}
	}
}
//------------------------------------------------------------------------------
//---------GangHandler----------------------------
public PlayerLeaveGang(playerid)
{
	new string[75],
	gangid = playerVariables[playerid][Gang];
	
	if(gangid != GANG_NONE) 
	{
		GangInfo[gangid][GangMembers]--;
		if(GangInfo[gangid][GangMembers] == 0)
		{
			GangInfo[gangid][GangBank] = 0;
		}
		foreach(Player, i)
		{
			if(GangInfo[gangid][GangMembers] == 0)
			{
				if(playerVariables[i][GangInvite] == gangid)
				{
					playerVariables[i][GangInvite] = GANG_NONE;
					SendClientMessage(i, COLOR_OLIVE, "'The gang which you were invited is stopped!");
				}
			}
			else
			{
				if(playerVariables[i][Gang] == gangid)
				{
					format(string, sizeof(string),"%s is no longer in your gang.", playerVariables[playerid][PlayerName]);
					SendClientMessage(i, COLOR_OLIVE, string);
				}
			}
		}
		format(string, sizeof(string),"You're have left your gang '%s' (id: %d)!", GangInfo[gangid][GangName], gangid);
		SendClientMessage(playerid, COLOR_OLIVE, string);
		playerVariables[playerid][Gang] = GANG_NONE;
		SetPlayerColor(playerid,RandomColors[playerid]);
	}
	else 
	{
		SendClientMessage(playerid, COLOR_RED, "You're not in a gang!");
	}
}
//------------------------------------------------------------------------------
//---------GangHandler----------------------------
public GangChat(playerid, text[])
{
	new gangid = playerVariables[playerid][Gang];
	
	if(gangid != 999) 
	{
		new 
		gangchat[256],
		string[256],
		string2[256];
		
		strmid(gangchat,text,1,strlen(text));
		format(string, sizeof(string),"%s: %s", playerVariables[playerid][PlayerName], gangchat);
		format(string2, sizeof(string),"** %s (%s): %s", playerVariables[playerid][PlayerName], GangInfo[gangid][GangName], gangchat);

		foreach(Player, i)
		{
			if(playerVariables[i][Gang] == gangid)
			{
				SendClientMessage(i, COLOR_MINTCREAM, string);
			}
			if(IsPlayerInThisCheckpoint(i,U_DISH) && playerVariables[i][Gang] != gangid)
			{
				SendClientMessage(i, COLOR_MINTCREAM, string2);
			}
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_RED, "You are not in a gang, type /gangs for more information!");
	}
	return 0;
}
//------------------------------------------------------------------------------
//---------Bank System----------------------------
public BankInterest()
{
	foreach(Player, i)
	{
		if(!IsPlayerJailed(i) && !IsPlayerPaused(i))
		{
			if(playerVariables[i][Bank] > 0 && playerVariables[i][Bank] < playerVariables[i][MaxBank])
			{
				new 
				outputmessage[65],
				interest = (playerVariables[i][Bank]/100) * 1;
				format(outputmessage, sizeof(outputmessage), "You have received interest $%d on your bank account!", interest);
				SendClientMessage(i, COLOR_RED, outputmessage);
				playerVariables[i][Bank] += interest;
				if(playerVariables[i][Bank] > playerVariables[i][MaxBank])
				{
					playerVariables[i][Bank] = playerVariables[i][MaxBank];
				}
			}
		}
	}
}
//------------------------------------------------------------------------------
//---------Transport------------------------------
public TaxiPlayer(playerid,newlocation)
{
	
	new
	outputmessage[62],
	Float:x,
	Float:y,
	Float:z,
	Float:distance,
	cost,
	Float:taxiplaces[33][4] =
	{
		{2021.7634,1545.4008,10.8232},                  // 0: LV SHIP
		{1434.2039,2625.4392,11.3926},					// 1: Yellow Bell Station(LV)
		{2860.5020,1291.0507,11.3906},                  // 2: Linden Station(LV)
		{822.0372,-1362.1971,-0.5078},					// 3: Market Station(LS)
		{1730.4075,-1949.0419,14.1172},                 // 4: Unity Station(LS)
		{-1957.6895,138.1897,27.6940},					// 5: Cranberry Station(SF)
		{1648.0355,1607.7329,10.8203,0.0}, 				// 6: LV AIRPORT
		{195.8650,179.9261,1003.0300,3.0},				// 7: PRISON
		{2492.7844,-1682.5851,13.0654,0.0}, 			// 8: LS GROVE STREET
		{-1989.3699,265.4546,35.1794,0.0},              // 9: SF WANG CARS
		{-2232.6819,-1737.5704,480.8345,0.0},			// 10: SA MOUNT CHILLIAD
		{2277.3252,2460.1770,10.8203},					//11:Police Station
		{2536.0796,2085.4226,10.8203},					//12:Ammunition
		{2154.8992, 938.5535, 10.3908},					//13:Ammunition2
		{213.4851,1870.4987,17.6406},					//14:Area 69
		{421.0738,2530.8396,16.6170},					//15:Airstrip
		{-122.4106,1140.5603,19.4179},					//16:Fort Carson
		{-800.6419,1556.0458,26.7969},					//17:Las Barrancas
		{-1521.2667,2608.5671,55.5156},					//18:El Quebrados
		{-226.4346,2706.8306,62.2908},					//19:Las Payasadas
		{-2515.7759,2337.9111,4.6627},					//20:Bayside
		{2336.6533,61.5553,26.2530},					//21:Palomino Creek
		{753.3595,334.0266,19.8663},					//22:Hampton Barns
		{239.0445,-177.2144,1.1190},					//23:Blueberry
		{675.3820,-497.2187,15.9056},					//24:Dillimore
		{-1091.2517,-1638.9419,75.9005},				//25:Leafy Hollow
		{1691.3243,-2452.5896,14.2731},					//26:Los Santos Airport
		{2489.5339,2769.2688,10.3609},					//27:KACC Military Fuels
		{-2162.0396,-2420.0054,30.6250},				//28:Angel Pine
		{-1268.9606,-37.0707,14.1484},					//29:Easter Bay Airport
		{-1269.2292,-35.3244,14.1484},					//30:San Fierro Airport
		{1570.8782,-1309.4750,17.1471},					//31:Downtown Los Santos
		{1570.8782,-1309.4750,17.1471}					//32:Los Santos Basejumping
	};
	
	if(PlayerTaxi[playerid] == 1)
	{
		format (outputmessage, sizeof(outputmessage), "You have recently taken a taxi, try again in a few minutes!");
		SendClientMessage(playerid, COLOR_CRIMSON, outputmessage);
		return 1;
	}
	
	GetPlayerPos(playerid, x, y, z);
	distance = GetDistance(x,y,z,taxiplaces[newlocation][0],taxiplaces[newlocation][1],taxiplaces[newlocation][2]);
	cost = floatround((distance/400)*ServerPrice[Taxi], floatround_floor); //400 from 1000 because getdistance distance as the crow flies is.
	// if the player has enough money
	if(GetPlayerMoney(playerid) < cost)
	{
		format (outputmessage, sizeof(outputmessage), "You do not have enough money: $%d", cost);
		SendClientMessage(playerid, COLOR_RED, outputmessage);
		return 1;
	}
	GiveMoney(playerid, -cost);
	RemovePlayerFromVehicle(playerid);
	new interior = floatround(taxiplaces[newlocation][3], floatround_floor);
	SetPlayerInterior(playerid, interior);
	SetPlayerPos(playerid,taxiplaces[newlocation][0],taxiplaces[newlocation][1],taxiplaces[newlocation][2]);
	format (outputmessage, sizeof(outputmessage), "You have taken a taxi for $%d.", cost);
	SendClientMessage(playerid, COLOR_HOTPINK, outputmessage);
	PlayerTaxi[playerid] = 1;
	SetTimerEx("AllowTaxi", TAXI_WAIT_TIME, 0, "i", playerid);
	return 1;
	
}
//------------------------------------------------------------------------------
public AllowTaxi(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(PlayerTaxi[playerid] == 1)
		{
	    	PlayerTaxi[playerid] = 0;
		}
	}
	return 1;
}
//------------------------------------------------------------------------------
//---------Transport------------------------------
public TrainPlayer(playerid,newlocation)
{
	
	new
	outputmessage[35],
	Float:trainplaces[5][3] =
	{
		{1434.2039,2625.4392,11.3926},					// 0: Yellow Bell Station(LV)
		{2860.5020,1291.0507,11.3906},                  // 1: Linden Station(LV)
		{822.0372,-1362.1971,-0.5078},					// 2: Market Station(LS)
		{1730.4075,-1949.0419,14.1172},                 // 3: Unity Station(LS)
		{-1957.6895,138.1897,27.6940}					// 4: Cranberry Station(SF)
	};
	
	RemovePlayerFromVehicle(playerid);
	
	SetPlayerPos(playerid,trainplaces[newlocation][0],trainplaces[newlocation][1],trainplaces[newlocation][2]);
	format (outputmessage, sizeof(outputmessage), "You have free use of the train!");
	SendClientMessage(playerid, COLOR_HOTPINK, outputmessage);
	
	return 1;
	
}
//------------------------------------------------------------------------------
//---------LoginHandler---------------------------
public IsPlayerLoggedIn(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(playerVariables[playerid][PlayerStatus] != STATUS_NOTLOGGEDIN)
		{
			return 1;
		}
	}
	return 0;
}
//------------------------------------------------------------------------------
//---------LoginHandler---------------------------
public RegisterPlayer(playerid)
{
	SendClientMessage(playerid, COLOR_LEMONCHIFFON, "Your account has been successfully created, have lots of fun playing!");
	SendClientMessage(playerid, COLOR_LEMONCHIFFON, "You have $50,000 as start-up money deposited to your bank account!");playerVariables[playerid][Bank] = 50000;
	playerVariables[playerid][PlayerStatus] = STATUS_NONE;
	SendClientMessage(playerid, COLOR_INDIGO, "Type /help for general help!");
	OnPlayerSpawn(playerid);
	ResidingCountry(playerid);
	SetPlayerHealth(playerid, 100);
	SetPlayerColor(playerid,RandomColors[playerid]);
	zoneupdates[playerid] =1;//area zones
	
}
//------------------------------------------------------------------------------
//---------LoginHandler---------------------------
public RegisterPlayedPlayer(playerid)
{
	SendClientMessage(playerid, COLOR_LEMONCHIFFON, "Your account has been successfully created, have lots of fun playing!");
	SendClientMessage(playerid, COLOR_LEMONCHIFFON, "You have $50,000 as start-up money deposited to your bank account!");playerVariables[playerid][Bank] = 50000;
	playerVariables[playerid][PlayerStatus] = STATUS_NONE;
	SendClientMessage(playerid, COLOR_INDIGO, "Type /help for general help!");	
}		
//------------------------------------------------------------------------------
//---------LoginHandler---------------------------
public LoginPlayer(playerid)
{
	//          let the player know he is spawned and shit
	CheckPlayerRank(playerid);
	SendClientMessage(playerid, COLOR_LEMONCHIFFON, "You've successfully logged in, have fun playing!");
	SendClientMessage(playerid, COLOR_LEMONCHIFFON, "Type /help for a list of helpful stuff (IMPORTANT!)");
	SendClientMessage(playerid, COLOR_LEMONCHIFFON, "Type /rules for the server (IMPORTANT READ!)");
	
	if(playerVariables[playerid][JailTime] > 0)
	{
		Jail(playerid, 1);	//Runnaway!..
	}
	else
	{
		playerVariables[playerid][PlayerStatus] = STATUS_NONE;
		OnPlayerSpawn(playerid);		
	}
	ResidingCountry(playerid);
	SetPlayerHealth(playerid, 100);
	SetPlayerColor(playerid,RandomColors[playerid]);
	zoneupdates[playerid] =1;//area zones
}
//------------------------------------------------------------------------------
//---------LoginHandler---------------------------
public Playerplay(playerid)
{
	SendClientMessage(playerid, COLOR_LEMONCHIFFON, "Welcome to World-Gamerz, have fun playing!");
	SendClientMessage(playerid, COLOR_LEMONCHIFFON, "Dont forget you can register at any time while playing.");
	SendClientMessage(playerid, COLOR_LEMONCHIFFON, "Type /help for a list of helpful stuff (IMPORTANT!)");
	SendClientMessage(playerid, COLOR_LEMONCHIFFON, "Type /rules for the server (IMPORTANT READ!)");
	playerVariables[playerid][PlayerStatus] = STATUS_TEMP;
	OnPlayerSpawn(playerid);
	ResidingCountry(playerid);
	SetPlayerHealth(playerid, 100);
	SetPlayerColor(playerid,RandomColors[playerid]);
	zoneupdates[playerid] =1;//area zones
}
//------------------------------------------------------------------------------
//--------Timers----------------------------------
//------------------------------------------------------------------------------
//--------Timers----------------------------------
public MainTimer()
{
	TickCount[TenSecTimer]++;
	TickCount[MinTimer]++;
	TickCount[FiveMinTimer]++;
	TickCount[TenMinTimer]++;
	TickCount{FithTeenMinTimer}++;
	TickCount[TimeTimer]++;
	TickCount[AreaTimer]++;
	
	if(tickcount() / 1000 % 5 == 0)TextDrawSetString(InfoBar, InfoBarText[random(sizeof(InfoBarText))]);
	
	if(TickCount[CountDownTimer] > 0)
	{
		TickCount[CountDownTimer]--;
		CountDownFunction();
		#if defined DEBUG
		printf("[debug] Count Down Timer working");
		#endif

	}
	
	if (TickCount[AreaTimer] == 2)
	{
		SafeZone();
		AreaCheckFunc();
		update_zones();
		TickCount[AreaTimer] = 0;
	}
	
	if (TickCount[TenSecTimer] == 10)
	{
		ServerNameUpdate();
		UnlockEmptyVehicles();
		TickCount[TenSecTimer] = 0;
	}
	
	if (TickCount[MinTimer] == 60)
	{
		TickCount[MinTimer] = 0;
	}
	
	if (TickCount[FiveMinTimer] == 300)
	{
		UpdateIngameTimes();
		ReSpawnVehicles();
		TickCount[FiveMinTimer] = 0;
	}
	
	if (TickCount[TenMinTimer] == 600)
	{
		BankInterest();
		OperationSaveTheWorld();
		TickCount[TenMinTimer] = 0;
		CheckPlayerAFK();
	}
	
	if (TickCount[FithTeenMinTimer] == 900)
	{
		TickCount[FithTeenMinTimer] = 0;
	}
	
	MoneyCheatDetection();
	MoneyScoreUpdate();
	JailTimeUpdate();
	//Auto-kick for the players not logging in
	new reason[32];
	foreach(Player, f)
	{
		if(!IsPlayerLoggedIn(f))
		{
			if(playerVariables[f][NotLoggedInTime] < 240)
			{
				playerVariables[f][NotLoggedInTime]++;
				if(playerVariables[f][NotLoggedInTime] == 240)
				{	// 4 minutes = too long
					reason = "Too slow to login";
					KickPlayer(f, reason);
				}
				if(playerVariables[f][NotLoggedInTime] == 60 || playerVariables[f][NotLoggedInTime] == 120 || playerVariables[f][NotLoggedInTime] == 180)
				{	// First a reminder every minute
					SendClientMessage(f, COLOR_DEEPPINK, "Server: Please Choose a skin!");
				}
			}
		}
	}
}

//------------------------------------------------------------------------------
//--------Timers----------------------------------
public MoneyScoreUpdate()
{
	foreach(Player, i)
	{
			new CashScore;
			CashScore = GetPlayerMoney(i);
			SetPlayerScore(i, CashScore);
	}
}
//------------------------------------------------------------------------------
//--------Timers----------------------------------
public OperationSaveTheWorld()
{
	foreach(Player, i)
	{
		if(IsPlayerLoggedIn(i))
		{
			SaveSaveablePlayerInfo(i);
		}
	}
}
//------------------------------------------------------------------------------
//--------Timers----------------------------------
public CountDownFunction()
{
	new
		counts[30];
	
	if(TickCount[CountDownTimer] > 0)
	{
		format(counts, sizeof(counts), "CountDown At %d second(s)", TickCount[CountDownTimer]);
		SendClientMessageToAll(COLOR_ALICEBLUE, counts);
		#if defined DEBUG
		printf("CountDown At %d second(s)",TickCount[CountDownTimer]);
		#endif
	}
	else{
		SendClientMessageToAll(COLOR_AQUA, "Goooooo");
	}
}
//------------------------------------------------------------------------------
//--------Timers----------------------------------
public CheckPlayerAFK()
{
	foreach(Player, i)
{
		new 
			Float:x,
			Float:y,
			Float:z;
		GetPlayerPos(i, x, y, z);
		
		if(playerVariables[i][PlayerSavedPos][0] == x && playerVariables[i][PlayerSavedPos][1] == y && playerVariables[i][PlayerSavedPos][2] == z && !IsPlayerPaused(i) && IsPlayerLoggedIn(i))
		{
			new reason[44];
			reason = "Away from your computer, now using /pause.";
			KickPlayer(i, reason);
		}
		else
		{
			playerVariables[i][PlayerSavedPos][0] = x;
			playerVariables[i][PlayerSavedPos][1] = y;
			playerVariables[i][PlayerSavedPos][2] = z;
		}
	}
}
//------------------------------------------------------------------------------
//------------Ship safe zone ---------------------
public SafeZone()
{
	foreach(Player, i)
	{
            playerSafe[i] = 0;
            new
				Float:x,
				Float:y,
				Float:z;
            GetPlayerPos(i, x, y, z);
                                                  
            if (x < 2008.2683 && x > 1994.6351 && y < 1571.3304 && y > 1516.6323 && z < 2250.000 && z > 0.000) playerSafe[i] = 1;//ship
                                                  
            if (x < 2026.0396&& x > 2006.0 && y < 1550.50 && y > 1540.0 && z < 2250.000 && z > 0.000) playerSafe[i] = 1;//ramp 2 ship
                                                 
            if (GetPlayerInterior(i) > 0) playerSafe[i] = 0;
            if (playerSafe[i] == 1)
			{
                if (!seenSafeMsg[i])
				{ 
				{
//                        SendClientMessage(i, COLOR_CORAL, "DEBUG:You are in the Safe Zone.");
						SaveWeapsForPlayer(i);
                        seenSafeMsg[i] = 1;
                    }
                }
                if (IsPlayerInVeh(i))
				{
				{
                        RemovePlayerFromVehicle(GetPlayerVehicleID(i));
                        SetVehicleToRespawn(GetPlayerVehicleID(i));
                        return 1;
                    }
                }
            }
            if (playerSafe[i] != 1)
			{
                if (seenSafeMsg[i] == 1)
				{
//                    SendClientMessage(i, COLOR_CORAL, "DEBUG:You have left the safe zone.");
                }
				LoadPlayerSavedWeaps(i);
                seenSafeMsg[i] = 0;
            }
        }
    return 1;
}
//------------------------------------------------------------------------------
//------------Ship safe zone ---------------------
public IsPlayerInVeh(playerid)
{
 //   if (!IsPlayerAdmin(playerid)) maybe needed for a later date
    if (IsPlayerInAnyVehicle(playerid))
	{
        new badvehiclemodel = GetVehicleModel(GetPlayerVehicleID(playerid));
        switch (badvehiclemodel)
		{
            case 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417,
                418, 419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430, 431, 432, 433, 434, 435, 436,
                437, 438, 439, 440, 441, 442, 443, 444, 445, 446, 447, 448, 451, 452, 453, 454, 455, 456, 457,
                458, 459, 460, 461, 462, 463, 464, 465, 466, 467, 468, 469, 470, 471, 472, 473, 474, 475, 476,
                477, 478, 479, 480, 481, 482, 483, 484, 485, 486, 487, 488, 489, 490, 491, 492, 493, 494, 495,
                496, 497, 498, 499, 500, 501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512, 513, 514,
                515, 516, 517, 518, 519, 520, 521, 522, 523, 524, 525, 526, 527, 528, 529, 530, 531, 532, 533,
                534, 535, 536, 537, 538, 539, 540, 541, 542, 543, 544, 545, 546, 547, 548, 549, 550, 551, 552,
                553, 554, 555, 556, 557, 558, 559, 560, 561, 562, 563, 564, 565, 566, 567, 568, 569, 570, 571,
                572, 573, 574, 575, 576, 577, 578, 579, 580, 581, 582, 583, 584, 585, 586, 587, 588, 589, 590,
                591, 592, 593, 594, 595, 596, 597, 598, 599, 600, 601, 602, 603, 604, 605, 606, 607, 608, 609,
                610, 611: 
			return 1;//put MODELIDS of vehicles you wish to restrict from the safe zone
        }
    }
    return 0;
}
//------------------------------------------------------------------------------
/*This is to show any MYSQL errors and save them to MySql_Error.txt in
the scriptfiles :-)
*/
public OnQueryError(errorid, error[], callback[], query[], connectionHandle)
{
	new 
		File:fhMySqlError,
		writestr[100],
		string[32],
		tstring[20],
		Year,
		Month,
		Day,
		Hour,
		Minute,
		Second;
	
	getdate(Year, Month, Day);
	gettime(Hour, Minute, Second);
	fhMySqlError = fopen("Server/MySql_Error.txt",io_append);
	format(string, sizeof(string), "%02d,%s,%d", Day, GetMonth(Month), Year);
	format(tstring,sizeof(tstring),"%02d:%02d:%02d", Hour, Minute, Second);
	format(writestr,sizeof(writestr), "Date: %s | Time %s - Error #%d - Error: %s | Query: %s\r\n", string, tstring, errorid, error, query);
	fwrite(fhMySqlError,writestr);
	fclose(fhMySqlError);
	printf("!!!!MySql Error. Check MySql_Error.txt!!!!");
	return 1;
}
//------------------------------------------------------------------------------
public KickPublic(playerid) 
{
	Kick(playerid); 
}
//------------------------------------------------------------------------------
public Jail(playerid, time)
{
	if (IsPlayerConnected(playerid))
	{
		new
			outputmessage[125];
		
		// The server will determine the time
		if(time == 999)
		{
			new guilty = randomEx(60,120);
			time = guilty;
		}
		else
		{
			time = 60*time;
		}
		
		// The player was already in prison
		if(IsPlayerJailed(playerid))
		{
			time = playerVariables[playerid][JailTime] + time;
		}
		
		// Time exceeds 10 minutes limit
		if (time>600)
		{
			time = 600;
		}
		
		
		// Necessary changes
		RemovePlayerFromVehicle(playerid);
		if(IsPlayerPaused(playerid))
		{
			SetPlayerHealth(playerid, 100);
		}
		
		// Put it in jail!
		
		SetPlayerJailSpawn(playerid);
		playerVariables[playerid][JailTime] = time;
		playerVariables[playerid][PlayerStatus] = STATUS_JAILED;
		
		// And tell him what's going on..
		new minutes = 0;
		new seconds = 0;
		
		if(playerVariables[playerid][JailTime] > 59)
		{
			minutes = floatround(playerVariables[playerid][JailTime]/60, floatround_floor);//floatround_floor	Round downwards.
		}
		seconds = playerVariables[playerid][JailTime] - (minutes*60);
		SendClientMessage(playerid, COLOR_LIME, HORIZONTAL_RULE);
		SendClientMessage(playerid, COLOR_RED, "You're put in prison because you have broken /RULES.");
		if (seconds == 0)
		{
			format(outputmessage, sizeof(outputmessage),"The court has determined that you should spend %d minute(s) thinking about your crime", minutes);
		}
		else
		{
			format(outputmessage, sizeof(outputmessage),"The court has determined that you have %d minute(s) and %d seconds thinking about your crime", minutes, seconds);
		}
		SendClientMessage(playerid, COLOR_PEACHPUFF, outputmessage);
		SendClientMessage(playerid, COLOR_PEACHPUFF, "Contact an admin if you think you're wrongly jailed.");
		SendClientMessage(playerid, COLOR_LIME, HORIZONTAL_RULE);
		format(outputmessage, sizeof(outputmessage), "%s is in jail for breaking the rules.", playerVariables[playerid][PlayerName]);
		news(outputmessage);
	}
}
//------------------------------------------------------------------------------
public UnJail(playerid,guilty)
{
	
	if (IsPlayerConnected(playerid))
	{
		if (playerVariables[playerid][PlayerStatus] == STATUS_JAILED){
			
			if (guilty == 1)
			{
				playerVariables[playerid][Jails]++;
			}
			new
			outputmessage[57];
			
			playerVariables[playerid][JailTime] = 0;
			playerVariables[playerid][PlayerStatus] = STATUS_NONE;
			SetPlayerVirtualWorld(playerid,0);
			SetPlayerInterior(playerid, 0);
			SetPlayerFacingAngle(playerid, 180.0000);
			SetPlayerPos(playerid, 2337.1001,2455.9500,14.9688);
			SendClientMessage(playerid, COLOR_PLUM, "You have been released from jail!");
			
			format(outputmessage, sizeof(outputmessage), "%s has been released from jail.", playerVariables[playerid][PlayerName]);
			news(outputmessage);
		}
	}
}
//------------------------------------------------------------------------------
public IsPlayerJailed(playerid)
{
	if (IsPlayerConnected(playerid))
	{
		if (playerVariables[playerid][PlayerStatus] == STATUS_JAILED)
		{
			return 1;
		}
	}
	return 0;
}
//------------------------------------------------------------------------------
public JailTimeUpdate()
{
	foreach(Player, i)
	{
			if (IsPlayerJailed(i))
			{
				playerVariables[i][JailTime]--;
				if (playerVariables[i][JailTime] == 0)
				{
					UnJail(i,1);
				}
			}
	}
}
//------------------------------------------------------------------------------
public SetPlayerJailSpawn(playerid)
{
	new Float:JailSpawns[2] = 
	{
		197.4298,
		193.9253
	};
	
	new rand = random(sizeof(JailSpawns));
	SetPlayerVirtualWorld(playerid,((playerid % 50) + 1 ));
	SetPlayerInterior(playerid,3);
	SetPlayerPos(playerid, JailSpawns[rand], 174.5428, 1003.0234);
}
//------------------------------------------------------------------------------
//!!!!!!!!!!!will change this later!!!!!!!!!!!!!
//gmx
public restartTimer()
{
    iGMXTick--;
    switch(iGMXTick)
	{
        case 0:
		{
            GameTextForAll("~w~The server is now restarting...", 9000, 5);
            SendClientMessageToAll(COLOR_LIGHTRED, "AdmCmd:{FFFFFF} The server is now set to restart, please wait for the server to restart.");
			OperationSaveTheWorld();
			cmd_KickAllGmx();
            mysql_close(dConnect);// Close the database connection. We're done here.
            KillTimer(iGMXTimer);
            SendRconCommand("gmx");
			}
        case 1: GameTextForAll("~w~The server will restart in...~n~ ~r~1~w~ second.", 1110, 5);
        case 2: GameTextForAll("~w~The server will restart in...~n~ ~r~2~w~ seconds.", 1110, 5);
        case 3: GameTextForAll("~w~The server will restart in...~n~ ~r~3~w~ seconds.", 1110, 5);
        case 4: GameTextForAll("~w~The server will restart in...~n~ ~r~4~w~ seconds.", 1110, 5);
        case 5: GameTextForAll("~w~The server will restart in...~n~ ~r~5~w~ seconds.", 1110, 5);
        case 6: GameTextForAll("~w~The server will restart in...~n~ ~r~6~w~ second.", 1110, 5);
        case 7: GameTextForAll("~w~The server will restart in...~n~ ~r~7~w~ seconds.", 1110, 5);
        case 8: GameTextForAll("~w~The server will restart in...~n~ ~r~8~w~ seconds.", 1110, 5);
        case 9: GameTextForAll("~w~The server will restart in...~n~ ~r~9~w~ seconds.", 1110, 5);
        case 10: GameTextForAll("~w~The server will restart in...~n~ ~r~10~w~ seconds.", 1110, 5);
		}
    return 1;
}
//------------------------------------------------------------------------------
public ReSpawnVehicles()
{
   for(new i; i < MAX_VEHICLES; i++) if(!IsVehicleOccupied(i)) SetVehicleToRespawn(i);
   #if defined DEBUG
   printf("All Un-Occupied Vehicles have been re-spawned");
   #endif
    return 1;
}
//------------------------------------------------------------------------------
public ServerNameUpdate()
{
	if(CurrentServerName==MAX_SERVER_NAMES)
		CurrentServerName=0;
	
	new
	string[96];
	if(ServerNames[CurrentServerName][0]=='*')
		format(string,sizeof(string),"hostname %s",MainServerName);
	else
		format(string,sizeof(string),"hostname %s",ServerNames[CurrentServerName]);
	SendRconCommand(string);
	CurrentServerName++;
	return 1;
}
//------------------------------------------------------------------------------
public PlayerTaxiTimer(playerid)
{
    PlayerTaxi[playerid]= 0;
    return 1;
}
//------------------------------------------------------------------------------
public PlayerGiveCashDelay(playerid)
{
	PlayerGiveCash[playerid]=0;
	return 1;
}
//====COMMANDS====================================
CMD:mouse(playerid, params[])
{
	SelectTextDraw(playerid, COLOR_YELLOW);
	return 1;
}
//------------------------------------------------------------------------------
CMD:help(playerid,params[])
{
	new
		string[190];
	format(string, sizeof(string), "Type: /commands to list all available commands\nType: /rules to see the server rules.\nType: /playing for a insight to the server.\nType: /contact for questions and tips related to the server.");
	ShowPlayerDialog(playerid, DIALOG_MSGBOX, DIALOG_STYLE_MSGBOX, "Welcome To World-Gamerz", string, "Close", "");
	return 1;
}
//------------------------------------------------------------------------------
CMD:commands(playerid,params[])
{
	new
		string[140];
	format(string, sizeof(string), "Type: /minigames\nType: /banking.\nType: /business.\nType: /transport.\nType: /ganghelp.\nType: /bounties.\nType: /rules.\nType: /misc ");
	ShowPlayerDialog(playerid, DIALOG_MSGBOX, DIALOG_STYLE_MSGBOX, "Available commands", string, "Close", "");
	return 1;
}
//------------------------------------------------------------------------------
CMD:rules(playerid,params[])
{
	new
		string[160];
    format(string, sizeof(string), "SERVER RULES:\nDONT BUG ABUSE.\n\nCHEATS ARE NOT ALLOWED.\n\nNO KILLING IN INTERIORS.\n\nTHE SHIP IS A SAFE ZONE,NO KILLING.\n\nUSE ENGLISH IN MAIN CHAT");
	ShowPlayerDialog(playerid, DIALOG_MSGBOX, DIALOG_STYLE_MSGBOX, "World-Gamerz Rules", string, "Close","");
	return 1;
}
//------------------------------------------------------------------------------
CMD:playing(playerid,params[])
{
	new
		string[280];
    format(string, sizeof(string), "This server aims to offer something for everyone!\nThe whole map is a deatmatch area,apart from the ship\nin LV and interiors.\nOr just cruise around in vehicles,\nbuy buisiness's and make money.\nBut just remember that anyone can shoot at you,what ever \nyou are doing!");
	ShowPlayerDialog(playerid, DIALOG_MSGBOX, DIALOG_STYLE_MSGBOX, "Strategies", string, "Close","");
	return 1;
}
//------------------------------------------------------------------------------
CMD:contact(playerid,params[])
{
	SendClientMessage(playerid, COLOR_YELLOWGREEN,"Contact:");
	SendClientMessage(playerid, COLOR_SPRINGGREEN,"For all your questions and comments can be posted at");
	SendClientMessage(playerid, COLOR_SPRINGGREEN,"www.world-gamerz.com");
	return 1;
}
//------------------------------------------------------------------------------
CMD:Ranks(playerid,params[])
{
	new 
		string[180];
	format(string, sizeof(string), "Player Ranks are based on you in-game time.\n0-10h:   Newbie\n10-20h:  go-getter\n20-30h:  master\n30-40h:  Pro\n40-50h:  Expert\n50-100h: Elite\n+100h:   Freak! ");
	ShowPlayerDialog(playerid, DIALOG_MSGBOX, DIALOG_STYLE_MSGBOX, "Player Ranks", string, "Close", "");
	return 1;
}
//------------------------------------------------------------------------------
CMD:ganghelp(playerid,params[])
{
	new
	string[200];
	format(string, sizeof(string), "If a few of you wish to start a gang and try to own san andreas\nthen feel free to make a gang\nGangs do not save at the moment\nbut will do in due course\nType: /gcommands for more info!. ");
	ShowPlayerDialog(playerid, DIALOG_MSGBOX, DIALOG_STYLE_MSGBOX, "Gangs", string, "Close", "");
	return 1;
}
//------------------------------------------------------------------------------
CMD:gcommands(playerid,params[])
{
	new
		string[230];
	format(string, sizeof(string), "Type: /gang create [name]\nType: /gang join\nType :/gang invite [playerid]\nType: /gang quit\nType: /gangs\nType: /ganginfo [number]\nType: /gbank [amount]\nType: /gopnemen [amount]\nType: /gbalance\n\nUse ! <for your gang-chat>");
	ShowPlayerDialog(playerid, DIALOG_MSGBOX, DIALOG_STYLE_MSGBOX, "Gang commands", string, "Close", "");
	return 1;
}
//------------------------------------------------------------------------------
CMD:bounties(playerid,params[]){
	new
		string[100];
	format(string, sizeof(string), "If you want to place a price on some one's head,\nthen these are the command for you.\n or If you want to make fast money then you can kill that person. \nType: /hitman [playerid] [amount]\nType: bounty [playerid]\nType :/hitlist for Current Bounties\n");
	return 1;
}
//------------------------------------------------------------------------------
CMD:hitman(playerid,params[])
{
		new 
			giveid,
			string[125],
			moneys;
			
		if(sscanf(params,"ui",giveid,moneys))
		{
			SendClientMessage(playerid, COLOR_WHITE, "USAGE: /hitman [playerid/partname] [amount]");
			return 1;
		}
	    if(moneys > GetPlayerMoney(playerid))
		{
			SendClientMessage(playerid, COLOR_RED, "You don't have enough money!");
			return 1;
	    }
	    if(moneys < 1)
		{
			SendClientMessage(playerid, COLOR_YELLOW, "Hey what are you trying to pull here.");
			return 1;
		}
		if (giveid == INVALID_PLAYER_ID)
		{
			SendClientMessage(playerid, COLOR_RED, "Dream on,There is no such player here.");
			return 1;
		}

		playerVariables[giveid][Bounty]+=moneys;
		GivePlayerMoney(playerid, 0-moneys);


		format(string, sizeof(string), "%s has had a $%d bounty put on his head from %s (total: $%d).", playerVariables[giveid][PlayerName], moneys, playerVariables[playerid][PlayerName], playerVariables[giveid][Bounty]);
		news(string);


		format(string, sizeof(string), "You have had a $%d bounty put on you from %s (id: %d).", moneys, playerid, playerVariables[playerid][PlayerName]);
		SendClientMessage(giveid, COLOR_RED, string);
		return 1;
	}
//------------------------------------------------------------------------------
CMD:bounty(playerid,params[])
{
	new
	giveid,
	string[125];
	
	if (sscanf(params, "u", giveid))
	{
		format(string, sizeof(string), "Usage: /givecash [playerid/partname]");
		SendClientMessage(playerid, COLOR_SNOW, string);
		return 1;
	}
	if (giveid == INVALID_PLAYER_ID)
	{
		format(string, sizeof(string), "ID: %d I know he's not here!", giveid);
		SendClientMessage(playerid, COLOR_SNOW, string);
	}
	
	else
	{
		format(string, sizeof(string), "%s (id: %d) has a $%d bounty on his head.", playerVariables[giveid][PlayerName],giveid,playerVariables[giveid][Bounty]);
		SendClientMessage(playerid, COLOR_YELLOW, string);
	}
	
	return 1;
}
//------------------------------------------------------------------------------
CMD:hitlist(playerid,params[])
{
	new
	x,
	giveplayer[MAX_PLAYER_NAME],
	string[75];
	
	SendClientMessage(playerid, COLOR_LIME, HORIZONTAL_RULE);
	SendClientMessage(playerid, COLOR_LAVENDER, "Current Bounties:");
	foreach (Player, i)
	{
		if(playerVariables[i][Bounty] > 0)
		{
			GetPlayerName(i, giveplayer, sizeof(giveplayer));
			format(string, sizeof(string), "%s%s(%d): $%d", string,giveplayer,i,playerVariables[i][Bounty]);
			x++;
			if(x > 3)
			{
				SendClientMessage(playerid, COLOR_YELLOW, string);
				x = 0;
				format(string, sizeof(string), "");
			}
			else
			{
				format(string, sizeof(string), "%s, ", string);
			}
		}
	}
	if(x <= 3 && x > 0)
	{
		string[strlen(string)-2] = '.';
		SendClientMessage(playerid, COLOR_YELLOW, string);
	}
	SendClientMessage(playerid, COLOR_LIME, HORIZONTAL_RULE);
	return 1;
}
//------------------------------------------------------------------------------
CMD:banking(playerid,params[])
{
	new
		string[340];
	format(string, sizeof(string), "You seriously dont want to be walking around with lots of money on you,\nbecause if you die you will lose all of your money.\nSo put your money in the Bank,there are plenty of \nthem around,just look out for the money icon on your map.\nPlus for any money in your account \nyou will recieve 1% interest every 15 minutes of playing");
	ShowPlayerDialog(playerid, DIALOG_MSGBOX, DIALOG_STYLE_MSGBOX, "banking", string, "Close", "");
	return 1;
}
//------------------------------------------------------------------------------
CMD:transport(playerid,params[])
{
	new
		string[250];
	format(string, sizeof(string), "If you get stuck somewhere in san andreas,then dont worry call a taxi,\njust type: /taxi and you will be shown a list of locations.\nBut this is not a free service.\nBut the train network is free and is available\nat any one of the four stations.");
	ShowPlayerDialog(playerid, DIALOG_MSGBOX, DIALOG_STYLE_MSGBOX, "Transport", string, "Close", "");
	return 1;
}
//------------------------------------------------------------------------------
CMD:misc(playerid,params[])
{
	new 
		string[150];
	format(string, sizeof(string), "Type: /skyfall\nType: /chillidog\nType: /pm [id] [message]\nType: /givemoney [id] [amount]\nType: /pause\nType: /lock or /open(vehicle doors)");
	ShowPlayerDialog(playerid, DIALOG_MSGBOX, DIALOG_STYLE_MSGBOX, "Misc commands", string, "Close", "");
	return 1;
}
//------------------------------------------------------------------------------
CMD:taxi(playerid,params[])
{
	if(!IsPlayerJailed(playerid) && !IsPlayerPaused(playerid))
	{
	new
		string[600];
	strcat(string,"Pirate ship \nYellow Bell Station(LV) \nLinden Station(LV) \nMarket Station(LS) \nUnity Station(LS) \nCranberry Station \nLas Venturas Airport \nprison \nGrove Street \nWang Cars \nMount Chilliad \nPolice Station \nAmmunition(East LV) \nAmmunition(South LV) \nArea 69 \nAirstrip \nFort Carson");
	strcat(string,"\nLas Barrancas \nEl Quebrados \nLas Payasadas \nBayside	\nPalomino Creek \nHampton Barns \nBlueberry \nDillimore \nLeafy Hollow \nLos Santos Airport \nKACC Military Fuels \nAngel Pine \nEaster Bay Airport \nSan Fierro Airport \nDowntown Los Santos \nLos Santos Basejumping");
	ShowPlayerDialog(playerid,DIALOG_TAXI,DIALOG_STYLE_LIST,"Welcome To San Andreas Taxi's",string,"Taxi", "Cancel");
	}
	return 1;
}
//-----------------------------------------------------------------------------
CMD:seepms(playerid, params[]) {
	switch(playerVariables[playerid][PmStatus]) {
		case 0: {
		    playerVariables[playerid][PmStatus] = 1;
			return SendClientMessage(playerid, COLOR_WHITE, "You have disabled your PMs.");
		}
		case 1: {
		    playerVariables[playerid][PmStatus] = 0;
			return SendClientMessage(playerid, COLOR_WHITE, "You have enabled your PMs.");
		}
	}
	return 1;
}
//------------------------------------------------------------------------------
CMD:pm(playerid, params[])
{
	new
	PmMessage[128],
	OutPutMessage[128],
	giveid;
	
	if(sscanf(params, "us[128]", giveid, PmMessage))
	{
		SendClientMessage(playerid, COLOR_SNOW,"USAGE: /pm [playerid/partname] [message]");
		return 1;
	}
	if (giveid == INVALID_PLAYER_ID)
	{
		format(OutPutMessage, sizeof(OutPutMessage), "ID: %d I know he's not here!", giveid);
		SendClientMessage(playerid, COLOR_SNOW, OutPutMessage);
	}
	
	if(playerVariables[giveid][PmStatus] == 0) {
		OnPlayerPrivmsg(playerid, giveid, PmMessage);
/*	
		format(OutPutMessage, sizeof(OutPutMessage), "(( PM from %s: %s ))", playerVariables[playerid][PlayerName], PmMessage);
		SendClientMessage(giveid, COLOR_YELLOW, OutPutMessage);
		format(OutPutMessage, sizeof(OutPutMessage), "(( PM sent to %s: %s ))", playerVariables[giveid][PlayerName], PmMessage);
		SendClientMessage(playerid, COLOR_GREY, OutPutMessage);
*/		
	}
	else {
		return SendClientMessage(playerid, COLOR_GREY, "That player's PMs aren't enabled.");
	}
	return 1;
}
//------------------------------------------------------------------------------
CMD:fubar(playerid,params[])
{
	SendClientMessage(playerid, COLOR_GOLDENROD,"Congratulations, you have found a hidden command!");
	return 1;
}
//------------------------------------------------------------------------------
CMD:lock(playerid,params[]){
	if(IsPlayerInAnyVehicle(playerid)) 
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
		{
			SendClientMessage(playerid, COLOR_DIMGRAY, "What are you doing? loser!");
			return 1;
		}
		foreach(Player, i)
		{
			if(i != playerid)
			{
				SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid),i, 0, 1);
			}
		}
		SendClientMessage(playerid,COLOR_DEEPSKYBLUE,"Your car is locked!");
	}
	else 
	{
		SendClientMessage(playerid,COLOR_DIMGRAY,"Fool!");
	}
	return 1;
}
//------------------------------------------------------------------------------
CMD:unlock(playerid,params[])
{
	if(IsPlayerInAnyVehicle(playerid)) 
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
		{
			SendClientMessage(playerid, COLOR_DIMGRAY, "Shame on you!");
			return 1;
		}
		foreach(Player, i)
		{
			SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid),i, 0, 0);
		}
		SendClientMessage(playerid,COLOR_FLORALWHITE,"Your car is un-locked!");
	}
	else
	{
		SendClientMessage(playerid,COLOR_DODGERBLUE,"Fool!");
	}
	return 1;
}
//------------------------------------------------------------------------------
CMD:stats(playerid,params[])
{
	new
		player1;
	if(isnull(params)) player1 = playerid;
	else player1 = strval(params);
	if(IsPlayerConnected(player1))
	{
		ReturnPlayerStats(player1,playerid);
	}
	else return SendClientMessage(playerid, COLOR_ALICEBLUE, "This player id is not online, arse!");
	return 1;
}
//------------------------------------------------------------------------------
CMD:register(playerid,params[])
{
	if(playerVariables[playerid][PlayerStatus] == STATUS_NONE)
	{
	SendClientMessage(playerid, COLOR_ALICEBLUE, "You are already registered, Stupid!");
	}
	else
	{
	new szMessage[128];
	format(szMessage, sizeof(szMessage), "SERVER: Please enter a password to register a new account for user name (%s).", playerVariables[playerid][PlayerName]);
	ShowPlayerDialog(playerid, DIALOG_REGISTER2, DIALOG_STYLE_PASSWORD, "SERVER: Register", szMessage, "Register", "Cancel");
	}
	return 1;
}
//------------------------------------------------------------------------------
CMD:countdown(playerid,params[])
{
	if(TickCount[CountDownTimer] != 0)
	{
		SendClientMessage(playerid, COLOR_ALICEBLUE, "The countdown has already started!");
		return 1;
	}
	//maybe some admin action here.laters
	TickCount[CountDownTimer] = 4;
	return 1;
}
//------------------------------------------------------------------------------
CMD:pause(playerid,params[])
{
	PausePlayer(playerid);
	return 1;
}
//------------------------------------------------------------------------------
CMD:chillidog(playerid,params[])
{
	new 
		Float:health;
	if(IsPlayerInRangeOfPoint(playerid, 3, 2000.8953, 1554.2316, 14.4390))
	{
		if(GetPlayerMoney(playerid) < 1000) 
		{
			SendClientMessage(playerid, COLOR_ALICEBLUE, "You do not have enough money for a chillidog!");
			return 1;
		}
		GetPlayerHealth(playerid, health);
		if (health < 100) 
		{
			health = 100-health;
			if (health > 50) 
			{
				SetPlayerHealth(playerid, 100-health+50);
			}
			else 
			{
				SetPlayerHealth(playerid, 500);
			}
		}
		GiveMoney(playerid, -1000);
		SendClientMessage(playerid, COLOR_CORNFLOWERBLUE, "Bon appetit!");
	}
	else 
	{
		SendClientMessage(playerid, COLOR_RED, "You must be a chillidog marker. USE /chillidog");
	}
	return 1;
}
//------------------------------------------------------------------------------
CMD:skyfall(playerid,params[])
{
	if(!IsPlayerJailed(playerid) && !IsPlayerPaused(playerid))
	{
	new
		outputmessage[80],
		Float:x,
		Float:y,
		Float:z;

	if(GetPlayerMoney(playerid) < ServerPrice[Skydive])
	{
		format(outputmessage, sizeof(outputmessage), "idiot, you do not have enough money for skyfall: $%d .", ServerPrice[Skydive]);
		SendClientMessage(playerid,COLOR_RED, outputmessage);
		return 1;
	}

	GetPlayerPos(playerid,x,y,z);
	SetPlayerInterior(playerid, 0);
	SetPlayerPos(playerid,x,y,900);
	GivePlayerWeapon(playerid,WEAPON_PARACHUTE,1);
	GiveMoney(playerid,-ServerPrice[Skydive]);
	GameTextForPlayer(playerid,"Diiiive.",3000,5);
	}
	return 1;
}
//------------------------------------------------------------------------------
CMD:setname(playerid, params[]) 
{
	new
	szQuery[128],
	Player,
	NewPlayerName[MAX_PLAYER_NAME];
	
	if(sscanf(params, "us[24]", Player, NewPlayerName))
		return SendClientMessage(playerid, COLOR_SNOW, "SERVER: /setname [playerid] [new name]");
	SetPVarInt(Player, "changeBy", playerid);
	SetPVarString(Player, "oldName", playerVariables[Player][PlayerName]);
	mysql_real_escape_string(NewPlayerName, playerVariables[Player][PlayerName], 24);
	format(szQuery, sizeof(szQuery), "UPDATE players SET Username = '%s' WHERE ID = %d", playerVariables[Player][PlayerName], playerVariables[Player][pDBID]);
	mysql_query(szQuery, THREAD_CHANGE_NAME, Player, dConnect);
	
	return 1;
}
//------------------------------------------------------------------------------
CMD:givecash(playerid,params[])
{
	new 
	giveid,
	moneys,
	string[64];
	
	if (sscanf(params, "ud", giveid, moneys))
	{
		format(string, sizeof(string), "Usage: /givecash [playerid/partname] [amount]");
		SendClientMessage(playerid, COLOR_SNOW, string);
		return 1;
	} 
	
	if(PlayerGiveCash[playerid]==1)
	{
		format(string, sizeof(string), "*** You can only send money once every 60 seconds.");
		SendClientMessage(playerid, COLOR_SNOW, string);
		return 1;
	}
	else if (giveid == INVALID_PLAYER_ID)
	{
		format(string, sizeof(string), "ID: %d I know he's not here!", giveid);
		SendClientMessage(playerid, COLOR_SNOW, string);
	}
	else if (moneys > GetPlayerMoney(playerid)>= moneys && moneys <= MAX_GIVECASH) SendClientMessage(playerid, COLOR_SNOW, "That will not work...");
	else
	{
		GiveMoney(playerid, -moneys);
		GiveMoney(giveid, moneys);
		format(string, sizeof(string), "you've given %s (id: %d) $%d.", playerVariables[giveid][PlayerName],giveid, moneys);
		SendClientMessage(playerid, COLOR_ORANGE, string);
		format(string, sizeof(string), "you've received $%d from %s (id: %d).", moneys, playerVariables[playerid][PlayerName], playerid);
		SendClientMessage(giveid, COLOR_ORANGERED, string);
		PlayerGiveCash[playerid]=1;
		SetTimerEx("PlayerGiveCashDelay",60000,false,"i",playerid);
	}
	return 1;
}

//Gang Commands----------------------------------------------------------------
CMD:gang(playerid,params[])
{
	#pragma unused params
	ShowPlayerDialog(playerid, DIALOG_GANG, DIALOG_STYLE_LIST, "World-Gamerz Gang commands", "Create A Gang\nJoin A Gang \nInvite Player To Your Gang \nQuit Your Current Gang", "Proceed", "Cancel");
}
//------------------------------------------------------------------------------
CMD:gangs(playerid,params[])
{
	new 
		x,
		string[256];
	
	for(new i=0; i < MAX_GANGS; i++) 
	{
		if(GangInfo[i][GangMembers]==1) 
		{
			format(string, sizeof(string), "%s%s(%d) - %d members", string,GangInfo[i][GangName],i,GangInfo[i][GangMembers]);
			x++;
			if(x > 2) 
			{
				ShowPlayerDialog(playerid, DIALOG_MSGBOX, DIALOG_STYLE_MSGBOX, "Current San Andreas Gangs", string, "Close", "");
				x = 0;
				format(string, sizeof(string), "");
				} 
				else 
				{
				format(string, sizeof(string), "%s \n", string);
			}
		}
	}
	
	if(x <= 2 && x > 0) 
	{
		string[strlen(string)-2] = '.';
		ShowPlayerDialog(playerid, DIALOG_MSGBOX, DIALOG_STYLE_MSGBOX, "Current San Andreas Gangs", string, "Close", "");
	}
	
	return 1;
}
//------------------------------------------------------------------------------
CMD:speed(playerid,params[])
{
		new
		string[50];
		format(string, sizeof(string),"Vehicle Speed Normal\n\nVehicle Speed Faster");
		ShowPlayerDialog(playerid, DIALOG_SPEED, DIALOG_STYLE_LIST,"Vehicle Speed Control", string, "Process", "Cancel");
		return 1;
	}
//------------------------------------------------------------------------------
CMD:bug(playerid,params[])
{
		new
		szMessage[128];
		format(szMessage, sizeof(szMessage), "SERVER: Your about to submit a bug report,make sure you give clear description on what bug your reporting.");
		ShowPlayerDialog(playerid, DIALOG_BUG_REPORT, DIALOG_STYLE_INPUT, "SERVER: Bug Report", szMessage, "Submit", "Cancel");
		return 1;
}
//------------------------------------------------------------------------------
CMD:saveskin(playerid, params[])
{
	if(playerVariables[playerid][PlayerStatus] !=STATUS_NONE)
	{
		SendClientMessage(playerid, COLOR_MEDIUMVIOLETRED, "You must be logged in to use this command");
		return 1;
	}
	
	if(playerVariables[playerid][IngameTime] >= 600)// over 10 hours
	{
		playerVariables[playerid][Skin] = GetPlayerSkin(playerid);
		playerVariables[playerid][UseSkin] = 1;
		SaveSaveablePlayerInfo(playerid);
		SendClientMessage(playerid, COLOR_YELLOWGREEN, "You Have Saved Your Skin");
		return 1;
	}
	
	SendClientMessage(playerid, COLOR_YELLOWGREEN, "You must be Ranked higher to use this command");
	return 1;
}
//------------------------------------------------------------------------------
CMD:unsaveskin(playerid, params[])
{
	if(playerVariables[playerid][PlayerStatus] !=STATUS_NONE)
	{
		SendClientMessage(playerid, COLOR_MEDIUMVIOLETRED, "You must be logged in to use this command");
		return 1;
	}
	
	if(playerVariables[playerid][UseSkin] == 1)
	{
		playerVariables[playerid][Skin] = 0;
		playerVariables[playerid][UseSkin] = 0;
		SaveSaveablePlayerInfo(playerid);
		SendClientMessage(playerid, COLOR_YELLOWGREEN, "You Have Un Saved Your Skin");
		return 1;
	}
	
	SendClientMessage(playerid, COLOR_YELLOWGREEN, "You Freak,You never saved your skin in the first place");
	return 1;
}
//------------------------------------------------------------------------------
//----Admin Commands
//------------------------------------------------------------------------------
CMD:gmx(playerid, params[]) 
{
    if(IsPlayerAdmin(playerid))
	{	
		ShowPlayerDialog(playerid, DIALOG_GMX, DIALOG_STYLE_MSGBOX, ""#CRED"Server Restart", ""#CYELLOW"Please confirm whether you are positive that you wish to initiate a server restart?", "Yes", "No");
		}
    return 1;
}
//------------------------------------------------------------------------------
CMD:rac(playerid, params[])
{
	#pragma unused params
	if(IsPlayerAdmin(playerid))
	{
		ReSpawnVehicles();
	}
	return 1;
}
//------------------------------------------------------------------------------
CMD:KickAllGmx()//this is only used for gmx command
{
    foreach (Player, i)
    {
        Kick(i);
    }
    return true;
}

//====STOCKS======================================
stock clearScreen(playerid)
 {
	SendClientMessage(playerid, COLOR_WHITE, " ");
	SendClientMessage(playerid, COLOR_WHITE, " ");
	SendClientMessage(playerid, COLOR_WHITE, " ");
	SendClientMessage(playerid, COLOR_WHITE, " ");
	SendClientMessage(playerid, COLOR_WHITE, " ");
	SendClientMessage(playerid, COLOR_WHITE, " ");
	SendClientMessage(playerid, COLOR_WHITE, " ");
	SendClientMessage(playerid, COLOR_WHITE, " ");
	SendClientMessage(playerid, COLOR_WHITE, " ");
	SendClientMessage(playerid, COLOR_WHITE, " ");
	SendClientMessage(playerid, COLOR_WHITE, " ");
	return 1;
}
//------------------------------------------------------------------------------
stock zonename(i, j)
{
	KillTimer(ZnameTimer[i]);
	format(lstring, sizeof(lstring), "%s",zones[j][zone_name]);
	TextDrawShowForPlayer(i, ZoneText[i]);
	TextDrawSetString(ZoneText[i],lstring);
	ZnameTimer[i] = SetTimerEx("HideZoneName", 2500, 0, "i", i);
	return 1;
}
//------------------------------------------------------------------------------
stock SaveWeapsForPlayer ( playerid )
{
    if(shipDisarm[playerid] == 0) 
	{
        for(new weapSlot = 0; weapSlot != 13; weapSlot++) 
		{
            GetPlayerWeaponData(playerid, weapSlot, SavedPlayerWeaps[playerid][weapSlot][0], SavedPlayerWeaps[playerid][weapSlot][1]);
        }
        shipDisarm[playerid] = 1;
        ResetPlayerWeapons(playerid);
    }
    return 1;
}
//------------------------------------------------------------------------------
stock LoadPlayerSavedWeaps ( playerid )
{
	if (shipDisarm[playerid] == 1)
	{
		shipDisarm[ playerid ] = 0;
		for(new weapSlot = 0; weapSlot != 13; weapSlot++)
		{
			if (SavedPlayerWeaps[playerid][weapSlot][0] != 0)
			{
				{
				GivePlayerWeapon(playerid, SavedPlayerWeaps[playerid][weapSlot][0], SavedPlayerWeaps[playerid][weapSlot][1]);
				}
			}
			SavedPlayerWeaps[playerid][weapSlot][0] = 0;
			SavedPlayerWeaps[playerid][weapSlot][1] = 0;
		}
	}
}	
//------------------------------------------------------------------------------
stock GetMonth(Month)
{
	new MonthStr[15];
	switch(Month)
	{
		case 1:  MonthStr = "January";
		case 2:  MonthStr = "February";
		case 3:  MonthStr = "March";
		case 4:  MonthStr = "April";
		case 5:  MonthStr = "May";
		case 6:  MonthStr = "June";
		case 7:  MonthStr = "July";
		case 8:  MonthStr = "August";
		case 9:  MonthStr = "September";
		case 10: MonthStr = "October";
		case 11: MonthStr = "November";
		case 12: MonthStr = "December";
	}
	return MonthStr;
}
//------------------------------------------------------------------------------
stock ResidingCountry(playerid)
{
	new lStr[120],country[MAX_COUNTRY_NAME];
	country = GetPlayerCountryName(playerid);
	format(lStr, sizeof(lStr), ""#CBLUE"%s: ID"#CYELLOW"[%d]: "#CBLUE"location: "#CDGREEN"[%s] "#CORANGE" has joined the server", playerVariables[playerid][PlayerName], playerid, country);
	SendClientMessageToAll(-1, lStr);
	return 1;
}
//------------------------------------------------------------------------------
stock ResetPlayerVariables(playerid)
{
	GetPlayerName(playerid, playerVariables[playerid][PlayerName], MAX_PLAYER_NAME);
	mysql_real_escape_string(playerVariables[playerid][PlayerName], playerVariables[playerid][PlayerName], dConnect);
	playerVariables[playerid][PlayerStatus] = STATUS_NOTLOGGEDIN;
	playerVariables[playerid][Checkpoint] = CP_NONE;
	playerVariables[playerid][GangInvite] = GANG_NONE;
	playerVariables[playerid][Gang] = GANG_NONE;
	playerVariables[playerid][BackPos][0] = 0;
	playerVariables[playerid][BackPos][1] = 0;
	playerVariables[playerid][BackPos][2] = 0;
	playerVariables[playerid][RegDate] = 0;
	playerVariables[playerid][WatchingPlayer] = INVALID_PLAYER_ID;
	playerVariables[playerid][Money] = 0;
	playerVariables[playerid][PlayerMute] = 0;
	playerVariables[playerid][pMoney] = 0;
	playerVariables[playerid][Bank] = 0;
	playerVariables[playerid][Bounty] = 0;
	playerVariables[playerid][JailTime] = 0;
	playerVariables[playerid][IngameTime] = 0;
	playerVariables[playerid][Kills] = 0;
	playerVariables[playerid][Deaths] = 0;
	playerVariables[playerid][Jails] = 0;
	playerVariables[playerid][Kicks] = 0;
	playerVariables[playerid][Skin] = 0;
	playerVariables[playerid][UseSkin] = 0;
	playerVariables[playerid][NotLoggedInTime] = 0;
	playerVariables[playerid][FirstTimeSpawned] = 1;
	playerVariables[playerid][PlayerRanking] = RANK_STARTER;
	playerVariables[playerid][MaxBank] = 500000;
	playerVariables[playerid][PlayerSavedPos][0] = 0.0;
	playerVariables[playerid][PlayerSavedPos][1] = 0.0;
	playerVariables[playerid][PlayerSavedPos][2] = 0.0;
	playerVariables[playerid][ResetToBackPos] = 0;
	playerVariables[playerid][Speed] = 0;
	playerVariables[playerid][PmStatus] = 0;
	PlayerTaxi[playerid] = 0;
	PlayerGiveCash[playerid]=0;	
	return 1;
}
//------------------------------------------------------------------------------
stock SecondsToTime(seconds)
{
	new 
		timeminutes,
		timeseconds,
		timesecondsstr[2],
		time[8];
	
	timeminutes = floatround(seconds/60, floatround_floor);
	timeseconds = seconds - (timeminutes*60);
	
	valstr(timesecondsstr, timeseconds);
	if(strlen(timesecondsstr)<2)
	{
		format (timesecondsstr, 2, "0%s",timesecondsstr);
	}
	format(time, 8, "%d:%s", timeminutes, timesecondsstr);
	
	return time;
}
//------------------------------------------------------------------------------
stock SaveSaveablePlayerInfo(playerid)
{
	new 
		szQuery[512],//512 Since we're going to save a lot of data, our query size will need to be big.
		cash = GetPlayerMoney(playerid),
		string[64],
		Year,
		Month,
		Day,
		bank = playerVariables[playerid][Bank];
	
	if(cash > MAX_PLAYER_SPAWNCASH) 
	{
		cash = MAX_PLAYER_SPAWNCASH;
	}

	if(bank > playerVariables[playerid][MaxBank]) 
	{
		bank = playerVariables[playerid][MaxBank];
	}
	
	getdate(Year, Month, Day);
	format(string, sizeof(string), "%02d,%s,%d", Day, GetMonth(Month), Year);
	format(szQuery, sizeof(szQuery), "UPDATE players SET cash = %d, bank = %d, jailTime = %d, laston = '%s'", cash, playerVariables[playerid][Bank], playerVariables[playerid][JailTime], string);
	format(szQuery, sizeof(szQuery),"%s, ingameTime = %d,kills = %d,deaths = %d,jails = %d,kicks = %d", szQuery, playerVariables[playerid][IngameTime], playerVariables[playerid][Kills], playerVariables[playerid][Deaths], playerVariables[playerid][Jails], playerVariables[playerid][Kicks]);
	format(szQuery, sizeof(szQuery),"%s, skin = %d ,useskin = %d WHERE ID = %d", szQuery, playerVariables[playerid][Skin], playerVariables[playerid][UseSkin], playerVariables[playerid][pDBID]);	
	mysql_query(szQuery, THREAD_NO_RESULT, playerid, dConnect);
	return 1;
}
//------------------------------------------------------------------------------
stock IsPlayerConnectedEx(playerid)
 {
	if(IsPlayerConnected(playerid) && playerVariables[playerid][PlayerStatus] == 1) return 1;
	return 0;
}
//------------------------------------------------------------------------------
stock KickWithMessage(playerid, message[])
{
	SendClientMessage(playerid, COLOR_BUTTONHIGHLIGHT, message);
	SetTimerEx("KickPublic", 1000, 0, "d", playerid); 	//Delay of 1 second before kicking the player so he recieves the message
}
//------------------------------------------------------------------------------
stock ToggleMainMenu(playerid, toggle)
{
	for(new i=0; i<sizeof(MainMenu); i++) 
	{
		if(toggle) 
		{
			TextDrawShowForPlayer(playerid, MainMenu[i]);
			TogglePlayerControllable(playerid, 0);
		}
		
		else 
		{
			TextDrawHideForPlayer(playerid, MainMenu[i]);
			TogglePlayerControllable(playerid, 1);
		}
	}
	return 1;
}	
//------------------------------------------------------------------------------
stock randomEx(min, max)
{    
    //Credits to y_less    
    new rand = random(max-min)+min;    
    return rand;
}
//------------------------------------------------------------------------------
stock mySQL_init()
{
	new
	szQueryOutput[256],
	File: fhConnectionInfo = fopen("Server/MySQL.txt", io_read);
	
	fread(fhConnectionInfo, szQueryOutput);
	fclose(fhConnectionInfo);
	sscanf(szQueryOutput, "p<|>e<s[32]s[32]s[32]s[64]>", connectionInfo);
	dConnect = mysql_connect(connectionInfo[szDatabaseHostname], connectionInfo[szDatabaseUsername], connectionInfo[szDatabaseName], connectionInfo[szDatabasePassword]);
	
	#if defined DEBUG
	mysql_debug(1);
	printf("[debug] initiateConnections() '%s', '%s', '%s', '%s'", szQueryOutput, connectionInfo[szDatabaseHostname], connectionInfo[szDatabaseUsername], connectionInfo[szDatabaseName], connectionInfo[szDatabasePassword]);
	#endif
	return 1;
}
//------------------------------------------------------------------------------
stock KickPlayer(playerid, reason[])
{
	new File:fhandle,
		writestr[256],
		string[256],
		Dstr[64],
		Tstr[64],
		Year,
		Month,
		Day,
		Hour,
		Minute,
		Second;
	
	getdate(Year, Month, Day);
	gettime(Hour, Minute, Second);
	format(Dstr, sizeof(Dstr), "%02d,%s,%d", Day, GetMonth(Month), Year);
	format(Tstr,sizeof(Tstr),"%02d:%02d:%02d", Hour, Minute, Second);
	fhandle = fopen("Server/kicklist.txt",io_append);
	format(writestr,sizeof(writestr), "Date: %s | Time: %s |Name: %s -> %s -> Autokick \r\n", Dstr, Tstr, playerVariables[playerid][PlayerName], reason);
	fwrite(fhandle,writestr);
	fclose(fhandle);
	playerVariables[playerid][Kicks]++;
	format(string, sizeof(string), "%s is kicked. reason: %s", playerVariables[playerid][PlayerName], reason);
	news(string);
	KickWithMessage(playerid, reason);
	return 1;
}
//------------------------------------------------------------------------------
stock IsVehicleOccupied(vehicleid)
{
	foreach(Player, i)
    {
        if(GetPlayerVehicleID(i) == vehicleid) return 1;
    }
    return 0;
}
//================================================
LoadTextDraws()
{
	print("- Loading TextDraws...");
//--Infobar
	InfoBar					=TextDrawCreate(320.000000, 435.000000, "Information bar for holding information about the server. If this message shows, something is broken!");
	TextDrawAlignment		(InfoBar, 2);
	TextDrawBackgroundColor	(InfoBar, 255);
	TextDrawFont			(InfoBar, 1);
	TextDrawLetterSize		(InfoBar, 0.32, 1.2);
	TextDrawColor			(InfoBar, -1);
	TextDrawSetOutline		(InfoBar, 0);
	TextDrawSetProportional	(InfoBar, 1);
	TextDrawSetShadow		(InfoBar, 1);
	TextDrawUseBox			(InfoBar, 1);
	TextDrawBoxColor		(InfoBar, 0x000000AA);
	TextDrawTextSize		(InfoBar, 20.000000, 640.000000);
//--Start Screen TextDraws
	/* Bottom Bar */
	MainMenu[0] = TextDrawCreate(250.000000, 343.000000, "~n~~n~~n~~n~~n~~n~");
	TextDrawAlignment(MainMenu[0], 2);
	TextDrawBackgroundColor(MainMenu[0], 255);
	TextDrawFont(MainMenu[0], 1);
	TextDrawLetterSize(MainMenu[0], 1.000000, 2.000000);
	TextDrawColor(MainMenu[0], -16776961);
	TextDrawSetOutline(MainMenu[0], 1);
	TextDrawSetProportional(MainMenu[0], 1);
	TextDrawUseBox(MainMenu[0], 1);
	TextDrawBoxColor(MainMenu[0], 255);
	TextDrawTextSize(MainMenu[0], 90.000000, 803.000000);
	
	/* Top Bar */
	MainMenu[1] = TextDrawCreate(250.000000, -12.000000, "~n~~n~~n~~n~~n~~n~");
	TextDrawAlignment(MainMenu[1], 2);
	TextDrawBackgroundColor(MainMenu[1], 255);
	TextDrawFont(MainMenu[1], 1);
	TextDrawLetterSize(MainMenu[1], 1.000000, 2.000000);
	TextDrawColor(MainMenu[1], -16776961);
	TextDrawSetOutline(MainMenu[1], 1);
	TextDrawSetProportional(MainMenu[1], 1);
	TextDrawUseBox(MainMenu[1], 1);
	TextDrawBoxColor(MainMenu[1], 255);
	TextDrawTextSize(MainMenu[1], 90.000000, 918.000000);
	
	/* Top Colored Bar */
	MainMenu[2] = TextDrawCreate(729.000000, 99.000000, "_");
	TextDrawBackgroundColor(MainMenu[2], 255);
	TextDrawFont(MainMenu[2], 1);
	TextDrawLetterSize(MainMenu[2], 50.000000, 0.099999);
	TextDrawColor(MainMenu[2], -16776961);
	TextDrawSetOutline(MainMenu[2], 0);
	TextDrawSetProportional(MainMenu[2], 1);
	TextDrawSetShadow(MainMenu[2], 1);
	TextDrawUseBox(MainMenu[2], 1);
	TextDrawBoxColor(MainMenu[2], 0x1564F5FF);
	TextDrawTextSize(MainMenu[2], -5.000000, 1031.000000);
	
	/* Bottom Colored Bar */
	MainMenu[3] = TextDrawCreate(729.000000, 340.000000, "_");
	TextDrawBackgroundColor(MainMenu[3], 255);
	TextDrawFont(MainMenu[3], 1);
	TextDrawLetterSize(MainMenu[3], 50.000000, 0.099999);
	TextDrawColor(MainMenu[3], -16776961);
	TextDrawSetOutline(MainMenu[3], 0);
	TextDrawSetProportional(MainMenu[3], 1);
	TextDrawSetShadow(MainMenu[3], 1);
	TextDrawUseBox(MainMenu[3], 1);
	TextDrawBoxColor(MainMenu[3], 0x1564F5FF);
	TextDrawTextSize(MainMenu[3], -5.000000, 1031.000000);
}
//================================================	
/*
=============		  =========== 			===============	
=============		 =============			===============
==					==			 ==			==
==				   ==			  ==		==
==				  ==			   ==		==	
==				 ==		 			==		==
=============	==	                 ==		===============	
=============	== 					 ==		===============	
==				 ==					 ==		==	
==				  ==				==		==	
==				   ==			   ==		==
==					==			  ==		==
=============		 ==============			==
=============		  ============			==
*/
