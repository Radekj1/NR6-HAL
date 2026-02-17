_SCRname = "SitRep";
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

if (isNil ("RydHQ_MAtt")) then {RydHQ_MAtt = false};
_HQ setVariable ["RydHQ_MAtt",RydHQ_MAtt];
if ((isNil ("RydHQ_Personality")) or not (_HQ getVariable ["RydHQ_MAtt",false])) then {RydHQ_Personality = "OTHER"};
_HQ setVariable ["RydHQ_Personality",RydHQ_Personality];

if (isNil ("RydHQ_Recklessness")) then {RydHQ_Recklessness = 0.5};
_HQ setVariable ["RydHQ_Recklessness",RydHQ_Recklessness];
if (isNil ("RydHQ_Consistency")) then {RydHQ_Consistency = 0.5};
_HQ setVariable ["RydHQ_Consistency",RydHQ_Consistency];
if (isNil ("RydHQ_Activity")) then {RydHQ_Activity = 0.5};
_HQ setVariable ["RydHQ_Activity",RydHQ_Activity];
if (isNil ("RydHQ_Reflex")) then {RydHQ_Reflex = 0.5};
_HQ setVariable ["RydHQ_Reflex",RydHQ_Reflex];
if (isNil ("RydHQ_Circumspection")) then {RydHQ_Circumspection = 0.5};
_HQ setVariable ["RydHQ_Circumspection",RydHQ_Circumspection];
if (isNil ("RydHQ_Fineness")) then {RydHQ_Fineness = 0.5};
_HQ setVariable ["RydHQ_Fineness",RydHQ_Fineness];

[_HQ] call HAL_Personality;

[_HQ] call HAL_LHQ;

if (isNil ("RydHQ_Boxed")) then {RydHQ_Boxed = []};
_HQ setVariable ["RydHQ_Boxed",RydHQ_Boxed];

if (isNil ("RydHQ_AmmoBoxes")) then 
	{
	RydHQ_AmmoBoxes = [];

	if not (isNil "RydHQ_AmmoDepot") then 
		{
		_rds = (triggerArea RydHQ_AmmoDepot) select 0;
		RydHQ_AmmoBoxes = (getPosATL RydHQ_AmmoDepot) nearObjects ["ReammoBox_F",_rds]
		}
	};
	
_HQ setVariable ["RydHQ_AmmoBoxes",RydHQ_AmmoBoxes];

_HQ setVariable ["RydHQ_ReconDone",false];
_HQ setVariable ["RydHQ_DefDone",false];
_HQ setVariable ["RydHQ_ReconStage",1];
_HQ setVariable ["RydHQ_ReconStage2",1];
_HQ setVariable ["RydHQ_AirInDef",[]];

_KnEnPos = [];

if (isNil ("RydHQ_Excluded")) then {RydHQ_Excluded = []};
_HQ setVariable ["RydHQ_Excluded",RydHQ_Excluded];
if (isNil ("RydHQ_Fast")) then {RydHQ_Fast = false};
_HQ setVariable ["RydHQ_Fast",RydHQ_Fast];
if (isNil ("RydHQ_ExInfo")) then {RydHQ_ExInfo = false};
_HQ setVariable ["RydHQ_ExInfo",RydHQ_ExInfo];
if (isNil ("RydHQ_ObjHoldTime")) then {RydHQ_ObjHoldTime = 600};
_HQ setVariable ["RydHQ_ObjHoldTime",RydHQ_ObjHoldTime];
if (isNil "RydHQ_NObj") then {RydHQ_NObj = 1};
_HQ setVariable ["RydHQ_NObj",RydHQ_NObj];

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

if (isNil ("RydHQ_SupportWP")) then {RydHQ_SupportWP = false};
	
