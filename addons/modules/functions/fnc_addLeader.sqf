params ["_logic"];

private _grpID = (_logic getVariable "HQname");
private _leaderType = (_logic getVariable "LeaderType");

private _leader = objNull;
private _grp = grpNull;

{
    if (_x isKindOf "CAManBase") then {
        _leader = _x;
        _grp = (group _leader);
    };
} forEach (synchronizedObjects _logic);

if (isNull _leader) then {

    private _side = (call compile (_logic getVariable ["LeaderSide", "civilian"]));
    _grp = createGroup _side;

    switch case (_side) do {
        case west: {_leader = _grp createUnit ["B_officer_F", position _logic, [], 0, "FORM"]};
        case east: {_leader = _grp createUnit ["O_officer_F", position _logic, [], 0, "FORM"]};
        case independent: {_leader = _grp createUnit ["I_officer_F", position _logic, [], 0, "FORM"]};
        case civilian: {_leader = _grp createUnit ["C_man_1", position _logic, [], 0, "FORM"]};
    };

    _grp setVariable ["zbe_cacheDisabled", true];

    _leader hideObjectGlobal true;
    _leader enableSimulationGlobal false;
    _leader allowDamage false;

};

if !(isNil "_grpID") then {_grp setGroupIdGlobal [_grpID]};

_leader call compile (_leaderType + " = _this");
