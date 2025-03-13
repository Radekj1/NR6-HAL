//[Side, Strength (in number of groups per spawn from 1 to 10), Spawning Positions (as array of positions), Spawning Radius (In meters, recommended 100 to 700 depending on Strength. Minimum 10m.), Available Forces (number of groups), Faction, Threshold (from 0 to 1), Array of leaders for that side (example : [LeaderHQ,LeaderHQB,LeaderHQC]), Source object, Rejoining position]  spawn NR6_fnc_Reinforcements; 

//Ex: [east,1,[(getpos RO1),(getpos RO2),(getpos RO3)],100,50,"LOP_TKA",1,[LeaderHQC,LeaderHQD]]  spawn NR6_fnc_Reinforcements; 
//Ex (using custom faction): [west,1,[(getpos RB1),(getpos RB2)],100,30,"custom",1,[LeaderHQ,LeaderHQB],[['Hum_al_serg','Hum_al_corp','Hum_al_sold','Hum_al_sold','Hum_al_sold','Hum_al_corp','Hum_al_sold','Hum_al_snip','Hum_al_soldAT'],['Hum_al_serg','Hum_al_soldAT','Hum_al_soldAT','Hum_al_sold'],['C_mako1_al_F'],['MEOP_veh_kodiakArm_alliance']]] spawn NR6_fnc_Reinforcements;  


private 
    [
    "_side","_logic","_playerRange","_Commanders","_rStrgt","_SpawnPos","_StartForces","_sidetick","_faction","_CurrentForces","_Pool","_Threshold","_SpawnRadius","_Leaders","_Leader","_SpawnRGroup","_CTR","_ObjSource","_CanSpawn","_RejoinPoint","_SpawnMode","_sidetickHold","_sideEn","_sideEn2","_BluforHQs","_OpforHQs","_IndepHQs","_AllTaken","_nearObjs","_Objective"
    ];

_logic = _this select 0;

_Commanders = [];
_Leaders = [];

{
	if ((typeOf _x) == "NR6_HAL_Leader_Module") then {waitUntil {sleep 0.5; (not (isNil (_x getvariable "LeaderType")))}; _Leaders pushback (call compile (_x getvariable "LeaderType"))};
} foreach (synchronizedObjects _logic);

_side = call compile (_logic getvariable "_side");
_rStrgt = _logic getvariable "_rStrgt";
_SpawnPos =  [getpos _logic];
_SpawnRadius = _logic getvariable "_SpawnRadius";
_sidetick = _logic getvariable "_sidetick";
_faction = _logic getvariable "_faction";
_Threshold = _logic getvariable "_Threshold";
_HalReinf = _logic getvariable "_HalReinf";
_playerFriend = _logic getvariable "_PlayerFriend";
//_Leaders = _Commanders;
_ObjSource = _logic;
_objPos = getpos _logic;
_RejoinPoint = call compile (_logic getvariable "_RejoinPoint");
if (isNil "_RejoinPoint") then {_RejoinPoint = []};
if (_RejoinPoint isEqualTo []) then  {_RejoinPoint = nil};
_playerRange = _logic getvariable "_playerRange";
_SpawnMode = false;
if ((typeOf _logic) == "NR6_Spawn_Module") then {_SpawnMode = true};
_ThresholdDecay = _logic getvariable "_TDecay";
if (isNil "_ThresholdDecay") then {_ThresholdDecay = -1};
if ((_ThresholdDecay == -1) and not (_SpawnMode)) then  {_ThresholdDecay = (1/_sidetick)};

if (isNil ("_HalReinf")) then {_HalReinf = "vanilla"};

if (isNil ("RydHQ_Included")) then {RydHQ_Included = []};
if (isNil ("RydHQB_Included")) then {RydHQB_Included = []};
if (isNil ("RydHQC_Included")) then {RydHQC_Included = []};
if (isNil ("RydHQD_Included")) then {RydHQD_Included = []};
if (isNil ("RydHQE_Included")) then {RydHQE_Included = []};
if (isNil ("RydHQF_Included")) then {RydHQF_Included = []};
if (isNil ("RydHQG_Included")) then {RydHQG_Included = []};
if (isNil ("RydHQH_Included")) then {RydHQH_Included = []};

if (isNil ("LeaderHQ")) then {LeaderHQ = objNull};
if (isNil ("LeaderHQB")) then {LeaderHQB = objNull};
if (isNil ("LeaderHQC")) then {LeaderHQC = objNull};
if (isNil ("LeaderHQD")) then {LeaderHQD = objNull};
if (isNil ("LeaderHQE")) then {LeaderHQE = objNull};
if (isNil ("LeaderHQF")) then {LeaderHQF = objNull};
if (isNil ("LeaderHQG")) then {LeaderHQG = objNull};
if (isNil ("LeaderHQH")) then {LeaderHQH = objNull};

_OpforHQs = [];
_BluforHQs = [];
_IndepHQs = [];
_nearObjs = [];

_nearObjs = _objPos nearEntities ["NR6_HAL_Leader_SimpleObjective_Module", 300];
_nearObjs = [_nearObjs, [], {_objPos distance _x }, "ASCEND",{true}] call BIS_fnc_sortBy;

{
	if ((typeOf _x) == "NR6_HAL_Leader_SimpleObjective_Module") then {
		_Objective = _x;
        _ObjSource = _Objective;
		_campName = _Objective getvariable ["_ObjName",""];
		_objPos = getpos _Objective;
//		_Commanders = [];
		
		{
			if ((typeOf _x) == "NR6_HAL_Leader_Module") then {_Commanders pushback _x};
		} foreach (synchronizedObjects _Objective);

		{
			_Leader = (_x getvariable "LeaderType");

			waitUntil {sleep 0.5; (not (isNil _Leader))};
			
			_Leader = call compile _Leader;

			
			switch (side _Leader) do
			{
				case west: {_BluforHQs pushBack _Leader};
				case east: {_OpforHQs pushBack _Leader};
				case resistance: {_IndepHQs pushBack _Leader};
			};
		} foreach _Commanders;
		_Leaders = _Leaders + _BluforHQs + _OpforHQs + _IndepHQs;
	};
} foreach _nearObjs;

_Commanders = _Leaders;

//CUSTOM FACTIONS - EDIT AT WILL

if (_faction == "B") then {

    _Pool = 
        [
        
        ]
};

if (_faction == "O") then {

    _Pool = 
        [
        
        ]
};

if (_faction == "I") then {

    _Pool = 
        [
        
        ]
};

if (_faction == "custom") then {

    _Pool = call compile (_logic getvariable "_Pool");
};

//BLUFOR POOL

if (_faction == "BLU_F") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad",
        configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfTeam",
        configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfTeam_AT",
        configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfTeam_AA",
        configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Armored" >> "BUS_TankSection",
        configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Mechanized" >> "BUS_MechInf_Support",
        configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Mechanized" >> "BUS_MechInfSquad",
        configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Motorized" >> "BUS_MotInf_GMGTeam",
        configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Motorized" >> "BUS_MotInf_MGTeam"
        ]
};

