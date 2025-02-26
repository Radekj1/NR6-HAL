_logic = _this select 0;
 
_cost = _logic getVariable "NR6UnitClassCost";
_unit = objNull;

{
	missionNamespace setVariable ["NR6ClassCost_" + (typeOf _x),_cost,true];
	_unit = _x;
} forEach (synchronizedObjects _logic);
