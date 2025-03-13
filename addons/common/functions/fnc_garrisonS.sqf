#include "..\script_component.hpp"
// Originally from HAC_fnc.sqf (RYD_GarrS)

/**
 * @description Places a unit in a garrison position and configures their stance/direction
 * @param {Object} Unit to place in garrison
 * @param {Array} Position where to garrison
 * @param {Object} Building object to garrison in
 * @param {Array} Taken positions tracking array [array, index]
 * @param {Object} HQ reference
 * @return {Nothing}
 */
params ["_unit", "_pos", "_bld", "_taken", "_HQ"];

// Order unit to move to garrison position
_unit doMove _pos;

// Store original position to check progress
private _posLast = getPosASL _unit;
private _timer = 0;
private _alive = true;

// Wait until unit reaches position or timeout
waitUntil {
    private _dst = 0;
    if !(isNull _unit) then {_dst = _unit distance _pos};
    [0.1] call CBA_fnc_waitAndExecute;

    private _dst2 = 0;
    if !(isNull _unit) then {_dst2 = _unit distance _pos};

    // Check if the unit is still alive and valid
    switch (true) do {
        case (isNull _unit): {_alive = false};
        case (!alive _unit): {_alive = false};
        case (_HQ getVariable ["RydHQ_KIA", false]): {_alive = false};
        case ((group _unit) getVariable ["RydHQ_MIA", false]): {
            _alive = false;
            (group _unit) setVariable ["RydHQ_MIA", nil];
        };
    };

    // Increment timer if we're not making progress
    if (_dst2 >= _dst) then {_timer = _timer + 1};

    ((unitReady _unit) || (_timer > 240) || !_alive)
};

// Exit if unit died during movement
if !(_alive) exitWith {};

// Stop the unit
doStop _unit;

// Get building direction as a starting point for positioning
private _dir = getDir _bld;

// Get unit's ASL position for calculations
private _uPosASL = getPosASL _unit;
private _watchPos = [];
private _unitP = "UP"; // Default stance

// Try to find a good position to watch in four directions (90-degree increments)
for "_i" from _dir to (_dir + 270) step 90 do {
    // Try to find a position 5m away in this direction with line of sight
    private _cPosASL = [_uPosASL, _i, 5] call FUNC(positionTowards2D);
    private _isLOS = [_cPosASL, _cPosASL, 1.5, 20, _unit, objNull] call RYD_LOSCheck;

    if (_isLOS) then {
        // Double-check if we have direct line of sight
        _isLOS = [_uPosASL, _cPosASL, 1.5, 1.5, _unit, objNull] call RYD_LOSCheck;

        if (_isLOS) then {
            _watchPos = ASLToATL _cPosASL;
        };
    };
};

// If we couldn't find a good position, try looking at building exits
if (count _watchPos < 2) then {
    _unitP = "MIDDLE";
    private _exits = [];
    private _exitCount = 0;
    private _exitPos = _bld buildingExit 0;

    // Check all building exits for those with line of sight
    while {(_exitPos distance [0,0,0]) > 0} do {
        private _isLOS = [_uPosASL, ATLToASL _exitPos, 1.5, 1.5, _unit, objNull] call RYD_LOSCheck;
        if (_isLOS) then {
            _exits pushBack _exitPos;
        };

        _exitCount = _exitCount + 1;
        _exitPos = _bld buildingExit _exitCount;
    };

    // Choose the closest exit if any are valid
    if (count _exits > 0) then {
        private _closestExit = [_uPosASL, _exits] call RYD_FindClosest;
        _watchPos = _closestExit;
    };
};

// Last resort: find the direction with the longest line of sight
if (count _watchPos < 2) then {
    _unitP = "MIDDLE";
    private _maxDst = 1;
    private _chosenDir = random 360;

    // Check in cardinal directions
    for "_i" from _dir to (_dir + 270) step 90 do {
        private _isLOS = true;
        private _dst = 1;

        // Keep going until we hit something
        while {_isLOS} do {
            private _cPosASL = [_uPosASL, _i, _dst] call FUNC(positionTowards2D);
            _isLOS = [_uPosASL, _cPosASL, 1.5, 1.5, _unit, objNull] call RYD_LOSCheck;
            _dst = _dst + 1;
            if (_dst > 50) exitWith {};
        };

        // Remember the direction with the longest sight line
        if (_dst > _maxDst) then {
            _maxDst = _dst;
            _chosenDir = _i;
        };

        _watchPos = ASLToATL ([_uPosASL, _chosenDir, 5] call FUNC(positionTowards2D));
    };
};

// Calculate exact direction to lookout position
private _watchDir = [_uPosASL, _watchPos, 5] call FUNC(angleTowards);

// Set unit's stance and direction
_unit setUnitPos _unitP;
_unit setDir _watchDir;
_unit doWatch _watchPos;

// Wait until the unit is no longer garrisoned or killed
waitUntil {
    [30] call CBA_fnc_waitAndExecute;

    // Check if unit is still valid
    switch (true) do {
        case (isNull _unit): {_alive = false};
        case (!alive _unit): {_alive = false};
        case (_HQ getVariable ["RydHQ_KIA", false]): {_alive = false};
        case ((group _unit) getVariable ["RydHQ_MIA", false]): {
            _alive = false;
            (group _unit) setVariable ["RydHQ_MIA", nil];
        };
    };

    // Check if the group is still garrisoned
    private _isGarrisoned = (group _unit) getVariable ("Garrisoned" + (str (group _unit)));
    if (isNil "_isGarrisoned" || {!_isGarrisoned}) then {_alive = false};

    !_alive
};

// When exiting, free up the position in the taken array
private _ix = _taken select 1;
_taken = _taken select 0;
_taken deleteAt _ix;
