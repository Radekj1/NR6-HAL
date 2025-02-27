#include "..\script_component.hpp"
// Originally from HAC_fnc.sqf (RYD_AngTowards)

params ["_source", "_target", "random"];

private _dX0 = (_target select 0) - (_source select 0);
private _dY0 = (_target select 1) - (_source select 1);

(_dX0 atan2 _dY0) + (random (_random * 2)) - _random;