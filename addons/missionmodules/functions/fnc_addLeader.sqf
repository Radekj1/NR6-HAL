#include "..\script_component.hpp"

params ["_logic", "_units", "_activated"];

private _groupID = (_logic getVariable ["HQname", objNull]);
private _leaderType = (_logic getVariable ["LeaderType", "LeaderHQ"]);

private _leader = objNull;
private _group = grpNull;

{
    if (_x isKindOf "CAManBase") then {
        _leader = _x;
        _group = (group _leader);
    };
} forEach _units;

if (isNull _leader) then {

    private _side = call compile (_logic getVariable ["LeaderSide", "west"]);
    _group = createGroup _side;

    switch (_side) do {
        case west: {_leader = _group createUnit ["B_officer_F", position _logic, [], 0, "FORM"]};
        case east: {_leader = _group createUnit ["O_officer_F", position _logic, [], 0, "FORM"]};
        case independent: {_leader = _group createUnit ["I_officer_F", position _logic, [], 0, "FORM"]};
        case civilian: {_leader = _group createUnit ["C_man_1", position _logic, [], 0, "FORM"]};
    };

    _group setVariable ["zbe_cacheDisabled", true];

    _leader hideObjectGlobal true;
    _leader enableSimulationGlobal false;
    _leader allowDamage false;

};

if !(isNil "_groupID") then {_group setGroupIdGlobal [_groupID]};

_leader call compile (_leaderType + " = _this");
