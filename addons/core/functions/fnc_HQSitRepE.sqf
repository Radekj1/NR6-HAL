#include "..\script_component.hpp"
params ["_HQ"];

_HQ setVariable ["leaderHQ",(leader _HQ)];
_csN = +RydHQ_CallSignsN;

{
	_nouns = [_x] call FUNC(RandomOrderB);
	_csN set [_foreachIndex,_nouns]
} forEach _csN;

_HQ setVariable ["RydHQ_CallSignsN",_csN];
_HQ setVariable ["RydHQ_Cyclecount",0];
_cycleC = 0;

if (isNil ("RydHQE_MAtt")) then {RydHQE_MAtt = false};
_HQ setVariable ["RydHQ_MAtt",RydHQE_MAtt];
if ((isNil ("RydHQE_Personality")) or not (_HQ getVariable ["RydHQ_MAtt",false])) then {RydHQE_Personality = "OTHER"};
_HQ setVariable ["RydHQ_Personality",RydHQE_Personality];
	
if (isNil ("RydHQE_Recklessness")) then {RydHQE_Recklessness = 0.5};
_HQ setVariable ["RydHQ_Recklessness",RydHQE_Recklessness];
if (isNil ("RydHQE_Consistency")) then {RydHQE_Consistency = 0.5};
_HQ setVariable ["RydHQ_Consistency",RydHQE_Consistency];
if (isNil ("RydHQE_Activity")) then {RydHQE_Activity = 0.5};
_HQ setVariable ["RydHQ_Activity",RydHQE_Activity];
if (isNil ("RydHQE_Reflex")) then {RydHQE_Reflex = 0.5};
_HQ setVariable ["RydHQ_Reflex",RydHQE_Reflex];
if (isNil ("RydHQE_Circumspection")) then {RydHQE_Circumspection = 0.5};
_HQ setVariable ["RydHQ_Circumspection",RydHQE_Circumspection];
if (isNil ("RydHQE_Fineness")) then {RydHQE_Fineness = 0.5};
_HQ setVariable ["RydHQ_Fineness",RydHQE_Fineness];

[_HQ] call FUNC(personality);

[[_HQ],HAL_LHQ] call FUNC(spawn);

if (isNil ("RydHQE_Boxed")) then {RydHQE_Boxed = []};
_HQ setVariable ["RydHQ_Boxed",RydHQE_Boxed];

if (isNil ("RydHQE_AmmoBoxes")) then 
	{
	RydHQE_AmmoBoxes = [];

	if !(isNil "RydHQE_AmmoDepot") then 
		{
		_rds = (triggerArea RydHQE_AmmoDepot) select 0;
		RydHQE_AmmoBoxes = (getPosATL RydHQE_AmmoDepot) nearObjects ["ReammoBox_F",_rds]
		}
	};
	
_HQ setVariable ["RydHQ_AmmoBoxes",RydHQE_AmmoBoxes];

_HQ setVariable ["RydHQ_ReconDone",false];
_HQ setVariable ["RydHQ_DefDone",false];
_HQ setVariable ["RydHQ_ReconStage",1];
_HQ setVariable ["RydHQ_ReconStage2",1];
_HQ setVariable ["RydHQ_AirInDef",[]];

_KnEnPos = [];

if (isNil ("RydHQE_Excluded")) then {RydHQE_Excluded = []};
_HQ setVariable ["RydHQ_Excluded",RydHQE_Excluded];
if (isNil ("RydHQE_Fast")) then {RydHQE_Fast = false};
_HQ setVariable ["RydHQ_Fast",RydHQE_Fast];
if (isNil ("RydHQE_ExInfo")) then {RydHQE_ExInfo = false};
_HQ setVariable ["RydHQ_ExInfo",RydHQE_ExInfo];
if (isNil ("RydHQE_ObjHoldTime")) then {RydHQE_ObjHoldTime = 600};
_HQ setVariable ["RydHQ_ObjHoldTime",RydHQE_ObjHoldTime];
if (isNil "RydHQE_NObj") then {RydHQE_NObj = 1};
_HQ setVariable ["RydHQ_NObj",RydHQE_NObj];

_HQ setVariable ["RydHQ_Init",true];

_HQ setVariable ["RydHQ_Inertia",0];
_HQ setVariable ["RydHQ_Morale",0];
_HQ setVariable ["RydHQ_CInitial",0];
_HQ setVariable ["RydHQ_CLast",0];
_HQ setVariable ["RydHQ_CCurrent",0];
_HQ setVariable ["RydHQ_CIMoraleC",0];
_HQ setVariable ["RydHQ_CLMoraleC",0];
_HQ setVariable ["RydHQ_Surrender",false];

_HQ setVariable ["RydHQ_FirstEMark",true];
_HQ setVariable ["RydHQ_LastE",0];
_HQ setVariable ["RydHQ_FlankingInit",false];
_HQ setVariable ["RydHQ_FlankingDone",false];
_HQ setVariable ["RydHQ_Progress",0];

_HQ setVariable ["RydHQ_AAthreat",[]];
_HQ setVariable ["RydHQ_ATthreat",[]];
_HQ setVariable ["RydHQ_Airthreat",[]];
_HQ setVariable ["RydHQ_Exhausted",[]];

