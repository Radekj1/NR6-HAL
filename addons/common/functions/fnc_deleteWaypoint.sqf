#include "..\script_component.hpp"
// Originally from HAC_fnc.sqf (RYD_WPdel)

//used for deleting waypoints?
//[_group] call RYD_WPdel
params ["_group"];

if (isNil "_group") exitWith {};
if (isNull _group) exitWith {};

private _count = (count (waypoints _group)) - 1;

if (_count < 0) exitWith {};

[_group, (currentWaypoint _group)] setWaypointPosition [position (vehicle (leader _group)), 0];

while {(_count >= 0)} do {
    if (isNull _group) exitWith {};
    _count = (count (waypoints _group)) - 1;
    if (_count < 0) exitWith {};
    deleteWaypoint ((waypoints _group) select _count);
    _count = (count (waypoints _group)) - 1
};
