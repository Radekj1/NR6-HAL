if (isNil ("RydHQ_Included")) then {RydHQ_Included = []};
if (isNil ("RydHQB_Included")) then {RydHQB_Included = []};
if (isNil ("RydHQC_Included")) then {RydHQC_Included = []};
if (isNil ("RydHQD_Included")) then {RydHQD_Included = []};
if (isNil ("RydHQE_Included")) then {RydHQE_Included = []};
if (isNil ("RydHQF_Included")) then {RydHQF_Included = []};
if (isNil ("RydHQG_Included")) then {RydHQG_Included = []};
if (isNil ("RydHQH_Included")) then {RydHQH_Included = []};

if (isNil ("RydHQ_NoDef")) then {RydHQ_NoDef = []};
if (isNil ("RydHQB_NoDef")) then {RydHQB_NoDef = []};
if (isNil ("RydHQC_NoDef")) then {RydHQC_NoDef = []};
if (isNil ("RydHQD_NoDef")) then {RydHQD_NoDef = []};
if (isNil ("RydHQE_NoDef")) then {RydHQE_NoDef = []};
if (isNil ("RydHQF_NoDef")) then {RydHQF_NoDef = []};
if (isNil ("RydHQG_NoDef")) then {RydHQG_NoDef = []};
if (isNil ("RydHQH_NoDef")) then {RydHQH_NoDef = []};

SpawnRGroupS = {

    private ["_grp","_SelGroup","_class","_vharr","_selectedPos","_crewGear","_SpawnRadius","_Side","_Pool","_SpawnRadius","_MinBuilding","_PatrolPercent","_Leaders"];

    _selectedPos = _this select 0;
    _SpawnRadius = _this select 1;
    _Side = _this select 2;
    _Pool = _this select 3;
    _SpawnRadius = _this select 4;
    _MinBuilding = _this select 5;
    _PatrolPercent = _this select 6;
    _Leaders = _this select 7; 
    _SelGroup = selectRandom _Pool;

    _grp = grpNull;

    if ((typeName _SelGroup) isEqualTo "ARRAY") then {

        if not ((typeName (_SelGroup select 0)) isEqualTo "ARRAY") then {

            {_SelGroup set [_foreachindex,[_x,[],[],[]]]} forEach _SelGroup;

        };

        _grp = createGroup _side;
        _selectedPos = ([_selectedPos,0,_SpawnRadius,10] call BIS_fnc_findSafePos);
        {
            _class = _x select 0;
            if (_class isKindOf "Man") then {
               _unit = _grp createUnit [_class, ([_selectedPos,0,30,1] call BIS_fnc_findSafePos), [], 0, "NONE"];
               if not ((_x select 1) isEqualTo []) then {_unit setUnitLoadout (_x select 1)};

            } else {
                _crewGear = _x select 1;
                _vharr = [([_selectedPos,0,75,10] call BIS_fnc_findSafePos),0,_class,_grp] call BIS_fnc_spawnVehicle;
                if not ((_x select 3) isEqualTo []) then {{_vharr setPylonLoadout [(_forEachIndex + 1),_x]} forEach (_x select 3)};
                {((_vharr select 1) select _foreachindex) setUnitLoadout _x} forEach _crewGear;
            };
        } forEach _SelGroup;

    } else {

        _grp = [([_selectedPos,0,_SpawnRadius,10] call BIS_fnc_findSafePos),_side,_SelGroup] call BIS_fnc_spawnGroup;

    }; 
    
    _grp deleteGroupWhenEmpty true;
//    _grp setVariable ["zbe_cacheDisabled",true];
    _grp setVariable ["Unable",true];
    _grp setVariable ["Busy" + (str _grp),true];
    _grp setVariable ["Garrisoned" + (str _grp),true];
    [_grp,_SpawnPos,_SpawnRadius,_MinBuilding,_PatrolPercent] remoteExecCall ["NR6_fnc_CBA_Defend",(leader _grp)];

    {        
    if (isNull _x) then {} else 
        {
        if (_x==LeaderHQ) then {RydHQ_Included pushBack _grp;};
        if (_x==LeaderHQB) then {RydHQB_Included pushBack _grp;};
        if (_x==LeaderHQC) then {RydHQC_Included pushBack _grp;};
        if (_x==LeaderHQD) then {RydHQD_Included pushBack _grp;};
        if (_x==LeaderHQE) then {RydHQE_Included pushBack _grp;};
        if (_x==LeaderHQF) then {RydHQF_Included pushBack _grp;};
        if (_x==LeaderHQG) then {RydHQG_Included pushBack _grp;};
        if (_x==LeaderHQH) then {RydHQH_Included pushBack _grp;};

        if (_x==LeaderHQ) then {RydHQ_NoDef pushBack _grp;};
        if (_x==LeaderHQB) then {RydHQB_NoDef pushBack _grp;};
        if (_x==LeaderHQC) then {RydHQC_NoDef pushBack _grp;};
        if (_x==LeaderHQD) then {RydHQD_NoDef pushBack _grp;};
        if (_x==LeaderHQE) then {RydHQE_NoDef pushBack _grp;};
        if (_x==LeaderHQF) then {RydHQF_NoDef pushBack _grp;};
        if (_x==LeaderHQG) then {RydHQG_NoDef pushBack _grp;};
        if (_x==LeaderHQH) then {RydHQH_NoDef pushBack _grp;};
        }; 
            
    } forEach _Leaders;

};

