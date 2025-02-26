private ["_temp","_logicFnc","_twnlist","_locationParams","_create","_twnlistTemp","_i","_rarity","_faction","_classlist","_classlistVehicles","_scope","_side","_woman","_class","_vehicleclass","_parents","_actual","_condition","_fsm","_locked","_canrepeat","_initVariables","_init","_allActions","_action","_tempArrayx","_civilianActions","_source","_allActionsx","_allTopics","_endSentences","_tempArray","_element","_type","_topic","_path","_category","_screams","_scream","_categoryId","_oldScreams","_allScreams","_Remarks","_oldRemarks","_allRemarks","_civilianConversations","_civilianScreams","_civilianRemarks","_factionCiv","_logic","_debug","_initArray","_distlimit","_trafficDistance","_twnSize","_civilianCount","_actionCategories","_kbCategories","_townsFaction","_blacklist","_respectModifyCoef","_threatDecay","_unitrarity","_totobj","_allConversations","_twnrespect","_newloc","_neighbors"];
scriptName "\NR6_Alice2\data\scripts\main.sqf";

BIS_alice_mainscope = _this select 0;
/*
	File: main.sqf
	Author: Karel Moricky

	Description:
	Init script - Ambient Life In Civilian Environment 2

	Parameter(s):
	_this: Alice2 logic unit which triggered this script.
*/
//PORTED TO ARMA 3 BY NINJARIDER600, ALL ORIGINAL CREDITS GO TO THE AUTHOR MENTIONED ABOVE.

_temp = [] call compile preprocessFileLineNumbers '\NR6_Alice2\data\scripts\init-alice2.sqf';
_logic = _this select 0;
_logic setPos [1,1,1];

//--- Default values
_logic setVariable ["id",0,true];
_logic setVariable ["pause",true,true];
/*
createcenter west;
createcenter east;
createcenter resistance;
createcenter civilian;
*/
//--- File paths
BIS_Alice2_path = "\NR6_Alice2\data\";

//--- Is Garbage collector running?
//if (isnil "BIS_GC_trashItFunc") then {(group _logic) createUnit ["GarbageCollector", position player, [], 0, "NONE"]};

//--- Execute Functions
//if (isnil "bis_fnc_init") then {
//	_logicFnc = (group _logic) createunit ["FunctionsManager",position player,[],0,"none"];
//};
//waituntil {!isnil "BIS_fnc_init"};	//--- Wait for functions
//if (!isnil "bis_gita_0") then {waituntil {!isnil "bis_gita_init"}};	//--- If present, wait for GITA (town generator)

///////////////////////////////////////////////////////////////////////////////////
///// Custom params
///////////////////////////////////////////////////////////////////////////////////
//--- Debug
_debug = if (isNil {_logic getVariable "debug"}) then {false} else {_logic getVariable "debug"};
_logic setVariable ["debug",_debug];

//--- Civilian init
_initArray = if (isNil {_logic getVariable "initArray"}) then {[]} else {_logic getVariable "initArray";};
_logic setVariable ["initArray",_initArray];

//--- Spawn distance
_distlimit = if (isNil {_logic getVariable "spawnDistance"}) then {400} else {_logic getVariable "spawnDistance"};
_logic setVariable ["spawnDistance",_distLimit];

//--- Traffic distance
_trafficDistance = if (isNil {_logic getVariable "trafficDistance"}) then {500} else {_logic getVariable "trafficDistance"};
_logic setVariable ["trafficDistance",_trafficDistance];

//--- Town size
_twnSize = if (isNil {_logic getVariable "ALICE_townsize"}) then {_distLimit * 2/3} else {_logic getVariable "ALICE_townsize";};
_logic setVariable ["ALICE_townsize",_twnSize];

//--- Civilian count
_civilianCount = if (isNil {_logic getVariable "civilianCount"}) then {"round (4 * (sqrt %1))"} else {_logic getVariable "civilianCount";};
_logic setVariable ["civilianCount",_civilianCount];

//--- Civilian actions

//--- Civilian conversations

//--- Towns faction
_townsFaction = if (isNil {_logic getVariable "townsFaction"}) then {["CIV_F"]} else {call compile (_logic getVariable "townsFaction");};
_logic setVariable ["townsFaction",_townsFaction];

//--- Object blacklist
_blacklist = if (isNil {_logic getVariable "blacklist"}) then {[]} else {_logic getVariable "blacklist";};
_logic setVariable ["blacklist",_blacklist];

//--- Respect modify
_respectModifyCoef = if (isNil {_logic getVariable "respectModifyCoef"}) then {0.15} else {_logic getVariable "respectModifyCoef"};
_logic setVariable ["respectModifyCoef",_respectModifyCoef];

//--- ThreatDecay
_threatDecay = if (isNil {_logic getVariable "threatDecay"}) then {0.25} else {_logic getVariable "threatDecay"};
_logic setVariable ["threatDecay",_threatDecay];


