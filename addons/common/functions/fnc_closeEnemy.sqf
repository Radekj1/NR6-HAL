#include "..\script_component.hpp"
// Originally from HAC_fnc.sqf (RYD_CloseEnemy)

/**
 * @description Checks if any enemy group is within the specified distance
 * @param {Object|Array} Position or object to check from
 * @param {Array} Array of enemy groups to check
 * @param {Number} Maximum distance to consider enemies as "close"
 * @return {Boolean} True if any enemy is within range, false otherwise
 */
params ["_position", "_enemyGroups", "_maxDistance"];

// Exit early if no enemy groups to check
if (count _enemyGroups == 0) exitWith {false};

// Initialize result
private _enemyIsClose = false;

// Get minimum distance to any enemy group
{
    private _enemyDistance = (vehicle (leader _x)) distance _position;
    if (_enemyDistance < _maxDistance) exitWith {
        _enemyIsClose = true;
    };
} forEach _enemyGroups;

// Return the result
_enemyIsClose
