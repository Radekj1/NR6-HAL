#include "..\script_component.hpp"
// Originally from HAC_fnc.sqf (RYD_FireCount)

/**
 * @description Tracks unit firing and removes event handler after a threshold
 * @param {Object} Unit to track firing
 * @return {Nothing}
 */
params ["_unit"];

// Get current fire count or initialize to 0
private _fireCount = _unit getVariable ["FireCount", 0];

// If already fired at least twice, remove the event handler
if (_fireCount >= 2) exitWith {
    // Get and remove the Fired event handler
    private _eventHandlerId = _unit getVariable ["HAC_FEH", nil];
    if (!isNil "_eventHandlerId") then {
        _unit removeEventHandler ["Fired", _eventHandlerId];
        _unit setVariable ["HAC_FEH", nil];
    };
};

// Increment the fire count
_unit setVariable ["FireCount", _fireCount + 1]; 