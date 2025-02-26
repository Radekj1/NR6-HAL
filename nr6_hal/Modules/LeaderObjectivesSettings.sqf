private ["_logic","_Commanders","_Leader","_prefix"];

_logic = (_this select 0);
_Commanders = [];

{
	if ((typeOf _x) == "NR6_HAL_Leader_Module") then {_Commanders pushBack _x};
} forEach (synchronizedObjects _logic);

{
	_Leader = (_x getVariable "LeaderType");

	if (_Leader == "LeaderHQ") then {_prefix = "RydHQ_"};
	if (_Leader == "LeaderHQB") then {_prefix = "RydHQB_"};
	if (_Leader == "LeaderHQC") then {_prefix = "RydHQC_"};
	if (_Leader == "LeaderHQD") then {_prefix = "RydHQD_"};
	if (_Leader == "LeaderHQE") then {_prefix = "RydHQE_"};
	if (_Leader == "LeaderHQF") then {_prefix = "RydHQF_"};
	if (_Leader == "LeaderHQG") then {_prefix = "RydHQG_"};
	if (_Leader == "LeaderHQH") then {_prefix = "RydHQH_"};


	if (_logic getVariable "RydHQ_Order") then {_logic call compile (_prefix + "Order" + " = " + str "DEFEND")};
	
	_logic call compile (_prefix + "Berserk" + " = " + str (_logic getVariable "RydHQ_Berserk"));
	_logic call compile (_prefix + "SimpleMode" + " = " + str (_logic getVariable "RydHQ_SimpleMode"));
	_logic call compile (_prefix + "UnlimitedCapt" + " = " + str (_logic getVariable "RydHQ_UnlimitedCapt"));
	_logic call compile (_prefix + "CaptLimit" + " = " + str (_logic getVariable "RydHQ_CaptLimit"));
	_logic call compile (_prefix + "GarrR" + " = " + str (_logic getVariable "RydHQ_GarrR"));
	_logic call compile (_prefix + "ObjHoldTime" + " = " + str (_logic getVariable "RydHQ_ObjHoldTime"));
	_logic call compile (_prefix + "ObjRadius2" + " = " + str (_logic getVariable "RydHQ_ObjRadius1"));
	_logic call compile (_prefix + "ObjRadius1" + " = " + str (_logic getVariable "RydHQ_ObjRadius2"));
	_logic call compile (_prefix + "LRelocating" + " = " + str (_logic getVariable "RydHQ_LRelocating"));
	_logic call compile (_prefix + "NoRec" + " = " + str (_logic getVariable "RydHQ_NoRec"));
	_logic call compile (_prefix + "RapidCapt" + " = " + str (_logic getVariable "RydHQ_RapidCapt"));
	_logic call compile (_prefix + "DefendObjectives" + " = " + str(_logic getVariable "RydHQ_DefendObjectives"));
	_logic call compile (_prefix + "ReconReserve" + " = " + str (_logic getVariable "RydHQ_ReconReserve"));
	_logic call compile (_prefix + "AttackReserve" + " = " + str (_logic getVariable "RydHQ_AttackReserve"));
	_logic call compile (_prefix + "AAO" + " = " + str (_logic getVariable "RydHQ_AAO"));
	_logic call compile (_prefix + "ForceAAO" + " = " + str (_logic getVariable "RydHQ_ForceAAO"));
	_logic call compile (_prefix + "BBAOObj" + " = " + str (_logic getVariable "RydHQ_BBAOObj"));
	_logic call compile (_prefix + "MaxSimpleObjs" + " = " + str (_logic getVariable "RydHQ_MaxSimpleObjs"));
	_logic call compile (_prefix + "CRDefRes" + " = " + str (_logic getVariable "RydHQ_CRDefRes"));

	waitUntil {sleep 0.5; (not (isNil _Leader))};

	_Leader = call compile _Leader;

//New Variables

	(group _Leader) setVariable ["RydHQ_ObjectiveRespawn",(_logic getVariable ["RydHQ_ObjectiveRespawn",true])];

} forEach _Commanders;