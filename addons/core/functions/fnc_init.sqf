#include "..\script_component.hpp"
// Originally from RydHQInit.sqf

params ["_logic", "_units", "_activated"];

if !(isServer) exitWith {};

RydHQ_Wait = _logic getVariable ["RydHQ_Wait", 15];


RydxHQ_ReconCargo = missionNamespace getVariable ["RydxHQ_ReconCargo",true];
publicVariable "RydxHQ_ReconCargo";
RydxHQ_SynchroAttack = missionNamespace getVariable ["RydxHQ_SynchroAttack",false];
publicVariable "RydxHQ_SynchroAttack";
RydxHQ_InfoMarkersID = missionNamespace getVariable ["RydxHQ_InfoMarkersID",true];
publicVariable "RydxHQ_InfoMarkersID";

RydxHQ_Actions = missionNamespace getVariable ["RydxHQ_Actions",true];
publicVariable "RydxHQ_Actions";
RydxHQ_ActionsMenu = missionNamespace getVariable ["RydxHQ_ActionsMenu",true];
publicVariable "RydxHQ_ActionsMenu";

RydxHQ_TaskActions = missionNamespace getVariable ["RydxHQ_TaskActions",false];
publicVariable "RydxHQ_TaskActions";
RydxHQ_SupportActions = missionNamespace getVariable ["RydxHQ_SupportActions",false];
publicVariable "RydxHQ_SupportActions";
RydxHQ_ActionsAceOnly = missionNamespace getVariable ["RydxHQ_ActionsAceOnly",false];
publicVariable "RydxHQ_ActionsAceOnly";

RydxHQ_NoRestPlayers = missionNamespace getVariable ["RydxHQ_NoRestPlayers",true];
publicVariable "RydxHQ_NoRestPlayers";
RydxHQ_NoCargoPlayers = missionNamespace getVariable ["RydxHQ_NoCargoPlayers",true];
publicVariable "RydxHQ_NoCargoPlayers";

RydxHQ_LZ = missionNamespace getVariable ["RydxHQ_LZ",true];
publicVariable "RydxHQ_LZ";

RydART_Safe = missionNamespace getVariable ["RydART_Safe",250];
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

RydxHQ_HQChat = missionNamespace getVariable ["RydxHQ_HQChat",true];
publicVariable "RydxHQ_HQChat";
RydxHQ_AIChatDensity = missionNamespace getVariable ["RydxHQ_AIChatDensity",100];
publicVariable "RydxHQ_AIChatDensity";
RydxHQ_AIChat_Type = missionNamespace getVariable ["RydxHQ_AIChat_Type",100];
publicVariable "RydxHQ_AIChat_Type";
RydxHQ_GarrisonV2 = missionNamespace getVariable ["RydxHQ_GarrisonV2",true];
publicVariable "RydxHQ_GarrisonV2";
RydxHQ_NEAware = missionNamespace getVariable ["RydxHQ_NEAware",500];
publicVariable "RydxHQ_NEAware";
RydxHQ_SlingDrop = missionNamespace getVariable ["RydxHQ_SlingDrop",false];
publicVariable "RydxHQ_SlingDrop";
RydxHQ_RHQAutoFill = missionNamespace getVariable ["RydxHQ_RHQAutoFill",true];
publicVariable "RydxHQ_RHQAutoFill";

RydxHQ_PathFinding = missionNamespace getVariable ["RydxHQ_PathFinding",0];
publicVariable "RydxHQ_PathFinding";

RydxHQ_MagicHeal = missionNamespace getVariable ["RydxHQ_MagicHeal",false];
publicVariable "RydxHQ_MagicHeal";
RydxHQ_MagicRepair = missionNamespace getVariable ["RydxHQ_MagicRepair",false];
publicVariable "RydxHQ_MagicRepair";
RydxHQ_MagicRearm = missionNamespace getVariable ["RydxHQ_MagicRearm",false];
publicVariable "RydxHQ_MagicRearm";
RydxHQ_MagicRefuel = missionNamespace getVariable ["RydxHQ_MagicRefuel",false];
publicVariable "RydxHQ_MagicRefuel";

RydxHQ_PlayerCargoCheckLoopTime = missionNamespace getVariable ["RydxHQ_PlayerCargoCheckLoopTime",2];
publicVariable "RydxHQ_PlayerCargoCheckLoopTime";

RydxHQ_DisembarkRange = missionNamespace getVariable ["RydxHQ_DisembarkRange",200];
publicVariable "RydxHQ_DisembarkRange";

RydxHQ_CargoObjRange = missionNamespace getVariable ["RydxHQ_CargoObjRange",1500];
publicVariable "RydxHQ_CargoObjRange";

