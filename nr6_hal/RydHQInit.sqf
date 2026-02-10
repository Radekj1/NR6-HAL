if not (isServer) exitWith {};
RYD_Path = "\NR6_HAL\";
if (isNil ("RydHQ_Wait")) then 
{
    RydHQ_Wait = ((_this select 0) getvariable "RydHQ_Wait"); 
    if (isNil ("RydHQ_Wait")) then {RydHQ_Wait = 15;};
};

private _sc = 0;

hint str RydHQ_Wait;
sleep 5;
while 
{(RydHQ_Wait > _sc) and (missionNamespace getVariable ["Hal_FS", false] == false);} 
do 
{
	_sc = _sc + 1;
	sleep 1;
	hint str _sc;
};
HQInit1 = false;
HQInit2 = false;
//calling cba to execute global variables in unsheduled mode.
[{

RydxHQ_ReconCargo = missionNamespace getvariable ["RydxHQ_ReconCargo",true];
publicVariable "RydxHQ_ReconCargo";
RydxHQ_SynchroAttack = missionNamespace getvariable ["RydxHQ_SynchroAttack",false];
publicVariable "RydxHQ_SynchroAttack";
RydxHQ_InfoMarkersID = missionNamespace getvariable ["RydxHQ_InfoMarkersID",true];
publicVariable "RydxHQ_InfoMarkersID";

RydxHQ_Actions = missionNamespace getvariable ["RydxHQ_Actions",true];
publicVariable "RydxHQ_Actions";
RydxHQ_ActionsMenu = missionNamespace getvariable ["RydxHQ_ActionsMenu",true];
publicVariable "RydxHQ_ActionsMenu";

RydxHQ_TaskActions = missionNamespace getvariable ["RydxHQ_TaskActions",false];
publicVariable "RydxHQ_TaskActions";
RydxHQ_SupportActions = missionNamespace getvariable ["RydxHQ_SupportActions",false];
publicVariable "RydxHQ_SupportActions";
RydxHQ_ActionsAceOnly = missionNamespace getvariable ["RydxHQ_ActionsAceOnly",false];
publicVariable "RydxHQ_ActionsAceOnly";

RydxHQ_NoRestPlayers = missionNamespace getvariable ["RydxHQ_NoRestPlayers",true];
publicVariable "RydxHQ_NoRestPlayers";
RydxHQ_NoCargoPlayers = missionNamespace getvariable ["RydxHQ_NoCargoPlayers",true];
publicVariable "RydxHQ_NoCargoPlayers";

RydxHQ_LZ = missionNamespace getvariable ["RydxHQ_LZ",true];
publicVariable "RydxHQ_LZ";

RydART_Safe = missionNamespace getvariable ["RydART_Safe",250];
publicVariable "RydART_Safe";

RydHQ_LZ = RydxHQ_LZ;
RydHQB_LZ = RydxHQ_LZ;
RydHQC_LZ = RydxHQ_LZ;
RydHQD_LZ = RydxHQ_LZ;
RydHQE_LZ = RydxHQ_LZ;
RydHQF_LZ = RydxHQ_LZ;
RydHQG_LZ = RydxHQ_LZ;
RydHQH_LZ = RydxHQ_LZ;

//LZ setting was coded in entire system as Leader specific despite making far more sense as a general setting. Will clean it up eventually.

RydxHQ_HQChat = missionNamespace getvariable ["RydxHQ_HQChat",true];
publicVariable "RydxHQ_HQChat";
RydxHQ_AIChatDensity = missionNamespace getvariable ["RydxHQ_AIChatDensity",100];
publicVariable "RydxHQ_AIChatDensity";
RydxHQ_AIChat_Type = missionNamespace getvariable ["RydxHQ_AIChat_Type",100];
publicVariable "RydxHQ_AIChat_Type";
RydxHQ_GarrisonV2 = missionNamespace getvariable ["RydxHQ_GarrisonV2",true];
publicVariable "RydxHQ_GarrisonV2";
RydxHQ_NEAware = missionNamespace getvariable ["RydxHQ_NEAware",500];
publicVariable "RydxHQ_NEAware";
RydxHQ_SlingDrop = missionNamespace getvariable ["RydxHQ_SlingDrop",false];
publicVariable "RydxHQ_SlingDrop";
RydxHQ_RHQAutoFill = missionNamespace getvariable ["RydxHQ_RHQAutoFill",true];
publicVariable "RydxHQ_RHQAutoFill";

RydxHQ_PathFinding = missionNamespace getvariable ["RydxHQ_PathFinding",0];
publicVariable "RydxHQ_PathFinding";

RydxHQ_MagicHeal = missionNamespace getvariable ["RydxHQ_MagicHeal",false];
publicVariable "RydxHQ_MagicHeal";
RydxHQ_MagicRepair = missionNamespace getvariable ["RydxHQ_MagicRepair",false];
publicVariable "RydxHQ_MagicRepair";
RydxHQ_MagicRearm = missionNamespace getvariable ["RydxHQ_MagicRearm",false];
publicVariable "RydxHQ_MagicRearm";
RydxHQ_MagicRefuel = missionNamespace getvariable ["RydxHQ_MagicRefuel",false];
publicVariable "RydxHQ_MagicRefuel";

RydxHQ_PlayerCargoCheckLoopTime = missionNamespace getvariable ["RydxHQ_PlayerCargoCheckLoopTime",2];
publicVariable "RydxHQ_PlayerCargoCheckLoopTime";

RydxHQ_DisembarkRange = missionNamespace getvariable ["RydxHQ_DisembarkRange",200];
publicVariable "RydxHQ_DisembarkRange";

RydxHQ_CargoObjRange = missionNamespace getvariable ["RydxHQ_CargoObjRange",1500];
publicVariable "RydxHQ_CargoObjRange";

RydxHQ_ReconCargo = missionNamespace getvariable ["RydxHQ_ReconCargo",false];
publicVariable "RydxHQ_ReconCargo";

RYD_WS_ArtyMarks = missionNamespace getvariable ["RYD_WS_ArtyMarks",false];
publicVariable "RYD_WS_ArtyMarks";


call compile preprocessfile (RYD_Path + "HAL_Version.sqf");

_hi = HAL_Ver + " Initialized";

if ((random 100) < 1) then {_hi = "Good evening, Dave. Everything's running smoothly - and you? - Blame these night owls"};

_hi remoteExecCall ["systemChat"];
HQInit1 = true;
}] call CBA_fnc_directCall;
waitUntil {sleep 1; HQInit1};

