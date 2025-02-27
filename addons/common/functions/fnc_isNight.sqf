#include "..\script_component.hpp"
// Originally from HAC_fnc.sqf (RYD_isNight)

/**
 * @description Determines if it is currently night time in-game based on sunOrMoon value and overcast
 * @return {Boolean} True if it is night, false otherwise
 */

// Calculate if it's night based on sunOrMoon value, adjusted for overcast
// Formula accounts for reduced light levels in cloudy conditions
private _isNight = (sunOrMoon - ((overcast/2)^(2 - overcast))) <= 0.15;

// Return the result
_isNight 