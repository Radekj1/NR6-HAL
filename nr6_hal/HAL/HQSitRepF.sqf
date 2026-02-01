_SCRname = "SitRepF";
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

if (isNil ("RydHQF_MAtt")) then {RydHQF_MAtt = false};
_HQ setVariable ["RydHQ_MAtt",RydHQF_MAtt];
if ((isNil ("RydHQF_Personality")) or not (_HQ getVariable ["RydHQ_MAtt",false])) then {RydHQF_Personality = "OTHER"};
_HQ setVariable ["RydHQ_Personality",RydHQF_Personality];

if (isNil ("RydHQF_Recklessness")) then {RydHQF_Recklessness = 0.5};
_HQ setVariable ["RydHQ_Recklessness",RydHQF_Recklessness];
if (isNil ("RydHQF_Consistency")) then {RydHQF_Consistency = 0.5};
_HQ setVariable ["RydHQ_Consistency",RydHQF_Consistency];
if (isNil ("RydHQF_Activity")) then {RydHQF_Activity = 0.5};
_HQ setVariable ["RydHQ_Activity",RydHQF_Activity];
if (isNil ("RydHQF_Reflex")) then {RydHQF_Reflex = 0.5};
_HQ setVariable ["RydHQ_Reflex",RydHQF_Reflex];
if (isNil ("RydHQF_Circumspection")) then {RydHQF_Circumspection = 0.5};
_HQ setVariable ["RydHQ_Circumspection",RydHQF_Circumspection];
if (isNil ("RydHQF_Fineness")) then {RydHQF_Fineness = 0.5};
_HQ setVariable ["RydHQ_Fineness",RydHQF_Fineness];

[_HQ] call HAL_Personality;

[[_HQ],HAL_LHQ] call RYD_Spawn;

if (isNil ("RydHQF_Boxed")) then {RydHQF_Boxed = []};
_HQ setVariable ["RydHQ_Boxed",RydHQF_Boxed];

if (isNil ("RydHQF_AmmoBoxes")) then 
	{
	RydHQF_AmmoBoxes = [];

	if not (isNil "RydHQF_AmmoDepot") then 
		{
		_rds = (triggerArea RydHQF_AmmoDepot) select 0;
		RydHQF_AmmoBoxes = (getPosATL RydHQF_AmmoDepot) nearObjects ["ReammoBox_F",_rds]
		}
	};
	
_HQ setVariable ["RydHQ_AmmoBoxes",RydHQF_AmmoBoxes];

_HQ setVariable ["RydHQ_ReconDone",false];
_HQ setVariable ["RydHQ_DefDone",false];
_HQ setVariable ["RydHQ_ReconStage",1];
_HQ setVariable ["RydHQ_ReconStage2",1];
_HQ setVariable ["RydHQ_AirInDef",[]];

_KnEnPos = [];

if (isNil ("RydHQF_Excluded")) then {RydHQF_Excluded = []};
_HQ setVariable ["RydHQ_Excluded",RydHQF_Excluded];
if (isNil ("RydHQF_Fast")) then {RydHQF_Fast = false};
_HQ setVariable ["RydHQ_Fast",RydHQF_Fast];
if (isNil ("RydHQF_ExInfo")) then {RydHQF_ExInfo = false};
_HQ setVariable ["RydHQ_ExInfo",RydHQF_ExInfo];
if (isNil ("RydHQF_ObjHoldTime")) then {RydHQF_ObjHoldTime = 600};
_HQ setVariable ["RydHQ_ObjHoldTime",RydHQF_ObjHoldTime];
if (isNil "RydHQF_NObj") then {RydHQF_NObj = 1};
_HQ setVariable ["RydHQ_NObj",RydHQF_NObj];

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

if (isNil ("RydHQF_SupportWP")) then {RydHQF_SupportWP = false};
	
