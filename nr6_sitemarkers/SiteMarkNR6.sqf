//[objective position(pos array),objective radius (number),friendly side (side),enemy side (side),name of location for notification (string),add name of location in marker too (boolean)] call fnc_NR6_SiteMarker;

if (isnil "NR6_SiteMarkNotif") then {NR6_SiteMarkNotif = true};

NR6_SiteFMarkB = {
	if (NR6_SiteMarkNotif) then { ['NR6_Objective_B',[(_this select 0) + ' Update', (_this select 0) + ' under control of ' + (_this select 1)]] remoteExecCall ["BIS_fnc_showNotification",0];};
};

NR6_SiteFMarkO = {
	if (NR6_SiteMarkNotif) then { ['NR6_Objective_O',[(_this select 0) + ' Update', (_this select 0) + ' under control of ' + (_this select 1)]] remoteExecCall ["BIS_fnc_showNotification",0];};
};

NR6_SiteFMarkI = {
	if (NR6_SiteMarkNotif) then { ['NR6_Objective_I',[(_this select 0) + ' Update', (_this select 0) + ' under control of ' + (_this select 1)]] remoteExecCall ["BIS_fnc_showNotification",0];};
};

NR6_SiteFMarkN = {
	if (NR6_SiteMarkNotif) then { ['NR6_Objective_N',[(_this select 0) + ' Update', (_this select 0) + ' control contested']] remoteExecCall ["BIS_fnc_showNotification",0];};
};

private ["_objPos","_objradius","_BluforType","_OpforType","_IndepType","_campName","_trg1","_mrk","_mrkName","_mrkSize","_westTroops","_eastTroops","_indepTroops","_ownership","_Objective","_Commanders","_Leader","_BluforHQs","_OpforHQs","_IndepHQs","_AllTaken","_nearObjs","_nL","_where","_firstChange"];

_logic = _this select 0;

_objPos = getpos _logic;
_objradius = _logic getVariable "_objradius";
_BluforType = _logic getVariable "_BluforType";
_OpforType = _logic getVariable "_OpforType";
_IndepType = _logic getVariable "_IndepType";
_campName = _logic getVariable ["_campName",""];
_mrkSize = _logic getVariable "_mrkSize";
_Objective = objNull;

_OpforHQs = [];
_BluforHQs = [];
_IndepHQs = [];
_Commanders = [];
_nearObjs = [];

_nearObjs = _objPos nearEntities ["NR6_HAL_Leader_SimpleObjective_Module", 300];
_nearObjs = [_nearObjs, [], {_objPos distance _x }, "ASCEND",{true}] call BIS_fnc_sortBy;

{
	if ((typeOf _x) == "NR6_HAL_Leader_SimpleObjective_Module") exitwith {
		_Objective = _x;
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
		_Commanders = (_BluforHQs + _OpforHQs + _IndepHQs);
	};
} foreach _nearObjs;

if (_campName isEqualTo "") then {
	_nL = nearestLocations [_objPos, ["Hill","NameCityCapital","NameCity","NameVillage","NameLocal","Strategic","StrongpointArea"], 500];
							
	if ((count _nL) > 0) then {
		_nL = _nL select 0;
		_where = (text _nL);
		_campName = _where;
	} else {_campName = mapGridPosition _objPos};
};

_mrk = createMarker [_campName,_objPos];
_mrk setMarkerShape "ICON";
_mrk setMarkerText _campName;
_mrk setMarkerType  "Empty";
_mrk setMarkerSize [_mrkSize,_mrkSize];


_ownership = "";
_firstChange = true;


if not (isNull _Objective) then {
	while {not (isNull _Objective)} do {

		sleep 5;

		_OpforTaken = [];
		_BluforTaken = [];
		_IndepTaken = [];
		
		{
			if (_x in _OpforHQs) then {
				_OpforTaken = _OpforTaken + ((group _x) getvariable ["RydHQ_Taken",[]]);
			};

			if (_x in _BluforHQs) then {
				_BluforTaken = _BluforTaken + ((group _x) getvariable ["RydHQ_Taken",[]]);
			};

			if (_x in _IndepHQs) then {
				_IndepTaken = _IndepTaken + ((group _x) getvariable ["RydHQ_Taken",[]]);
			};
			
		} foreach _Commanders;

		_AllTaken = (_IndepTaken + _OpforTaken + _BluforTaken);

		
		if ((_Objective in _BluforTaken) and not (_ownership == "BLUFOR")) then {
    
			If not (_firstChange) then {[_campName,_BluforType] call NR6_SiteFMarkB}; 
			_mrk setMarkerType  "b_installation";
			_mrk setMarkerColor "Default";
			_ownership = "BLUFOR";
			_firstChange = false;

		}; 
	
		if ((_Objective in _OpforTaken) and not (_ownership == "OPFOR")) then {
		
			If not (_firstChange) then {[_campName,_OpforType] call NR6_SiteFMarkO}; 
			_mrk setMarkerType  "o_installation";
			_mrk setMarkerColor "Default";
			_ownership = "OPFOR";
			_firstChange = false;
		}; 
	
		if ((_Objective in _IndepTaken) and not (_ownership == "INDEP")) then {
		
			If not (_firstChange) then {[_campName,_IndepType] call NR6_SiteFMarkI}; 
			_mrk setMarkerType  "n_installation";
			_mrk setMarkerColor "Default";
			_ownership = "INDEP";
			_firstChange = false;
		};

		if (not (_Objective in (_AllTaken)) and not (_ownership == "NONE")) then {
			
			If not (_firstChange) then {[_campName,_IndepType] call NR6_SiteFMarkN}; 
			_mrk setMarkerType  "n_installation";
			_mrk setMarkerColor "ColorGrey";
			_ownership = "NONE";
			_firstChange = false;
		}; 
	}; 
} else {

	_trg1 = createTrigger ["EmptyDetector", _objPos, true];
	_trg1 setTriggerArea [_objradius, _objradius, 0, false];
	_trg1 setTriggerActivation [ "ANY", "PRESENT", true];

	while {true} do {
	
		sleep 5; 
	
		_westTroops = west countSide (list _trg1); 
		_eastTroops = east countSide (list _trg1); 
		_indepTroops = resistance countSide (list _trg1); 
	
		if ((_eastTroops < _westTroops) and (_westTroops > _indepTroops) and not (_ownership == "BLUFOR")) then { 
		
			[_campName,_BluforType] call NR6_SiteFMarkB; 
			_mrk setMarkerType  "b_installation";
			_ownership = "BLUFOR";

		}; 
	
		if ((_westTroops < _eastTroops) and (_eastTroops > _indepTroops) and not (_ownership == "OPFOR")) then { 
		
			[_campName,_OpforType] call NR6_SiteFMarkO; 
			_mrk setMarkerType  "o_installation";
			_ownership = "OPFOR";
		}; 
	
		if ((_eastTroops < _indepTroops) and (_indepTroops > _westTroops) and not (_ownership == "INDEP")) then { 
		
			[_campName,_IndepType] call NR6_SiteFMarkI; 
			_mrk setMarkerType  "n_installation";
			_ownership = "INDEP";
		}; 
	}; 
};
 

