#include "..\script_component.hpp"
// Originally from HAC_fnc.sqf (RYD_ReverseArr)

private ["_arr","_final","_amnt"];

	_arr = _this select 0;
	_amnt = count _arr;

	_final = [];

		{
		_amnt = _amnt - 1;
		_final set [_amnt,_x]
		}
	forEach _arr;

	_final