zbe_module					= _this select 0;

zbe_aiCacheDist				= zbe_module getVariable "zbe_aiCacheDist";
zbe_minFrameRate			= -1;
zbe_debug					= zbe_module getVariable "zbe_debug";
zbe_vehicleCacheDistCar		= zbe_module getVariable "zbe_vehicleCacheDistCar";
zbe_vehicleCacheDistAir		= zbe_module getVariable "zbe_vehicleCacheDistAir";
zbe_vehicleCacheDistBoat	= zbe_module getVariable "zbe_vehicleCacheDistBoat";

zbe_ObjCache				= zbe_module getVariable "zbe_ObjCache";
zbe_ObjCacheLite			= zbe_module getVariable "zbe_ObjCacheLite";
zbe_NoHideMode				= zbe_module getVariable "zbe_NoHideMode";

zbe_allGroups	   			= 0;
zbe_cachedGroups   			= [];
zbe_cachedEnt				= [];
zbe_cachedUnits	   			= 0;
zbe_allVehicles	   			= 0;
zbe_cachedVehicles 			= 0;
zbe_objectView	   			= 0;
zbe_players					= [];

sleep 5;

call compileFinal preprocessFileLineNumbers "\NR6_zbe_cache\zbe_functions.sqf";

if (zbe_minFrameRate == -1) then {if (isDedicated) then {zbe_minFrameRate = 1} else {zbe_minFrameRate = 1};};

/*
zbe_mapsize = [] call bis_fnc_mapSize;
zbe_mapside = zbe_mapsize / 2;
zbe_centerPOS = [zbe_mapside, zbe_mapside, 0];
*/

zbe_mapside = 10000000;
zbe_centerPOS = [0,0,0];