if (_faction == "BLU_T_F") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Infantry" >> "B_T_InfSquad",
        configfile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Infantry" >> "B_T_InfTeam",
        configfile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Infantry" >> "B_T_InfTeam_AA",
        configfile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Infantry" >> "B_T_InfTeam_AT",
        configfile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Mechanized" >> "B_T_MechInf_Support",
        configfile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Mechanized" >> "B_T_MechInfSquad",
        configfile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Motorized" >> "B_T_MotInf_GMGTeam",
        configfile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Motorized" >> "B_T_MotInf_MGTeam",
        configfile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Armored" >> "B_T_TankPlatoon_AA",
        configfile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Armored" >> "B_T_TankPlatoon"
        ]
};

if (_faction == "rhs_faction_usarmy_d") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_d" >> "rhs_group_nato_usarmy_d_infantry" >> "rhs_group_nato_usarmy_d_infantry_squad",
        configfile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_d" >> "rhs_group_nato_usarmy_d_infantry" >> "rhs_group_nato_usarmy_d_infantry_team_AA",
        configfile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_d" >> "rhs_group_nato_usarmy_d_infantry" >> "rhs_group_nato_usarmy_d_infantry_team_AT",
        configfile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_d" >> "rhs_group_nato_usarmy_d_infantry" >> "rhs_group_nato_usarmy_d_infantry_weaponsquad",
        ["rhsusf_army_ocp_teamleader","rhsusf_army_ocp_rifleman","rhsusf_army_ocp_autorifleman","rhsusf_army_ocp_autorifleman","rhsusf_army_ocp_autorifleman","rhsusf_army_ocp_riflemanat","rhsusf_army_ocp_autorifleman","rhsusf_M1220_M2_usarmy_d"],
        ["rhsusf_army_ocp_teamleader","rhsusf_army_ocp_riflemanat","rhsusf_army_ocp_rifleman","rhsusf_m1025_d_mk19"],
        ["rhsusf_army_ocp_teamleader","rhsusf_army_ocp_riflemanat","rhsusf_army_ocp_rifleman","rhsusf_m1025_d_m2"],
        ["rhsusf_army_ocp_teamleader","rhsusf_army_ocp_rifleman","rhsusf_army_ocp_autorifleman","rhsusf_army_ocp_autorifleman","rhsusf_army_ocp_autorifleman","rhsusf_army_ocp_riflemanat","RHS_M2A3_BUSKIII"],
        ["rhsusf_m1a2sep1tuskiid_usarmy"],
        ["rhsusf_m1a2sep1tuskiid_usarmy"],
        ["RHS_M2A3_BUSKIII"]
        ]
};

if (_faction == "rhs_faction_usarmy_wd") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_wd" >> "rhs_group_nato_usarmy_wd_infantry" >> "rhs_group_nato_usarmy_wd_infantry_squad",
        configfile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_wd" >> "rhs_group_nato_usarmy_wd_infantry" >> "rhs_group_nato_usarmy_wd_infantry_team_AA",
        configfile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_wd" >> "rhs_group_nato_usarmy_wd_infantry" >> "rhs_group_nato_usarmy_wd_infantry_team_AT",
        configfile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_wd" >> "rhs_group_nato_usarmy_wd_infantry" >> "rhs_group_nato_usarmy_wd_infantry_weaponsquad",
        ["rhsusf_army_ucp_teamleader","rhsusf_army_ucp_rifleman","rhsusf_army_ucp_autorifleman","rhsusf_army_ucp_autorifleman","rhsusf_army_ucp_autorifleman","rhsusf_army_ucp_riflemanat","rhsusf_army_ucp_autorifleman","rhsusf_M1220_M2_usarmy_wd"],
        ["rhsusf_army_ucp_teamleader","rhsusf_army_ucp_riflemanat","rhsusf_army_ucp_rifleman","rhsusf_m1025_w_mk19"],
        ["rhsusf_army_ucp_teamleader","rhsusf_army_ucp_riflemanat","rhsusf_army_ucp_rifleman","rhsusf_m1025_w_m2"],
        ["rhsusf_army_ucp_teamleader","rhsusf_army_ucp_rifleman","rhsusf_army_ucp_autorifleman","rhsusf_army_ucp_autorifleman","rhsusf_army_ucp_autorifleman","rhsusf_army_ucp_riflemanat","RHS_M2A3_BUSKIII_wd"],
        ["RHS_M2A3_BUSKIII_wd"],
        ["rhsusf_m1a2sep1tuskiwd_usarmy"],
        ["rhsusf_m1a2sep1tuskiwd_usarmy"]
        ]
};

if (_faction == "rhs_faction_usmc_d") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_d" >> "rhs_group_nato_usmc_d_infantry" >> "rhs_group_nato_usmc_d_infantry_squad",
        configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_d" >> "rhs_group_nato_usmc_d_infantry" >> "rhs_group_nato_usmc_d_infantry_team_heavy_AT",
        configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_d" >> "rhs_group_nato_usmc_d_infantry" >> "rhs_group_nato_usmc_d_infantry_team_AA",
        configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_d" >> "rhs_group_nato_usmc_d_infantry" >> "rhs_group_nato_usmc_d_infantry_weaponsquad",
        ["rhsusf_m1043_d_s_mk19"],
        ["rhsusf_m1043_d_s_m2"],
        ["rhsusf_m1a1fep_od"],
        ["rhsusf_m1a1fep_od"],
        ["rhsusf_m1a1fep_d"]
        ]
};

if (_faction == "rhs_faction_usmc_wd") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_infantry" >> "rhs_group_nato_usmc_wd_infantry_squad",
        configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_infantry" >> "rhs_group_nato_usmc_wd_infantry_team_heavy_AT",
        configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_infantry" >> "rhs_group_nato_usmc_wd_infantry_team_AA",
        configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_infantry" >> "rhs_group_nato_usmc_wd_infantry_weaponsquad",
        ["rhsusf_m1043_w_s_mk19"],
        ["rhsusf_m1043_w_s_m2"],
        ["rhsusf_m1a1fep_od"],
        ["rhsusf_m1a1fep_od"],
        ["rhsusf_m1a1fep_wd"]
        ]
};

if (_faction == "CAF_TW") then {

    _Pool = 
        [
        ["CAF_SECTIONIC_tw","CAF_RIFLEMAN_tw","CAF_GRENADIER_tw","CAF_GRENADIER_tw","CAF_RIFLEMAN_tw","CAF_SECTION2IC_tw","CAF_C9GUNNER_tw","CAF_C9GUNNER_tw"],
        ["CAF_SECTIONIC_tw","CAF_RIFLEMAN_tw","CAF_GRENADIER_tw","CAF_GRENADIER_tw","CAF_RIFLEMAN_tw","CAF_SECTION2IC_tw","CAF_C9GUNNER_tw","CAF_C9GUNNER_tw"],
        ["CAF_GRENADIER_tw","CAF_RIFLEMAN_tw","CAF_RIFLEMAN_tw","CAF_84GUNNER_tw"],
        ["CAF_GRENADIER_tw","CAF_RIFLEMAN_tw","CAF_C6GUNNER_tw","CAF_C9GUNNER_tw"],
        ["CAF_LeopardC2_TW"],
        ["CAF_LeopardC2_TW"]
        ]
};

