#include "..\script_component.hpp"
// Originally from HAC_fnc.sqf (RYD_RandomAroundMM)

/**
 * @description Selects a random position around a given center point within min-max radius
 * @param {Array} Center position [x,y,z]
 * @param {Number} Minimum radius
 * @param {Number} Maximum radius
 * @return {Array} New position [x,y,z]
 */
params ["_pos", "_minRadius", "_maxRadius"];

private _range = _maxRadius - _minRadius;
private _dir = random 360;

// Non-uniform distribution - sqrt ensures more even spatial distribution
private _mag = _minRadius + (sqrt ((random _range) * _range));
private _nX = _mag * sin _dir;
private _nY = _mag * cos _dir;

[(_pos select 0) + _nX, (_pos select 1) + _nY, 0] 