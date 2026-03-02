if (!isServer) exitWith {};
private 
    [
    "_logic","_SyncedAssets","_PoolModules","_MainPool","_SyncedGroups","_SyncedEmpties","_ArrVar","_GUnits","_Vehicles"
    ];

_logic = _this select 0;
_Counter = _logic getvariable ["_Counter",false];
//Add synced objects CLASSNAME to the array.
{
    if (_Counter) then {
        switch (typeOf _logic) do {

            case "NR6_RHQ_SpecFor_Module": {if (isnil "RHQs_SpecFor") then {RHQs_SpecFor = []}; RHQs_SpecFor pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_Recon_Module": {if (isnil "RHQs_Recon") then {RHQs_Recon = []}; RHQs_Recon pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_FO_Module": {if (isnil "RHQs_FO") then {RHQs_FO = []}; RHQs_FO pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_Snipers_Module": {if (isnil "RHQs_Snipers") then {RHQs_Snipers = []}; RHQs_Snipers pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_ATInf_Module": {if (isnil "RHQs_ATInf") then {RHQs_ATInf = []}; RHQs_ATInf pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_AAInf_Module": {if (isnil "RHQs_AAInf") then {RHQs_AAInf = []}; RHQs_AAInf pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_Inf_Module": {if (isnil "RHQs_Inf") then {RHQs_Inf = []}; RHQs_Inf pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_HArmor_Module": {if (isnil "RHQs_HArmor") then {RHQs_HArmor = []}; RHQs_HArmor pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_MArmor_Module": {if (isnil "RHQs_MArmor") then {RHQs_MArmor = []}; RHQs_MArmor pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_LArmor_Module": {if (isnil "RHQs_LArmor") then {RHQs_LArmor = []}; RHQs_LArmor pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_LarmorAT_Module": {if (isnil "RHQs_LarmorAT") then {RHQs_LarmorAT = []}; RHQs_LarmorAT pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_Cars_Module": {if (isnil "RHQs_Cars") then {RHQs_Cars = []}; RHQs_Cars pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_Air_Module": {if (isnil "RHQs_Air") then {RHQs_Air = []}; RHQs_Air pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_NCAir_Module": {if (isnil "RHQs_NCAir") then {RHQs_NCAir = []}; RHQs_NCAir pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_BAir_Module": {if (isnil "RHQs_BAir") then {RHQs_BAir = []}; RHQs_BAir pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_RAir_Module": {if (isnil "RHQs_RAir") then {RHQs_RAir = []}; RHQs_RAir pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_Naval_Module": {if (isnil "RHQs_Naval") then {RHQs_Naval = []}; RHQs_Naval pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_Static_Module": {if (isnil "RHQs_Static") then {RHQs_Static = []}; RHQs_Static pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_StaticAA_Module": {if (isnil "RHQs_StaticAA") then {RHQs_StaticAA = []}; RHQs_StaticAA pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_StaticAT_Module": {if (isnil "RHQs_StaticAT") then {RHQs_StaticAT = []}; RHQs_StaticAT pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_Support_Module": {if (isnil "RHQs_Support") then {RHQs_Support = []}; RHQs_Support pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_Med_Module": {if (isnil "RHQs_Med") then {RHQs_Med = []}; RHQs_Med pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_Ammo_Module": {if (isnil "RHQs_Ammo") then {RHQs_Ammo = []}; RHQs_Ammo pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_Fuel_Module": {if (isnil "RHQs_Fuel") then {RHQs_Fuel = []}; RHQs_Fuel pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_Rep_Module": {if (isnil "RHQs_Rep") then {RHQs_Rep = []}; RHQs_Rep pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_Cargo_Module": {if (isnil "RHQs_Cargo") then {RHQs_Cargo = []}; RHQs_Cargo pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_NCCargo_Module": {if (isnil "RHQs_NCCargo") then {RHQs_NCCargo = []}; RHQs_NCCargo pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_Crew_Module": {if (isnil "RHQs_Crew") then {RHQs_Crew = []}; RHQs_Crew pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_Art_Module": {if (isnil "RHQs_Art") then {RHQs_Art = []}; RHQs_Art pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_RocketArty_Module": {if (isnil "RHQs_RocketArty") then {RHQs_RocketArty = []}; RHQs_RocketArty pushBackUnique (toLower (typeOf _x));};
            
            };
    } else {
        switch (typeOf _logic) do {

            case "NR6_RHQ_SpecFor_Module": {if (isnil "RHQ_SpecFor") then {RHQ_SpecFor = []}; RHQ_SpecFor pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_Recon_Module": {if (isnil "RHQ_Recon") then {RHQ_Recon = []}; RHQ_Recon pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_FO_Module": {if (isnil "RHQ_FO") then {RHQ_FO = []}; RHQ_FO pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_Snipers_Module": {if (isnil "RHQ_Snipers") then {RHQ_Snipers = []}; RHQ_Snipers pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_ATInf_Module": {if (isnil "RHQ_ATInf") then {RHQ_ATInf = []}; RHQ_ATInf pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_AAInf_Module": {if (isnil "RHQ_AAInf") then {RHQ_AAInf = []}; RHQ_AAInf pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_Inf_Module": {if (isnil "RHQ_Inf") then {RHQ_Inf = []}; RHQ_Inf pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_HArmor_Module": {if (isnil "RHQ_HArmor") then {RHQ_HArmor = []}; RHQ_HArmor pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_MArmor_Module": {if (isnil "RHQ_MArmor") then {RHQ_MArmor = []}; RHQ_MArmor pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_LArmor_Module": {if (isnil "RHQ_LArmor") then {RHQ_LArmor = []}; RHQ_LArmor pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_LarmorAT_Module": {if (isnil "RHQ_LarmorAT") then {RHQ_LarmorAT = []}; RHQ_LarmorAT pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_Cars_Module": {if (isnil "RHQ_Cars") then {RHQ_Cars = []}; RHQ_Cars pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_Air_Module": {if (isnil "RHQ_Air") then {RHQ_Air = []}; RHQ_Air pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_NCAir_Module": {if (isnil "RHQ_NCAir") then {RHQ_NCAir = []}; RHQ_NCAir pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_BAir_Module": {if (isnil "RHQ_BAir") then {RHQ_BAir = []}; RHQ_BAir pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_RAir_Module": {if (isnil "RHQ_RAir") then {RHQ_RAir = []}; RHQ_RAir pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_Naval_Module": {if (isnil "RHQ_Naval") then {RHQ_Naval = []}; RHQ_Naval pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_Static_Module": {if (isnil "RHQ_Static") then {RHQ_Static = []}; RHQ_Static pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_StaticAA_Module": {if (isnil "RHQ_StaticAA") then {RHQ_StaticAA = []}; RHQ_StaticAA pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_StaticAT_Module": {if (isnil "RHQ_StaticAT") then {RHQ_StaticAT = []}; RHQ_StaticAT pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_Support_Module": {if (isnil "RHQ_Support") then {RHQ_Support = []}; RHQ_Support pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_Med_Module": {if (isnil "RHQ_Med") then {RHQ_Med = []}; RHQ_Med pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_Ammo_Module": {if (isnil "RHQ_Ammo") then {RHQ_Ammo = []}; RHQ_Ammo pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_Fuel_Module": {if (isnil "RHQ_Fuel") then {RHQ_Fuel = []}; RHQ_Fuel pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_Rep_Module": {if (isnil "RHQ_Rep") then {RHQ_Rep = []}; RHQ_Rep pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_Cargo_Module": {if (isnil "RHQ_Cargo") then {RHQ_Cargo = []}; RHQ_Cargo pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_NCCargo_Module": {if (isnil "RHQ_NCCargo") then {RHQ_NCCargo = []}; RHQ_NCCargo pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_Crew_Module": {if (isnil "RHQ_Crew") then {RHQ_Crew = []}; RHQ_Crew pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_Art_Module": {if (isnil "RHQ_Art") then {RHQ_Art = []}; RHQ_Art pushBackUnique (toLower (typeOf _x));};
            case "NR6_RHQ_RocketArty_Module": {if (isnil "RHQ_RocketArty") then {RHQ_RocketArty = []}; RHQ_RocketArty pushBackUnique (toLower (typeOf _x));};
            
            };
    };
} foreach (synchronizedObjects _logic);