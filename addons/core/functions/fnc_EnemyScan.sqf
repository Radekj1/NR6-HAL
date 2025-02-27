#include "..\script_component.hpp"

/**
 * @description Scans for enemies near friendly groups and adjusts their behavior accordingly
 * @param {Object} HQ The headquarters object that has references to all friendly/enemy groups
 * @return {Nothing} None
 */
params ["_HQ"];

// Cache frequently used variables to avoid repeated lookups
private _friendlyGroups = _HQ getVariable ["RydHQ_Friends", []];
private _enemyGroups = _HQ getVariable ["RydHQ_KnEnemiesG", []];
private _isDebugEnabled = _HQ getVariable ["RydHQ_DebugII", false];
private _airGroups = _HQ getVariable ["RydHQ_AirG", []];
private _chatDensity = missionNamespace getVariable ["RydxHQ_AIChatDensity", 0];
private _isDynFormEnabled = _HQ getVariable ["RydHQ_DynForm", false];

// Exclude support, naval, artillery groups for performance
private _excludedGroups = (_HQ getVariable ["RydHQ_NavalG", []]) + 
                          (_HQ getVariable ["RydHQ_SupportG", []]) + 
                          (_HQ getVariable ["RydHQ_ArtG", []]);

// Calculate NCCargo groups minus crew infantry minus support
private _NCCargoMinusCrewInf = (_HQ getVariable ["RydHQ_NCCargoG", []]) - 
                             ((_HQ getVariable ["RydHQ_NCrewInfG", []]) - 
                             (_HQ getVariable ["RydHQ_SupportG", []]));

// Final list of combat units to process
private _combatUnitGroups = _friendlyGroups - (_excludedGroups + _NCCargoMinusCrewInf);

// Handle debug marker creation if enabled
if (_isDebugEnabled) then {
    {
        private _dangerValue = _x getVariable ["NearE", 0];
        private _marker = [(position (vehicle (leader _x))), _x, "markDanger", "ColorGreen", 
                        "ICON", "mil_dot", (str _dangerValue), ""] call FUNC(mark);
        _x setVariable ["RydHQ_MarkerES", true];
    } forEach _friendlyGroups;
    
    // Set up continuous debug marker updating only on first cycle
    if ((_HQ getVariable ["RydHQ_Cyclecount", 1]) == 1) then {
        [_HQ] spawn {
            params ["_HQ"];
            
            while {!isNull _HQ && {!(_HQ getVariable ["RydHQ_KIA", false])}} do {
                private _friendlyGroups = _HQ getVariable ["RydHQ_Friends", []];
                
                {
                    // Skip invalid groups
                    if (isNull _x || {!alive (leader _x)}) then {
                        deleteMarker ("MarkDanger" + (str _x));
                        continue;
                    };
                    
                    // Create or update marker
                    private _markerName = "MarkDanger" + (str _x);
                    private _dangerValue = _x getVariable ["NearE", 0];
                    
                    if !(_x getVariable ["RydHQ_MarkerES", false]) then {
                        private _marker = [(position (vehicle (leader _x))), _x, "markDanger", 
                                         "ColorGreen", "ICON", "mil_dot", (str _dangerValue), ""] call FUNC(mark);
                        _x setVariable ["RydHQ_MarkerES", true];
                    };
                    
                    // Update marker position and color based on danger level
                    _markerName setMarkerPos (position (vehicle (leader _x)));
                    
                    private _markerColor = "ColorGreen";
                    if (_dangerValue > 0.5) then {
                        _markerColor = "ColorRed";
                    } else {
                        if (_dangerValue > 0.1) then {
                            _markerColor = "ColorOrange";
                        };
                    };
                    
                    _markerName setMarkerColor _markerColor;
                    _markerName setMarkerText (str _dangerValue);
                } forEach _friendlyGroups;
                
                sleep 5;
            };
        };
    };
};

// Pre-calculate unit counts for performance
private _groupStrengthMap = createHashMap;
{
    if (!isNull _x && {alive (leader _x)}) then {
        _groupStrengthMap set [_x, count (units _x)];
    };
} forEach _combatUnitGroups;

