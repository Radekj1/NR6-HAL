//[position of site, radius of site,  number of groups, chance for patrol,,minimum building size, side, array of available groups for guard to spawn (can be a config path or array), controlled HAL leaders] call NR6_Sites;

//Ex: [(getPos this),100,4,0.2,1,west,[['rhsusf_army_ocp_teamleader', 'rhsusf_army_ocp_grenadier','rhsusf_army_ocp_autorifleman','rhsusf_army_ocp_rifleman'],['rhsusf_army_ocp_grenadier', 'rhsusf_army_ocp_rifleman']], [LeaderHQ,LeaderHQB]] call NR6_fnc_Sites; 

private 
    [
    "_grp","_Commanders","_SpawnPos","_SpawnRadius","_Pool","_GrpQuantity","_Leaders","_i","_Side","_SpawnRGroup","_PatrolPercent","_MinBuilding"
    ];
params ["_logic"];
//_logic = _this select 0;

_Commanders = [];

{
	if ((typeOf _x) == "NR6_HAL_Leader_Module") then {waitUntil {sleep 0.5; (not (isNil (_x getvariable "LeaderType")))}; _Commanders pushback (call compile (_x getvariable "LeaderType"))};
} foreach (synchronizedObjects _logic);

_SpawnPos = getpos _logic;
_Side = (_logic getVariable "_side");
_campside = (_logic getVariable "_campside");
_type = (_logic getVariable "_type");
_climate = (_logic getVariable "_climate");
_Campsize = (_logic getVariable "_Campsize");
_militarytype = (_logic getVariable "_militarytype");
_usecup = (_logic getVariable "_usecup");
_CampSpawnRadius = (_logic getVariable "_CampSpawnRadius");
_CampNumber = (_logic getVariable "_CampNumber");

_GrpQuantity = _logic getvariable "_GrpQuantity";
_PatrolPercent = _logic getvariable "_PatrolPercent";
_MinBuilding = _logic getvariable "_MinBuilding";
_Pool = call compile (_logic getvariable "_Pool");
_Leaders = _Commanders;


if (isNil ("LeaderHQ")) then {LeaderHQ = objNull};
if (isNil ("LeaderHQB")) then {LeaderHQB = objNull};
if (isNil ("LeaderHQC")) then {LeaderHQC = objNull};
if (isNil ("LeaderHQD")) then {LeaderHQD = objNull};
if (isNil ("LeaderHQE")) then {LeaderHQE = objNull};
if (isNil ("LeaderHQF")) then {LeaderHQF = objNull};
if (isNil ("LeaderHQG")) then {LeaderHQG = objNull};
if (isNil ("LeaderHQH")) then {LeaderHQH = objNull};

if (isNil ("RydHQ_Excluded")) then {RydHQ_Excluded = []};
if (isNil ("RydHQB_Excluded")) then {RydHQB_Excluded = []};
if (isNil ("RydHQC_Excluded")) then {RydHQC_Excluded = []};
if (isNil ("RydHQD_Excluded")) then {RydHQD_Excluded = []};
if (isNil ("RydHQE_Excluded")) then {RydHQE_Excluded = []};
if (isNil ("RydHQF_Excluded")) then {RydHQF_Excluded = []};
if (isNil ("RydHQG_Excluded")) then {RydHQG_Excluded = []};
if (isNil ("RydHQH_Excluded")) then {RydHQH_Excluded = []};

//pick

for "_x" from 1 to _GrpQuantity do
{
  [_SpawnPos,_SpawnRadius,_Side,_Pool,_SpawnRadius,_MinBuilding,_PatrolPercent,_Leaders] call SpawnRGroupS;
};