if (_faction == "CUP_B_US_Army") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "West" >> "CUP_B_US_Army" >> "Infantry" >> "CUP_B_US_Army_RifleSquad",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_US_Army" >> "Infantry" >> "CUP_B_US_Army_Team",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_US_Army" >> "Infantry" >> "CUP_B_US_Army_TeamAT",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_US_Army" >> "Infantry" >> "CUP_B_US_Army_HeavyATTeam",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_US_Army" >> "Mechanized" >> "CUP_B_US_Army_MechanizedInfantrySquadICVM2",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_US_Army" >> "Mechanized" >> "CUP_B_US_Army_MechanizedInfantrySquadICVMK19",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_US_Army" >> "Motorized" >> "CUP_B_US_Army_MotorizedSection",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_US_Army" >> "Motorized" >> "CUP_B_US_Army_MotorizedSectionAT",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_US_Army" >> "Armored" >> "CUP_B_US_Army_M1A2Section",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_US_Army" >> "Armored" >> "CUP_B_US_Army_MGSPlatoon"
        ]
};

if (_faction == "CUP_B_USMC") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "West" >> "CUP_B_USMC" >> "Infantry" >> "CUP_B_USMC_InfSquad",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_USMC" >> "Infantry" >> "CUP_B_USMC_HeavyATTeam",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_USMC" >> "Infantry" >> "CUP_B_USMC_FireTeam_MG",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_USMC" >> "Infantry" >> "CUP_B_USMC_FireTeam_AT",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_USMC" >> "Infantry" >> "CUP_B_USMC_FireTeam",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_USMC" >> "Mechanized" >> "CUP_B_USMC_MechReconSection",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_USMC" >> "Mechanized" >> "CUP_B_USMC_MechInfSquad",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_USMC" >> "Motorized" >> "CUP_B_USMC_MotInfSection",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_USMC" >> "Motorized" >> "CUP_B_USMC_MotInfSection_AT",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_USMC" >> "Motorized" >> "CUP_B_USMC_MotInfSquad",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_USMC" >> "Armored" >> "CUP_B_USMC_TankPlatoon"
        ]
};

if (_faction == "CUP_B_CDF") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "West" >> "CUP_B_CDF" >> "Infantry_FST" >> "CUP_B_CDFInfSquad_FST",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_CDF" >> "Infantry_FST" >> "CUP_B_CDFInfSection_AT_FST",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_CDF" >> "Infantry_FST" >> "CUP_B_CDFInfSection_AA_FST",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_CDF" >> "Infantry_FST" >> "CUP_B_CDFInfSection_MG_FST",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_CDF" >> "Armored" >> "CUP_B_CDFTankPlatoon",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_CDF" >> "Mechanized" >> "CUP_B_CDFMechATSection",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_CDF" >> "Motorized" >> "CUP_B_CDFMotInfSquad",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_CDF" >> "Motorized" >> "CUP_B_CDFMotInfSection"
        ]
};

if (_faction == "CUP_B_CZ") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "West" >> "CUP_B_CZ" >> "Infantry" >> "CUP_B_CZInfantryTeam_WDL",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_CZ" >> "Motorized" >> "CUP_B_CZMotorizedPatrol"
        ]
};

if (_faction == "CUP_B_GB") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "West" >> "CUP_B_GB" >> "Infantry" >> "CUP_B_GB_Section_MTP",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_GB" >> "Infantry" >> "CUP_B_GB_Fireteam_MTP",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_GB" >> "Infantry" >> "CUP_B_GB_HAT_MTP",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_GB" >> "Infantry" >> "CUP_B_GB_AT_MTP",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_GB" >> "Infantry" >> "CUP_B_GB_MG_MTP",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_GB" >> "Mechanized" >> "CUP_B_GB_MechAT_W",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_GB" >> "Mechanized" >> "CUP_B_GB_MechSec_W",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_GB" >> "Motorized_MTP" >> "CUP_B_GB_MSection_W_Mastiff",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_GB" >> "Motorized_MTP" >> "CUP_B_GB_MSection_W_Ridgback",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_GB" >> "Motorized_MTP" >> "CUP_B_GB_MTeam_W",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_GB" >> "Armored" >> "CUP_B_GB_WPlatoon_W"
        ]
};

if (_faction == "CUP_B_GER") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "West" >> "CUP_B_GER" >> "Infantry_WDL" >> "CUP_B_GER_Fleck_KSK_AssaultTeam",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_GER" >> "Infantry_WDL" >> "CUP_B_GER_Fleck_KSK_Team",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_GER" >> "Infantry_WDL" >> "CUP_B_GER_Fleck_KSK_ATTeam",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_GER" >> "Motorized" >> "CUP_B_GER_SF_MotInf_KSK_WDL",
        configfile >> "CfgGroups" >> "West" >> "CUP_B_GER" >> "Motorized" >> "CUP_B_GER_SF_MotInf_ReconPatrol_KSK_WDL"
        ]
};

if (_faction == "LOP_AA") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "West" >> "LOP_AA" >> "Infantry" >> "LOP_AA_Rifle_squad",
        configfile >> "CfgGroups" >> "West" >> "LOP_AA" >> "Infantry" >> "LOP_AA_Fireteam",
        configfile >> "CfgGroups" >> "West" >> "LOP_AA" >> "Infantry" >> "LOP_AA_AT_section",
        configfile >> "CfgGroups" >> "West" >> "LOP_AA" >> "Infantry" >> "LOP_AA_Support_section",
        configfile >> "CfgGroups" >> "West" >> "LOP_AA" >> "Mechanized" >> "LOP_AA_Mech_squad_BMP2",
        configfile >> "CfgGroups" >> "West" >> "LOP_AA" >> "Mechanized" >> "LOP_AA_Motor_Offroad_M2",
        configfile >> "CfgGroups" >> "West" >> "LOP_AA" >> "Armored" >> "LOP_AA_ZSU234_Platoon"
        ]
};

