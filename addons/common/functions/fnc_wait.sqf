#include "..\script_component.hpp"
// Originally from HAC_fnc.sqf (RYD_Wait)

/**
 * @description Makes a group wait until specific conditions are met
 * @param {Group} Group that will wait
 * @param {Number} Wait interval in seconds
 * @param {Boolean} Whether to track movement speed
 * @param {Boolean} Whether to check for enemy presence
 * @param {Number} Tolerance value for timeout 
 * @param {Array} Additional data array [air groups, enemy groups, HQ]
 * @param {Boolean} Whether to check cargo status
 * @param {Boolean} [Optional] Whether units should be inside vehicles
 * @param {Boolean} [Optional] Whether units should be outside vehicles
 * @param {Boolean} [Optional] Whether own vehicles are used
 * @param {Boolean} [Optional] Whether to check busy status
 * @param {Boolean} [Optional] Whether to check waypoints
 * @param {Boolean} [Optional] Whether to check fired count
 * @param {Array} [Optional] Specific units to check
 * @return {Array} Results array [timer, alive status, enemy detected, busy, break status]
 */
params [
    "_group",
    "_interval",
    "_checkSpeed",
    "_checkEnemy",
    "_tolerance",
    "_additionalData",
    "_checkCargo",
    ["_shouldBeInside", true],
    ["_shouldBeOutside", true],
    ["_useOwnVehicles", false],
    ["_checkBusy", false],
    ["_checkWaypoints", true],
    ["_checkFired", false],
    ["_specificUnits", []]
];

// Extract integer and fractional parts of interval
private _integerInterval = floor _interval;
private _checkAmmo = false;

// Determine if we're also checking ammo based on decimal part of interval
if (_interval != _integerInterval) then {
    _checkAmmo = true;
};

// Initialize variables
private _timer = 0;
private _alive = false;
private _enemy = false;
private _enemyPresent = false;
private _busy = false;
private _isInside = false;
private _isOutside = false;
private _breakFlag = false;

// Get unit leader and vehicles
private _unitLeader = leader _group;
private _assignedVehicle = vehicle _unitLeader;
private _driverUnit = _unitLeader;
private _driverGroup = _group;

// Process additional data if provided
private _airGroups = [];
private _enemyGroups = [];
private _HQ = grpNull;

if (count _additionalData > 0) then {
    _airGroups = _additionalData select 0;
    _enemyGroups = _additionalData select 1;
    
    if (count _additionalData > 2) then {
        _HQ = _additionalData select 2;
        _enemyGroups = _HQ getVariable ["RydHQ_KnEnemiesG", []];
    };
};

