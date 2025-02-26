
if (isNil ("RydHQ_Included")) then {RydHQ_Included = []};
if (isNil ("RydHQB_Included")) then {RydHQB_Included = []};
if (isNil ("RydHQC_Included")) then {RydHQC_Included = []};
if (isNil ("RydHQD_Included")) then {RydHQD_Included = []};
if (isNil ("RydHQE_Included")) then {RydHQE_Included = []};
if (isNil ("RydHQF_Included")) then {RydHQF_Included = []};
if (isNil ("RydHQG_Included")) then {RydHQG_Included = []};
if (isNil ("RydHQH_Included")) then {RydHQH_Included = []};

SpawnARVicC = {

    private ["_grp","_selectedPos","_GoodPads","_side","_GoodsideForces","_Leaders","_VC","_selectedDir","_selectedAircraft"];

	_side = _this select 0;
	_selectedAircraft = _this select 1;
	_Leaders = _this select 2;


    _grp = createGroup _side;

    _VC = _selectedAircraft;
    createVehicleCrew _VC;
    units (group _VC) joinSilent _grp;
    [units _grp,false] remoteExecCall ["orderGetIn"];

    _VC setVariable ["Air_ReinforcementsNR6_Crew",_grp];
    _VC setVariable ["Air_ReinforcementsNR6_CrewSize",(count (units _grp))];

    _grp setVariable ["Unable",true];


    if (_VC isKindOf "Plane") then {
        _VC flyInHeight (random [100,1000,3500]);
    };

    _grp setBehaviour "SAFE";


    {        
        if (_side==(side _x)) then 
            {
            if (isNull _x) then {} else 
                {
            //    _x sideChat (format ["Air asset %2 deployed at grid: %1",mapGridPosition _selectedPos,groupId _grp]);
                if (_x==LeaderHQ) then {RydHQ_Included pushBack _grp; (group LeaderHQ) setVariable ["RydHQ_Included",RydHQ_Included];};
                if (_x==LeaderHQB) then {RydHQB_Included pushBack _grp; (group LeaderHQB) setVariable ["RydHQ_Included",RydHQB_Included];};
                if (_x==LeaderHQC) then {RydHQC_Included pushBack _grp; (group LeaderHQC) setVariable ["RydHQ_Included",RydHQC_Included];};
                if (_x==LeaderHQD) then {RydHQD_Included pushBack _grp; (group LeaderHQD) setVariable ["RydHQ_Included",RydHQD_Included];};
                if (_x==LeaderHQE) then {RydHQE_Included pushBack _grp; (group LeaderHQE) setVariable ["RydHQ_Included",RydHQE_Included];};
                if (_x==LeaderHQF) then {RydHQF_Included pushBack _grp; (group LeaderHQF) setVariable ["RydHQ_Included",RydHQF_Included];};
                if (_x==LeaderHQG) then {RydHQG_Included pushBack _grp; (group LeaderHQG) setVariable ["RydHQ_Included",RydHQG_Included];};
                if (_x==LeaderHQH) then {RydHQH_Included pushBack _grp; (group LeaderHQH) setVariable ["RydHQ_Included",RydHQH_Included];};
                }; 
            };

    } forEach _Leaders;

    _grp;

};

SpawnARGroupC = {

    private ["_grp","_selectedPos","_GoodPads","_side","_GoodsideForces","_Leaders","_VC","_selectedDir","_selectedAircraft"];

	_side = _this select 0;
	_GoodsideForces = _this select 1;
	_Leaders = _this select 2;

    _selectedAircraft = selectRandom _GoodsideForces;

    _grp = _selectedAircraft getVariable ["Air_ReinforcementsNR6_Crew",grpNull];

    _selectedAircraft setVariable ["Air_ReinforcementsNR6_Taken",true];

    [units _grp,true] remoteExecCall ["orderGetIn"];
    _grp setVariable ["Unable",false];

//  _grp setBehaviour "AWARE";

    sleep 15;

    _selectedAircraft;

};