#include "..\script_component.hpp"
// Originally from HAC_fnc.sqf (RYD_RandomOrdB)

private ["_array","_final","_random","_select"];

_array = +(_this select 0);

_final = [];

while {((count _array) > 0)} do
	{
	_select = floor (random (count _array));
	_random = _array select _select;
	_final pushBack _random;

	_array deleteAt _select;
	};

_final
