_SCRname = "SitRepB";
_HQ = _this select 0;

_HQ setVariable ["leaderHQ",(leader _HQ)];
_csN = +RydHQ_CallSignsN;

	{
	_nouns = [_x] call RYD_RandomOrdB;
	_csN set [_foreachIndex,_nouns]
	}
foreach _csN;

_HQ setVariable ["RydHQ_CallSignsN",_csN];
_HQ setVariable ["RydHQ_Cyclecount",0];
_cycleC = 0;

if (isNil ("RydHQB_MAtt")) then {RydHQB_MAtt = false};
_HQ setVariable ["RydHQ_MAtt",RydHQB_MAtt];
if ((isNil ("RydHQB_Personality")) or not (_HQ getVariable ["RydHQ_MAtt",false])) then {RydHQB_Personality = "OTHER"};
_HQ setVariable ["RydHQ_Personality",RydHQB_Personality];
	
if (isNil ("RydHQB_Recklessness")) then {RydHQB_Recklessness = 0.5};
_HQ setVariable ["RydHQ_Recklessness",RydHQB_Recklessness];
if (isNil ("RydHQB_Consistency")) then {RydHQB_Consistency = 0.5};
_HQ setVariable ["RydHQ_Consistency",RydHQB_Consistency];
if (isNil ("RydHQB_Activity")) then {RydHQB_Activity = 0.5};
_HQ setVariable ["RydHQ_Activity",RydHQB_Activity];
if (isNil ("RydHQB_Reflex")) then {RydHQB_Reflex = 0.5};
_HQ setVariable ["RydHQ_Reflex",RydHQB_Reflex];
if (isNil ("RydHQB_Circumspection")) then {RydHQB_Circumspection = 0.5};
_HQ setVariable ["RydHQ_Circumspection",RydHQB_Circumspection];
if (isNil ("RydHQB_Fineness")) then {RydHQB_Fineness = 0.5};
_HQ setVariable ["RydHQ_Fineness",RydHQB_Fineness];

[_HQ] call HAL_Personality;

[[_HQ],HAL_LHQ] call RYD_Spawn;

if (isNil ("RydHQB_Boxed")) then {RydHQB_Boxed = []};
_HQ setVariable ["RydHQ_Boxed",RydHQB_Boxed];

if (isNil ("RydHQB_AmmoBoxes")) then 
	{
	RydHQB_AmmoBoxes = [];

	if not (isNil "RydHQB_AmmoDepot") then 
		{
		_rds = (triggerArea RydHQB_AmmoDepot) select 0;
		RydHQB_AmmoBoxes = (getPosATL RydHQB_AmmoDepot) nearObjects ["ReammoBox_F",_rds]
		}
	};
	
_HQ setVariable ["RydHQ_AmmoBoxes",RydHQB_AmmoBoxes];

_HQ setVariable ["RydHQ_ReconDone",false];
_HQ setVariable ["RydHQ_DefDone",false];
_HQ setVariable ["RydHQ_ReconStage",1];
_HQ setVariable ["RydHQ_ReconStage2",1];
_HQ setVariable ["RydHQ_AirInDef",[]];

_KnEnPos = [];

if (isNil ("RydHQB_Excluded")) then {RydHQB_Excluded = []};
_HQ setVariable ["RydHQ_Excluded",RydHQB_Excluded];
if (isNil ("RydHQB_Fast")) then {RydHQB_Fast = false};
_HQ setVariable ["RydHQ_Fast",RydHQB_Fast];
if (isNil ("RydHQB_ExInfo")) then {RydHQB_ExInfo = false};
_HQ setVariable ["RydHQ_ExInfo",RydHQB_ExInfo];
if (isNil ("RydHQB_ObjHoldTime")) then {RydHQB_ObjHoldTime = 600};
_HQ setVariable ["RydHQ_ObjHoldTime",RydHQB_ObjHoldTime];
if (isNil "RydHQB_NObj") then {RydHQB_NObj = 1};
_HQ setVariable ["RydHQ_NObj",RydHQB_NObj];

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

