private ["_logic","_Commanders","_Leader","_prefix"];

_logic = (_this select 0);


{
	if not ((typeOf _x) == "NR6_HAL_Leader_Module") then {
		(group _x) setVariable ["Unable",true];
	};
} forEach (synchronizedObjects _logic);
