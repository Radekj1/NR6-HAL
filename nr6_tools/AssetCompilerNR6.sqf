private 
    [
    "_logic","_SyncedAssets","_PoolModules","_MainPool","_SyncedGroups","_SyncedEmpties","_ArrVar","_GUnits","_Vehicles","_crewGear","_crewClasses","_pylons","_civVeh","_civMen","_civFact"
    ];

_logic = _this select 0;

_SyncedAssets = [];
_PoolModules = [];
_MainPool = [];
_SyncedGroups = [];
_SyncedEmpties = [];
_civVeh = [];
_civMen = [];
_civFact = [];

{
    switch (typeOf _x) do {

        case "NR6_Spawn_Module": {_PoolModules pushBack _x};
        case "NR6_Reiforcements_Module": {_PoolModules pushBack _x};
        case "NR6_AirReinfA_Module": {_PoolModules pushBack _x};
        case "NR6_Site_Module": {_PoolModules pushBack _x};
        case "NR6_ALICE2_Module": {_PoolModules pushBack _x};
        case "NR6_ReqPoint_Module": {_PoolModules pushBack _x};
        default {_SyncedAssets pushBack _x; _x enableSimulationGlobal false; _x allowDamage false;};

        };

} forEach (synchronizedObjects _logic);

_ArrVar = _logic getVariable ["_ArrVar",""];

{

    if ((crew _x) isNotEqualTo []) then {_SyncedGroups pushBackUnique (group _x)} else {_SyncedEmpties pushBackUnique _x};

} forEach _SyncedAssets;

{
    _GUnits = [];
    _Vehicles = [];

    {
        if ((vehicle _x) == _x) then {_civMen pushBack (typeOf _x); _civFact pushBackUnique (faction _x); _GUnits pushBack [(typeOf _x),getUnitLoadout _x];} else {_Vehicles pushBackUnique (vehicle _x)};

    } forEach (units _x);

    {
        _crewGear = [];
        _crewClasses = [];
        _pylons = [];
        {_crewGear pushBack (getUnitLoadout _x)} forEach (crew _x);
        {_crewClasses pushBack (typeOf _x)} forEach (crew _x);
        _pylons = getPylonMagazines _x;

        _civFact pushBackUnique (faction _x);
        _civVeh pushBack (typeOf _x);
        _GUnits pushBack [(typeOf _x),_crewGear,_crewClasses,_pylons];

    } forEach _Vehicles;

    _MainPool pushBack _GUnits;

    {deleteVehicle _x} forEach (units _x);
    {deleteVehicle _x} forEach _Vehicles;
    deleteGroup _x;

} forEach _SyncedGroups;

{
    _pylons = [];
    _pylons = getPylonMagazines _x;

    _civFact pushBackUnique (faction _x);
    _civVeh pushBack (typeOf _x);
    _MainPool pushBack [[(typeOf _x),[],[],_pylons]];
    deleteVehicle _x;
    
} forEach _SyncedEmpties;


{
    _x setVariable ["_Pool",str _MainPool];
    _x setVariable ["_Faction","custom"];

    if ((typeOf _x) == "NR6_AirReinfA_Module") then {

        _ModPool = [];

        {
            {_ModPool pushBack _x} forEach _x
        } forEach _MainPool;

        _x setVariable ["_Pool",str _ModPool];

    };

    if ((typeOf _x) == "NR6_ALICE2_Module") then {

        _x setVariable ["townsFaction",str _civFact];
        _x setVariable ["manClasses",str _civMen];
        _x setVariable ["vehClasses",str _civVeh];

    };

} forEach _PoolModules;

if (_ArrVar isNotEqualTo "") then {call compile (_ArrVar + " = " + (str _MainPool))};
