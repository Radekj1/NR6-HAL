#include "..\script_component.hpp"
// Originally from HAC_fnc2.sqf (RYD_LF)


private ["_src","_dc","_leader","_posS"];

_src = _this select 0;
_leader = _this select 1;

if  !(RydHQ_LF) then
    {
    _dc = "EmptyDetector" createVehicle (getPosATL _src);

    RydHQ_LF = true;
    [_src, _src, _leader, 0] call BIS_fnc_liveFeed;

    waitUntil { !(isNil "BIS_liveFeed")};
    waitUntil {camCommitted BIS_liveFeed};

    if ([] call FUNC(isNight)) then {
        [1] call FUNC(LF_EFF);
    };

    _vh = vehicle _src;
    _tp = toLower (typeOf _vh);

    (group _leader) setVariable ["RydHQ_LFSourceFin", _vh];

    _vPos = [0,50,2];

    if (_src != _vh) then {
        _vPos = [0,30,0];

        _pX = 0;
        _pY = (sizeOf (typeOf _vh))/15;
        _pZ = -_pY;

        _sign = 1;

        if (_tp in ["b_truck_01_ammo_f"]) then { _pZ = 0 };

        if (_vh isKindOf "Air") then {
            _pY = (sizeOf (typeOf _vh))/4;
            _pZ = 0;
            _sign = 2
        };

        _inside = true;

        while {_inside} do {
            _inside = [_vh,[_pX,_pY,_pZ],6,[[1],[1]]] call RYD_isInside;
            _pZ = _pZ + (0.01 * _sign);
        };

        if (_tp in ["b_mbt_01_cannon_f","i_mbt_03_cannon_f"]) then { _pZ = _pZ + 0.1; } else { _pZ = _pZ + 0.2; };

        //_dc setPos (_vh modelToWorld [_pX,_pY,0]);
        _dc attachTo [_vh,[_pX,_pY,_pZ]];
    } else {
        //_dc setPos (_vh modelToWorld [0.22,0.05,0]);
        _dc attachTo [_vh,[0.22,0.05,0.1],"head"];
    };

    [[_dc, [0, 0, 0]]] call BIS_fnc_liveFeedSetSource;

    private _fnc_code = {
        _tgt = _this select 0;
        _vPos = _this select 1;
        _isFoot = (!isNull objectParent _tgt);

        while { !(isNil "BIS_liveFeed")} do {
            if ((_isFoot) && (!isNull objectParent _tgt)) exitWith {
                if (isNil "RydxHQ_LFTerminating") then {
                    RydxHQ_LFTerminating = true;
                    [] call BIS_fnc_liveFeedTerminate;
                    waitUntil {isNil "BIS_liveFeed"};
                    RydxHQ_LFTerminating = nil;
                    _dc = _tgt getVariable ["RydHQ_CamPoint",objNull];

                    deleteVehicle _dc;

                    _tgt setVariable ["RydHQ_CamPoint",nil];

                    RydHQ_LF = false;
                };
            };

            _tgtF = _tgt modelToWorld _vPos;
            [{if !(_isFoot) then {BIS_liveFeed setDir (getDir _tgt)};
            [_tgtF] call BIS_fnc_liveFeedSetTarget;}, 0.02] call CBA_fnc_waitAndExecute;
        };
    };

    [[_src,_vPos], _fnc_code] call RYD_Spawn
} else {
    if (isNil "RydxHQ_LFTerminating") then {
        RydxHQ_LFTerminating = true;
        [] call BIS_fnc_liveFeedTerminate;
        waitUntil {isNil "BIS_liveFeed"};
        RydxHQ_LFTerminating = nil;
        _dc = _src getVariable ["RydHQ_CamPoint",objNull];

        deleteVehicle _dc;

        _src setVariable ["RydHQ_CamPoint",nil];

        RydHQ_LF = false;
    };
};