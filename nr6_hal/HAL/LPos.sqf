_SCRname = "LPos";

private ["_veh","_pos","_start","_ammo","_rest","_wp","_exh","_dst","_newPos","_lz","_heli","_gp","_cause","_timer","_alive","_ct"];
params ["_HQ"];

	{
		if not (isNull _x) then {
		_veh = vehicle (leader _x);
		_pos = getPosATL _veh;
		_start = _x getvariable ("START" + str (_x));
		if (isNil ("_start")) then {_x setVariable [("START" + str (_x)),_pos];_start = _pos};
		_dst = _pos distance2D _start;
		if (not (isPlayer (leader _x)) and (_dst > (_HQ getVariable ["RydHQ_AirDist",4000]))) then 
			{
			if (not (_x getVariable [("Resting" + (str _x)),false]) and not (_x getVariable ["Defending",false]) and not (_x getVariable ["Break",false]) and not (_x getVariable [("Busy" + (str _x)),false]) and (((getpos _veh) select 2) > 5)) then
				{

				if ((count (waypoints _x)) < 1) then {_wp = [_x,_start,"MOVE","CARELESS","GREEN","NORMAL",["true", "deletewaypoint [(group this), 0]"]] call RYD_WPadd};

				}
			}
		}
	}
foreach (_HQ getVariable ["RydHQ_AirG",[]]);
