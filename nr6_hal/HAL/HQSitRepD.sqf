_SCRname = "SitRepD";
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

if (isNil ("RydHQD_MAtt")) then {RydHQD_MAtt = false};
_HQ setVariable ["RydHQ_MAtt",RydHQD_MAtt];
if ((isNil ("RydHQD_Personality")) or not (_HQ getVariable ["RydHQ_MAtt",false])) then {RydHQD_Personality = "OTHER"};
_HQ setVariable ["RydHQ_Personality",RydHQD_Personality];

if (isNil ("RydHQD_Recklessness")) then {RydHQD_Recklessness = 0.5};
_HQ setVariable ["RydHQ_Recklessness",RydHQD_Recklessness];
if (isNil ("RydHQD_Consistency")) then {RydHQD_Consistency = 0.5};
_HQ setVariable ["RydHQ_Consistency",RydHQD_Consistency];
if (isNil ("RydHQD_Activity")) then {RydHQD_Activity = 0.5};
_HQ setVariable ["RydHQ_Activity",RydHQD_Activity];
if (isNil ("RydHQD_Reflex")) then {RydHQD_Reflex = 0.5};
_HQ setVariable ["RydHQ_Reflex",RydHQD_Reflex];
if (isNil ("RydHQD_Circumspection")) then {RydHQD_Circumspection = 0.5};
_HQ setVariable ["RydHQ_Circumspection",RydHQD_Circumspection];
if (isNil ("RydHQD_Fineness")) then {RydHQD_Fineness = 0.5};
_HQ setVariable ["RydHQ_Fineness",RydHQD_Fineness];

[_HQ] call HAL_Personality;

[[_HQ],HAL_LHQ] call RYD_Spawn;

if (isNil ("RydHQD_Boxed")) then {RydHQD_Boxed = []};
_HQ setVariable ["RydHQ_Boxed",RydHQD_Boxed];

if (isNil ("RydHQD_AmmoBoxes")) then 
	{
	RydHQD_AmmoBoxes = [];

	if not (isNil "RydHQD_AmmoDepot") then 
		{
		_rds = (triggerArea RydHQD_AmmoDepot) select 0;
		RydHQD_AmmoBoxes = (getPosATL RydHQD_AmmoDepot) nearObjects ["ReammoBox_F",_rds]
		}
	};
	
_HQ setVariable ["RydHQ_AmmoBoxes",RydHQD_AmmoBoxes];

_HQ setVariable ["RydHQ_ReconDone",false];
_HQ setVariable ["RydHQ_DefDone",false];
_HQ setVariable ["RydHQ_ReconStage",1];
_HQ setVariable ["RydHQ_ReconStage2",1];
_HQ setVariable ["RydHQ_AirInDef",[]];

_KnEnPos = [];

if (isNil ("RydHQD_Excluded")) then {RydHQD_Excluded = []};
_HQ setVariable ["RydHQ_Excluded",RydHQD_Excluded];
if (isNil ("RydHQD_Fast")) then {RydHQD_Fast = false};
_HQ setVariable ["RydHQ_Fast",RydHQD_Fast];
if (isNil ("RydHQD_ExInfo")) then {RydHQD_ExInfo = false};
_HQ setVariable ["RydHQ_ExInfo",RydHQD_ExInfo];
if (isNil ("RydHQD_ObjHoldTime")) then {RydHQD_ObjHoldTime = 600};
_HQ setVariable ["RydHQ_ObjHoldTime",RydHQD_ObjHoldTime];
if (isNil "RydHQD_NObj") then {RydHQD_NObj = 1};
_HQ setVariable ["RydHQ_NObj",RydHQD_NObj];

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

if (isNil ("RydHQD_SupportWP")) then {RydHQD_SupportWP = false};
	
