_SCRname = "SitRepG";
_HQ = _this select 0;

_HQ setVariable ["leaderHQ",(leader _HQ)];
_csN = +RydHQ_CallSignsN;

	{
	_nouns = [_x] call RYD_RandomOrdB;
	_csN set [_foreachIndex,_nouns]
	}
forEach _csN;

_HQ setVariable ["RydHQ_CallSignsN",_csN];
_HQ setVariable ["RydHQ_Cyclecount",0];
_cycleC = 0;

if (isNil ("RydHQG_MAtt")) then {RydHQG_MAtt = false};
_HQ setVariable ["RydHQ_MAtt",RydHQG_MAtt];
if ((isNil ("RydHQG_Personality")) or not (_HQ getVariable ["RydHQ_MAtt",false])) then {RydHQG_Personality = "OTHER"};
_HQ setVariable ["RydHQ_Personality",RydHQG_Personality];

if (isNil ("RydHQG_Recklessness")) then {RydHQG_Recklessness = 0.5};
_HQ setVariable ["RydHQ_Recklessness",RydHQG_Recklessness];
if (isNil ("RydHQG_Consistency")) then {RydHQG_Consistency = 0.5};
_HQ setVariable ["RydHQ_Consistency",RydHQG_Consistency];
if (isNil ("RydHQG_Activity")) then {RydHQG_Activity = 0.5};
_HQ setVariable ["RydHQ_Activity",RydHQG_Activity];
if (isNil ("RydHQG_Reflex")) then {RydHQG_Reflex = 0.5};
_HQ setVariable ["RydHQ_Reflex",RydHQG_Reflex];
if (isNil ("RydHQG_Circumspection")) then {RydHQG_Circumspection = 0.5};
_HQ setVariable ["RydHQ_Circumspection",RydHQG_Circumspection];
if (isNil ("RydHQG_Fineness")) then {RydHQG_Fineness = 0.5};
_HQ setVariable ["RydHQ_Fineness",RydHQG_Fineness];

[_HQ] call HAL_Personality;

[[_HQ],HAL_LHQ] call RYD_Spawn;

if (isNil ("RydHQG_Boxed")) then {RydHQG_Boxed = []};
_HQ setVariable ["RydHQ_Boxed",RydHQG_Boxed];

if (isNil ("RydHQG_AmmoBoxes")) then 
	{
	RydHQG_AmmoBoxes = [];

	if not (isNil "RydHQG_AmmoDepot") then 
		{
		_rds = (triggerArea RydHQG_AmmoDepot) select 0;
		RydHQG_AmmoBoxes = (getPosATL RydHQG_AmmoDepot) nearObjects ["ReammoBox_F",_rds]
		}
	};
	
_HQ setVariable ["RydHQ_AmmoBoxes",RydHQG_AmmoBoxes];

_HQ setVariable ["RydHQ_ReconDone",false];
_HQ setVariable ["RydHQ_DefDone",false];
_HQ setVariable ["RydHQ_ReconStage",1];
_HQ setVariable ["RydHQ_ReconStage2",1];
_HQ setVariable ["RydHQ_AirInDef",[]];

_KnEnPos = [];

if (isNil ("RydHQG_Excluded")) then {RydHQG_Excluded = []};
_HQ setVariable ["RydHQ_Excluded",RydHQG_Excluded];
if (isNil ("RydHQG_Fast")) then {RydHQG_Fast = false};
_HQ setVariable ["RydHQ_Fast",RydHQG_Fast];
if (isNil ("RydHQG_ExInfo")) then {RydHQG_ExInfo = false};
_HQ setVariable ["RydHQ_ExInfo",RydHQG_ExInfo];
if (isNil ("RydHQG_ObjHoldTime")) then {RydHQG_ObjHoldTime = 600};
_HQ setVariable ["RydHQ_ObjHoldTime",RydHQG_ObjHoldTime];
if (isNil "RydHQG_NObj") then {RydHQG_NObj = 1};
_HQ setVariable ["RydHQ_NObj",RydHQG_NObj];

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

