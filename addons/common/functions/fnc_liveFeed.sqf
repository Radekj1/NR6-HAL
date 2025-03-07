#include "..\script_component.hpp"
// Originally from HAC_fnc2.sqf (RYD_LiveFeed)

private ["_unit","_HQ","_id"];

_unit = _this select 0;
_HQ = _this select 1;

_id = _unit addAction ["Enable cam view", (RYD_Path + "LF\LF.sqf"),[_HQ], -71, false, true, "", "(not RydxHQ_LFActive) and (_this == _target)"];
_id = _unit addAction ["Disable cam view", (RYD_Path + "LF\LF.sqf"),[_HQ], -81, false, true, "", "(RydxHQ_LFActive) and (_this == _target)"];

true