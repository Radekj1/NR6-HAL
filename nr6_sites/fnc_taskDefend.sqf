/* ----------------------------------------------------------------------------
Function: CBA_fnc_taskDefend

Description:
    A function for a group to defend a parsed location. Should be ran locally.

    Units will mount nearby static machine guns and garrison in nearby buildings.
    10% chance to patrol the radius unless specified differently (100% when no available building positions).
    0% chance to hold defensive positions in combat unless specified differently.

Parameters:
    _group      - the group <GROUP, OBJECT>
    _position   - centre of area to defend <ARRAY, OBJECT, LOCATION, GROUP> (Default: _group)
    _radius     - radius of area to defend <NUMBER> (Default: 50)
    _threshold  - minimum building positions required to be considered for garrison <NUMBER> (Default: 3)
    _patrol     - chance for each unit to patrol instead of garrison, true for default, false for 0% <NUMBER, BOOLEAN> (Default: 0.1)
    _hold       - chance for each unit to hold their garrison in combat, true for 100%, false for 0% <NUMBER, BOOLEAN> (Default: 0)

Returns:
    None

Examples:
    (begin example)
        [this] call CBA_fnc_taskDefend
    (end)

Author:
    Rommel, SilentSpike
---------------------------------------------------------------------------- */
params [
    ["_group", grpNull, [grpNull, objNull]],
    ["_position", [], [[], objNull, grpNull, locationNull], 3],
    ["_radius", 50, [0]],
    ["_threshold", 3, [0]],
    ["_patrol", 0.1, [true, 0]],
    ["_hold", 0, [true, 0]]
];

private _New = true;
if ((count _this) >= 7) then {_New = (_this select 6)};

// Input validation stuff here
_group = _group call CBA_fnc_getGroup;
if !(local _group) exitWith {}; // Don't create waypoints on each machine

_position = [_position, _group] select (_position isEqualTo []);
_position = _position call CBA_fnc_getPos;

if (_patrol isEqualType true) then {
    _patrol = [0, 0.1] select _patrol;
};

if (_hold isEqualType true) then {
    _hold = parseNumber _hold;
};

// Start of the actual function
[_group] call CBA_fnc_clearWaypoints;

private _statics = _position nearObjects ["StaticWeapon", _radius];
private _buildings = _position nearObjects ["Building", _radius];

private _BclassesOP = [

    "Land_BagBunker_Large_F",
    "Land_BagBunker_Small_F",
    "Land_BagBunker_Tower_F",
    "Land_Cargo_HQ_V2_F",
    "Land_Cargo_HQ_V3_F",
    "Land_Cargo_HQ_V1_F",
    "Land_Cargo_Patrol_V3_F",
    "Land_Cargo_Patrol_V1_F",
    "Land_Cargo_Patrol_V2_F",
    "Land_Cargo_Tower_V1_No1_F",
    "Land_Cargo_Tower_V1_No2_F",
    "Land_Cargo_Tower_V1_No3_F",
    "Land_Cargo_Tower_V1_No4_F",
    "Land_Cargo_Tower_V1_No5_F",
    "Land_Cargo_Tower_V1_No6_F",
    "Land_Cargo_Tower_V1_No7_F",
    "Land_Cargo_Tower_V3_F",
    "Land_Cargo_Tower_V1_F",
    "Land_Cargo_Tower_V2_F",
    "Land_Research_HQ_F",
    "Land_Bunker_02_light_double_F",
    "Land_Bunker_02_light_left_F",
    "Land_Bunker_02_left_F",
    "Land_Bunker_02_double_F",
    "Land_Bunker_02_light_right_F",
    "Land_Bunker_02_right_F",
    "Land_Bunker_01_big_F",
    "Land_Bunker_01_HQ_F",
    "Land_Bunker_01_small_F",
    "Land_Bunker_01_tall_F",
    "Land_BagBunker_01_large_green_F",
    "Land_BagBunker_01_small_green_F",
    "Land_HBarrier_01_tower_green_F",
    "Land_Cargo_HQ_V4_F",
    "Land_Cargo_Patrol_V4_F",
    "Land_Cargo_Tower_V4_F"
];

