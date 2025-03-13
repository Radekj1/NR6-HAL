#include "..\script_component.hpp"
// Originally from HAC_fnc.sqf (RYD_Flares)

/**
 * @description Makes a group periodically fire flares during night time
 * @param {Group} Group that will deploy flares
 * @param {Boolean} Whether flares are enabled
 * @param {Array} Artillery groups that can provide illumination support
 * @param {Number} Available artillery shells
 * @param {Object} Leader who can call artillery support
 * @return {Nothing}
 */
params ["_group", "_flareEnabled", "_artilleryGroups", "_availableShells", "_leaderUnit"];

// Exit early if the _group parameter is invalid
if (isNull _group) exitWith {};

private _unitLeader = leader _group;

// Flag to track if the group is currently in a defensive stance
private _isDefending = true;

// Main loop - runs until the group is no longer defending
while {_isDefending} do {
    // Wait random time between flare deployments
    sleep (60 + (random 60));

    // If flares are enabled, check if it's night time
    if (_flareEnabled) then {
        if ([] call FUNC(isNight)) then {
            if (alive _unitLeader) then {
                // Try to find nearby enemy
                private _nearestEnemy = _unitLeader findNearestEnemy _unitLeader;

                if (!isNull _nearestEnemy) then {
                    // Only deploy flares for enemies within 400m
                    if ((_nearestEnemy distance (vehicle _unitLeader)) <= 400) then {
                        private _enemyPos = getPosASL _nearestEnemy;
                        private _callForFireSucceeded = false;

                        // Try to call for artillery illumination if available
                        if ((_availableShells > 0) && ((random 100) > 50)) then {
                            // Request illumination from leader
                            if (!isPlayer _unitLeader) then {
                                if ((random 100) < (missionNamespace getVariable ["RydxHQ_AIChatDensity", 30])) then {
                                    [_unitLeader, (missionNamespace getVariable ["RydxHQ_AIC_IllumReq", ["Radio_Report_IllumRequest"]]), "IllumReq"] call FUNC(AIChatter);
                                };
                            };

                            // Try to call for illumination
                            _callForFireSucceeded = ([_enemyPos, _artilleryGroups, "ILLUM", 1, _unitLeader] call FUNC(artyMission)) select 0;

                            // Report success or failure
                            if (_callForFireSucceeded) then {
                                if ((random 100) < (missionNamespace getVariable ["RydxHQ_AIChatDensity", 30])) then {
                                    [_leaderUnit, (missionNamespace getVariable ["RydxHQ_AIC_ArtAss", ["Radio_Report_IllumSent"]]), "ArtAss"] call FUNC(AIChatter);
                                };
                            } else {
                                if ((random 100) < (missionNamespace getVariable ["RydxHQ_AIChatDensity", 30])) then {
                                    [_leaderUnit, (missionNamespace getVariable ["RydxHQ_AIC_ArtDen", ["Radio_Report_IllumDenied"]]), "ArtDen"] call FUNC(AIChatter);
                                };
                            };
                        };

                        // If artillery call failed, try to use infantry flares
                        if (!_callForFireSucceeded && !isPlayer _unitLeader) then {
                            private _flareCount = 0;

                            {
                                private _unit = _x;

                                // Only use infantry units not in vehicles
                                if ((isNull objectParent _unit) && !isPlayer _unit) then {
                                    // Search for flare launchers
                                    private _muzzles = getArray (configFile >> "CfgWeapons" >> (primaryWeapon _unit) >> "muzzles");
                                    _muzzles append getArray (configFile >> "CfgWeapons" >> (secondaryWeapon _unit) >> "muzzles");

                                    {
                                        private _muzzleName = "";
                                        private _magazineName = "";

                                        // Check if this unit has flare launchers
                                        if ((_x select 0) in _muzzles) then {
                                            _muzzleName = _x select 0;
                                        };

                                        // Find compatible flare magazines
                                        if (_muzzleName != "") then {
                                            private _magazines = [];
                                            private _magsWithAmmo = magazinesAmmoFull _unit;

                                            {
                                                _magazines pushBack (_x select 0);
                                            } forEach _magsWithAmmo;

                                            {
                                                if (_x in _magazines) exitWith {
                                                    _magazineName = _x;
                                                };
                                            } forEach (_x select 1);
                                        };

                                        // If unit has proper equipment, launch a flare
                                        if (_muzzleName != "" && _magazineName != "") exitWith {
                                            [_unit, _nearestEnemy, _muzzleName, _magazineName] spawn {
                                                params ["_unit", "_enemy", "_muzzleName", "_magazineName"];

                                                // Calculate optimal flare position
                                                private _unitPos = getPosATL _unit;
                                                private _enemyPos = getPosATL _enemy;
                                                private _distance = _unit distance _enemy;
                                                private _height = _distance * (0.25 + (random 0.25));

                                                // Center flare between unit and enemy, with randomization
                                                private _flarePos = [
                                                    ((_unitPos select 0) + (_enemyPos select 0))/2,
                                                    ((_unitPos select 1) + (_enemyPos select 1))/2,
                                                    0
                                                ];

                                                _flarePos = [_flarePos, 20 * (_distance/200)] call FUNC(randomAround);
                                                _flarePos set [2, _height];

                                                // Create an invisible target for aiming
                                                private _decoy = [_flarePos] call FUNC(createDecoy);

                                                // Aim and fire
                                                _unit doWatch _decoy;
                                                sleep 0.1;

                                                _unit doTarget _decoy;
                                                sleep 5;

                                                _unit selectWeapon _muzzleName;
                                                sleep 1;

                                                _unit fire [_muzzleName, _muzzleName, _magazineName];
                                                sleep 0.1;

                                                // Clean up
                                                _unit doWatch objNull;
                                                deleteVehicle _decoy;
                                            };

                                            _flareCount = _flareCount + 1;
                                        };

                                        // Stop after launching one flare
                                        if (_flareCount > 0) exitWith {};
                                    } forEach (missionNamespace getVariable ["RydxHQ_FlareMuzzles", []]);
                                };

                                // Stop after launching one flare
                                if (_flareCount > 0) exitWith {};
                            } forEach (units _group);
                        };
                    };
                };
            };
        };
    };

    // Update the defending status from the group variable
    _isDefending = _group getVariable ["Defending", false];

    // Check for group/leader death conditions
    if (isNull _group) then {_isDefending = false};
    if (!alive _unitLeader) then {_isDefending = false};
};
