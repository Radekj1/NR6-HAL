#include "..\script_component.hpp"
// Originally from HAC_fnc.sqf (RYD_CloseEnemyB)

/**
 * @description Checks if any enemy group is within the specified distance and returns additional info
 * @param {Object|Array} Position or object to check from
 * @param {Array} Array of enemy groups to check
 * @param {Number} Maximum distance to consider enemies as "close"
 * @return {Array} [is enemy close, closest distance, closest enemy group]
 */
params ["_position", "_enemyGroups", "_maxDistance"];

// Exit early if no enemy groups to check
if (count _enemyGroups == 0) exitWith {[false, 100000, grpNull]};

// Initialize variables with defaults
private _enemyIsClose = false;
private _minimumDistance = 100000;
private _closestEnemyGroup = _enemyGroups select 0;

// Find the closest enemy group and its distance
{
    private _enemyDistance = (vehicle (leader _x)) distance _position;
    
    if (_enemyDistance < _minimumDistance) then {
        _closestEnemyGroup = _x;
        _minimumDistance = _enemyDistance;
    };
} forEach _enemyGroups;

// Determine if the closest enemy is within the specified range
if (_minimumDistance < _maxDistance) then {
    _enemyIsClose = true;
};

// Return result array with all information
[_enemyIsClose, _minimumDistance, _closestEnemyGroup] 