if (isNil ("RydHQB_SupportWP")) then {RydHQB_SupportWP = false};
	
_HQ setVariable ["RydHQ_SupportWP",RydHQB_SupportWP];

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
	[] call RYD_PresentRHQ
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
	
	if not (_HQ getVariable ["RydHQ_Fast",false]) then 
		{
		waituntil 
			{
			sleep 0.1;
			((({(_x getVariable ["RydHQ_Pending",false])} count RydxHQ_AllHQ) == 0) or (_HQ getVariable ["RydHQ_KIA",false]))
			}
		};
		
	if (_HQ getVariable ["RydHQ_KIA",false]) exitWith {RydxHQ_AllHQ = RydxHQ_AllHQ - [_HQ]};
	
	_HQ setVariable ["RydHQ_Pending",true];

	if (_cycleC > 1) then
		{
		if not (_lastHQ == (_HQ getVariable ["leaderHQ",objNull])) then {sleep (60 + (random 60))};
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
	
	if (isNil "RydHQB_Garrison") then {RydHQB_Garrison = []};
	_HQ setVariable ["RydHQ_Garrison",RydHQB_Garrison];
	
	if (isNil ("RydHQB_NoAirCargo")) then {RydHQB_NoAirCargo = false};
	_HQ setVariable ["RydHQ_NoAirCargo",RydHQB_NoAirCargo];
	if (isNil ("RydHQB_NoLandCargo")) then {RydHQB_NoLandCargo = false};
	_HQ setVariable ["RydHQ_NoLandCargo",RydHQB_NoLandCargo];
	if (isNil ("RydHQB_LastFriends")) then {RydHQB_LastFriends = []};
	_HQ setVariable ["RydHQ_LastFriends",RydHQB_LastFriends];
	if (isNil ("RydHQB_CargoFind")) then {RydHQB_CargoFind = 1};
	_HQ setVariable ["RydHQ_CargoFind",RydHQB_CargoFind];
	if (isNil ("RydHQB_Subordinated")) then {RydHQB_Subordinated = []};
	_HQ setVariable ["RydHQ_Subordinated",RydHQB_Subordinated];
	if (isNil ("RydHQB_Included")) then {RydHQB_Included = []};
	_HQ setVariable ["RydHQ_Included",RydHQB_Included];
	if (isNil ("RydHQB_Excluded")) then {RydHQB_Excluded = []};
	_HQ setVariable ["RydHQ_Excluded",RydHQB_Excluded];
	if (isNil ("RydHQB_SubAll")) then {RydHQB_SubAll = true};
	_HQ setVariable ["RydHQ_SubAll",RydHQB_SubAll];
	if (isNil ("RydHQB_SubSynchro")) then {RydHQB_SubSynchro = false};
	_HQ setVariable ["RydHQ_SubSynchro",RydHQB_SubSynchro];
	if (isNil ("RydHQB_SubNamed")) then {RydHQB_SubNamed = false};
	_HQ setVariable ["RydHQ_SubNamed",RydHQB_SubNamed];
	if (isNil ("RydHQB_SubZero")) then {RydHQB_SubZero = false};
	_HQ setVariable ["RydHQ_SubZero",RydHQB_SubZero];
	if (isNil ("RydHQB_ReSynchro")) then {RydHQB_ReSynchro = true};
	_HQ setVariable ["RydHQ_ReSynchro",RydHQB_ReSynchro];
	if (isNil ("RydHQB_NameLimit")) then {RydHQB_NameLimit = 100};
	_HQ setVariable ["RydHQ_NameLimit",RydHQB_NameLimit];
	if (isNil ("RydHQB_Surr")) then {RydHQB_Surr = false};
	_HQ setVariable ["RydHQ_Surr",RydHQB_Surr];
	if (isNil ("RydHQB_NoRecon")) then {RydHQB_NoRecon = []};
	_HQ setVariable ["RydHQ_NoRecon",RydHQB_NoRecon];
	if (isNil ("RydHQB_NoAttack")) then {RydHQB_NoAttack = []};
	_HQ setVariable ["RydHQ_NoAttack",RydHQB_NoAttack];
	if (isNil ("RydHQB_CargoOnly")) then {RydHQB_CargoOnly = []};
	_HQ setVariable ["RydHQ_CargoOnly",RydHQB_CargoOnly];
	if (isNil ("RydHQB_NoCargo")) then {RydHQB_NoCargo = []};
	_HQ setVariable ["RydHQ_NoCargo",RydHQB_NoCargo];
	if (isNil ("RydHQB_NoFlank")) then {RydHQB_NoFlank = []};
	_HQ setVariable ["RydHQ_NoFlank",RydHQB_NoFlank];
	if (isNil ("RydHQB_NoDef")) then {RydHQB_NoDef = []};
	_HQ setVariable ["RydHQ_NoDef",RydHQB_NoDef];
	if (isNil ("RydHQB_FirstToFight")) then {RydHQB_FirstToFight = []};
	_HQ setVariable ["RydHQ_FirstToFight",RydHQB_FirstToFight];
	if (isNil ("RydHQB_VoiceComm")) then {RydHQB_VoiceComm = true};
	_HQ setVariable ["RydHQ_VoiceComm",RydHQB_VoiceComm];
	if (isNil ("RydHQB_FrontA")) then {RydHQB_Front = false};
	_HQ setVariable ["RydHQ_FrontA",RydHQB_Front];
	if (isNil ("RydHQB_LRelocating")) then {RydHQB_LRelocating = false};
	_HQ setVariable ["RydHQ_LRelocating",RydHQB_LRelocating];
	if (isNil ("RydHQB_Flee")) then {RydHQB_Flee = true};
	_HQ setVariable ["RydHQ_Flee",RydHQB_Flee];

	if (isNil ("RydHQB_GarrR")) then {RydHQB_GarrR = 500};
	_HQ setVariable ["RydHQ_GarrR",RydHQB_GarrR];
	if (isNil ("RydHQB_GarrLim")) then {RydHQB_GarrLim = 5};
	_HQ setVariable ["RydHQ_GarrLim",RydHQB_GarrLim];

	if (isNil ("RydHQB_Rush")) then {RydHQB_Rush = false};
	_HQ setVariable ["RydHQ_Rush",RydHQB_Rush];
	if (isNil ("RydHQB_GarrVehAb")) then {RydHQB_GarrVehAb = false};
	_HQ setVariable ["RydHQ_GarrVehAb",RydHQB_GarrVehAb];
	if (isNil ("RydHQB_DefendObjectives")) then {RydHQB_DefendObjectives = 4};
	_HQ setVariable ["RydHQ_DefendObjectives",RydHQB_DefendObjectives];
	if (isNil ("RydHQB_DefSpot")) then {RydHQB_DefSpot = []};
	_HQ setVariable ["RydHQ_DefSpot",RydHQB_DefSpot];
	if (isNil ("RydHQB_RecDefSpot")) then {RydHQB_RecDefSpot = []};
	_HQ setVariable ["RydHQ_RecDefSpot",RydHQB_RecDefSpot];
	if (isNil "RydHQB_Flare") then {RydHQB_Flare = true};
	_HQ setVariable ["RydHQ_Flare",RydHQB_Flare];
	if (isNil "RydHQB_Smoke") then {RydHQB_Smoke = true};
	_HQ setVariable ["RydHQ_Smoke",RydHQB_Smoke];
	if (isNil "RydHQB_NoRec") then {RydHQB_NoRec = 1};
	_HQ setVariable ["RydHQ_NoRec",RydHQB_NoRec];
	if (isNil "RydHQB_RapidCapt") then {RydHQB_RapidCapt = 10};
	_HQ setVariable ["RydHQ_RapidCapt",RydHQB_RapidCapt];
	if (isNil "RydHQB_Muu") then {RydHQB_Muu = 1};
	_HQ setVariable ["RydHQ_Muu",RydHQB_Muu];
	if (isNil "RydHQB_ArtyShells") then {RydHQB_ArtyShells = 1};
	_HQ setVariable ["RydHQ_ArtyShells",RydHQB_ArtyShells];
	if (isNil "RydHQB_Withdraw") then {RydHQB_Withdraw = 1};
	_HQ setVariable ["RydHQ_Withdraw",RydHQB_Withdraw];
	if (isNil "RydHQB_Berserk") then {RydHQB_Berserk = false};
	_HQ setVariable ["RydHQ_Berserk",RydHQB_Berserk];
	if (isNil "RydHQB_IDChance") then {RydHQB_IDChance = 100};
	_HQ setVariable ["RydHQ_IDChance",RydHQB_IDChance];
	if (isNil "RydHQB_RDChance") then {RydHQB_RDChance = 100};
	_HQ setVariable ["RydHQ_RDChance",RydHQB_RDChance];
	if (isNil "RydHQB_SDChance") then {RydHQB_SDChance = 100};
	_HQ setVariable ["RydHQ_SDChance",RydHQB_SDChance];
	if (isNil "RydHQB_AmmoDrop") then {RydHQB_AmmoDrop = []};
	_HQ setVariable ["RydHQ_AmmoDrop",RydHQB_AmmoDrop];
	if (isNil "RydHQB_SFTargets") then {RydHQB_SFTargets = []};
	_HQ setVariable ["RydHQ_SFTargets",RydHQB_SFTargets];
	if (isNil "RydHQB_LZ") then {RydHQB_LZ = false};
	_HQ setVariable ["RydHQ_LZ",RydHQB_LZ];
	if (isNil "RydHQB_SFBodyGuard") then {RydHQB_SFBodyGuard = []};
	_HQ setVariable ["RydHQ_SFBodyGuard",RydHQB_SFBodyGuard];
	if (isNil "RydHQB_DynForm") then {RydHQB_DynForm = false};
	_HQ setVariable ["RydHQ_DynForm",RydHQB_DynForm];
	if (isNil "RydHQB_UnlimitedCapt") then {RydHQB_UnlimitedCapt = false};
	_HQ setVariable ["RydHQ_UnlimitedCapt",RydHQB_UnlimitedCapt];
	if (isNil "RydHQB_CaptLimit") then {RydHQB_CaptLimit = 10};
	_HQ setVariable ["RydHQ_CaptLimit",RydHQB_CaptLimit];
	if (isNil "RydHQB_GetHQInside") then {RydHQB_GetHQInside = false};
	_HQ setVariable ["RydHQ_GetHQInside",RydHQB_GetHQInside];
	if (isNil "RydHQB_WA") then {RydHQB_WA = true};
	_HQ setVariable ["RydHQ_WA",RydHQB_WA];

	if (isNil "RydHQB_InfoMarkers") then {RydHQB_InfoMarkers = false};
	_HQ setVariable ["RydHQ_InfoMarkers",RydHQB_InfoMarkers];

	if (isNil "RydHQB_ArtyMarks") then {RydHQB_ArtyMarks = false};
	_HQ setVariable ["RydHQ_ArtyMarks",RydHQB_ArtyMarks];

	if (isNil ("RydHQB_ResetNow")) then {RydHQB_ResetNow = false};
	_HQ setVariable ["RydHQ_ResetNow",RydHQB_ResetNow];
	if (isNil ("RydHQB_ResetOnDemand")) then {RydHQB_ResetOnDemand = false};
	_HQ setVariable ["RydHQ_ResetOnDemand",RydHQB_ResetOnDemand];
	if (isNil ("RydHQB_ResetTime")) then {RydHQB_ResetTime = 600};
	_HQ setVariable ["RydHQ_ResetTime",RydHQB_ResetTime];
	if (isNil ("RydHQB_Combining")) then {RydHQB_Combining = false};
	_HQ setVariable ["RydHQ_Combining",RydHQB_Combining];
	if (isNil ("RydHQB_ObjRadius1")) then {RydHQB_ObjRadius1 = 300};
	_HQ setVariable ["RydHQ_ObjRadius1",RydHQB_ObjRadius1];
	if (isNil ("RydHQB_ObjRadius2")) then {RydHQB_ObjRadius2 = 500};
	_HQ setVariable ["RydHQ_ObjRadius2",RydHQB_ObjRadius2];
	if (isNil ("RydHQB_KnowTL")) then {RydHQB_KnowTL = true};
	_HQ setVariable ["RydHQ_KnowTL",RydHQB_KnowTL];
	
	if (isNil ("RydHQB_SMed")) then {RydHQB_SMed = true};
	_HQ setVariable ["RydHQ_SMed",RydHQB_SMed];
	if (isNil ("RydHQB_ExMedic")) then {RydHQB_ExMedic = []};
	_HQ setVariable ["RydHQ_ExMedic",RydHQB_ExMedic];
	if (isNil ("RydHQB_MedPoints")) then {RydHQB_MedPoints = []};
	_HQ setVariable ["RydHQ_MedPoints",RydHQB_MedPoints];
	if (isNil ("RydHQB_SupportedG")) then {RydHQB_SupportedG = []};
	_HQ setVariable ["RydHQ_SupportedG",RydHQB_SupportedG];

	if (isNil ("RydHQB_RCASB")) then {RydHQB_RCAS = []};
	_HQ setVariable ["RydHQ_RCAS",RydHQB_RCAS];
	if (isNil ("RydHQB_RCAPB")) then {RydHQB_RCAP = []};
	_HQ setVariable ["RydHQ_RCAP",RydHQB_RCAP];
	
	if (isNil ("RydHQB_SFuel")) then {RydHQB_SFuel = true};
	_HQ setVariable ["RydHQ_SFuel",RydHQB_SFuel];
	if (isNil ("RydHQB_ExRefuel")) then {RydHQB_ExRefuel = []};
	_HQ setVariable ["RydHQ_ExRefuel",RydHQB_ExRefuel];
	if (isNil ("RydHQB_FuelPoints")) then {RydHQB_FuelPoints = []};
	_HQ setVariable ["RydHQ_FuelPoints",RydHQB_FuelPoints];
	if (isNil ("RydHQB_FSupportedG")) then {RydHQB_FSupportedG = []};
	_HQ setVariable ["RydHQ_FSupportedG",RydHQB_FSupportedG];
	
	if (isNil ("RydHQB_SAmmo")) then {RydHQB_SAmmo = true};
	_HQ setVariable ["RydHQ_SAmmo",RydHQB_SAmmo];
	if (isNil ("RydHQB_ExReammo")) then {RydHQB_ExReammo = []};
	_HQ setVariable ["RydHQ_ExReammo",RydHQB_ExReammo];
	if (isNil ("RydHQB_AmmoPoints")) then {RydHQB_AmmoPoints = []};
	_HQ setVariable ["RydHQ_AmmoPoints",RydHQB_AmmoPoints];
	if (isNil ("RydHQB_ASupportedG")) then {RydHQB_ASupportedG = []};
	_HQ setVariable ["RydHQ_ASupportedG",RydHQB_ASupportedG];
	
	if (isNil ("RydHQB_SRep")) then {RydHQB_SRep = true};
	_HQ setVariable ["RydHQ_SRep",RydHQB_SRep];
	if (isNil ("RydHQB_ExRepair")) then {RydHQB_ExRepair = []};
	_HQ setVariable ["RydHQ_ExRepair",RydHQB_ExRepair];
	if (isNil ("RydHQB_RepPoints")) then {RydHQB_RepPoints = []};
	_HQ setVariable ["RydHQ_RepPoints",RydHQB_RepPoints];
	if (isNil ("RydHQB_RSupportedG")) then {RydHQB_RSupportedG = []};
	_HQ setVariable ["RydHQ_RSupportedG",RydHQB_RSupportedG];
	
	if (isNil "RydHQB_AirDist") then {RydHQB_AirDist = 4000};
	_HQ setVariable ["RydHQ_AirDist",RydHQB_AirDist];
	
	if (isNil ("RydHQB_CommDelay")) then {RydHQB_CommDelay = 1};
	_HQ setVariable ["RydHQ_CommDelay",RydHQB_CommDelay];


	if ((isNil ("RydHQB_Order")) and (isNil {_HQ getVariable "RydHQ_Order"})) then {_HQ setVariable ["RydHQ_Order","ATTACK"]};
	if ( not (isNil ("RydHQB_Order"))) then {
		if (RydHQB_Order == "DEFEND") then {
			_HQ setVariable ["RydHQ_Order","DEFEND"]
		} else {
			_HQ setVariable ["RydHQ_Order","ATTACK"]
		};
	};

	if (isNil ("RydHQB_AttackAlways")) then {RydHQB_AttackAlways = false};
	_HQ setVariable ["RydHQ_AttackAlways",RydHQB_AttackAlways];

	if (isNil ("RydHQB_CRDefRes")) then {RydHQB_CRDefRes = 0};
	_HQ setVariable ["RydHQ_CRDefRes",RydHQB_CRDefRes];


	if (isNil ("RydHQB_ReconReserve")) then {RydHQB_ReconReserve = (0.3 * (0.5 + (_HQ getVariable ["RydHQ_Circumspection",0.5])))};
	_HQ setVariable ["RydHQ_ReconReserve",RydHQB_ReconReserve];
	if (isNil ("RydHQB_Exhausted")) then {RydHQB_Exhausted = []};
	_HQ setVariable ["RydHQ_Exhausted",RydHQB_Exhausted];
	if (isNil ("RydHQB_AttackReserve")) then {RydHQB_AttackReserve = (0.5 * (0.5 + ((_HQ getVariable ["RydHQ_Circumspection",0.5])/1.5)))};
	_HQ setVariable ["RydHQ_AttackReserve",RydHQB_AttackReserve];
	if (isNil ("RydHQB_IdleOrd")) then {RydHQB_IdleOrd = true};
	_HQ setVariable ["RydHQ_IdleOrd",RydHQB_IdleOrd];

	if (isNil ("RydHQB_IdleDef")) then {RydHQB_IdleDef = true};
	_HQ setVariable ["RydHQ_IdleDef",RydHQB_IdleDef];

	if (isNil "RydHQB_IdleDecoy") then {RydHQB_IdleDecoy = objNull};
	_HQ setVariable ["RydHQ_IdleDecoy",RydHQB_IdleDecoy]; 
	if (isNil "RydHQB_SupportDecoy") then {RydHQB_SupportDecoy = objNull};
	_HQ setVariable ["RydHQ_SupportDecoy",RydHQB_SupportDecoy]; 
	if (isNil "RydHQB_RestDecoy") then {RydHQB_RestDecoy = objNull};
	_HQ setVariable ["RydHQ_RestDecoy",RydHQB_RestDecoy]; 
	if (isNil "RydHQB_Sec1") then {RydHQB_Sec1 = objNull};
	_HQ setVariable ["RydHQ_Sec1",RydHQB_Sec1]; 
	if (isNil "RydHQB_Sec2") then {RydHQB_Sec2 = objNull};
	_HQ setVariable ["RydHQ_Sec2",RydHQB_Sec2];

	if (isNil "RydHQB_SupportRTB") then {RydHQB_SupportRTB = false};
	_HQ setVariable ["RydHQ_SupportRTB",RydHQB_SupportRTB];
	
	if (isNil "RydHQB_Debug") then {RydHQB_Debug = false};
	_HQ setVariable ["RydHQ_Debug",RydHQB_Debug]; 
	if (isNil "RydHQB_DebugII") then {RydHQB_DebugII = false};
	_HQ setVariable ["RydHQ_DebugII",RydHQB_DebugII]; 
	
	if (isNil "RydHQB_AlwaysKnownU") then {RydHQB_AlwaysKnownU = []};
	_HQ setVariable ["RydHQ_AlwaysKnownU",RydHQB_AlwaysKnownU]; 
	if (isNil "RydHQB_AlwaysUnKnownU") then {RydHQB_AlwaysUnKnownU = []};
	_HQ setVariable ["RydHQ_AlwaysUnKnownU",RydHQB_AlwaysUnKnownU]; 
	
	if (isNil "RydHQB_AOnly") then {RydHQB_AOnly = []};
	_HQ setVariable ["RydHQ_AOnly",RydHQB_AOnly]; 
	if (isNil "RydHQB_ROnly") then {RydHQB_ROnly = []};
	_HQ setVariable ["RydHQ_ROnly",RydHQB_ROnly]; 
	
	if (isNil "RydHQB_AirEvac") then {RydHQB_AirEvac = false};
	_HQ setVariable ["RydHQ_AirEvac",RydHQB_AirEvac];
	
	if (isNil "RydHQB_AAO") then {RydHQB_AAO = false};
	_HQ setVariable ["RydHQ_AAO",RydHQB_AAO]; 
	if (isNil "RydHQB_ForceAAO") then {RydHQB_ForceAAO = false};
	_HQ setVariable ["RydHQ_ForceAAO",RydHQB_ForceAAO];
	
	if (isNil "RydHQB_BBAOObj") then {RydHQB_BBAOObj = 1};
	_HQ setVariable ["RydHQ_BBAOObj",RydHQB_BBAOObj]; 
	
	if (isNil ("RydHQB_MoraleConst")) then {RydHQB_MoraleConst = 1};
	_HQ setVariable ["RydHQ_MoraleConst",RydHQB_MoraleConst];
	
	if (isNil ("RydHQB_OffTend")) then {RydHQB_OffTend = 1};
	_HQ setVariable ["RydHQ_OffTend",RydHQB_OffTend];
	
	if (isNil "RydHQB_EBDoctrine") then {RydHQB_EBDoctrine = false};
	_HQ setVariable ["RydHQ_EBDoctrine",RydHQB_EBDoctrine]; 
	if (isNil "RydHQB_ForceEBDoctrine") then {RydHQB_ForceEBDoctrine = false};
	_HQ setVariable ["RydHQ_ForceEBDoctrine",RydHQB_ForceEBDoctrine]; 
	
	if (isNil "RydHQB_DefRange") then {RydHQB_DefRange = 1};
	_HQ setVariable ["RydHQ_DefRange",RydHQB_DefRange];
	if (isNil "RydHQB_GarrRange") then {RydHQB_GarrRange = 1};
	_HQ setVariable ["RydHQ_GarrRange",RydHQB_GarrRange];
		
	if (isNil "RydHQB_NoCapt") then {RydHQB_NoCapt = []};
	_HQ setVariable ["RydHQ_NoCapt",RydHQB_NoCapt];
	
	if (isNil "RydHQB_AttInfDistance") then {RydHQB_AttInfDistance = 1};
	_HQ setVariable ["RydHQ_AttInfDistance",RydHQB_AttInfDistance];
	if (isNil "RydHQB_AttArmDistance") then {RydHQB_AttArmDistance = 1};
	_HQ setVariable ["RydHQ_AttArmDistance",RydHQB_AttArmDistance];
	if (isNil "RydHQB_AttSnpDistance") then {RydHQB_AttSnpDistance = 1};
	_HQ setVariable ["RydHQ_AttSnpDistance",RydHQB_AttSnpDistance];
	if (isNil "RydHQB_CaptureDistance") then {RydHQB_CaptureDistance = 1};
	_HQ setVariable ["RydHQ_CaptureDistance",RydHQB_CaptureDistance];	
	if (isNil "RydHQB_FlankDistance") then {RydHQB_FlankDistance = 1};
	_HQ setVariable ["RydHQ_FlankDistance",RydHQB_FlankDistance];
	if (isNil "RydHQB_AttSFDistance") then {RydHQB_AttSFDistance = 1};
	_HQ setVariable ["RydHQ_AttSFDistance",RydHQB_AttSFDistance];
	if (isNil "RydHQB_ReconDistance") then {RydHQB_ReconDistance = 1};
	_HQ setVariable ["RydHQ_ReconDistance",RydHQB_ReconDistance];
	if (isNil "RydHQB_UAVAlt") then {RydHQB_UAVAlt = 150};
	_HQ setVariable ["RydHQ_UAVAlt",RydHQB_UAVAlt];

	if (isNil "RydHQB_Obj1") then {RydHQB_Obj1 = createTrigger ["EmptyDetector", leaderHQB]};
	if (isNil "RydHQB_Obj2") then {RydHQB_Obj2 = createTrigger ["EmptyDetector", leaderHQB]};
	if (isNil "RydHQB_Obj3") then {RydHQB_Obj3 = createTrigger ["EmptyDetector", leaderHQB]};
	if (isNil "RydHQB_Obj4") then {RydHQB_Obj4 = createTrigger ["EmptyDetector", leaderHQB]};
	
	_HQ setVariable ["RydHQ_Obj1",RydHQB_Obj1];
	_HQ setVariable ["RydHQ_Obj2",RydHQB_Obj2];
	_HQ setVariable ["RydHQ_Obj3",RydHQB_Obj3];
	_HQ setVariable ["RydHQ_Obj4",RydHQB_Obj4];
		
	_objectives = [RydHQB_Obj1,RydHQB_Obj2,RydHQB_Obj3,RydHQB_Obj4];
	_NAVObjectives = [];

	if (isNil ("RydHQB_SimpleMode")) then {RydHQB_SimpleMode = true};
	_HQ setVariable ["RydHQ_SimpleMode",RydHQB_SimpleMode];

	if (isNil ("RydHQB_NavalObjs")) then {RydHQB_NavalObjs = []};
	_HQ setVariable ["RydHQ_NavalObjs",RydHQB_NavalObjs];

	if (isNil ("RydHQB_SecTasks")) then {RydHQB_SecTasks = false};
	_HQ setVariable ["RydHQ_SecTasks",RydHQB_SecTasks];

	if (isNil ("RydHQB_SimpleObjs")) then {RydHQB_SimpleObjs = []};
	_HQ setVariable ["RydHQ_SimpleObjs",RydHQB_SimpleObjs];

	if (isNil ("RydHQB_MaxSimpleObjs")) then {RydHQB_MaxSimpleObjs = 5};
	_HQ setVariable ["RydHQ_MaxSimpleObjs",RydHQB_MaxSimpleObjs];

	if (_HQ getVariable ["RydHQ_SimpleMode",false]) then {

		_objectives = RydHQB_SimpleObjs;
		_NAVObjectives = RydHQB_NavalObjs;
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
		foreach _notTaken;
			
		_HQ setVariable ["RydHQ_EyeOfBattle",[_midX/_nTc,_midY/_nTc,0]];
		};
			
	if not (isNil "RydHQB_DefFrontL") then {_HQ setVariable ["RydHQ_DefFrontL",RydHQB_DefFrontL]};
	if not (isNil "RydHQB_DefFront1") then {_HQ setVariable ["RydHQ_DefFront1",RydHQB_DefFront1]};
	if not (isNil "RydHQB_DefFront2") then {_HQ setVariable ["RydHQ_DefFront2",RydHQB_DefFront2]};
	if not (isNil "RydHQB_DefFront3") then {_HQ setVariable ["RydHQ_DefFront3",RydHQB_DefFront3]};
	if not (isNil "RydHQB_DefFront4") then {_HQ setVariable ["RydHQ_DefFront4",RydHQB_DefFront4]};
	
	_civF = ["CIV_F","CIV","CIV_RU","BIS_TK_CIV","BIS_CIV_special"];
	if not (isNil ("RydHQB_CivF")) then {_civF = RydHQB_CivF};
	_HQ setVariable ["RydHQ_CivF",_civF];
	
	if (isNil ("RydHQB_Def")) then {RydHQB_Def = []};
	_HQ setVariable ["RydHQ_Def",RydHQB_Def];
	
	_nObj = _HQ getVariable ["RydHQ_NObj",1];

	switch (_nObj) do
		{
		case (1) : {_HQ setVariable ["RydHQ_Obj",RydHQB_Obj1]};
		case (2) : {_HQ setVariable ["RydHQ_Obj",RydHQB_Obj2]};
		case (3) : {_HQ setVariable ["RydHQ_Obj",RydHQB_Obj3]};
		default {_HQ setVariable ["RydHQ_Obj",RydHQB_Obj4]};
		};
	
	call RYD_StatusQuo;
	};