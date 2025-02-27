#include "..\script_component.hpp"
// Originally from HAC_fnc.sqf (RYD_LOSCheck)

/**
 * @description Checks line of sight between two positions with height adjustments
 * @param {Array} First position in ASL format
 * @param {Array} Second position in ASL format
 * @param {Number} Height adjustment for first position
 * @param {Number} Height adjustment for second position
 * @param {Object} [Optional] Object to exclude from LOS check
 * @param {Object} [Optional] Additional object to exclude from LOS check
 * @return {Boolean} True if line of sight is clear, false otherwise
 */
params [
    "_pos1", 
    "_pos2", 
    "_height1", 
    "_height2", 
    ["_ignoreObject", objNull], 
    ["_ignoreObject2", objNull]
];

// Extract coordinates for terrain intersection check
private _pX1 = _pos1 select 0;
private _pY1 = _pos1 select 1;
private _pX2 = _pos2 select 0;
private _pY2 = _pos2 select 1;

// Create adjusted positions for the LOS check
private _checkPos1 = [_pX1, _pY1, (_pos1 select 2) + _height1];
private _checkPos2 = [_pX2, _pY2, (_pos2 select 2) + _height2];

// Create ATL positions for terrain intersection check
private _pos1ATL = [_pX1, _pY1, _height1];
private _pos2ATL = [_pX2, _pY2, _height2];

// First check if the terrain itself blocks the line of sight
private _isLOS = !terrainIntersect [_pos1ATL, _pos2ATL];

// If terrain doesn't block the view, check for objects blocking the view
if (_isLOS) then {
    _isLOS = !lineIntersects [_checkPos1, _checkPos2, _ignoreObject, _ignoreObject2];
};

_isLOS 