// Process each combat group (excluding air units for formation changes)
{
    // Skip processing if the group is invalid
    if (isNull _x || {!alive (leader _x)}) then {continue};
    
    private _group = _x;
    private _groupLeader = leader _group;
    private _leaderVehicle = vehicle _groupLeader;
    private _baseStrength = _groupStrengthMap get _group;
    
    // Avoid unnecessary calculations if no enemy groups
    if (count _enemyGroups == 0) then {
        _group setVariable ["NearE", 0];
        continue;
    };
    
    // Calculate friendly force concentration within 500m
    private _totalFriendlyStrength = _baseStrength;
    private _leaderPos = getPosATL _leaderVehicle;
    
    // Add nearby friendly group strength with distance weighting
    {
        if (_x != _group && {!isNull _x} && {alive (leader _x)}) then {
            private _friendDistance = (vehicle (leader _x)) distance _leaderVehicle;
            if (_friendDistance < 500 && _friendDistance > 0) then {
                _totalFriendlyStrength = _totalFriendlyStrength + ((_groupStrengthMap get _x) / (_friendDistance/3));
            };
        };
    } forEach _combatUnitGroups;
    
    // Calculate danger value based on enemy proximity and strength
    private _dangerValue = 0;
    {
        if (!isNull _x && {alive (leader _x)}) then {
            private _enemyDistance = (vehicle (leader _x)) distance _leaderVehicle;
            
            // Only consider enemies within 1000m
            if (_enemyDistance < 1000) then {
                private _enemyStrength = count (units _x);
                
                // Formula weights enemies by square of their strength divided by our strength
                // and inversely proportional to distance
                _dangerValue = _dangerValue + ((_enemyStrength * _enemyStrength / _totalFriendlyStrength) / ((_enemyDistance+1)/3));
            };
        };
    } forEach _enemyGroups;
    
    // Store calculated danger value
    _group setVariable ["NearE", _dangerValue];
    
    // Send danger message to AI if appropriate
    if (_dangerValue > 0.15 && {!isPlayer _groupLeader} && {random 100 < _chatDensity}) then {
        [_groupLeader, (missionNamespace getVariable ["RydxHQ_AIC_InDanger", ["SentCombatDanger"]]), "InDanger"] call FUNC(AIChatter);
    };
    
    // Skip formation changes for air units
    if (_isDynFormEnabled && {!(_group in _airGroups)}) then {
        private _formationData = _group getVariable ["FormChanged", nil];
        
        if (_dangerValue > 0.005) then {
            // Save original formation if not already saved
            if (isNil "_formationData") then {
                _group setVariable ["FormChanged", [formation _group, behaviour _groupLeader, speedMode _group]];
            };
            
            // Adjust formation and behavior based on threat
            if ((behaviour _groupLeader) in ["CARELESS", "SAFE"]) then {
                _group setBehaviour "AWARE";
            };
            
            if ((speedMode _group) == "LIMITED") then {
                _group setSpeedMode "NORMAL";
            };
            
            if ((formation _group) != "WEDGE") then {
                _group setFormation "WEDGE";
            };
        } else {
            // Restore original formation if danger has passed
            if (!isNil "_formationData") then {
                private _originalFormation = _formationData select 0;
                private _originalBehavior = _formationData select 1;
                private _originalSpeed = _formationData select 2;
                
                if ((behaviour _groupLeader) != _originalBehavior) then {
                    _group setBehaviour _originalBehavior;
                };
                
                if ((speedMode _group) != _originalSpeed) then {
                    _group setSpeedMode _originalSpeed;
                };
                
                if ((formation _group) != _originalFormation) then {
                    _group setFormation _originalFormation;
                };
                
                _group setVariable ["FormChanged", nil];
            };
        };
    };
} forEach (_combatUnitGroups - _airGroups);

// Mark scan as complete
_HQ setVariable ["RydHQ_ES", true]; 