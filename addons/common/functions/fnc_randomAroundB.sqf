#include "..\script_component.hpp"

/**
 * @description Selects a random position around a given center point within specified radius
 * @param {Array} Center position [x,y,z]
 * @param {Number} Maximum radius
 * @return {Array} New position [x,y,z]
 */
params ["_pos", "_radiusMax"];

private _angle = random 360;
private _radius = random _radiusMax;

private _X = _radius * sin _angle;
private _Y = _radius * cos _angle;

[(_pos select 0) + _X, (_pos select 1) + _Y, 0] 