private _BclassesGen = [

    "Land_DeconTent_01_AAF_F",
    "Land_DeconTent_01_CSAT_brownhex_F",
    "Land_DeconTent_01_NATO_F",
    "Land_MedicalTent_01_digital_closed_F",
    "Land_MedicalTent_01_brownhex_closed_F",
    "Land_MedicalTent_01_MTP_closed_F",
    "Land_Cargo_House_V3_F",
    "Land_Cargo_House_V1_F",
    "Land_Medevac_house_V1_F",
    "Land_Cargo_House_V2_F",
    "Land_Medevac_HQ_V1_F",
    "Land_Research_house_V1_F",
    "Land_MedicalTent_01_aaf_generic_closed_F",
    "Land_MedicalTent_01_CSAT_brownhex_generic_closed_F",
    "Land_MedicalTent_01_NATO_generic_closed_F",
    "Land_MedicalTent_01_aaf_generic_inner_F",
    "Land_MedicalTent_01_CSAT_brownhex_generic_inner_F",
    "Land_MedicalTent_01_NATO_generic_inner_F",
    "Land_MedicalTent_01_aaf_generic_open_F",
    "Land_MedicalTent_01_CSAT_brownhex_generic_open_F",
    "Land_MedicalTent_01_NATO_generic_open_F",
    "Land_MedicalTent_01_aaf_generic_outer_F",
    "Land_MedicalTent_01_CSAT_brownhex_generic_outer_F",
    "Land_MedicalTent_01_NATO_generic_outer_F",
    "Land_MedicalTent_01_wdl_generic_closed_F",
    "Land_MedicalTent_01_wdl_generic_inner_F",
    "Land_MedicalTent_01_wdl_generic_open_F",
    "Land_MedicalTent_01_wdl_generic_outer_F",
    "Land_MedicalTent_01_CSAT_greenhex_generic_closed_F",
    "Land_MedicalTent_01_NATO_tropic_generic_closed_F",
    "Land_MedicalTent_01_CSAT_greenhex_generic_inner_F",
    "Land_MedicalTent_01_NATO_tropic_generic_inner_F",
    "Land_MedicalTent_01_CSAT_greenhex_generic_open_F",
    "Land_MedicalTent_01_NATO_tropic_generic_open_F",
    "Land_MedicalTent_01_CSAT_greenhex_generic_outer_F",
    "Land_MedicalTent_01_NATO_tropic_generic_outer_F",
    "Land_MedicalTent_01_wdl_closed_F",
    "Land_DeconTent_01_wdl_F",
    "Land_DeconTent_01_CSAT_greenhex_F",
    "Land_DeconTent_01_NATO_tropic_F",
    "Land_MedicalTent_01_greenhex_closed_F",
    "Land_MedicalTent_01_tropic_closed_F",
    "Land_Cargo_House_V4_F"
];

private _Bclasses = _BclassesGen + _BclassesOP;

// Filter out occupied statics and non military buildings
_statics = _statics select {locked _x != 2 && {(_x emptyPositions "Gunner") > 0}};

// Filter out buildings below the size threshold (and store positions for later use) and remove non military buildings
_buildings = _buildings select {
    private _positions = _x buildingPos -1;

    if (isNil {_x getVariable "CBA_taskDefend_positions"}) then {
        _x setVariable ["CBA_taskDefend_positions", _positions];
    };

   (count (_positions) >= _threshold)
};

// If patrolling is enabled then the leader must be free to lead it
private _units = units _group;
if (_patrol > 0 && {count _units > 1}) then {
    _units deleteAt (_units find (leader _group));
};

{
    // 31% chance to occupy nearest free static weapon
    if ((random 1 < 0.31) && {_statics isNotEqualTo []}) then {
        _x assignAsGunner (_statics deleteAt 0);
        [_x] orderGetIn true;
    } else {
        // Respect chance to patrol, or force if no building positions left
        if !((_buildings isEqualTo []) || { (random 1 < _patrol) }) then {
            private _building = _buildings select {
                if ((random 100) < 55) then {((typeOf _x) in _BclassesOP)} else {true}
            };

            _building = selectRandom _building;
            private _array = _building getVariable ["CBA_taskDefend_positions", []];

            if (_array isNotEqualTo []) then {
                private _pos = _array deleteAt (floor (random (count _array)));

                // If building positions are all taken remove from possible buildings
                if (_array isEqualTo []) then {
                    _buildings deleteAt (_buildings find _building);
                    _building setVariable ["CBA_taskDefend_positions", nil];
                } else {
                    _building setVariable ["CBA_taskDefend_positions", _array];
                };

                // Wait until AI is in position then force them to stay
                [_x, _pos, _hold,_New] spawn {
                    params ["_unit", "_pos", "_hold","_New"];
                    if (surfaceIsWater _pos) exitWith {};

                    _unit doMove _pos;
                    if (_New) then {_unit setPos _pos};
                    [{
                    [{unitReady _unit;}, 1] call CBA_fnc_waitAndExecute;
                    if (random 1 < _hold) then {
                        _unit disableAI "PATH";
                        doStop _unit;
                        _unit setVariable ["NR6Site",true];
                    } else {
                        doStop _unit;
                        _unit setVariable ["NR6Site",true];
                    };

                    // This command causes AI to repeatedly attempt to crouch when engaged
                    // If ever fixed by BI then consider uncommenting
                    // _unit setUnitPos "UP";
                    }, {}] call CBA_fnc_waitUntilAndExecute;
               };
            };
       };
    };
} forEach _units;

// Unassigned (or combat reacted) units will patrol
[_group, _position, _radius, 5, "sad", "safe", "red", "limited"] call CBA_fnc_taskPatrol;

