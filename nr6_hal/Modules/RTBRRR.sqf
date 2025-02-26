private ["_logic","_Commanders","_Leader","_prefix"];

_logic = (_this select 0);




{
	if not (_x isKindOf "Logic") then {
		(group _x) setVariable ["Ryd_RRR",true];
	} else {
		_x setVariable ["_ExtraArgs",(_logic getVariable ["_ExtraArgs",""]) + "; (group _this) setVariable [""Ryd_RRR"",true];"];
	};

} forEach (synchronizedObjects _logic);
