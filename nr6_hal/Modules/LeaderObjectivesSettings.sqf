private ["_logic","_Commanders","_Leader","_prefix"];

_logic = (_this select 0);
_Commanders = [];

{
	if ((typeOf _x) == "NR6_HAL_Leader_Module") then {_Commanders pushback _x};
} foreach (synchronizedObjects _logic);

{
	_Leader = (_x getvariable "LeaderType");

	if (_Leader == "LeaderHQ") then {_prefix = "RydHQ_"};
	if (_Leader == "LeaderHQB") then {_prefix = "RydHQB_"};
	if (_Leader == "LeaderHQC") then {_prefix = "RydHQC_"};
	if (_Leader == "LeaderHQD") then {_prefix = "RydHQD_"};
	if (_Leader == "LeaderHQE") then {_prefix = "RydHQE_"};
	if (_Leader == "LeaderHQF") then {_prefix = "RydHQF_"};
	if (_Leader == "LeaderHQG") then {_prefix = "RydHQG_"};
	if (_Leader == "LeaderHQH") then {_prefix = "RydHQH_"};


	if (_logic getvariable "RydHQ_Order") then {_logic call compile (_prefix + "Order" + " = " + str "DEFEND")};
	
	_logic call compile (_prefix + "Berserk" + " = " + str (_logic getvariable "RydHQ_Berserk"));
	_logic call compile (_prefix + "SimpleMode" + " = " + str (_logic getvariable "RydHQ_SimpleMode"));
	_logic call compile (_prefix + "UnlimitedCapt" + " = " + str (_logic getvariable "RydHQ_UnlimitedCapt"));
	_logic call compile (_prefix + "CaptLimit" + " = " + str (_logic getvariable "RydHQ_CaptLimit"));
	_logic call compile (_prefix + "GarrR" + " = " + str (_logic getvariable "RydHQ_GarrR"));
	_logic call compile (_prefix + "ObjHoldTime" + " = " + str (_logic getvariable "RydHQ_ObjHoldTime"));
	_logic call compile (_prefix + "ObjRadius2" + " = " + str (_logic getvariable "RydHQ_ObjRadius1"));
	_logic call compile (_prefix + "ObjRadius1" + " = " + str (_logic getvariable "RydHQ_ObjRadius2"));
	_logic call compile (_prefix + "LRelocating" + " = " + str (_logic getvariable "RydHQ_LRelocating"));
	_logic call compile (_prefix + "NoRec" + " = " + str (_logic getvariable "RydHQ_NoRec"));
	_logic call compile (_prefix + "RapidCapt" + " = " + str (_logic getvariable "RydHQ_RapidCapt"));
	_logic call compile (_prefix + "DefendObjectives" + " = " + str(_logic getvariable "RydHQ_DefendObjectives"));
	_logic call compile (_prefix + "ReconReserve" + " = " + str (_logic getvariable "RydHQ_ReconReserve"));
	_logic call compile (_prefix + "AttackReserve" + " = " + str (_logic getvariable "RydHQ_AttackReserve"));
	_logic call compile (_prefix + "AAO" + " = " + str (_logic getvariable "RydHQ_AAO"));
	_logic call compile (_prefix + "ForceAAO" + " = " + str (_logic getvariable "RydHQ_ForceAAO"));
	_logic call compile (_prefix + "BBAOObj" + " = " + str (_logic getvariable "RydHQ_BBAOObj"));
	_logic call compile (_prefix + "MaxSimpleObjs" + " = " + str (_logic getvariable "RydHQ_MaxSimpleObjs"));
	_logic call compile (_prefix + "CRDefRes" + " = " + str (_logic getvariable "RydHQ_CRDefRes"));

	waitUntil {sleep 0.5; (not (isNil _Leader))};

	_Leader = call compile _Leader;

//New Variables

	(group _Leader) setVariable ["RydHQ_ObjectiveRespawn",(_logic getvariable ["RydHQ_ObjectiveRespawn",true])];

} foreach _Commanders;