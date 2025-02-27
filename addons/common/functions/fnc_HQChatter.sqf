#include "..\script_component.hpp"
// Originally from HAC_fnc.sqf (RYD_HQChatter)

/**
 * @description Sends a text message from HQ to the player with location information
 * @param {Group} Group that the message refers to
 * @param {String} Sentence key to use for the message
 * @param {Array} Position where the event is occurring
 * @param {Group} HQ group that's sending the message
 * @return {Nothing}
 */
params ["_group", "_sentenceKey", "_position", "_HQ"];

// Get the unit that will communicate as HQ
private _unit = leader _group;
private _commander = leader _HQ;

// Get the actual sentence text from config
private _sentenceType = missionNamespace getVariable ["RydxHQ_AIChat_Type", "NONE"];
if (_sentenceType != "NONE") then {
    switch (_sentenceType) do {
        case "SILENT_M": {_sentenceKey = "HAC_SILENTM_" + _sentenceKey};
        case "40K_IMPERIUM": {_sentenceKey = "HAC_40KImp_" + _sentenceKey};
    };
};

private _sentence = getText (configFile >> "CfgRadio" >> _sentenceKey >> "title");

// Format the unit identification - use group ID
private _unitID = groupId _group;

// Build a detailed location description
private _locationDescription = "";

// Check for nearby map markers/locations
private _nearestLocations = nearestLocations [_position, ["Hill", "NameCityCapital", "NameCity", "NameVillage", "NameLocal", "Strategic", "StrongpointArea"], 600];
if (count _nearestLocations > 0) then {
    _locationDescription = text (_nearestLocations select 0) + ", ";
};

// Add grid reference to the location
_locationDescription = _locationDescription + format ["Grid: %1", mapGridPosition _position];

// Build the full message with sender, content, and location
private _message = format ["%1. %2 at %3.", _unitID, _sentence, _locationDescription];

// Send the message based on multiplayer status
if (isMultiplayer) then {
    [_commander, _message] remoteExecCall ["sideChat"];
} else {
    _commander sideChat _message;
}; 