#include "..\script_component.hpp"
// Originally from HAC_fnc.sqf (RYD_GarrP)

params ["_group", "_points", "_HQ"];

{
    private _nHouse = _x nearestObject "House";
    private _posAll = [];
    private _i = 0;
    private _posAct = _nHouse buildingPos _i;
    
    while {((_posAct distance [0,0,0]) > 0)} do {
        _posAll pushBack _posAct;
            
        _i = _i + 1;
        _posAct = _nHouse buildingPos _i;
    };

    private _formation = "DIAMOND";
    if (isPlayer (leader _group)) then {_formation = formation _group;} else {_formation = "DIAMOND";};

    _wp = [[_group],_x,"MOVE","AWARE","YELLOW","LIMITED",["true",""],false,0.01,[10,15,20],_formation] call RYD_WPadd;

    if ((count _posAll) > 0) then {
        _wp waypointAttachVehicle _nHouse;
        sleep 0.05;
        _wp setWaypointHousePosition (floor (random (count _posAll)))
    };
} forEach _points;

_wp = [[_group], _points select 0, "CYCLE", "AWARE", "YELLOW", "LIMITED", ["true",""], false, 0.01, [10,15,20], _formation] call RYD_WPadd;

private _fnc_code = {
    params ["_group", "_HQ"];

    private _leader = leader _group;
    private _neareastEnemy = "";
    private _distance = 0;

    _alive = true;

    waitUntil {
        sleep 20;
        _distance = 10000;
        
        _alive = true;
        switch (true) do {
            case (isNull _group) : {_alive = false};
            case (({alive _x} count (units _group)) < 1) : {_alive = false};
            case (_HQ getVariable ["RydHQ_KIA", false]) : {_alive = false};
            case (_group getVariable ["RydHQ_MIA", false]) : {_alive = false; _group setVariable ["RydHQ_MIA", nil]}
        };

        if (_alive) then {
            _leader = leader _group;
            if not (alive _leader) then {_alive = false};

            if (_alive) then {
                _neareastEnemy = _leader findNearestEnemy (vehicle _leader);
                if  !(isNull _neareastEnemy) then {_distance = _neareastEnemy distance (vehicle _leader)}
            };
        };
        
        (_distance < 500)
    };

    _group setVariable ["Garrisoned" + (str _group), false]
};
    
[[_group, _HQ], _fnc_code] call RYD_Spawn