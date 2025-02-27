#include "..\script_component.hpp"
// Originally from HAC_fnc.sqf (RYD_FindClosest)

/**
 * @description Finds the closest object/position to a reference point
 * @param {Array|Object} Reference position or object
 * @param {Array} Array of positions or objects to check
 * @return {Array|Object} The closest position or object from the array
 */
params ["_reference", "_objectsArray"];

// Return early if array is empty
if (_objectsArray isEqualTo []) exitWith {objNull};

// Initialize with the first element as closest
private _closest = _objectsArray select 0;
private _minDistance = _reference distance _closest;

// Check all objects in the array
{
    private _currentDistance = _reference distance _x;

    // If we found a closer object, update the minimum
    if (_currentDistance < _minDistance) then {
        _minDistance = _currentDistance;
        _closest = _x;
    };
} forEach _objectsArray;

// Return the closest object
_closest
