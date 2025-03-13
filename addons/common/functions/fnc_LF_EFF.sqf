#include "..\script_component.hpp"
// Originally from HAC_fnc2.sqf (RYD_LF_EFF)


params ["_mode"];

if !(isNil "BIS_liveFeed") then {
    [_mode] call BIS_fnc_liveFeedEffects;
};