// Main wait loop
waitUntil {
    sleep _integerInterval;
    
    // If player is involved, adjust behavior
    private _isPlayerInvolved = isPlayer (leader _group);
    
    // Check various conditions
    _alive = true;
    switch (true) do {
        case (isNull _group): {_alive = false};
        case ({alive _x} count (units _group) < 1): {_alive = false};
        case (isNull _assignedVehicle): {_alive = false};
        case (!alive _assignedVehicle): {_alive = false};
        case (_group getVariable ["RydHQ_MIA", false]): {
            _alive = false;
            _group setVariable ["RydHQ_MIA", nil];
        };
        case (_group getVariable ["Break", false]): {
            _breakFlag = true;
            _alive = false;
        };
    };
    
    if (_alive) then {
        // Check cargo status if needed
        if (_checkCargo) then {
            _assignedVehicle = assignedVehicle _unitLeader;
            _driverUnit = assignedDriver _assignedVehicle;
            
            if (!_useOwnVehicles) then {
                _driverGroup = group _driverUnit;
            };
            
            // Wait for vehicle assignment if necessary
            if (isNull _assignedVehicle) then {
                waitUntil {sleep 0.5; !isNull (assignedVehicle _unitLeader)};
                
                _assignedVehicle = assignedVehicle _unitLeader;
                _driverUnit = assignedDriver _assignedVehicle;
                if (!_useOwnVehicles) then {_driverGroup = group _driverUnit};
            };
        };
        
        // Check for nearby enemies if required
        if (_checkEnemy > 0) then {
            if !(_driverGroup in _airGroups && !_useOwnVehicles) then {
                _enemy = [_assignedVehicle, _enemyGroups, _checkEnemy] call FUNC(closeEnemy);
            };
        } else {
            if !(_driverGroup in _airGroups) then {
                _enemyPresent = [_assignedVehicle, _enemyGroups, 
                    missionNamespace getVariable ["RydxHQ_DisembarkRange", 500]] call FUNC(closeEnemy);
            };
        };
        
        // Handle infantry get-in behavior
        if (_group getVariable ["InfGetinCheck" + (str _group), false] && 
            _driverGroup == _group && 
            !isNull (assignedVehicle _unitLeader)) then {
            
            _assignedVehicle = assignedVehicle _unitLeader;
            _driverUnit = assignedDriver _assignedVehicle;
            
            // Check for nearby enemies
            if (!_enemy && !_enemyPresent && !(_driverGroup in _airGroups)) then {
                private _closestEnemy = objNull;
                _closestEnemy = (vehicle (leader _group)) findNearestEnemy (vehicle (leader _group));
                
                if (!isNull _closestEnemy) then {
                    if (((vehicle (leader _group)) distance _closestEnemy) < 
                        missionNamespace getVariable ["RydxHQ_DisembarkRange", 500]) then {
                        _enemyPresent = true;
                        if (_checkEnemy > 0) then {_enemy = true;};
                    };
                };
            };
            
            // Adjust vehicle behavior based on enemy presence
            if (_enemy || _enemyPresent) then {
                if (_driverGroup == _group && !isNull _assignedVehicle) then {
                    _assignedVehicle setUnloadInCombat [true, false];
                };
            } else {
                if (_driverGroup == _group && !isNull _assignedVehicle) then {
                    _assignedVehicle setUnloadInCombat [false, false];
                    private _waitingForCargo = false;
                    
                    {
                        // Handle infantry mounting behavior
                        if (!(_x == (assignedCommander _assignedVehicle) || 
                              _x == (assignedDriver _assignedVehicle) || 
                              _x == (assignedGunner _assignedVehicle)) && 
                            !((vehicle _x) == _assignedVehicle)) then {
                            if (_x == (leader _group)) then {_x assignAsCommander _assignedVehicle};
                            _x assignAsCargo _assignedVehicle;
                        };
                        
                        if ((assignedVehicle _x == _assignedVehicle) && (_x == (vehicle _x))) then {
                            [_x] orderGetIn true;
                            doStop _assignedVehicle;
                            _assignedVehicle setVariable ["WaitForCargo" + (str _assignedVehicle), true];
                            _waitingForCargo = true;
                        };
                    } forEach (units _group);
                    
                    // Clear waiting flag if all cargo is aboard
                    if ((_assignedVehicle getVariable ["WaitForCargo" + (str _assignedVehicle), false]) && !_waitingForCargo) then {
                        _assignedVehicle setVariable ["WaitForCargo" + (str _assignedVehicle), false];
                    };
                    
                    // Move vehicle slightly if stuck
                    if ((abs (speed _assignedVehicle) < 0.05) && 
                        !_waitingForCargo && 
                        (count (waypoints _group) >= 1) && 
                        ((time - (_assignedVehicle getVariable ["LastMoveOR", 0])) > 10)) then {
                        _assignedVehicle doMove [((position _assignedVehicle) select 0) + 5, 
                                                ((position _assignedVehicle) select 1) + 5, 
                                                (position _assignedVehicle) select 2];
                        _assignedVehicle setVariable ["LastMoveOR", time];
                    };
                };
            };
        };
        
        // Check speed factor if enabled
        if (_checkSpeed) then {
            if (!missionNamespace getVariable ["RydxHQ_SynchroAttack", false]) then {
                if (abs (speed (vehicle (leader _driverGroup))) < 0.05) then {
                    _timer = _timer + 1;
                };
            } else {
                private _vehicleType = typeOf _assignedVehicle;
                private _precisionRadius = getNumber (configFile >> "CfgVehicles" >> _vehicleType >> "precision");
                private _currentWaypointPos = waypointPosition [_group, (currentWaypoint _group)];
                
                if ((abs (speed (vehicle (leader _driverGroup))) < 0.05) && 
                    ((_currentWaypointPos distance _assignedVehicle) >= _precisionRadius)) then {
                    _timer = _timer + 1;
                };
            };
        };
        
        // Check for unit positions relative to vehicles if required
        private _unitsToCheck = units _group;
        if (count _specificUnits > 0) then {_unitsToCheck = _specificUnits};
        
        if (!_shouldBeInside) then {
            {
                if (!(_x in _assignedVehicle)) exitWith {_isInside = false};
                _isInside = true;
            } forEach _unitsToCheck;
            
            _timer = _timer + 1;
        };
        
        if (!_shouldBeOutside) then {
            {
                if (_x in _assignedVehicle) exitWith {_isOutside = false};
                _isOutside = true;
            } forEach _unitsToCheck;
            
            _timer = _timer + 1;
        };
        
        // Check cargo status for special conditions
        if (_checkCargo) then {
            if (_useOwnVehicles) then {
                _alive = false;
                if (!isNull _assignedVehicle) then {_alive = true};
            };
        };
        
        // Check busy status if required
        if (_checkBusy) then {
            _busy = _group getVariable ("Busy" + (str _group));
            if (isNil "_busy") then {_busy = false};
        };
        
        // Handle boxing and ammo replenishment
        private _isForBoxing = _group getVariable "forBoxing";
        
        if (_checkAmmo && !isNil "_isForBoxing") then {
            [_group, (currentWaypoint _group)] setWaypointType "HOLD";
            [_group, (currentWaypoint _group)] setWaypointPosition [_isForBoxing, 10];
            _isForBoxing = nil;
            _group setVariable ["ForBoxing", nil];
        };
        
        private _boxedAt = _group getVariable "isBoxed";
        
        if (_checkAmmo && !isNil "_boxedAt") then {
            _boxedAt = getPosATL _boxedAt;
            _boxedAt = [_boxedAt, 20] call FUNC(randomAround);
            private _wp = [_group, [_boxedAt select 0, _boxedAt select 1], "MOVE", "AWARE", "GREEN", "FULL", 
                ["true", "deletewaypoint [(group this), 0]"]] call FUNC(WPadd);
            _boxedAt = nil;
            _group setVariable ["isBoxed", nil];
        };
        
        // Check for unit firing if enabled
        private _fireCount = (leader _group) getVariable "FireCount";
        if (isNil "_fireCount") then {_fireCount = 0};
        
        if (_checkFired && _fireCount >= 2 && !_isPlayerInvolved) then {
            _timer = _tolerance + _integerInterval;
            (leader _group) setVariable ["FireCount", nil];
        };
        
        // Check for waiting targets and objectives
        if (!isNil {_group getVariable "RydHQ_WaitingTarget"}) then {
            private _waitingTarget = _group getVariable "RydHQ_WaitingTarget";
            if ((isNull _waitingTarget) || !alive _waitingTarget) then {
                [_group] call FUNC(deleteWaypoint);
                _group setVariable ["RydHQ_WaitingTarget", nil];
                _timer = _tolerance + 10;
            } else {
                private _frontArea = _HQ getVariable ["RydHQ_Front", locationNull];
                if (!isNull _frontArea) then {
                    if !((getPosATL _waitingTarget) in _frontArea) then {
                        [_group] call FUNC(deleteWaypoint);
                        _group setVariable ["RydHQ_WaitingTarget", nil];
                        _timer = _tolerance + 10;
                    };
                };
            };
        };
        
        if (!isNil {_group getVariable "RydHQ_WaitingObjective"}) then {
            private _objective = (_group getVariable "RydHQ_WaitingObjective") select 1;
            private _objectiveHQ = (_group getVariable "RydHQ_WaitingObjective") select 0;
            
            if ((isNull _objective) || (_objective in (_objectiveHQ getVariable ["RydHQ_Taken", []]))) then {
                [_group] call FUNC(deleteWaypoint);
                _group setVariable ["RydHQ_WaitingObjective", nil];
            };
        };
    };
    
    // Check for various exit conditions
    ((((count (waypoints _driverGroup)) < (_checkWaypoints ? (_tolerance == floor _tolerance) ? 1 : 2 : 999)) && _checkWaypoints) || 
     ((_timer > _tolerance) && !_isPlayerInvolved) || 
     ((_enemy) && !_isPlayerInvolved) || 
     (_breakFlag) || 
     !_alive || 
     _isInside || 
     _isOutside || 
     _busy)
};

// Clean up
if (!isNull _assignedVehicle) then {
    _assignedVehicle setVariable ["WaitForCargo" + (str _assignedVehicle), false];
};

// Clear waiting target/objective variables
_group setVariable ["RydHQ_WaitingTarget", nil];
_group setVariable ["RydHQ_WaitingObjective", nil];

// Clear infantry get-in checking
if (_group getVariable ["InfGetinCheck" + (str _group), false]) then {
    _group setVariable ["InfGetinCheck" + (str _group), false];
    if (_driverGroup == _group) then {
        _assignedVehicle setUnloadInCombat [true, false];
    };
};

// Send AI chatter message about order denial if timed out
if (_timer > _tolerance) then {
    if ((random 100) < (missionNamespace getVariable ["RydxHQ_AIChatDensity", 30])) then {
        [(leader _group), (missionNamespace getVariable ["RydxHQ_AIC_OrdDen", ["Radio_Report_OrderRejected"]]), "OrdDen"] call FUNC(AIChatter);
    };
};

// Return results
[_timer, _alive, _enemy, _busy, _breakFlag] 