#include "..\script_component.hpp"
// Originally from HAC_fnc.sqf (RYD_Smoke)

/**
 * @description Makes a group deploy smoke towards an enemy position
 * @param {Group} Group that will deploy smoke
 * @param {Object} Enemy unit to target with smoke
 * @return {Nothing}
 */
params ["_group", "_enemyUnit"];

// Track to avoid duplicates
private _lastVehicle = objNull;
private _smokeCount = 0;

// Loop through all units in the group to find possible smoke deployers
{
    private _unit = _x;
    
    // Check infantry units first (not in vehicle)
    if ((vehicle _unit == _unit) && !(isPlayer _unit)) then {
        
        // Loop through predefined smoke muzzles (from global variable)
        {
            // Skip if we've already used enough smoke
            if (_smokeCount > 2) exitWith {};
            
            private _muzzleName = "";
            private _magazineName = "";
            
            // Check if unit has the current smoke muzzle
            private _muzzles = getArray (configFile >> "CfgWeapons" >> (primaryWeapon _unit) >> "muzzles");
            _muzzles append getArray (configFile >> "CfgWeapons" >> (secondaryWeapon _unit) >> "muzzles");
            _muzzles append getArray (configFile >> "CfgWeapons" >> "Throw" >> "muzzles");
            
            if ((_x select 0) in _muzzles) then {
                _muzzleName = _x select 0;
            };
            
            // If we found a valid muzzle, check if the unit has compatible smoke magazines
            if (_muzzleName != "") then {
                private _magazines = [];
                private _magsWithAmmo = magazinesAmmoFull _unit;
                
                {
                    _magazines pushBack (_x select 0);
                } forEach _magsWithAmmo;
                
                // Find compatible magazine for the muzzle
                {
                    if (_x in _magazines) exitWith {
                        _magazineName = _x;
                    };
                } forEach (_x select 1);
            };
            
            // If we found both muzzle and magazine, deploy smoke
            if (_muzzleName != "" && _magazineName != "") exitWith {
                // Create a decoy to use as a target for smoke placement
                private _firePosASL = getPosASL _unit;
                private _targetPosASL = getPosASL _enemyUnit;
                private _distance = _unit distance _enemyUnit;
                private _height = (_distance min 200) * (0.025 + (random 0.025));
                
                // Place smoke approximately between the unit and enemy
                private _smokePos = [
                    (((_firePosASL select 0) + (_targetPosASL select 0))/2),
                    (((_firePosASL select 1) + (_targetPosASL select 1))/2),
                    0
                ];
                
                // Add some randomness to avoid predictable patterns
                _smokePos = [_smokePos, 5 * (_distance/200)] call FUNC(randomAround);
                _smokePos set [2, _height];
                
                // Calculate 2D distance for wind effects
                private _distance2D = [(_smokePos select 0),(_smokePos select 1)] distance _firePosASL;
                
                // Create a decoy target for aiming
                private _decoy = [_smokePos] call FUNC(createDecoy);
                
                // Different handling for grenade launchers vs thrown smoke
                if (_muzzleName in ["EGLM", "GL_3GL_F"]) then {
                    // Handle grenade launcher smoke
                    [_unit, _smokePos, _decoy, _distance2D, _muzzleName, _magazineName] spawn {
                        params ["_unit", "_smokePos", "_decoy", "_distance2D", "_muzzleName", "_magazineName"];
                        
                        // Adjust for wind
                        _smokePos set [0, (_smokePos select 0) - ((wind select 0) * (sqrt _distance2D) * 0.25)];
                        _smokePos set [1, (_smokePos select 1) - ((wind select 1) * (sqrt _distance2D) * 0.25)];
                        
                        _decoy setPosATL _smokePos;
                        
                        // Aim at target
                        _unit doWatch _decoy;
                        sleep 0.1;
                        
                        _unit doTarget _decoy;
                        sleep 3;
                        
                        // Select and fire smoke
                        _unit selectWeapon _muzzleName;
                        sleep 1;
                        
                        _unit fire [_muzzleName, _muzzleName, _magazineName];
                        sleep 1;
                        
                        // Clean up
                        deleteVehicle _decoy;
                        _unit doWatch objNull;
                    };
                } else {
                    // Handle thrown smoke
                    [_unit, _smokePos, _decoy, _distance2D, _muzzleName, _magazineName] spawn {
                        params ["_unit", "_smokePos", "_decoy", "_distance2D", "_muzzleName", "_magazineName"];
                        
                        // Adjust for wind
                        _smokePos set [0, (_smokePos select 0) - ((wind select 0) * _distance2D * 0.25)];
                        _smokePos set [1, (_smokePos select 1) - ((wind select 1) * _distance2D * 0.25)];
                        
                        _decoy setPosATL _smokePos;
                        
                        // Aim and throw smoke
                        _unit doWatch _decoy;
                        sleep 1;
                        
                        _unit selectWeapon _muzzleName;
                        _unit fire [_muzzleName, _muzzleName, _magazineName];
                        
                        sleep 0.1;
                        
                        // Clean up
                        _unit doWatch objNull;
                        deleteVehicle _decoy;
                    };
                };
                
                _smokeCount = _smokeCount + 1;
            };
        } forEach (missionNamespace getVariable ["RydxHQ_SmokeMuzzles", []]);
    };
    
    // Check if unit is in a different vehicle than we've already processed
    if ((vehicle _x != _x) && (_lastVehicle != vehicle _x)) then {
        _lastVehicle = vehicle _x;
        
        // Fire smoke launcher from vehicle
        _lastVehicle selectWeapon "SmokeLauncher";
        _lastVehicle fire "SmokeLauncher";
        _smokeCount = _smokeCount + 1;
    };
    
    // Stop if we've used enough smoke
    if (_smokeCount > 2) exitWith {};
} forEach (units _group); 