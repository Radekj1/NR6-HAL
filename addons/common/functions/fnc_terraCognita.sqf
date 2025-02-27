#include "..\script_component.hpp"
// Originally from HAC_fnc.sqf (RYD_TerraCognita)

/**
 * @description Analyzes terrain features around a position
 * @param {Array|Object} Position or object to analyze
 * @param {Number} Number of samples to take for each terrain type
 * @param {Number} [Optional] Radius to analyze (default: 100m)
 * @return {Array} Values [urban, forest, hills, flat, sea, groundGradient]
 */
params ["_position", "_samples", ["_radius", 100]];

// Convert object to position if needed
if !(_position isEqualType []) then {
    _position = getPosATL _position;
};

private _posX = _position select 0;
private _posY = _position select 1;

// Constants for terrain analysis
private _urban = 0;
private _forest = 0;
private _hills = 0;
private _flat = 0;
private _sea = 0;

// Calculate ground gradient (slope) around the position
private _groundGradient = 0;
private _prevHeight = getTerrainHeightASL [_posX, _posY];

// Take 10 samples to measure terrain gradient
for "_i" from 1 to 10 do {
    private _samplePos = [_posX + ((random (_radius * 2)) - _radius), _posY + ((random (_radius * 2)) - _radius)];
    private _currentHeight = getTerrainHeightASL _samplePos;
    _groundGradient = _groundGradient + abs (_currentHeight - _prevHeight);
    _prevHeight = _currentHeight;
};

// Average the gradient
_groundGradient = _groundGradient / 10;

// Analyze terrain features using selectBestPlaces
{
    private _valueSum = 0;

    // Take multiple samples for each terrain type to improve accuracy
    for "_i" from 1 to _samples do {
        // Use a small radius for each sample but randomize the center position
        private _sampleCenter = [
            _posX + (random (_radius/5)) - (_radius/10),
            _posY + (random (_radius/5)) - (_radius/10)
        ];

        // Get the best place of this type in a small radius
        private _bestValue = selectBestPlaces [_sampleCenter, 5, _x, 1, 1];

        // Extract the value from the result
        if (count _bestValue > 0) then {
            _valueSum = _valueSum + ((_bestValue select 0) select 1);
        };
    };

    // Calculate average value for this terrain type
    private _average = _valueSum / _samples;

    // Store in the appropriate variable
    switch (_x) do {
        case "Houses": { _urban = _urban + _average };
        case "Trees": { _forest = _forest + (_average/3) };
        case "Forest": { _forest = _forest + _average };
        case "Hills": { _hills = _hills + _average };
        case "Meadow": { _flat = _flat + _average };
        case "Sea": { _sea = _sea + _average };
    };
} forEach ["Houses", "Trees", "Forest", "Hills", "Meadow", "Sea"];

// Return combined terrain analysis
[_urban, _forest, _hills, _flat, _sea, _groundGradient]