RydxHQ_ReconCargo = missionNamespace getVariable ["RydxHQ_ReconCargo",false];
publicVariable "RydxHQ_ReconCargo";

RYD_WS_ArtyMarks = missionNamespace getVariable ["RYD_WS_ArtyMarks",false];
publicVariable "RYD_WS_ArtyMarks";

RYD_Path = "\NR6_HAL\";

//move this to functions folder

// call compile preprocessFile (RYD_Path + "HAC_fnc.sqf");
// call compile preprocessFile (RYD_Path + "HAC_fnc2.sqf");
// call compile preprocessFile (RYD_Path + "VarInit.sqf");
// call compile preprocessFile (RYD_Path + "TaskMenu.sqf");
// call compile preprocessFile (RYD_Path + "TaskInitNR6.sqf");

//can be replaced with getMarkerType and getMarkerSize
HAL_fnc_getType = compile preprocessFileLineNumbers "A3\modules_f\marta\data\scripts\fnc_getType.sqf";
HAL_fnc_getSize = compile preprocessFileLineNumbers "A3\modules_f\marta\data\scripts\fnc_getSize.sqf";

//used to "compile" list of units types usable by AI
if (RydHQ_RHQCheck) then {[] call RYD_RHQCheck};

RydxHQ_AllLeaders = [];
RydxHQ_AllHQ = [];

private _clB = [Map_BLUFOR_R,Map_BLUFOR_G,Map_BLUFOR_B,Map_BLUFOR_A];
private _clO = [Map_OPFOR_R,Map_OPFOR_G,Map_OPFOR_B,Map_OPFOR_A];
private _clI = [Map_Independent_R,Map_Independent_G,Map_Independent_B,Map_Independent_A];
private _clU = [Map_Unknown_R,Map_Unknown_G,Map_Unknown_B,Map_Unknown_A];


if !(isNull leaderHQ) then {
	_gp = group leaderHQ;
	RydxHQ_AllLeaders set [(count RydxHQ_AllLeaders),leaderHQ];
	RydxHQ_AllHQ set [(count RydxHQ_AllHQ),_gp];
	_gp setVariable ["RydHQ_CodeSign","A"];

	if !(isNil ("HET_FA")) then {
		_gp setVariable ["RydHQ_Front", HET_FA]
	};
};

if !(isNull leaderHQB) then
	{
	_gp = group leaderHQB;
	RydxHQ_AllLeaders set [(count RydxHQ_AllLeaders),leaderHQB];
	RydxHQ_AllHQ set [(count RydxHQ_AllHQ),_gp];
	_gp setVariable ["RydHQ_CodeSign","B"];

	if !(isNil ("HET_FB")) then
		{
		_gp setVariable ["RydHQ_Front",HET_FB]
		}
	};

if !(isNull leaderHQC) then
	{
	_gp = group leaderHQC;
	RydxHQ_AllLeaders set [(count RydxHQ_AllLeaders),leaderHQC];
	RydxHQ_AllHQ set [(count RydxHQ_AllHQ),_gp];
	_gp setVariable ["RydHQ_CodeSign","C"];

	if !(isNil ("HET_FC")) then
		{
		_gp setVariable ["RydHQ_Front",HET_FC]
		}
	};

if !(isNull leaderHQD) then
	{
	_gp = group leaderHQD;
	RydxHQ_AllLeaders set [(count RydxHQ_AllLeaders),leaderHQD];
	RydxHQ_AllHQ set [(count RydxHQ_AllHQ),_gp];
	_gp setVariable ["RydHQ_CodeSign","D"];

	if !(isNil ("HET_FD")) then
		{
		_gp setVariable ["RydHQ_Front",HET_FD]
		}
	};

if !(isNull leaderHQE) then
	{
	_gp = group leaderHQE;
	RydxHQ_AllLeaders set [(count RydxHQ_AllLeaders),leaderHQE];
	RydxHQ_AllHQ set [(count RydxHQ_AllHQ),_gp];
	_gp setVariable ["RydHQ_CodeSign","E"];

	if !(isNil ("HET_FE")) then
		{
		_gp setVariable ["RydHQ_Front",HET_FE]
		}
	};

if !(isNull leaderHQF) then
	{
	_gp = group leaderHQF;
	RydxHQ_AllLeaders set [(count RydxHQ_AllLeaders),leaderHQF];
	RydxHQ_AllHQ set [(count RydxHQ_AllHQ),_gp];
	_gp setVariable ["RydHQ_CodeSign","F"];

	if !(isNil ("HET_FF")) then
		{
		_gp setVariable ["RydHQ_Front",HET_FF]
		}
	};