call compile preprocessfile (RYD_Path + "HAC_fnc.sqf");
call compile preprocessfile (RYD_Path + "HAC_fnc2.sqf");
call compile preprocessfile (RYD_Path + "VarInit.sqf"); 
call compile preprocessfile (RYD_Path + "TaskMenu.sqf");
call compile preprocessfile (RYD_Path + "TaskInitNR6.sqf");

//Running below publicvariables in unsheduled mode.
[{
HAL_fnc_getType = compile preprocessFileLineNumbers "A3\modules_f\marta\data\scripts\fnc_getType.sqf";
HAL_fnc_getSize = compile preprocessFileLineNumbers "A3\modules_f\marta\data\scripts\fnc_getSize.sqf";

publicVariable "RYD_MP_Sidechat";
publicVariable "RYD_MP_SideRadio";
publicVariable "RYD_MP_orderGetIn";
publicVariable "RYD_MP_unassignVehicle";
publicVariable "RYD_MP_assignedVehicle";
publicVariable "RYD_MP_assignedVehicle2";

publicVariable "RYD_ReqTransport_Actions";
publicVariable "RYD_ReqLogistics_Actions";
publicVariable "RYD_ReqLogisticsDelete_Actions";

publicVariable "ActionMfnc";
publicVariable "ACEActionMfnc";
publicVariable "ActionMfncR";
publicVariable "ACEActionMfncR";

publicVariable "NR6_Player_Menu";
publicVariable "NR6_Tasking_Menu";
publicVariable "NR6_Supports_Menu";
publicVariable "NR6_Logistics_Menu";

publicVariable "Action1ct";
publicVariable "Action1fnc";
publicVariable "ACEAction1fnc";
publicVariable "Action2ct";
publicVariable "Action2fnc";
publicVariable "ACEAction2fnc";
publicVariable "Action3ct";
publicVariable "Action3fnc";
publicVariable "ACEAction3fnc";
publicVariable "Action1fncR";
publicVariable "ACEAction1fncR";
publicVariable "Action2fncR";
publicVariable "ACEAction2fncR";
publicVariable "Action3fncR";
publicVariable "ACEAction3fncR";

publicVariable "Action4ct";
publicVariable "Action4fnc";
publicVariable "ACEAction4fnc";
publicVariable "Action4fncR";
publicVariable "ACEAction4fncR";

publicVariable "Action5ct";
publicVariable "Action5fnc";
publicVariable "ACEAction5fnc";
publicVariable "Action5fncR";
publicVariable "ACEAction5fncR";

publicVariable "Action6ct";
publicVariable "Action6fnc";
publicVariable "ACEAction6fnc";
publicVariable "Action6fncR";
publicVariable "ACEAction6fncR";

publicVariable "Action7ct";
publicVariable "Action7fnc";
publicVariable "ACEAction7fnc";
publicVariable "Action7fncR";
publicVariable "ACEAction7fncR";

publicVariable "Action8ct";
publicVariable "Action8fnc";
publicVariable "ACEAction8fnc";
publicVariable "Action8fncR";
publicVariable "ACEAction8fncR";

publicVariable "Action9ct";
publicVariable "Action9fnc";
publicVariable "ACEAction9fnc";
publicVariable "Action9fncR";
publicVariable "ACEAction9fncR";

publicVariable "Action10ct";
publicVariable "Action10fnc";
publicVariable "ACEAction10fnc";
publicVariable "Action10fncR";
publicVariable "ACEAction10fncR";

publicVariable "Action11ct";
publicVariable "Action11fnc";
publicVariable "ACEAction11fnc";
publicVariable "Action11fncR";
publicVariable "ACEAction11fncR";

publicVariable "Action12ct";
publicVariable "Action12fnc";
publicVariable "ACEAction12fnc";
publicVariable "Action12fncR";
publicVariable "ACEAction12fncR";

publicVariable "Action13ct";
publicVariable "Action13fnc";
publicVariable "ACEAction13fnc";
publicVariable "Action13fncR";
publicVariable "ACEAction13fncR";

publicVariable "ActionGTct";
publicVariable "ActionArtct";
publicVariable "ActionArt2ct";
HQInit2 = true;
}] call CBA_fnc_directCall;
waitUntil {HQInit2};
if (RydHQ_RHQCheck) then {[] call RYD_RHQCheck};

