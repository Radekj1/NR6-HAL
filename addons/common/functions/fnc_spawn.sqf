#include "..\script_component.hpp"
// Originally from HAC_fnc2.sqf (RYD_Spawn)

private ["_arguments","_script","_handle"];

_arguments = _this select 0;
_script = _this select 1;

_handle = _arguments spawn _script;

RydxHQ_Handles pushBack _handle;

    {
    if (isNil {_x}) then
        {
        RydxHQ_Handles set [_foreachIndex,0]
        }
    else
        {
        if not (_x isEqualTo 0) then
            {
            if (scriptDone _x) then
                {
                RydxHQ_Handles set [_foreachIndex,0]
                }
            }
        }
    }
forEach RydxHQ_Handles;

RydxHQ_Handles = RydxHQ_Handles - [0];
