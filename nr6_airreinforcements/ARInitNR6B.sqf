
if (isNil ("RydHQ_Included")) then {RydHQ_Included = []};
if (isNil ("RydHQB_Included")) then {RydHQB_Included = []};
if (isNil ("RydHQC_Included")) then {RydHQC_Included = []};
if (isNil ("RydHQD_Included")) then {RydHQD_Included = []};
if (isNil ("RydHQE_Included")) then {RydHQE_Included = []};
if (isNil ("RydHQF_Included")) then {RydHQF_Included = []};
if (isNil ("RydHQG_Included")) then {RydHQG_Included = []};
if (isNil ("RydHQH_Included")) then {RydHQH_Included = []};

SpawnARGroupB = {

    private ["_grp","_selectedPos","_VC","_selectedDir","_selectedAircraft"];
    params ["_GoodPads","_side","_GoodsideForces","_Leaders"];
	//_GoodPads = _this select 0;
	//_side = _this select 1;
	//_GoodsideForces = _this select 2;
	//_Leaders = _this select 3;

    _selectedPad = selectRandom _GoodPads;
    _selectedAircraft = selectRandom _GoodsideForces;

    _selectedPos = (getposATL _selectedPad);
    _selectedDir = (getdir _selectedPad);


    _grp = createGroup _side;

    _VC = _selectedAircraft;
    _VC setposATL _selectedPos;
    _VC setdir _selectedDir;
    createVehicleCrew _VC;
    units (group _VC) joinSilent _grp;
    _grp addVehicle _VC;

    _VC setvariable ["Air_ReinforcementsNR6_Taken",true];

    _VC setVehicleLock "UNLOCKED";

    if (_VC isKindof "Plane") then {
        _VC FlyInHeight (random [100,1000,3500]);
    };

    _grp setBehaviour "SAFE";


    {        
        if (_side==(side _x)) then 
            {
            if (isNull _x) then {} else 
                {
            //    _x sideChat (format ["Air asset %2 deployed at grid: %1",mapGridPosition _selectedPos,groupId _grp]);
                if (_x==LeaderHQ) then {RydHQ_Included pushBack _grp; (group LeaderHQ) setvariable ["RydHQ_Included",RydHQ_Included];};
                if (_x==LeaderHQB) then {RydHQB_Included pushBack _grp; (group LeaderHQB) setvariable ["RydHQ_Included",RydHQB_Included];};
                if (_x==LeaderHQC) then {RydHQC_Included pushBack _grp; (group LeaderHQC) setvariable ["RydHQ_Included",RydHQC_Included];};
                if (_x==LeaderHQD) then {RydHQD_Included pushBack _grp; (group LeaderHQD) setvariable ["RydHQ_Included",RydHQD_Included];};
                if (_x==LeaderHQE) then {RydHQE_Included pushBack _grp; (group LeaderHQE) setvariable ["RydHQ_Included",RydHQE_Included];};
                if (_x==LeaderHQF) then {RydHQF_Included pushBack _grp; (group LeaderHQF) setvariable ["RydHQ_Included",RydHQF_Included];};
                if (_x==LeaderHQG) then {RydHQG_Included pushBack _grp; (group LeaderHQG) setvariable ["RydHQ_Included",RydHQG_Included];};
                if (_x==LeaderHQH) then {RydHQH_Included pushBack _grp; (group LeaderHQH) setvariable ["RydHQ_Included",RydHQH_Included];};
                }; 
            };

    } forEach _Leaders;

    _grp;

};