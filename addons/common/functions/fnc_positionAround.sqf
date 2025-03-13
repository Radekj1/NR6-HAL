#include "..\script_component.hpp"
// Originally from HAC_fnc.sqf (RYD_RandomAround)

//based on Muzzleflash' function
params ["_pos", "_a"];

private _xPos = _pos select 0;
private _yPos = _pos select 1;

private _dir = random 360;

private _mag = sqrt ((random _a) * _a);
private _nX = _mag * (sin _dir);
private _nY = _mag * (cos _dir);

[_xPos + _nX, _yPos + _nY, 0]