RydxHQ_AllLeaders = [];
RydxHQ_AllHQ = [];

_clB = [(profilenamespace getvariable ['Map_BLUFOR_R',0]),(profilenamespace getvariable ['Map_BLUFOR_G',1]),(profilenamespace getvariable ['Map_BLUFOR_B',1]),(profilenamespace getvariable ['Map_BLUFOR_A',0.8])];
_clO = [(profilenamespace getvariable ['Map_OPFOR_R',0]),(profilenamespace getvariable ['Map_OPFOR_G',1]),(profilenamespace getvariable ['Map_OPFOR_B',1]),(profilenamespace getvariable ['Map_OPFOR_A',0.8])];
_clI = [(profilenamespace getvariable ['Map_Independent_R',0]),(profilenamespace getvariable ['Map_Independent_G',1]),(profilenamespace getvariable ['Map_Independent_B',1]),(profilenamespace getvariable ['Map_Independent_A',0.8])];
_clU = [(profilenamespace getvariable ['Map_Unknown_R',0]),(profilenamespace getvariable ['Map_Unknown_G',1]),(profilenamespace getvariable ['Map_Unknown_B',1]),(profilenamespace getvariable ['Map_Unknown_A',0.8])];
/*
RydHQ_CallSignsA = [RydHQ_CallSignsA] call RYD_RandomOrdB;

	{
	_nouns = [_x] call RYD_RandomOrdB;
	RydHQ_CallSignsN set [_foreachIndex,_nouns]
	}
foreach RydHQ_CallSignsN; 
*/
if not (isNull leaderHQ) then 
	{
	_gp = group leaderHQ;
	RydxHQ_AllLeaders set [(count RydxHQ_AllLeaders),leaderHQ];
	RydxHQ_AllHQ set [(count RydxHQ_AllHQ),_gp];
	_gp setVariable ["RydHQ_CodeSign","A"];
			
	if not (isNil ("HET_FA")) then 
		{
		_gp setVariable ["RydHQ_Front",HET_FA]
		}
	};
	
