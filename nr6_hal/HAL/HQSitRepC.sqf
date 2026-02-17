_SCRname = "SitRepC";
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

if (isNil ("RydHQC_MAtt")) then {RydHQC_MAtt = false};
_HQ setVariable ["RydHQ_MAtt",RydHQC_MAtt];
if ((isNil ("RydHQC_Personality")) or not (_HQ getVariable ["RydHQ_MAtt",false])) then {RydHQC_Personality = "OTHER"};
_HQ setVariable ["RydHQ_Personality",RydHQC_Personality];

if (isNil ("RydHQC_Recklessness")) then {RydHQC_Recklessness = 0.5};
_HQ setVariable ["RydHQ_Recklessness",RydHQC_Recklessness];
if (isNil ("RydHQC_Consistency")) then {RydHQC_Consistency = 0.5};
_HQ setVariable ["RydHQ_Consistency",RydHQC_Consistency];
if (isNil ("RydHQC_Activity")) then {RydHQC_Activity = 0.5};
_HQ setVariable ["RydHQ_Activity",RydHQC_Activity];
if (isNil ("RydHQC_Reflex")) then {RydHQC_Reflex = 0.5};
_HQ setVariable ["RydHQ_Reflex",RydHQC_Reflex];
if (isNil ("RydHQC_Circumspection")) then {RydHQC_Circumspection = 0.5};
_HQ setVariable ["RydHQ_Circumspection",RydHQC_Circumspection];
if (isNil ("RydHQC_Fineness")) then {RydHQC_Fineness = 0.5};
_HQ setVariable ["RydHQ_Fineness",RydHQC_Fineness];

[_HQ] call HAL_Personality;

[_HQ] call HAL_LHQ;

if (isNil ("RydHQC_Boxed")) then {RydHQC_Boxed = []};
_HQ setVariable ["RydHQ_Boxed",RydHQC_Boxed];

if (isNil ("RydHQC_AmmoBoxes")) then 
	{
	RydHQC_AmmoBoxes = [];

	if not (isNil "RydHQC_AmmoDepot") then 
		{
		_rds = (triggerArea RydHQC_AmmoDepot) select 0;
		RydHQC_AmmoBoxes = (getPosATL RydHQC_AmmoDepot) nearObjects ["ReammoBox_F",_rds]
		}
	};
	
_HQ setVariable ["RydHQ_AmmoBoxes",RydHQC_AmmoBoxes];

_HQ setVariable ["RydHQ_ReconDone",false];
_HQ setVariable ["RydHQ_DefDone",false];
_HQ setVariable ["RydHQ_ReconStage",1];
_HQ setVariable ["RydHQ_ReconStage2",1];
_HQ setVariable ["RydHQ_AirInDef",[]];

_KnEnPos = [];

if (isNil ("RydHQC_Excluded")) then {RydHQC_Excluded = []};
_HQ setVariable ["RydHQ_Excluded",RydHQC_Excluded];
if (isNil ("RydHQC_Fast")) then {RydHQC_Fast = false};
_HQ setVariable ["RydHQ_Fast",RydHQC_Fast];
if (isNil ("RydHQC_ExInfo")) then {RydHQC_ExInfo = false};
_HQ setVariable ["RydHQ_ExInfo",RydHQC_ExInfo];
if (isNil ("RydHQC_ObjHoldTime")) then {RydHQC_ObjHoldTime = 600};
_HQ setVariable ["RydHQ_ObjHoldTime",RydHQC_ObjHoldTime];
if (isNil "RydHQC_NObj") then {RydHQC_NObj = 1};
_HQ setVariable ["RydHQ_NObj",RydHQC_NObj];

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

if (isNil ("RydHQC_SupportWP")) then {RydHQC_SupportWP = false};
	