[] spawn  {
	while {true} do {
		sleep 15;
		zbe_players = (switchableUnits + playableUnits - (entities "HeadlessClient_F"));
		{
			private ["_disable"];
			_disable = _x getVariable ["zbe_cacheDisabled",false];
//			if (!(isNull objectParent (leader _x))) then {_disable = true};
//			if ((waypointType [_x,currentWaypoint _x]) == "GETIN") then {_disable = true};
			if (!(_disable) && !(_x in zbe_cachedGroups)) then {
					zbe_cachedGroups = zbe_cachedGroups + [_x];
				 [zbe_aiCacheDist, _x, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_aiCaching.fsm";
				};
			if ((_disable) && (_x in zbe_cachedGroups)) then {
					zbe_cachedGroups = zbe_cachedGroups - [_x];
				};
		} forEach allGroups;
	};
};
// Vehicle Caching Beta (for client FPS)
if (true) then {

	[] spawn {
	private ["_assetscar", "_assetsair", "_assetsboat"];
	zbe_cached_cars = [];
	zbe_cached_air = [];
	zbe_cached_boat = [];
	while {true} do 
		{
			_assetscar = zbe_centerPOS nearEntities ["LandVehicle", zbe_mapside];
			{
				if !(_x in zbe_cached_cars) then {
					zbe_cached_cars = zbe_cached_cars + [_x];
						[_x, zbe_vehicleCacheDistCar] execFSM "\NR6_zbe_cache\zbe_vehicleCaching.fsm";
				};
			} forEach _assetscar;
			_assetsair = zbe_centerPOS nearEntities ["Air", zbe_mapside];
			{
				if !(_x in zbe_cached_air) then {
					zbe_cached_air = zbe_cached_air + [_x];
						[_x, zbe_vehicleCacheDistAir] execFSM "\NR6_zbe_cache\zbe_vehicleCaching.fsm";
				};
			} forEach _assetsair;
			_assetsboat = zbe_centerPOS nearEntities ["Ship", zbe_mapside];
			{
				if !(_x in zbe_cached_boat) then {
					zbe_cached_boat = zbe_cached_boat + [_x];
						[_x, zbe_vehicleCacheDistBoat] execFSM "\NR6_zbe_cache\zbe_vehicleCaching.fsm";
				};
			} forEach _assetsboat;

			{
				if (!(_x in _assetscar)) then {
				zbe_cached_cars = zbe_cached_cars - [_x];
				};
			} forEach zbe_cached_cars;
			{
				if (!(_x in _assetsair)) then {
				zbe_cached_air = zbe_cached_air - [_x];
				};
			} forEach zbe_cached_air;
			{
				if (!(_x in _assetsboat)) then {
				zbe_cached_boat = zbe_cached_boat - [_x];
				};
			} forEach zbe_cached_boat;
			zbe_allVehicles = (_assetscar + _assetsair + _assetsboat);
			sleep 15;
		};
	};
};


[] spawn {
	if (zbe_debug) then {
			while {true} do {
				uiSleep 15;
				zbe_cachedUnits = (count allUnits - ({simulationEnabled _x} count allUnits));
				zbe_cachedVehicles = (count zbe_allVehicles - ({simulationEnabled _x} count zbe_allVehicles));
				zbe_allVehiclesCount = (count zbe_allVehicles);
				hintSilent parseText format ["
                <t color='#FFFFFF' size='1.5'>ZBE Caching</t><br/>
                <t color='#FFFFFF'>Debug data</t><br/><br/>
                <t color='#A1A4AD' align='left'>Game time in seconds:</t><t color='#FFFFFF' align='right'>%1</t><br/><br/>
                <t color='#A1A4AD' align='left'>Number of groups:</t><t color='#FFFFFF' align='right'>%2</t><br/>
                <t color='#A1A4AD' align='left'>All units:</t><t color='#FFFFFF' align='right'>%3</t><br/>
                <t color='#A1A4AD' align='left'>Cached units:</t><t color='#39a0ff' align='right'>%4</t><br/><br/>
                <t color='#A1A4AD' align='left'>All vehicles:</t><t color='#FFFFFF' align='right'>%5</t><br/>
                <t color='#A1A4AD' align='left'>Cached vehicles:</t><t color='#39a0ff' align='right'>%6</t><br/><br/>
                <t color='#A1A4AD' align='left'>FPS:</t><t color='#FFFFFF' align='right'>%7</t><br/><br/>
                <t color='#A1A4AD' align='left'>Obj draw distance:</t><t color='#FFFFFF' align='right'>%8</t><br/>
            ", (round time), count allGroups, count allUnits, zbe_cachedUnits, zbe_allVehiclesCount, zbe_cachedVehicles, (round diag_fps), zbe_objectView];
				zbe_log_stats = format ["Groups: %1 # All/Cached Units: %2/%3 # All/Cached Vehicles: %4/%5 # FPS: %6 # ObjectDrawDistance: %7", count allGroups, count allUnits, zbe_cachedUnits, zbe_allVehiclesCount, zbe_cachedVehicles, (round diag_fps), zbe_objectView];
				diag_log format ["%1 ZBE_Cache (%2) ---  %3", (round time), name player, zbe_log_stats];
			};
		};
};
// Experimental, disabled for now
// if (!isDedicated) then {execFSM "\NR6_zbe_cache\zbe_clientObjectDrawAuto.fsm";};

if (zbe_ObjCache) then {

	zbe_cachedEnt = (zbe_centerPOS nearObjects ["Static", 5000000]);
	zbe_cachedEnt1 = zbe_cachedEnt;
	
if ((count zbe_cachedEnt) > 30) then {

	zbe_cachedEnt1 = zbe_cachedEnt select [0, ((count zbe_cachedEnt)/30)];
	zbe_cachedEnt2 = zbe_cachedEnt select [((count zbe_cachedEnt)/30), (2*((count zbe_cachedEnt)/10))];
	zbe_cachedEnt3 = zbe_cachedEnt select [(2*((count zbe_cachedEnt)/30)), (3*((count zbe_cachedEnt)/30))];
	zbe_cachedEnt4 = zbe_cachedEnt select [(3*((count zbe_cachedEnt)/30)), (4*((count zbe_cachedEnt)/30))];
	zbe_cachedEnt5 = zbe_cachedEnt select [(4*((count zbe_cachedEnt)/30)), (5*((count zbe_cachedEnt)/30))];
	zbe_cachedEnt6 = zbe_cachedEnt select [(5*((count zbe_cachedEnt)/30)), (6*((count zbe_cachedEnt)/30))];
	zbe_cachedEnt7 = zbe_cachedEnt select [(6*((count zbe_cachedEnt)/30)), (7*((count zbe_cachedEnt)/30))];
	zbe_cachedEnt8 = zbe_cachedEnt select [(7*((count zbe_cachedEnt)/30)), (8*((count zbe_cachedEnt)/30))];
	zbe_cachedEnt9 = zbe_cachedEnt select [(8*((count zbe_cachedEnt)/30)), (9*((count zbe_cachedEnt)/30))];
	zbe_cachedEnt10 = zbe_cachedEnt select [(9*((count zbe_cachedEnt)/30)), (10*((count zbe_cachedEnt)/30))];
	zbe_cachedEnt11 = zbe_cachedEnt select [(10*((count zbe_cachedEnt)/30)), (11*((count zbe_cachedEnt)/30))];
	zbe_cachedEnt12 = zbe_cachedEnt select [(11*((count zbe_cachedEnt)/30)), (12*((count zbe_cachedEnt)/30))];
	zbe_cachedEnt13 = zbe_cachedEnt select [(12*((count zbe_cachedEnt)/30)), (13*((count zbe_cachedEnt)/30))];
	zbe_cachedEnt14 = zbe_cachedEnt select [(13*((count zbe_cachedEnt)/30)), (14*((count zbe_cachedEnt)/30))];
	zbe_cachedEnt15 = zbe_cachedEnt select [(14*((count zbe_cachedEnt)/30)), (15*((count zbe_cachedEnt)/30))];
	zbe_cachedEnt16 = zbe_cachedEnt select [(15*((count zbe_cachedEnt)/30)), (16*((count zbe_cachedEnt)/30))];
	zbe_cachedEnt17 = zbe_cachedEnt select [(16*((count zbe_cachedEnt)/30)), (17*((count zbe_cachedEnt)/30))];
	zbe_cachedEnt18 = zbe_cachedEnt select [(17*((count zbe_cachedEnt)/30)), (18*((count zbe_cachedEnt)/30))];
	zbe_cachedEnt19 = zbe_cachedEnt select [(18*((count zbe_cachedEnt)/30)), (19*((count zbe_cachedEnt)/30))];
	zbe_cachedEnt20 = zbe_cachedEnt select [(19*((count zbe_cachedEnt)/30)), (20*((count zbe_cachedEnt)/30))];
	zbe_cachedEnt21 = zbe_cachedEnt select [(20*((count zbe_cachedEnt)/30)), (21*((count zbe_cachedEnt)/30))];
	zbe_cachedEnt22 = zbe_cachedEnt select [(21*((count zbe_cachedEnt)/30)), (22*((count zbe_cachedEnt)/30))];
	zbe_cachedEnt23 = zbe_cachedEnt select [(22*((count zbe_cachedEnt)/30)), (23*((count zbe_cachedEnt)/30))];
	zbe_cachedEnt24 = zbe_cachedEnt select [(23*((count zbe_cachedEnt)/30)), (24*((count zbe_cachedEnt)/30))];
	zbe_cachedEnt25 = zbe_cachedEnt select [(24*((count zbe_cachedEnt)/30)), (25*((count zbe_cachedEnt)/30))];
	zbe_cachedEnt26 = zbe_cachedEnt select [(25*((count zbe_cachedEnt)/30)), (26*((count zbe_cachedEnt)/30))];
	zbe_cachedEnt27 = zbe_cachedEnt select [(26*((count zbe_cachedEnt)/30)), (27*((count zbe_cachedEnt)/30))];
	zbe_cachedEnt28 = zbe_cachedEnt select [(27*((count zbe_cachedEnt)/30)), (28*((count zbe_cachedEnt)/30))];
	zbe_cachedEnt29 = zbe_cachedEnt select [(28*((count zbe_cachedEnt)/30)), (29*((count zbe_cachedEnt)/30))];
	zbe_cachedEnt30 = zbe_cachedEnt select [(29*((count zbe_cachedEnt)/30)), (30*((count zbe_cachedEnt)/30))];

};


	[zbe_aiCacheDist,zbe_cachedEnt1, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_statCaching.fsm";
	sleep 2;

if ((count zbe_cachedEnt) > 30) then {

		[zbe_aiCacheDist,zbe_cachedEnt2, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_statCaching.fsm";
		sleep 2;
		[zbe_aiCacheDist,zbe_cachedEnt3, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_statCaching.fsm";
		sleep 2;
		[zbe_aiCacheDist,zbe_cachedEnt4, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_statCaching.fsm";
		sleep 2;
		[zbe_aiCacheDist,zbe_cachedEnt5, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_statCaching.fsm";
		sleep 2;
		[zbe_aiCacheDist,zbe_cachedEnt6, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_statCaching.fsm";
		sleep 2;
		[zbe_aiCacheDist,zbe_cachedEnt7, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_statCaching.fsm";
		sleep 2;
		[zbe_aiCacheDist,zbe_cachedEnt8, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_statCaching.fsm";
		sleep 2;
		[zbe_aiCacheDist,zbe_cachedEnt9, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_statCaching.fsm";
		sleep 2;
		[zbe_aiCacheDist,zbe_cachedEnt10, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_statCaching.fsm";
		sleep 2;
		[zbe_aiCacheDist,zbe_cachedEnt11, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_statCaching.fsm";
		sleep 2;
		[zbe_aiCacheDist,zbe_cachedEnt12, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_statCaching.fsm";
		sleep 2;
		[zbe_aiCacheDist,zbe_cachedEnt13, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_statCaching.fsm";
		sleep 2;
		[zbe_aiCacheDist,zbe_cachedEnt14, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_statCaching.fsm";
		sleep 2;
		[zbe_aiCacheDist,zbe_cachedEnt15, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_statCaching.fsm";
		sleep 2;
		[zbe_aiCacheDist,zbe_cachedEnt16, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_statCaching.fsm";
		sleep 2;
		[zbe_aiCacheDist,zbe_cachedEnt17, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_statCaching.fsm";
		sleep 2;
		[zbe_aiCacheDist,zbe_cachedEnt18, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_statCaching.fsm";
		sleep 2;
		[zbe_aiCacheDist,zbe_cachedEnt19, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_statCaching.fsm";
		sleep 2;
		[zbe_aiCacheDist,zbe_cachedEnt20, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_statCaching.fsm";
		sleep 2;
		[zbe_aiCacheDist,zbe_cachedEnt21, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_statCaching.fsm";
		sleep 2;
		[zbe_aiCacheDist,zbe_cachedEnt22, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_statCaching.fsm";
		sleep 2;
		[zbe_aiCacheDist,zbe_cachedEnt23, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_statCaching.fsm";
		sleep 2;
		[zbe_aiCacheDist,zbe_cachedEnt24, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_statCaching.fsm";
		sleep 2;
		[zbe_aiCacheDist,zbe_cachedEnt25, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_statCaching.fsm";
		sleep 2;
		[zbe_aiCacheDist,zbe_cachedEnt26, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_statCaching.fsm";
		sleep 2;
		[zbe_aiCacheDist,zbe_cachedEnt27, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_statCaching.fsm";
		sleep 2;
		[zbe_aiCacheDist,zbe_cachedEnt28, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_statCaching.fsm";
		sleep 2;
		[zbe_aiCacheDist,zbe_cachedEnt29, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_statCaching.fsm";
		sleep 2;
		[zbe_aiCacheDist,zbe_cachedEnt30, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_statCaching.fsm";

	}
};

if (zbe_ObjCacheLite) then {

//	zbe_cachedEnt = (allmissionObjects "Static");
//	zbe_cachedEnt = ((zbe_centerPOS nearObjects ["Static", 5000000]) + (nearestTerrainObjects [zbe_centerPOS, ["TREE","SMALL TREE","BUSH"], 5000000]));
	zbe_cachedEnt = (zbe_centerPOS nearObjects ["Static", 5000000]);


	{[750,_x, zbe_minFrameRate, zbe_debug] execFSM "\NR6_zbe_cache\zbe_statCaching2.fsm"} forEach zbe_cachedEnt;
};