_HQ setVariable ["RydHQ_SupportWP",RydHQ_SupportWP];

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
	
	if (isNil "RydHQ_Garrison") then {RydHQ_Garrison = []};
	_HQ setVariable ["RydHQ_Garrison",RydHQ_Garrison];
	
	if (isNil ("RydHQ_NoAirCargo")) then {RydHQ_NoAirCargo = false};
	_HQ setVariable ["RydHQ_NoAirCargo",RydHQ_NoAirCargo];
	if (isNil ("RydHQ_NoLandCargo")) then {RydHQ_NoLandCargo = false};
	_HQ setVariable ["RydHQ_NoLandCargo",RydHQ_NoLandCargo];
	if (isNil ("RydHQ_LastFriends")) then {RydHQ_LastFriends = []};
	_HQ setVariable ["RydHQ_LastFriends",RydHQ_LastFriends];
	if (isNil ("RydHQ_CargoFind")) then {RydHQ_CargoFind = 1};
	_HQ setVariable ["RydHQ_CargoFind",RydHQ_CargoFind];
	if (isNil ("RydHQ_Subordinated")) then {RydHQ_Subordinated = []};
	_HQ setVariable ["RydHQ_Subordinated",RydHQ_Subordinated];
	if (isNil ("RydHQ_Included")) then {RydHQ_Included = []};
	_HQ setVariable ["RydHQ_Included",RydHQ_Included];
	if (isNil ("RydHQ_Excluded")) then {RydHQ_Excluded = []};
	_HQ setVariable ["RydHQ_Excluded",RydHQ_Excluded];
	if (isNil ("RydHQ_SubAll")) then {RydHQ_SubAll = true};
	_HQ setVariable ["RydHQ_SubAll",RydHQ_SubAll];
	if (isNil ("RydHQ_SubSynchro")) then {RydHQ_SubSynchro = false};
	_HQ setVariable ["RydHQ_SubSynchro",RydHQ_SubSynchro];
	if (isNil ("RydHQ_SubNamed")) then {RydHQ_SubNamed = false};
	_HQ setVariable ["RydHQ_SubNamed",RydHQ_SubNamed];
	if (isNil ("RydHQ_SubZero")) then {RydHQ_SubZero = false};
	_HQ setVariable ["RydHQ_SubZero",RydHQ_SubZero];
	if (isNil ("RydHQ_ReSynchro")) then {RydHQ_ReSynchro = true};
	_HQ setVariable ["RydHQ_ReSynchro",RydHQ_ReSynchro];
	if (isNil ("RydHQ_NameLimit")) then {RydHQ_NameLimit = 100};
	_HQ setVariable ["RydHQ_NameLimit",RydHQ_NameLimit];
	if (isNil ("RydHQ_Surr")) then {RydHQ_Surr = false};
	_HQ setVariable ["RydHQ_Surr",RydHQ_Surr];
	if (isNil ("RydHQ_NoRecon")) then {RydHQ_NoRecon = []};
	_HQ setVariable ["RydHQ_NoRecon",RydHQ_NoRecon];
	if (isNil ("RydHQ_NoAttack")) then {RydHQ_NoAttack = []};
	_HQ setVariable ["RydHQ_NoAttack",RydHQ_NoAttack];
	if (isNil ("RydHQ_CargoOnly")) then {RydHQ_CargoOnly = []};
	_HQ setVariable ["RydHQ_CargoOnly",RydHQ_CargoOnly];
	if (isNil ("RydHQ_NoCargo")) then {RydHQ_NoCargo = []};
	_HQ setVariable ["RydHQ_NoCargo",RydHQ_NoCargo];
	if (isNil ("RydHQ_NoFlank")) then {RydHQ_NoFlank = []};
	_HQ setVariable ["RydHQ_NoFlank",RydHQ_NoFlank];
	if (isNil ("RydHQ_NoDef")) then {RydHQ_NoDef = []};
	_HQ setVariable ["RydHQ_NoDef",RydHQ_NoDef];
	if (isNil ("RydHQ_FirstToFight")) then {RydHQ_FirstToFight = []};
	_HQ setVariable ["RydHQ_FirstToFight",RydHQ_FirstToFight];
	if (isNil ("RydHQ_VoiceComm")) then {RydHQ_VoiceComm = true};
	_HQ setVariable ["RydHQ_VoiceComm",RydHQ_VoiceComm];
	if (isNil ("RydHQ_FrontA")) then {RydHQ_Front = false};
	_HQ setVariable ["RydHQ_FrontA",RydHQ_Front];
	if (isNil ("RydHQ_LRelocating")) then {RydHQ_LRelocating = false};
	_HQ setVariable ["RydHQ_LRelocating",RydHQ_LRelocating];
	if (isNil ("RydHQ_Flee")) then {RydHQ_Flee = true};
	_HQ setVariable ["RydHQ_Flee",RydHQ_Flee];
	if (isNil ("RydHQ_GarrR")) then {RydHQ_GarrR = 500};
	_HQ setVariable ["RydHQ_GarrR",RydHQ_GarrR];
	if (isNil ("RydHQ_GarrLim")) then {RydHQ_GarrLim = 5};
	_HQ setVariable ["RydHQ_GarrLim",RydHQ_GarrLim];
	if (isNil ("RydHQ_Rush")) then {RydHQ_Rush = false};
	_HQ setVariable ["RydHQ_Rush",RydHQ_Rush];
	if (isNil ("RydHQ_GarrVehAb")) then {RydHQ_GarrVehAb = false};
	_HQ setVariable ["RydHQ_GarrVehAb",RydHQ_GarrVehAb];
	if (isNil ("RydHQ_DefendObjectives")) then {RydHQ_DefendObjectives = 4};
	_HQ setVariable ["RydHQ_DefendObjectives",RydHQ_DefendObjectives];
	if (isNil ("RydHQ_DefSpot")) then {RydHQ_DefSpot = []};
	_HQ setVariable ["RydHQ_DefSpot",RydHQ_DefSpot];
	if (isNil ("RydHQ_RecDefSpot")) then {RydHQ_RecDefSpot = []};
	_HQ setVariable ["RydHQ_RecDefSpot",RydHQ_RecDefSpot];
	if (isNil "RydHQ_Flare") then {RydHQ_Flare = true};
	_HQ setVariable ["RydHQ_Flare",RydHQ_Flare];
	if (isNil "RydHQ_Smoke") then {RydHQ_Smoke = true};
	_HQ setVariable ["RydHQ_Smoke",RydHQ_Smoke];
	if (isNil "RydHQ_NoRec") then {RydHQ_NoRec = 1};
	_HQ setVariable ["RydHQ_NoRec",RydHQ_NoRec];
	if (isNil "RydHQ_RapidCapt") then {RydHQ_RapidCapt = 10};
	_HQ setVariable ["RydHQ_RapidCapt",RydHQ_RapidCapt];
	if (isNil "RydHQ_Muu") then {RydHQ_Muu = 1};
	_HQ setVariable ["RydHQ_Muu",RydHQ_Muu];
	if (isNil "RydHQ_ArtyShells") then {RydHQ_ArtyShells = 1};
	_HQ setVariable ["RydHQ_ArtyShells",RydHQ_ArtyShells];
	if (isNil "RydHQ_Withdraw") then {RydHQ_Withdraw = 1};
	_HQ setVariable ["RydHQ_Withdraw",RydHQ_Withdraw];
	if (isNil "RydHQ_Berserk") then {RydHQ_Berserk = false};
	_HQ setVariable ["RydHQ_Berserk",RydHQ_Berserk];
	if (isNil "RydHQ_IDChance") then {RydHQ_IDChance = 100};
	_HQ setVariable ["RydHQ_IDChance",RydHQ_IDChance];
	if (isNil "RydHQ_RDChance") then {RydHQ_RDChance = 100};
	_HQ setVariable ["RydHQ_RDChance",RydHQ_RDChance];
	if (isNil "RydHQ_SDChance") then {RydHQ_SDChance = 100};
	_HQ setVariable ["RydHQ_SDChance",RydHQ_SDChance];
	if (isNil "RydHQ_AmmoDrop") then {RydHQ_AmmoDrop = []};
	_HQ setVariable ["RydHQ_AmmoDrop",RydHQ_AmmoDrop];
	if (isNil "RydHQ_SFTargets") then {RydHQ_SFTargets = []};
	_HQ setVariable ["RydHQ_SFTargets",RydHQ_SFTargets];
	if (isNil "RydHQ_LZ") then {RydHQ_LZ = false};
	_HQ setVariable ["RydHQ_LZ",RydHQ_LZ];
	if (isNil "RydHQ_SFBodyGuard") then {RydHQ_SFBodyGuard = []};
	_HQ setVariable ["RydHQ_SFBodyGuard",RydHQ_SFBodyGuard];
	if (isNil "RydHQ_DynForm") then {RydHQ_DynForm = false};
	_HQ setVariable ["RydHQ_DynForm",RydHQ_DynForm];
	if (isNil "RydHQ_UnlimitedCapt") then {RydHQ_UnlimitedCapt = false};
	_HQ setVariable ["RydHQ_UnlimitedCapt",RydHQ_UnlimitedCapt];
	if (isNil "RydHQ_CaptLimit") then {RydHQ_CaptLimit = 10};
	_HQ setVariable ["RydHQ_CaptLimit",RydHQ_CaptLimit];
	if (isNil "RydHQ_GetHQInside") then {RydHQ_GetHQInside = false};
	_HQ setVariable ["RydHQ_GetHQInside",RydHQ_GetHQInside];
	if (isNil "RydHQ_WA") then {RydHQ_WA = true};
	_HQ setVariable ["RydHQ_WA",RydHQ_WA];

	if (isNil "RydHQ_InfoMarkers") then {RydHQ_InfoMarkers = false};
	_HQ setVariable ["RydHQ_InfoMarkers",RydHQ_InfoMarkers];

	if (isNil "RydHQ_ArtyMarks") then {RydHQ_ArtyMarks = false};
	_HQ setVariable ["RydHQ_ArtyMarks",RydHQ_ArtyMarks];
	
	if (isNil ("RydHQ_ResetNow")) then {RydHQ_ResetNow = false};
	_HQ setVariable ["RydHQ_ResetNow",RydHQ_ResetNow];
	if (isNil ("RydHQ_ResetOnDemand")) then {RydHQ_ResetOnDemand = false};
	_HQ setVariable ["RydHQ_ResetOnDemand",RydHQ_ResetOnDemand];
	if (isNil ("RydHQ_ResetTime")) then {RydHQ_ResetTime = 600};
	_HQ setVariable ["RydHQ_ResetTime",RydHQ_ResetTime];
	if (isNil ("RydHQ_Combining")) then {RydHQ_Combining = false};
	_HQ setVariable ["RydHQ_Combining",RydHQ_Combining];
	if (isNil ("RydHQ_ObjRadius1")) then {RydHQ_ObjRadius1 = 300};
	_HQ setVariable ["RydHQ_ObjRadius1",RydHQ_ObjRadius1];
	if (isNil ("RydHQ_ObjRadius2")) then {RydHQ_ObjRadius2 = 500};
	_HQ setVariable ["RydHQ_ObjRadius2",RydHQ_ObjRadius2];
	if (isNil ("RydHQ_KnowTL")) then {RydHQ_KnowTL = true};
	_HQ setVariable ["RydHQ_KnowTL",RydHQ_KnowTL];
	
	if (isNil ("RydHQ_SMed")) then {RydHQ_SMed = true};
	_HQ setVariable ["RydHQ_SMed",RydHQ_SMed];
	if (isNil ("RydHQ_ExMedic")) then {RydHQ_ExMedic = []};
	_HQ setVariable ["RydHQ_ExMedic",RydHQ_ExMedic];
	if (isNil ("RydHQ_MedPoints")) then {RydHQ_MedPoints = []};
	_HQ setVariable ["RydHQ_MedPoints",RydHQ_MedPoints];
	if (isNil ("RydHQ_SupportedG")) then {RydHQ_SupportedG = []};
	_HQ setVariable ["RydHQ_SupportedG",RydHQ_SupportedG];

	if (isNil ("RydHQ_RCAS")) then {RydHQ_RCAS = []};
	_HQ setVariable ["RydHQ_RCAS",RydHQ_RCAS];
	if (isNil ("RydHQ_RCAP")) then {RydHQ_RCAP = []};
	_HQ setVariable ["RydHQ_RCAP",RydHQ_RCAP];
	
	if (isNil ("RydHQ_SFuel")) then {RydHQ_SFuel = true};
	_HQ setVariable ["RydHQ_SFuel",RydHQ_SFuel];
	if (isNil ("RydHQ_ExRefuel")) then {RydHQ_ExRefuel = []};
	_HQ setVariable ["RydHQ_ExRefuel",RydHQ_ExRefuel];
	if (isNil ("RydHQ_FuelPoints")) then {RydHQ_FuelPoints = []};
	_HQ setVariable ["RydHQ_FuelPoints",RydHQ_FuelPoints];
	if (isNil ("RydHQ_FSupportedG")) then {RydHQ_FSupportedG = []};
	_HQ setVariable ["RydHQ_FSupportedG",RydHQ_FSupportedG];
	
	if (isNil ("RydHQ_SAmmo")) then {RydHQ_SAmmo = true};
	_HQ setVariable ["RydHQ_SAmmo",RydHQ_SAmmo];
	if (isNil ("RydHQ_ExReammo")) then {RydHQ_ExReammo = []};
	_HQ setVariable ["RydHQ_ExReammo",RydHQ_ExReammo];
	if (isNil ("RydHQ_AmmoPoints")) then {RydHQ_AmmoPoints = []};
	_HQ setVariable ["RydHQ_AmmoPoints",RydHQ_AmmoPoints];
	if (isNil ("RydHQ_ASupportedG")) then {RydHQ_ASupportedG = []};
	_HQ setVariable ["RydHQ_ASupportedG",RydHQ_ASupportedG];
	
	if (isNil ("RydHQ_SRep")) then {RydHQ_SRep = true};
	_HQ setVariable ["RydHQ_SRep",RydHQ_SRep];
	if (isNil ("RydHQ_ExRepair")) then {RydHQ_ExRepair = []};
	_HQ setVariable ["RydHQ_ExRepair",RydHQ_ExRepair];
	if (isNil ("RydHQ_RepPoints")) then {RydHQ_RepPoints = []};
	_HQ setVariable ["RydHQ_RepPoints",RydHQ_RepPoints];
	if (isNil ("RydHQ_RSupportedG")) then {RydHQ_RSupportedG = []};
	_HQ setVariable ["RydHQ_RSupportedG",RydHQ_RSupportedG];
	
	if (isNil "RydHQ_AirDist") then {RydHQ_AirDist = 4000};
	_HQ setVariable ["RydHQ_AirDist",RydHQ_AirDist];
	
	if (isNil ("RydHQ_CommDelay")) then {RydHQ_CommDelay = 1};
	_HQ setVariable ["RydHQ_CommDelay",RydHQ_CommDelay];


	if ((isNil ("RydHQ_Order")) and (isNil {_HQ getVariable "RydHQ_Order"})) then {_HQ setVariable ["RydHQ_Order","ATTACK"]};
	if ( not (isNil ("RydHQ_Order"))) then {
		if (RydHQ_Order == "DEFEND") then {
			_HQ setVariable ["RydHQ_Order","DEFEND"]
		} else {
			_HQ setVariable ["RydHQ_Order","ATTACK"]
		};
	};

	if (isNil ("RydHQ_AttackAlways")) then {RydHQ_AttackAlways = false};
	_HQ setVariable ["RydHQ_AttackAlways",RydHQ_AttackAlways];

	if (isNil ("RydHQ_CRDefRes")) then {RydHQ_CRDefRes = 0};
	_HQ setVariable ["RydHQ_CRDefRes",RydHQ_CRDefRes];

	if (isNil ("RydHQ_ReconReserve")) then {RydHQ_ReconReserve = (0.3 * (0.5 + (_HQ getVariable ["RydHQ_Circumspection",0.5])))};
	_HQ setVariable ["RydHQ_ReconReserve",RydHQ_ReconReserve];
	if (isNil ("RydHQ_Exhausted")) then {RydHQ_Exhausted = []};
	_HQ setVariable ["RydHQ_Exhausted",RydHQ_Exhausted];
	if (isNil ("RydHQ_AttackReserve")) then {RydHQ_AttackReserve = (0.5 * (0.5 + ((_HQ getVariable ["RydHQ_Circumspection",0.5])/1.5)))};
	_HQ setVariable ["RydHQ_AttackReserve",RydHQ_AttackReserve];
	if (isNil ("RydHQ_IdleOrd")) then {RydHQ_IdleOrd = true};
	_HQ setVariable ["RydHQ_IdleOrd",RydHQ_IdleOrd];

	if (isNil ("RydHQ_IdleDef")) then {RydHQ_IdleDef = true};
	_HQ setVariable ["RydHQ_IdleDef",RydHQ_IdleDef];

	if (isNil "RydHQ_IdleDecoy") then {RydHQ_IdleDecoy = objNull};
	_HQ setVariable ["RydHQ_IdleDecoy",RydHQ_IdleDecoy]; 
	if (isNil "RydHQ_SupportDecoy") then {RydHQ_SupportDecoy = objNull};
	_HQ setVariable ["RydHQ_SupportDecoy",RydHQ_SupportDecoy]; 
	if (isNil "RydHQ_RestDecoy") then {RydHQ_RestDecoy = objNull};
	_HQ setVariable ["RydHQ_RestDecoy",RydHQ_RestDecoy]; 
	if (isNil "RydHQ_Sec1") then {RydHQ_Sec1 = objNull};
	_HQ setVariable ["RydHQ_Sec1",RydHQ_Sec1]; 
	if (isNil "RydHQ_Sec2") then {RydHQ_Sec2 = objNull};
	_HQ setVariable ["RydHQ_Sec2",RydHQ_Sec2]; 

	if (isNil "RydHQ_SupportRTB") then {RydHQ_SupportRTB = false};
	_HQ setVariable ["RydHQ_SupportRTB",RydHQ_SupportRTB]; 
	
	if (isNil "RydHQ_Debug") then {RydHQ_Debug = false};
	_HQ setVariable ["RydHQ_Debug",RydHQ_Debug]; 
	if (isNil "RydHQ_DebugII") then {RydHQ_DebugII = false};
	_HQ setVariable ["RydHQ_DebugII",RydHQ_DebugII]; 
	
	if (isNil "RydHQ_AlwaysKnownU") then {RydHQ_AlwaysKnownU = []};
	_HQ setVariable ["RydHQ_AlwaysKnownU",RydHQ_AlwaysKnownU]; 
	if (isNil "RydHQ_AlwaysUnKnownU") then {RydHQ_AlwaysUnKnownU = []};
	_HQ setVariable ["RydHQ_AlwaysUnKnownU",RydHQ_AlwaysUnKnownU]; 
	
	if (isNil "RydHQ_AOnly") then {RydHQ_AOnly = []};
	_HQ setVariable ["RydHQ_AOnly",RydHQ_AOnly]; 
	if (isNil "RydHQ_ROnly") then {RydHQ_ROnly = []};
	_HQ setVariable ["RydHQ_ROnly",RydHQ_ROnly]; 
	
	if (isNil "RydHQ_AirEvac") then {RydHQ_AirEvac = false};
	_HQ setVariable ["RydHQ_AirEvac",RydHQ_AirEvac]; 
	
	if (isNil "RydHQ_AAO") then {RydHQ_AAO = false};
	_HQ setVariable ["RydHQ_AAO",RydHQ_AAO]; 
	if (isNil "RydHQ_ForceAAO") then {RydHQ_ForceAAO = false};
	_HQ setVariable ["RydHQ_ForceAAO",RydHQ_ForceAAO];
	

	if (isNil "RydHQ_BBAOObj") then {RydHQ_BBAOObj = 1};
	_HQ setVariable ["RydHQ_BBAOObj",RydHQ_BBAOObj]; 

	if (isNil ("RydHQ_MoraleConst")) then {RydHQ_MoraleConst = 1};
	_HQ setVariable ["RydHQ_MoraleConst",RydHQ_MoraleConst];
	
	if (isNil ("RydHQ_OffTend")) then {RydHQ_OffTend = 1};
	_HQ setVariable ["RydHQ_OffTend",RydHQ_OffTend];
	
	if (isNil "RydHQ_EBDoctrine") then {RydHQ_EBDoctrine = false};
	_HQ setVariable ["RydHQ_EBDoctrine",RydHQ_EBDoctrine]; 
	if (isNil "RydHQ_ForceEBDoctrine") then {RydHQ_ForceEBDoctrine = false};
	_HQ setVariable ["RydHQ_ForceEBDoctrine",RydHQ_ForceEBDoctrine]; 

	if (isNil "RydHQ_DefRange") then {RydHQ_DefRange = 1};
	_HQ setVariable ["RydHQ_DefRange",RydHQ_DefRange];
	if (isNil "RydHQ_GarrRange") then {RydHQ_GarrRange = 1};
	_HQ setVariable ["RydHQ_GarrRange",RydHQ_GarrRange];
	
	if (isNil "RydHQ_NoCapt") then {RydHQ_NoCapt = []};
	_HQ setVariable ["RydHQ_NoCapt",RydHQ_NoCapt];
	
	if (isNil "RydHQ_AttInfDistance") then {RydHQ_AttInfDistance = 1};
	_HQ setVariable ["RydHQ_AttInfDistance",RydHQ_AttInfDistance];
	if (isNil "RydHQ_AttArmDistance") then {RydHQ_AttArmDistance = 1};
	_HQ setVariable ["RydHQ_AttArmDistance",RydHQ_AttArmDistance];
	if (isNil "RydHQ_AttSnpDistance") then {RydHQ_AttSnpDistance = 1};
	_HQ setVariable ["RydHQ_AttSnpDistance",RydHQ_AttSnpDistance];
	if (isNil "RydHQ_CaptureDistance") then {RydHQ_CaptureDistance = 1};
	_HQ setVariable ["RydHQ_CaptureDistance",RydHQ_CaptureDistance];	
	if (isNil "RydHQ_FlankDistance") then {RydHQ_FlankDistance = 1};
	_HQ setVariable ["RydHQ_FlankDistance",RydHQ_FlankDistance];
	if (isNil "RydHQ_AttSFDistance") then {RydHQ_AttSFDistance = 1};
	_HQ setVariable ["RydHQ_AttSFDistance",RydHQ_AttSFDistance];
	if (isNil "RydHQ_ReconDistance") then {RydHQ_ReconDistance = 1};
	_HQ setVariable ["RydHQ_ReconDistance",RydHQ_ReconDistance];
	if (isNil "RydHQ_UAVAlt") then {RydHQ_UAVAlt = 150};
	_HQ setVariable ["RydHQ_UAVAlt",RydHQ_UAVAlt];

	if (isNil "RydHQ_Obj1") then {RydHQ_Obj1 = createTrigger ["EmptyDetector", leaderHQ]};
	if (isNil "RydHQ_Obj2") then {RydHQ_Obj2 = createTrigger ["EmptyDetector", leaderHQ]};
	if (isNil "RydHQ_Obj3") then {RydHQ_Obj3 = createTrigger ["EmptyDetector", leaderHQ]};
	if (isNil "RydHQ_Obj4") then {RydHQ_Obj4 = createTrigger ["EmptyDetector", leaderHQ]};

	_HQ setVariable ["RydHQ_Obj1",RydHQ_Obj1];
	_HQ setVariable ["RydHQ_Obj2",RydHQ_Obj2];
	_HQ setVariable ["RydHQ_Obj3",RydHQ_Obj3];
	_HQ setVariable ["RydHQ_Obj4",RydHQ_Obj4];
		
	_objectives = [RydHQ_Obj1,RydHQ_Obj2,RydHQ_Obj3,RydHQ_Obj4];
	_NAVObjectives = [];

	if (isNil ("RydHQ_SimpleMode")) then {RydHQ_SimpleMode = true};
	_HQ setVariable ["RydHQ_SimpleMode",RydHQ_SimpleMode];

	if (isNil ("RydHQ_SecTasks")) then {RydHQ_SecTasks = false};
	_HQ setVariable ["RydHQ_SecTasks",RydHQ_SecTasks];

	if (isNil ("RydHQ_SimpleObjs")) then {RydHQ_SimpleObjs = []};
	_HQ setVariable ["RydHQ_SimpleObjs",RydHQ_SimpleObjs];

	if (isNil ("RydHQ_NavalObjs")) then {RydHQ_NavalObjs = []};
	_HQ setVariable ["RydHQ_NavalObjs",RydHQ_NavalObjs];

	if (isNil ("RydHQ_MaxSimpleObjs")) then {RydHQ_MaxSimpleObjs = 5};
	_HQ setVariable ["RydHQ_MaxSimpleObjs",RydHQ_MaxSimpleObjs];

	if (_HQ getVariable ["RydHQ_SimpleMode",false]) then {

		_objectives = RydHQ_SimpleObjs;
		_NAVObjectives = RydHQ_NavalObjs;
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

	if not (isNil "RydHQ_DefFrontL") then {_HQ setVariable ["RydHQ_DefFrontL",RydHQ_DefFrontL]};
	if not (isNil "RydHQ_DefFront1") then {_HQ setVariable ["RydHQ_DefFront1",RydHQ_DefFront1]};
	if not (isNil "RydHQ_DefFront2") then {_HQ setVariable ["RydHQ_DefFront2",RydHQ_DefFront2]};
	if not (isNil "RydHQ_DefFront3") then {_HQ setVariable ["RydHQ_DefFront3",RydHQ_DefFront3]};
	if not (isNil "RydHQ_DefFront4") then {_HQ setVariable ["RydHQ_DefFront4",RydHQ_DefFront4]};
	
	_civF = ["CIV_F","CIV","CIV_RU","BIS_TK_CIV","BIS_CIV_special"];
	if not (isNil ("RydHQ_CivF")) then {_civF = RydHQ_CivF};
	_HQ setVariable ["RydHQ_CivF",_civF];
	
	if (isNil ("RydHQ_Def")) then {RydHQ_Def = []};
	_HQ setVariable ["RydHQ_Def",RydHQ_Def];
	
	_nObj = _HQ getVariable ["RydHQ_NObj",1];

	switch (_nObj) do
		{
		case (1) : {_HQ setVariable ["RydHQ_Obj",RydHQ_Obj1]};
		case (2) : {_HQ setVariable ["RydHQ_Obj",RydHQ_Obj2]};
		case (3) : {_HQ setVariable ["RydHQ_Obj",RydHQ_Obj3]};
		default {_HQ setVariable ["RydHQ_Obj",RydHQ_Obj4]};
		};
	
	call RYD_StatusQuo;

	};