if not (isNull leaderHQB) then 
	{
	_gp = group leaderHQB;
	RydxHQ_AllLeaders set [(count RydxHQ_AllLeaders),leaderHQB];
	RydxHQ_AllHQ set [(count RydxHQ_AllHQ),_gp];
	_gp setVariable ["RydHQ_CodeSign","B"];
	
	if not (isNil ("HET_FB")) then 
		{
		_gp setVariable ["RydHQ_Front",HET_FB]
		}
	};
	
if not (isNull leaderHQC) then 
	{
	_gp = group leaderHQC;
	RydxHQ_AllLeaders set [(count RydxHQ_AllLeaders),leaderHQC];
	RydxHQ_AllHQ set [(count RydxHQ_AllHQ),_gp];
	_gp setVariable ["RydHQ_CodeSign","C"];
	
	if not (isNil ("HET_FC")) then 
		{
		_gp setVariable ["RydHQ_Front",HET_FC]
		}
	};
	
if not (isNull leaderHQD) then 
	{
	_gp = group leaderHQD;
	RydxHQ_AllLeaders set [(count RydxHQ_AllLeaders),leaderHQD];
	RydxHQ_AllHQ set [(count RydxHQ_AllHQ),_gp];
	_gp setVariable ["RydHQ_CodeSign","D"];
	
	if not (isNil ("HET_FD")) then 
		{
		_gp setVariable ["RydHQ_Front",HET_FD]
		}
	};
	
if not (isNull leaderHQE) then 
	{
	_gp = group leaderHQE;
	RydxHQ_AllLeaders set [(count RydxHQ_AllLeaders),leaderHQE];
	RydxHQ_AllHQ set [(count RydxHQ_AllHQ),_gp];
	_gp setVariable ["RydHQ_CodeSign","E"];
	
	if not (isNil ("HET_FE")) then 
		{
		_gp setVariable ["RydHQ_Front",HET_FE]
		}
	};
	
if not (isNull leaderHQF) then 
	{
	_gp = group leaderHQF;
	RydxHQ_AllLeaders set [(count RydxHQ_AllLeaders),leaderHQF];
	RydxHQ_AllHQ set [(count RydxHQ_AllHQ),_gp];
	_gp setVariable ["RydHQ_CodeSign","F"];
	
	if not (isNil ("HET_FF")) then 
		{
		_gp setVariable ["RydHQ_Front",HET_FF]
		}
	};
	
if not (isNull leaderHQG) then 
	{
	_gp = group leaderHQG;
	RydxHQ_AllLeaders set [(count RydxHQ_AllLeaders),leaderHQG];
	RydxHQ_AllHQ set [(count RydxHQ_AllHQ),_gp];
	_gp setVariable ["RydHQ_CodeSign","G"];
	
	if not (isNil ("HET_FG")) then 
		{
		_gp setVariable ["RydHQ_Front",HET_FG]
		}
	};
	