if (_faction == "LOP_CDF") then {

    _Pool = 
        [
        ["rhsgref_cdf_b_reg_squadleader", "rhsgref_cdf_b_reg_machinegunner", "rhsgref_cdf_b_reg_grenadier_rpg", "rhsgref_cdf_b_reg_grenadier", "rhsgref_cdf_b_reg_rifleman_rpg75", "rhsgref_cdf_b_reg_machinegunner", "rhsgref_cdf_b_reg_grenadier_rpg" ,"rhsgref_cdf_b_reg_grenadier" ,"rhsgref_cdf_b_reg_rifleman" ,"rhsgref_cdf_b_reg_medic"],
        ["rhsgref_cdf_b_reg_squadleader", "rhsgref_cdf_b_reg_machinegunner", "rhsgref_cdf_b_reg_grenadier_rpg", "rhsgref_cdf_b_reg_grenadier", "rhsgref_cdf_b_reg_rifleman_rpg75", "rhsgref_cdf_b_reg_machinegunner", "rhsgref_cdf_b_reg_grenadier_rpg" ,"rhsgref_cdf_b_reg_grenadier" ,"rhsgref_cdf_b_reg_rifleman" ,"rhsgref_cdf_b_reg_medic"],
        ["rhsgref_cdf_b_reg_squadleader", "rhsgref_cdf_b_reg_machinegunner", "rhsgref_cdf_b_reg_grenadier_rpg", "rhsgref_cdf_b_reg_grenadier", "rhsgref_cdf_b_reg_rifleman_rpg75", "rhsgref_cdf_b_reg_machinegunner", "rhsgref_cdf_b_reg_grenadier_rpg" ,"rhsgref_cdf_b_reg_grenadier" ,"rhsgref_cdf_b_reg_rifleman" ,"rhsgref_cdf_b_reg_medic"],
        ["rhsgref_cdf_b_reg_squadleader", "rhsgref_cdf_b_reg_machinegunner", "rhsgref_cdf_b_reg_grenadier_rpg", "rhsgref_cdf_b_reg_grenadier", "rhsgref_cdf_b_reg_rifleman_rpg75", "rhsgref_cdf_b_reg_machinegunner", "rhsgref_cdf_b_reg_grenadier_rpg" ,"rhsgref_cdf_b_reg_grenadier" ,"rhsgref_cdf_b_reg_rifleman" ,"rhsgref_cdf_b_reg_medic"],
        ["rhsgref_cdf_b_t80bv_tv"],
        ["rhsgref_cdf_b_t80bv_tv"],
        ["rhsgref_cdf_b_t80bv_tv"],
        ["rhsgref_cdf_b_reg_squadleader", "rhsgref_cdf_b_reg_machinegunner", "rhsgref_cdf_b_reg_grenadier_rpg", "rhsgref_cdf_b_reg_grenadier", "rhsgref_cdf_b_reg_rifleman_rpg75","rhsgref_BRDM2_b"],
        ["rhsgref_cdf_b_reg_squadleader", "rhsgref_cdf_b_reg_machinegunner", "rhsgref_cdf_b_reg_grenadier_rpg", "rhsgref_cdf_b_reg_grenadier", "rhsgref_cdf_b_reg_rifleman_rpg75","rhsgref_cdf_b_bmp2k"]

        ]
};

if (_faction == "LOP_IA") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "West" >> "LOP_IA" >> "Infantry" >> "LOP_IA_Rifle_squad",
        configfile >> "CfgGroups" >> "West" >> "LOP_IA" >> "Infantry" >> "LOP_IA_Support_section",
        configfile >> "CfgGroups" >> "West" >> "LOP_IA" >> "Infantry" >> "LOP_IA_AT_section",
        configfile >> "CfgGroups" >> "West" >> "LOP_IA" >> "Mechanized" >> "LOP_IA_Mech_squad_BMP2",
        configfile >> "CfgGroups" >> "West" >> "LOP_IA" >> "Armored" >> "LOP_IA_ZSU234_Platoon"
        ]
};

if (_faction == "LOP_PESH") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "West" >> "LOP_PESH" >> "Infantry" >> "LOP_PESH_Rifle_squad",
        configfile >> "CfgGroups" >> "West" >> "LOP_PESH" >> "Infantry" >> "LOP_PESH_Fireteam",
        configfile >> "CfgGroups" >> "West" >> "LOP_PESH" >> "Infantry" >> "LOP_PESH_AT_section",
        configfile >> "CfgGroups" >> "West" >> "LOP_PESH" >> "Infantry" >> "LOP_PESH_Support_section",
        configfile >> "CfgGroups" >> "West" >> "LOP_PESH" >> "Motorized" >> "LOP_PESH_Motor_squad_LR",
        configfile >> "CfgGroups" >> "West" >> "LOP_PESH" >> "Motorized" >> "LOP_PESH_Motor_squad_HMMWV"
        ]
};

if (_faction == "OPTRE_UNSC") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "West" >> "OPTRE_UNSC" >> "Infantry_Army_WDL" >> "OPTRE_Groups_UNSC_Squad_Army_WDL", 
        configfile >> "CfgGroups" >> "West" >> "OPTRE_UNSC" >> "Infantry_Army_WDL" >> "OPTRE_Groups_UNSC_Squad_Army_WDL",
        configfile >> "CfgGroups" >> "West" >> "OPTRE_UNSC" >> "Infantry_Army_WDL" >> "OPTRE_Groups_UNSC_Squad_Army_WDL",
        ["OPTRE_M808B_UNSC"],
        ["OPTRE_M12_LRV"],
        ["OPTRE_M12G1_LRV"],
        ["OPTRE_M412_IFV_UNSC"],
        ["OPTRE_M413_MGS_UNSC"]
        ]
};

if (_faction == "OPTRE_UNSC_DES") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "West" >> "OPTRE_UNSC" >> "Infantry_Army_DES" >> "OPTRE_Groups_UNSC_Squad_Army_DES",
        configfile >> "CfgGroups" >> "West" >> "OPTRE_UNSC" >> "Infantry_Army_DES" >> "OPTRE_Groups_UNSC_Squad_Army_DES",
        configfile >> "CfgGroups" >> "West" >> "OPTRE_UNSC" >> "Infantry_Army_DES" >> "OPTRE_Groups_UNSC_Squad_Army_DES",
        ["OPTRE_M808B_UNSC"],
        ["OPTRE_M12_LRV"],
        ["OPTRE_M12G1_LRV"],
        ["OPTRE_M412_IFV_UNSC"],
        ["OPTRE_M413_MGS_UNSC"]
        ]
};

if (_faction == "MEOP_human") then {

    _Pool = 
        [
        ["Hum_al_corp","Hum_al_sold","Hum_al_sold","Hum_al_corp","Hum_al_sold","Hum_al_snip","Hum_al_soldAT","Hum_al_soldAT","Hum_al_serg"],
        ["C_mako1_al_F"]
        ]
};

//OPFOR POOL

if (_faction == "OPF_F") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Armored" >> "OIA_TankSection",
        configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad",
        configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam",
        configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam_AT",
        configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "O_InfTeam_AT_Heavy",
        configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam_AA",
        configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Mechanized" >> "OIA_MechInfSquad",
        configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Mechanized" >> "OIA_MechInf_Support",
        configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Motorized_MTP" >> "OIA_MotInf_GMGTeam",
        configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Motorized_MTP" >> "OIA_MotInf_MGTeam",
        configfile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Armored" >> "O_T_TankPlatoon",
        configfile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Armored" >> "O_T_TankPlatoon_AA"

        ]
};

if (_faction == "OPF_T_F") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfSquad",
        configfile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfTeam",
        configfile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfTeam_AA",
        configfile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfTeam_AT",
        configfile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Mechanized" >> "O_T_MechInfSquad",
        configfile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Mechanized" >> "O_T_MechInf_Support",
        configfile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Motorized_MTP" >> "O_T_MotInf_MGTeam",
        configfile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Motorized_MTP" >> "O_T_MotInf_GMGTeam",
        configfile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Armored" >> "O_T_TankPlatoon",
        configfile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Armored" >> "O_T_TankPlatoon_AA"
        ]
};

