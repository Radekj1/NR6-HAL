#include "..\script_component.hpp"

/**
 * @description Calculates ammunition count ratio (current/max) for a group, focusing on damaging ammunition
 * @param {Group} Group to check ammunition ratio for
 * @param {Array} [Optional] Array of vehicle types to not check
 * @return {Number} Ammunition ratio (0-1)
 */
params ["_group", ["_excludedVehicles", []]];

// Track checked vehicles to avoid duplicates
private _checkedVehicles = [];
private _vehicles = [];

// Initialize counters
private _currentAmmo = 0;
private _maxAmmo = 0;

// Process all units in the group
{
    private _unit = _x;
    private _vehicle = vehicle _unit;
    
    // Add any vehicles to the tracking list
    if !(_vehicle isEqualTo _unit) then {
        _vehicles pushBackUnique _vehicle;
    };
    
    // Process the unit if we haven't already processed their vehicle
    if !(_unit in _checkedVehicles) then {
        _checkedVehicles pushBackUnique _unit;
        
        // Get magazine information
        private _turretMags = 0;
        
        // Try to get magazines from turret if it exists
        private _turretConfigPath = configFile >> "CfgVehicles" >> (typeOf _unit) >> "Turrets" >> "MainTurret";
        
        if (isClass _turretConfigPath) then {
            _turretMags = getArray (_turretConfigPath >> "magazines");
        } else {
            _turretMags = getArray (configFile >> "CfgVehicles" >> (typeOf _unit) >> "magazines");
        };
        
        // Count max capacity of damaging ammunition
        {
            if ((getNumber (configFile >> "CfgAmmo" >> (getText (configFile >> "CfgMagazines" >> _x >> "ammo")) >> "Hit")) > 0) then {
                _maxAmmo = _maxAmmo + getNumber (configFile >> "CfgMagazines" >> _x >> "count");
            };
        } forEach _turretMags;
        
        // Count currently loaded damaging ammunition
        {
            if ((getNumber (configFile >> "CfgAmmo" >> (getText (configFile >> "CfgMagazines" >> (_x select 0) >> "ammo")) >> "Hit")) > 0) then {
                _currentAmmo = _currentAmmo + (_x select 1);
            };
        } forEach (magazinesAmmo _unit);
    };
} forEach (units _group);

// Process vehicles separately to count their ammunition
{
    private _vehicle = _x;
    private _unitType = typeOf _vehicle;
    
    switch (true) do {
        // Only process excluded vehicles if they're explicitly listed
        case ((toLower _unitType) in _excludedVehicles): {
            // Get magazine array from config
            private _vehicleMags = getArray (configFile >> "CfgVehicles" >> _unitType >> "magazines");
            
            // Count max capacity
            {
                if ((getNumber (configFile >> "CfgAmmo" >> (getText (configFile >> "CfgMagazines" >> _x >> "ammo")) >> "Hit")) > 0) then {
                    _maxAmmo = _maxAmmo + getNumber (configFile >> "CfgMagazines" >> _x >> "count");
                };
            } forEach _vehicleMags;
            
            // Count backpack magazines if present
            private _backpack = getText (configFile >> "CfgVehicles" >> _unitType >> "backpack");
            
            if !(_backpack isEqualTo "") then {
                private _backpackMagsConfig = configFile >> "CfgVehicles" >> _backpack >> "TransportMagazines";
                
                for "_i" from 0 to (count _backpackMagsConfig - 1) do {
                    private _magEntry = _backpackMagsConfig select _i;
                    private _magType = getText (_magEntry >> "magazine");
                    
                    if ((getNumber (configFile >> "CfgAmmo" >> (getText (configFile >> "CfgMagazines" >> _magType >> "ammo")) >> "Hit")) > 0) then {
                        private _magCount = getNumber (_magEntry >> "count");
                        private _magSize = getNumber (configFile >> "CfgMagazines" >> _magType >> "count");
                        _maxAmmo = _maxAmmo + (_magSize * _magCount);
                    };
                };
            };
            
            // Count current ammo
            {
                if ((getNumber (configFile >> "CfgAmmo" >> (getText (configFile >> "CfgMagazines" >> (_x select 0) >> "ammo")) >> "Hit")) > 0) then {
                    _currentAmmo = _currentAmmo + (_x select 1);
                };
            } forEach (magazinesAmmoFull _vehicle);
        };
        
        // Process normal vehicles
        case !(_vehicle in _checkedVehicles): {
            _checkedVehicles pushBackUnique _vehicle;
            
            // Get turret magazines
            private _turretMags = 0;
            private _turretConfigPath = configFile >> "CfgVehicles" >> _unitType >> "Turrets" >> "MainTurret";
            
            if (isClass _turretConfigPath) then {
                _turretMags = getArray (_turretConfigPath >> "magazines");
            } else {
                _turretMags = getArray (configFile >> "CfgVehicles" >> _unitType >> "magazines");
            };
            
            // Count max capacity
            {
                if ((getNumber (configFile >> "CfgAmmo" >> (getText (configFile >> "CfgMagazines" >> _x >> "ammo")) >> "Hit")) > 0) then {
                    _maxAmmo = _maxAmmo + getNumber (configFile >> "CfgMagazines" >> _x >> "count");
                };
            } forEach _turretMags;
            
            // Count current ammo
            {
                if ((getNumber (configFile >> "CfgAmmo" >> (getText (configFile >> "CfgMagazines" >> (_x select 0) >> "ammo")) >> "Hit")) > 0) then {
                    _currentAmmo = _currentAmmo + (_x select 1);
                };
            } forEach (magazinesAmmo _vehicle);
        };
    };
} forEach _vehicles;

// Return ratio (avoid division by zero)
(_currentAmmo / (_maxAmmo max 1)) 