_HQ setVariable ["RydHQ_SupportWP",RydHQD_SupportWP];

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
	
	if (isNil "RydHQD_Garrison") then {RydHQD_Garrison = []};
	_HQ setVariable ["RydHQ_Garrison",RydHQD_Garrison];
	
	if (isNil ("RydHQD_NoAirCargo")) then {RydHQD_NoAirCargo = false};
	_HQ setVariable ["RydHQ_NoAirCargo",RydHQD_NoAirCargo];
	if (isNil ("RydHQD_NoLandCargo")) then {RydHQD_NoLandCargo = false};
	_HQ setVariable ["RydHQ_NoLandCargo",RydHQD_NoLandCargo];
	if (isNil ("RydHQD_LastFriends")) then {RydHQD_LastFriends = []};
	_HQ setVariable ["RydHQ_LastFriends",RydHQD_LastFriends];
	if (isNil ("RydHQD_CargoFind")) then {RydHQD_CargoFind = 1};
	_HQ setVariable ["RydHQ_CargoFind",RydHQD_CargoFind];
	if (isNil ("RydHQD_Subordinated")) then {RydHQD_Subordinated = []};
	_HQ setVariable ["RydHQ_Subordinated",RydHQD_Subordinated];
	if (isNil ("RydHQD_Included")) then {RydHQD_Included = []};
	_HQ setVariable ["RydHQ_Included",RydHQD_Included];
	if (isNil ("RydHQD_Excluded")) then {RydHQD_Excluded = []};
	_HQ setVariable ["RydHQ_Excluded",RydHQD_Excluded];
	if (isNil ("RydHQD_SubAll")) then {RydHQD_SubAll = true};
	_HQ setVariable ["RydHQ_SubAll",RydHQD_SubAll];
	if (isNil ("RydHQD_SubSynchro")) then {RydHQD_SubSynchro = false};
	_HQ setVariable ["RydHQ_SubSynchro",RydHQD_SubSynchro];
	if (isNil ("RydHQD_SubNamed")) then {RydHQD_SubNamed = false};
	_HQ setVariable ["RydHQ_SubNamed",RydHQD_SubNamed];
	if (isNil ("RydHQD_SubZero")) then {RydHQD_SubZero = false};
	_HQ setVariable ["RydHQ_SubZero",RydHQD_SubZero];
	if (isNil ("RydHQD_ReSynchro")) then {RydHQD_ReSynchro = true};
	_HQ setVariable ["RydHQ_ReSynchro",RydHQD_ReSynchro];
	if (isNil ("RydHQD_NameLimit")) then {RydHQD_NameLimit = 100};
	_HQ setVariable ["RydHQ_NameLimit",RydHQD_NameLimit];
	if (isNil ("RydHQD_Surr")) then {RydHQD_Surr = false};
	_HQ setVariable ["RydHQ_Surr",RydHQD_Surr];
	if (isNil ("RydHQD_NoRecon")) then {RydHQD_NoRecon = []};
	_HQ setVariable ["RydHQ_NoRecon",RydHQD_NoRecon];
	if (isNil ("RydHQD_NoAttack")) then {RydHQD_NoAttack = []};
	_HQ setVariable ["RydHQ_NoAttack",RydHQD_NoAttack];
	if (isNil ("RydHQD_CargoOnly")) then {RydHQD_CargoOnly = []};
	_HQ setVariable ["RydHQ_CargoOnly",RydHQD_CargoOnly];
	if (isNil ("RydHQD_NoCargo")) then {RydHQD_NoCargo = []};
	_HQ setVariable ["RydHQ_NoCargo",RydHQD_NoCargo];
	if (isNil ("RydHQD_NoFlank")) then {RydHQD_NoFlank = []};
	_HQ setVariable ["RydHQ_NoFlank",RydHQD_NoFlank];
	if (isNil ("RydHQD_NoDef")) then {RydHQD_NoDef = []};
	_HQ setVariable ["RydHQ_NoDef",RydHQD_NoDef];
	if (isNil ("RydHQD_FirstToFight")) then {RydHQD_FirstToFight = []};
	_HQ setVariable ["RydHQ_FirstToFight",RydHQD_FirstToFight];
	if (isNil ("RydHQD_VoiceComm")) then {RydHQD_VoiceComm = true};
	_HQ setVariable ["RydHQ_VoiceComm",RydHQD_VoiceComm];
	if (isNil ("RydHQD_FrontA")) then {RydHQD_Front = false};
	_HQ setVariable ["RydHQ_FrontA",RydHQD_Front];
	if (isNil ("RydHQD_LRelocating")) then {RydHQD_LRelocating = false};
	_HQ setVariable ["RydHQ_LRelocating",RydHQD_LRelocating];
	if (isNil ("RydHQD_Flee")) then {RydHQD_Flee = true};
	_HQ setVariable ["RydHQ_Flee",RydHQD_Flee];
	if (isNil ("RydHQD_GarrR")) then {RydHQD_GarrR = 500};
	_HQ setVariable ["RydHQ_GarrR",RydHQD_GarrR];
	if (isNil ("RydHQD_GarrLim")) then {RydHQD_GarrLim = 5};
	_HQ setVariable ["RydHQ_GarrLim",RydHQD_GarrLim];
	if (isNil ("RydHQD_Rush")) then {RydHQD_Rush = false};
	_HQ setVariable ["RydHQ_Rush",RydHQD_Rush];
	if (isNil ("RydHQD_GarrVehAb")) then {RydHQD_GarrVehAb = false};
	_HQ setVariable ["RydHQ_GarrVehAb",RydHQD_GarrVehAb];
	if (isNil ("RydHQD_DefendObjectives")) then {RydHQD_DefendObjectives = 4};
	_HQ setVariable ["RydHQ_DefendObjectives",RydHQD_DefendObjectives];
	if (isNil ("RydHQD_DefSpot")) then {RydHQD_DefSpot = []};
	_HQ setVariable ["RydHQ_DefSpot",RydHQD_DefSpot];
	if (isNil ("RydHQD_RecDefSpot")) then {RydHQD_RecDefSpot = []};
	_HQ setVariable ["RydHQ_RecDefSpot",RydHQD_RecDefSpot];
	if (isNil "RydHQD_Flare") then {RydHQD_Flare = true};
	_HQ setVariable ["RydHQ_Flare",RydHQD_Flare];
	if (isNil "RydHQD_Smoke") then {RydHQD_Smoke = true};
	_HQ setVariable ["RydHQ_Smoke",RydHQD_Smoke];
	if (isNil "RydHQD_NoRec") then {RydHQD_NoRec = 1};
	_HQ setVariable ["RydHQ_NoRec",RydHQD_NoRec];
	if (isNil "RydHQD_RapidCapt") then {RydHQD_RapidCapt = 10};
	_HQ setVariable ["RydHQ_RapidCapt",RydHQD_RapidCapt];
	if (isNil "RydHQD_Muu") then {RydHQD_Muu = 1};
	_HQ setVariable ["RydHQ_Muu",RydHQD_Muu];
	if (isNil "RydHQD_ArtyShells") then {RydHQD_ArtyShells = 1};
	_HQ setVariable ["RydHQ_ArtyShells",RydHQD_ArtyShells];
	if (isNil "RydHQD_Withdraw") then {RydHQD_Withdraw = 1};
	_HQ setVariable ["RydHQ_Withdraw",RydHQD_Withdraw];
	if (isNil "RydHQD_Berserk") then {RydHQD_Berserk = false};
	_HQ setVariable ["RydHQ_Berserk",RydHQD_Berserk];
	if (isNil "RydHQD_IDChance") then {RydHQD_IDChance = 100};
	_HQ setVariable ["RydHQ_IDChance",RydHQD_IDChance];
	if (isNil "RydHQD_RDChance") then {RydHQD_RDChance = 100};
	_HQ setVariable ["RydHQ_RDChance",RydHQD_RDChance];
	if (isNil "RydHQD_SDChance") then {RydHQD_SDChance = 100};
	_HQ setVariable ["RydHQ_SDChance",RydHQD_SDChance];
	if (isNil "RydHQD_AmmoDrop") then {RydHQD_AmmoDrop = []};
	_HQ setVariable ["RydHQ_AmmoDrop",RydHQD_AmmoDrop];
	if (isNil "RydHQD_SFTargets") then {RydHQD_SFTargets = []};
	_HQ setVariable ["RydHQ_SFTargets",RydHQD_SFTargets];
	if (isNil "RydHQD_LZ") then {RydHQD_LZ = false};
	_HQ setVariable ["RydHQ_LZ",RydHQD_LZ];
	if (isNil "RydHQD_SFBodyGuard") then {RydHQD_SFBodyGuard = []};
	_HQ setVariable ["RydHQ_SFBodyGuard",RydHQD_SFBodyGuard];
	if (isNil "RydHQD_DynForm") then {RydHQD_DynForm = false};
	_HQ setVariable ["RydHQ_DynForm",RydHQD_DynForm];
	if (isNil "RydHQD_UnlimitedCapt") then {RydHQD_UnlimitedCapt = false};
	_HQ setVariable ["RydHQ_UnlimitedCapt",RydHQD_UnlimitedCapt];
	if (isNil "RydHQD_CaptLimit") then {RydHQD_CaptLimit = 10};
	_HQ setVariable ["RydHQ_CaptLimit",RydHQD_CaptLimit];
	if (isNil "RydHQD_GetHQInside") then {RydHQD_GetHQInside = false};
	_HQ setVariable ["RydHQ_GetHQInside",RydHQD_GetHQInside];
	if (isNil "RydHQD_WA") then {RydHQD_WA = true};
	_HQ setVariable ["RydHQ_WA",RydHQD_WA];

	if (isNil "RydHQD_InfoMarkers") then {RydHQD_InfoMarkers = false};
	_HQ setVariable ["RydHQ_InfoMarkers",RydHQD_InfoMarkers];

	if (isNil "RydHQD_ArtyMarks") then {RydHQD_ArtyMarks = false};
	_HQ setVariable ["RydHQ_ArtyMarks",RydHQD_ArtyMarks];
		
	if (isNil ("RydHQD_ResetNow")) then {RydHQD_ResetNow = false};
	_HQ setVariable ["RydHQ_ResetNow",RydHQD_ResetNow];
	if (isNil ("RydHQD_ResetOnDemand")) then {RydHQD_ResetOnDemand = false};
	_HQ setVariable ["RydHQ_ResetOnDemand",RydHQD_ResetOnDemand];
	if (isNil ("RydHQD_ResetTime")) then {RydHQD_ResetTime = 600};
	_HQ setVariable ["RydHQ_ResetTime",RydHQD_ResetTime];
	if (isNil ("RydHQD_Combining")) then {RydHQD_Combining = false};
	_HQ setVariable ["RydHQ_Combining",RydHQD_Combining];
	if (isNil ("RydHQD_ObjRadius1")) then {RydHQD_ObjRadius1 = 300};
	_HQ setVariable ["RydHQ_ObjRadius1",RydHQD_ObjRadius1];
	if (isNil ("RydHQD_ObjRadius2")) then {RydHQD_ObjRadius2 = 500};
	_HQ setVariable ["RydHQ_ObjRadius2",RydHQD_ObjRadius2];
	if (isNil ("RydHQD_KnowTL")) then {RydHQD_KnowTL = true};
	_HQ setVariable ["RydHQ_KnowTL",RydHQD_KnowTL];
	
	if (isNil ("RydHQD_SMed")) then {RydHQD_SMed = true};
	_HQ setVariable ["RydHQ_SMed",RydHQD_SMed];
	if (isNil ("RydHQD_ExMedic")) then {RydHQD_ExMedic = []};
	_HQ setVariable ["RydHQ_ExMedic",RydHQD_ExMedic];
	if (isNil ("RydHQD_MedPoints")) then {RydHQD_MedPoints = []};
	_HQ setVariable ["RydHQ_MedPoints",RydHQD_MedPoints];
	if (isNil ("RydHQD_SupportedG")) then {RydHQD_SupportedG = []};
	_HQ setVariable ["RydHQ_SupportedG",RydHQD_SupportedG];
		
	if (isNil ("RydHQD_RCAS")) then {RydHQD_RCAS = []};
	_HQ setVariable ["RydHQ_RCAS",RydHQD_RCAS];
	if (isNil ("RydHQD_RCAP")) then {RydHQD_RCAP = []};
	_HQ setVariable ["RydHQ_RCAP",RydHQD_RCAP];
	
	if (isNil ("RydHQD_SFuel")) then {RydHQD_SFuel = true};
	_HQ setVariable ["RydHQ_SFuel",RydHQD_SFuel];
	if (isNil ("RydHQD_ExRefuel")) then {RydHQD_ExRefuel = []};
	_HQ setVariable ["RydHQ_ExRefuel",RydHQD_ExRefuel];
	if (isNil ("RydHQD_FuelPoints")) then {RydHQD_FuelPoints = []};
	_HQ setVariable ["RydHQ_FuelPoints",RydHQD_FuelPoints];
	if (isNil ("RydHQD_FSupportedG")) then {RydHQD_FSupportedG = []};
	_HQ setVariable ["RydHQ_FSupportedG",RydHQD_FSupportedG];
	
	if (isNil ("RydHQD_SAmmo")) then {RydHQD_SAmmo = true};
	_HQ setVariable ["RydHQ_SAmmo",RydHQD_SAmmo];
	if (isNil ("RydHQD_ExReammo")) then {RydHQD_ExReammo = []};
	_HQ setVariable ["RydHQ_ExReammo",RydHQD_ExReammo];
	if (isNil ("RydHQD_AmmoPoints")) then {RydHQD_AmmoPoints = []};
	_HQ setVariable ["RydHQ_AmmoPoints",RydHQD_AmmoPoints];
	if (isNil ("RydHQD_ASupportedG")) then {RydHQD_ASupportedG = []};
	_HQ setVariable ["RydHQ_ASupportedG",RydHQD_ASupportedG];
	
	if (isNil ("RydHQD_SRep")) then {RydHQD_SRep = true};
	_HQ setVariable ["RydHQ_SRep",RydHQD_SRep];
	if (isNil ("RydHQD_ExRepair")) then {RydHQD_ExRepair = []};
	_HQ setVariable ["RydHQ_ExRepair",RydHQD_ExRepair];
	if (isNil ("RydHQD_RepPoints")) then {RydHQD_RepPoints = []};
	_HQ setVariable ["RydHQ_RepPoints",RydHQD_RepPoints];
	if (isNil ("RydHQD_RSupportedG")) then {RydHQD_RSupportedG = []};
	_HQ setVariable ["RydHQ_RSupportedG",RydHQD_RSupportedG];
	
	if (isNil "RydHQD_AirDist") then {RydHQD_AirDist = 4000};
	_HQ setVariable ["RydHQ_AirDist",RydHQD_AirDist];
	
	if (isNil ("RydHQD_CommDelay")) then {RydHQD_CommDelay = 1};
	_HQ setVariable ["RydHQ_CommDelay",RydHQD_CommDelay];


	if ((isNil ("RydHQD_Order")) and (isNil {_HQ getVariable "RydHQ_Order"})) then {_HQ setVariable ["RydHQ_Order","ATTACK"]};
	if ( not (isNil ("RydHQD_Order"))) then {
		if (RydHQD_Order == "DEFEND") then {
			_HQ setVariable ["RydHQ_Order","DEFEND"]
		} else {
			_HQ setVariable ["RydHQ_Order","ATTACK"]
		};
	};

	if (isNil ("RydHQD_AttackAlways")) then {RydHQD_AttackAlways = false};
	_HQ setVariable ["RydHQ_AttackAlways",RydHQD_AttackAlways];

	if (isNil ("RydHQD_CRDefRes")) then {RydHQD_CRDefRes = 0};
	_HQ setVariable ["RydHQ_CRDefRes",RydHQD_CRDefRes];

	if (isNil ("RydHQD_ReconReserve")) then {RydHQD_ReconReserve = (0.3 * (0.5 + (_HQ getVariable ["RydHQ_Circumspection",0.5])))};
	_HQ setVariable ["RydHQ_ReconReserve",RydHQD_ReconReserve];
	if (isNil ("RydHQD_Exhausted")) then {RydHQD_Exhausted = []};
	_HQ setVariable ["RydHQ_Exhausted",RydHQD_Exhausted];
	if (isNil ("RydHQD_AttackReserve")) then {RydHQD_AttackReserve = (0.5 * (0.5 + ((_HQ getVariable ["RydHQ_Circumspection",0.5])/1.5)))};
	_HQ setVariable ["RydHQ_AttackReserve",RydHQD_AttackReserve];
	if (isNil ("RydHQD_IdleOrd")) then {RydHQD_IdleOrd = true};
	_HQ setVariable ["RydHQ_IdleOrd",RydHQD_IdleOrd];

	if (isNil ("RydHQD_IdleDef")) then {RydHQD_IdleDef = true};
	_HQ setVariable ["RydHQ_IdleDef",RydHQD_IdleDef];

	if (isNil "RydHQD_IdleDecoy") then {RydHQD_IdleDecoy = objNull};
	_HQ setVariable ["RydHQ_IdleDecoy",RydHQD_IdleDecoy]; 
	if (isNil "RydHQD_SupportDecoy") then {RydHQD_SupportDecoy = objNull};
	_HQ setVariable ["RydHQ_SupportDecoy",RydHQD_SupportDecoy]; 
	if (isNil "RydHQD_RestDecoy") then {RydHQD_RestDecoy = objNull};
	_HQ setVariable ["RydHQ_RestDecoy",RydHQD_RestDecoy]; 
	if (isNil "RydHQD_Sec1") then {RydHQD_Sec1 = objNull};
	_HQ setVariable ["RydHQ_Sec1",RydHQD_Sec1]; 
	if (isNil "RydHQD_Sec2") then {RydHQD_Sec2 = objNull};
	_HQ setVariable ["RydHQ_Sec2",RydHQD_Sec2];

	if (isNil "RydHQD_SupportRTB") then {RydHQD_SupportRTB = false};
	_HQ setVariable ["RydHQ_SupportRTB",RydHQD_SupportRTB];
	
	if (isNil "RydHQD_Debug") then {RydHQD_Debug = false};
	_HQ setVariable ["RydHQ_Debug",RydHQD_Debug]; 
	if (isNil "RydHQD_DebugII") then {RydHQD_DebugII = false};
	_HQ setVariable ["RydHQ_DebugII",RydHQD_DebugII];
	
	if (isNil "RydHQD_AlwaysKnownU") then {RydHQD_AlwaysKnownU = []};
	_HQ setVariable ["RydHQ_AlwaysKnownU",RydHQD_AlwaysKnownU]; 
	if (isNil "RydHQD_AlwaysUnKnownU") then {RydHQD_AlwaysUnKnownU = []};
	_HQ setVariable ["RydHQ_AlwaysUnKnownU",RydHQD_AlwaysUnKnownU]; 
	
	if (isNil "RydHQD_AOnly") then {RydHQD_AOnly = []};
	_HQ setVariable ["RydHQ_AOnly",RydHQD_AOnly]; 
	if (isNil "RydHQD_ROnly") then {RydHQD_ROnly = []};
	_HQ setVariable ["RydHQ_ROnly",RydHQD_ROnly];
	
	if (isNil "RydHQD_AirEvac") then {RydHQD_AirEvac = false};
	_HQ setVariable ["RydHQ_AirEvac",RydHQD_AirEvac];  
	
	if (isNil "RydHQD_AAO") then {RydHQD_AAO = false};
	_HQ setVariable ["RydHQ_AAO",RydHQD_AAO]; 
	if (isNil "RydHQD_ForceAAO") then {RydHQD_ForceAAO = false};
	_HQ setVariable ["RydHQ_ForceAAO",RydHQD_ForceAAO];


	if (isNil "RydHQD_BBAOObj") then {RydHQD_BBAOObj = 1};
	_HQ setVariable ["RydHQ_BBAOObj",RydHQD_BBAOObj]; 
	
	if (isNil ("RydHQD_MoraleConst")) then {RydHQD_MoraleConst = 1};
	_HQ setVariable ["RydHQ_MoraleConst",RydHQD_MoraleConst];
	
	if (isNil ("RydHQD_OffTend")) then {RydHQD_OffTend = 1};
	_HQ setVariable ["RydHQ_OffTend",RydHQD_OffTend];
	
	if (isNil "RydHQD_EBDoctrine") then {RydHQD_EBDoctrine = false};
	_HQ setVariable ["RydHQ_EBDoctrine",RydHQD_EBDoctrine]; 
	if (isNil "RydHQD_ForceEBDoctrine") then {RydHQD_ForceEBDoctrine = false};
	_HQ setVariable ["RydHQ_ForceEBDoctrine",RydHQD_ForceEBDoctrine]; 
	
	if (isNil "RydHQD_DefRange") then {RydHQD_DefRange = 1};
	_HQ setVariable ["RydHQ_DefRange",RydHQD_DefRange];
	if (isNil "RydHQD_GarrRange") then {RydHQD_GarrRange = 1};
	_HQ setVariable ["RydHQ_GarrRange",RydHQD_GarrRange];
	
	if (isNil "RydHQD_NoCapt") then {RydHQD_NoCapt = []};
	_HQ setVariable ["RydHQ_NoCapt",RydHQD_NoCapt];
	
	if (isNil "RydHQD_AttInfDistance") then {RydHQD_AttInfDistance = 1};
	_HQ setVariable ["RydHQ_AttInfDistance",RydHQD_AttInfDistance];
	if (isNil "RydHQD_AttArmDistance") then {RydHQD_AttArmDistance = 1};
	_HQ setVariable ["RydHQ_AttArmDistance",RydHQD_AttArmDistance];
	if (isNil "RydHQD_AttSnpDistance") then {RydHQD_AttSnpDistance = 1};
	_HQ setVariable ["RydHQ_AttSnpDistance",RydHQD_AttSnpDistance];
	if (isNil "RydHQD_CaptureDistance") then {RydHQD_CaptureDistance = 1};
	_HQ setVariable ["RydHQ_CaptureDistance",RydHQD_CaptureDistance];	
	if (isNil "RydHQD_FlankDistance") then {RydHQD_FlankDistance = 1};
	_HQ setVariable ["RydHQ_FlankDistance",RydHQD_FlankDistance];
	if (isNil "RydHQD_AttSFDistance") then {RydHQD_AttSFDistance = 1};
	_HQ setVariable ["RydHQ_AttSFDistance",RydHQD_AttSFDistance];
	if (isNil "RydHQD_ReconDistance") then {RydHQD_ReconDistance = 1};
	_HQ setVariable ["RydHQ_ReconDistance",RydHQD_ReconDistance];
	if (isNil "RydHQD_UAVAlt") then {RydHQD_UAVAlt = 150};
	_HQ setVariable ["RydHQ_UAVAlt",RydHQD_UAVAlt];

	if (isNil "RydHQD_Obj1") then {RydHQD_Obj1 = createTrigger ["EmptyDetector", leaderHQD]};
	if (isNil "RydHQD_Obj2") then {RydHQD_Obj2 = createTrigger ["EmptyDetector", leaderHQD]};
	if (isNil "RydHQD_Obj3") then {RydHQD_Obj3 = createTrigger ["EmptyDetector", leaderHQD]};
	if (isNil "RydHQD_Obj4") then {RydHQD_Obj4 = createTrigger ["EmptyDetector", leaderHQD]};
	
 	_HQ setVariable ["RydHQ_Obj1",RydHQD_Obj1];
	_HQ setVariable ["RydHQ_Obj2",RydHQD_Obj2];
	_HQ setVariable ["RydHQ_Obj3",RydHQD_Obj3];
	_HQ setVariable ["RydHQ_Obj4",RydHQD_Obj4];
	
	_objectives = [RydHQD_Obj1,RydHQD_Obj2,RydHQD_Obj3,RydHQD_Obj4];
	_NAVObjectives = [];

	if (isNil ("RydHQD_SimpleMode")) then {RydHQD_SimpleMode = true};
	_HQ setVariable ["RydHQ_SimpleMode",RydHQD_SimpleMode];

	if (isNil ("RydHQD_SecTasks")) then {RydHQD_SecTasks = false};
	_HQ setVariable ["RydHQ_SecTasks",RydHQD_SecTasks];
	
	if (isNil ("RydHQD_SimpleObjs")) then {RydHQD_SimpleObjs = []};
	_HQ setVariable ["RydHQ_SimpleObjs",RydHQD_SimpleObjs];

	if (isNil ("RydHQD_NavalObjs")) then {RydHQD_NavalObjs = []};
	_HQ setVariable ["RydHQ_NavalObjs",RydHQD_NavalObjs];

	if (isNil ("RydHQD_MaxSimpleObjs")) then {RydHQD_MaxSimpleObjs = 5};
	_HQ setVariable ["RydHQ_MaxSimpleObjs",RydHQD_MaxSimpleObjs];

	if (_HQ getVariable ["RydHQ_SimpleMode",false]) then {

		_objectives = RydHQD_SimpleObjs;
		_NAVObjectives = RydHQD_NavalObjs;
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
				
	if not (isNil "RydHQD_DefFrontL") then {_HQ setVariable ["RydHQ_DefFrontL",RydHQD_DefFrontL]};
	if not (isNil "RydHQD_DefFront1") then {_HQ setVariable ["RydHQ_DefFront1",RydHQD_DefFront1]};
	if not (isNil "RydHQD_DefFront2") then {_HQ setVariable ["RydHQ_DefFront2",RydHQD_DefFront2]};
	if not (isNil "RydHQD_DefFront3") then {_HQ setVariable ["RydHQ_DefFront3",RydHQD_DefFront3]};
	if not (isNil "RydHQD_DefFront4") then {_HQ setVariable ["RydHQ_DefFront4",RydHQD_DefFront4]};
	
	_civF = ["CIV_F","CIV","CIV_RU","BIS_TK_CIV","BIS_CIV_special"];
	if not (isNil ("RydHQD_CivF")) then {_civF = RydHQD_CivF};
	_HQ setVariable ["RydHQ_CivF",_civF];
	
	if (isNil ("RydHQD_Def")) then {RydHQD_Def = []};
	_HQ setVariable ["RydHQ_Def",RydHQD_Def];
	
	_nObj = _HQ getVariable ["RydHQ_NObj",1];

	switch (_nObj) do
		{
		case (1) : {_HQ setVariable ["RydHQ_Obj",RydHQD_Obj1]};
		case (2) : {_HQ setVariable ["RydHQ_Obj",RydHQD_Obj2]};
		case (3) : {_HQ setVariable ["RydHQ_Obj",RydHQD_Obj3]};
		default {_HQ setVariable ["RydHQ_Obj",RydHQD_Obj4]};
		};
		
	call RYD_StatusQuo;
	};