if (_faction == "LOP_BH") then {

    _Pool = 
        [
        ["LOP_BH_Infantry_SL", "LOP_BH_Infantry_TL", "LOP_BH_Infantry_AR", "LOP_BH_Infantry_AT", "LOP_BH_Infantry_AR_Asst", "LOP_BH_Infantry_GL", "LOP_BH_Infantry_Rifleman", "LOP_BH_Infantry_Corpsman"],
        ["LOP_BH_Infantry_SL", "LOP_BH_Infantry_TL", "LOP_BH_Infantry_AR", "LOP_BH_Infantry_AT", "LOP_BH_Infantry_AR_Asst", "LOP_BH_Infantry_GL", "LOP_BH_Infantry_Rifleman", "LOP_BH_Infantry_Corpsman"],
        ["LOP_BH_Infantry_TL", "LOP_BH_Infantry_AT", "LOP_BH_Infantry_AT", "LOP_BH_Infantry_GL"],
        ["LOP_BH_Offroad_M2"],
        ["LOP_BH_Landrover_SPG9"], 
        ["LOP_BH_Landrover_M2"],
        configfile >> "CfgGroups" >> "East" >> "LOP_BH" >> "Motorized" >> "LOP_BH_LRPatrol",
        configfile >> "CfgGroups" >> "East" >> "LOP_BH" >> "Motorized" >> "LOP_BH_TruckPatrol"
        ]
};


if (_faction == "LOP_IRAN") then {

    _Pool = 
        [
        
    ["LOP_IRAN_Infantry_junior_sergeant", "LOP_IRAN_Infantry_junior_sergeant", "LOP_IRAN_Infantry_medic" ,"LOP_IRAN_Infantry_Marksman", "LOP_IRAN_Infantry_Rifleman", "LOP_IRAN_Infantry_Light" ,"LOP_IRAN_Infantry_Grenadier", "LOP_IRAN_Infantry_AR"],
    ["LOP_IRAN_Infantry_junior_sergeant", "LOP_IRAN_Infantry_RPG", "LOP_IRAN_Infantry_LAT" ,"LOP_IRAN_Infantry_RPG"],
    ["LOP_IRAN_Infantry_junior_sergeant", "LOP_IRAN_Infantry_junior_sergeant", "LOP_IRAN_Infantry_medic" ,"LOP_IRAN_Infantry_Marksman", "LOP_IRAN_Infantry_Rifleman", "LOP_IRAN_Infantry_Light" ,"LOP_IRAN_Infantry_Grenadier", "LOP_IRAN_Infantry_AR"],
    ["LOP_IRAN_Infantry_junior_sergeant", "LOP_IRAN_Infantry_RPG", "LOP_IRAN_Infantry_LAT" ,"LOP_IRAN_Infantry_RPG"],
    ["LOP_IRAN_Infantry_junior_sergeant", "LOP_IRAN_Infantry_RPG", "LOP_IRAN_Infantry_LAT" ,"LOP_IRAN_Infantry_RPG","LOP_IRAN_BMP1"], 
    ["LOP_IRAN_Infantry_junior_sergeant", "LOP_IRAN_Infantry_RPG", "LOP_IRAN_Infantry_LAT" ,"LOP_IRAN_Infantry_RPG","LOP_IRAN_BMP2"], 
    ["LOP_IRAN_T72BA"], 
    ["LOP_IRAN_BTR80"]
        ]
};

if (_faction == "LOP_TKA") then {

        _Pool = 
            [
            configfile >> "CfgGroups" >> "East" >> "LOP_TKA" >> "Infantry" >> "LOP_TKA_Rifle_squad",
            configfile >> "CfgGroups" >> "East" >> "LOP_TKA" >> "Infantry" >> "LOP_TKA_Support_section",
            configfile >> "CfgGroups" >> "East" >> "LOP_TKA" >> "Infantry" >> "LOP_TKA_AT_section",
            configfile >> "CfgGroups" >> "East" >> "LOP_TKA" >> "Infantry" >> "LOP_TKA_Rifle_squad",
            configfile >> "CfgGroups" >> "East" >> "LOP_TKA" >> "Infantry" >> "LOP_TKA_Rifle_squad",
            ["LOP_TKA_BMP1"],
            ["LOP_TKA_UAZ_DshKM"],
            ["LOP_TKA_T72BB"],
            ["LOP_TKA_Infantry_TL","LOP_TKA_Infantry_SL","LOP_TKA_Infantry_Corpsman","LOP_TKA_Infantry_MG","LOP_TKA_Infantry_Rifleman","LOP_TKA_Infantry_GL","LOP_TKA_BMP1D"],
            ["LOP_TKA_Infantry_TL","LOP_TKA_Infantry_SL","LOP_TKA_Infantry_Corpsman","LOP_TKA_Infantry_MG","LOP_TKA_Infantry_Rifleman","LOP_TKA_Infantry_GL","LOP_TKA_BMP2D"],
            ["LOP_TKA_Ural"]
            ]
};

if (_faction == "rhs_faction_ru") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_squad",
        configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_section_AA",
        configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_section_AT",
        configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_squad",
        configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_section_AA",
        configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_section_AT",
        configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_squad",
        configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_section_AA",
        configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_section_AT",
        configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_squad",
        configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_squad",
        configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_section_AA",
        configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_section_AT",
        ["rhs_msv_sergeant","rhs_msv_junior_sergeant","rhs_msv_grenadier","rhs_msv_machinegunner","rhs_tigr_sts_vv"],
        ["rhs_msv_sergeant","rhs_msv_junior_sergeant","rhs_msv_grenadier","rhs_msv_machinegunner","rhs_tigr_m_3camo_vv"],
        ["rhs_msv_sergeant","rhs_msv_junior_sergeant","rhs_msv_grenadier","rhs_msv_machinegunner","rhs_tigr_sts_3camo_vv"],
        ["rhs_msv_sergeant","rhs_msv_junior_sergeant","rhs_msv_grenadier","rhs_msv_machinegunner","rhs_tigr_m_vv"],
        ["rhs_msv_sergeant","rhs_msv_junior_sergeant","rhs_msv_grenadier","rhs_msv_machinegunner","rhs_msv_at","rhs_msv_strelok_rpg_assist","rhs_msv_rifleman","rhs_bmp2_msv"],
        ["rhs_msv_sergeant","rhs_msv_junior_sergeant","rhs_msv_grenadier","rhs_msv_machinegunner","rhs_msv_at","rhs_msv_strelok_rpg_assist","rhs_msv_rifleman","rhs_bmp1p_msv"],
        ["rhs_msv_sergeant","rhs_msv_junior_sergeant","rhs_msv_grenadier","rhs_msv_machinegunner","rhs_msv_at","rhs_msv_strelok_rpg_assist","rhs_msv_rifleman","rhs_bmp3mera_msv"],
        ["rhs_msv_sergeant","rhs_msv_junior_sergeant","rhs_msv_grenadier","rhs_msv_machinegunner","rhs_msv_at","rhs_msv_strelok_rpg_assist","rhs_msv_rifleman","rhs_btr80a_msv"],
        ["rhs_btr80a_msv"],
        ["rhs_bmp3mera_msv"],
        ["rhs_bmp2k_msv"],
        ["rhs_bmp1p_msv"],
        ["rhs_t90a_tv"],
        ["rhs_t80um"],
        ["rhs_t80bvk"],
        ["rhs_t72be_tv"]
        ]
};