if (isNil ("RydHQG_SupportWP")) then {RydHQG_SupportWP = false};
	
_HQ setVariable ["RydHQ_SupportWP",RydHQG_SupportWP];

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
		waitUntil 
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
	
	if (isNil "RydHQG_Garrison") then {RydHQG_Garrison = []};
	_HQ setVariable ["RydHQ_Garrison",RydHQG_Garrison];
	
	if (isNil ("RydHQG_NoAirCargo")) then {RydHQG_NoAirCargo = false};
	_HQ setVariable ["RydHQ_NoAirCargo",RydHQG_NoAirCargo];
	if (isNil ("RydHQG_NoLandCargo")) then {RydHQG_NoLandCargo = false};
	_HQ setVariable ["RydHQ_NoLandCargo",RydHQG_NoLandCargo];
	if (isNil ("RydHQG_LastFriends")) then {RydHQG_LastFriends = []};
	_HQ setVariable ["RydHQ_LastFriends",RydHQG_LastFriends];
	if (isNil ("RydHQG_CargoFind")) then {RydHQG_CargoFind = 1};
	_HQ setVariable ["RydHQ_CargoFind",RydHQG_CargoFind];
	if (isNil ("RydHQG_Subordinated")) then {RydHQG_Subordinated = []};
	_HQ setVariable ["RydHQ_Subordinated",RydHQG_Subordinated];
	if (isNil ("RydHQG_Included")) then {RydHQG_Included = []};
	_HQ setVariable ["RydHQ_Included",RydHQG_Included];
	if (isNil ("RydHQG_Excluded")) then {RydHQG_Excluded = []};
	_HQ setVariable ["RydHQ_Excluded",RydHQG_Excluded];
	if (isNil ("RydHQG_SubAll")) then {RydHQG_SubAll = true};
	_HQ setVariable ["RydHQ_SubAll",RydHQG_SubAll];
	if (isNil ("RydHQG_SubSynchro")) then {RydHQG_SubSynchro = false};
	_HQ setVariable ["RydHQ_SubSynchro",RydHQG_SubSynchro];
	if (isNil ("RydHQG_SubNamed")) then {RydHQG_SubNamed = false};
	_HQ setVariable ["RydHQ_SubNamed",RydHQG_SubNamed];
	if (isNil ("RydHQG_SubZero")) then {RydHQG_SubZero = false};
	_HQ setVariable ["RydHQ_SubZero",RydHQG_SubZero];
	if (isNil ("RydHQG_ReSynchro")) then {RydHQG_ReSynchro = true};
	_HQ setVariable ["RydHQ_ReSynchro",RydHQG_ReSynchro];
	if (isNil ("RydHQG_NameLimit")) then {RydHQG_NameLimit = 100};
	_HQ setVariable ["RydHQ_NameLimit",RydHQG_NameLimit];
	if (isNil ("RydHQG_Surr")) then {RydHQG_Surr = false};
	_HQ setVariable ["RydHQ_Surr",RydHQG_Surr];
	if (isNil ("RydHQG_NoRecon")) then {RydHQG_NoRecon = []};
	_HQ setVariable ["RydHQ_NoRecon",RydHQG_NoRecon];
	if (isNil ("RydHQG_NoAttack")) then {RydHQG_NoAttack = []};
	_HQ setVariable ["RydHQ_NoAttack",RydHQG_NoAttack];
	if (isNil ("RydHQG_CargoOnly")) then {RydHQG_CargoOnly = []};
	_HQ setVariable ["RydHQ_CargoOnly",RydHQG_CargoOnly];
	if (isNil ("RydHQG_NoCargo")) then {RydHQG_NoCargo = []};
	_HQ setVariable ["RydHQ_NoCargo",RydHQG_NoCargo];
	if (isNil ("RydHQG_NoFlank")) then {RydHQG_NoFlank = []};
	_HQ setVariable ["RydHQ_NoFlank",RydHQG_NoFlank];
	if (isNil ("RydHQG_NoDef")) then {RydHQG_NoDef = []};
	_HQ setVariable ["RydHQ_NoDef",RydHQG_NoDef];
	if (isNil ("RydHQG_FirstToFight")) then {RydHQG_FirstToFight = []};
	_HQ setVariable ["RydHQ_FirstToFight",RydHQG_FirstToFight];
	if (isNil ("RydHQG_VoiceComm")) then {RydHQG_VoiceComm = true};
	_HQ setVariable ["RydHQ_VoiceComm",RydHQG_VoiceComm];
	if (isNil ("RydHQG_FrontA")) then {RydHQG_Front = false};
	_HQ setVariable ["RydHQ_FrontA",RydHQG_Front];
	if (isNil ("RydHQG_LRelocating")) then {RydHQG_LRelocating = false};
	_HQ setVariable ["RydHQ_LRelocating",RydHQG_LRelocating];
	if (isNil ("RydHQG_Flee")) then {RydHQG_Flee = true};
	_HQ setVariable ["RydHQ_Flee",RydHQG_Flee];
	if (isNil ("RydHQG_GarrR")) then {RydHQG_GarrR = 500};
	_HQ setVariable ["RydHQ_GarrR",RydHQG_GarrR];
	if (isNil ("RydHQG_Rush")) then {RydHQG_Rush = false};
	_HQ setVariable ["RydHQ_Rush",RydHQG_Rush];
	if (isNil ("RydHQG_GarrVehAb")) then {RydHQG_GarrVehAb = false};
	_HQ setVariable ["RydHQ_GarrVehAb",RydHQG_GarrVehAb];
	if (isNil ("RydHQG_DefendObjectives")) then {RydHQG_DefendObjectives = 4};
	_HQ setVariable ["RydHQ_DefendObjectives",RydHQG_DefendObjectives];
	if (isNil ("RydHQG_DefSpot")) then {RydHQG_DefSpot = []};
	_HQ setVariable ["RydHQ_DefSpot",RydHQG_DefSpot];
	if (isNil ("RydHQG_RecDefSpot")) then {RydHQG_RecDefSpot = []};
	_HQ setVariable ["RydHQ_RecDefSpot",RydHQG_RecDefSpot];
	if (isNil "RydHQG_Flare") then {RydHQG_Flare = true};
	_HQ setVariable ["RydHQ_Flare",RydHQG_Flare];
	if (isNil "RydHQG_Smoke") then {RydHQG_Smoke = true};
	_HQ setVariable ["RydHQ_Smoke",RydHQG_Smoke];
	if (isNil "RydHQG_NoRec") then {RydHQG_NoRec = 1};
	_HQ setVariable ["RydHQ_NoRec",RydHQG_NoRec];
	if (isNil "RydHQG_RapidCapt") then {RydHQG_RapidCapt = 10};
	_HQ setVariable ["RydHQ_RapidCapt",RydHQG_RapidCapt];
	if (isNil "RydHQG_Muu") then {RydHQG_Muu = 1};
	_HQ setVariable ["RydHQ_Muu",RydHQG_Muu];
	if (isNil "RydHQG_ArtyShells") then {RydHQG_ArtyShells = 1};
	_HQ setVariable ["RydHQ_ArtyShells",RydHQG_ArtyShells];
	if (isNil "RydHQG_Withdraw") then {RydHQG_Withdraw = 1};
	_HQ setVariable ["RydHQ_Withdraw",RydHQG_Withdraw];
	if (isNil "RydHQG_Berserk") then {RydHQG_Berserk = false};
	_HQ setVariable ["RydHQ_Berserk",RydHQG_Berserk];
	if (isNil "RydHQG_IDChance") then {RydHQG_IDChance = 100};
	_HQ setVariable ["RydHQ_IDChance",RydHQG_IDChance];
	if (isNil "RydHQG_RDChance") then {RydHQG_RDChance = 100};
	_HQ setVariable ["RydHQ_RDChance",RydHQG_RDChance];
	if (isNil "RydHQG_SDChance") then {RydHQG_SDChance = 100};
	_HQ setVariable ["RydHQ_SDChance",RydHQG_SDChance];
	if (isNil "RydHQG_AmmoDrop") then {RydHQG_AmmoDrop = []};
	_HQ setVariable ["RydHQ_AmmoDrop",RydHQG_AmmoDrop];
	if (isNil "RydHQG_SFTargets") then {RydHQG_SFTargets = []};
	_HQ setVariable ["RydHQ_SFTargets",RydHQG_SFTargets];
	if (isNil "RydHQG_LZ") then {RydHQG_LZ = false};
	_HQ setVariable ["RydHQ_LZ",RydHQG_LZ];
	if (isNil "RydHQG_SFBodyGuard") then {RydHQG_SFBodyGuard = []};
	_HQ setVariable ["RydHQ_SFBodyGuard",RydHQG_SFBodyGuard];
	if (isNil "RydHQG_DynForm") then {RydHQG_DynForm = false};
	_HQ setVariable ["RydHQ_DynForm",RydHQG_DynForm];
	if (isNil "RydHQG_UnlimitedCapt") then {RydHQG_UnlimitedCapt = false};
	_HQ setVariable ["RydHQ_UnlimitedCapt",RydHQG_UnlimitedCapt];
	if (isNil "RydHQG_CaptLimit") then {RydHQG_CaptLimit = 10};
	_HQ setVariable ["RydHQ_CaptLimit",RydHQG_CaptLimit];
	if (isNil "RydHQG_GetHQInside") then {RydHQG_GetHQInside = false};
	_HQ setVariable ["RydHQ_GetHQInside",RydHQG_GetHQInside];
	if (isNil "RydHQG_WA") then {RydHQG_WA = true};
	_HQ setVariable ["RydHQ_WA",RydHQG_WA];

	if (isNil "RydHQG_InfoMarkers") then {RydHQG_InfoMarkers = false};
	_HQ setVariable ["RydHQ_InfoMarkers",RydHQG_InfoMarkers];
	
	if (isNil "RydHQG_ArtyMarks") then {RydHQG_ArtyMarks = false};
	_HQ setVariable ["RydHQ_ArtyMarks",RydHQG_ArtyMarks];
	
	if (isNil ("RydHQG_ResetNow")) then {RydHQG_ResetNow = false};
	_HQ setVariable ["RydHQ_ResetNow",RydHQG_ResetNow];
	if (isNil ("RydHQG_ResetOnDemand")) then {RydHQG_ResetOnDemand = false};
	_HQ setVariable ["RydHQ_ResetOnDemand",RydHQG_ResetOnDemand];
	if (isNil ("RydHQG_ResetTime")) then {RydHQG_ResetTime = 600};
	_HQ setVariable ["RydHQ_ResetTime",RydHQG_ResetTime];
	if (isNil ("RydHQG_Combining")) then {RydHQG_Combining = false};
	_HQ setVariable ["RydHQ_Combining",RydHQG_Combining];
	if (isNil ("RydHQG_ObjRadius1")) then {RydHQG_ObjRadius1 = 300};
	_HQ setVariable ["RydHQ_ObjRadius1",RydHQG_ObjRadius1];
	if (isNil ("RydHQG_ObjRadius2")) then {RydHQG_ObjRadius2 = 500};
	_HQ setVariable ["RydHQ_ObjRadius2",RydHQG_ObjRadius2];
	if (isNil ("RydHQG_KnowTL")) then {RydHQG_KnowTL = true};
	_HQ setVariable ["RydHQ_KnowTL",RydHQG_KnowTL];
	
	if (isNil ("RydHQG_SMed")) then {RydHQG_SMed = true};
	_HQ setVariable ["RydHQ_SMed",RydHQG_SMed];
	if (isNil ("RydHQG_ExMedic")) then {RydHQG_ExMedic = []};
	_HQ setVariable ["RydHQ_ExMedic",RydHQG_ExMedic];
	if (isNil ("RydHQG_MedPoints")) then {RydHQG_MedPoints = []};
	_HQ setVariable ["RydHQ_MedPoints",RydHQG_MedPoints];
	if (isNil ("RydHQG_SupportedG")) then {RydHQG_SupportedG = []};
	_HQ setVariable ["RydHQ_SupportedG",RydHQG_SupportedG];
		
	if (isNil ("RydHQG_RCAS")) then {RydHQG_RCAS = []};
	_HQ setVariable ["RydHQ_RCAS",RydHQG_RCAS];
	if (isNil ("RydHQG_RCAP")) then {RydHQG_RCAP = []};
	_HQ setVariable ["RydHQ_RCAP",RydHQG_RCAP];
	
	if (isNil ("RydHQG_SFuel")) then {RydHQG_SFuel = true};
	_HQ setVariable ["RydHQ_SFuel",RydHQG_SFuel];
	if (isNil ("RydHQG_ExRefuel")) then {RydHQG_ExRefuel = []};
	_HQ setVariable ["RydHQ_ExRefuel",RydHQG_ExRefuel];
	if (isNil ("RydHQG_FuelPoints")) then {RydHQG_FuelPoints = []};
	_HQ setVariable ["RydHQ_FuelPoints",RydHQG_FuelPoints];
	if (isNil ("RydHQG_FSupportedG")) then {RydHQG_FSupportedG = []};
	_HQ setVariable ["RydHQ_FSupportedG",RydHQG_FSupportedG];
	
	if (isNil ("RydHQG_SAmmo")) then {RydHQG_SAmmo = true};
	_HQ setVariable ["RydHQ_SAmmo",RydHQG_SAmmo];
	if (isNil ("RydHQG_ExReammo")) then {RydHQG_ExReammo = []};
	_HQ setVariable ["RydHQ_ExReammo",RydHQG_ExReammo];
	if (isNil ("RydHQG_AmmoPoints")) then {RydHQG_AmmoPoints = []};
	_HQ setVariable ["RydHQ_AmmoPoints",RydHQG_AmmoPoints];
	if (isNil ("RydHQG_ASupportedG")) then {RydHQG_ASupportedG = []};
	_HQ setVariable ["RydHQ_ASupportedG",RydHQG_ASupportedG];
	
	if (isNil ("RydHQG_SRep")) then {RydHQG_SRep = true};
	_HQ setVariable ["RydHQ_SRep",RydHQG_SRep];
	if (isNil ("RydHQG_ExRepair")) then {RydHQG_ExRepair = []};
	_HQ setVariable ["RydHQ_ExRepair",RydHQG_ExRepair];
	if (isNil ("RydHQG_RepPoints")) then {RydHQG_RepPoints = []};
	_HQ setVariable ["RydHQ_RepPoints",RydHQG_RepPoints];
	if (isNil ("RydHQG_RSupportedG")) then {RydHQG_RSupportedG = []};
	_HQ setVariable ["RydHQ_RSupportedG",RydHQG_RSupportedG];
	
	if (isNil "RydHQG_AirDist") then {RydHQG_AirDist = 4000};
	_HQ setVariable ["RydHQ_AirDist",RydHQG_AirDist];
	
	if (isNil ("RydHQG_CommDelay")) then {RydHQG_CommDelay = 1};
	_HQ setVariable ["RydHQ_CommDelay",RydHQG_CommDelay];


	if ((isNil ("RydHQG_Order")) and (isNil {_HQ getVariable "RydHQ_Order"})) then {_HQ setVariable ["RydHQ_Order","ATTACK"]};
	if ( not (isNil ("RydHQG_Order"))) then {
		if (RydHQG_Order == "DEFEND") then {
			_HQ setVariable ["RydHQ_Order","DEFEND"]
		} else {
			_HQ setVariable ["RydHQ_Order","ATTACK"]
		};
	};

	if (isNil ("RydHQG_AttackAlways")) then {RydHQG_AttackAlways = false};
	_HQ setVariable ["RydHQ_AttackAlways",RydHQG_AttackAlways];

	if (isNil ("RydHQG_CRDefRes")) then {RydHQG_CRDefRes = 0};
	_HQ setVariable ["RydHQ_CRDefRes",RydHQG_CRDefRes];

	if (isNil ("RydHQG_ReconReserve")) then {RydHQG_ReconReserve = (0.3 * (0.5 + (_HQ getVariable ["RydHQ_Circumspection",0.5])))};
	_HQ setVariable ["RydHQ_ReconReserve",RydHQG_ReconReserve];
	if (isNil ("RydHQG_Exhausted")) then {RydHQG_Exhausted = []};
	_HQ setVariable ["RydHQ_Exhausted",RydHQG_Exhausted];
	if (isNil ("RydHQG_AttackReserve")) then {RydHQG_AttackReserve = (0.5 * (0.5 + ((_HQ getVariable ["RydHQ_Circumspection",0.5])/1.5)))};
	_HQ setVariable ["RydHQ_AttackReserve",RydHQG_AttackReserve];
	if (isNil ("RydHQG_IdleOrd")) then {RydHQG_IdleOrd = true};
	_HQ setVariable ["RydHQ_IdleOrd",RydHQG_IdleOrd];

	if (isNil ("RydHQG_IdleDef")) then {RydHQG_IdleDef = true};
	_HQ setVariable ["RydHQ_IdleDef",RydHQG_IdleDef];

	if (isNil "RydHQG_IdleDecoy") then {RydHQG_IdleDecoy = objNull};
	_HQ setVariable ["RydHQ_IdleDecoy",RydHQG_IdleDecoy]; 
	if (isNil "RydHQG_SupportDecoy") then {RydHQG_SupportDecoy = objNull};
	_HQ setVariable ["RydHQ_SupportDecoy",RydHQG_SupportDecoy]; 
	if (isNil "RydHQG_RestDecoy") then {RydHQG_RestDecoy = objNull};
	_HQ setVariable ["RydHQ_RestDecoy",RydHQG_RestDecoy]; 
	if (isNil "RydHQG_Sec1") then {RydHQG_Sec1 = objNull};
	_HQ setVariable ["RydHQ_Sec1",RydHQG_Sec1]; 
	if (isNil "RydHQG_Sec2") then {RydHQG_Sec2 = objNull};
	_HQ setVariable ["RydHQ_Sec2",RydHQG_Sec2]; 

	if (isNil "RydHQG_SupportRTB") then {RydHQG_SupportRTB = false};
	_HQ setVariable ["RydHQ_SupportRTB",RydHQG_SupportRTB];
	
	if (isNil "RydHQG_Debug") then {RydHQG_Debug = false};
	_HQ setVariable ["RydHQ_Debug",RydHQG_Debug]; 
	if (isNil "RydHQG_DebugII") then {RydHQG_DebugII = false};
	_HQ setVariable ["RydHQ_DebugII",RydHQG_DebugII]; 
	
	if (isNil "RydHQG_AlwaysKnownU") then {RydHQG_AlwaysKnownU = []};
	_HQ setVariable ["RydHQ_AlwaysKnownU",RydHQG_AlwaysKnownU]; 
	if (isNil "RydHQG_AlwaysUnKnownU") then {RydHQG_AlwaysUnKnownU = []};
	_HQ setVariable ["RydHQ_AlwaysUnKnownU",RydHQG_AlwaysUnKnownU];
	
	if (isNil "RydHQG_AOnly") then {RydHQG_AOnly = []};
	_HQ setVariable ["RydHQ_AOnly",RydHQG_AOnly]; 
	if (isNil "RydHQG_ROnly") then {RydHQG_ROnly = []};
	_HQ setVariable ["RydHQ_ROnly",RydHQG_ROnly]; 
	
	if (isNil "RydHQG_AirEvac") then {RydHQG_AirEvac = false};
	_HQ setVariable ["RydHQ_AirEvac",RydHQG_AirEvac]; 
	
	if (isNil "RydHQG_AAO") then {RydHQG_AAO = false};
	_HQ setVariable ["RydHQ_AAO",RydHQG_AAO]; 
	if (isNil "RydHQG_ForceAAO") then {RydHQG_ForceAAO = false};
	_HQ setVariable ["RydHQ_ForceAAO",RydHQG_ForceAAO];
	

	if (isNil "RydHQG_BBAOObj") then {RydHQG_BBAOObj = 1};
	_HQ setVariable ["RydHQ_BBAOObj",RydHQG_BBAOObj]; 
	
	if (isNil ("RydHQG_MoraleConst")) then {RydHQG_MoraleConst = 1};
	_HQ setVariable ["RydHQ_MoraleConst",RydHQG_MoraleConst];
	
	if (isNil ("RydHQG_OffTend")) then {RydHQG_OffTend = 1};
	_HQ setVariable ["RydHQ_OffTend",RydHQG_OffTend];
	
	if (isNil "RydHQG_EBDoctrine") then {RydHQG_EBDoctrine = false};
	_HQ setVariable ["RydHQ_EBDoctrine",RydHQG_EBDoctrine]; 
	if (isNil "RydHQG_ForceEBDoctrine") then {RydHQG_ForceEBDoctrine = false};
	_HQ setVariable ["RydHQ_ForceEBDoctrine",RydHQG_ForceEBDoctrine]; 
	
	if (isNil "RydHQG_DefRange") then {RydHQG_DefRange = 1};
	_HQ setVariable ["RydHQ_DefRange",RydHQG_DefRange];
	if (isNil "RydHQG_GarrRange") then {RydHQG_GarrRange = 1};
	_HQ setVariable ["RydHQ_GarrRange",RydHQG_GarrRange];
	
	if (isNil "RydHQG_NoCapt") then {RydHQG_NoCapt = []};
	_HQ setVariable ["RydHQ_NoCapt",RydHQ_NoCapt];
	
	if (isNil "RydHQG_AttInfDistance") then {RydHQG_AttInfDistance = 1};
	_HQ setVariable ["RydHQ_AttInfDistance",RydHQG_AttInfDistance];
	if (isNil "RydHQG_AttArmDistance") then {RydHQG_AttArmDistance = 1};
	_HQ setVariable ["RydHQ_AttArmDistance",RydHQG_AttArmDistance];
	if (isNil "RydHQG_AttSnpDistance") then {RydHQG_AttSnpDistance = 1};
	_HQ setVariable ["RydHQ_AttSnpDistance",RydHQG_AttSnpDistance];
	if (isNil "RydHQG_CaptureDistance") then {RydHQG_CaptureDistance = 1};
	_HQ setVariable ["RydHQ_CaptureDistance",RydHQG_CaptureDistance];	
	if (isNil "RydHQG_FlankDistance") then {RydHQG_FlankDistance = 1};
	_HQ setVariable ["RydHQ_FlankDistance",RydHQG_FlankDistance];
	if (isNil "RydHQG_AttSFDistance") then {RydHQG_AttSFDistance = 1};
	_HQ setVariable ["RydHQ_AttSFDistance",RydHQG_AttSFDistance];
	if (isNil "RydHQG_ReconDistance") then {RydHQG_ReconDistance = 1};
	_HQ setVariable ["RydHQ_ReconDistance",RydHQG_ReconDistance];
	if (isNil "RydHQG_UAVAlt") then {RydHQG_UAVAlt = 150};
	_HQ setVariable ["RydHQ_UAVAlt",RydHQG_UAVAlt];
	
	if (isNil "RydHQG_Obj1") then {RydHQG_Obj1 = createTrigger ["EmptyDetector", leaderHQG]};
	if (isNil "RydHQG_Obj2") then {RydHQG_Obj2 = createTrigger ["EmptyDetector", leaderHQG]};
	if (isNil "RydHQG_Obj3") then {RydHQG_Obj3 = createTrigger ["EmptyDetector", leaderHQG]};
	if (isNil "RydHQG_Obj4") then {RydHQG_Obj4 = createTrigger ["EmptyDetector", leaderHQG]};
	
	_HQ setVariable ["RydHQ_Obj1",RydHQG_Obj1];
	_HQ setVariable ["RydHQ_Obj2",RydHQG_Obj2];
	_HQ setVariable ["RydHQ_Obj3",RydHQG_Obj3];
	_HQ setVariable ["RydHQ_Obj4",RydHQG_Obj4];
	
	_objectives = [RydHQG_Obj1,RydHQG_Obj2,RydHQG_Obj3,RydHQG_Obj4];
	_NAVObjectives = [];

	if (isNil ("RydHQG_SimpleMode")) then {RydHQG_SimpleMode = true};
	_HQ setVariable ["RydHQ_SimpleMode",RydHQG_SimpleMode];

	if (isNil ("RydHQG_SecTasks")) then {RydHQG_SecTasks = false};
	_HQ setVariable ["RydHQ_SecTasks",RydHQG_SecTasks];
	
	if (isNil ("RydHQG_SimpleObjs")) then {RydHQG_SimpleObjs = []};
	_HQ setVariable ["RydHQ_SimpleObjs",RydHQG_SimpleObjs];

	if (isNil ("RydHQG_NavalObjs")) then {RydHQG_NavalObjs = []};
	_HQ setVariable ["RydHQ_NavalObjs",RydHQG_NavalObjs];

	if (isNil ("RydHQG_MaxSimpleObjs")) then {RydHQG_MaxSimpleObjs = 5};
	_HQ setVariable ["RydHQ_MaxSimpleObjs",RydHQG_MaxSimpleObjs];

	if (_HQ getVariable ["RydHQ_SimpleMode",false]) then {

		_objectives = RydHQG_SimpleObjs;
		_NAVObjectives = RydHQG_NavalObjs;
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
			
	if not (isNil "RydHQG_DefFrontL") then {_HQ setVariable ["RydHQ_DefFrontL",RydHQG_DefFrontL]};
	if not (isNil "RydHQG_DefFront1") then {_HQ setVariable ["RydHQ_DefFront1",RydHQG_DefFront1]};
	if not (isNil "RydHQG_DefFront2") then {_HQ setVariable ["RydHQ_DefFront2",RydHQG_DefFront2]};
	if not (isNil "RydHQG_DefFront3") then {_HQ setVariable ["RydHQ_DefFront3",RydHQG_DefFront3]};
	if not (isNil "RydHQG_DefFront4") then {_HQ setVariable ["RydHQ_DefFront4",RydHQG_DefFront4]};
	
	_civF = ["CIV_F","CIV","CIV_RU","BIS_TK_CIV","BIS_CIV_special"];
	if not (isNil ("RydHQG_CivF")) then {_civF = RydHQG_CivF};
	_HQ setVariable ["RydHQ_CivF",_civF];
	
	if (isNil ("RydHQG_Def")) then {RydHQG_Def = []};
	_HQ setVariable ["RydHQ_Def",RydHQG_Def];
	
	_nObj = _HQ getVariable ["RydHQ_NObj",1];

	switch (_nObj) do
		{
		case (1) : {_HQ setVariable ["RydHQ_Obj",RydHQG_Obj1]};
		case (2) : {_HQ setVariable ["RydHQ_Obj",RydHQG_Obj2]};
		case (3) : {_HQ setVariable ["RydHQ_Obj",RydHQG_Obj3]};
		default {_HQ setVariable ["RydHQ_Obj",RydHQG_Obj4]};
		};
		
	call RYD_StatusQuo;
	};