if not (isNull leaderHQH) then 
	{
	_gp = group leaderHQH;
	RydxHQ_AllLeaders set [(count RydxHQ_AllLeaders),leaderHQH];
	RydxHQ_AllHQ set [(count RydxHQ_AllHQ),_gp];
	_gp setVariable ["RydHQ_CodeSign","H"];
	
	if not (isNil ("HET_FH")) then 
		{
		_gp setVariable ["RydHQ_Front",HET_FH]
		}
	};

[] call compile preprocessfile (RYD_Path + "Front.sqf");

if (RydHQ_TimeM) then 
	{
	[([player] + (switchableUnits - [player]))] call RYD_TimeMachine
	};
	
if (RydBB_Active) then 
	{
	call compile preprocessfile (RYD_Path + "Boss_fnc.sqf");
	RydBBa_InitDone = false;
	RydBBb_InitDone = false;

		{
		if ((count (_x select 0)) > 0) then 
			{
			if ((_x select 1) == "A") then {RydBBa_Init = false};
			_BBHQs = _x select 0;
			_BBHQGrps = [];

				{
				_BBHQGrps set [(count _BBHQGrps),(group _x)]
				}
			foreach _BBHQs;

				{
				_x setVariable ["BBProgress",0]
				}
			foreach _BBHQGrps;
			[_x,_BBHQGrps] call Boss;
			};

		sleep 1;
		}
	foreach [[RydBBa_HQs,"A"],[RydBBb_HQs,"B"]];
	};

if (((RydHQ_Debug) or (RydHQB_Debug) or (RydHQC_Debug) or (RydHQD_Debug) or (RydHQE_Debug) or (RydHQF_Debug) or (RydHQG_Debug) or (RydHQH_Debug)) and (RydHQ_DbgMon)) then {[] call RYD_DbgMon};

if not (isNull leaderHQ) then {publicVariable "leaderHQ"; [(group leaderHQ)] call A_HQSitRep; [(group leaderHQ)] call HAL_FBFTLOOP; [(group leaderHQ)] call HAL_SecTasks; sleep 5};
if not (isNull leaderHQB) then {publicVariable "leaderHQB"; [(group leaderHQB)] call B_HQSitRep; [(group leaderHQB)] call HAL_FBFTLOOP; [(group leaderHQB)] call HAL_SecTasks; sleep 5};
if not (isNull leaderHQC) then {publicVariable "leaderHQC"; [(group leaderHQC)] call B_HQSitRep; [(group leaderHQC)] call HAL_FBFTLOOP; [(group leaderHQC)] call HAL_SecTasks; sleep 5};
if not (isNull leaderHQD) then {publicVariable "leaderHQD"; [(group leaderHQD)] call B_HQSitRep; [(group leaderHQD)] call HAL_FBFTLOOP; [(group leaderHQD)] call HAL_SecTasks; sleep 5};
if not (isNull leaderHQE) then {publicVariable "leaderHQE"; [(group leaderHQE)] call B_HQSitRep; [(group leaderHQE)] call HAL_FBFTLOOP; [(group leaderHQE)] call HAL_SecTasks; sleep 5};
if not (isNull leaderHQF) then {publicVariable "leaderHQF"; [(group leaderHQF)] call B_HQSitRep; [(group leaderHQF)] call HAL_FBFTLOOP; [(group leaderHQF)] call HAL_SecTasks; sleep 5};
if not (isNull leaderHQG) then {publicVariable "leaderHQG"; [(group leaderHQG)] call B_HQSitRep; [(group leaderHQG)] call HAL_FBFTLOOP; [(group leaderHQG)] call HAL_SecTasks; sleep 5};
if not (isNull leaderHQH) then {publicVariable "leaderHQH"; [(group leaderHQH)] call B_HQSitRep; [(group leaderHQH)] call HAL_FBFTLOOP; [(group leaderHQH)] call HAL_SecTasks; sleep 5};

if ((count RydHQ_GroupMarks) > 0) then
	{	
	[RydHQ_GroupMarks] call RYD_GroupMarkerLoop;
	};
{
if (RydxHQ_Actions) then {
nul = [] call compile (RYD_Path + "SquadTaskingNR6Init.sqf");
};

} call CBA_fnc_directCall;
