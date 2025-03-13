
zbe_deleteunitsnotleader = {
	{_x call zbe_deleteunitsnotleaderfnc;
	} forEach allGroups;
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
	({alive _x} count (crew _vehicle) > 0)
};

zbe_vehicleCache = {

	_vehicle enableSimulationGlobal false;
	_vehicle hideObjectGlobal false;
	[_vehicle,false] remoteExecCall ["hideobject",0];
	[_vehicle,false] remoteExecCall ["enableSimulation",0];
};

zbe_vehicleUncache = {

	_vehicle enableSimulationGlobal true;
	_vehicle hideObjectGlobal false;
	[_vehicle,false] remoteExecCall ["hideobject",0];
	[_vehicle,true] remoteExecCall ["enableSimulation",0];
};

zbe_objCache2 = {

	_obj enableSimulationGlobal false;
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


	_obj enableSimulationGlobal true;
//	_obj hideObjectGlobal false;

//	[_obj,false] remoteExecCall ["hideobject",0];
	[_obj,true] remoteExecCall ["enableSimulation",0];

};
