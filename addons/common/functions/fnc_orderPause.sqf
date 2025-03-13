#include "..\script_component.hpp"
// Originally from HAC_fnc.sqf (RYD_OrderPause)

/**
 * @description Pauses order execution to prevent command spam and can trigger HQ chat messages
 * @param {Group} Group that's receiving the order
 * @param {Array|Object} Position or object related to the order
 * @param {String} Message type for HQ chat
 * @param {Group} HQ group issuing the order
 * @return {Boolean} Always returns true
 */
params ["_group", "_position", "_messageType", "_HQ"];

// Convert object/location to position array if needed
if ((typeName _position) in [(typeName objNull), (typeName locationNull)]) then {
    _position = position _position;
};

// Ensure z-coordinate is 0
_position set [2, 0];

// Calculate a variable pause time (3-4.5 seconds)
private _pauseDuration = 3 + (random 1.5);

// Wait until enough time has passed since last order
waitUntil {
    [0.1] call CBA_fnc_waitAndExecute;

    private _lastOrderTime = _HQ getVariable ["RydHQ_MyLastOrder", 0];

    ((time - _lastOrderTime) > _pauseDuration)
};

// Update the last order time
_HQ setVariable ["RydHQ_MyLastOrder", time];

// Send HQ chat message if enabled
if (missionNamespace getVariable ["RydxHQ_HQChat", false]) then {
    [_group, _messageType, _position, _HQ] call FUNC(HQChatter);
};

// Always return true
true
