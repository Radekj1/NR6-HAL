private ["_logic","_Commanders"];

_logic = (_this select 0);
_Commanders = [];

{
	if ((typeOf _x) == "NR6_HAL_BBLeader_Objective_Module") then {_Commanders pushBack _x};
} forEach (synchronizedObjects _logic);

_Leader = (_logic getVariable "Owned");

if (_Leader == "A") then {_logic setVariable ["AreaTakenA",true]};
if (_Leader == "B") then {_logic setVariable ["AreaTakenB",true]};