//--- Town list
_twnlist = [];
 if ((isNil {_logic getVariable "townlist"}) or ((call compile (_logic getVariable "townlist")) isEqualTo [])) then {
//	_locationParams = if (_debug) then {[["CityCenter"],[],true]} else {[["CityCenter"]]};
	_create = nearestLocations [[0,0,0], ["CityCenter","NameCity","NameCityCapital","NameVillage"], 100000];

	_LogGrp = createGroup sideLogic;

	{
		_newLoc = _LogGrp createUnit ["LocationArea_F",position _x,[],0,"NONE"];
		_newLoc setVariable ["class",str _newloc];
		_newLoc setVariable ["name",str _newloc];
		_newLoc setVariable ["type","Area"];

		_twnlist pushBackUnique _newLoc;
	} forEach _create;

	{
		_newLoc = _x;
		_neighbors = [];
		
		{
			if ((_newLoc distance _x) < 2500) then {_neighbors pushBack _x};
		} forEach (_twnlist - [_newLoc]);


		_newLoc setVariable ["neighbors",_neighbors];

	} forEach _twnlist;

	_logic setVariable ["townlist",_twnlist];

} else {

	_create = _logic getVariable "townlist";

	_LogGrp = createGroup sideLogic;

	{
		_newLoc = _LogGrp createUnit ["LocationArea_F",position _x,[],0,"NONE"];
		_newLoc setVariable ["class",str _newloc];
		_newLoc setVariable ["name",str _newloc];
		_newLoc setVariable ["type","Area"];

		_twnlist pushBackUnique _newLoc;
	} forEach _create;

	{
		_newLoc = _x;
		_neighbors = [];
		
		{
			if ((_newLoc distance _x) < 2500) then {_neighbors pushBack _x};
		} forEach (_twnlist - [_newLoc]);


		_newLoc setVariable ["neighbors",_neighbors];

	} forEach _twnlist;

	_logic setVariable ["townlist",_twnlist];
};
_logic setVariable ["ALICE_alltowns",_twnlist];

///////////////////////////////////////////////////////////////////////////////////
///// Civilian & Vehicles Classes
///////////////////////////////////////////////////////////////////////////////////

_unitrarity = if (format ["%1",_logic getVariable "civilianRarity"] == "<null>") then {[]} else {_logic getVariable "civilianRarity";};
_logic setVariable ["civilianRarity",_unitrarity];

_classlistfilter = call compile (_logic getVariable "manClasses");
_classlistVehiclesfilter = call compile (_logic getVariable "vehClasses");

_classlist = [];
_classlistVehicles = [];
_totobj = count (configFile >> "cfgVehicles");
for [{_i = 0}, {_i < _totobj}, {_i = _i + 1}] do {
	_actual = (configFile >> "cfgVehicles") select _i;
	if (isClass _actual) then {
		_class = configName _actual;
		_vehicleclass = getText (configFile >> "cfgvehicles" >> _class >> "vehicleClass");
		_parents = [ _actual , true ] call BIS_fnc_returnParents;
		if (("Man" in _parents) or ("Car" in _parents)) then {
			_scope = getNumber (_actual >> "scope");
			_side = getNumber (_actual >> "side");
			_woman = getNumber (_actual >> "woman");

			//--- Civilians
			if ((_class isKindOf "civilian") && ((_classlistfilter isEqualTo []) || _class in _classlistfilter) && (_scope == 2) && ("Man" in _parents)) then {
				_rarity = if (_class in _unitrarity) then {
					_unitrarity select ((_unitrarity find _class)+1);
				} else {
					getNumber (_actual >> "rarityUrban");
				};
				_faction = getText (_actual >> "faction");
				_classlist = _classlist + [[_class,_rarity,_faction,_woman]];
			};

			//--- Civilian Cars
			if (("Car" in _parents) && ((_classlistVehiclesfilter isEqualTo []) || _class in _classlistVehiclesfilter) && _side == 3 && _scope == 2) then {
				_faction = getText (_actual >> "faction");
				_classlistVehicles = _classlistVehicles + [[_class,_faction]];
			};
		};
	};
};
_logic setVariable ["ALICE_classes",_classlist];
_logic setVariable ["ALICE_classesVehicles",_classlistVehicles];

///////////////////////////////////////////////////////////////////////////////////
///// Civilian Actions
///////////////////////////////////////////////////////////////////////////////////


_allActionsx = [];
_allActions = [
	"\NR6_Alice2\data\actions\safe_stay.fsm",
	"\NR6_Alice2\data\actions\safe_walk.fsm"
];

_logic setVariable ["ALICE_actionsx",_allActionsx];
_logic setVariable ["ALICE_actions",_allActions];
///////////////////////////////////////////////////////////////////////////////////
///// Civilian Conversations
///////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////////
///// Execute
///////////////////////////////////////////////////////////////////////////////////
_fsm = _logic execFSM (BIS_Alice2_path + "fsms\alice2.fsm");



///////////////////////////////////////////////////////////////////////////////////
///// Towns
///////////////////////////////////////////////////////////////////////////////////
//debuglog format ["Log: ALICE 2: Initializing ...",_twnlist];
_twnrespect = ["SET"] call BIS_fnc_respect;
{
	_factionCiv = [_x] call BIS_fnc_getFactions;
	_twnrespect set [_factionCiv,0.5];
} forEach _townsFaction;
/*
{
	_type = _x getvariable "type";
	_name = _x getvariable "name";
	_pos = position _x;
	if (isnil {_x getvariable "respect"}) then {_x setVariable ["respect",_twnrespect,true]};
	_x setVariable ["ALICE_active",false];
	_x setVariable ["ALICE_active_traffic",0];
	_x setvariable ["ALICE_threat",-1];
	_x setvariable ["ALICE_status","black"];
	_x setVariable ["ALICE_population",[]];
	_x setVariable ["ALICE_populationCount",-1];
	_fsm = [_x,_classlist] execfsm (BIS_Alice2_path + "fsms\alice2.fsm");
	_x setvariable ["ALICE_fsm",_fsm];
	//if (_x == bis_loc_acityc_khelm) then {diag_debugfsm _fsm};

	//sleep .1;
} foreach _twnlist;
_logic setvariable ["pause",false];
*/
debugLog format ["Log: ALICE 2: Initialized (%1 towns).",count _twnlist];
bis_alice2_init = true;