_HQ setVariable ["RydHQ_SupportWP",RydHQF_SupportWP];

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
	
	if (isNil "RydHQF_Garrison") then {RydHQF_Garrison = []};
	_HQ setVariable ["RydHQ_Garrison",RydHQF_Garrison];
	
	if (isNil ("RydHQF_NoAirCargo")) then {RydHQF_NoAirCargo = false};
	_HQ setVariable ["RydHQ_NoAirCargo",RydHQF_NoAirCargo];
	if (isNil ("RydHQF_NoLandCargo")) then {RydHQF_NoLandCargo = false};
	_HQ setVariable ["RydHQ_NoLandCargo",RydHQF_NoLandCargo];
	if (isNil ("RydHQF_LastFriends")) then {RydHQF_LastFriends = []};
	_HQ setVariable ["RydHQ_LastFriends",RydHQF_LastFriends];
	if (isNil ("RydHQF_CargoFind")) then {RydHQF_CargoFind = 1};
	_HQ setVariable ["RydHQ_CargoFind",RydHQF_CargoFind];
	if (isNil ("RydHQF_Subordinated")) then {RydHQF_Subordinated = []};
	_HQ setVariable ["RydHQ_Subordinated",RydHQF_Subordinated];
	if (isNil ("RydHQF_Included")) then {RydHQF_Included = []};
	_HQ setVariable ["RydHQ_Included",RydHQF_Included];
	if (isNil ("RydHQF_Excluded")) then {RydHQF_Excluded = []};
	_HQ setVariable ["RydHQ_Excluded",RydHQF_Excluded];
	if (isNil ("RydHQF_SubAll")) then {RydHQF_SubAll = true};
	_HQ setVariable ["RydHQ_SubAll",RydHQF_SubAll];
	if (isNil ("RydHQF_SubSynchro")) then {RydHQF_SubSynchro = false};
	_HQ setVariable ["RydHQ_SubSynchro",RydHQF_SubSynchro];
	if (isNil ("RydHQF_SubNamed")) then {RydHQF_SubNamed = false};
	_HQ setVariable ["RydHQ_SubNamed",RydHQF_SubNamed];
	if (isNil ("RydHQF_SubZero")) then {RydHQF_SubZero = false};
	_HQ setVariable ["RydHQ_SubZero",RydHQF_SubZero];
	if (isNil ("RydHQF_ReSynchro")) then {RydHQF_ReSynchro = true};
	_HQ setVariable ["RydHQ_ReSynchro",RydHQF_ReSynchro];
	if (isNil ("RydHQF_NameLimit")) then {RydHQF_NameLimit = 100};
	_HQ setVariable ["RydHQ_NameLimit",RydHQF_NameLimit];
	if (isNil ("RydHQF_Surr")) then {RydHQF_Surr = false};
	_HQ setVariable ["RydHQ_Surr",RydHQF_Surr];
	if (isNil ("RydHQF_NoRecon")) then {RydHQF_NoRecon = []};
	_HQ setVariable ["RydHQ_NoRecon",RydHQF_NoRecon];
	if (isNil ("RydHQF_NoAttack")) then {RydHQF_NoAttack = []};
	_HQ setVariable ["RydHQ_NoAttack",RydHQF_NoAttack];
	if (isNil ("RydHQF_CargoOnly")) then {RydHQF_CargoOnly = []};
	_HQ setVariable ["RydHQ_CargoOnly",RydHQF_CargoOnly];
	if (isNil ("RydHQF_NoCargo")) then {RydHQF_NoCargo = []};
	_HQ setVariable ["RydHQ_NoCargo",RydHQF_NoCargo];
	if (isNil ("RydHQF_NoFlank")) then {RydHQF_NoFlank = []};
	_HQ setVariable ["RydHQ_NoFlank",RydHQF_NoFlank];
	if (isNil ("RydHQF_NoDef")) then {RydHQF_NoDef = []};
	_HQ setVariable ["RydHQ_NoDef",RydHQF_NoDef];
	if (isNil ("RydHQF_FirstToFight")) then {RydHQF_FirstToFight = []};
	_HQ setVariable ["RydHQ_FirstToFight",RydHQF_FirstToFight];
	if (isNil ("RydHQF_VoiceComm")) then {RydHQF_VoiceComm = true};
	_HQ setVariable ["RydHQ_VoiceComm",RydHQF_VoiceComm];
	if (isNil ("RydHQF_FrontA")) then {RydHQF_Front = false};
	_HQ setVariable ["RydHQ_FrontA",RydHQF_Front];
	if (isNil ("RydHQF_LRelocating")) then {RydHQF_LRelocating = false};
	_HQ setVariable ["RydHQ_LRelocating",RydHQF_LRelocating];
	if (isNil ("RydHQF_Flee")) then {RydHQF_Flee = true};
	_HQ setVariable ["RydHQ_Flee",RydHQF_Flee];
	if (isNil ("RydHQF_GarrR")) then {RydHQF_GarrR = 500};
	_HQ setVariable ["RydHQ_GarrR",RydHQF_GarrR];
	if (isNil ("RydHQF_Rush")) then {RydHQF_Rush = false};
	_HQ setVariable ["RydHQ_Rush",RydHQF_Rush];
	if (isNil ("RydHQF_GarrVehAb")) then {RydHQF_GarrVehAb = false};
	_HQ setVariable ["RydHQ_GarrVehAb",RydHQF_GarrVehAb];
	if (isNil ("RydHQF_DefendObjectives")) then {RydHQF_DefendObjectives = 4};
	_HQ setVariable ["RydHQ_DefendObjectives",RydHQF_DefendObjectives];
	if (isNil ("RydHQF_DefSpot")) then {RydHQF_DefSpot = []};
	_HQ setVariable ["RydHQ_DefSpot",RydHQF_DefSpot];
	if (isNil ("RydHQF_RecDefSpot")) then {RydHQF_RecDefSpot = []};
	_HQ setVariable ["RydHQ_RecDefSpot",RydHQF_RecDefSpot];
	if (isNil "RydHQF_Flare") then {RydHQF_Flare = true};
	_HQ setVariable ["RydHQ_Flare",RydHQF_Flare];
	if (isNil "RydHQF_Smoke") then {RydHQF_Smoke = true};
	_HQ setVariable ["RydHQ_Smoke",RydHQF_Smoke];
	if (isNil "RydHQF_NoRec") then {RydHQF_NoRec = 1};
	_HQ setVariable ["RydHQ_NoRec",RydHQF_NoRec];
	if (isNil "RydHQF_RapidCapt") then {RydHQF_RapidCapt = 10};
	_HQ setVariable ["RydHQ_RapidCapt",RydHQF_RapidCapt];
	if (isNil "RydHQF_Muu") then {RydHQF_Muu = 1};
	_HQ setVariable ["RydHQ_Muu",RydHQF_Muu];
	if (isNil "RydHQF_ArtyShells") then {RydHQF_ArtyShells = 1};
	_HQ setVariable ["RydHQ_ArtyShells",RydHQF_ArtyShells];
	if (isNil "RydHQF_Withdraw") then {RydHQF_Withdraw = 1};
	_HQ setVariable ["RydHQ_Withdraw",RydHQF_Withdraw];
	if (isNil "RydHQF_Berserk") then {RydHQF_Berserk = false};
	_HQ setVariable ["RydHQ_Berserk",RydHQF_Berserk];
	if (isNil "RydHQF_IDChance") then {RydHQF_IDChance = 100};
	_HQ setVariable ["RydHQ_IDChance",RydHQF_IDChance];
	if (isNil "RydHQF_RDChance") then {RydHQF_RDChance = 100};
	_HQ setVariable ["RydHQ_RDChance",RydHQF_RDChance];
	if (isNil "RydHQF_SDChance") then {RydHQF_SDChance = 100};
	_HQ setVariable ["RydHQ_SDChance",RydHQF_SDChance];
	if (isNil "RydHQF_AmmoDrop") then {RydHQF_AmmoDrop = []};
	_HQ setVariable ["RydHQ_AmmoDrop",RydHQF_AmmoDrop];
	if (isNil "RydHQF_SFTargets") then {RydHQF_SFTargets = []};
	_HQ setVariable ["RydHQ_SFTargets",RydHQF_SFTargets];
	if (isNil "RydHQF_LZ") then {RydHQF_LZ = false};
	_HQ setVariable ["RydHQ_LZ",RydHQF_LZ];
	if (isNil "RydHQF_SFBodyGuard") then {RydHQF_SFBodyGuard = []};
	_HQ setVariable ["RydHQ_SFBodyGuard",RydHQF_SFBodyGuard];
	if (isNil "RydHQF_DynForm") then {RydHQF_DynForm = false};
	_HQ setVariable ["RydHQ_DynForm",RydHQF_DynForm];
	if (isNil "RydHQF_UnlimitedCapt") then {RydHQF_UnlimitedCapt = false};
	_HQ setVariable ["RydHQ_UnlimitedCapt",RydHQF_UnlimitedCapt];
	if (isNil "RydHQF_CaptLimit") then {RydHQF_CaptLimit = 10};
	_HQ setVariable ["RydHQ_CaptLimit",RydHQF_CaptLimit];
	if (isNil "RydHQF_GetHQInside") then {RydHQF_GetHQInside = false};
	_HQ setVariable ["RydHQ_GetHQInside",RydHQF_GetHQInside];
	if (isNil "RydHQF_WA") then {RydHQF_WA = true};
	_HQ setVariable ["RydHQ_WA",RydHQF_WA];

	if (isNil "RydHQF_InfoMarkers") then {RydHQF_InfoMarkers = false};
	_HQ setVariable ["RydHQ_InfoMarkers",RydHQF_InfoMarkers];

	if (isNil "RydHQF_ArtyMarks") then {RydHQF_ArtyMarks = false};
	_HQ setVariable ["RydHQ_ArtyMarks",RydHQF_ArtyMarks];
		
	if (isNil ("RydHQF_ResetNow")) then {RydHQF_ResetNow = false};
	_HQ setVariable ["RydHQ_ResetNow",RydHQF_ResetNow];
	if (isNil ("RydHQF_ResetOnDemand")) then {RydHQF_ResetOnDemand = false};
	_HQ setVariable ["RydHQ_ResetOnDemand",RydHQF_ResetOnDemand];
	if (isNil ("RydHQF_ResetTime")) then {RydHQF_ResetTime = 600};
	_HQ setVariable ["RydHQ_ResetTime",RydHQF_ResetTime];
	if (isNil ("RydHQF_Combining")) then {RydHQF_Combining = false};
	_HQ setVariable ["RydHQ_Combining",RydHQF_Combining];
	if (isNil ("RydHQF_ObjRadius1")) then {RydHQF_ObjRadius1 = 300};
	_HQ setVariable ["RydHQ_ObjRadius1",RydHQF_ObjRadius1];
	if (isNil ("RydHQF_ObjRadius2")) then {RydHQF_ObjRadius2 = 500};
	_HQ setVariable ["RydHQ_ObjRadius2",RydHQF_ObjRadius2];
	if (isNil ("RydHQF_KnowTL")) then {RydHQF_KnowTL = true};
	_HQ setVariable ["RydHQ_KnowTL",RydHQF_KnowTL];
	
	if (isNil ("RydHQF_SMed")) then {RydHQF_SMed = true};
	_HQ setVariable ["RydHQ_SMed",RydHQF_SMed];
	if (isNil ("RydHQF_ExMedic")) then {RydHQF_ExMedic = []};
	_HQ setVariable ["RydHQ_ExMedic",RydHQF_ExMedic];
	if (isNil ("RydHQF_MedPoints")) then {RydHQF_MedPoints = []};
	_HQ setVariable ["RydHQ_MedPoints",RydHQF_MedPoints];
	if (isNil ("RydHQF_SupportedG")) then {RydHQF_SupportedG = []};
	_HQ setVariable ["RydHQ_SupportedG",RydHQF_SupportedG];
		
	if (isNil ("RydHQF_RCAS")) then {RydHQF_RCAS = []};
	_HQ setVariable ["RydHQ_RCAS",RydHQF_RCAS];
	if (isNil ("RydHQF_RCAP")) then {RydHQF_RCAP = []};
	_HQ setVariable ["RydHQ_RCAP",RydHQF_RCAP];
	
	if (isNil ("RydHQF_SFuel")) then {RydHQF_SFuel = true};
	_HQ setVariable ["RydHQ_SFuel",RydHQF_SFuel];
	if (isNil ("RydHQF_ExRefuel")) then {RydHQF_ExRefuel = []};
	_HQ setVariable ["RydHQ_ExRefuel",RydHQF_ExRefuel];
	if (isNil ("RydHQF_FuelPoints")) then {RydHQF_FuelPoints = []};
	_HQ setVariable ["RydHQ_FuelPoints",RydHQF_FuelPoints];
	if (isNil ("RydHQF_FSupportedG")) then {RydHQF_FSupportedG = []};
	_HQ setVariable ["RydHQ_FSupportedG",RydHQF_FSupportedG];
	
	if (isNil ("RydHQF_SAmmo")) then {RydHQF_SAmmo = true};
	_HQ setVariable ["RydHQ_SAmmo",RydHQF_SAmmo];
	if (isNil ("RydHQF_ExReammo")) then {RydHQF_ExReammo = []};
	_HQ setVariable ["RydHQ_ExReammo",RydHQF_ExReammo];
	if (isNil ("RydHQF_AmmoPoints")) then {RydHQF_AmmoPoints = []};
	_HQ setVariable ["RydHQ_AmmoPoints",RydHQF_AmmoPoints];
	if (isNil ("RydHQF_ASupportedG")) then {RydHQF_ASupportedG = []};
	_HQ setVariable ["RydHQ_ASupportedG",RydHQF_ASupportedG];
	
	if (isNil ("RydHQF_SRep")) then {RydHQF_SRep = true};
	_HQ setVariable ["RydHQ_SRep",RydHQF_SRep];
	if (isNil ("RydHQF_ExRepair")) then {RydHQF_ExRepair = []};
	_HQ setVariable ["RydHQ_ExRepair",RydHQF_ExRepair];
	if (isNil ("RydHQF_RepPoints")) then {RydHQF_RepPoints = []};
	_HQ setVariable ["RydHQ_RepPoints",RydHQF_RepPoints];
	if (isNil ("RydHQF_RSupportedG")) then {RydHQF_RSupportedG = []};
	_HQ setVariable ["RydHQ_RSupportedG",RydHQF_RSupportedG];
	
	if (isNil "RydHQF_AirDist") then {RydHQF_AirDist = 4000};
	_HQ setVariable ["RydHQ_AirDist",RydHQF_AirDist];
	
	if (isNil ("RydHQF_CommDelay")) then {RydHQF_CommDelay = 1};
	_HQ setVariable ["RydHQ_CommDelay",RydHQF_CommDelay];


	if ((isNil ("RydHQF_Order")) and (isNil {_HQ getVariable "RydHQ_Order"})) then {_HQ setVariable ["RydHQ_Order","ATTACK"]};
	if ( not (isNil ("RydHQF_Order"))) then {
		if (RydHQF_Order == "DEFEND") then {
			_HQ setVariable ["RydHQ_Order","DEFEND"]
		} else {
			_HQ setVariable ["RydHQ_Order","ATTACK"]
		};
	};

	if (isNil ("RydHQF_AttackAlways")) then {RydHQF_AttackAlways = false};
	_HQ setVariable ["RydHQ_AttackAlways",RydHQF_AttackAlways];

	if (isNil ("RydHQF_CRDefRes")) then {RydHQF_CRDefRes = 0};
	_HQ setVariable ["RydHQ_CRDefRes",RydHQF_CRDefRes];

	if (isNil ("RydHQF_ReconReserve")) then {RydHQF_ReconReserve = (0.3 * (0.5 + (_HQ getVariable ["RydHQ_Circumspection",0.5])))};
	_HQ setVariable ["RydHQ_ReconReserve",RydHQF_ReconReserve];
	if (isNil ("RydHQF_Exhausted")) then {RydHQF_Exhausted = []};
	_HQ setVariable ["RydHQ_Exhausted",RydHQF_Exhausted];
	if (isNil ("RydHQF_AttackReserve")) then {RydHQF_AttackReserve = (0.5 * (0.5 + ((_HQ getVariable ["RydHQ_Circumspection",0.5])/1.5)))};
	_HQ setVariable ["RydHQ_AttackReserve",RydHQF_AttackReserve];
	if (isNil ("RydHQF_IdleOrd")) then {RydHQF_IdleOrd = true};
	_HQ setVariable ["RydHQ_IdleOrd",RydHQF_IdleOrd];

	if (isNil ("RydHQF_IdleDef")) then {RydHQF_IdleDef = true};
	_HQ setVariable ["RydHQ_IdleDef",RydHQF_IdleDef];

	if (isNil "RydHQF_IdleDecoy") then {RydHQF_IdleDecoy = objNull};
	_HQ setVariable ["RydHQ_IdleDecoy",RydHQF_IdleDecoy]; 
	if (isNil "RydHQF_SupportDecoy") then {RydHQF_SupportDecoy = objNull};
	_HQ setVariable ["RydHQ_SupportDecoy",RydHQF_SupportDecoy]; 
	if (isNil "RydHQF_RestDecoy") then {RydHQF_RestDecoy = objNull};
	_HQ setVariable ["RydHQ_RestDecoy",RydHQF_RestDecoy]; 
	if (isNil "RydHQF_Sec1") then {RydHQF_Sec1 = objNull};
	_HQ setVariable ["RydHQ_Sec1",RydHQF_Sec1]; 
	if (isNil "RydHQF_Sec2") then {RydHQF_Sec2 = objNull};
	_HQ setVariable ["RydHQ_Sec2",RydHQF_Sec2];

	if (isNil "RydHQF_SupportRTB") then {RydHQF_SupportRTB = false};
	_HQ setVariable ["RydHQ_SupportRTB",RydHQF_SupportRTB];
	
 	if (isNil "RydHQF_Debug") then {RydHQF_Debug = false};
	_HQ setVariable ["RydHQ_Debug",RydHQF_Debug]; 
	if (isNil "RydHQF_DebugII") then {RydHQF_DebugII = false};
	_HQ setVariable ["RydHQ_DebugII",RydHQF_DebugII];
	
	if (isNil "RydHQF_AlwaysKnownU") then {RydHQF_AlwaysKnownU = []};
	_HQ setVariable ["RydHQ_AlwaysKnownU",RydHQF_AlwaysKnownU]; 
	if (isNil "RydHQF_AlwaysUnKnownU") then {RydHQF_AlwaysUnKnownU = []};
	_HQ setVariable ["RydHQ_AlwaysUnKnownU",RydHQF_AlwaysUnKnownU]; 
	
	if (isNil "RydHQF_AOnly") then {RydHQF_AOnly = []};
	_HQ setVariable ["RydHQ_AOnly",RydHQF_AOnly]; 
	if (isNil "RydHQF_ROnly") then {RydHQF_ROnly = []};
	_HQ setVariable ["RydHQ_ROnly",RydHQF_ROnly]; 
	
	if (isNil "RydHQF_AirEvac") then {RydHQF_AirEvac = false};
	_HQ setVariable ["RydHQ_AirEvac",RydHQF_AirEvac]; 
	
	if (isNil "RydHQF_AAO") then {RydHQF_AAO = false};
	_HQ setVariable ["RydHQ_AAO",RydHQF_AAO]; 
	if (isNil "RydHQF_ForceAAO") then {RydHQF_ForceAAO = false};
	_HQ setVariable ["RydHQ_ForceAAO",RydHQF_ForceAAO];
	

	if (isNil "RydHQF_BBAOObj") then {RydHQF_BBAOObj = 1};
	_HQ setVariable ["RydHQ_BBAOObj",RydHQF_BBAOObj]; 
	
	if (isNil ("RydHQF_MoraleConst")) then {RydHQF_MoraleConst = 1};
	_HQ setVariable ["RydHQ_MoraleConst",RydHQF_MoraleConst];
	
	if (isNil ("RydHQF_OffTend")) then {RydHQF_OffTend = 1};
	_HQ setVariable ["RydHQ_OffTend",RydHQF_OffTend];
	
	if (isNil "RydHQF_EBDoctrine") then {RydHQF_EBDoctrine = false};
	_HQ setVariable ["RydHQ_EBDoctrine",RydHQF_EBDoctrine]; 
	if (isNil "RydHQF_ForceEBDoctrine") then {RydHQF_ForceEBDoctrine = false};
	_HQ setVariable ["RydHQ_ForceEBDoctrine",RydHQF_ForceEBDoctrine]; 
	
	if (isNil "RydHQF_DefRange") then {RydHQF_DefRange = 1};
	_HQ setVariable ["RydHQ_DefRange",RydHQF_DefRange];
	if (isNil "RydHQF_GarrRange") then {RydHQF_GarrRange = 1};
	_HQ setVariable ["RydHQ_GarrRange",RydHQF_GarrRange];
	
	if (isNil "RydHQF_NoCapt") then {RydHQF_NoCapt = []};
	_HQ setVariable ["RydHQ_NoCapt",RydHQF_NoCapt];
	
	if (isNil "RydHQF_AttInfDistance") then {RydHQF_AttInfDistance = 1};
	_HQ setVariable ["RydHQ_AttInfDistance",RydHQF_AttInfDistance];
	if (isNil "RydHQF_AttArmDistance") then {RydHQF_AttArmDistance = 1};
	_HQ setVariable ["RydHQ_AttArmDistance",RydHQF_AttArmDistance];
	if (isNil "RydHQF_AttSnpDistance") then {RydHQF_AttSnpDistance = 1};
	_HQ setVariable ["RydHQ_AttSnpDistance",RydHQF_AttSnpDistance];
	if (isNil "RydHQF_CaptureDistance") then {RydHQF_CaptureDistance = 1};
	_HQ setVariable ["RydHQ_CaptureDistance",RydHQF_CaptureDistance];	
	if (isNil "RydHQF_FlankDistance") then {RydHQF_FlankDistance = 1};
	_HQ setVariable ["RydHQ_FlankDistance",RydHQF_FlankDistance];
	if (isNil "RydHQF_AttSFDistance") then {RydHQF_AttSFDistance = 1};
	_HQ setVariable ["RydHQ_AttSFDistance",RydHQF_AttSFDistance];
	if (isNil "RydHQF_ReconDistance") then {RydHQF_ReconDistance = 1};
	_HQ setVariable ["RydHQ_ReconDistance",RydHQF_ReconDistance];
	if (isNil "RydHQF_UAVAlt") then {RydHQF_UAVAlt = 150};
	_HQ setVariable ["RydHQ_UAVAlt",RydHQF_UAVAlt];
		
	if (isNil "RydHQF_Obj1") then {RydHQF_Obj1 = createTrigger ["EmptyDetector", leaderHQF]};
	if (isNil "RydHQF_Obj2") then {RydHQF_Obj2 = createTrigger ["EmptyDetector", leaderHQF]};
	if (isNil "RydHQF_Obj3") then {RydHQF_Obj3 = createTrigger ["EmptyDetector", leaderHQF]};
	if (isNil "RydHQF_Obj4") then {RydHQF_Obj4 = createTrigger ["EmptyDetector", leaderHQF]};
		
	_HQ setVariable ["RydHQ_Obj1",RydHQF_Obj1];
	_HQ setVariable ["RydHQ_Obj2",RydHQF_Obj2];
	_HQ setVariable ["RydHQ_Obj3",RydHQF_Obj3];
	_HQ setVariable ["RydHQ_Obj4",RydHQF_Obj4];
	
	_objectives = [RydHQF_Obj1,RydHQF_Obj2,RydHQF_Obj3,RydHQF_Obj4];
	_NAVObjectives = [];

	if (isNil ("RydHQF_SimpleMode")) then {RydHQF_SimpleMode = true};
	_HQ setVariable ["RydHQ_SimpleMode",RydHQF_SimpleMode];

	if (isNil ("RydHQF_SecTasks")) then {RydHQF_SecTasks = false};
	_HQ setVariable ["RydHQ_SecTasks",RydHQF_SecTasks];
	
	if (isNil ("RydHQF_SimpleObjs")) then {RydHQF_SimpleObjs = []};
	_HQ setVariable ["RydHQ_SimpleObjs",RydHQF_SimpleObjs];

	if (isNil ("RydHQF_NavalObjs")) then {RydHQF_NavalObjs = []};
	_HQ setVariable ["RydHQ_NavalObjs",RydHQF_NavalObjs];

	if (isNil ("RydHQF_MaxSimpleObjs")) then {RydHQF_MaxSimpleObjs = 5};
	_HQ setVariable ["RydHQ_MaxSimpleObjs",RydHQF_MaxSimpleObjs];

	if (_HQ getVariable ["RydHQ_SimpleMode",false]) then {

		_objectives = RydHQF_SimpleObjs;
		_NAVObjectives = RydHQF_NavalObjs;
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
				
	if not (isNil "RydHQF_DefFrontL") then {_HQ setVariable ["RydHQ_DefFrontL",RydHQF_DefFrontL]};
	if not (isNil "RydHQF_DefFront1") then {_HQ setVariable ["RydHQ_DefFront1",RydHQF_DefFront1]};
	if not (isNil "RydHQF_DefFront2") then {_HQ setVariable ["RydHQ_DefFront2",RydHQF_DefFront2]};
	if not (isNil "RydHQF_DefFront3") then {_HQ setVariable ["RydHQ_DefFront3",RydHQF_DefFront3]};
	if not (isNil "RydHQF_DefFront4") then {_HQ setVariable ["RydHQ_DefFront4",RydHQF_DefFront4]};
	
	_civF = ["CIV_F","CIV","CIV_RU","BIS_TK_CIV","BIS_CIV_special"];
	if not (isNil ("RydHQF_CivF")) then {_civF = RydHQF_CivF};
	_HQ setVariable ["RydHQ_CivF",_civF];
	
	if (isNil ("RydHQF_Def")) then {RydHQF_Def = []};
	_HQ setVariable ["RydHQ_Def",RydHQF_Def];
	
	_nObj = _HQ getVariable ["RydHQ_NObj",1];

	switch (_nObj) do
		{
		case (1) : {_HQ setVariable ["RydHQ_Obj",RydHQF_Obj1]};
		case (2) : {_HQ setVariable ["RydHQ_Obj",RydHQF_Obj2]};
		case (3) : {_HQ setVariable ["RydHQ_Obj",RydHQF_Obj3]};
		default {_HQ setVariable ["RydHQ_Obj",RydHQF_Obj4]};
		};
		
	call RYD_StatusQuo;
	};