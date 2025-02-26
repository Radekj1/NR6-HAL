scriptName "\NR6_Alice2\data\scripts\fnc_civilianKilled.sqf";
/*
	File: fnc_civilianKilled.sqf
	Author: Karel Moricky

	Description:
	What happens after death of one innocent ALICE civilian. Executed from KILLED event handler.

	Parameter(s):
	_this select 0: Object - civilian
	_this select 1: Object - shooter
*/

private ["_unit","_shooter","_id_civ","_twn","_coef"];

_unit = _this select 0;
_shooter = _this select 1;
_id_civ = _unit getVariable "ALICE_id";

//--- Reset action variables
//--- Terminate action
_unit setVariable ["ALICE_action",""];
_unit setVariable ["ALICE_action_locked",-1];
_unit setVariable ["ALICE_action_fsm",-1];

/*
//--- Remove unit from town list
if !(isnil "_twn") then {
	if (_twn != _unit) then {
		[_twn,"ALICE_population",[_unit],true] call bis_fnc_variablespaceremove;
	};
};
*/

//debuglog format ["Log: [ALICE2] OH NO.... #%1... IS DOWN!",_id_civ];

//--- Delete body (Garbage Collector)
[_unit] call BIS_GC_trashItFunc;


true;