_HQ setVariable ["RydHQ_SupportWP",RydHQC_SupportWP];

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
	
	if (isNil "RydHQC_Garrison") then {RydHQC_Garrison = []};
	_HQ setVariable ["RydHQ_Garrison",RydHQC_Garrison];
	
	if (isNil ("RydHQC_NoAirCargo")) then {RydHQC_NoAirCargo = false};
	_HQ setVariable ["RydHQ_NoAirCargo",RydHQC_NoAirCargo];
	if (isNil ("RydHQC_NoLandCargo")) then {RydHQC_NoLandCargo = false};
	_HQ setVariable ["RydHQ_NoLandCargo",RydHQC_NoLandCargo];
	if (isNil ("RydHQC_LastFriends")) then {RydHQC_LastFriends = []};
	_HQ setVariable ["RydHQ_LastFriends",RydHQC_LastFriends];
	if (isNil ("RydHQC_CargoFind")) then {RydHQC_CargoFind = 1};
	_HQ setVariable ["RydHQ_CargoFind",RydHQC_CargoFind];
	if (isNil ("RydHQC_Subordinated")) then {RydHQC_Subordinated = []};
	_HQ setVariable ["RydHQ_Subordinated",RydHQC_Subordinated];
	if (isNil ("RydHQC_Included")) then {RydHQC_Included = []};
	_HQ setVariable ["RydHQ_Included",RydHQC_Included];
	if (isNil ("RydHQC_Excluded")) then {RydHQC_Excluded = []};
	_HQ setVariable ["RydHQ_Excluded",RydHQC_Excluded];
	if (isNil ("RydHQC_SubAll")) then {RydHQC_SubAll = true};
	_HQ setVariable ["RydHQ_SubAll",RydHQC_SubAll];
	if (isNil ("RydHQC_SubSynchro")) then {RydHQC_SubSynchro = false};
	_HQ setVariable ["RydHQ_SubSynchro",RydHQC_SubSynchro];
	if (isNil ("RydHQC_SubNamed")) then {RydHQC_SubNamed = false};
	_HQ setVariable ["RydHQ_SubNamed",RydHQC_SubNamed];
	if (isNil ("RydHQC_SubZero")) then {RydHQC_SubZero = false};
	_HQ setVariable ["RydHQ_SubZero",RydHQC_SubZero];
	if (isNil ("RydHQC_ReSynchro")) then {RydHQC_ReSynchro = true};
	_HQ setVariable ["RydHQ_ReSynchro",RydHQC_ReSynchro];
	if (isNil ("RydHQC_NameLimit")) then {RydHQC_NameLimit = 100};
	_HQ setVariable ["RydHQ_NameLimit",RydHQC_NameLimit];
	if (isNil ("RydHQC_Surr")) then {RydHQC_Surr = false};
	_HQ setVariable ["RydHQ_Surr",RydHQC_Surr];
	if (isNil ("RydHQC_NoRecon")) then {RydHQC_NoRecon = []};
	_HQ setVariable ["RydHQ_NoRecon",RydHQC_NoRecon];
	if (isNil ("RydHQC_NoAttack")) then {RydHQC_NoAttack = []};
	_HQ setVariable ["RydHQ_NoAttack",RydHQC_NoAttack];
	if (isNil ("RydHQC_CargoOnly")) then {RydHQC_CargoOnly = []};
	_HQ setVariable ["RydHQ_CargoOnly",RydHQC_CargoOnly];
	if (isNil ("RydHQC_NoCargo")) then {RydHQC_NoCargo = []};
	_HQ setVariable ["RydHQ_NoCargo",RydHQC_NoCargo];
	if (isNil ("RydHQC_NoFlank")) then {RydHQC_NoFlank = []};
	_HQ setVariable ["RydHQ_NoFlank",RydHQC_NoFlank];
	if (isNil ("RydHQC_NoDef")) then {RydHQC_NoDef = []};
	_HQ setVariable ["RydHQ_NoDef",RydHQC_NoDef];
	if (isNil ("RydHQC_FirstToFight")) then {RydHQC_FirstToFight = []};
	_HQ setVariable ["RydHQ_FirstToFight",RydHQC_FirstToFight];
	if (isNil ("RydHQC_VoiceComm")) then {RydHQC_VoiceComm = true};
	_HQ setVariable ["RydHQ_VoiceComm",RydHQC_VoiceComm];
	if (isNil ("RydHQC_FrontA")) then {RydHQC_Front = false};
	_HQ setVariable ["RydHQ_FrontA",RydHQC_Front];
	if (isNil ("RydHQC_LRelocating")) then {RydHQC_LRelocating = false};
	_HQ setVariable ["RydHQ_LRelocating",RydHQC_LRelocating];
	if (isNil ("RydHQC_Flee")) then {RydHQC_Flee = true};
	_HQ setVariable ["RydHQ_Flee",RydHQC_Flee];
	if (isNil ("RydHQC_GarrR")) then {RydHQC_GarrR = 500};
	_HQ setVariable ["RydHQ_GarrR",RydHQC_GarrR];
	if (isNil ("RydHQC_GarrLim")) then {RydHQC_GarrLim = 5};
	_HQ setVariable ["RydHQ_GarrLim",RydHQC_GarrLim];
	if (isNil ("RydHQC_Rush")) then {RydHQC_Rush = false};
	_HQ setVariable ["RydHQ_Rush",RydHQC_Rush];
	if (isNil ("RydHQC_GarrVehAb")) then {RydHQC_GarrVehAb = false};
	_HQ setVariable ["RydHQ_GarrVehAb",RydHQC_GarrVehAb];
	if (isNil ("RydHQC_DefendObjectives")) then {RydHQC_DefendObjectives = 4};
	_HQ setVariable ["RydHQ_DefendObjectives",RydHQC_DefendObjectives];
	if (isNil ("RydHQC_DefSpot")) then {RydHQC_DefSpot = []};
	_HQ setVariable ["RydHQ_DefSpot",RydHQC_DefSpot];
	if (isNil ("RydHQC_RecDefSpot")) then {RydHQC_RecDefSpot = []};
	_HQ setVariable ["RydHQ_RecDefSpot",RydHQC_RecDefSpot];
	if (isNil "RydHQC_Flare") then {RydHQC_Flare = true};
	_HQ setVariable ["RydHQ_Flare",RydHQC_Flare];
	if (isNil "RydHQC_Smoke") then {RydHQC_Smoke = true};
	_HQ setVariable ["RydHQ_Smoke",RydHQC_Smoke];
	if (isNil "RydHQC_NoRec") then {RydHQC_NoRec = 1};
	_HQ setVariable ["RydHQ_NoRec",RydHQC_NoRec];
	if (isNil "RydHQC_RapidCapt") then {RydHQC_RapidCapt = 10};
	_HQ setVariable ["RydHQ_RapidCapt",RydHQC_RapidCapt];
	if (isNil "RydHQC_Muu") then {RydHQC_Muu = 1};
	_HQ setVariable ["RydHQ_Muu",RydHQC_Muu];
	if (isNil "RydHQC_ArtyShells") then {RydHQC_ArtyShells = 1};
	_HQ setVariable ["RydHQ_ArtyShells",RydHQC_ArtyShells];
	if (isNil "RydHQC_Withdraw") then {RydHQC_Withdraw = 1};
	_HQ setVariable ["RydHQ_Withdraw",RydHQC_Withdraw];
	if (isNil "RydHQC_Berserk") then {RydHQC_Berserk = false};
	_HQ setVariable ["RydHQ_Berserk",RydHQC_Berserk];
	if (isNil "RydHQC_IDChance") then {RydHQC_IDChance = 100};
	_HQ setVariable ["RydHQ_IDChance",RydHQC_IDChance];
	if (isNil "RydHQC_RDChance") then {RydHQC_RDChance = 100};
	_HQ setVariable ["RydHQ_RDChance",RydHQC_RDChance];
	if (isNil "RydHQC_SDChance") then {RydHQC_SDChance = 100};
	_HQ setVariable ["RydHQ_SDChance",RydHQC_SDChance];
	if (isNil "RydHQC_AmmoDrop") then {RydHQC_AmmoDrop = []};
	_HQ setVariable ["RydHQ_AmmoDrop",RydHQC_AmmoDrop];
	if (isNil "RydHQC_SFTargets") then {RydHQC_SFTargets = []};
	_HQ setVariable ["RydHQ_SFTargets",RydHQC_SFTargets];
	if (isNil "RydHQC_LZ") then {RydHQC_LZ = false};
	_HQ setVariable ["RydHQ_LZ",RydHQC_LZ];
	if (isNil "RydHQC_SFBodyGuard") then {RydHQC_SFBodyGuard = []};
	_HQ setVariable ["RydHQ_SFBodyGuard",RydHQC_SFBodyGuard];
	if (isNil "RydHQC_DynForm") then {RydHQC_DynForm = false};
	_HQ setVariable ["RydHQ_DynForm",RydHQC_DynForm];
	if (isNil "RydHQC_UnlimitedCapt") then {RydHQC_UnlimitedCapt = false};
	_HQ setVariable ["RydHQ_UnlimitedCapt",RydHQC_UnlimitedCapt];
	if (isNil "RydHQC_CaptLimit") then {RydHQC_CaptLimit = 10};
	_HQ setVariable ["RydHQ_CaptLimit",RydHQC_CaptLimit];
	if (isNil "RydHQC_GetHQInside") then {RydHQC_GetHQInside = false};
	_HQ setVariable ["RydHQ_GetHQInside",RydHQC_GetHQInside];
	if (isNil "RydHQC_WA") then {RydHQC_WA = true};
	_HQ setVariable ["RydHQ_WA",RydHQC_WA];

	if (isNil "RydHQC_InfoMarkers") then {RydHQC_InfoMarkers = false};
	_HQ setVariable ["RydHQ_InfoMarkers",RydHQC_InfoMarkers];

	if (isNil "RydHQC_ArtyMarks") then {RydHQC_ArtyMarks = false};
	_HQ setVariable ["RydHQ_ArtyMarks",RydHQC_ArtyMarks];
		
	if (isNil ("RydHQC_ResetNow")) then {RydHQC_ResetNow = false};
	_HQ setVariable ["RydHQ_ResetNow",RydHQC_ResetNow];
	if (isNil ("RydHQC_ResetOnDemand")) then {RydHQC_ResetOnDemand = false};
	_HQ setVariable ["RydHQ_ResetOnDemand",RydHQC_ResetOnDemand];
	if (isNil ("RydHQC_ResetTime")) then {RydHQC_ResetTime = 600};
	_HQ setVariable ["RydHQ_ResetTime",RydHQC_ResetTime];
	if (isNil ("RydHQC_Combining")) then {RydHQC_Combining = false};
	_HQ setVariable ["RydHQ_Combining",RydHQC_Combining];
	if (isNil ("RydHQC_ObjRadius1")) then {RydHQC_ObjRadius1 = 300};
	_HQ setVariable ["RydHQ_ObjRadius1",RydHQC_ObjRadius1];
	if (isNil ("RydHQC_ObjRadius2")) then {RydHQC_ObjRadius2 = 500};
	_HQ setVariable ["RydHQ_ObjRadius2",RydHQC_ObjRadius2];
	if (isNil ("RydHQC_KnowTL")) then {RydHQC_KnowTL = true};
	_HQ setVariable ["RydHQ_KnowTL",RydHQC_KnowTL];
	
	if (isNil ("RydHQC_SMed")) then {RydHQC_SMed = true};
	_HQ setVariable ["RydHQ_SMed",RydHQC_SMed];
	if (isNil ("RydHQC_ExMedic")) then {RydHQC_ExMedic = []};
	_HQ setVariable ["RydHQ_ExMedic",RydHQC_ExMedic];
	if (isNil ("RydHQC_MedPoints")) then {RydHQC_MedPoints = []};
	_HQ setVariable ["RydHQ_MedPoints",RydHQC_MedPoints];
	if (isNil ("RydHQC_SupportedG")) then {RydHQC_SupportedG = []};
	_HQ setVariable ["RydHQ_SupportedG",RydHQC_SupportedG];
	
	if (isNil ("RydHQC_RCAS")) then {RydHQC_RCAS = []};
	_HQ setVariable ["RydHQ_RCAS",RydHQC_RCAS];
	if (isNil ("RydHQC_RCAP")) then {RydHQC_RCAP = []};
	_HQ setVariable ["RydHQ_RCAP",RydHQC_RCAP];

	if (isNil ("RydHQC_SFuel")) then {RydHQC_SFuel = true};
	_HQ setVariable ["RydHQ_SFuel",RydHQC_SFuel];
	if (isNil ("RydHQC_ExRefuel")) then {RydHQC_ExRefuel = []};
	_HQ setVariable ["RydHQ_ExRefuel",RydHQC_ExRefuel];
	if (isNil ("RydHQC_FuelPoints")) then {RydHQC_FuelPoints = []};
	_HQ setVariable ["RydHQ_FuelPoints",RydHQC_FuelPoints];
	if (isNil ("RydHQC_FSupportedG")) then {RydHQC_FSupportedG = []};
	_HQ setVariable ["RydHQ_FSupportedG",RydHQC_FSupportedG];
	
	if (isNil ("RydHQC_SAmmo")) then {RydHQC_SAmmo = true};
	_HQ setVariable ["RydHQ_SAmmo",RydHQC_SAmmo];
	if (isNil ("RydHQC_ExReammo")) then {RydHQC_ExReammo = []};
	_HQ setVariable ["RydHQ_ExReammo",RydHQC_ExReammo];
	if (isNil ("RydHQC_AmmoPoints")) then {RydHQC_AmmoPoints = []};
	_HQ setVariable ["RydHQ_AmmoPoints",RydHQC_AmmoPoints];
	if (isNil ("RydHQC_ASupportedG")) then {RydHQC_ASupportedG = []};
	_HQ setVariable ["RydHQ_ASupportedG",RydHQC_ASupportedG];
	
	if (isNil ("RydHQC_SRep")) then {RydHQC_SRep = true};
	_HQ setVariable ["RydHQ_SRep",RydHQC_SRep];
	if (isNil ("RydHQC_ExRepair")) then {RydHQC_ExRepair = []};
	_HQ setVariable ["RydHQ_ExRepair",RydHQC_ExRepair];
	if (isNil ("RydHQC_RepPoints")) then {RydHQC_RepPoints = []};
	_HQ setVariable ["RydHQ_RepPoints",RydHQC_RepPoints];
	if (isNil ("RydHQC_RSupportedG")) then {RydHQC_RSupportedG = []};
	_HQ setVariable ["RydHQ_RSupportedG",RydHQC_RSupportedG];
	
	if (isNil "RydHQC_AirDist") then {RydHQC_AirDist = 4000};
	_HQ setVariable ["RydHQ_AirDist",RydHQC_AirDist];
	
	if (isNil ("RydHQC_CommDelay")) then {RydHQC_CommDelay = 1};
	_HQ setVariable ["RydHQ_CommDelay",RydHQC_CommDelay];


	if ((isNil ("RydHQC_Order")) and (isNil {_HQ getVariable "RydHQ_Order"})) then {_HQ setVariable ["RydHQ_Order","ATTACK"]};
	if ( not (isNil ("RydHQC_Order"))) then {
		if (RydHQC_Order == "DEFEND") then {
			_HQ setVariable ["RydHQ_Order","DEFEND"]
		} else {
			_HQ setVariable ["RydHQ_Order","ATTACK"]
		};
	};

	if (isNil ("RydHQC_AttackAlways")) then {RydHQC_AttackAlways = false};
	_HQ setVariable ["RydHQ_AttackAlways",RydHQC_AttackAlways];

	if (isNil ("RydHQC_CRDefRes")) then {RydHQC_CRDefRes = 0};
	_HQ setVariable ["RydHQ_CRDefRes",RydHQC_CRDefRes];

	if (isNil ("RydHQC_ReconReserve")) then {RydHQC_ReconReserve = (0.3 * (0.5 + (_HQ getVariable ["RydHQ_Circumspection",0.5])))};
	_HQ setVariable ["RydHQ_ReconReserve",RydHQC_ReconReserve];
	if (isNil ("RydHQC_Exhausted")) then {RydHQC_Exhausted = []};
	_HQ setVariable ["RydHQ_Exhausted",RydHQC_Exhausted];
	if (isNil ("RydHQC_AttackReserve")) then {RydHQC_AttackReserve = (0.5 * (0.5 + ((_HQ getVariable ["RydHQ_Circumspection",0.5])/1.5)))};
	_HQ setVariable ["RydHQ_AttackReserve",RydHQC_AttackReserve];
	if (isNil ("RydHQC_IdleOrd")) then {RydHQC_IdleOrd = true};
	_HQ setVariable ["RydHQ_IdleOrd",RydHQC_IdleOrd];
	
	if (isNil ("RydHQC_IdleDef")) then {RydHQC_IdleDef = true};
	_HQ setVariable ["RydHQ_IdleDef",RydHQC_IdleDef];

	if (isNil "RydHQC_IdleDecoy") then {RydHQC_IdleDecoy = objNull};
	_HQ setVariable ["RydHQ_IdleDecoy",RydHQC_IdleDecoy]; 
	if (isNil "RydHQC_SupportDecoy") then {RydHQC_SupportDecoy = objNull};
	_HQ setVariable ["RydHQ_SupportDecoy",RydHQC_SupportDecoy]; 
	if (isNil "RydHQC_RestDecoy") then {RydHQC_RestDecoy = objNull};
	_HQ setVariable ["RydHQ_RestDecoy",RydHQC_RestDecoy]; 
	if (isNil "RydHQC_Sec1") then {RydHQC_Sec1 = objNull};
	_HQ setVariable ["RydHQ_Sec1",RydHQC_Sec1]; 
	if (isNil "RydHQC_Sec2") then {RydHQC_Sec2 = objNull};
	_HQ setVariable ["RydHQ_Sec2",RydHQC_Sec2];

	if (isNil "RydHQC_SupportRTB") then {RydHQC_SupportRTB = false};
	_HQ setVariable ["RydHQ_SupportRTB",RydHQC_SupportRTB];
	
	if (isNil "RydHQC_Debug") then {RydHQC_Debug = false};
	_HQ setVariable ["RydHQ_Debug",RydHQC_Debug]; 
	if (isNil "RydHQC_DebugII") then {RydHQC_DebugII = false};
	_HQ setVariable ["RydHQ_DebugII",RydHQC_DebugII]; 
	
	if (isNil "RydHQC_AlwaysKnownU") then {RydHQC_AlwaysKnownU = []};
	_HQ setVariable ["RydHQ_AlwaysKnownU",RydHQC_AlwaysKnownU]; 
	if (isNil "RydHQC_AlwaysUnKnownU") then {RydHQC_AlwaysUnKnownU = []};
	_HQ setVariable ["RydHQ_AlwaysUnKnownU",RydHQC_AlwaysUnKnownU]; 
	
	if (isNil "RydHQC_AOnly") then {RydHQC_AOnly = []};
	_HQ setVariable ["RydHQ_AOnly",RydHQC_AOnly]; 
	if (isNil "RydHQC_ROnly") then {RydHQC_ROnly = []};
	_HQ setVariable ["RydHQ_ROnly",RydHQC_ROnly]; 
	
	if (isNil "RydHQC_AirEvac") then {RydHQC_AirEvac = false};
	_HQ setVariable ["RydHQ_AirEvac",RydHQC_AirEvac];
	
	if (isNil "RydHQC_AAO") then {RydHQC_AAO = false};
	_HQ setVariable ["RydHQ_AAO",RydHQC_AAO]; 
	if (isNil "RydHQC_ForceAAO") then {RydHQC_ForceAAO = false};
	_HQ setVariable ["RydHQ_ForceAAO",RydHQC_ForceAAO]; 
	
	if (isNil "RydHQC_BBAOObj") then {RydHQC_BBAOObj = 1};
	_HQ setVariable ["RydHQ_BBAOObj",RydHQC_BBAOObj]; 

	if (isNil ("RydHQC_MoraleConst")) then {RydHQC_MoraleConst = 1};
	_HQ setVariable ["RydHQ_MoraleConst",RydHQC_MoraleConst];
	
	if (isNil ("RydHQC_OffTend")) then {RydHQC_OffTend = 1};
	_HQ setVariable ["RydHQ_OffTend",RydHQC_OffTend];
	
	if (isNil "RydHQC_EBDoctrine") then {RydHQC_EBDoctrine = false};
	_HQ setVariable ["RydHQ_EBDoctrine",RydHQC_EBDoctrine]; 
	if (isNil "RydHQC_ForceEBDoctrine") then {RydHQC_ForceEBDoctrine = false};
	_HQ setVariable ["RydHQ_ForceEBDoctrine",RydHQC_ForceEBDoctrine]; 
	
	if (isNil "RydHQC_DefRange") then {RydHQC_DefRange = 1};
	_HQ setVariable ["RydHQ_DefRange",RydHQC_DefRange];
	if (isNil "RydHQC_GarrRange") then {RydHQC_GarrRange = 1};
	_HQ setVariable ["RydHQ_GarrRange",RydHQC_GarrRange];

	if (isNil "RydHQC_NoCapt") then {RydHQC_NoCapt = []};
	_HQ setVariable ["RydHQ_NoCapt",RydHQC_NoCapt];
	
	if (isNil "RydHQC_AttInfDistance") then {RydHQC_AttInfDistance = 1};
	_HQ setVariable ["RydHQ_AttInfDistance",RydHQC_AttInfDistance];
	if (isNil "RydHQC_AttArmDistance") then {RydHQC_AttArmDistance = 1};
	_HQ setVariable ["RydHQ_AttArmDistance",RydHQC_AttArmDistance];
	if (isNil "RydHQC_AttSnpDistance") then {RydHQC_AttSnpDistance = 1};
	_HQ setVariable ["RydHQ_AttSnpDistance",RydHQC_AttSnpDistance];
	if (isNil "RydHQC_CaptureDistance") then {RydHQC_CaptureDistance = 1};
	_HQ setVariable ["RydHQ_CaptureDistance",RydHQC_CaptureDistance];	
	if (isNil "RydHQC_FlankDistance") then {RydHQC_FlankDistance = 1};
	_HQ setVariable ["RydHQ_FlankDistance",RydHQC_FlankDistance];
	if (isNil "RydHQC_AttSFDistance") then {RydHQC_AttSFDistance = 1};
	_HQ setVariable ["RydHQ_AttSFDistance",RydHQC_AttSFDistance];
	if (isNil "RydHQC_ReconDistance") then {RydHQC_ReconDistance = 1};
	_HQ setVariable ["RydHQ_ReconDistance",RydHQC_ReconDistance];
	if (isNil "RydHQC_UAVAlt") then {RydHQC_UAVAlt = 150};
	_HQ setVariable ["RydHQ_UAVAlt",RydHQC_UAVAlt];

	if (isNil "RydHQC_Obj1") then {RydHQC_Obj1 = createTrigger ["EmptyDetector", leaderHQC]};
	if (isNil "RydHQC_Obj2") then {RydHQC_Obj2 = createTrigger ["EmptyDetector", leaderHQC]};
	if (isNil "RydHQC_Obj3") then {RydHQC_Obj3 = createTrigger ["EmptyDetector", leaderHQC]};
	if (isNil "RydHQC_Obj4") then {RydHQC_Obj4 = createTrigger ["EmptyDetector", leaderHQC]};
	
	_HQ setVariable ["RydHQ_Obj1",RydHQC_Obj1];
	_HQ setVariable ["RydHQ_Obj2",RydHQC_Obj2];
	_HQ setVariable ["RydHQ_Obj3",RydHQC_Obj3];
	_HQ setVariable ["RydHQ_Obj4",RydHQC_Obj4];
	
	_objectives = [RydHQC_Obj1,RydHQC_Obj2,RydHQC_Obj3,RydHQC_Obj4];
	_NAVObjectives = [];

	if (isNil ("RydHQC_SimpleMode")) then {RydHQC_SimpleMode = true};
	_HQ setVariable ["RydHQ_SimpleMode",RydHQC_SimpleMode];

	if (isNil ("RydHQC_SecTasks")) then {RydHQC_SecTasks = false};
	_HQ setVariable ["RydHQ_SecTasks",RydHQC_SecTasks];

	if (isNil ("RydHQC_SimpleObjs")) then {RydHQC_SimpleObjs = []};
	_HQ setVariable ["RydHQ_SimpleObjs",RydHQC_SimpleObjs];

	if (isNil ("RydHQC_NavalObjs")) then {RydHQC_NavalObjs = []};
	_HQ setVariable ["RydHQ_NavalObjs",RydHQC_NavalObjs];

	if (isNil ("RydHQC_MaxSimpleObjs")) then {RydHQC_MaxSimpleObjs = 5};
	_HQ setVariable ["RydHQ_MaxSimpleObjs",RydHQC_MaxSimpleObjs];

	if (_HQ getVariable ["RydHQ_SimpleMode",false]) then {

		_objectives = RydHQC_SimpleObjs;
		_NAVObjectives = RydHQC_NavalObjs;
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
		
	if not (isNil "RydHQC_DefFrontL") then {_HQ setVariable ["RydHQ_DefFrontL",RydHQC_DefFrontL]};
	if not (isNil "RydHQC_DefFront1") then {_HQ setVariable ["RydHQ_DefFront1",RydHQC_DefFront1]};
	if not (isNil "RydHQC_DefFront2") then {_HQ setVariable ["RydHQ_DefFront2",RydHQC_DefFront2]};
	if not (isNil "RydHQC_DefFront3") then {_HQ setVariable ["RydHQ_DefFront3",RydHQC_DefFront3]};
	if not (isNil "RydHQC_DefFront4") then {_HQ setVariable ["RydHQ_DefFront4",RydHQC_DefFront4]};
	
	_civF = ["CIV_F","CIV","CIV_RU","BIS_TK_CIV","BIS_CIV_special"];
	if not (isNil ("RydHQC_CivF")) then {_civF = RydHQC_CivF};
	_HQ setVariable ["RydHQ_CivF",_civF];
	
	if (isNil ("RydHQC_Def")) then {RydHQC_Def = []};
	_HQ setVariable ["RydHQ_Def",RydHQC_Def];
	
	_nObj = _HQ getVariable ["RydHQ_NObj",1];

	switch (_nObj) do
		{
		case (1) : {_HQ setVariable ["RydHQ_Obj",RydHQC_Obj1]};
		case (2) : {_HQ setVariable ["RydHQ_Obj",RydHQC_Obj2]};
		case (3) : {_HQ setVariable ["RydHQ_Obj",RydHQC_Obj3]};
		default {_HQ setVariable ["RydHQ_Obj",RydHQC_Obj4]};
		};
		
	call RYD_StatusQuo;

	};