if (isNil ("RydHQE_SupportWP")) then {RydHQE_SupportWP = false};
	
_HQ setVariable ["RydHQ_SupportWP",RydHQE_SupportWP];

_lastHQ = _HQ getVariable ["leaderHQ",objNull];
_OLmpl = 0;
_cycleCap = 0;
_firstMC = 0; 
_wp = [];
_lastReset = 0;
_HQlPos = [-10,-10,0];
_cInitial = 0;

while {true} do
	{
	
	if (RydxHQ_RHQAutoFill) then
	{
	[] call FUNC(Ryd_PresentRHQ)
	};
	
	_specFor_class = RHQ_SpecFor + RYD_WS_specFor_class - RHQs_SpecFor;

	_recon_class = RHQ_Recon + RYD_WS_recon_class - RHQs_Recon;
		
	_FO_class = RHQ_FO + RYD_WS_FO_class - RHQs_FO;
		
	_snipers_class = RHQ_Snipers + RYD_WS_snipers_class - RHQs_Snipers;
		
	_ATinf_class = RHQ_ATInf + RYD_WS_ATinf_class - RHQs_ATInf;
		
	_AAinf_class = RHQ_AAInf + RYD_WS_AAinf_class - RHQs_AAInf;

	_Inf_class = RHQ_Inf + RYD_WS_Inf_class - RHQs_Inf;
		
	_Art_class = RHQ_Art + RYD_WS_Art_class - RHQs_Art;
		
	_HArmor_class = RHQ_HArmor + RYD_WS_HArmor_class - RHQs_HArmor;
		
	_MArmor_class = RHQ_MArmor + RYD_WS_MArmor_class - RHQs_MArmor;

	_LArmor_class = RHQ_LArmor + RYD_WS_LArmor_class - RHQs_LArmor;
		
	_LArmorAT_class = RHQ_LArmorAT + RYD_WS_LArmorAT_class - RHQs_LArmorAT;

	_Cars_class = RHQ_Cars + RYD_WS_Cars_class - RHQs_Cars;
		
	_Air_class = RHQ_Air + RYD_WS_Air_class - RHQs_Air;
		
	_BAir_class = RHQ_BAir + RYD_WS_BAir_class - RHQs_BAir;
		
	_RAir_class = RHQ_RAir + RYD_WS_RAir_class - RHQs_RAir;
		
	_NCAir_class = RHQ_NCAir + RYD_WS_NCAir_class - RHQs_NCAir;

	_Naval_class = RHQ_Naval + RYD_WS_Naval_class - RHQs_Naval;

	_Static_class = RHQ_Static + RYD_WS_Static_class - RHQs_Static;
		
	_StaticAA_class = RHQ_StaticAA + RYD_WS_StaticAA_class - RHQs_StaticAA;
		
	_StaticAT_class = RHQ_StaticAT + RYD_WS_StaticAT_class - RHQs_StaticAT;
		
	_Support_class = RHQ_Support + RYD_WS_Support_class - RHQs_Support;
		
	_Cargo_class = RHQ_Cargo + RYD_WS_Cargo_class - RHQs_Cargo;
		
	_NCCargo_class = RHQ_NCCargo + RYD_WS_NCCargo_class - RHQs_NCCargo;
		
	_Crew_class = RHQ_Crew + RYD_WS_Crew_class - RHQs_Crew;
		
	_Other_class = RHQ_Other + RYD_WS_Other_class;

	_NCrewInf_class = _Inf_class - _Crew_class;
	_Cargo_class = _Cargo_class - (_Support_class - ["MH60S"]);

	_HQ setVariable ["RydHQ_NCVeh",_NCCargo_class + (_Support_class - ["MH60S"])];

	if (isNull _HQ) exitWith {RydxHQ_AllHQ = RydxHQ_AllHQ - [_HQ]};
	if (({alive _x} count (units _HQ)) == 0) exitWith {RydxHQ_AllHQ = RydxHQ_AllHQ - [_HQ]};
	if (_HQ getVariable ["RydHQ_Surrender",false]) exitWith {RydxHQ_AllHQ = RydxHQ_AllHQ - [_HQ]};
	
	if !(_HQ getVariable ["RydHQ_Fast",false]) then 
		{
			[{[{
			((({(_x getVariable ["RydHQ_Pending",false])} count RydxHQ_AllHQ) == 0) or (_HQ getVariable ["RydHQ_KIA",false]))
			}, 0.1] call CBA_fnc_waitAndExecute;
			}, {}] call CBA_fnc_waitUntilAndExecute;
		};
		
	if (_HQ getVariable ["RydHQ_KIA",false]) exitWith {RydxHQ_AllHQ = RydxHQ_AllHQ - [_HQ]};
	
	_HQ setVariable ["RydHQ_Pending",true];

	if (_cycleC > 1) then
		{
		if (_lastHQ != (_HQ getVariable ["leaderHQ",objNull])) then {[{}, {60 + (random 60)}] call CBA_fnc_waitAndExecute;};
		};
		
	if (_HQ getVariable ["RydHQ_KIA",false]) exitWith {RydxHQ_AllHQ = RydxHQ_AllHQ - [_HQ]};
	
	_lastHQ = (leader _HQ);
	
	_HQ setVariable ["RydHQ_Cyclecount",_cycleC + 1];
	_cycleC = _HQ getVariable ["RydHQ_Cyclecount",1];
	
	_SpecFor = [];
	_recon = [];
	_FO = [];
	_snipers = [];
	_ATinf = [];
	_AAinf = [];
	_Inf = [];
	_Art = [];
	_HArmor = [];
	_MArmor = [];
	_LArmor = [];
	_LArmorAT = [];
	_Cars = [];
	_Air = [];
	_BAir = [];
	_RAir = [];
	_NCAir = [];
	_Naval = [];
	_Static = [];
	_StaticAA = [];
	_StaticAT = [];
	_Support = [];
	_Cargo = [];
	_NCCargo = [];
	_Other = [];
	_Crew = [];
	_NCrewInf = [];

	_SpecForG = [];
	_reconG = [];
	_FOG = [];
	_snipersG = [];
	_ATinfG = [];
	_AAinfG = [];
	_InfG = [];
	_ArtG = [];
	_HArmorG = [];
	_MArmorG = [];
	_LArmorG = [];
	_LArmorATG = [];
	_CarsG = [];
	_AirG = [];
	_BAirG = [];
	_RAirG = [];
	_NCAirG = [];
	_NavalG = [];
	_StaticG = [];
	_StaticAAG = [];
	_StaticATG = [];
	_SupportG = [];
	_CargoG = [];
	_NCCargoG = [];
	_OtherG = [];
	_CrewG = [];
	_NCrewInfG = [];

	_EnSpecFor = [];
	_Enrecon = [];
	_EnFO = [];
	_Ensnipers = [];
	_EnATinf = [];
	_EnAAinf = [];
	_EnInf = [];
	_EnArt = [];
	_EnHArmor = [];
	_EnMArmor = [];
	_EnLArmor = [];
	_EnLArmorAT = [];
	_EnCars = [];
	_EnAir = [];
	_EnBAir = [];
	_EnRAir = [];
	_EnNCAir = [];
	_EnNaval = [];
	_EnStatic = [];
	_EnStaticAA = [];
	_EnStaticAT = [];
	_EnSupport = [];
	_EnCargo = [];
	_EnNCCargo = [];
	_EnOther = [];
	_EnCrew = [];
	_EnNCrewInf = [];

	_EnSpecForG = [];
	_EnreconG = [];
	_EnFOG = [];
	_EnsnipersG = [];
	_EnATinfG = [];
	_EnAAinfG = [];
	_EnInfG = [];
	_EnArtG = [];
	_EnHArmorG = [];
	_EnMArmorG = [];
	_EnLArmorG = [];
	_EnLArmorATG = [];
	_EnCarsG = [];
	_EnAirG = [];
	_EnBAirG = [];
	_EnRAirG = [];
	_EnNCAirG = [];
	_EnNavalG = [];
	_EnStaticG = [];
	_EnStaticAAG = [];
	_EnStaticATG = [];
	_EnSupportG = [];
	_EnCargoG = [];
	_EnNCCargoG = [];
	_EnOtherG = [];
	_EnCrewG = [];
	_EnNCrewInfG = [];

	_HQ setVariable ["RydHQ_LastE",count (_HQ getVariable ["RydHQ_KnEnemies",[]])];
	_HQ setVariable ["RydHQ_LastFriends",_HQ getVariable ["RydHQ_Friends",[]]];
	
	if (isNil "RydHQE_Garrison") then {RydHQE_Garrison = []};
	_HQ setVariable ["RydHQ_Garrison",RydHQE_Garrison];
	
	if (isNil ("RydHQE_NoAirCargo")) then {RydHQE_NoAirCargo = false};
	_HQ setVariable ["RydHQ_NoAirCargo",RydHQE_NoAirCargo];
	if (isNil ("RydHQE_NoLandCargo")) then {RydHQE_NoLandCargo = false};
	_HQ setVariable ["RydHQ_NoLandCargo",RydHQE_NoLandCargo];
	if (isNil ("RydHQE_LastFriends")) then {RydHQE_LastFriends = []};
	_HQ setVariable ["RydHQ_LastFriends",RydHQE_LastFriends];
	if (isNil ("RydHQE_CargoFind")) then {RydHQE_CargoFind = 1};
	_HQ setVariable ["RydHQ_CargoFind",RydHQE_CargoFind];
	if (isNil ("RydHQE_Subordinated")) then {RydHQE_Subordinated = []};
	_HQ setVariable ["RydHQ_Subordinated",RydHQE_Subordinated];
	if (isNil ("RydHQE_Included")) then {RydHQE_Included = []};
	_HQ setVariable ["RydHQ_Included",RydHQE_Included];
	if (isNil ("RydHQE_Excluded")) then {RydHQE_Excluded = []};
	_HQ setVariable ["RydHQ_Excluded",RydHQE_Excluded];
	if (isNil ("RydHQE_SubAll")) then {RydHQE_SubAll = true};
	_HQ setVariable ["RydHQ_SubAll",RydHQE_SubAll];
	if (isNil ("RydHQE_SubSynchro")) then {RydHQE_SubSynchro = false};
	_HQ setVariable ["RydHQ_SubSynchro",RydHQE_SubSynchro];
	if (isNil ("RydHQE_SubNamed")) then {RydHQE_SubNamed = false};
	_HQ setVariable ["RydHQ_SubNamed",RydHQE_SubNamed];
	if (isNil ("RydHQE_SubZero")) then {RydHQE_SubZero = false};
	_HQ setVariable ["RydHQ_SubZero",RydHQE_SubZero];
	if (isNil ("RydHQE_ReSynchro")) then {RydHQE_ReSynchro = true};
	_HQ setVariable ["RydHQ_ReSynchro",RydHQE_ReSynchro];
	if (isNil ("RydHQE_NameLimit")) then {RydHQE_NameLimit = 100};
	_HQ setVariable ["RydHQ_NameLimit",RydHQE_NameLimit];
	if (isNil ("RydHQE_Surr")) then {RydHQE_Surr = false};
	_HQ setVariable ["RydHQ_Surr",RydHQE_Surr];
	if (isNil ("RydHQE_NoRecon")) then {RydHQE_NoRecon = []};
	_HQ setVariable ["RydHQ_NoRecon",RydHQE_NoRecon];
	if (isNil ("RydHQE_NoAttack")) then {RydHQE_NoAttack = []};
	_HQ setVariable ["RydHQ_NoAttack",RydHQE_NoAttack];
	if (isNil ("RydHQE_CargoOnly")) then {RydHQE_CargoOnly = []};
	_HQ setVariable ["RydHQ_CargoOnly",RydHQE_CargoOnly];
	if (isNil ("RydHQE_NoCargo")) then {RydHQE_NoCargo = []};
	_HQ setVariable ["RydHQ_NoCargo",RydHQE_NoCargo];
	if (isNil ("RydHQE_NoFlank")) then {RydHQE_NoFlank = []};
	_HQ setVariable ["RydHQ_NoFlank",RydHQE_NoFlank];
	if (isNil ("RydHQE_NoDef")) then {RydHQE_NoDef = []};
	_HQ setVariable ["RydHQ_NoDef",RydHQE_NoDef];
	if (isNil ("RydHQE_FirstToFight")) then {RydHQE_FirstToFight = []};
	_HQ setVariable ["RydHQ_FirstToFight",RydHQE_FirstToFight];
	if (isNil ("RydHQE_VoiceComm")) then {RydHQE_VoiceComm = true};
	_HQ setVariable ["RydHQ_VoiceComm",RydHQE_VoiceComm];
	if (isNil ("RydHQE_FrontA")) then {RydHQE_Front = false};
	_HQ setVariable ["RydHQ_FrontA",RydHQE_Front];
	if (isNil ("RydHQE_LRelocating")) then {RydHQE_LRelocating = false};
	_HQ setVariable ["RydHQ_LRelocating",RydHQE_LRelocating];
	if (isNil ("RydHQE_Flee")) then {RydHQE_Flee = true};
	_HQ setVariable ["RydHQ_Flee",RydHQE_Flee];
	if (isNil ("RydHQE_GarrR")) then {RydHQE_GarrR = 500};
	_HQ setVariable ["RydHQ_GarrR",RydHQE_GarrR];
	if (isNil ("RydHQE_Rush")) then {RydHQE_Rush = false};
	_HQ setVariable ["RydHQ_Rush",RydHQE_Rush];
	if (isNil ("RydHQE_GarrVehAb")) then {RydHQE_GarrVehAb = false};
	_HQ setVariable ["RydHQ_GarrVehAb",RydHQE_GarrVehAb];
	if (isNil ("RydHQE_DefendObjectives")) then {RydHQE_DefendObjectives = 4};
	_HQ setVariable ["RydHQ_DefendObjectives",RydHQE_DefendObjectives];
	if (isNil ("RydHQE_DefSpot")) then {RydHQE_DefSpot = []};
	_HQ setVariable ["RydHQ_DefSpot",RydHQE_DefSpot];
	if (isNil ("RydHQE_RecDefSpot")) then {RydHQE_RecDefSpot = []};
	_HQ setVariable ["RydHQ_RecDefSpot",RydHQE_RecDefSpot];
	if (isNil "RydHQE_Flare") then {RydHQE_Flare = true};
	_HQ setVariable ["RydHQ_Flare",RydHQE_Flare];
	if (isNil "RydHQE_Smoke") then {RydHQE_Smoke = true};
	_HQ setVariable ["RydHQ_Smoke",RydHQE_Smoke];
	if (isNil "RydHQE_NoRec") then {RydHQE_NoRec = 1};
	_HQ setVariable ["RydHQ_NoRec",RydHQE_NoRec];
	if (isNil "RydHQE_RapidCapt") then {RydHQE_RapidCapt = 10};
	_HQ setVariable ["RydHQ_RapidCapt",RydHQE_RapidCapt];
	if (isNil "RydHQE_Muu") then {RydHQE_Muu = 1};
	_HQ setVariable ["RydHQ_Muu",RydHQE_Muu];
	if (isNil "RydHQE_ArtyShells") then {RydHQE_ArtyShells = 1};
	_HQ setVariable ["RydHQ_ArtyShells",RydHQE_ArtyShells];
	if (isNil "RydHQE_Withdraw") then {RydHQE_Withdraw = 1};
	_HQ setVariable ["RydHQ_Withdraw",RydHQE_Withdraw];
	if (isNil "RydHQE_Berserk") then {RydHQE_Berserk = false};
	_HQ setVariable ["RydHQ_Berserk",RydHQE_Berserk];
	if (isNil "RydHQE_IDChance") then {RydHQE_IDChance = 100};
	_HQ setVariable ["RydHQ_IDChance",RydHQE_IDChance];
	if (isNil "RydHQE_RDChance") then {RydHQE_RDChance = 100};
	_HQ setVariable ["RydHQ_RDChance",RydHQE_RDChance];
	if (isNil "RydHQE_SDChance") then {RydHQE_SDChance = 100};
	_HQ setVariable ["RydHQ_SDChance",RydHQE_SDChance];
	if (isNil "RydHQE_AmmoDrop") then {RydHQE_AmmoDrop = []};
	_HQ setVariable ["RydHQ_AmmoDrop",RydHQE_AmmoDrop];
	if (isNil "RydHQE_SFTargets") then {RydHQE_SFTargets = []};
	_HQ setVariable ["RydHQ_SFTargets",RydHQE_SFTargets];
	if (isNil "RydHQE_LZ") then {RydHQE_LZ = false};
	_HQ setVariable ["RydHQ_LZ",RydHQE_LZ];
	if (isNil "RydHQE_SFBodyGuard") then {RydHQE_SFBodyGuard = []};
	_HQ setVariable ["RydHQ_SFBodyGuard",RydHQE_SFBodyGuard];
	if (isNil "RydHQE_DynForm") then {RydHQE_DynForm = false};
	_HQ setVariable ["RydHQ_DynForm",RydHQE_DynForm];
	if (isNil "RydHQE_UnlimitedCapt") then {RydHQE_UnlimitedCapt = false};
	_HQ setVariable ["RydHQ_UnlimitedCapt",RydHQE_UnlimitedCapt];
	if (isNil "RydHQE_CaptLimit") then {RydHQE_CaptLimit = 10};
	_HQ setVariable ["RydHQ_CaptLimit",RydHQE_CaptLimit];
	if (isNil "RydHQE_GetHQInside") then {RydHQE_GetHQInside = false};
	_HQ setVariable ["RydHQ_GetHQInside",RydHQE_GetHQInside];
	if (isNil "RydHQE_WA") then {RydHQE_WA = true};
	_HQ setVariable ["RydHQ_WA",RydHQE_WA];

	if (isNil "RydHQE_InfoMarkers") then {RydHQE_InfoMarkers = false};
	_HQ setVariable ["RydHQ_InfoMarkers",RydHQE_InfoMarkers];

	if (isNil "RydHQE_ArtyMarks") then {RydHQE_ArtyMarks = false};
	_HQ setVariable ["RydHQ_ArtyMarks",RydHQE_ArtyMarks];

	if (isNil ("RydHQE_ResetNow")) then {RydHQE_ResetNow = false};
	_HQ setVariable ["RydHQ_ResetNow",RydHQE_ResetNow];
	if (isNil ("RydHQE_ResetOnDemand")) then {RydHQE_ResetOnDemand = false};
	_HQ setVariable ["RydHQ_ResetOnDemand",RydHQE_ResetOnDemand];
	if (isNil ("RydHQE_ResetTime")) then {RydHQE_ResetTime = 600};
	_HQ setVariable ["RydHQ_ResetTime",RydHQE_ResetTime];
	if (isNil ("RydHQE_Combining")) then {RydHQE_Combining = false};
	_HQ setVariable ["RydHQ_Combining",RydHQE_Combining];
	if (isNil ("RydHQE_ObjRadius1")) then {RydHQE_ObjRadius1 = 300};
	_HQ setVariable ["RydHQ_ObjRadius1",RydHQE_ObjRadius1];
	if (isNil ("RydHQE_ObjRadius2")) then {RydHQE_ObjRadius2 = 500};
	_HQ setVariable ["RydHQ_ObjRadius2",RydHQE_ObjRadius2];
	if (isNil ("RydHQE_KnowTL")) then {RydHQE_KnowTL = true};
	_HQ setVariable ["RydHQ_KnowTL",RydHQE_KnowTL];
	
	if (isNil ("RydHQE_SMed")) then {RydHQE_SMed = true};
	_HQ setVariable ["RydHQ_SMed",RydHQE_SMed];
	if (isNil ("RydHQE_ExMedic")) then {RydHQE_ExMedic = []};
	_HQ setVariable ["RydHQ_ExMedic",RydHQE_ExMedic];
	if (isNil ("RydHQE_MedPoints")) then {RydHQE_MedPoints = []};
	_HQ setVariable ["RydHQ_MedPoints",RydHQE_MedPoints];
	if (isNil ("RydHQE_SupportedG")) then {RydHQE_SupportedG = []};
	_HQ setVariable ["RydHQ_SupportedG",RydHQE_SupportedG];

	if (isNil ("RydHQE_RCASB")) then {RydHQE_RCAS = []};
	_HQ setVariable ["RydHQ_RCAS",RydHQE_RCAS];
	if (isNil ("RydHQE_RCAPB")) then {RydHQE_RCAP = []};
	_HQ setVariable ["RydHQ_RCAP",RydHQE_RCAP];
	
	if (isNil ("RydHQE_SFuel")) then {RydHQE_SFuel = true};
	_HQ setVariable ["RydHQ_SFuel",RydHQE_SFuel];
	if (isNil ("RydHQE_ExRefuel")) then {RydHQE_ExRefuel = []};
	_HQ setVariable ["RydHQ_ExRefuel",RydHQE_ExRefuel];
	if (isNil ("RydHQE_FuelPoints")) then {RydHQE_FuelPoints = []};
	_HQ setVariable ["RydHQ_FuelPoints",RydHQE_FuelPoints];
	if (isNil ("RydHQE_FSupportedG")) then {RydHQE_FSupportedG = []};
	_HQ setVariable ["RydHQ_FSupportedG",RydHQE_FSupportedG];
	
	if (isNil ("RydHQE_SAmmo")) then {RydHQE_SAmmo = true};
	_HQ setVariable ["RydHQ_SAmmo",RydHQE_SAmmo];
	if (isNil ("RydHQE_ExReammo")) then {RydHQE_ExReammo = []};
	_HQ setVariable ["RydHQ_ExReammo",RydHQE_ExReammo];
	if (isNil ("RydHQE_AmmoPoints")) then {RydHQE_AmmoPoints = []};
	_HQ setVariable ["RydHQ_AmmoPoints",RydHQE_AmmoPoints];
	if (isNil ("RydHQE_ASupportedG")) then {RydHQE_ASupportedG = []};
	_HQ setVariable ["RydHQ_ASupportedG",RydHQE_ASupportedG];
	
	if (isNil ("RydHQE_SRep")) then {RydHQE_SRep = true};
	_HQ setVariable ["RydHQ_SRep",RydHQE_SRep];
	if (isNil ("RydHQE_ExRepair")) then {RydHQE_ExRepair = []};
	_HQ setVariable ["RydHQ_ExRepair",RydHQE_ExRepair];
	if (isNil ("RydHQE_RepPoints")) then {RydHQE_RepPoints = []};
	_HQ setVariable ["RydHQ_RepPoints",RydHQE_RepPoints];
	if (isNil ("RydHQE_RSupportedG")) then {RydHQE_RSupportedG = []};
	_HQ setVariable ["RydHQ_RSupportedG",RydHQE_RSupportedG];
	
	if (isNil "RydHQE_AirDist") then {RydHQE_AirDist = 4000};
	_HQ setVariable ["RydHQ_AirDist",RydHQE_AirDist];
	
	if (isNil ("RydHQE_CommDelay")) then {RydHQE_CommDelay = 1};
	_HQ setVariable ["RydHQ_CommDelay",RydHQE_CommDelay];


	if ((isNil ("RydHQE_Order")) and (isNil {_HQ getVariable "RydHQ_Order"})) then {_HQ setVariable ["RydHQ_Order","ATTACK"]};
	if ( not (isNil ("RydHQE_Order"))) then {
		if (RydHQE_Order == "DEFEND") then {
			_HQ setVariable ["RydHQ_Order","DEFEND"]
		} else {
			_HQ setVariable ["RydHQ_Order","ATTACK"]
		};
	};

	if (isNil ("RydHQE_AttackAlways")) then {RydHQE_AttackAlways = false};
	_HQ setVariable ["RydHQ_AttackAlways",RydHQE_AttackAlways];

	if (isNil ("RydHQE_CRDefRes")) then {RydHQE_CRDefRes = 0};
	_HQ setVariable ["RydHQ_CRDefRes",RydHQE_CRDefRes];


	if (isNil ("RydHQE_ReconReserve")) then {RydHQE_ReconReserve = (0.3 * (0.5 + (_HQ getVariable ["RydHQ_Circumspection",0.5])))};
	_HQ setVariable ["RydHQ_ReconReserve",RydHQE_ReconReserve];
	if (isNil ("RydHQE_Exhausted")) then {RydHQE_Exhausted = []};
	_HQ setVariable ["RydHQ_Exhausted",RydHQE_Exhausted];
	if (isNil ("RydHQE_AttackReserve")) then {RydHQE_AttackReserve = (0.5 * (0.5 + ((_HQ getVariable ["RydHQ_Circumspection",0.5])/1.5)))};
	_HQ setVariable ["RydHQ_AttackReserve",RydHQE_AttackReserve];
	if (isNil ("RydHQE_IdleOrd")) then {RydHQE_IdleOrd = true};
	_HQ setVariable ["RydHQ_IdleOrd",RydHQE_IdleOrd];

	if (isNil ("RydHQE_IdleDef")) then {RydHQE_IdleDef = true};
	_HQ setVariable ["RydHQ_IdleDef",RydHQE_IdleDef];

	if (isNil "RydHQE_IdleDecoy") then {RydHQE_IdleDecoy = objNull};
	_HQ setVariable ["RydHQ_IdleDecoy",RydHQE_IdleDecoy]; 
	if (isNil "RydHQE_SupportDecoy") then {RydHQE_SupportDecoy = objNull};
	_HQ setVariable ["RydHQ_SupportDecoy",RydHQE_SupportDecoy]; 
	if (isNil "RydHQE_RestDecoy") then {RydHQE_RestDecoy = objNull};
	_HQ setVariable ["RydHQ_RestDecoy",RydHQE_RestDecoy]; 
	if (isNil "RydHQE_Sec1") then {RydHQE_Sec1 = objNull};
	_HQ setVariable ["RydHQ_Sec1",RydHQE_Sec1]; 
	if (isNil "RydHQE_Sec2") then {RydHQE_Sec2 = objNull};
	_HQ setVariable ["RydHQ_Sec2",RydHQE_Sec2];

	if (isNil "RydHQE_SupportRTB") then {RydHQE_SupportRTB = false};
	_HQ setVariable ["RydHQ_SupportRTB",RydHQE_SupportRTB];
	
	if (isNil "RydHQE_Debug") then {RydHQE_Debug = false};
	_HQ setVariable ["RydHQ_Debug",RydHQE_Debug]; 
	if (isNil "RydHQE_DebugII") then {RydHQE_DebugII = false};
	_HQ setVariable ["RydHQ_DebugII",RydHQE_DebugII]; 
	
	if (isNil "RydHQE_AlwaysKnownU") then {RydHQE_AlwaysKnownU = []};
	_HQ setVariable ["RydHQ_AlwaysKnownU",RydHQE_AlwaysKnownU]; 
	if (isNil "RydHQE_AlwaysUnKnownU") then {RydHQE_AlwaysUnKnownU = []};
	_HQ setVariable ["RydHQ_AlwaysUnKnownU",RydHQE_AlwaysUnKnownU]; 
	
	if (isNil "RydHQE_AOnly") then {RydHQE_AOnly = []};
	_HQ setVariable ["RydHQ_AOnly",RydHQE_AOnly]; 
	if (isNil "RydHQE_ROnly") then {RydHQE_ROnly = []};
	_HQ setVariable ["RydHQ_ROnly",RydHQE_ROnly]; 
	
	if (isNil "RydHQE_AirEvac") then {RydHQE_AirEvac = false};
	_HQ setVariable ["RydHQ_AirEvac",RydHQE_AirEvac];
	
	if (isNil "RydHQE_AAO") then {RydHQE_AAO = false};
	_HQ setVariable ["RydHQ_AAO",RydHQE_AAO]; 
	if (isNil "RydHQE_ForceAAO") then {RydHQE_ForceAAO = false};
	_HQ setVariable ["RydHQ_ForceAAO",RydHQE_ForceAAO];
	
	if (isNil "RydHQE_BBAOObj") then {RydHQE_BBAOObj = 1};
	_HQ setVariable ["RydHQ_BBAOObj",RydHQE_BBAOObj]; 
	
	if (isNil ("RydHQE_MoraleConst")) then {RydHQE_MoraleConst = 1};
	_HQ setVariable ["RydHQ_MoraleConst",RydHQE_MoraleConst];
	
	if (isNil ("RydHQE_OffTend")) then {RydHQE_OffTend = 1};
	_HQ setVariable ["RydHQ_OffTend",RydHQE_OffTend];
	
	if (isNil "RydHQE_EBDoctrine") then {RydHQE_EBDoctrine = false};
	_HQ setVariable ["RydHQ_EBDoctrine",RydHQE_EBDoctrine]; 
	if (isNil "RydHQE_ForceEBDoctrine") then {RydHQE_ForceEBDoctrine = false};
	_HQ setVariable ["RydHQ_ForceEBDoctrine",RydHQE_ForceEBDoctrine]; 
	
	if (isNil "RydHQE_DefRange") then {RydHQE_DefRange = 1};
	_HQ setVariable ["RydHQ_DefRange",RydHQE_DefRange];
	if (isNil "RydHQE_GarrRange") then {RydHQE_GarrRange = 1};
	_HQ setVariable ["RydHQ_GarrRange",RydHQE_GarrRange];
		
	if (isNil "RydHQE_NoCapt") then {RydHQE_NoCapt = []};
	_HQ setVariable ["RydHQ_NoCapt",RydHQE_NoCapt];
	
	if (isNil "RydHQE_AttInfDistance") then {RydHQE_AttInfDistance = 1};
	_HQ setVariable ["RydHQ_AttInfDistance",RydHQE_AttInfDistance];
	if (isNil "RydHQE_AttArmDistance") then {RydHQE_AttArmDistance = 1};
	_HQ setVariable ["RydHQ_AttArmDistance",RydHQE_AttArmDistance];
	if (isNil "RydHQE_AttSnpDistance") then {RydHQE_AttSnpDistance = 1};
	_HQ setVariable ["RydHQ_AttSnpDistance",RydHQE_AttSnpDistance];
	if (isNil "RydHQE_CaptureDistance") then {RydHQE_CaptureDistance = 1};
	_HQ setVariable ["RydHQ_CaptureDistance",RydHQE_CaptureDistance];	
	if (isNil "RydHQE_FlankDistance") then {RydHQE_FlankDistance = 1};
	_HQ setVariable ["RydHQ_FlankDistance",RydHQE_FlankDistance];
	if (isNil "RydHQE_AttSFDistance") then {RydHQE_AttSFDistance = 1};
	_HQ setVariable ["RydHQ_AttSFDistance",RydHQE_AttSFDistance];
	if (isNil "RydHQE_ReconDistance") then {RydHQE_ReconDistance = 1};
	_HQ setVariable ["RydHQ_ReconDistance",RydHQE_ReconDistance];
	if (isNil "RydHQE_UAVAlt") then {RydHQE_UAVAlt = 150};
	_HQ setVariable ["RydHQ_UAVAlt",RydHQE_UAVAlt];

	if (isNil "RydHQE_Obj1") then {RydHQE_Obj1 = createTrigger ["EmptyDetector", leaderHQB]};
	if (isNil "RydHQE_Obj2") then {RydHQE_Obj2 = createTrigger ["EmptyDetector", leaderHQB]};
	if (isNil "RydHQE_Obj3") then {RydHQE_Obj3 = createTrigger ["EmptyDetector", leaderHQB]};
	if (isNil "RydHQE_Obj4") then {RydHQE_Obj4 = createTrigger ["EmptyDetector", leaderHQB]};
	
	_HQ setVariable ["RydHQ_Obj1",RydHQE_Obj1];
	_HQ setVariable ["RydHQ_Obj2",RydHQE_Obj2];
	_HQ setVariable ["RydHQ_Obj3",RydHQE_Obj3];
	_HQ setVariable ["RydHQ_Obj4",RydHQE_Obj4];
		
	_objectives = [RydHQE_Obj1,RydHQE_Obj2,RydHQE_Obj3,RydHQE_Obj4];
	_NAVObjectives = [];

	if (isNil ("RydHQE_SimpleMode")) then {RydHQE_SimpleMode = true};
	_HQ setVariable ["RydHQ_SimpleMode",RydHQE_SimpleMode];

	if (isNil ("RydHQE_NavalObjs")) then {RydHQE_NavalObjs = []};
	_HQ setVariable ["RydHQ_NavalObjs",RydHQE_NavalObjs];

	if (isNil ("RydHQE_SecTasks")) then {RydHQE_SecTasks = false};
	_HQ setVariable ["RydHQ_SecTasks",RydHQE_SecTasks];

	if (isNil ("RydHQE_SimpleObjs")) then {RydHQE_SimpleObjs = []};
	_HQ setVariable ["RydHQ_SimpleObjs",RydHQE_SimpleObjs];

	if (isNil ("RydHQE_MaxSimpleObjs")) then {RydHQE_MaxSimpleObjs = 5};
	_HQ setVariable ["RydHQ_MaxSimpleObjs",RydHQE_MaxSimpleObjs];

	if (_HQ getVariable ["RydHQ_SimpleMode",false]) then {

		_objectives = RydHQE_SimpleObjs;
		_NAVObjectives = RydHQE_NavalObjs;
		_HQ setVariable ["RydHQ_AAO",true]; 
		_HQ setVariable ["RydHQ_ForceAAO",true];
		
	};
		
	_HQ setVariable ["RydHQ_Objectives",_objectives];
	_HQ setVariable ["RydHQ_NavalObjectives",_NAVObjectives];
		
	_listed = _HQ getVariable "BBProgress";

	if (isNil "_listed") then
		{
		_midX = 0;
		_midY = 0;
		
		_notTaken = _objectives - (_HQ getVariable ["RydHQ_Taken",[]]);
		
		_nTc = count _notTaken;
		
		if (_nTc < 1) then 
			{
			_notTaken = _objectives;
			_nTc = 4
			};
		
			{
			_pos = getPosATL _x;
			_midX = _midX + (_pos select 0);
			_midY = _midY + (_pos select 1);
			}
		forEach _notTaken;
			
		_HQ setVariable ["RydHQ_EyeOfBattle",[_midX/_nTc,_midY/_nTc,0]];
		};
			
	if not (isNil "RydHQE_DefFrontL") then {_HQ setVariable ["RydHQ_DefFrontL",RydHQE_DefFrontL]};
	if not (isNil "RydHQE_DefFront1") then {_HQ setVariable ["RydHQ_DefFront1",RydHQE_DefFront1]};
	if not (isNil "RydHQE_DefFront2") then {_HQ setVariable ["RydHQ_DefFront2",RydHQE_DefFront2]};
	if not (isNil "RydHQE_DefFront3") then {_HQ setVariable ["RydHQ_DefFront3",RydHQE_DefFront3]};
	if not (isNil "RydHQE_DefFront4") then {_HQ setVariable ["RydHQ_DefFront4",RydHQE_DefFront4]};
	
	_civF = ["CIV_F","CIV","CIV_RU","BIS_TK_CIV","BIS_CIV_special"];
	if not (isNil ("RydHQE_CivF")) then {_civF = RydHQE_CivF};
	_HQ setVariable ["RydHQ_CivF",_civF];
	
	if (isNil ("RydHQE_Def")) then {RydHQE_Def = []};
	_HQ setVariable ["RydHQ_Def",RydHQE_Def];
	
	_nObj = _HQ getVariable ["RydHQ_NObj",1];

	switch (_nObj) do
		{
		case (1) : {_HQ setVariable ["RydHQ_Obj",RydHQE_Obj1]};
		case (2) : {_HQ setVariable ["RydHQ_Obj",RydHQE_Obj2]};
		case (3) : {_HQ setVariable ["RydHQ_Obj",RydHQE_Obj3]};
		default {_HQ setVariable ["RydHQ_Obj",RydHQE_Obj4]};
		};
	
	call FUNC(RYD_StatusQuo);
	};