#include "..\script_component.hpp"
// Originally from HAC_fnc.sqf (RYD_AmmoCount)

/**
 * @description Counts total ammunition in a group, both on units and in vehicles
 * @param {Group} Group to check ammunition for
 * @param {Array} [Optional] Array of vehicle types to exclude
 * @return {Number} Total ammunition count
 */
params ["_group", ["_excludedVehicles", []]];

// Find all unique vehicles in the group
private _groupVehicles = [];
{
    if !(vehicle _x isEqualTo _x) then {
        _groupVehicles pushBackUnique (vehicle _x);
    };
} forEach (units _group);

// Calculate total ammunition count
private _ammoCount = 0;

// Add all magazines from units
{
    _ammoCount = _ammoCount + count (magazines _x);
} forEach (units _group);

// Add all cargo magazines from vehicles
{
    _ammoCount = _ammoCount + count (magazineCargo _x);
} forEach _groupVehicles;

_ammoCount 