/*
NR6SpawnCamp = {

};

NR6CampGuerPool = [

    [ //Temperate
        [ //camps
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "MortarCamp"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite1"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite2"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite3"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite4"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite5"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite6"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite7"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSiteHMG")
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "MortarCamp"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite1"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite2"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite3"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite4"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite5"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite6"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite7"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSiteHMG")
            ],
            [ //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "MortarCamp"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite1"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite2"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite3"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite4"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite5"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite6"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite7"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSiteHMG")
            ]
        ],
        [ //Field HQ
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FieldHQSmall" >> "FieldHQ_BLU_G_F")
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FieldHQMedium" >> "CargoHQ1_BLU_G_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FieldHQMedium" >> "CargoHQ2_BLU_G_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FieldHQMedium" >> "BunkerHQ1_BLU_G_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FieldHQMedium" >> "BunkerHQ2_BLU_G_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FieldHQMedium" >> "CargoHouseHQ1_BLU_G_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FieldHQMedium" >> "CargoHouseHQ2_BLU_G_F")
            ],
            [ //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FieldHQLarge" >> "CargoTowerHQ_BLU_G_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FieldHQLarge" >> "CargoHQ_BLU_G_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FieldHQLarge" >> "CargoPostHQ_BLU_G_F")
            ]
        ],
        [ //Fuel
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FuelSmall" >> "StorageArea"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FuelSmall" >> "FuelDrop")
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FuelMedium" >> "DieselStorage"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FuelMedium" >> "StorageTanks"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FuelMedium" >> "DieselStorage")
            ],
            [  //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FuelMedium" >> "DieselStorage"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FuelMedium" >> "StorageTanks"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FuelMedium" >> "DieselStorage")            
            ]
        ],
        [ //heli
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "" >> ""),
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "HeliportsMedium" >> "SupplyDropPoint"),
            ],
            [  //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "" >> ""),
            ]
        ],
        [ //HQ
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "HQSmall" >> "ConcreteBunker1"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "HQSmall" >> "ConcreteBunker2")
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "HQMedium" >> "RuinFortified"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "HQMedium" >> "HangarFortified"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "HQMedium" >> "ShedSandbags"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "HQMedium" >> "ConcreteBunker1_BLU_G_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "HQMedium" >> "ConcreteBunker2_BLU_G_F")
            ],
            [  //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "HQLarge" >> "MilitaryBase_BLU_G_F")
            ]
        ],
        [ //medical
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "MedicalSmall" >> "FieldHospital"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "MedicalSmall" >> "CollectionStation"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "MedicalSmall" >> "UrbanSurgery"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "MedicalSmall" >> "Surgery1"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "MedicalSmall" >> "Surgery2")
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "MedicalMedium" >> "FieldHospital"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "MedicalMedium" >> "AirStationHospital"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "MedicalMedium" >> "Surgery")
            ],
            [  //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "MedicalLarge" >> "AirAmbulance"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "MedicalLarge" >> "EvacHospital"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "MedicalLarge" >> "MedicalLab"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "MedicalLarge" >> "Hospital")
            ]
        ],
        [ //outpost
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "OutpostsSmall" >> ""),
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "OutpostsMedium" >> ""),
            ],
            [  //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "OutpostsLarge" >> ""),
            ]
        ],
        [ //supports
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "SupportsSmall" >> "Workshop_BLU_G_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "SupportsSmall" >> "ServiceStation_BLU_G_F")
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "SupportsMedium" >> ""),
            ],
            [  //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "SupportsLarge" >> ""),
            ]
        ],
        [ //supplies
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "SuppliesSmall" >> ""),
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "SuppliesMedium" >> ""),
            ],
            [  //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "SuppliesLarge" >> ""),
            ]
        ]

    ],
    [ //Pacific
        [ //camps
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "PicnicSite"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "JungleCamp"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampSite1"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampSite2"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampSite3"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampSite4"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampSite5"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampSite6"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampSite7"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampSite8"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampSite9"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampSite10"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampSite11"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampSite12"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampSite13"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampSite14"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampSiteHMG"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "MortarCamp1"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "MortarCamp2"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampCargoPost1"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampCargoPost2")
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsMedium" >> "CampJungle1"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsMedium" >> "CampJungle2"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsMedium" >> "CampJungle3"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsMedium" >> "CampJungle4"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsMedium" >> "CampJungle5")
            ],
            [ //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsMedium" >> "CampJungle1"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsMedium" >> "CampJungle2"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsMedium" >> "CampJungle3"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsMedium" >> "CampJungle4"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsMedium" >> "CampJungle5")
            ]
        ],
        [ //Field HQ
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FieldHQSmall" >> "ObservationTower_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FieldHQSmall" >> "ObservationPost_IND_C_F")
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FieldHQMedium" >> "CargoHQ1_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FieldHQMedium" >> "CargoHQ2_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FieldHQMedium" >> "BunkerHQ1_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FieldHQMedium" >> "BunkerHQ2_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FieldHQMedium" >> "CargoHouseHQ1_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FieldHQMedium" >> "CargoHouseHQ2_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FieldHQMedium" >> "FieldHQ_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FieldHQMedium" >> "ObservationTower_IND_C_F")
            ],
            [ //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FieldHQLarge" >> "Factory_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FieldHQLarge" >> "CargoTowerHQ_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FieldHQLarge" >> "CargoHQ_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FieldHQLarge" >> "CargoPostHQ_IND_C_F")
            ]
        ],
        [ //Fuel
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FuelSmall" >> "StorageArea_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FuelSmall" >> "StorageTanks_IND_C_F")
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FuelMedium" >> "StorageTank_IND_C_F")
            ],
            [  //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FuelLarge" >> "Depot_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FuelLarge" >> "Refinery_IND_C_F")         ]
        ],
        [ //heli
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "HeliportsSmall" >> "HelipadCircle"),
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "HeliportsMedium" >> "HelipadSquare_IND_C_F"),
            ],
            [  //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "HeliportsLarge" >> "HelipadSquare_IND_C_F"),
            ]
        ],
        [ //HQ
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "HQLarge" >> "MainHQ_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "HQLarge" >> "FactoryHQ_IND_C_F")
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "HQLarge" >> "MainHQ_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "HQLarge" >> "FactoryHQ_IND_C_F")
            ],
            [  //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "HQLarge" >> "MainHQ_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "HQLarge" >> "FactoryHQ_IND_C_F")
            ]
        ],
        [ //medical
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "MedicalSmall" >> "FieldHospital"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "MedicalSmall" >> "CollectionStation_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "MedicalSmall" >> "UrbanSurgery"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "MedicalSmall" >> "UrbanEvacPoint_IND_C_F")
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "MedicalMedium" >> "FieldHospital")
            ],
            [  //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "MedicalLarge" >> "AirAmbulance_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "MedicalLarge" >> "MedicalLabs"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "MedicalLarge" >> "Hospital"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "MedicalLarge" >> "EvacHospital_IND_C_F")
            ]
        ],
        [ //outpost
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsSmall" >> "NativeHut_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsSmall" >> "SlumShack_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsSmall" >> "Shed_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsSmall" >> "ShedSmall_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsSmall" >> "Shack_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsSmall" >> "ShedTiny_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsSmall" >> "OldBungalow_IND_C_F")
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsMedium" >> "Bungalow_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsMedium" >> "BrickBungalow_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsMedium" >> "GreyBungalow_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsMedium" >> "YellowBungalow_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsMedium" >> "BlueBungalow_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsMedium" >> "Shack_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsMedium" >> "ParkingHouse_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsMedium" >> "GuardHouse_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsMedium" >> "Junkyard_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsMedium" >> "BunkerLarge_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsMedium" >> "SmugglersOutpost1"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsMedium" >> "SmugglersOutpost2")
            ],
            [  //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsLarge" >> "LargeBungalow1_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsLarge" >> "LargeBungalow2_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsLarge" >> "Villa_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsLarge" >> "Apartment_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsLarge" >> "Factory_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsLarge" >> "Warehouse_IND_C_F")
            ]
        ],
        [ //supports
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "SupportsSmall" >> "RepairBay_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "SupportsSmall" >> "WaterStation_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "SupportsSmall" >> "Canteen_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "SupportsSmall" >> "BriefingArea_IND_C_F")
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "SupportsMedium" >> "Device_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "SupportsMedium" >> "VehicleShed_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "SupportsMedium" >> "CargoPosts_IND_C_F")
            ],
            [  //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "SupportsLarge" >> "Workshop"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "SupportsLarge" >> "PumpingStation_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "SupportsLarge" >> "MotorPool_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "SupportsLarge" >> "MilitaryFactory")
            ]
        ],
        [ //supplies
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "SuppliesSmall" >> ""),
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "SuppliesMedium" >> ""),
            ],
            [  //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "SuppliesLarge" >> ""),
            ]
        ]
    ],
    [ //Desert

    ]

];

NR6CampMilPool = [

    [ //Temperate
        [ //camps
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "MortarCamp"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite1"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite2"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite3"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite4"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite5"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite6"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite7"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSiteHMG")
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "MortarCamp"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite1"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite2"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite3"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite4"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite5"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite6"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite7"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSiteHMG")
            ],
            [ //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "MortarCamp"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite1"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite2"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite3"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite4"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite5"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite6"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSite7"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "CampsSmall" >> "CampSiteHMG")
            ]
        ],
        [ //Field HQ
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FieldHQSmall" >> "FieldHQ_BLU_G_F")
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FieldHQMedium" >> "CargoHQ1_BLU_G_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FieldHQMedium" >> "CargoHQ2_BLU_G_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FieldHQMedium" >> "BunkerHQ1_BLU_G_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FieldHQMedium" >> "BunkerHQ2_BLU_G_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FieldHQMedium" >> "CargoHouseHQ1_BLU_G_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FieldHQMedium" >> "CargoHouseHQ2_BLU_G_F")
            ],
            [ //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FieldHQLarge" >> "CargoTowerHQ_BLU_G_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FieldHQLarge" >> "CargoHQ_BLU_G_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FieldHQLarge" >> "CargoPostHQ_BLU_G_F")
            ]
        ],
        [ //Fuel
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FuelSmall" >> "StorageArea"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FuelSmall" >> "FuelDrop")
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FuelMedium" >> "DieselStorage"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FuelMedium" >> "StorageTanks"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FuelMedium" >> "DieselStorage")
            ],
            [  //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FuelMedium" >> "DieselStorage"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FuelMedium" >> "StorageTanks"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "FuelMedium" >> "DieselStorage")            
            ]
        ],
        [ //heli
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "" >> ""),
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "HeliportsMedium" >> "SupplyDropPoint"),
            ],
            [  //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "" >> ""),
            ]
        ],
        [ //HQ
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "HQSmall" >> "ConcreteBunker1"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "HQSmall" >> "ConcreteBunker2")
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "HQMedium" >> "RuinFortified"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "HQMedium" >> "HangarFortified"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "HQMedium" >> "ShedSandbags"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "HQMedium" >> "ConcreteBunker1_BLU_G_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "HQMedium" >> "ConcreteBunker2_BLU_G_F")
            ],
            [  //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "HQLarge" >> "MilitaryBase_BLU_G_F")
            ]
        ],
        [ //medical
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "MedicalSmall" >> "FieldHospital"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "MedicalSmall" >> "CollectionStation"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "MedicalSmall" >> "UrbanSurgery"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "MedicalSmall" >> "Surgery1"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "MedicalSmall" >> "Surgery2")
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "MedicalMedium" >> "FieldHospital"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "MedicalMedium" >> "AirStationHospital"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "MedicalMedium" >> "Surgery")
            ],
            [  //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "MedicalLarge" >> "AirAmbulance"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "MedicalLarge" >> "EvacHospital"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "MedicalLarge" >> "MedicalLab"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "MedicalLarge" >> "Hospital")
            ]
        ],
        [ //outpost
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "OutpostsSmall" >> ""),
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "OutpostsMedium" >> ""),
            ],
            [  //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "OutpostsLarge" >> ""),
            ]
        ],
        [ //supports
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "SupportsSmall" >> "Workshop_BLU_G_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "SupportsSmall" >> "ServiceStation_BLU_G_F")
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "SupportsMedium" >> ""),
            ],
            [  //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "SupportsLarge" >> ""),
            ]
        ],
        [ //supplies
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "SuppliesSmall" >> ""),
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "SuppliesMedium" >> ""),
            ],
            [  //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla" >> "SuppliesLarge" >> ""),
            ]
        ]

    ],
    [ //Pacific
        [ //camps
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "PicnicSite"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "JungleCamp"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampSite1"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampSite2"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampSite3"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampSite4"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampSite5"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampSite6"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampSite7"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampSite8"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampSite9"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampSite10"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampSite11"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampSite12"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampSite13"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampSite14"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampSiteHMG"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "MortarCamp1"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "MortarCamp2"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampCargoPost1"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsSmall" >> "CampCargoPost2")
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsMedium" >> "CampJungle1"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsMedium" >> "CampJungle2"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsMedium" >> "CampJungle3"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsMedium" >> "CampJungle4"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsMedium" >> "CampJungle5")
            ],
            [ //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsMedium" >> "CampJungle1"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsMedium" >> "CampJungle2"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsMedium" >> "CampJungle3"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsMedium" >> "CampJungle4"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "CampsMedium" >> "CampJungle5")
            ]
        ],
        [ //Field HQ
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FieldHQSmall" >> "ObservationTower_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FieldHQSmall" >> "ObservationPost_IND_C_F")
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FieldHQMedium" >> "CargoHQ1_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FieldHQMedium" >> "CargoHQ2_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FieldHQMedium" >> "BunkerHQ1_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FieldHQMedium" >> "BunkerHQ2_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FieldHQMedium" >> "CargoHouseHQ1_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FieldHQMedium" >> "CargoHouseHQ2_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FieldHQMedium" >> "FieldHQ_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FieldHQMedium" >> "ObservationTower_IND_C_F")
            ],
            [ //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FieldHQLarge" >> "Factory_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FieldHQLarge" >> "CargoTowerHQ_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FieldHQLarge" >> "CargoHQ_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FieldHQLarge" >> "CargoPostHQ_IND_C_F")
            ]
        ],
        [ //Fuel
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FuelSmall" >> "StorageArea_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FuelSmall" >> "StorageTanks_IND_C_F")
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FuelMedium" >> "StorageTank_IND_C_F")
            ],
            [  //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FuelLarge" >> "Depot_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "FuelLarge" >> "Refinery_IND_C_F")         ]
        ],
        [ //heli
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "HeliportsSmall" >> "HelipadCircle"),
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "HeliportsMedium" >> "HelipadSquare_IND_C_F"),
            ],
            [  //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "HeliportsLarge" >> "HelipadSquare_IND_C_F"),
            ]
        ],
        [ //HQ
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "HQLarge" >> "MainHQ_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "HQLarge" >> "FactoryHQ_IND_C_F")
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "HQLarge" >> "MainHQ_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "HQLarge" >> "FactoryHQ_IND_C_F")
            ],
            [  //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "HQLarge" >> "MainHQ_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "HQLarge" >> "FactoryHQ_IND_C_F")
            ]
        ],
        [ //medical
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "MedicalSmall" >> "FieldHospital"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "MedicalSmall" >> "CollectionStation_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "MedicalSmall" >> "UrbanSurgery"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "MedicalSmall" >> "UrbanEvacPoint_IND_C_F")
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "MedicalMedium" >> "FieldHospital")
            ],
            [  //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "MedicalLarge" >> "AirAmbulance_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "MedicalLarge" >> "MedicalLabs"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "MedicalLarge" >> "Hospital"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "MedicalLarge" >> "EvacHospital_IND_C_F")
            ]
        ],
        [ //outpost
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsSmall" >> "NativeHut_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsSmall" >> "SlumShack_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsSmall" >> "Shed_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsSmall" >> "ShedSmall_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsSmall" >> "Shack_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsSmall" >> "ShedTiny_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsSmall" >> "OldBungalow_IND_C_F")
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsMedium" >> "Bungalow_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsMedium" >> "BrickBungalow_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsMedium" >> "GreyBungalow_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsMedium" >> "YellowBungalow_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsMedium" >> "BlueBungalow_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsMedium" >> "Shack_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsMedium" >> "ParkingHouse_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsMedium" >> "GuardHouse_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsMedium" >> "Junkyard_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsMedium" >> "BunkerLarge_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsMedium" >> "SmugglersOutpost1"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsMedium" >> "SmugglersOutpost2")
            ],
            [  //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsLarge" >> "LargeBungalow1_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsLarge" >> "LargeBungalow2_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsLarge" >> "Villa_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsLarge" >> "Apartment_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsLarge" >> "Factory_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "OutpostsLarge" >> "Warehouse_IND_C_F")
            ]
        ],
        [ //supports
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "SupportsSmall" >> "RepairBay_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "SupportsSmall" >> "WaterStation_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "SupportsSmall" >> "Canteen_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "SupportsSmall" >> "BriefingArea_IND_C_F")
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "SupportsMedium" >> "Device_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "SupportsMedium" >> "VehicleShed_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "SupportsMedium" >> "CargoPosts_IND_C_F")
            ],
            [  //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "SupportsLarge" >> "Workshop"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "SupportsLarge" >> "PumpingStation_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "SupportsLarge" >> "MotorPool_IND_C_F"),
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "SupportsLarge" >> "MilitaryFactory")
            ]
        ],
        [ //supplies
            [ //small
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "SuppliesSmall" >> ""),
            ],
            [ //medium
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "SuppliesMedium" >> ""),
            ],
            [  //large
                (configFile >> "CfgGroups" >> "Empty" >> "Guerrilla_Pacific" >> "SuppliesLarge" >> ""),
            ]
        ]
    ],
    [ //Desert

    ]

];

*/
