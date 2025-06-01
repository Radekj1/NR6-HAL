
if (isNil ("RydHQ_Included")) then {RydHQ_Included = []};
if (isNil ("RydHQB_Included")) then {RydHQB_Included = []};
if (isNil ("RydHQC_Included")) then {RydHQC_Included = []};
if (isNil ("RydHQD_Included")) then {RydHQD_Included = []};
if (isNil ("RydHQE_Included")) then {RydHQE_Included = []};
if (isNil ("RydHQF_Included")) then {RydHQF_Included = []};
if (isNil ("RydHQG_Included")) then {RydHQG_Included = []};
if (isNil ("RydHQH_Included")) then {RydHQH_Included = []};

SpawnRGroup = {

    private ["_grp","_vharr","_class","_crewGear","_unit","_SelGroup","_grpi","_selectedPos","_SpawnPos","_SpawnRadius","_side","_Pool","_Leaders","_RejoinPoint","_sentence","_ExtraArgs","_pylons"];

	_SpawnPos = _this select 0;
	_SpawnRadius = _this select 1;
	_side = _this select 2;
	_Pool = _this select 3;
	_Leaders = _this select 4;
    _RejoinPoint = _this select 5;
    _ExtraArgs = _this select 6;
    _SelGroup = (selectRandom _Pool);
    _selectedPos = selectRandom _SpawnPos;

    _grp = grpNull;
    if ((typeName (_SelGroup select 0)) isNotEqualTo "ARRAY") then {

       {_SelGroup set [_foreachindex,[_x,[],[],[]]]} foreach _SelGroup;
    
    };
    if ((typeName (_SelGroup select 0)) isEqualTo "ARRAY") then {

        _grp = createGroup _side;
        _selectedPos = ([_selectedPos,0,_SpawnRadius,10] call BIS_fnc_findSafePos);

        {
            _class = _x select 0;
            if (_class isKindOf "Man") then 
            {
               _unit = _grp createUnit [_class, ([_selectedPos,0,30,1] call BIS_fnc_findSafePos), [], 0, "NONE"];
			   [_unit] joinSilent _grp;
               if ((_x select 1) isNotEqualTo []) then {_unit setUnitLoadout (_x select 1)};
            } else 
            {
                _crewGear = _x select 1;
                _pylons = _x select 3;
                _vharr = [([_selectedPos,0,75,10] call BIS_fnc_findSafePos),0,_class,_grp] call BIS_fnc_spawnVehicle;
                private _vh = [];
                _vh = _vharr select 0;
                {((crew _vh) select _foreachindex) setUnitLoadout _x} foreach (_crewgear); 
                if ((isClass (configFile >> "CfgVehicles" >> _class >> "Components" >> "TransportPylonsComponent" >> "Pylons"))) then 
                    {
                        private _pylonPaths = (configProperties [configFile >> "CfgVehicles" >> _class >> "Components" >> "TransportPylonsComponent" >> "Pylons", "isClass _x"]) apply { getArray (_x >> "turret") };
                        {_vh removeWeaponGlobal getText (configFile >> "CfgMagazines" >> _x >> "pylonWeapon") };
                        {_vh setPylonLoadout [_forEachIndex + 1, _x, true, _pylonPaths select _forEachIndex] } forEach _pylons;
                        {((crew _vh) select _foreachindex) setUnitLoadout _x} foreach (_crewgear);
						[(crew _vh)] joinSilent _grp;                        
                    };    
            };
        } foreach _SelGroup;
    } else {

        _grp = [([_selectedPos,0,_SpawnRadius,10] call BIS_fnc_findSafePos),_side,_SelGroup] call BIS_fnc_spawnGroup;
		//[_grp] joinSilent _side; 
    }; 
        
    _grp deleteGroupWhenEmpty true;

    if not (isNil "_ExtraArgs") then {(leader _grp) call compile _ExtraArgs};
    
    if !(isNil "_RejoinPoint") then {_grp addWaypoint [_RejoinPoint,100]};

    {
        if (_side==(side _x)) then 
            {
            if (isNull _x) then {} else 
                {
                _sentence = (format ["%2 deployed at grid: %1",mapGridPosition _selectedPos,groupId _grp]);
            //    [_x,_sentence] remoteExecCall ["RYD_MP_Sidechat"];
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

};

NR6_GetUnit = {
	
	private ['_selType','_unit'];

	_selType = ((_this select 2) select 0);
	_leader = ((_this select 2) select 1);
	_logic = ((_this select 2) select 2);
	_side = ((_this select 2) select 3);
	_cost = ((_this select 2) select 4);
	_emptyS = ((_this select 2) select 5);
	_class = (_selType select 0); 
	
	_Objective = objNull;
	_Reinf = objNull;
	_objPos = getpos _logic;
	
	if ((_logic getVariable ['NR6Supplies',0]) <= 0) exitWith {('Supplies Available At Camp: ' + str (_logic getVariable ['NR6Supplies',0])) remoteExecCall ['hint',(_this select 1)]; };

	_nearObjs = [];
	_nearReinfs = [];

	_nearObjs = _objPos nearEntities ["NR6_HAL_Leader_SimpleObjective_Module", 300];
	_nearReinfs = _objPos nearEntities ["NR6_Reiforcements_Module", 300];

	if ((count _nearObjs) > 0) then {
		_nearObjs = [_nearObjs, [], {_objPos distance _x }, "ASCEND",{true}] call BIS_fnc_sortBy;
		_Objective = _nearObjs select 0;
	};

	if ((count _nearReinfs) > 0) then {
		_nearReinfs = [_nearReinfs, [], {_objPos distance _x }, "ASCEND",{true}] call BIS_fnc_sortBy;
		_Reinf = _nearReinfs select 0;
		_rTick = _Reinf getvariable ["_sidetick",0];
		_logic setVariable ['NR6Supplies',((_rTick)*(10))];	
	};


	if not (isNull _leader) then {if not (_Objective in ((group _leader) getvariable ["RydHQ_Taken",[]])) exitwith {('Objective Not Secured') remoteExecCall ['hint',(_this select 1)]; }};

	if ((_logic getVariable ['NR6Supplies',0]) <= 0) exitWith {('Supplies Available At Camp: ' + str (_logic getVariable ['NR6Supplies',0])) remoteExecCall ['hint',(_this select 1)]; };



	if (_class isKindOf "Man") then {
	
		_unit = (group (_this select 1))  createUnit [(_selType select 0),([getPosATL (_this select 1),0,100,5] call BIS_fnc_findSafePos),[],25,'NONE']; 
		if not ((_selType select 1) isEqualTo []) then {_unit setUnitLoadout (_selType select 1)}; 
		[_unit] join (group (_this select 1));

		(_logic setVariable ['NR6Supplies',(_logic getVariable ['NR6Supplies',0]) - (_cost)]);	
		('Supplies Available At Objective: ' + str (_logic getVariable ['NR6Supplies',0])) remoteExecCall ['hint',(_this select 1)]; 
	
	} else {
		if not (_emptyS) then {
			_crewGear = _selType select 1; 
			_vharr = [([getPosATL (_this select 1),0,100,10] call BIS_fnc_findSafePos),0,_class,createGroup (side (_this select 1))] call BIS_fnc_spawnVehicle; 
			if not ((_selType select 3) isEqualTo []) then {{_vharr setPylonLoadOut [(_forEachIndex + 1),_x]} foreach (_selType select 3)}; 
			{((_vharr select 1) select _foreachindex) setUnitLoadout _x} foreach _crewGear; 
			_vharr join (group (_this select 1));
			(_logic setVariable ['NR6Supplies',(_logic getVariable ['NR6Supplies',0]) - (_cost)]);	
			('Supplies Available At Objective: ' + str (_logic getVariable ['NR6Supplies',0])) remoteExecCall ['hint',(_this select 1)]; 
		} else {		
			_class createVehicle ([getPosATL (_this select 1),0,100,10] call BIS_fnc_findSafePos);
			(_logic setVariable ['NR6Supplies',(_logic getVariable ['NR6Supplies',0]) - (_cost)]);	
			('Supplies Available At Objective: ' + str (_logic getVariable ['NR6Supplies',0])) remoteExecCall ['hint',(_this select 1)]; 
		};
		
	};

	if not (isNull _Reinf) then {_Reinf setvariable ["_sidetick",((_logic getVariable ['NR6Supplies',0])*(0.1))]};
	
};

NR6_CheckSupplies = {
	_Objective = objNull;
	_Reinf = objNull;
	_objPos = getpos (_this select 2);
	_nearReinfs = _objPos nearEntities ["NR6_Reiforcements_Module", 300];


	if ((count _nearReinfs) > 0) then {
		_nearReinfs = [_nearReinfs, [], {_objPos distance _x }, "ASCEND",{true}] call BIS_fnc_sortBy;
		_Reinf = _nearReinfs select 0;
		_rTick = _Reinf getvariable ["_sidetick",0];
		(_this select 2) setVariable ['NR6Supplies',((_rTick)*(10))];	
	};
	
	('Supplies Available At Objective: ' + str ((_this select 2) getVariable ['NR6Supplies',0])) remoteExecCall ['hint',(_this select 1)]; 
	
};

NR6_DimsmissAllAI = {
	_sUnits = units (group (_this select 1));
	
	if not (({not (isPlayer _x)} count _sUnits) > 0) exitwith {};

	_nGroup = createGroup (side (_this select 1));

	{
		if not (isPlayer _x) then {
			[_x] join _nGroup;
		};

	} foreach _sUnits;
	
};

