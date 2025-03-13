scriptName "\NR6_Alice2\data\scripts\fnc_civilianHit.sqf";
/*
	File: fnc_civilianHit.sqf
	Author: Karel Moricky

	Description:
	What happens after hit of one innocent ALICE civilian. Executed from HIT event handler.
2
	Parameter(s):
	_this select 0: Object - civilian
	_this select 1: Object - shooter
*/

private ["_unit","_shooter","_hit","_id_civ","_twn","_coef"];

_unit = _this select 0;
_shooter = _this select 1;
_hit = _this select 2;
_id_civ = _unit getVariable "ALICE_id";
_twn = _unit getVariable "ALICE_twn";
_coef = bis_alice_mainscope getVariable "respectModifyCoef";
_coef = _coef * _hit;

//--- Modify town respect (against shooter and his allies)
if (!isNull _shooter && !isNull leader _shooter && _unit != _shooter && _twn != _unit) then {
	["KILLED",_shooter,_twn,true,_coef] call BIS_fnc_respect;
};

true;