if (_faction == "CUP_O_ChDKZ") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "East" >> "CUP_O_ChDKZ" >> "Infantry" >> "CUP_O_ChDKZ_InfSquad",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_ChDKZ" >> "Infantry" >> "CUP_O_ChDKZ_InfSection_AT",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_ChDKZ" >> "Infantry" >> "CUP_O_ChDKZ_InfSection_AA",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_ChDKZ" >> "Armored" >> "CUP_O_ChDKZ_TankSection",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_ChDKZ" >> "Mechanized" >> "CUP_O_ChDKZ_MechInfSection",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_ChDKZ" >> "Motorized" >> "CUP_O_ChDKZ_MotInfSquad",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_ChDKZ" >> "Motorized" >> "CUP_O_ChDKZ_MotInfSection"
        ]
};

if (_faction == "CUP_O_RU") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "East" >> "CUP_O_RU" >> "Infantry" >> "CUP_O_RU_InfSquad_VDV",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_RU" >> "Infantry" >> "CUP_O_RU_InfSection_EMR",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_RU" >> "Infantry" >> "CUP_O_RU_InfSection_MG_VDV",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_RU" >> "Infantry" >> "CUP_O_RU_InfSection_AA",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_RU" >> "Infantry" >> "CUP_O_RU_InfSection_AT",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_RU" >> "Motorized" >> "CUP_O_RU_MotInfSquad",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_RU" >> "Armored" >> "CUP_O_RU_TankPlatoon",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_RU" >> "Mechanized" >> "CUP_O_RU_MechInfSquad_2"
        ]
};

if (_faction == "CUP_O_SLA") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "East" >> "CUP_O_SLA" >> "Infantry" >> "CUP_O_SLA_InfantrySquad",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_SLA" >> "Infantry" >> "CUP_O_SLA_InfantrySectionMG",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_SLA" >> "Infantry" >> "CUP_O_SLA_InfantrySectionAT",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_SLA" >> "Infantry" >> "CUP_O_SLA_InfantrySectionAA",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_SLA" >> "Infantry" >> "CUP_O_SLA_InfantrySection",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_SLA" >> "Armored" >> "CUP_O_SLA_TankPlatoon",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_SLA" >> "Motorized" >> "CUP_O_SLA_MotInfSection_AT",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_SLA" >> "Motorized" >> "CUP_O_SLA_MotInfSection",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_SLA" >> "Mechanized" >> "CUP_O_SLA_MechInfSquad"
        ]
};

if (_faction == "CUP_O_SLA") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "East" >> "CUP_O_SLA" >> "Infantry" >> "CUP_O_SLA_InfantrySquad",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_SLA" >> "Infantry" >> "CUP_O_SLA_InfantrySectionMG",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_SLA" >> "Infantry" >> "CUP_O_SLA_InfantrySectionAT",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_SLA" >> "Infantry" >> "CUP_O_SLA_InfantrySectionAA",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_SLA" >> "Infantry" >> "CUP_O_SLA_InfantrySection",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_SLA" >> "Armored" >> "CUP_O_SLA_TankPlatoon",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_SLA" >> "Motorized" >> "CUP_O_SLA_MotInfSection_AT",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_SLA" >> "Motorized" >> "CUP_O_SLA_MotInfSection",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_SLA" >> "Mechanized" >> "CUP_O_SLA_MechInfSquad"
        ]
};

if (_faction == "CUP_O_TK") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "East" >> "CUP_O_TK" >> "Infantry" >> "CUP_O_TK_InfantrySquad",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_TK" >> "Infantry" >> "CUP_O_TK_InfantrySection",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_TK" >> "Infantry" >> "CUP_O_TK_InfantrySectionMG",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_TK" >> "Infantry" >> "CUP_O_TK_InfantrySectionAT",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_TK" >> "Infantry" >> "CUP_O_TK_InfantrySectionAA",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_TK" >> "Mechanized" >> "CUP_O_TK_MechanizedReconSectionAT",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_TK" >> "Mechanized" >> "CUP_O_TK_MechanizedInfantrySquadBMP2",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_TK" >> "Motorized" >> "CUP_O_TK_MotorizedReconSection",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_TK" >> "Motorized" >> "CUP_O_TK_MotorizedPatrol",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_TK" >> "Armored" >> "CUP_O_TK_T72Platoon"
        ]
};

if (_faction == "CUP_O_TK_MILITIA") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "East" >> "CUP_O_TK_MILITIA" >> "Infantry" >> "CUP_O_TK_MILITIA_AATeam",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_TK_MILITIA" >> "Infantry" >> "CUP_O_TK_MILITIA_ATTeam",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_TK_MILITIA" >> "Infantry" >> "CUP_O_TK_MILITIA_Demosquad",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_TK_MILITIA" >> "Infantry" >> "CUP_O_TK_MILITIA_Group",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_TK_MILITIA" >> "Infantry" >> "CUP_O_TK_MILITIA_Patrol",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_TK_MILITIA" >> "Motorized" >> "CUP_O_TK_MILITIA_MotorizedGroup",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_TK_MILITIA" >> "Motorized" >> "CUP_O_TK_MILITIA_MotorizedPatrolBTR40",
        configfile >> "CfgGroups" >> "East" >> "CUP_O_TK_MILITIA" >> "Motorized" >> "CUP_O_TK_MILITIA_Technicals"
        ]
};

if (_faction == "LOP_AFR_OPF") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "East" >> "LOP_AFR_OPF" >> "Infantry" >> "LOP_AFR_OPF_AT_section",
        configfile >> "CfgGroups" >> "East" >> "LOP_AFR_OPF" >> "Infantry" >> "LOP_AFR_OPF_Rifle_squad",
        configfile >> "CfgGroups" >> "East" >> "LOP_AFR_OPF" >> "Infantry" >> "LOP_AFR_OPF_Support_section",
        configfile >> "CfgGroups" >> "East" >> "LOP_AFR_OPF" >> "Motorized" >> "LOP_AFR_OPF_Motor_squad_LR",
        configfile >> "CfgGroups" >> "East" >> "LOP_AFR_OPF" >> "Armored" >> "LOP_AFR_OPF_T72_Platoon"
        ]
};

