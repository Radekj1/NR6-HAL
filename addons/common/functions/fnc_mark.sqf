#include "..\script_component.hpp"
// Originally from HAC_fnc.sqf (RYD_Mark)

/**
 * @description Creates a marker with given parameters and adds it to the marker tracking array
 * @param {Array|Object} Position for the marker or object to place marker on
 * @param {Object|String} Reference object or string to create unique marker name
 * @param {String} Prefix for marker name
 * @param {String} Marker color
 * @param {String} Marker shape (ICON, RECTANGLE, ELLIPSE)
 * @param {String} Marker type (for ICON shape)
 * @param {String} Default marker text
 * @param {String} Text when player is reference
 * @param {Array} [Optional] Marker size [width, height]
 * @param {Number} [Optional] Marker direction in degrees
 * @return {String} Created marker name
 */
params [
    "_pos",
    "_ref",
    "_prefix",
    "_color",
    "_shape",
    "_type",
    "_defaultText",
    "_playerText",
    ["_size", [1, 1]],
    ["_dir", 0]
];

// Determine final marker text
private _text = _defaultText;

// Use special text for player groups
if (typeName _ref == "GROUP") then {
    if (isPlayer (leader _ref)) then {
        _text = _defaultText;
    };
};

// Convert object position to coordinates if needed
if (typeName _pos == "OBJECT") then {
    _pos = position _pos;
};

// Validate position
if (!(_pos isEqualType []) ||
    count _pos < 2 ||
    (_pos select 0) == 0 ||
    isNil "_pos") exitWith {""};

// Create unique marker name
private _markerName = _prefix + (str _ref);
private _marker = createMarker [_markerName, _pos];

// Set marker properties
_marker setMarkerColorLocal _color;
_marker setMarkerShapeLocal _shape;

if (_shape == "ICON") then {
    _marker setMarkerTypeLocal _type;
} else {
    _marker setMarkerBrushLocal _type;
};

_marker setMarkerSizeLocal _size;
_marker setMarkerDirLocal _dir;
_marker setMarkerText _text;

// Add to marker tracking array if it exists
if (!isNil "RydxHQ_Markers") then {
    RydxHQ_Markers pushBack _marker;
};

// Return marker name
_marker