if !(isNull leaderHQG) then
	{
	_gp = group leaderHQG;
	RydxHQ_AllLeaders set [(count RydxHQ_AllLeaders),leaderHQG];
	RydxHQ_AllHQ set [(count RydxHQ_AllHQ),_gp];
	_gp setVariable ["RydHQ_CodeSign","G"];

	if !(isNil ("HET_FG")) then
		{
		_gp setVariable ["RydHQ_Front",HET_FG]
		}
	};

if !(isNull leaderHQH) then
	{
	_gp = group leaderHQH;
	RydxHQ_AllLeaders set [(count RydxHQ_AllLeaders),leaderHQH];
	RydxHQ_AllHQ set [(count RydxHQ_AllHQ),_gp];
	_gp setVariable ["RydHQ_CodeSign","H"];

	if !(isNil ("HET_FH")) then
		{
		_gp setVariable ["RydHQ_Front",HET_FH]
		}
	};

[] call compile preprocessFile (RYD_Path + "Front.sqf");

if (RydHQ_TimeM) then
	{
	[([player] + (switchableUnits - [player]))] call RYD_TimeMachine
	};

if (RydBB_Active) then
	{
	call compile preprocessFile (RYD_Path + "Boss_fnc.sqf");
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
			forEach _BBHQs;

				{
				_x setVariable ["BBProgress",0]
				}
			forEach _BBHQGrps;
			[[_x,_BBHQGrps],Boss] call RYD_Spawn
			};

		sleep 1;
		}
	forEach [[RydBBa_HQs,"A"],[RydBBb_HQs,"B"]];
	};

if (((RydHQ_Debug) or (RydHQB_Debug) or (RydHQC_Debug) or (RydHQD_Debug) or (RydHQE_Debug) or (RydHQF_Debug) or (RydHQG_Debug) or (RydHQH_Debug)) and (RydHQ_DbgMon)) then {[[],RYD_DbgMon] call RYD_Spawn};

if !(isNull leaderHQ) then {publicVariable "leaderHQ"; [[(group leaderHQ)],A_HQSitRep] call RYD_Spawn; [[(group leaderHQ)],HAL_FBFTLOOP] call RYD_Spawn; [[(group leaderHQ)],HAL_SecTasks] call RYD_Spawn; sleep 5};
if !(isNull leaderHQB) then {publicVariable "leaderHQB"; [[(group leaderHQB)],B_HQSitRep] call RYD_Spawn; [[(group leaderHQB)],HAL_FBFTLOOP] call RYD_Spawn; [[(group leaderHQB)],HAL_SecTasks] call RYD_Spawn; sleep 5};
if !(isNull leaderHQC) then {publicVariable "leaderHQC"; [[(group leaderHQC)],C_HQSitRep] call RYD_Spawn; [[(group leaderHQC)],HAL_FBFTLOOP] call RYD_Spawn; [[(group leaderHQC)],HAL_SecTasks] call RYD_Spawn; sleep 5};
if !(isNull leaderHQD) then {publicVariable "leaderHQD"; [[(group leaderHQD)],D_HQSitRep] call RYD_Spawn; [[(group leaderHQD)],HAL_FBFTLOOP] call RYD_Spawn; [[(group leaderHQD)],HAL_SecTasks] call RYD_Spawn; sleep 5};
if !(isNull leaderHQE) then {publicVariable "leaderHQE"; [[(group leaderHQE)],E_HQSitRep] call RYD_Spawn; [[(group leaderHQE)],HAL_FBFTLOOP] call RYD_Spawn; [[(group leaderHQE)],HAL_SecTasks] call RYD_Spawn; sleep 5};
if !(isNull leaderHQF) then {publicVariable "leaderHQF"; [[(group leaderHQF)],F_HQSitRep] call RYD_Spawn; [[(group leaderHQF)],HAL_FBFTLOOP] call RYD_Spawn; [[(group leaderHQF)],HAL_SecTasks] call RYD_Spawn; sleep 5};
if !(isNull leaderHQG) then {publicVariable "leaderHQG"; [[(group leaderHQG)],G_HQSitRep] call RYD_Spawn; [[(group leaderHQG)],HAL_FBFTLOOP] call RYD_Spawn; [[(group leaderHQG)],HAL_SecTasks] call RYD_Spawn; sleep 5};
if !(isNull leaderHQH) then {publicVariable "leaderHQH"; [[(group leaderHQH)],H_HQSitRep] call RYD_Spawn; [[(group leaderHQH)],HAL_FBFTLOOP] call RYD_Spawn; [[(group leaderHQH)],HAL_SecTasks] call RYD_Spawn; sleep 5};

if ((count RydHQ_GroupMarks) > 0) then
	{
	[RydHQ_GroupMarks,RYD_GroupMarkerLoop] call RYD_Spawn
	};

if (RydxHQ_Actions) then {
nul = [] execVM  (RYD_Path + "SquadTaskingNR6.sqf");
};
