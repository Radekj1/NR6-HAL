private ["_Leader","_logic","_grp","_LeaderType","_grpID"];

_logic = (_this select 0);
_grpID = (_logic getVariable "HQname");
_LeaderType = (_logic getVariable "LeaderType");

_Leader = objNull;

{
	if (_x isKindOf "Man") then {_Leader = _x; _grp = (group _Leader);};
} forEach (synchronizedObjects _logic);

if (isNull _Leader) then {

	_grp = createGroup (call compile (_logic getVariable ["LeaderSide","civilian"]));

	if ((call compile (_logic getVariable ["LeaderSide","civilian"])) isEqualTo west) then {_Leader = _grp createUnit ["B_officer_F", position _logic, [], 0, "FORM"]};
	if ((call compile (_logic getVariable ["LeaderSide","civilian"])) isEqualTo east) then {_Leader = _grp createUnit ["O_officer_F", position _logic, [], 0, "FORM"]};
	if ((call compile (_logic getVariable ["LeaderSide","civilian"])) isEqualTo independent) then {_Leader = _grp createUnit ["I_officer_F", position _logic, [], 0, "FORM"]};
	if ((call compile (_logic getVariable ["LeaderSide","civilian"])) isEqualTo civilian) then {_Leader = _grp createUnit ["C_man_1", position _logic, [], 0, "FORM"]};

	_grp setVariable ["zbe_cacheDisabled",true];

	_Leader hideObjectGlobal true;
	_Leader enableSimulationGlobal false;
	_Leader allowDamage false;

};

if not (isNil "_grpID") then {_grp setGroupIdGlobal [_grpID]};

_Leader call compile (_LeaderType + " = _this");