
zbe_deleteunitsnotleader = {
	{_x call zbe_deleteunitsnotleaderfnc;
	} forEach allGroups;
};

zbe_setPosFull = {
	{	
		if ( not (stopped _x) and not (_x getvariable ["NR6Site",false])) then { 

			_testpos = (formationPosition _x);
			if (!(isNil "_testpos") && (count _testpos > 0)) then {
			if (!(isPlayer _x) && (vehicle _x == _x)) then {
					_x setPos [_testpos select 0,_testpos select 1,0];
					_x allowDamage false;
					[_x]spawn {sleep 3;(_this select 0) allowDamage true;};
				};
			};
		};
	} forEach _toCache;
};

zbe_removeDead = {
	{if !(alive _x) then {
		_x enablesimulationglobal true;
		_x hideObjectGlobal false;
		[_x,false] remoteExecCall ["hideobject",0];
		[_x,true] remoteExecCall ["enableSimulation",0];
		if (zbe_debug) then {
			diag_log format ["ZBE_Cache %1 died while cached from group %2, uncaching and removing from cache loop",_x,_group];
		};
	_toCache = _toCache - [_x];
	};
	} forEach _toCache;
};

zbe_cacheEvent = {
	({_x distance _leader < _distance} count (allPlayers - (entities "HeadlessClient_F")) > 0) || !isNull (_leader findNearestEnemy _leader)
};

zbe_cacheEventHide = {
	({_x distance _leader < _distance} count (allPlayers - (entities "HeadlessClient_F")) > 0)
};

zbe_ObjcacheEvent = {
	({_x distance _obj < _distance} count (allPlayers - (entities "HeadlessClient_F")) > 0)
};

zbe_AliveCrewEvent = {
	({Alive _x} count (crew _vehicle) > 0)
};

zbe_vehicleCache = {

	_vehicle enablesimulationglobal false;
	_vehicle hideObjectGlobal false;
	[_vehicle,false] remoteExecCall ["hideobject",0];
	[_vehicle,false] remoteExecCall ["enableSimulation",0];
};

zbe_vehicleUncache = {

	_vehicle enablesimulationglobal true;
	_vehicle hideObjectGlobal false;
	[_vehicle,false] remoteExecCall ["hideobject",0];
	[_vehicle,true] remoteExecCall ["enableSimulation",0];
};

zbe_hideVeh = {

	if (zbe_NoHideMode) exitwith {};

	private ["_CGR"];
	


		{
			if (((vehicle _x) iskindof "Air") or (_x getvariable ["zbe_SeeAll",false])) then {

				[_vehicle,false] remoteExecCall ["hideobject",_x];
				[_vehicle,true] remoteExecCall ["enableSimulation",_x];


			} else {

				if (not ((_vehicle iskindof "Air") and (10 > (random 100))) and not ((owner _vehicle) isEqualTo (owner _x))) then {

					[_vehicle,true] remoteExecCall ["hideobject",_x];
					[_vehicle,false] remoteExecCall ["enableSimulation",_x];

				} else {

					[_vehicle,false] remoteExecCall ["hideobject",_x];
					[_vehicle,true] remoteExecCall ["enableSimulation",_x];

				};
			};
		} forEach (allPlayers - (entities "HeadlessClient_F"));
		

};



































zbe_objhide = {


	private ["_CGR"];

	{
		if not (isPlayer _x) then {

			_CGR = _x;

			{
				if (((vehicle _x) iskindof "Air") or (_x getvariable ["zbe_SeeAll",false])) then {

					if (((_x distance _CGR) > zbe_aiCacheDist) and not ((owner _CGR) isEqualTo (owner _x))) then {

						[_CGR,false] remoteExecCall ["hideobject",_x];
						[_CGR,false] remoteExecCall ["enableSimulation",_x];

					} else {

						[_CGR,false] remoteExecCall ["hideobject",_x];
						[_CGR,true] remoteExecCall ["enableSimulation",_x];

					};

				} else {

					if (((_x distance _CGR) > zbe_aiCacheDist) and not ((owner _CGR) isEqualTo (owner _x))) then {

						[_CGR,true] remoteExecCall ["hideobject",_x];
						[_CGR,false] remoteExecCall ["enableSimulation",_x];

					} else {

						[_CGR,false] remoteExecCall ["hideobject",_x];
						[_CGR,true] remoteExecCall ["enableSimulation",_x];

					};
				};
			} forEach (allPlayers - (entities "HeadlessClient_F"));
			
		};
	} forEach _objects;
};

zbe_objunCache = {

	{
		_x enablesimulationglobal true;
		_x hideObjectGlobal false;
		[_x,false] remoteExecCall ["hideobject",0];
		[_x,true] remoteExecCall ["enableSimulation",0];
		
	} forEach (allMissionObjects "Static");
};

zbe_objCache2 = {

	_obj enablesimulationglobal false;
//	_obj hideObjectGlobal true;

	{
//		[_obj,true] remoteExecCall ["hideobject",_x];
		[_obj,false] remoteExecCall ["enableSimulation",_x];
		
	} forEach allPlayers;

	{
//		[_obj,false] remoteExecCall ["hideobject",_x];
		[_obj,true] remoteExecCall ["enableSimulation",_x];
		
	} forEach (entities "HeadlessClient_F");

//	[_obj,false] remoteExecCall ["hideobject",2];
	[_obj,true] remoteExecCall ["enableSimulation",2];
};

zbe_objunCache2 = {

	
	_obj enablesimulationglobal true;
//	_obj hideObjectGlobal false;

//	[_obj,false] remoteExecCall ["hideobject",0];
	[_obj,true] remoteExecCall ["enableSimulation",0];

};