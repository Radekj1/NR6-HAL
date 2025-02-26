private ["_logic","_Commanders","_Leader","_prefix","_objName","_prefixT"];

_logic = (_this select 0);
_Commanders = [];

_objName = _logic getVariable "_ObjName";
if not (_objName isEqualTo "") then {_logic setVariable ["ObjName",_objName]};

{
	if ((typeOf _x) == "NR6_HAL_Leader_Module") then {_Commanders pushBack _x};
} forEach (synchronizedObjects _logic);

{
	_Leader = (_x getVariable "LeaderType");

	if (_Leader == "LeaderHQ") then {_prefix = "RydHQ_"; _prefixT = "SetTakenA"};
	if (_Leader == "LeaderHQB") then {_prefix = "RydHQB_"; _prefixT = "SetTakenB"};
	if (_Leader == "LeaderHQC") then {_prefix = "RydHQC_"; _prefixT = "SetTakenC"};
	if (_Leader == "LeaderHQD") then {_prefix = "RydHQD_"; _prefixT = "SetTakenD"};
	if (_Leader == "LeaderHQE") then {_prefix = "RydHQE_"; _prefixT = "SetTakenE"};
	if (_Leader == "LeaderHQF") then {_prefix = "RydHQF_"; _prefixT = "SetTakenF"};
	if (_Leader == "LeaderHQG") then {_prefix = "RydHQG_"; _prefixT = "SetTakenG"};
	if (_Leader == "LeaderHQH") then {_prefix = "RydHQH_"; _prefixT = "SetTakenH"};

	waitUntil {sleep 0.5; (not (isNil _Leader))};
	
	_Leader = call compile _Leader;

	if (call compile ("isNil " + "'" + _prefix + "NavalObjs" + "'")) then {
	
		call compile (_prefix + "NavalObjs" + " = " + "[]");
		
	};

	_logic call compile (_prefix + "NavalObjs" + " pushback " + "_this");
	
	if ((_logic getVariable "RydHQ_TakenLeader") isEqualTo (_x getVariable "LeaderType")) then  {
		(group _Leader) setVariable ["RydHQ_TakenNaval",((group _Leader) getVariable ["RydHQ_TakenNaval",[]]) + [_logic]];
		_logic setVariable [_prefixT,true];
	};

} forEach _Commanders;
