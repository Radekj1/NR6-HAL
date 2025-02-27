#include "..\script_component.hpp"
// Originally from HAC_fnc.sqf (RYD_CreateDecoy)

/**
 * @description Creates an invisible target object at specified position
 * @param {Array} Position where to create the decoy [x,y,z]
 * @return {Object} Created decoy object
 */
params ["_pos"];

// Create a sphere object that will be invisible but can be targeted
private _decoy = "Sign_Sphere100cm_F" createVehicle _pos;

// Position it precisely
_decoy setPosATL _pos;

// Make it transparent so it's not visible to players
_decoy setObjectTexture [0, "#(ARGB,8,8,3)color(1,1,1,0,ca)"];

// Return the created object
_decoy
