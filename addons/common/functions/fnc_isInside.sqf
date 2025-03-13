#include "..\script_component.hpp"
// Originally from HAC_fnc2.sqf (RYD_isInside)

private ["_pos","_cam","_target","_pX","_pY","_pZ","_pos1","_pos2","_level","_roofed","_axis","_mark","_vh","_axisArr","_marks"];

_vh = _this select 0;
_pos = _this select 1;
_level = _this select 2;
_axisArr = _this select 3;
_marks = _axisArr select 1;
_axisArr = _axisArr select 0;

_cam = objNull;

if ((count _this) > 5) then {_cam = _this select 5};

_target = objNull;

if ((count _this) > 6) then {_target = _this select 6};

_pX = _pos select 0;
_pY = _pos select 1;
_pZ = _pos select 2;

_pos1 = [_pX,_pY,_pZ];

_roofed = false;

{
    _axis = _x;
    _mark = _marks select _foreachIndex;

    _pos2 = +_pos1;
    _pos2 set [_axis,(_pos2 select _axis) + (_level * _mark)];

    _roofed = lineIntersects [ATLToASL (_vh modelToWorld _pos1), ATLToASL (_vh modelToWorld _pos2),_cam,_target];

    if (_roofed) exitWith {};
} forEach _axisArr;

_roofed