if (_faction == "LOP_AM_OPF") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "East" >> "LOP_AM_OPF" >> "Infantry" >> "LOP_AM_OPF_AT_section",
        configfile >> "CfgGroups" >> "East" >> "LOP_AM_OPF" >> "Infantry" >> "LOP_AM_OPF_Rifle_squad",
        configfile >> "CfgGroups" >> "East" >> "LOP_AM_OPF" >> "Infantry" >> "LOP_AM_OPF_Fireteam",
        configfile >> "CfgGroups" >> "East" >> "LOP_AM_OPF" >> "Infantry" >> "LOP_AM_OPF_Support_section",
        configfile >> "CfgGroups" >> "East" >> "LOP_AM_OPF" >> "Motorized" >> "LOP_AM_OPF_Motor_squad_UAZ",
        configfile >> "CfgGroups" >> "East" >> "LOP_AM_OPF" >> "Motorized" >> "LOP_AM_OPF_Motor_squad_LR",
        ["LOP_AM_OPF_BTR60"],
        ["LOP_AM_OPF_Landrover_M2"],
        ["LOP_AM_OPF_Nissan_PKM"],
        ["LOP_AM_OPF_UAZ_DshKM"]
        ]
};


if (_faction == "LOP_ChDKZ") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "East" >> "LOP_ChDKZ" >> "Infantry" >> "LOP_ChDKZ_Rifle_squad",
        configfile >> "CfgGroups" >> "East" >> "LOP_ChDKZ" >> "Infantry" >> "LOP_ChDKZ_AT_section",
        configfile >> "CfgGroups" >> "East" >> "LOP_ChDKZ" >> "Infantry" >> "LOP_ChDKZ_Support_section",
        configfile >> "CfgGroups" >> "East" >> "LOP_ChDKZ" >> "Mechanized" >> "LOP_ChDKZ_Mech_squad_BMP2",
        configfile >> "CfgGroups" >> "East" >> "LOP_ChDKZ" >> "Motorized" >> "LOP_ChDKZ_Moto_Squad_btr70",
        configfile >> "CfgGroups" >> "East" >> "LOP_ChDKZ" >> "Motorized" >> "LOP_ChDKZ_Moto_Squad_uazopen",
        configfile >> "CfgGroups" >> "East" >> "LOP_ChDKZ" >> "Armored" >> "LOP_ChDKZ_T72BB_Platoon",
        configfile >> "CfgGroups" >> "East" >> "LOP_ChDKZ" >> "Armored" >> "LOP_ChDKZ_BTR_Combined_Platoon"
        ]
};

if (_faction == "LOP_IRA") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "East" >> "LOP_IRA" >> "Infantry" >> "LOP_IRA_RifleSquad",
        configfile >> "CfgGroups" >> "East" >> "LOP_IRA" >> "Infantry" >> "LOP_IRA_Fireteam",
        configfile >> "CfgGroups" >> "East" >> "LOP_IRA" >> "Infantry" >> "LOP_IRA_ATTeam",
        configfile >> "CfgGroups" >> "East" >> "LOP_IRA" >> "Motorized" >> "LOP_IRA_ArmedLRGroup",
        configfile >> "CfgGroups" >> "East" >> "LOP_IRA" >> "Motorized" >> "LOP_IRA_ArmedOffroadGroup",
        configfile >> "CfgGroups" >> "East" >> "LOP_IRA" >> "Motorized" >> "LOP_IRA_LRPatrol"
        ]
};

if (_faction == "LOP_ISTS_OPF") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "East" >> "LOP_ISTS_OPF" >> "Infantry" >> "PO_ISTS_OPF_inf_WEAP_SQ",
        configfile >> "CfgGroups" >> "East" >> "LOP_ISTS_OPF" >> "Infantry" >> "PO_ISTS_OPF_inf_WEAP_SEC",
        configfile >> "CfgGroups" >> "East" >> "LOP_ISTS_OPF" >> "Infantry" >> "PO_ISTS_OPF_inf_Weapon_ft",
        ["LOP_ISTS_OPF_BMP2"],
        ["LOP_ISTS_OPF_Landrover_M2"],
        ["LOP_ISTS_OPF_T55"]
        ]
};

if (_faction == "LOP_SLA") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "East" >> "LOP_SLA" >> "Infantry" >> "LOP_SLA_Rifle_squad",
        configfile >> "CfgGroups" >> "East" >> "LOP_SLA" >> "Infantry" >> "LOP_SLA_AA_section",
        configfile >> "CfgGroups" >> "East" >> "LOP_SLA" >> "Infantry" >> "LOP_SLA_AT_section",
        configfile >> "CfgGroups" >> "East" >> "LOP_SLA" >> "Infantry" >> "LOP_SLA_Support_section",
        configfile >> "CfgGroups" >> "East" >> "LOP_SLA" >> "Mechanized" >> "LOP_SLA_Mech_squad_BMP2",
        configfile >> "CfgGroups" >> "East" >> "LOP_SLA" >> "Mechanized" >> "LOP_SLA_Mech_squad_BMP1",
        configfile >> "CfgGroups" >> "East" >> "LOP_SLA" >> "Armored" >> "LOP_SLA_T72BB_Platoon",
        configfile >> "CfgGroups" >> "East" >> "LOP_SLA" >> "Armored" >> "LOP_SLA_BTR_Combined_Platoon"
        ]
};

if (_faction == "LOP_SLA") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "East" >> "LOP_US" >> "Infantry" >> "LOP_US_Rifle_squad",
        configfile >> "CfgGroups" >> "East" >> "LOP_US" >> "Infantry" >> "LOP_US_Support_section",
        configfile >> "CfgGroups" >> "East" >> "LOP_US" >> "Infantry" >> "LOP_US_FT_section",
        configfile >> "CfgGroups" >> "East" >> "LOP_US" >> "Infantry" >> "LOP_US_AT_section",
        configfile >> "CfgGroups" >> "East" >> "LOP_US" >> "Infantry" >> "LOP_US_AA_section",
        configfile >> "CfgGroups" >> "East" >> "LOP_US" >> "Mechanized" >> "LOP_US_Mech_squad_BMP1",
        configfile >> "CfgGroups" >> "East" >> "LOP_US" >> "Mechanized" >> "LOP_US_Mech_squad_BMP2",
        configfile >> "CfgGroups" >> "East" >> "LOP_US" >> "Motorized" >> "LOP_US_MotInf_Team_BTR70",
        configfile >> "CfgGroups" >> "East" >> "LOP_US" >> "Motorized" >> "LOP_US_MotInf_Team_BTR60",
        configfile >> "CfgGroups" >> "East" >> "LOP_US" >> "Motorized" >> "LOP_US_MotInf_Team",
        configfile >> "CfgGroups" >> "East" >> "LOP_US" >> "Armored" >> "LOP_US_T72_Platoon"
        ]
};

if (_faction == "OPTRE_Ins") then {

    _Pool = 
        [
        configfile >> "CfgGroups" >> "East" >> "OPTRE_Ins" >> "Infantry_ER" >> "OPTRE_Ins_ER_Inf_MSquad",
        configfile >> "CfgGroups" >> "East" >> "OPTRE_Ins" >> "Infantry_ER" >> "OPTRE_Ins_ER_Inf_Group",
        configfile >> "CfgGroups" >> "East" >> "OPTRE_Ins" >> "Infantry_URF" >> "OPTRE_Ins_URF_Inf_AntiTank",
        configfile >> "CfgGroups" >> "East" >> "OPTRE_Ins" >> "Infantry_URF" >> "OPTRE_Ins_URF_Inf_RifleSquad",
        configfile >> "CfgGroups" >> "East" >> "OPTRE_Ins" >> "Infantry_URF" >> "OPTRE_Ins_URF_Inf_AntiAir"
        ]
};

