#include "..\script_component.hpp"
// Originally from HAC_fnc.sqf (RYD_AIChatter)

/**
 * @description Handles AI radio communications based on situation and chat type
 * @param {Object} Unit that will speak
 * @param {Array} Array of possible sentences (radio message names)
 * @param {String} Type of message (used for tracking repeats)
 * @return {Nothing}
 */
params ["_unit", "_sentences", "_messageType"];

// Skip if no players of unit's side are present
private _unitGroup = group _unit;
private _unitSide = side _unit;

if (({((side _x) == _unitSide) && (isPlayer _x)} count allUnits) < 1) exitWith {};

// Check if this group has spoken recently
private _lastCommunication = _unitGroup getVariable ["HAC_LastComm", -5];
if ((time - _lastCommunication) < 5) exitWith {};

// Set the last communication time
_unitGroup setVariable ["HAC_LastComm", time];

// Apply chat type variations if specified in mission settings
switch (missionNamespace getVariable ["RydxHQ_AIChat_Type", "NONE"]) do {
    case "SILENT_M": {
        _sentences = call compile ("RydxHQ_AIC_SILENTM_" + _messageType);
    };
    case "40K_IMPERIUM": {
        _sentences = call compile ("RydxHQ_AIC_40KImp_" + _messageType);
    };
};

// Determine variable name suffix based on side
private _varSuffix = switch (_unitSide) do {
    case east: {"_East"};
    case resistance: {"_Guer"};
    default {"_West"};
};

// Check for recent messages to avoid spam
private _lastTime = missionNamespace getVariable ["HAC_AIChatLT" + _varSuffix, [0, ""]];
private _lastKind = _lastTime select 1;
private _lastTimestamp = _lastTime select 0;

// Introduce delays to avoid message clusters
if ((time - _lastTimestamp) < 5) then {[{}, 2] call CBA_fnc_waitAndExecute;};
_lastTime = missionNamespace getVariable ["HAC_AIChatLT" + _varSuffix, [0, ""]];
_lastKind = _lastTime select 1;
_lastTimestamp = _lastTime select 0;
if ((time - _lastTimestamp) < 5) then {[{}, 2] call CBA_fnc_waitAndExecute;};
_lastTime = missionNamespace getVariable ["HAC_AIChatLT" + _varSuffix, [0, ""]];
_lastKind = _lastTime select 1;
_lastTimestamp = _lastTime select 0;
if ((time - _lastTimestamp) < 5) exitWith {};

// Prevent excessive repetition of the same message type
private _shouldExit = false;
if (_lastKind isEqualTo _messageType) then {
    private _chatRepetitions = missionNamespace getVariable ["HAC_AIChatRep" + _varSuffix, 0];
    private _repetitionExitChance = round (random 2);

    if (_chatRepetitions >= _repetitionExitChance) then {
        if ((random 100) < (90 + _chatRepetitions)) then {
            _shouldExit = true;
        };
    };
};

if (_shouldExit) exitWith {};

// Update the last message time
missionNamespace setVariable ["HAC_AIChatLT" + _varSuffix, [time, _messageType]];

// Increment repetition counter if same message type is repeated
if (_lastKind isEqualTo _messageType) then {
    private _chatRepetitions = missionNamespace getVariable ["HAC_AIChatRep" + _varSuffix, 0];
    missionNamespace setVariable ["HAC_AIChatRep" + _varSuffix, _chatRepetitions + 1];
};

// Randomly select a sentence and transmit via radio
private _sentence = selectRandom _sentences;
[_unit, _sentence] remoteExecCall ["sideRadio"];

// Create debug markers if enabled
if (missionNamespace getVariable ["RydHQ_ChatDebug", false]) then {
    // Select marker color and type based on message category
    private _color = "ColorGrey";
    private _type = "mil_warning";

    if (_messageType in ["ArtyReq", "SmokeReq", "IllumReq", "SuppReq", "MedReq"]) then {
        _type = "mil_unknown";
    };

    switch (true) do {
        case (_messageType in ["OffStance", "DefStance", "OrdConf", "OrdFinal", "OrdEnd", "ArtFire"]): {
            _color = "Color4_FD_F"; // light blue
        };
        case (_messageType in ["SuppAss", "ArtAss"]): {
            _color = "Color2_FD_F"; // light khaki
        };
        case (_messageType in ["EnemySpot"]): {
            _color = "Color1_FD_F"; // light red
        };
        case (_messageType in ["MedReq", "SuppReq", "ArtyReq", "SmokeReq", "IllumReq"]): {
            _color = "Color3_FD_F"; // light orange
        };
        case (_messageType in ["ArtDen", "SuppDen", "OrdDen"]): {
            _color = "ColorOrange";
        };
        case (_messageType in ["InDanger", "InFear", "InPanic"]): {
            _color = "ColorRed";
        };
    };

    // Get the translated sentence text
    private _sentenceText = getText (configFile >> "CfgRadio" >> _sentence >> "title");

    // Add the unit's group name to the marker text
    private _who = groupId (group _unit);

    // Create the marker
    private _marker = [(getPosATL _unit), _unit, "markChatter" + (str (random 10)), _color, "ICON", _type, _who + " : " + _sentenceText, "", [0.5, 0.5]] call FUNC(mark);

    // Make the marker fade out after a delay
    [_marker] spawn {
        params ["_marker"];

        private _alpha = 1;

        [{}, 28] call CBA_fnc_waitAndExecute;

        for "_i" from 1 to 20 do {
            _alpha = _alpha - 0.05;
            _marker setMarkerAlpha _alpha;

            [{}, 0.1] call CBA_fnc_waitAndExecute;
        };

        deleteMarker _marker;
    };
};