if (isNil "_sidetickHold") then 
    {
        _sidetickHold = 0;
    };

if (isNil "_sideEn") then 
    {
        _sideEn = civilian;
    };
if (isNil "_sideEn2") then 
    {
        _sideEn2 = civilian;
    };

//if ((_HalReinf isEqualTo "KillSwitch") or (_HalReinf isEqualTo "ReCapture")) then 
//{
if (_sideEn == civilian) then {
    if ((_sideEn == civilian) and ([west, _side] call BIS_fnc_sideIsEnemy)) then 
    {
        _sideEn = west;
    }; 
    if ((_sideEn == civilian) and ([east, _side] call BIS_fnc_sideIsEnemy)) then 
    {
        _sideEn = east;
    }; 
    if ((_sideEn == civilian) and ([resistance, _side] call BIS_fnc_sideIsEnemy)) then 
    {
        _sideEn = resistance;
    }; 
    if (_sideEn == civilian) then {_sideEn = sideEnemy};
};

if (_sideEn2 == civilian) then {
    if ((_sideEn2 == civilian) and not (_sideEn == west) and ([west, _side] call BIS_fnc_sideIsEnemy)) then 
    {
        _sideEn2 = west;
    }; 
    if ((_sideEn2 == civilian) and not (_sideEn == east) and ([east, _side] call BIS_fnc_sideIsEnemy)) then 
    {
        _sideEn2 = east;
    }; 
    if ((_sideEn2 == civilian) and not (_sideEn == resistance) and ([resistance, _side] call BIS_fnc_sideIsEnemy)) then 
    {
        _sideEn2 = resistance;
    }; 
    if (_sideEn2 == civilian) then {_sideEn2 = _sideEn};
};
//};


if (_SpawnMode) exitwith {
    for "_i" from 1 to _rStrgt do
        {

        waitUntil {sleep 1; not ({_x distance (_SpawnPos select 0) < _playerRange} count allplayers > 0)};
        
        [_SpawnPos,_SpawnRadius,_side,_Pool,_Leaders,nil,(_logic getVariable ["_ExtraArgs",""])] call SpawnRGroup;

        };
        
    };

sleep 20;

_StartForces = (_side countSide allUnits);
sleep 20;

private _counter = _side countSide allUnits;

if ((not (_Objsource == _logic)) or (1 == (count _Commanders))) then {
    sleep 20;
    _Leaders = _Commanders;
    {
        if ((side _x) == _side) then {
            _CrrFr = [];
            waitUntil {sleep 5; ((count ((group _x) getvariable ["RydHQ_Friends",[]])) > 0)};
            private _StrtForces = (group _x) getvariable ["RydHQ_Friends",[]];
            {
                {_CrrFr pushBackUnique _x} foreach (units _x);
            } foreach _StrtForces;
            _StartForces = (count _CrrFr);
        };
                    
    } foreach _Commanders;
} else {
    while {_StartForces < _counter} do 
    {
        _StartForces = (_side countSide allUnits);
        sleep 20;
        _counter = _side countSide allUnits;
    };
};

while {true} do 

    {

    _sidetick = _logic getvariable ["_sidetick",0];
    
    _CanSpawn = true;

    _CurrentForces = (_side countSide allUnits);

    if not (isNil "_ObjSource") then {
        if (_ObjSource getvariable ["CanSpawn",true]) then {
            _CanSpawn = true;
            if not (_Objsource == _logic) then {
                {
                    if ((side _x) == _side) then {
                        _CrrFr = [];
                        _CurrentForces = (((group _x) getvariable ["RydHQ_Friends",[]]) + ((group _x) getvariable ["RydHQ_Included",[]]));
                        {
                            {if (alive _x) then {_CrrFr pushBackUnique _x}} foreach (units _x);
                        } foreach _CurrentForces;
                        _CurrentForces = (count _CrrFr);
                        if ((_Objsource in ((group _x) getvariable ["RydHQ_Taken",[]])) and not ((_sideEn countSide ((_SpawnPos select 0) nearEntities _playerRange) > 0) or (_sideEn2 countSide ((_SpawnPos select 0) nearEntities _playerRange) > 0))) then {_CanSpawn = true} else {_CanSpawn = false};
                    };
                    
                } foreach _Commanders;
            };
        } else {
            _CanSpawn = false;
        };
    };

    if ((_HalReinf isEqualTo "KillSwitch") and ({_x distance (_SpawnPos select 0) < _playerRange} count allplayers > 0) and (_side countSide ((_SpawnPos select 0) nearEntities _playerRange) == 0)) then 
    {
        _sidetick = 0;
    };

    if ((_HalReinf isEqualTo "ReCapture") and (_sidetick != 0) and ((_sideEn countSide ((_SpawnPos select 0) nearEntities _playerRange) > 0) or (_sideEn2 countSide ((_SpawnPos select 0) nearEntities _playerRange) > 0)) and (_side countSide ((_SpawnPos select 0) nearEntities _playerRange) == 0)) then 
    {
        if (_sidetick > 0) then 
        {
            _sidetickHold = _sidetick;
        };
        _sidetick = 0;
    };
    if ((_HalReinf isEqualTo "ReCapture") and (_sidetickHold != 0) and (_sideEn countSide ((_SpawnPos select 0) nearEntities _playerRange) == 0) and (_sideEn2 countSide ((_SpawnPos select 0) nearEntities _playerRange) == 0) and (_side countSide ((_SpawnPos select 0) nearEntities _playerRange) > 0)) then 
    {
        if (_sidetick == 0) then 
        {
            _sidetick = _sidetickHold;
        };
        _sidetickHold = 0; 
    };

//    _CurrentForces = (_side countSide allUnits);

    if (((_CurrentForces) < (_Threshold*_StartForces)) and (not ({(_x distance (_SpawnPos select 0) < _playerRange)} count allplayers > 0) or (_playerFriend)) and (_CanSpawn)) then 
        {
        for "_i" from 1 to _rStrgt do
            {
            if (_sidetick > 0) then {

                if (isNil "_RejoinPoint") then {
                    [_SpawnPos,_SpawnRadius,_side,_Pool,_Leaders,nil,(_logic getVariable ["_ExtraArgs",""])] call SpawnRGroup;
                } else {
                    [_SpawnPos,_SpawnRadius,_side,_Pool,_Leaders,_RejoinPoint,(_logic getVariable ["_ExtraArgs",""])] call SpawnRGroup;
                };
                _sidetick = (_sidetick - 1);
                _logic setvariable ["_sidetick",_sidetick];
                
            };

            _Threshold = (_Threshold - _ThresholdDecay);
            
            sleep 3;
            };
        };
    if ((_sidetick <= 0) and (_sidetickHold <= 0)) exitwith {};
    sleep (random [5,7,15]);
    };