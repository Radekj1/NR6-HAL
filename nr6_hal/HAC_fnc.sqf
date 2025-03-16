// RYD_AngTowards = {
// 	params ["_source", "_target", "random"];

// 	private _dX0 = (_target select 0) - (_source select 0);
// 	private _dY0 = (_target select 1) - (_source select 1);

// 	(_dX0 atan2 _dY0) + (random (_random * 2)) - _random;

// };

// RYD_PosTowards2D = {
// 	params ["_source", "_angle", "_distT"];

// 	private _dXb = _distT * (sin _angle);
// 	private _dYb = _distT * (cos _angle);

// 	private _px = (_source select 0) + _dXb;
// 	private _py = (_source select 1) + _dYb;

// 	private _pz = getTerrainHeightASL [_px,_py];

// 	[_px,_py,_pz]
// };

// RYD_RandomAround = {
// 	//based on Muzzleflash' function
// 	params ["_pos", "_a"];

// 	private _xPos = _pos select 0;
// 	private _yPos = _pos select 1;

// 	private _dir = random 360;

// 	private _mag = sqrt ((random _a) * _a);
// 	private _nX = _mag * (sin _dir);
// 	private _nY = _mag * (cos _dir);

// 	[_xPos + _nX, _yPos + _nY, 0]
// };

RYD_RandomAroundB =
	{//[[_posX,_posY],100] call RYD_RandomAround
	private ["_pos","_X","_Y","_radius","_radiusMax","_angle"];

	_pos = _this select 0;
	_radiusMax = _this select 1;

	_angle = random 360;
	_radius = random _radiusMax;

	_X = _radius * sin _angle;
	_Y = _radius * cos _angle;

	_pos = [(_pos select 0) + _X,(_pos select 1) + _Y,0];

	_pos
	};

RYD_RandomAroundMM =
	{//based on Muzzleflash' function
	private ["_pos","_xPos","_yPos","_a","_b","_dir","_angle","_mag","_nX","_nY","_temp"];

	_pos = _this select 0;
	_a = _this select 1;
	_b = _this select 2;

	_b = _b - _a;

	_xPos = _pos select 0;
	_yPos = _pos select 1;

	_dir = random 360;

	_mag = _a + (sqrt ((random _b) * _b));
	_nX = _mag * (sin _dir);
	_nY = _mag * (cos _dir);

	_pos = [_xPos + _nX, _yPos + _nY,0];

	_pos
	};

RYD_PointToSecDst =
	{
	private ["_p1","_p2","_pc","_d","_d0","_d1","_d2","_x1","_y1","_x2","_y2","_xc","_yc","_a","_b"];

	_p1 = _this select 0;//ATL
	_p2 = _this select 1;//ATL
	_pc = _this select 2;//ATL

	_d0 = _p1 distance _p2;
	_d1 = _pc distance _p1;
	_d2 = _pc distance _p2;

	_d = _d1;

	switch (true) do
		{
		case (((_d0 * _d0) + (_d1 * _d1)) <= (_d2 * _d2)) : {_d = _d1};
		case (((_d0 * _d0) + (_d2 * _d2)) <= (_d1 * _d1)) : {_d = _d2};
		default
			{
			_x1 = _p1 select 0;
			_y1 = _p1 select 1;

			_x2 = _p2 select 0;
			_y2 = _p2 select 1;

			_xc = _pc select 0;
			_yc = _pc select 1;

			_a = (_y2 - _y1)/(_x2 - _x1);
			_b = _y1 - _x1 * _a;

			_d = abs (((_a/_b) * _xc) + ((-1/_b) * _yc) + 1)/(sqrt (((_a/_b) * (_a/_b)) + (1/(_b * _b))));
			}
		};

	_d
	};
// RYD_GarrP = {
// 	params ["_group", "_points", "_HQ"];
// 	_SCRname = "GarrP";

// 	private ["_wp","_sum","_sumAct","_added","_code"];


// 	{
// 		private _nHouse = _x nearestObject "House";
// 		private _posAll = [];
// 		private _i = 0;
// 		private _posAct = _nHouse buildingPos _i;

// 		while {((_posAct distance [0,0,0]) > 0)} do {
// 			_posAll pushBack _posAct;

// 			_i = _i + 1;
// 			_posAct = _nHouse buildingPos _i;
// 		};

// 		private _formation = "DIAMOND";
// 		if (isPlayer (leader _group)) then {_formation = formation _group;} else {_formation = "DIAMOND";};

// 		_wp = [[_group],_x,"MOVE","AWARE","YELLOW","LIMITED",["true",""],false,0.01,[10,15,20],_formation] call RYD_WPadd;

// 		if ((count _posAll) > 0) then {
// 			_wp waypointAttachVehicle _nHouse;
// 			sleep 0.05;
// 			_wp setWaypointHousePosition (floor (random (count _posAll)))
// 		};
// 	} forEach _points;

// 	_wp = [[_group], _points select 0, "CYCLE", "AWARE", "YELLOW", "LIMITED", ["true",""], false, 0.01, [10,15,20], _formation] call RYD_WPadd;

// 	private _code = {
// 		params ["_gruop", "_HQ"];

// 		private _UL = leader _group;
// 		private _nE = "";
// 		private _dst = 0;

// 		_alive = true;

// 		waitUntil
// 			{
// 			sleep 20;
// 			_dst = 10000;

// 			_alive = true;
// 			switch (true) do
// 				{
// 				case (isNull _group) : {_alive = false};
// 				case (({alive _x} count (units _group)) < 1) : {_alive = false};
// 				case (_HQ getVariable ["RydHQ_KIA",false]) : {_alive = false};
// 				case (_group getVariable ["RydHQ_MIA",false]) : {_alive = false;_group setVariable ["RydHQ_MIA",nil]}
// 				};

// 			if (_alive) then
// 				{
// 				_UL = leader _group;
// 				if not (alive _UL) then {_alive = false};

// 				if (_alive) then
// 					{
// 					_nE = _UL findNearestEnemy (vehicle _UL);
// 					if not (isNull _nE) then {_dst = _nE distance (vehicle _UL)}
// 					}
// 				};

// 			(_dst < 500)
// 			};

// 		_group setVariable ["Garrisoned" + (str _group),false]
// 	};

// 	[[_group, _HQ], _code] call RYD_Spawn
// };

RYD_GarrS =
	{
	private ["_unit","_pos","_timer","_alive","_dst","_taken","_gar","_i","_vel","_sum","_posLast","_dst2","_HQ","_bld","_ix"];

	_unit = _this select 0;
	_pos = _this select 1;
	_bld = _this select 2;
	_taken = _this select 3;
	_HQ = _this select 4;

	_unit doMove _pos;

	//_i = [_pos,_unit,"markPos","ColorBrown","ICON","mil_box","Pos","",[0.3,0.3]] call RYD_Mark;

	_timer = 0;
	_alive = true;

	_posLast = getPosASL _unit;

	waitUntil
		{
		_dst = 0;
		if not (isNull _unit) then {_dst = _unit distance _pos};
		sleep 0.1;
		_dst2 = 0;
		if not (isNull _unit) then {_dst2 = _unit distance _pos};

		switch (true) do
			{
			case (isNull _unit) : {_alive = false};
			case (not (alive _unit)) : {_alive = false};
			case (_HQ getVariable ["RydHQ_KIA",false]) : {_alive = false};
			case ((group _unit) getVariable ["RydHQ_MIA",false]) : {_alive = false;(group _unit) setVariable ["RydHQ_MIA",nil]}
			};

		if (_dst2 >= _dst) then {_timer = _timer + 1};

		((unitReady _unit) or (_timer > 240) or not (_alive))
		};

	if not (_alive) exitWith {};

	doStop _unit;

	_dir = getDir _bld;

	_uPosASL = getPosASL _unit;
	_watchPos = [];
	_unitP = "UP";

	for "_i" from _dir to (_dir + 270) step 90 do
		{
		_cPosASL = [_uPosASL,_i,5] call RYD_PosTowards2D;
		_isLOS = [_cPosASL,_cPosASL,1.5,20,_unit,objNull] call RYD_LOSCheck;

		if (_isLOS) then
			{
			_isLOS = [_uPosASL,_cPosASL,1.5,1.5,_unit,objNull] call RYD_LOSCheck;

			if (_isLOS) then
				{
				_watchPos = ASLToATL _cPosASL
				}
			}
		};

	if ((count _watchPos) < 2) then
		{
		_unitP = "MIDDLE";
		_exits = [];
		_exitAct = _bld buildingExit 0;
		_ct = 0;

		while {((_exitAct distance [0,0,0]) > 0)} do
			{
			_isLOS = [_uPosASL,ATLToASL _exitAct,1.5,1.5,_unit,objNull] call RYD_LOSCheck;
			if (_isLOS) then
				{
				_exits pushBack _exitAct;
				};

			_ct = _ct + 1;
			_exitAct = _Bld buildingExit _ct;
			};

		if ((count _exits) > 0) then
			{
			_closestExit = [_uPosASL,_exits] call RYD_FindClosest;
			_watchPos = _closestExit
			}
		};

	if ((count _watchPos) < 2) then
		{
		_unitP = "MIDDLE";
		_chosenDir = random 360;
		_maxDst = 1;
		_dir = getDir _bld;
		for "_i" from _dir to (_dir + 270) step 90 do
			{
			_isLOS = true;
			_dst = 1;

			while {_isLOS} do
				{
				_cPosASL = [_uPosASL,_i,_dst] call RYD_PosTowards2D;
				_isLOS = [_uPosASL,_cPosASL,1.5,1.5,_unit,objNull] call RYD_LOSCheck;
				_dst = _dst + 1;
				if (_dst > 50) exitWith {};
				};

			if (_dst > _maxDst) then
				{
				_maxDst = _dst;
				_chosenDir = _i;
				};

			_watchPos = ASLToATL ([_uPosASL,_chosenDir,5] call RYD_PosTowards2D);
			};
		};

	_watchDir = [_uPosASL,_watchPos,5] call RYD_AngTowards;

	_unit setUnitPos _unitP;
	_unit setDir _watchDir;
	_unit doWatch _watchPos;

	waitUntil
		{
		sleep 30;
		switch (true) do
			{
			case (isNull _unit) : {_alive = false};
			case (not (alive _unit)) : {_alive = false};
			case (_HQ getVariable ["RydHQ_KIA",false]) : {_alive = false};
			case ((group _unit) getVariable ["RydHQ_MIA",false]) : {_alive = false;(group _unit) setVariable ["RydHQ_MIA",nil]}
			};

		_gar = (group _unit) getVariable ("Garrisoned" + (str (group _unit)));
		if not (_gar) then {_alive = false};
		not (_alive)
		};

	_ix = _taken select 1;
	_taken = _taken select 0;
	_taken deleteAt _ix;
	};

RYD_AmmoCount =
	{//[_group] call RYD_AmmoCount
	private ["_group","_ct","_ncVeh","_gVeh"];

	_group = _this select 0;

	_ncVeh = [];
	if ((count _this) > 1) then {_ncVeh = _this select 1};
	_gVeh = [];

	{if not (_x == (vehicle _x)) then {_gVeh pushBackUnique (vehicle _x)}} forEach (units _group);

	_ct = 0;

		{
		_ct = _ct + (count (magazines (_x)));
//		if ((toLower (typeOf (vehicle _x))) in _ncVeh) then {_ct = _ct + (count (magazines _x))}
		}
	forEach (units _group);

		{
		_ct = _ct + (count (magazineCargo  (_x)));
		}
	forEach _gVeh;

	_ct
	};

RYD_AmmoFullCount =
	{//[_group] call RYD_AmmoFullCount
	private ["_group","_ct","_ncVeh","_checked","_vh","_magsD","_am","_ctMax","_mCount","_magsM","_tp","_back","_magsB","_mag","_magEntry","_trt","_vehicles"];

	_group = _this select 0;

	_ncVeh = [];
	if ((count _this) > 1) then {_ncVeh = _this select 1};

	_checked = [];
	_vehicles = [];

	_ct = 0;
	_ctMax = 0;
	//_ctM = 0;
	//_ctMMax = 0;

		{
		_vh = _x;
		if not ((vehicle _x) == _x) then {_vehicles pushBackUnique (vehicle _x)};
		_tp = typeOf _x;

		switch (true) do
			{
			case (not (_vh in _checked)) :
				{
				_checked pushBackUnique _vh;

				_magsM = 0;

				_trt = (configFile >> "CfgVehicles" >> (typeOf _vh) >> "Turrets" >> "MainTurret");

				if (isClass _trt) then
					{
					_magsM = (getArray (_trt >> "magazines"));
					}
				else
					{
					_magsM = (getArray (configFile >> "CfgVehicles" >> (typeOf _vh) >> "magazines"));
					};

				//_ctMMax = _ctMMax + ({((getNumber (configFile >> "CfgAmmo" >> (getText (configFile >> "CfgMagazines" >> _x >> "ammo")) >> "Hit")) > 0)} count _magsM);

					{
					if ((getNumber (configFile >> "CfgAmmo" >> (getText (configFile >> "CfgMagazines" >> _x >> "ammo")) >> "Hit")) > 0) then
						{
						_mCount = getNumber (configFile >> "CfgMagazines" >> _x >> "count");
						_ctMax = _ctMax + _mCount;
						}
					}
				forEach _magsM;

				_magsD = magazinesAmmo _vh;

					{
					if ((getNumber (configFile >> "CfgAmmo" >> (getText (configFile >> "CfgMagazines" >> (_x select 0) >> "ammo")) >> "Hit")) > 0) then
						{
						_ct = _ct + (_x select 1)
						}
					}
				forEach _magsD;

				//_ctM = _ctM + ({((getNumber (configFile >> "CfgAmmo" >> (getText (configFile >> "CfgMagazines" >> (_x select 0) >> "ammo")) >> "Hit")) > 0)} count _magsD);
				}
			}
		}
	forEach (units _group);

	{
		_vh = vehicle _x;
		_tp = typeOf _x;

		switch (true) do
			{
			case ((toLower (typeOf _vh)) in _ncVeh) :
				{
				_magsM = getArray (configFile >> "CfgVehicles" >> _tp >> "magazines");

				//_ctMMax = _ctMMax + ({(getNumber ((configFile >> "CfgAmmo" >> (getText (configFile >> "CfgMagazines" >> _x >> "ammo")) >> "Hit")) > 0)} count _magsM);

					{
					if ((getNumber (configFile >> "CfgAmmo" >> (getText (configFile >> "CfgMagazines" >> _x >> "ammo")) >> "Hit")) > 0) then
						{
						_mCount = getNumber (configFile >> "CfgMagazines" >> _x >> "count");
						_ctMax = _ctMax + _mCount;
						}
					}
				forEach _magsM;

				_back = getText (configFile >> "CfgVehicles" >> _tp >> "backpack");

				if not (_back in [""]) then
					{
					_magsB = (configFile >> "CfgVehicles" >> _back >> "TransportMagazines");

					for "_i" from 1 to (count _magsB) do
						{
						_magEntry = _magsB select (_i - 1);
						_mag = getText (_magEntry >> "magazine");

						if ((getNumber (configFile >> "CfgAmmo" >> (getText (configFile >> "CfgMagazines" >> _mag >> "ammo")) >> "Hit")) > 0) then
							{
							_am = getNumber (_magEntry >> "count");
							_mCount = getNumber (configFile >> "CfgMagazines" >> _mag >> "count");
							_ctMax = _ctMax + (_mCount * _am);
							//_ctMMax = _ctMMax + _am;
							}
						}
					};

				_magsD = magazinesAmmoFull _x;

					{
					if ((getNumber (configFile >> "CfgAmmo" >> (getText (configFile >> "CfgMagazines" >> (_x select 0) >> "ammo")) >> "Hit")) > 0) then
						{
						_ct = _ct + (_x select 1)
						}
					}
				forEach _magsD;

				//_ctM = _ctM + ({((getNumber (configFile >> "CfgAmmo" >> (getText (configFile >> "CfgMagazines" >> (_x select 0) >> "ammo")) >> "Hit")) > 0)} count _magsD)
				};

			case (not (_vh in _checked)) :
				{
				_checked pushBackUnique _vh;

				_magsM = 0;

				_trt = (configFile >> "CfgVehicles" >> (typeOf _vh) >> "Turrets" >> "MainTurret");

				if (isClass _trt) then
					{
					_magsM = (getArray (_trt >> "magazines"));
					}
				else
					{
					_magsM = (getArray (configFile >> "CfgVehicles" >> (typeOf _vh) >> "magazines"));
					};

				//_ctMMax = _ctMMax + ({((getNumber (configFile >> "CfgAmmo" >> (getText (configFile >> "CfgMagazines" >> _x >> "ammo")) >> "Hit")) > 0)} count _magsM);

					{
					if ((getNumber (configFile >> "CfgAmmo" >> (getText (configFile >> "CfgMagazines" >> _x >> "ammo")) >> "Hit")) > 0) then
						{
						_mCount = getNumber (configFile >> "CfgMagazines" >> _x >> "count");
						_ctMax = _ctMax + _mCount;
						}
					}
				forEach _magsM;

				_magsD = magazinesAmmo _vh;

					{
					if ((getNumber (configFile >> "CfgAmmo" >> (getText (configFile >> "CfgMagazines" >> (_x select 0) >> "ammo")) >> "Hit")) > 0) then
						{
						_ct = _ct + (_x select 1)
						}
					}
				forEach _magsD;

				//_ctM = _ctM + ({((getNumber (configFile >> "CfgAmmo" >> (getText (configFile >> "CfgMagazines" >> (_x select 0) >> "ammo")) >> "Hit")) > 0)} count _magsD);
				}
			}
		}
	forEach (_vehicles);

	(_ct/(_ctMax max 1))//(_ct/(_ctMax max 1)) min (_ctM/(_ctMMax max 1))
	};

RYD_Mark =
	{//[_pos,_ref,_pfx,_cl,_shp,_tp,_dTxt,_ifPTxt,_sz,_dir] call RYD_Mark;
	private ["_pos","_ref","_pfx","_cl","_shp","_tp","_dTxt","_ifPTxt","_sz","_dir","_txt","_i"];

	_pos = _this select 0;
	_ref = _this select 1;
	_pfx = _this select 2;

	_cl = _this select 3;
	_shp = _this select 4;
	_tp = _this select 5;
	_dTxt = _this select 6;
	_ifPTxt = _this select 7;

	_sz = [1,1];
	if ((count _this) > 8) then {_sz = _this select 8};

	_dir = 0;
	if ((count _this) > 9) then {_dir = _this select 9};

	_txt = _dTxt;

	if (typeName _ref == "GROUP") then
		{
		if (isPlayer (leader _ref)) then {_txt = _dTxt }
		};

	if ((typeName _pos) == "OBJECT") then {_pos = position _pos};

	if not ((typeName _pos) == "ARRAY") exitWith {};
	if ((_pos select 0) == 0) exitWith {};
	if ((count _pos) < 2) exitWith {};
//diag_log format ["mark: %1 pos: %2 col: %3 size: %4 dir: %5 text: %6",_pfx + (str _ref),_pos,_cl,_sz,_dir,_txt];

	if (isNil "_pos") exitWith {};

	_i = _pfx + (str _ref);
	_i = createMarker [_i,_pos];
	_i setMarkerColor _cl;
	_i setMarkerShape _shp;
	if (_shp =="ICON") then {_i setMarkerType _tp} else {_i setMarkerBrush _tp};
	_i setMarkerSize _sz;
	_i setMarkerDir _dir;
	_i setMarkerText _txt;

	RydxHQ_Markers pushBack _i;

	_i
	};

RYD_WPadd =
	{//[_group,_pos,_tp,_beh,_CM,_spd,_sts,_crr,_rds,_TO,_formation] call RYD_WPadd;
	private
		[
		"_group","_HQ","_pos","_tp","_beh","_CM","_spd","_sts","_crr","_rds","_TO","_formation","_wp","_vh",
		"_topArr","_fFactor","_posX","_posY","_isWater","_wpn","_addedpath","_assVeh","_wps",
		"_isAir","_sPoint","_dst","_dstFirst","_mPoints","_num","_actDst","_angle","_mPoint",
		"_topPoints","_sPosX","_sPosY","_sUrban","_sForest","_sHills","_sFlat","_sSea",
		"_sGr","_count","_friendly","_opt","_j","_samplePos","_sRoads,","_lastDistance",
		"_dstCheck","_pfAll","_sRoads","_mpl","_frds","_TO2","_isFlat","_Sc","_posX","_posY"
		];

	_pfAll = true;

	_group = _this select 0;

	if ((typeName _group) == "ARRAY") then {_pfAll = false;_group = _group select 0};

	_HQ = grpNull;

	if not (isNil "LeaderHQ") then {if (_group in ((group LeaderHQ) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQ)}};
	if not (isNil "LeaderHQB") then {if (_group in ((group LeaderHQB) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQB)}};
	if not (isNil "LeaderHQC") then {if (_group in ((group LeaderHQC) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQC)}};
	if not (isNil "LeaderHQD") then {if (_group in ((group LeaderHQD) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQD)}};
	if not (isNil "LeaderHQE") then {if (_group in ((group LeaderHQE) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQE)}};
	if not (isNil "LeaderHQF") then {if (_group in ((group LeaderHQF) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQF)}};
	if not (isNil "LeaderHQG") then {if (_group in ((group LeaderHQG) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQG)}};
	if not (isNil "LeaderHQH") then {if (_group in ((group LeaderHQH) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQH)}};

	_pos = _this select 1;

	_tp = "MOVE";
	if ((count _this) > 2) then {_tp = _this select 2};

	_beh = "AWARE";
	if ((count _this) > 3) then {_beh = _this select 3};

	_CM = "YELLOW";
	if ((count _this) > 4) then {_CM = _this select 4};

	_spd = "NORMAL";
	if ((count _this) > 5) then {_spd = _this select 5};

	if (_HQ getVariable ["RydHQ_Rush",false]) then
		{
		if (_spd == "LIMITED") then
			{
			_spd = "NORMAL"
			};

		if (_beh == "SAFE") then
			{
			_beh = "AWARE"
			}
		};

	_sts = ["true","deletewaypoint [(group this), 0]"];
	if ((count _this) > 6) then {_sts = _this select 6};

	_crr = true;
	if ((count _this) > 7) then {_crr = _this select 7};

	_rds = 0;
	if ((count _this) > 8) then {_rds = _this select 8};

	_TO = [0,0,0];
	if ((count _this) > 9) then {_TO = _this select 9};

	_formation = formation _group;
	if ((count _this) > 10) then {_formation = _this select 10};

	if ((typeName _pos) == "OBJECT") then {_pos = position _pos};

	if (isNull _group) exitWith {diag_log format ["wp error group: %1 type: %3 pos: %2",_group,_pos,typeOf (vehicle (leader _group))]};
	if not ((typeName _pos == "ARRAY")) exitWith {diag_log format ["wp error group: %1 typ: %3 pos: %2",_group,_pos,typeOf (vehicle (leader _group))]};
	if ((count _pos) < 2) exitWith {diag_log format ["wp error group: %1 type: %3 pos: %2",_group,_pos,typeOf (vehicle (leader _group))]};
	if ((_pos select 0) == 0) exitWith {diag_log format ["wp error group: %1 type: %3 pos: %2",_group,_pos,typeOf (vehicle (leader _group))]};

	if (isNil "_pos") exitWith {diag_log format ["wp error group: %1 type: %3 pos: %2",_group,_pos,typeOf (vehicle (leader _group))]};

	_addedpath = false;

	if (isPlayer (leader _group)) then {_pfAll = false};

	if not (_rds == 0.01) then {[_group] call CBA_fnc_clearWaypoints};

	_frds = floor _rds;
	if (_frds == _rds) then
		{
		_pos = [_pos,50] call RYD_FlatLandNoRoad
		}
	else
		{
		_rds = 0
		};

	if (not (isNull (assignedVehicle (leader _group))) and (_group == (group (assignedVehicle (leader _group))))) then {
		if not ((assignedVehicle (leader _group)) isKindOf "Air") then {

			_Sc = 50;
			_posX = _pos select 0;
			_posY = _pos select 1;

			while {_Sc <= 400} do
			{
			_isFlat = _pos isFlatEmpty [10,_Sc,1.5,10,0,false,objNull];

			if ((count _isFlat) > 1) exitWith
				{
				_posX = _isFlat select 0;
				_posY = _isFlat select 1;
				};

			_Sc = _Sc + 50;
			};

			if (_posX > 0) then {_pos = [_posX,_posY,0]};
		};
	};

	if ((RydxHQ_PathFinding > 0) and (_pfAll)) then
		{
		_assVeh = assignedVehicle (leader _group);
		if (isNull _assVeh) then
			{
				{
				_vh = assignedVehicle _x;
				if not (isNull _vh) exitWith {_assVeh = _vh};
				_vh = vehicle _x;
				if not (_vh == _x) exitWith {_assVeh = _vh}
				}
			forEach (units _group)
			};

		if not (isNull _assVeh) exitWith {};//!

		_isAir = false;
		if not (isNull _assVeh) then
			{
			if (_assVeh isKindOf "Air") then {_isAir = true}
			};

		if not (_isAir) then
			{
			_sPoint = getPosATL (vehicle (leader _group));

			_wps = waypoints _group;

			if not ((count _wps) == 0) then
				{
				_sPoint = waypointPosition (_wps select ((count _wps) - 1))
				};

			_dst = _sPoint distance _pos;

			_lastDistance = _dst;

			if (_dst > RydxHQ_PathFinding) then
				{
				_dstFirst = _dst;
				_mPoints = [];

				while {(_dst > RydxHQ_PathFinding)} do
					{
					_dst = floor (_dst/2)
					};

				_dst = _dst * 2;

				_num = floor (_dstFirst/_dst);

				if (_num >= 2) then
					{
					_actDst = 0;
					_angle = [_sPoint,_pos,0] call RYD_AngTowards;

					for "_i" from 1 to _num do
						{
						_actDst = _actDst + _dst;
						_mPoint = [_sPoint,_angle,_actDst] call RYD_PosTowards2D;
						_mPoints pushBack _mPoint;
						};

					_topPoints = [];

						{
						_sPosX = _x select 0;
						_sPosY = _x select 1;

						_count = 10;

						_friendly = -1000000;
						_opt = _x;
						_samplePos = _x;
						_mpl = 1.5;

						for "_i" from 1 to _count do
							{
							_samplePos = [_sPosX + ((random (RydxHQ_PathFinding * _mpl)) - ((RydxHQ_PathFinding * _mpl)/2)),_sPosY + ((random (RydxHQ_PathFinding * _mpl)) - ((RydxHQ_PathFinding * _mpl)/2))];

							_topArr = [_samplePos,1] call RYD_TerraCognita;

							_sUrban = _topArr select 0;
							_sForest = _topArr select 1;
							_sHills = _topArr select 2;
							_sFlat = _topArr select 3;
							_sSea = _topArr select 4;
							_sGr = _topArr select 5;

							_sUrban = round (_sUrban*100);
							_sForest = round (_sForest*100);
							_sHills = round (_sHills*100);
							_sFlat = round (_sFlat*100);
							_sSea = round (_sSea*100);
							_sGr = round _sGr;

							_sRoads = count (_samplePos nearRoads 100);

							_fFactor = _sUrban + _sForest + _sGr - _sFlat - _sHills;

							if (not (isNull _assVeh) and (_assVeh isKindOf "LandVehicle")) then
								{
								_fFactor = _sFlat + _sHills + _sRoads - _sUrban - _sForest - _sGr
								};

							if (_fFactor > _friendly) then
								{
								_opt = _samplePos;
								_friendly = _fFactor
								}
							};

						_posX = _opt select 0;
						_posY = _opt select 1;

						_isWater = surfaceIsWater [_posX,_posY];


						_dstCheck = [_posX,_posY] distance _pos;

						if ((not (_isWater)) and (true)) then
							{
							_topPoints pushBack [_posX,_posY,0];
							_lastDistance = _dstCheck;
							}
						}
					forEach _mPoints;

					if ((count _topPoints) > 0) then
						{
						_wpn = 0;
						_TO2 = [0,0,0];
						if (RydHQ_Rush) then
							{
							if (_spd in ["NORMAL"]) then
								{
								_TO2 = [15,20,25]
								}
							};

							{
							//if (RydBB_Debug) then {_j = [_x,_group,(str (random 1000)),"ColorPink","ICON","mil_dot",(str _wpn),"",[0.25,0.25]] call RYD_Mark};

							_wpn = _wpn + 1;
							_wp = _group addWaypoint [_x, 0];
							_wp setWaypointType "MOVE";

							if (_foreachIndex == 0) then
								{
								_wp setWaypointBehaviour _beh;
								_wp setWaypointCombatMode _CM;
								_wp setWaypointSpeed _spd;
								_wp setWaypointFormation _formation;
								};

							_wp setWaypointStatements ["true","deletewaypoint [(group this), 0]"];
							_wp setWaypointTimeout _TO2;
							if ((_crr) and (_wpn == 1)) then {_group setCurrentWaypoint _wp};
							}
						forEach _topPoints
						};

					_addedpath = true;
					}
				}
			}
		};

	_wp = _group addWaypoint [_pos, _rds];
	_wp setWaypointType _tp;
	if ((_tp == "HOOK") and not (isNull (_group getVariable ["AmmBox" + (str _group),objNull]))) then {_wp waypointAttachVehicle (_group getVariable ["AmmBox" + (str _group),objNull]);_group setVariable ["AmmBox" + (str _group),objNull]};
	_wp setWaypointStatements _sts;
	_wp setWaypointTimeout _TO;

	if not (_addedpath) then
		{
		_wp setWaypointBehaviour _beh;
		_wp setWaypointCombatMode _CM;
		_wp setWaypointSpeed _spd;
		_wp setWaypointFormation _formation;

		if (_crr) then
			{
			_group setCurrentWaypoint _wp
			}
		};
	_wp
	};

RYD_TerraCognita =
	{
	private ["_position","_posX","_posY","_radius","_precision","_sourcesCount","_urban","_forest","_hills","_flat","_sea","_valS","_value","_val0","_samples","_sGr","_hprev","_hcurr","_samplePos","_i","_rds"];

	_position = _this select 0;
	_samples = _this select 1;
	_rds = 100;
	if ((count _this) > 2) then {_rds = _this select 2};

	if not ((typeName _position) == "ARRAY") then {_position = getPosATL _position};

	_posX = _position select 0;
	_posY = _position select 1;

	_radius = 5;
	_precision = 1;
	_sourcesCount = 1;

	_urban = 0;
	_forest = 0;
	_hills = 0;
	_flat = 0;
	_sea = 0;

	_sGr = 0;
	_hprev = getTerrainHeightASL [_posX,_posY];

	for "_i" from 1 to 10 do
		{
		_samplePos = [_posX + ((random (_rds * 2)) - _rds),_posY + ((random (_rds * 2)) - _rds)];
		_hcurr = getTerrainHeightASL _samplePos;
		_sGr = _sGr + abs (_hcurr - _hprev)
		};

	_sGr = _sGr/10;

		{
		_valS = 0;

		for "_i" from 1 to _samples do
			{
			_position = [_posX + (random (_rds/5)) - (_rds/10),_posY + (random (_rds/5)) - (_rds/10)];


			_value = selectBestPlaces [_position,_radius,_x,_precision,_sourcesCount];

			_val0 = _value select 0;
			_val0 = _val0 select 1;

			_valS = _valS + _val0;
			};

		_valS = _valS/_samples;

		switch (_x) do
			{
			case ("Houses") : {_urban = _urban + _valS};
			case ("Trees") : {_forest = _forest + (_valS/3)};
			case ("Forest") : {_forest = _forest + _valS};
			case ("Hills") : {_hills = _hills + _valS};
			case ("Meadow") : {_flat = _flat + _valS};
			case ("Sea") : {_sea = _sea + _valS};
			};
		}
	forEach ["Houses","Trees","Forest","Hills","Meadow","Sea"];

	[_urban,_forest,_hills,_flat,_sea,_sGr]
	};

RYD_GoLaunch =
	{
	private ["_kind","_code"];

	_kind = _this select 0;

	_code = {};

	switch (_kind) do
		{
		case ("INF") : {_code = HAL_GoAttInf};
		case ("ARM") : {_code = HAL_GoAttArmor};
		case ("SNP") : {_code = HAL_GoAttSniper};
		case ("AIR") : {_code = HAL_GoAttAir};
		case ("AIRCAP") : {_code = HAL_GoAttAirCAP};
		case ("NAVAL") : {_code = HAL_GoAttNaval};
		};

	_code
	};

RYD_FindClosestWithIndex =
	{
	private ["_ref","_objects","_closest","_dstMin","_dstAct","_index","_clIndex","_clst","_act"];

	_ref = _this select 0;
	_objects = _this select 1;

	_objects = _objects - [0];

	_closest = objNull;
	_clIndex = 0;

	if ((count _objects) > 0) then
		{
		_closest = _objects select 0;
		_clst = _closest;
		if ((typeName _clst) == (typeName grpNull)) then {_clst = vehicle (leader _clst)};
		_index = 0;
		_clIndex = 0;
		_dstMin = _ref distance _clst;

			{
			_act = _x;
			if ((typeName _act) == (typeName grpNull)) then {_act = vehicle (leader _act)};
			_dstAct = _ref distance _act;

			if (_dstAct < _dstMin) then
				{
				_closest = _x;
				_dstMin = _dstAct;
				_clIndex = _index
				};

			_index = _index + 1
			}
		forEach _objects
		};

	[_closest,_clIndex]
	};

/*RYD_FindClosestWithIndex =
	{
	private ["_ref","_objects","_closest","_dstMin","_dstAct","_index","_clIndex"];

	_ref = _this select 0;
	_objects = _this select 1;

	_closest = objNull;

	if ((count _objects) > 0) then
		{
		_closest = _objects select 0;
		_index = 0;
		_clIndex = 0;
		_dstMin = _ref distance _closest;

			{
			_dstAct = _ref distance _x;

			if (_dstAct < _dstMin) then
				{
				_closest = _x;
				_dstMin = _dstAct;
				_clIndex = _index
				};

			_index = _index + 1
			}
		foreach _objects
		};

	[_closest,_clIndex]
	};*/

RYD_DistOrd =
	{
	private ["_array","_point","_final","_closest","_ix","_limit","_clst"];

	_array = +(_this select 0);
	_point = _this select 1;
	_limit = _this select 2;

	_final = [];

	while {(({not ((typeName _x) in [(typeName "")])} count _array) > 0)} do
		{
		_closest = [_point,_array] call RYD_FindClosestWithIndex;
		_ix = _closest select 1;
		_closest = _closest select 0;
		_clst = _closest;
		if ((typeName _clst) == (typeName grpNull)) then {_clst = vehicle (leader _clst)};

		if ((_clst distance _point) < _limit) then
			{
			_final pushBack _closest
			};

		_array deleteAt _ix;
		};

	_final
	};

RYD_DistOrdC =
	{
	private ["_array","_first","_point","_dst","_limit","_final","_VL"];

	_array = _this select 0;//BB strategic areas
	_point = _this select 1;
	_limit = _this select 2;

	_first = [];
	_final = [];

		{
		_dst = round (_x distance _point);
		if (_dst <= _limit) then {_first set [_dst,_x]}
		}
	forEach _array;

		{
		if not (isNil "_x") then {_final pushBack _x}
		}
	forEach _first;

	_first = nil;

	_final
	};

RYD_DistOrdD =
	{
	private ["_array","_first","_point","_dst","_limit","_final","_VL","_pos","_sort"];

	_array = _this select 0;//BB strategic areas
	_point = _this select 1;
	_limit = _this select 2;

	_first = [];
	_sort = [];
	_mid = [];
	_final = [];

		{
		_dst = round (_x distance _point);
		if (_dst <= _limit) then {_first set [_dst,_x]}
		}
	forEach _array;

		{
		if not (isNil "_x") then {_sort pushBack _x}
		}
	forEach _first;

		{
		_pos =	(round ((((_foreachindex + 1)/(count _sort))*1000) + ((11 - (_x getVariable ["objvalue",5]))*100)));
		if ((count _mid) >= _pos) then {while {sleep 0.1; not (isNil {_mid select _pos})} do {_pos = _pos + 1}};
		_mid set [_pos,_x];
		}
	forEach _sort;

		{
		if not (isNil "_x") then {_final pushBack _x}
		}
	forEach _mid;

	_first = nil;
	_sort = nil;
	_mid = nil;

	_final
	};

RYD_Recon =
	{
	private ["_ammo","_gps","_IR","_garrA","_recAv","_flankAv","_AOnlyA","_exhA","_final","_pass","_trg","_lmt","_rcArr","_nCargo","_busy","_isRAir","_NCVeh","_Unable"];

	_gps = _this select 0;
	_IR = _this select 1;
	_rcArr = _this select 2;

	_garrA = _rcArr select 0;
	_recAv = _rcArr select 1;
	_flankAv = _rcArr select 2;
	_AOnlyA = _rcArr select 3;
	_exhA = _rcArr select 4;
	_nCargo = _rcArr select 5;
	_trg = _rcArr select 6;
	_NCVeh = _rcArr select 7;

	_lmt = _this select 3;
	_isRAir = _this select 4;

	_final = [];

		{
		_pass = true;

		if not ((_x in _recAv) or (_IR == "NR")) then
			{
			_pass = false
			}
		else
			{
			if (_x in _AOnlyA) then
				{
				_pass = false
				}
			else
				{
				if (_x in _exhA) then
					{
					_pass = false
					}
				else
					{
					if (_x in _garrA) then
						{
						_pass = false
						}
					else
						{
						if ((_x in _nCargo) and ((count (units _x)) <= 1) and (((assignedVehicle (leader _x)) emptyPositions "Cargo") > 4)) then
							{
							_pass = false
							}
						else
							{
							_ammo = [_x,_NCVeh] call RYD_AmmoCount;
							if ((_ammo == 0) and not (_isRAir)) then
								{
								_pass = false
								}
							else
								{
								_busy = _x getVariable ("Busy" + (str _x));
								if (isNil ("_busy")) then {_busy = false};
								_Unable = _x getVariable "Unable";
								if (isNil ("_Unable")) then {_Unable = false};
								if (_busy or _Unable) then
									{
									_pass = false
									}
								else
									{
									if (_x in _flankAv) then
										{
										_pass = false
										}
									}
								}
							}
						}
					}
				}
			};

		if (_pass) then {_final pushBack _x}
		}
	forEach _gps;

	if ((count _final) > 0) then {_final = [_final,_trg,_lmt] call RYD_DistOrd};

	_final
	};

RYD_Dispatcher =
	{
	_SCRname = "Dispatcher";

	private ["_threat","_kind","_pool","_cars","_air","_Fpool","_HQ","_force","_range","_pattern","_SortedForce","_tPos","_limit","_avF","_trg","_ix","_infEnough","_armEnough","_airEnough","_sum","_handled",
	"_SnipersG","_NCrewInfG","_LArmorG","_HArmorG","_LArmorATG","_ATInfG","_AAInfG","_chosen","_ammo","_reck","_topo","_sCity","_sForest","_sHills","_sMeadow","_sGr","_sVal","_mpl","_attackAv","_garrison",
	"_garrR","_flankAv","_busy","_positive","_ATriskResign1","_ATriskResign2","_AAriskResign","_AAthreat","_ATthreat","_allAir","_armorATthreat","_ATRR1","_ATRR2","_thRep","_isClose","_enDst","_thFct","_chVP",
	"_clstE","_Airmpl","_NCVeh","_snpEnough","_cntInf","_cntArm","_cntAir","_cntSnp","_Unable","_allNaval","_navEnough","_cntNav","_airCAP","_airCAS","_BAir","_fr"];

	_threat = _this select 0;
	_kind = _this select 1;
	_HQ = _this select 2;
	_ATriskResign1 = _this select 3;
	_ATriskResign2 = _this select 4;
	_AAriskResign = _this select 5;
	_AAthreat = _this select 6;
	_ATthreat = _this select 7;
	_armorATthreat = _this select 8;
	_Fpool = _this select 9;

	_SnipersG = _Fpool select 0;
	_NCrewInfG = _Fpool select 1;
	_air = _Fpool select 2;
	_LArmorG = _Fpool select 3;
	_HArmorG = _Fpool select 4;
	_cars = _Fpool select 5;
	_LArmorATG = _Fpool select 6;
	_ATInfG = _Fpool select 7;
	_AAInfG = _Fpool select 8;
	_reck = _Fpool select 9;
	_attackAv = _Fpool select 10;
	_garrison = _Fpool select 11;
	_garrR = _Fpool select 12;
	_flankAv = _Fpool select 13;
	_allAir = _Fpool select 14;
	_NCVeh = _Fpool select 15;
	_allNaval = _Fpool select 16;
	_airCAS = _Fpool select 17;
	_airCAP = _Fpool select 18;
	_BAir = _Fpool select 19;

	_pool = [];

	{
		if not (_x in (_airCAS)) then {_airCAS pushBack _x;};
	} forEach _BAir;

	{
		if not (_x in (_airCAP + _airCAS)) then {_airCAS pushBack _x; _airCAP pushBack _x;};
	} forEach _air;

	switch (_kind) do
		{
		case ("Recon") :
			{
			_pool = [[_SnipersG,0.5,"SNP"],[_NCrewInfG,0.5,"INF"]]
			};

		case ("ATInf") :
			{
			_pool = [[_SnipersG,0.5,"SNP"],[_airCAS,2,"AIR"],[_NCrewInfG,0.5,"INF"]]
			};

		case ("Inf") :
			{
			_pool = [[_LArmorG,1,"ARM"],[_HArmorG,1,"ARM"],[_SnipersG,0.5,"SNP"],[_cars,1,"INF"],[_airCAS,2,"AIR"],[_NCrewInfG,0.5,"INF"]]
			};

		case ("Armor") :
			{
			_pool = [[_airCAS,2,"AIR"],[_HArmorG,1,"ARM"],[_LArmorATG,1,"ARM"],[_ATInfG,0.5,"INF"]]
			};

		case ("Cars") :
			{
			_pool = [[_LArmorG,1,"ARM"],[_cars,1,"INF"],[_HArmorG,1,"ARM"],[_airCAS,2,"AIR"],[_NCrewInfG,0.5,"INF"]]
			};

		case ("Art") :
			{
			_pool = [[_airCAS,2,"AIR"],[_LArmorG,1,"ARM"],[_cars,1,"INF"],[_HArmorG,1,"ARM"],[_NCrewInfG,0.5,"INF"]]
			};

		case ("Air") :
			{
			_pool = [[_airCAP,2,"AIRCAP"],[_AAInfG,0.5,"INF"]]
			};

		case ("Static") :
			{
			_pool = [[_airCAS,2,"AIR"],[_LArmorG,1,"ARM"],[_SnipersG,0.5,"SNP"],[_cars,1,"INF"],[_HArmorG,1,"ARM"],[_NCrewInfG,0.5,"INF"]]
			};

		case ("Naval") :
			{
			_pool = [[_allNaval,2,"NAVAL"]]
			};
		};

	_limit = 3;
	_infEnough = 3;
	_armEnough = 2;
	_airEnough = 1;
	_snpEnough = 2;
	_navEnough = 3;

	_cntInf = {(_x in ((_NCrewInfG - _cars) + _cars))} count _attackAv;
	_cntArm = {(_x in ((_HArmorG + _LArmorG) - (_NCrewInfG + _air)))} count _attackAv;
	_cntAir = {(_x in (_air - (_NCrewInfG)))} count _attackAv;
	_cntNav = {(_x in (_allNaval - (_NCrewInfG)))} count _attackAv;
	_cntSnp = {((_x in (_SnipersG)) and ((count (units _x)) <= 2))} count _attackAv;

		{
		if (_x >= 0) then
			{
			switch (_foreachIndex) do
				{
				case (0) : {_infEnough = ceil (_cntInf * _x)};
				case (1) : {_armEnough = ceil (_cntArm * _x)};
				case (2) : {_airEnough = ceil (_cntAir * _x)};
				case (3) : {_snpEnough = ceil (_cntSnp * _x)};
				case (4) : {_navEnough = ceil (_cntNav * _x)};
				}
			}
		}
	forEach RydxHQ_MARatio;

	_sVal = 0;
	_mpl = 1 + _reck;

		{
		_handled = _x getVariable "HAC_Attacked";

		_sum = 0;

		if (isNil "_handled") then
			{
			_sum = 6;
			_infEnough = 3;
			_armEnough = 2;
			_airEnough = 1;
			_snpEnough = 2;
			_navEnough = 3;

				{
				if (_x >= 0) then
					{
					switch (_foreachIndex) do
						{
						case (0) : {_infEnough = ceil (_cntInf * _x)};
						case (1) : {_armEnough = ceil (_cntArm * _x)};
						case (2) : {_airEnough = ceil (_cntAir * _x)};
						case (3) : {_snpEnough = ceil (_cntSnp * _x)};
						case (4) : {_navEnough = ceil (_cntNav * _x)};
						}
					}
				}
			forEach RydxHQ_MARatio;
			}
		else
			{
			{_sum = _sum + _x} forEach _handled;
			_infEnough = _handled select 0;
			_armEnough = _handled select 1;
			_airEnough = _handled select 2;
			_snpEnough = _handled select 3;
			_navEnough = _handled select 4;
			};

		if not (alive (leader _x)) then {_sum = 0};
		if (isNull (leader _x)) then {_sum = 0};

		_fr = _HQ getVariable ["RydHQ_Front",locationNull];
		if not (isNull _fr) then
			{
			if not ((getPosATL (vehicle (leader _x))) in _fr) then {_sum = 0}
			};

		if (_sum > 0) then
			{
			_trg = vehicle (leader _x);
			_tPos = getPosATL _trg;

			_topo = [_trg,5] call RYD_TerraCognita;

			_sCity = 100 * (_topo select 0);
			_sForest = 100 * (_topo select 1);
			_sHills = 100 * (_topo select 2);
			_sMeadow = 100 * (_topo select 3);
			_sGr = _topo select 5;

				{
				_pattern = _x select 2;

				switch (true) do
					{
					case (_pattern in ["ARM"]) : {_limit = _armEnough};
					case (_pattern in ["AIR","AIRCAP"]) : {_limit = _airEnough};
					case (_pattern in ["SNP"]) : {_limit = _snpEnough};
					case (_pattern in ["NAVAL"]) : {_limit = _navEnough};
					default {_limit = _infEnough};
					};

				if (_limit >= 1) then
					{
					_force = _x select 0;
					_range = _x select 1;

					_FTFinPool = [];

					if ((count (_HQ getVariable ["RydHQ_FirstToFight",[]])) > 0) then
						{

							{
							if (_x in (_HQ getVariable ["RydHQ_FirstToFight",[]])) then
								{
								_FTFinPool pushBack _x
								}
							}
						forEach _force;
						};

					_SortedForce = [_force,_tPos,10000*_range] call RYD_DistOrd;

					_SortedForce = _FTFinPool + (_SortedForce - _FTFinPool);

					_avF = _SortedForce;

					_ix = 0;

					while {((_limit > 0) and ((count _avF) > 0) and (_ix < (count _SortedForce)))} do
						{
						_chosen = _SortedForce select _ix;
						_chVP = getPosATL (vehicle (leader _chosen));
						_ix = _ix + 1;

						_positive = true;

						_ammo = [_chosen,_NCVeh] call RYD_AmmoCount;

						switch (true) do
							{
							case (_pattern in ["SNP"]) : {_sVal = ((((2 * _sHills) + (2 * _sMeadow) + (_sGr/5)) * _mpl) - (((_sCity/2) + _sForest)/_mpl))};
							case (_pattern in ["ARM"]) : {_sVal = ((((5 * _sMeadow) + (_sHills)) * _mpl) - (((_sCity/2) + (3 * _sForest) + _sGr)/_mpl))};
							case (_pattern in ["AIR","AIRCAP"]) : {_sVal = ((((4 * _sMeadow) + (_sHills)) * _mpl) - (((_sCity) + (2 * _sForest) + (_SGr/5))/_mpl))};
							case (_pattern in ["NAVAL"]) : {_sVal = 120};
							default {_sVal = (0.5 + _sCity + (2 * _sForest) + (_sGr/10)) * (0.5 * _mpl) - ((0.05 + (2 * _sMeadow)) * (0.5/_mpl))};
							};

						if (_sVal < (5 + (10 * _reck))) then {_sVal = (5 + (10 * _reck))};

						_busy = _chosen getVariable ("Busy" + (str _chosen));
						if (isNil "_busy") then {_busy = false};
						_Unable = _chosen getVariable "Unable";
						if (isNil "_Unable") then {_Unable= false};

						if (_busy) then
							{
							_positive = false
							}
						else
							{
							if (_Unable) then
								{
								_positive = false
								}
							else
								{
								if (_ammo == 0) then
									{
									_positive = false
									}
								else
									{
									if ((random 100) > _sVal) then
										{
										_positive = false
										}
									else
										{
										if ((_chosen in _garrison) and (((vehicle (leader _chosen)) distance _tPos) > _garrR)) then
											{
											_positive = false
											}
										else
											{
											if not (_chosen in _attackAv) then
												{
												_positive = false
												}
											else
												{
												if (_chosen in _flankAv) then
													{
													_positive = false
													}
												else
													{
													if (_pattern in ["AIR","AIRCAP"]) then
														{
														_Airmpl = 0;
														if ([] call RYD_IsNight) then {_Airmpl = 3};
														if ((((random 100) * (1 + _reck)) < ((_Airmpl + overcast) * 30)) and not ((random 100) > 95)) then
															{
															_positive = false
															}
														}
													else
														{
														if (_pattern in ["SNP","INF"]) then
															{
															if (_pattern in ["SNP"]) then
																{
																if ((count (units _chosen)) > 2) then
																	{
																	_positive = false
																	}
																};

															if ((_chosen in _allAir) and ((count _AAthreat) > 0)) then
																{
																_thRep = [_chVP,_AAthreat,25000] call RYD_CloseEnemyB;
																_isClose = _thRep select 0;
																_clstE = getPosATL (vehicle (leader (_thRep select 2)));
																_enDst = [_chVP,_tPos,_clstE] call RYD_PointToSecDst;

																if ((_isClose) and (_enDst > 0) and (_enDst < 1500)) then
																	{
																	_thFct = (2500/(sqrt _enDst))/(0.5 + (2 * _reck));//diag_log format ["Grp: %1 endst: %2 thFct: %3",typeOf (vehicle (leader _chosen)),_enDst,_thFct];
																	if (((random 100) < _thFct) and not (((random 100) > (90 - (_reck * 10))) and (_thFct >= (95 - (_reck * 10))))) then
																		{
																		_positive = false
																		}
																	}
																}
															else
																{
																if ((_chosen in (_LArmorG + _HArmorG)) and ((count _ATthreat) > 0)) then
																	{
																	_thRep = [_chVP,_ATthreat,25000] call RYD_CloseEnemyB;
																	_isClose = _thRep select 0;
																	_clstE = getPosATL (vehicle (leader (_thRep select 2)));
																	_enDst = [_chVP,_tPos,_clstE] call RYD_PointToSecDst;

																	if ((_isClose) and (_enDst > 0) and (_enDst < 1500)) then
																		{
																		_thFct = (2500/(sqrt _enDst))/(0.5 + (2 * _reck));//diag_log format ["Grp: %1 endst: %2 thFct: %3",typeOf (vehicle (leader _chosen)),_enDst,_thFct];
																		if (((random 100) < _thFct) and not (((random 100) > (95 - (_reck * 10))) and (_thFct >= (95 - (_reck * 10))))) then
																			{
																			_positive = false
																			}
																		}
																	}
																}
															}
														}
													}
												}
											}
										}
									}
								}
							};

						_ATRR1 = _ATriskResign1;
						_ATRR2 = _ATriskResign2;
						if (_chosen in _LArmorG) then
							{
							_ATRR1 = _ATRR1 + 10;
							_ATRR2 = _ATRR2 + 10;
							};

						if (_positive) then
							{
							if (_pattern in ["ARM"]) then
								{
								if ((count _ATthreat) > 0) then
									{
									_thRep = [_chVP,_ATthreat,25000] call RYD_CloseEnemyB;
									_isClose = _thRep select 0;
									_clstE = getPosATL (vehicle (leader (_thRep select 2)));
									_enDst = [_chVP,_tPos,_clstE] call RYD_PointToSecDst;

									if ((_isClose) and (_enDst > 0) and (_enDst < 1500)) then
										{
										_thFct = ((_ATRR1 * 40)/(sqrt _enDst))/(0.5 + (2 * _reck));//diag_log format ["Grp: %1 endst: %2 thFct: %3",typeOf (vehicle (leader _chosen)),_enDst,_thFct];
										if (((random 100) < _thFct) and not (((random 100) > (95 - (_reck * 10))) and (_thFct >= (95 - (_reck * 10))))) then
											{
											_positive = false
											}
										}
									}
								else
									{
									if ((count _armorATthreat) > 0) then
										{
										_thRep = [_chVP,_ATthreat,25000] call RYD_CloseEnemyB;
										_isClose = _thRep select 0;
										_clstE = getPosATL (vehicle (leader (_thRep select 2)));
										_enDst = [_chVP,_tPos,_clstE] call RYD_PointToSecDst;

										if ((_isClose) and (_enDst > 0) and (_enDst < 1500)) then
											{
											_thFct = ((_ATRR2 * 40)/(sqrt _enDst))/(0.5 + (2 * _reck));//diag_log format ["Grp: %1 endst: %2 thFct: %3",typeOf (vehicle (leader _chosen)),_enDst,_thFct];
											if (((random 100) < _thFct) and not (((random 100) > (95 - (_reck * 10))) and (_thFct >= (95 - (_reck * 10))))) then
												{
												_positive = false
												}
											}
										}
									}
								};

							if (_pattern in ["AIR","AIRCAP"]) then
								{
								if ((count _AAthreat) > 0) then
									{
									_thRep = [_chVP,_ATthreat,25000] call RYD_CloseEnemyB;
									_isClose = _thRep select 0;
									_clstE = getPosATL (vehicle (leader (_thRep select 2)));
									_enDst = [_chVP,_tPos,_clstE] call RYD_PointToSecDst;

									if ((_isClose) and (_enDst > 0) and (_enDst < 1500)) then
										{
										_thFct = ((_AAriskResign * 40)/(sqrt _enDst))/(0.5 + (2 * _reck));//diag_log format ["Grp: %1 endst: %2 thFct: %3",typeOf (vehicle (leader _chosen)),_enDst,_thFct];
										if (((random 100) < _thFct) and not (((random 100) > (95 - (_reck * 10))) and (_thFct >= (95 - (_reck * 10))))) then
											{
											_positive = false
											}
										}
									}
								}
							};


						if (_positive) then
							{
							_chosen setVariable ["Busy" + (str _chosen),true];
							_HQ setVariable ["RydHQ_AttackAv",(_HQ getVariable ["RydHQ_AttackAv",[]]) - [_chosen]];
							//[_chosen,_trg,_HQ] spawn ([_pattern] call RYD_GoLaunch);

							[[_chosen,_trg,_HQ],([_pattern] call RYD_GoLaunch)] call RYD_Spawn;
							_limit = _limit - 1
							};

						_avF = _avF - [_chosen]
						};

					switch (true) do
						{
						case (_pattern in ["ARM"]) : {_armEnough = _limit};
						case (_pattern in ["AIR","AIRCAP"]) : {_airEnough = _limit};
						case (_pattern in ["SNP"]) : {_snpEnough = _limit};
						case (_pattern in ["NAVAL"]) : {_navEnough = _limit};
						default {_infEnough = _limit};
						}
					}

				}
			forEach _pool;

			_x setVariable ["HAC_Attacked",[_infEnough,_armEnough,_airEnough,_snpEnough,_navEnough]]
			}
		}
	forEach _threat
	};

RYD_VarReductor =
	{
	private ["_trg","_kind","_HAC_Attacked","_infEnough","_armEnough","_airEnough","_isAttacked","_snpEnough","_navEnough"];

	_trg = _this select 0;
	_kind = _this select 1;

	_HAC_Attacked = (group _trg) getVariable "HAC_Attacked";
	if (isNil "_HAC_Attacked") then {_HAC_Attacked = [0,0,0,0,0]};

	_infEnough = _HAC_Attacked select 0;
	_armEnough = _HAC_Attacked select 1;
	_airEnough = _HAC_Attacked select 2;
	_snpEnough = _HAC_Attacked select 3;
	_navEnough = _HAC_Attacked select 4;

	switch (_kind) do
		{
		case ("InfAttacked") : {_infEnough = _infEnough + 1};
		case ("SnpAttacked") : {_snpEnough = _snpEnough + 1};
		case ("ArmorAttacked") : {_armEnough = _armEnough + 1};
		case ("AirAttacked") : {_airEnough = _airEnough + 1};
		case ("NavAttacked") : {_navEnough = _navEnough + 1};
		};

	(group _trg) setVariable ["HAC_Attacked",[_infEnough,_armEnough,_airEnough,_snpEnough,_navEnough]];

	if not (_kind == "AirAttacked") then
		{
		_isAttacked = (group _trg) getVariable (_kind + (str (group _trg)));if (isNil "_isAttacked") then {_isAttacked = 0};
		if (_isAttacked > 0) then {(group _trg) setVariable [(_kind + (str (group _trg))),_isAttacked - 1]}
		}
	};

RYD_CloseEnemy =
	{
	private ["_pos","_eG","_limit","_tooClose","_dst"];

	_pos = _this select 0;
	_eG = _this select 1;
	_limit = _this select 2;

	if ((count _eG) == 0) exitWith {false};

	_tooClose = false;

	_dst = 100000;

		{
		_dst = (vehicle (leader _x)) distance _pos;
		if (_dst < _limit) exitWith {_tooClose = true}
		}
	forEach _eG;

	_tooClose
	};

RYD_CloseEnemyB =
	{
	private ["_pos","_eG","_limit","_tooClose","_dstM","_dstAct","_closest"];

	_pos = _this select 0;
	_eG = _this select 1;
	_limit = _this select 2;

	if ((count _eG) == 0) exitWith {[false,100000,grpNull]};

	_tooClose = false;

	_dstM = 100000;
	_closest = _eG select 0;

		{
		_dstAct = (vehicle (leader _x)) distance _pos;
		if (_dstAct < _dstM) then {_closest = _x;_dstM = _dstAct}
		}
	forEach _eG;

	if (_dstM < _limit) then {_tooClose = true};

	[_tooClose,_dstM,_closest]
	};

RYD_Wait =
	{
	private ["_group","_int","_int0","_ammoF","_speedF","_enemyF","_tolerance","_air","_cargo","_timer","_alive","_enemy","_UL","_DAV","_GDV","_AV","_inside","_outside","_own","_wplimit","_isBusy","_busy",
	"_isInside","_isOutside","_enG","_arr","_type","_cplR","_cWp","_wpCheck","_boxed","_firedF","_fCount","_forBoxing","_wp","_pass","_Break","_isPlayer","_enPres","_HQ","_ctc","_dw","_fr"];

	_group = _this select 0;
	_int0 = _this select 1;

	_int = floor _int0;
	_ammoF = false;

	_speedF = _this select 2;
	_enemyF = _this select 3;
	_tolerance = _this select 4;

	_arr = _this select 5;
	_air = [];
	_enG = [];

	_HQ = grpNull;

	if ((count _arr) > 0) then
		{
		_enG = _arr select 1;
		_air = _arr select 0;
		if ((count _arr) > 2) then {
			_HQ = _arr select 2;
			_enG = _HQ getVariable ["RydHQ_KnEnemiesG",[]];
			_air = _HQ getVariable ["RydHQ_AirG",[]];
			};
		};

	if not (_int == _int0) then
		{
		_ammoF = true
		};

	_cargo = _this select 6;
	_inside = true;
	if ((count _this) > 7) then {_inside = _this select 7};
	_outside = true;
	if ((count _this) > 8) then {_outside = _this select 8};
	_own = false;
	if ((count _this) > 9) then {_own = _this select 9};
	_isBusy = false;
	if ((count _this) > 10) then {_isBusy = _this select 10};
	_wpCheck = true;
	if ((count _this) > 11) then {_wpCheck = _this select 11};
	_firedF = false;
	if ((count _this) > 12) then {_firedF = _this select 12};
	_pass = (units _group);
	if ((count _this) > 13) then {_pass = _this select 13};

	_wplimit = 1;
	if not ((_tolerance - (round _tolerance)) == 0) then {_wplimit = 2};

	_timer = 0;
	_alive = false;
	_enemy = false;
	_enPres = false;
	_busy = false;
	_isInside = false;
	_isOutside = false;
	_Break = false;

	_UL = leader (_this select 0);
	_AV = vehicle _UL;
	_DAV = _UL;
	_GDV = _group;

	waitUntil
		{
		sleep _int;

		_isPlayer = (isPlayer (leader _group));

		_alive = true;
		switch (true) do
			{
			case (isNull (_this select 0)) : {_alive = false};
			case (({alive _x} count (units (_this select 0))) < 1) : {_alive = false};
			case (isNull _AV) : {_alive = false};
			case (not (alive _AV)) : {_alive = false};
			case ((_this select 0) getVariable ["RydHQ_MIA",false]) : {_alive = false;(_this select 0) setVariable ["RydHQ_MIA",nil]};
			case ((_this select 0) getVariable ["Break",false]) : {_Break = true;_alive = false}
			};

		if (_alive) then
			{
			if (_cargo) then
				{
				_AV = assignedVehicle _UL;
				_DAV = assignedDriver _AV;
				if not (_own) then {_GDV = group _DAV};

				waitUntil {sleep 0.5;not (isNull (assignedVehicle _UL))};

				_AV = assignedVehicle _UL;
				_DAV = assignedDriver _AV;
				if not (_own) then {_GDV = group _DAV};

//				if (not (_group getVariable ["CargoChosen",false]) and not (_own)) then {_Break = true};
				};

			if ((count _arr) > 0) then
				{
				_enG = _arr select 1;
				_air = _arr select 0;
				if ((count _arr) > 2) then {
					_HQ = _arr select 2;
					_enG = _HQ getVariable ["RydHQ_KnEnemiesG",[]];
//					_air = _HQ getVariable ["RydHQ_AirG",[]];
					};
				};

			if (_enemyF > 0) then
				{
				if not ((_GDV in _air) and not (_own)) then {_enemy = [_AV,_enG,_enemyF] call RYD_CloseEnemy}
				} else {
				if not (_GDV in _air) then {_enPres = [_AV,_enG,RydxHQ_DisembarkRange] call RYD_CloseEnemy}
				};

			if ((_group getVariable ["InfGetinCheck"  + (str _group),false]) and (_GDV == _group) and not (isNull (assignedVehicle _UL))) then {

				_AV = assignedVehicle _UL;
				_DAV = assignedDriver _AV;

				if (not (_enemy) and not (_enPres) and not (_GDV in _air)) then {
					_ctc = objNull;
					_ctc = (vehicle (leader _group)) findNearestEnemy (vehicle (leader _group));
					if not (isNull _ctc) then
						{
							if (((vehicle (leader _group)) distance _ctc) < RydxHQ_DisembarkRange) then {_enPres = true; if (_enemyF > 0) then {_enemy = true;}};
						};
					};

				if ((_enemy) or (_enPres)) then
					{
						if ((_GDV == _group) and not (isNull _AV)) then {_AV setUnloadInCombat [true, false]};

					} else {

						if ((_GDV == _group) and not (isNull _AV)) then
							{
								_AV setUnloadInCombat [false, false];
								_dw = false;
								{
								// Workaround for braindead BIS AI when using mech or mot infantry...
								if (not ((_x == (assignedCommander _AV)) or (_x == (assignedDriver _AV)) or (_x == (assignedGunner _AV))) and not ((vehicle _x) == _AV)) then { if (_x == (leader _group)) then {_x assignAsCommander _AV};_x assignAsCargo _AV;};
								if (((assignedVehicle _x) == _AV) and (_x == (vehicle _x))) then {[_x] orderGetIn true; doStop _AV; _AV setVariable ["WaitForCargo" + (str _AV),true]; _dw = true;};
								} forEach (units _group);
								if ((_AV getVariable ["WaitForCargo" + (str _AV),false]) and not (_dw)) then {_AV setVariable ["WaitForCargo" + (str _AV),false];};
								if ((abs (speed (_AV)) < 0.05) and not (_dw) and not ((count (waypoints _unitG)) < 1) and ((time - (_AV getVariable ["LastMoveOR",0])) > 10) ) then {_AV doMove [((position _AV) select 0) +5,((position _AV) select 1) +5,(position _AV) select 2]; _AV setVariable ["LastMoveOR",time];}
							};

					};

//				if (_AV getVariable ["WaitForCargo" + (str _AV),false]) then {_enemy = false};

			};

			if (not (isNull _GDV) and not (isNull _UL)) then {_alive = true} else {_alive = false};
			if (_speedF) then
				{
				if not (RydxHQ_SynchroAttack) then
					{
					if (abs (speed (vehicle (leader _GDV))) < 0.05) then {_timer = _timer + 1;}
					}
				else
					{
					_type = typeOf _AV;
					_cplR = getNumber (configFile >> "CfgVehicles" >> _type >> "precision");
					_cWp = waypointPosition [_group, (currentWaypoint _group)];
					if ((abs (speed (vehicle (leader _GDV))) < 0.05) and ((_cWp distance _AV) >= _cplR)) then {_timer = _timer + 1}
					}
				};

			_pass = (units _group);
			if ((count _this) > 13) then {_pass = _this select 13};

			if not (_inside) then
				{
					{
					if not (_x in _AV) exitWith {_isInside = false};
					_isInside = true;
					}
				forEach _pass;

				_timer = _timer + 1
				};

			if not (_outside) then
				{
					{
					if (_x in _AV) exitWith {_isOutside = false};
					_isOutside = true;
					}
				forEach _pass;

				_timer = _timer + 1
				};

			if (_cargo) then
				{
				if (_own) then
					{
					_alive = false;
					if not (isNull _AV) then {_alive = true}
					}
				};

			if (_isBusy) then
				{
				_busy = _group getVariable ("Busy" + (str _group));
				if (isNil "_busy") then {_busy = false}
				};


			_forBoxing = _group getVariable "forBoxing";

			if ((_ammoF) and not (isNil "_forBoxing")) then
				{
				[_group, (currentWaypoint _group)] setWaypointType "HOLD";
				[_group, (currentWaypoint _group)] setWaypointPosition [_forBoxing, 10];
				_forBoxing = nil;
				_group setVariable ["ForBoxing",nil]
				};

			_boxed = _group getVariable "isBoxed";

			if ((_ammoF) and not (isNil "_boxed")) then
				{
				_boxed = getPosATL _boxed;
				_boxed = [_boxed,20] call RYD_RandomAround;
				_wp = [_group,[_boxed select 0,_boxed select 1],"MOVE","AWARE","GREEN","FULL",["true","deletewaypoint [(group this), 0]"]] call RYD_WPadd;
				_boxed = nil;
				_group setVariable ["isBoxed",nil]
				};

			_fCount = (leader _group) getVariable "FireCount";
			if (isNil "_fCount") then {_fCount = 0};

			if ((_firedF) and (_fCount >= 2) and not (_isPlayer)) then
				{
				_timer = _tolerance + _int;
				(leader _group) setVariable ["FireCount",nil]
				};

			if not (isNil {_group getVariable "RydHQ_WaitingTarget"}) then
				{
				_wtgt = _group getVariable "RydHQ_WaitingTarget";
				if ((isNull _wtgt) or not (alive _wtgt)) then {
					[_group] call CBA_fnc_clearWaypoints;
					_group setVariable ["RydHQ_WaitingTarget",nil];
					_timer = _tolerance + 10;
					} else {
					_fr = _HQ getVariable ["RydHQ_Front",locationNull];
					if not (isNull _fr) then
						{
						if not ((getPosATL _wtgt) in _fr) then
							{
							[_group] call CBA_fnc_clearWaypoints;
							_group setVariable ["RydHQ_WaitingTarget",nil];
							_timer = _tolerance + 10;
							};
						};
					};
				};

			if not (isNil {_group getVariable "RydHQ_WaitingObjective"}) then
				{
				_wotgt = ((_group getVariable "RydHQ_WaitingObjective") select 1);
				_woHQ = ((_group getVariable "RydHQ_WaitingObjective") select 0);
				if ((isNull _wotgt) or (_wotgt in (_woHQ getVariable ["RydHQ_Taken",[]]))) then {
					[_group] call CBA_fnc_clearWaypoints;
					_group setVariable ["RydHQ_WaitingObjective",nil];
					};
				};
			};

		((((count (waypoints _GDV)) < _wplimit) and (_wpCheck)) or ((_timer > _tolerance) and not (_isPlayer)) or ((_enemy) and not (_isPlayer)) or (_Break) or not (_alive) or (_isInside) or (_isOutside) or (_busy))
		};

	if (_isPlayer) then {_timer = 0};

	if not (isNull (_AV)) then {_AV setVariable ["WaitForCargo" + (str _AV),false]};

	_group setVariable ["RydHQ_WaitingTarget",nil];
	_group setVariable ["RydHQ_WaitingObjective",nil];

	if (_group getVariable ["InfGetinCheck"  + (str _group),false]) then {_group setVariable ["InfGetinCheck"  + (str _group),false]; if (_GDV == _group) then {_AV setUnloadInCombat [true, false]}};

	if (_timer > _tolerance) then {if ((random 100) < RydxHQ_AIChatDensity) then {[(leader _group),RydxHQ_AIC_OrdDen,"OrdDen"] call RYD_AIChatter}};

	if (_Break) then {
		_alive = false;
//		_group setVariable [("Busy" + (str _group)),false];
//		_group setVariable [("Capt" + (str _group)),false];
//		_group setVariable [("Deployed" + (str _group)),false];
//		_group setVariable ["Defending", false];

		_group setVariable ["Break",false];
		_timer = _tolerance + 10;
	};


	[_timer,_alive,_enemy,_busy,_Break]
	};

RYD_CreateDecoy =
	{
	private ["_class","_pos","_HQ","_group","_object"];

	_pos = _this select 0;

	_class = "Sign_Sphere100cm_F";

	_object = _class createVehicle _pos;
	_object setPosATL _pos;
	_object setObjectTexture [0,"#(ARGB,8,8,3)color(1,1,1,0,ca)"];

	_object
	};

RYD_Smoke =
	{
	//private ["_group","_lastV","_Scount","_unit","_muzzles","_mags","_sMuzzle","_mag","_nE"];

	_group = _this select 0;
	_nE = _this select 1;

	_lastV = objNull;
	_Scount = 0;

		{
		_unit = _x;
		if (((vehicle _unit) == _unit) and not (isPlayer _unit)) then
			{
			_muzzles = getArray (configFile >> "CfgWeapons" >> (primaryWeapon _unit) >> "muzzles");
			_muzzles = _muzzles + (getArray (configFile >> "CfgWeapons" >> (secondaryWeapon _unit) >> "muzzles"));
			_muzzles = _muzzles + (getArray (configFile >> "CfgWeapons" >> "Throw" >> "muzzles"));

			_mags = [];
			_magsR = magazinesAmmoFull _unit;

				{
				_mags pushBack (_x select 0)
				}
			forEach _magsR;

				{
				_sMuzzle = "";
				_mag = "";

				if ((_x select 0) in _muzzles) then
					{
					_sMuzzle = _x select 0;
					};

				if not (_sMuzzle isEqualTo "") then
					{
						{
						if (_x in _mags) exitWith
							{
							_mag = _x
							}
						}
					forEach (_x select 1)
					};

				if not ("" in [_sMuzzle,_mag]) exitWith
					{
					_posF = getPosATL _unit;
					_posT = getPosATL _nE;
					_dst = _unit distance _nE;
					_hgt = (_dst min 200) * (0.025 + (random 0.025));

					_posT = [[(((_posF select 0) + (_posT select 0))/2),(((_posF select 1) + (_posT select 1))/2),0],5 * (_dst/200)] call RYD_RandomAround;

					_posT set [2,_hgt];

					_dst2D = [(_posT select 0),(_posT select 1)] distance _posF;

					_dc = [_posT] call RYD_CreateDecoy;

					if (_sMuzzle in ["EGLM","GL_3GL_F"]) then
						{
						[_unit,_posT,_dc,_dst2D,_sMuzzle,_mag] spawn
							{
							_unit = _this select 0;
							_posT = _this select 1;
							_dc = _this select 2;
							_dst2D = _this select 3;
							_sMuzzle = _this select 4;
							_mag = _this select 5;

							_posT = [(_posT select 0) - ((wind select 0) * (sqrt _dst2D) * 0.25),(_posT select 1) - ((wind select 1) * (sqrt _dst2D) * 0.25),_posT select 2];

							_dc setPosATL _posT;

							_unit doWatch _dc;
							sleep 0.1;

							_unit doTarget _dc;
							sleep 3;

							_unit selectWeapon _sMuzzle;
							sleep 1;

							_unit fire [_sMuzzle,_sMuzzle,_mag];
							sleep 1;

							deleteVehicle _dc;
							_unit doWatch objNull;
							}

						}
					else
						{
						[_unit,_posT,_dc,_dst2D,_sMuzzle,_mag] spawn
							{
							_unit = _this select 0;
							_posT = _this select 1;
							_dc = _this select 2;
							_dst2D = _this select 3;
							_sMuzzle = _this select 4;
							_mag = _this select 5;

							_posT = [(_posT select 0) - ((wind select 0) * _dst2D * 0.25),(_posT select 1) - ((wind select 1) * _dst2D * 0.25),_posT select 2];

							_dc setPosATL _posT;

							_unit doWatch _dc;
							sleep 1;

							_unit selectWeapon _sMuzzle;
							_unit fire [_sMuzzle,_sMuzzle,_mag];

							sleep 0.1;

							_unit doWatch objNull;
							deleteVehicle _dc;
							}
						};

					_Scount = _Scount + 1
					}
				}
			forEach RydxHQ_SmokeMuzzles;
			};

		if not (((vehicle _x) == _x) and not (_lastV == (vehicle _x))) then {_lastV = vehicle _x;_lastV selectWeapon "SmokeLauncher";_lastV fire "SmokeLauncher";_Scount = _Scount + 1};
		if (_Scount > 2) exitWith {};
		}
	forEach (units _group)
	};

RYD_isNight =
	{//math by CarlGustaffa
	//private ["_lat","_day","_hour","_sunangle","_isNight"];
	private ["_isNight"];

	_isNight = not ((sunOrMoon - ((overcast/2)^(2 - overcast))) > 0.15);

	/*_isNight = false;

	_lat = -1 * getNumber(configFile >> "CfgWorlds" >> worldName >> "latitude");
	_day = 360 * (dateToNumber date);
	_hour = (daytime / 24) * 360;
	_sunangle = ((12 * (cos _day) - 78) * (cos _lat) * (cos _hour)) - (24 * (sin _lat) * (cos _day));

	if (_sunangle < -10) then {_isNight = true};*/

	_isNight
	};

RYD_Flares =
	{
	_SCRname = "Flares";

	private ["_group","_UL","_nE","_inDef","_Scount","_lat","_day","_hour","_sunangle","_arty","_flare","_shells","_pos","_CFF","_ldr"];

	_group = _this select 0;
	_arty = _this select 2;
	_shells = _this select 3;
	_ldr = _this select 4;

	_UL = leader _group;

	_inDef = true;

	while {_inDef} do
		{
		sleep (60 + (random 60));

		_flare = _this select 1;

		if (_flare) then
			{
			if ([] call RYD_isNight) then
				{
				if not (false) then
					{
					_nE = _UL findNearestEnemy _UL;
					if not (isNull _nE) then
						{
						if ((_nE distance (vehicle _UL)) <= 400) then
							{
							_pos = getPosASL _nE;

							_CFF = false;

							if ((_shells > 0) and ((random 100) > 50)) then
								{
								if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_IllumReq,"IllumReq"] call RYD_AIChatter}};
								_CFF = ([_pos,_arty,"ILLUM",1,_UL] call RYD_ArtyMission) select 0;
								if (_CFF) then
									{
									if ((random 100) < RydxHQ_AIChatDensity) then {[_ldr,RydxHQ_AIC_ArtAss,"ArtAss"] call RYD_AIChatter};
									}
								else
									{
									if ((random 100) < RydxHQ_AIChatDensity) then {[_ldr,RydxHQ_AIC_ArtDen,"ArtDen"] call RYD_AIChatter};
									}
								};

							if (not (_CFF) and not (isPlayer _UL)) then
								{
								_Scount = 0;

									{
									_unit = _x;
									if (((vehicle _unit) == _unit) and not (isPlayer _unit)) then
										{
										_muzzles = getArray (configFile >> "CfgWeapons" >> (primaryWeapon _unit) >> "muzzles");
										_muzzles = _muzzles + (getArray (configFile >> "CfgWeapons" >> (secondaryWeapon _unit) >> "muzzles"));

										_mags = [];
										_magsR = magazinesAmmoFull _unit;

											{
											_mags pushBack (_x select 0);
											}
										forEach _magsR;

											{
											_sMuzzle = "";
											_mag = "";

											if ((_x select 0) in _muzzles) then
												{
												_sMuzzle = _x select 0;
												};

											if not (_sMuzzle isEqualTo "") then
												{
													{
													if (_x in _mags) exitWith
														{
														_mag = _x
														}
													}
												forEach (_x select 1)
												};

											if not ("" in [_sMuzzle,_mag]) exitWith
												{
												[_unit,_nE,_sMuzzle,_mag] spawn
													{
													_unit = _this select 0;
													_nE = _this select 1;
													_sMuzzle = _this select 2;
													_mag = _this select 3;

													_posF = getPosATL _unit;
													_posT = getPosATL _nE;
													_dst = _unit distance _nE;
													_hgt = _dst * (0.25 + (random 0.25));

													_posT = [[((_posF select 0) + (_posT select 0))/2,((_posF select 1) + (_posT select 1))/2,0],20 * (_dst/200)] call RYD_RandomAround;

													_posT set [2,_hgt];

													_dc = [_posT] call RYD_CreateDecoy;

													_unit doWatch _dc;
													sleep 0.1;

													_unit doTarget _dc;
													sleep 5;

													_unit selectWeapon _sMuzzle;
													sleep 1;

													_unit fire [_sMuzzle,_sMuzzle,_mag];
													sleep 0.1;

													_unit doWatch objNull;
													deleteVehicle _dc;
													};

												_Scount = _Scount + 1;
												}
											}
										forEach RydxHQ_FlareMuzzles;
										};

									if (_Scount > 0) exitWith {};
									}
								forEach (units _group)
								}
							}
						}
					}
				}
			};

		_inDef = _group getVariable "Defending";
		if (isNull _group) then {_inDef = false};
		if not (alive _UL) then {_inDef = false};
		}
	};

RYD_ArtyPrep =
	{
	private ["_arty","_amount","_vh","_handled","_magTypes","_mags","_tp","_cnt"];

	_arty = _this select 0;
	_amount = _this select 1;

	_amount = ceil _amount;
	//if (_amount < 2) exitWith {};

		{
			{
			_vh = vehicle _x;
			_handled = _vh getVariable ["RydHQArtyAmmoHandled",false];

			if not (_handled) then
				{
				_vh setVariable ["RydHQArtyAmmoHandled",true];

				_vh addEventHandler ["Fired",
					{
					(_this select 0) setVariable ["RydHQ_ShotFired",true];
					(_this select 0) setVariable ["RydHQ_ShotFired2",((_this select 0) getVariable ["RydHQ_ShotFired2",0]) + 1];
					}];

				_magTypes = getArtilleryAmmo [_vh];
				_mags = magazines _vh;

					{
					_tp = _x;
					_cnt = {_x in [_tp]} count _mags;
					_vh addMagazines [_tp, _cnt * (_amount - 1)];
					}
				forEach _magTypes
				}
			}
		forEach (units _x)
		}
	forEach _arty;
	};

RYD_CFF_TGT =
	{//_tgt = [RydHQ_KnEnemies] call RYD_CFF_TGT;
	private ["_enemies","_targets","_target","_nothing","_potential","_potL","_taken","_candidate","_CL","_vehFactor","_artFactor","_crowdFactor","_veh","_nearImp","_ValMax","_trgValS",
	"_temptation","_vh","_HQfactor","_nearCiv"];

	_enemies = _this select 0;

	_targets = [];
	_target = objNull;
	_temptation = 0;
	_nothing = 0;

		{
		_potential = vehicle _x;

		if not (isNil "_potential") then
			{
			if not (isNull _potential) then
				{
				if (alive _potential) then
					{
					_potL = vehicle (leader _potential);
					_taken = (group _potential) getVariable ["CFF_Taken",false];

					if not (isNil "_taken") then
						{
						if not (_taken) then
							{
							if (((getPosATL _potL) select 2) < 20) then
								{
								if ((abs(speed _potL)) < 50) then
									{
									if ((count (weapons (leader _potential))) > 0) then
										{
										if not ((leader _potential) isKindOf "civilian") then
											{
											if not (captive _potL) then
												{
												if not (_potential in _targets) then
													{
													if ((damage _potL) < 0.9) then
														{
														_targets pushBack _potential
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	forEach _enemies;

		{
		_candidate = _x;
		_CL = leader _candidate;

		_temptation = 0;
		_vehFactor = 0;
		_artFactor = 1;
		_crowdFactor = 1;
		_HQFactor = 1;
		_veh = objNull;

		if not (isNull (assignedVehicle _CL)) then {_veh = assignedVehicle _CL};
		if not ((vehicle _CL) == _CL) then
			{
			_veh = vehicle _CL;
			if ((toLower (typeOf _veh)) in RydHQ_AllArty) then {_artFactor = 10} else {_vehFactor = 500 + (rating _veh)};
			};

		_nearImp = (getPosATL _CL) nearEntities [["CAManBase","AllVehicles","Strategic","WarfareBBaseStructure","Fortress"],100];
		_nearCiv = false;

			{
			if (_x isKindOf "civilian") exitWith {_nearCiv = true};
			if (((side _x) getFriend (side _CL)) >= 0.6) then
				{
				_vh = vehicle _x;
				_crowdFactor = _crowdFactor + 0.2;
				if not (_x == _vh) then
					{
					_crowdFactor = _crowdFactor + 0.2;
					if ((toLower (typeOf _vh)) in RydHQ_AllArty) then
						{
						_crowdFactor = _crowdFactor + 0.2
						}
					}
				};
			}
		forEach _nearImp;

		if (_CL in RydxHQ_AllLeaders) then {_HQFactor = 20};

		if (_nearCiv) then
			{
			_targets deleteAt _foreachIndex
			}
		else
			{

				{
				_temptation = _temptation + (250 + (rating _x));
				}
			forEach (units _candidate);

			_temptation = (((_temptation + _vehFactor)*10)/(5 + (speed _CL))) * _artFactor * _crowdFactor * _HQFactor;
			_candidate setVariable ["CFF_Temptation",_temptation]
			}
		}
	forEach _targets;

	_ValMax = 0;

		{
		_trgValS = _x getVariable ["CFF_Temptation",0];
		if ((_ValMax < _trgValS) and (random 100 < 85)) then {_ValMax = _trgValS;_target = _x};
		}
	forEach _targets;

	if (isNull _target) then
		{
		if not ((count _targets) == 0) then
			{
			_target = _targets select (floor (random (count _targets)))
			}
		else
			{
			_nothing = 1
			}
		};

	_target
	};

RYD_CFF_Fire =
	{
	_SCRname = "CFF_Fire";

	private ["_battery","_pos","_ammo","_amount","_guns","_vh","_mags","_amount0","_eta","_alive","_available","_perGun","_rest","_aGuns","_perGun1","_shots","_toFire","_rest0","_bad","_ammoC","_ws","_code"];

	_battery = _this select 0;
	_pos = _this select 1;
	_ammo = _this select 2;
	_amount = _this select 3;

	_eta = -1;

	_guns = [];

		{
		if not (isNull _x) then
			{
				{
				_vh = vehicle _x;
				if not (_vh in _guns) then
					{
					_shots = 0;

						{
						if ((_x select 0) in _ammo) then
							{
							_shots = _shots + (_x select 1)
							}
						}
					forEach (magazinesAmmo _vh);

					_vh setVariable ["RydHQ_ShotsToFire",0];
					_vh setVariable ["RydHQ_MyShots",_shots];

					if (_shots > 0) then
						{
						_guns pushBack _vh
						}
					}
				}
			forEach (units _x)
			}
		}
	forEach _battery;

	_aGuns = count _guns;

	if (_aGuns < 1) exitWith {-1};
	if (_amount < 1) exitWith {-1};

	_perGun = floor (_amount/_aGuns);
	_rest = _amount - (_perGun * _aGuns);

		{
		_shots = _x getVariable ["RydHQ_MyShots",0];
		if not (_shots > _perGun) then
			{
			_x setVariable ["RydHQ_ShotsToFire",_shots];
			_amount = _amount - _shots;
			_rest = _rest + (_perGun - _shots);
			_x setVariable ["RydHQ_MyShots",0]
			}
		else
			{
			_x setVariable ["RydHQ_ShotsToFire",_perGun];
			_x setVariable ["RydHQ_MyShots",_shots - _perGun]
			};
		}
	forEach _guns;

	_bad = false;

	while {(_rest > 0)} do
		{
		_rest0 = _rest;

			{
			if (_rest < 1) exitWith {};
			_shots = _x getVariable ["RydHQ_MyShots",0];

			if (_shots > 0) then
				{
				_toFire = _x getVariable ["RydHQ_ShotsToFire",0];

				_rest = _rest - 1;

				_x setVariable ["RydHQ_ShotsToFire",_toFire + 1];
				_x setVariable ["RydHQ_MyShots",_shots - 1]
				}
			}
		forEach _guns;

		if (not (_rest0 > _rest) and (_rest > 0)) exitWith {_bad = true}
		};

	if (_bad) exitWith {-1};

	_code =
		{
		_SCRname = "ArtyFiring";

		_vh = _this select 0;
		_pos = _this select 1;
		_ammo = _this select 2;

		if (_pos inRangeOfArtillery [[_vh],_ammo]) then
			{
			if (_ammo in (getArtilleryAmmo [_vh])) then
				{
				_vh setVariable ["RydHQ_GunFree",false];

				if not ((currentMagazine _vh) in [_ammo]) then
					{
					_vh loadMagazine [[0],currentWeapon _vh,_ammo];

					_ct = time;

					waitUntil
						{
						sleep 0.1;
						_ws = weaponState [_vh,[0]];
						_ws = _ws select 3;
						((_ws in [_ammo]) or ((time - _ct) > 30))
						};

					sleep ((getNumber (configFile >> "cfgWeapons" >> (currentWeapon _vh) >> "magazineReloadTime")) + 0.1)
					};

				if (_pos inRangeOfArtillery [[_vh],_ammo]) then
					{
					if (_ammo in (getArtilleryAmmo [_vh])) then
						{
						[_vh,[_pos, _ammo,(_vh getVariable ["RydHQ_ShotsToFire",1])]] remoteExecCall ["doArtilleryFire",_vh];

						_ct = time;

						waitUntil
							{
							sleep 0.1;
							(not ((_vh getVariable ["RydHQ_ShotFired2",0]) < (_vh getVariable ["RydHQ_ShotsToFire",1])) or ((time - _ct) > 15))
							};

						_vh setVariable ["RydHQ_ShotFired",true];
						_vh setVariable ["RydHQ_ShotFired2",0];
						}
					};

				sleep ((getNumber (configFile >> "cfgWeapons" >> (currentWeapon _vh) >> "reloadTime")) + 0.5);

				_vh setVariable ["RydHQ_GunFree",true]
				}
			}
		};

		{
		switch (true) do
			{
			case (isNil {_x}) : {_guns set [_foreachIndex,objNull]};
			case (isNull _x) : {_guns set [_foreachIndex,objNull]};
			case not (alive _x) : {_guns set [_foreachIndex,objNull]};
			}
		}
	forEach _guns;

	_guns = _guns - [objNull];

	if ((count _guns) < 1) exitWith {-1};

		{
		if not (isNull _x) then
			{
			_vh = vehicle _x;

			if ((_vh getVariable ["RydHQ_ShotsToFire",0]) > 0) then
				{
				_mags = getArtilleryAmmo [_vh];

				_ammoC = (magazines _vh) select 0;

					{
					if (_x in _ammo) exitWith
						{
						_ammoC = _x
						}
					}
				forEach (magazines _vh);

				if (_ammoC in _mags) then
					{
					_amount = _amount - 1;

					_newEta = _vh getArtilleryETA [_pos,_ammoC];

					if (isNil "_newEta") then {_newEta = -1};

					if ((_newEta < _eta) or (_eta < 0)) then
						{
						_eta = _newEta
						};

					[[_vh,_pos,_ammoC],_code] call RYD_Spawn
					}
				}
			}
		}
	forEach _guns;

		/*{
		if not (isNull _x) then
			{
				{
				(vehicle _x) setVariable ["RydHQ_GunFree",true]
				}
			foreach (units _x)
			}
		}
	foreach _battery;*/

	_eta
	};

RYD_ArtyMission =
	{//_bArr = [_tgtPos,RydHQ_ArtG,"SADARM",6,leaderHQ] call RYD_ArtyMission;
	_SCRname = "ArtyMission";

	private ["_pos","_arty","_ammoG","_amount","_FO","_ammo","_possible","_battery","_agp","_artyAv","_vehs","_group","_hasAmmo","_checked","_vh","_tp","_inRange","_pX","_pY","_pZ","_ammoArr","_code","_allAmmo"];

	_pos = _this select 0;
	_arty = _this select 1;
	_ammoG = _this select 2;
	_amount = _this select 3;
	_FO = _this select 4;

	_ammo = "";
	_ammoArr = [];

	_hasAmmo = 0;
	_possible = false;
	_battery = [];
	_agp = [];

	_artyAv = [];
	_vehs = 0;
	_allAmmo = 0;

		{
		_group = _x;
		if not (isNull _group) then
			{
			if not (_group getVariable ["RydHQ_BatteryBusy",false]) then
				{
				_hasAmmo = 0;
				_checked = [];

					{
					_vh = vehicle _x;
					if not (_vh in _checked) then
						{
						_checked pushBack _vh;

						_tp = toLower (typeOf _vh);

						switch (true) do
							{
							case (_tp in RydHQ_Mortar_A3) :
								{
								switch (_ammoG) do
									{
									case ("HE") : {_ammo = "8Rnd_82mm_Mo_shells"};
									case ("SPECIAL") : {_ammo = "8Rnd_82mm_Mo_shells"};
									case ("SECONDARY") : {_ammo = "8Rnd_82mm_Mo_shells"};
									case ("SMOKE") : {_ammo = "8Rnd_82mm_Mo_Smoke_white"};
									case ("ILLUM") : {_ammo = "8Rnd_82mm_Mo_Flare_white"};
									}
								};

							case (_tp in RydHQ_SPMortar_A3) :
								{
								switch (_ammoG) do
									{
									case ("HE") : {_ammo = "32Rnd_155mm_Mo_shells"};
									case ("SPECIAL") : {_ammo = "2Rnd_155mm_Mo_Cluster"};
									case ("SECONDARY") : {_ammo = "2Rnd_155mm_Mo_guided"};
									case ("SMOKE") : {_ammo = "6Rnd_155mm_Mo_smoke"};
									case ("ILLUM") : {_ammo = ""};
									};
								};

							case (_tp in RHQ_RocketArty) :
								{
								switch (_ammoG) do
									{
									case ("HE") : {_ammo = (((magazinesAllTurrets _vh) select 0) select 0)};
									case ("SPECIAL") : {_ammo = (((magazinesAllTurrets _vh) select 0) select 0)};
									case ("SECONDARY") : {_ammo = (((magazinesAllTurrets _vh) select 0) select 0)};
									case ("SMOKE") : {_ammo = ""};
									case ("ILLUM") : {_ammo = ""};
									};
								};

							case (_tp in RydHQ_Rocket_A3) :
								{
								switch (_ammoG) do
									{
									case ("HE") : {_ammo = "12Rnd_230mm_rockets"};
									case ("SPECIAL") : {_ammo = "12Rnd_230mm_rockets"};
									case ("SECONDARY") : {_ammo = "12Rnd_230mm_rockets"};
									case ("SMOKE") : {_ammo = ""};
									case ("ILLUM") : {_ammo = ""};
									};
								};

							default
								{
								if ((count RHQ_Art) > 0) then
									{
									_arr = [];

										{
										if (_tp in (_x select 0)) exitWith {_arr = _x select 1}
										}
									forEach RydHQ_OtherArty;

									if ((count _arr) > 0) then
										{

										switch (_ammoG) do
											{
											case ("HE") : {_ammo = _arr select 0};
											case ("SPECIAL") : {_ammo = _arr select 1};
											case ("SECONDARY") : {_ammo = _arr select 2};
											case ("SMOKE") : {_ammo = _arr select 3};
											case ("ILLUM") : {_ammo = _arr select 4};
											}

										} else {

										switch (_ammoG) do
											{
											case ("HE") : {_ammo = (((magazinesAllTurrets _vh) select 0) select 0)};
											case ("SPECIAL") : {_ammo = (((magazinesAllTurrets _vh) select 0) select 0)};
											case ("SECONDARY") : {_ammo = (((magazinesAllTurrets _vh) select 0) select 0)};
											case ("SMOKE") : {_ammo = ""};
											case ("ILLUM") : {_ammo = ""};
											};

										}
									}
								}
							};

						_inRange = _pos inRangeOfArtillery [[_vh],_ammo];

						if (_inRange) then
							{
								{
								if ((_x select 0) in [_ammo]) then
									{
									_hasAmmo = _hasAmmo + (_x select 1);
									_allAmmo = _allAmmo + (_x select 1);
									_ammoArr pushBack _ammo;
									_vehs = _vehs + 1
									};

								if not (_hasAmmo < _amount) exitWith {};
								if not (_allAmmo < _amount) exitWith {}
								}
							forEach (magazinesAmmo _vh);
							}
						};

					if not (_vehs < _amount) exitWith {}
					}
				forEach (units _group);

				if (_hasAmmo > 0) then
					{
					_artyAv pushBack _group;
					_agp pushBack leader _group
					}
				}
			};

		if not (_hasAmmo < _amount) exitWith {};
		if not (_allAmmo < _amount) exitWith {}
		}
	forEach _arty;

	if not ((count _artyAv) == 0) then
		{
		_battery = _artyAv;

		_possible = true;

		if (_ammoG in ["ILLUM","SMOKE"]) then
			{
				{
				if not (isNull _x) then
					{
					_x setVariable ["RydHQ_BatteryBusy",true]
					}
				}
			forEach _battery;

			_pX = _pos select 0;
			_pY = _pos select 1;
			_pZ = _pos select 2;

			_pX = _pX + (random 100) - 50;
			_pY = _pY + (random 100) - 50;
			_pZ = _pZ + (random 20) - 10;

			_pos = [_pX,_pY,_pZ];
//_i = [_pos,(random 1000),"markArty","ColorRed","ICON","mil_dot",_ammoG,"",[0.75,0.75]] call RYD_Mark;
			_code =
				{
				_battery = _this select 0;
				_pos = _this select 1;
				_ammo = _this select 2;
				_FO = getPosASL (_this select 3);
				_amount = _this select 4;
				_ammoG = _this select 5;

				if (_ammoG == "ILLUM") then
					{
					[_battery,_pos,_ammo,_amount] call RYD_CFF_Fire;
					}
				else
					{
					_angle = [_FO,_pos,10] call RYD_AngTowards;
					_pos2 = [_pos,_angle + 110,200 + (random 100) - 50] call RYD_PosTowards2D;
					_pos3 = [_pos,_angle - 110,200 + (random 100) - 50] call RYD_PosTowards2D;
					//_i2 = [_pos2,(random 1000),"markArty","ColorRed","ICON","mil_dot",_ammoG,"",[0.75,0.75]] call RYD_Mark;
					//_i3 = [_pos3,(random 1000),"markArty","ColorRed","ICON","mil_dot",_ammoG,"",[0.75,0.75]] call RYD_Mark;

						{
						[_battery,_x,_ammo,ceil (_amount/3)] call RYD_CFF_Fire;

						_ct = 0;
						waitUntil
							{
							sleep 0.1;
							_ct = _ct + 0.1;
							_busy = 0;

								{
								if not (isNull _x) then
									{
									_busy = _busy + ({not ((vehicle _x) getVariable ["RydHQ_GunFree",true])} count (units _x))
									};
								}
							forEach _battery;

							((_busy == 0) or (_ct > 12))
							};
						}
					forEach [_pos,_pos2,_pos3]
					};

				_ct = 0;
				waitUntil
					{
					sleep 0.1;
					_ct = _ct + 0.1;
					_busy = 0;

						{
						if not (isNull _x) then
							{
							_add = {not ((vehicle _x) getVariable ["RydHQ_GunFree",true])} count (units _x);
							_busy = _busy + _add;
							if (_add == 0) then {_x setVariable ["RydHQ_BatteryBusy",false]}
							};
						}
					forEach _battery;

					((_busy == 0) or (_ct > 12))
					};

					{
					if not (isNull _x) then
						{
						_x setVariable ["RydHQ_BatteryBusy",false]
						}
					}
				forEach _battery
				};

			[[_battery,_pos,_ammoArr,_FO,_amount,_ammoG],_code] call RYD_Spawn
			}
		};

	//diag_log format ["AM: %1",[_possible,_battery,_agp,_ammoArr]];

	[_possible,_battery,_agp,_ammoArr,_allAmmo]
	};

RYD_CFF_FFE =
	{//[_battery,_tgt,_batlead,"SADARM",RydHQ_Friends,RydHQ_Debug] spawn RYD_CFF_FFE
	_SCRname = "CFF_FFE";

	private ["_battery","_target","_batlead","_Ammo","_friends","_Debug","_ammoG","_batname","_first","_phaseF","_targlead","_againF","_dispF","_accF","_amount","_Rate","_FMType","_againcheck","_Aunit",
	"_RydAccF","_TTI","_amount1","_amount2","_template","_targetPos","_X0","_Y0","_X1","_Y1","_X2","_Y2","_Xav","_Yav","_transspeed","_transdir","_Xhd","_Yhd","_impactpos","_safebase","_distance",
	"_safe","_safecheck","_gauss1","_gauss09","_gauss04","_gauss2","_distance2","_DdistF","_DdamageF","_DweatherF","_DskillF","_anotherD","_Dreduct","_spawndisp","_dispersion","_disp","_RydAccF",
	"_gauss1b","_gauss2b","_AdistF","_AweatherF","_AdamageF","_AskillF","_Areduct","_spotterF","_anotherA","_acc","_finalimpact","_posX","_posY","_i","_dX","_dY","_angle","_dXb","_dYb","_posX2",
	"_posY2","_AmmoN","_exDst","_exPX","_exPY","_onRoad","_exPos","_nR","_stRS","_dMin","_dAct","_dSum","_checkedRS","_RSArr","_angle","_rPos","_actRS","_ammocheck","_artyGp","_ammoCount","_dstAct",
	"_maxRange","_minRange","_isTaken","_batlead","_alive","_waitFor","_UL","_ammoC","_add","_stoper","_code","_myFO","_assumedPos","_eta"];

	_battery = _this select 0;
	_target = _this select 1;
	_batlead = _this select 2;
	_Ammo = _this select 3;
	_friends = _this select 4;
	_Debug = _this select 5;
	_ammoG = _this select 6;
	_amount = _this select 7;
	_request = false;
	if ((count _this) > 8) then {_request = _this select 8};

	if (_request) then {_myFO = objNull;_assumedPos = _target;};

	if not (_request) then {
		_myFO = _target getVariable ["RydHQ_MyFO",objNull];
		_assumedPos = (getPosATL _target);
		if not (isNull _myFO) then
			{
			_assumedPos = _myFO getHideFrom _target;
			};

	};

	_markers = [];

	_battery1 = _battery select 0;
	_batLead1 = leader _battery1;

	_batname = str _battery1;

	//_first = _battery getVariable [("FIRST" + _batname),1];

	//_artyGp = group _batlead;

	if not (_request) then {_isTaken = (group _target) getVariable ["CFF_Taken",false]} else {_isTaken = false};

	if (_isTaken) exitWith
		{
			{
			if not (isNull _x) then
				{
				_x setVariable ["RydHQ_BatteryBusy",false]
				}
			}
		forEach _battery
		};

	if not (_request) then {(group _target) setVariable ["CFF_Taken",true]};

	_phaseF = [1];

	if not (_request) then {_targlead = vehicle (leader _target)};

	_waitFor = true;

	_amount1 = ceil (_amount/6);
	_amount2 = _amount - _amount1;

		{
		if not (_request) then {
			if (isNil ("_myFO")) exitWith {_waitFor = false};
			if (isNull _myFO) exitWith {_waitFor = false};
			if not (alive _myFO) exitWith {_waitFor = false};

			if (isNil ("_target")) exitWith {_waitFor = false};
			if (isNull _target) exitWith {_waitFor = false};
			if not (alive _target) exitWith {_waitFor = false};

			if (({not (isNull _x)} count _batlead) < 1) exitWith {_waitFor = false};
			if (isNull _battery1) exitWith {_waitFor = false};
			if (({(alive _x)} count _batlead) < 1)  exitWith {_waitFor = false};

			if ((abs (speed _target)) > 50) exitWith {_waitFor = false};
			if ((_assumedPos select 2) > 20)  exitWith {_waitFor = false};

			if ((_assumedPos distance [0,0,0]) == 0) exitWith {_waitFor = false};
		};

		_againF = 0.5;
		_accF = 2;

		_againcheck = _battery1 getVariable [("CFF_Trg" + _batname),objNull];
		if not (_request) then {if not ((str _againcheck) == (str _target)) then {_againF = 1}};

		_RydAccF = 1;

		//if (isNil ("RydART_Amount")) then {_amount = _this select 7} else {_amount = RydART_Amount};
		if (isNil ("RydART_Acc")) then {_accF = 2} else {_accF = RydART_Acc};

		//if (_ammoG in ["CLUSTER","GUIDED"]) then {_amount = ceil (_amount/3)};

		if ((count _phaseF) == 2) then
			{
			if (_x == 1) then
				{
				_amount = _amount1
				}
			else
				{
				_amount = _amount2
				}
			};

		if (_amount == 0) exitWith {_waitFor = false};

		if not (_request) then {
			if not (isNull _myFO) then
				{
				_assumedPos = _myFO getHideFrom _target;
				};
		};

		if ((_assumedPos distance [0,0,0]) == 0) exitWith {_waitFor = false};

		_targetPosATL = _assumedPos;
		_targetPos = ATLToASL _assumedPos;

		_eta = -1;

			{
			switch (true) do
				{
				case (isNil {_x}) : {_battery set [_foreachIndex,grpNull]};
				case (isNull _x) : {_battery set [_foreachIndex,grpNull]};
				case (({((alive _x) and not (_x == (vehicle _x)))} count (units _x)) < 1) : {_battery set [_foreachIndex,grpNull]};
				}
			}
		forEach _battery;

		_battery = _battery - [grpNull];

		if ((count _battery) < 1) exitWith {_waitFor = false};

			{
				{
				_vh = vehicle _x;
				_ammoC = (magazines _vh) select 0;

					{
					if (_x in _ammo) exitWith
						{
						_ammoC = _x
						}
					}
				forEach (magazines _vh);

				_newEta = -1;

				if not (isNil "_ammoC") then {_newEta = _vh getArtilleryETA [_targetPosATL,_ammoC]};

				if (isNil "_newEta") then {_newEta = -1};

				if ((_newEta < _eta) or (_eta < 0)) then
					{
					_eta = _newEta
					}
				}
			forEach (units _x)
			}
		forEach _battery;

		if (_eta == -1) exitWith {_waitFor = false};

		_X0 = (_targetpos select 0);
		_Y0 = (_targetpos select 1);

		sleep 10;
		if not (_request) then {
			if (isNil ("_myFO")) exitWith {_waitFor = false};
			if (isNull _myFO) exitWith {_waitFor = false};
			if not (alive _myFO) exitWith {_waitFor = false};

			if (isNull _target) exitWith {_waitFor = false};
			if not (alive _target) exitWith {_waitFor = false};

			if (({not (isNull _x)} count _batlead) < 1) exitWith {_waitFor = false};
			if (isNull _battery1) exitWith {_waitFor = false};
			if (({(alive _x)} count _batlead) < 1)  exitWith {_waitFor = false};

			if ((abs (speed _target)) > 50) exitWith {_waitFor = false};
			if ((_assumedPos select 2) > 20)  exitWith {_waitFor = false};

			if not (isNull _myFO) then
				{
				_assumedPos = _myFO getHideFrom _target;
				};
		};

		if ((_assumedPos distance [0,0,0]) == 0) exitWith {_waitFor = false};

		_targetPos = ATLToASL _assumedPos;

		_X1 = (_targetpos select 0);
		_Y1 = (_targetpos select 1);

		sleep 10;
		if not (_request) then {
			if (isNil ("_myFO")) exitWith {_waitFor = false};
			if (isNull _myFO) exitWith {_waitFor = false};
			if not (alive _myFO) exitWith {_waitFor = false};

			if (isNull _target) exitWith {_waitFor = false};
			if not (alive _target) exitWith {_waitFor = false};

			if (({not (isNull _x)} count _batlead) < 1) exitWith {_waitFor = false};
			if (isNull _battery1) exitWith {_waitFor = false};
			if (({(alive _x)} count _batlead) < 1)  exitWith {_waitFor = false};

			if ((abs (speed _target)) > 50) exitWith {_waitFor = false};
			if ((_assumedPos select 2) > 20)  exitWith {_waitFor = false};

			if not (isNull _myFO) then
				{
				_assumedPos = _myFO getHideFrom _target;
				};
		};

		if ((_assumedPos distance [0,0,0]) == 0) exitWith {_waitFor = false};

		_targetPos = ATLToASL _assumedPos;

		_X2 = (_targetpos select 0);
		_Y2 = (_targetpos select 1);

		if not (_request) then {_onRoad = isOnRoad _targlead} else {_onRoad = false};

		_Xav = (_X1+_X2)/2;
		_Yav = (_Y1+_Y2)/2;

		_transspeed = ([_X0,_Y0] distance [_Xav,_Yav])/15;
		_transdir = (_Xav - _X0) atan2 (_Yav - _Y0);

		_add = 16/(1 + (_transspeed));

		_Xhd = _transspeed * (sin _transdir) * (_eta + _add);
		_Yhd = _transspeed * (cos _transdir) * (_eta + _add);
		_impactpos = _targetpos;
		_safebase = 250;

		_exPX = (_targetPos select 0) + _Xhd;
		_exPY = (_targetPos select 1) + _Yhd;

		_exPos = [_exPX,_exPY,getTerrainHeightASL [_exPX,_exPY]];
		_exTargetPosATL = ASLToATL _exPos;

		_eta = -1;

			{
			switch (true) do
				{
				case (isNil {_x}) : {_battery set [_foreachIndex,grpNull]};
				case (isNull _x) : {_battery set [_foreachIndex,grpNull]};
				case (({((alive _x) and not (_x == (vehicle _x)))} count (units _x)) < 1) : {_battery set [_foreachIndex,grpNull]};
				}
			}
		forEach _battery;

		_battery = _battery - [grpNull];

		if ((count _battery) < 1) exitWith {_waitFor = false};

			{
				{
				_vh = vehicle _x;

				_ammoC = (magazines _vh) select 0;

					{
					if (_x in _ammo) exitWith
						{
						_ammoC = _x
						}
					}
				forEach (magazines _vh);

				_newEta = _vh getArtilleryETA [_exTargetPosATL,_ammoC];

				if (isNil "_newEta") then {_newEta = -1};

				if ((_newEta < _eta) or (_eta < 0)) then
					{
					_eta = _newEta
					}
				}
			forEach (units _x)
			}
		forEach _battery;

		if (_eta == -1) exitWith {_waitFor = false};

		_Xhd = _transspeed * (sin _transdir) * (_eta + _add);
		_Yhd = _transspeed * (cos _transdir) * (_eta + _add);

		_exPX = (_targetPos select 0) + _Xhd;
		_exPY = (_targetPos select 1) + _Yhd;

		_exPos = [_exPX,_exPY,getTerrainHeightASL [_exPX,_exPY]];

		_exDst = _targetPos distance _exPos;

		if (isNil ("RydART_Safe")) then {_safebase = 250} else {_safebase = RydART_Safe};

		_safe = _safebase * _RydAccf * (1 + overcast);

		_safecheck = true;

		if not (_onRoad) then
			{
				{
				if (([(_impactpos select 0) + _Xhd, (_impactpos select 1) + _Yhd] distance (vehicle (leader _x))) < _safe) exitWith
						{
						_Xhd = _Xhd/2;
						_Yhd = _Yhd/2
						}
				}
			forEach _friends;

				{
				if ([(_impactpos select 0) + _Xhd, (_impactpos select 1) + _Yhd] distance (vehicle (leader _x)) < _safe) exitWith {_safecheck = false};
				}
			forEach _friends;

			if not (_safecheck) then
				{
				_Xhd = _Xhd/2;
				_Yhd = _Yhd/2;
				_safecheck = true;
					{
					if ([(_impactpos select 0) + _Xhd, (_impactpos select 1) + _Yhd] distance (vehicle (leader _x)) < _safe) exitWith {_safecheck = false};
					}
				forEach _friends;
				if not (_safecheck) then
					{
					_Xhd = _Xhd/5;
					_Yhd = _Yhd/5;
					_safecheck = true;
						{
						if ([(_impactpos select 0) + _Xhd, (_impactpos select 1) + _Yhd] distance (vehicle (leader _x)) < _safe) exitWith {_safecheck = false};
						}
					forEach _friends
					}
				};

			_impactpos = [(_targetpos select 0) + _Xhd, (_targetpos select 1) + _Yhd];
			}
		else
			{
			if not (_request) then {_nR = _targlead nearRoads 30} else {_nR = _target nearRoads 30};

			_stRS = _nR select 0;
			_dMin = _stRS distance _exPos;

				{
				_dAct = _x distance _exPos;
				if (_dAct < _dMin) then {_dMin = _dAct;_stRS = _x}
				}
			forEach _nR;

			_dSum = _assumedPos distance _stRS;
			_checkedRS = [_stRS];
			_actRS = _stRS;

			while {_dSum < _exDst} do
				{
				_RSArr = (roadsConnectedTo _actRS) - _checkedRS;
				if ((count _RSArr) == 0) exitWith {};
				_stRS = _RSArr select 0;
				_dMin = _stRS distance _exPos;

					{
					_dAct = _x distance _exPos;
					if (_dAct < _dMin) then {_dMin = _dAct;_stRS = _x}
					}
				forEach _RSArr;

				_dSum = _dSum + (_stRS distance _actRS);

				_actRS = _stRS;

				_checkedRS pushBack _stRS;
				};

			if (_dSum < _exDst) then
				{
				//if (_transdir < 0) then {_transdir = _transdir + 360};
				_angle = [_targetPos,(getPosASL _stRS),1] call RYD_AngTowards;
				_impactPos = [(getPosASL _stRS),_angle,(_exDst - _dSum)] call RYD_PosTowards2D
				}
			else
				{
				_rPos = getPosASL _stRS;
				_impactPos = [_rPos select 0,_rPos select 1]
				};

				{
				if ((_impactpos distance (vehicle (leader _x))) < _safe) exitWith
					{
					_safeCheck = false;
					_impactpos = [((_impactpos select 0) + (_targetPos select 0))/2,((_impactpos select 1) + (_targetPos select 1))/2]
					}
				}
			forEach _friends
			};

		if not (_safeCheck) then
			{
			_safeCheck = true;

				{
				if ((_impactpos distance (vehicle (leader _x))) < _safe) exitWith
					{
					_safeCheck = false
					}
				}
			forEach _friends
			};

		if not (_request) then {if not (_safecheck) exitWith {(group _target) setVariable ["CFF_Taken",false]}};

		_distance2 = _impactPos distance (getPosATL (vehicle _batlead1));
		_DweatherF = 1 + overcast;
		_gauss09 = (random 0.09) + (random 0.09) + (random 0.09) + (random 0.09) + (random 0.09) + (random 0.09) + (random 0.09) + (random 0.09) +  (random 0.09) + (random 0.09);

		//_gauss1 = (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) +  (random 0.1) + (random 0.1);
		//_gauss04 = (random 0.04) + (random 0.04) + (random 0.04) + (random 0.04) + (random 0.04) + (random 0.04) + (random 0.04) + (random 0.04) +  (random 0.04) + (random 0.04);
		//_gauss2 = (random 0.2) + (random 0.2) + (random 0.2) + (random 0.2) + (random 0.2) + (random 0.2) + (random 0.2) + (random 0.2) +  (random 0.2) + (random 0.2);
		//_DdistF = (_distance2/10) * (0.1 + _gauss04);
		//_DdamageF = 1 + 0.5 * (damage _batlead1);
		//_DskillF = 2 * (skill _batlead1);
		//_anotherD = 1 + _gauss1;
		//_Dreduct = (1 + _gauss2) + _DskillF;

		//_spawndisp = _dispF * ((_RydAccf * _DdistF * _DdamageF) + (50 * _DweatherF * _anotherD)) / _Dreduct;
		//_dispersion = 10000 * (_spawndisp atan2 _distance2) / 57.3;

		//_disp = _dispersion;
		//if (isNil ("RydART_SpawnM")) then {_disp = _dispersion} else {_disp = _spawndisp};

		//[_battery,_disp] call BIS_ARTY_F_SetDispersion;

		_RydAccF = 1;

		_gauss1b = (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) +  (random 0.1) + (random 0.1);
		_gauss2b = (random 0.2) + (random 0.2) + (random 0.2) + (random 0.2) + (random 0.2) + (random 0.2) + (random 0.2) + (random 0.2) +  (random 0.2) + (random 0.2);
		_AdistF = (_distance2/15) * (0.1 + _gauss09);
		_AweatherF = _DweatherF;
		_AdamageF = 1 + 0.1 * (damage (vehicle _batlead1));
		_AskillF = 5 * (_batlead1 skill "aimingAccuracy");
		_Areduct = (1 + _gauss2b) + _AskillF;
		_spotterF = 0.2 + (random 0.2);
		_anotherA = 1 + _gauss1b;
		if not (isNil ("RydART_FOAccGain")) then {_spotterF = RydART_FOAccGain + (random 0.2)};
		if (((count _phaseF) == 2) and (_x == 1) or ((count _phaseF) == 1)) then {_spotterF = 1};

		_acc = 0.4 * _spotterF * _againF * _accF * ((_AdistF * _AdamageF) + (50 * _AweatherF * _anotherA)) / _Areduct;

		_finalimpact = [(_impactpos select 0) + (random (2 * _acc)) - _acc,(_impactpos select 1) + (random (2 * _acc)) - _acc];
		if not (_request) then {
			if not (isNull _myFO) then
				{
				_assumedPos = _myFO getHideFrom _target;
				};

			if (isNull _target) exitWith {_waitFor = false};
			if not (alive _target) exitWith {_waitFor = false};
		};

		if (({not (isNull _x)} count _batlead) < 1) exitWith {_waitFor = false};
		if (isNull _battery1) exitWith {_waitFor = false};
		if (({(alive _x)} count _batlead) < 1)  exitWith {_waitFor = false};

		if not (_request) then {if ((abs (speed _target)) > 50) exitWith {_waitFor = false}};
		if ((_assumedPos select 2) > 20)  exitWith {_waitFor = false};

		//_dstAct = _impactpos distance _batlead;

			{
			if not (isNull _x) then
				{
					{
					(vehicle _x) setVariable ["RydHQ_ShotFired",false]
					}
				forEach (units _x)
				};
			}
		forEach _battery;

		sleep 0.2;
		_posX = 0;
		_posY = 0;

		_distance = _impactPos distance _finalimpact;

		(_battery select 0) setVariable ["RydHQ_Break",false];

		if not (_Debug) then
			{
			_Debug = RYD_WS_ArtyMarks
			};

		if (_Debug) then
			{
			_posM1 = getPosATL (vehicle _batlead1);
			_posM1 set [2,0];
			_impactPosM = +_impactPos;
			_impactPosM set [2,0];
			_finalimpactM = +_finalimpact;
			_finalimpactM set [2,0];

			_text = getText (configFile >> "CfgVehicles" >> (typeOf (vehicle _batlead1)) >> "displayName");
			_i = "markBat" + str (_battery1);
			_i = createMarker [_i,_posM1];
			_i setMarkerColor "ColorBlack";
			_i setMarkerShape "ICON";
			_i setMarkerType "mil_circle";
			_i setMarkerSize [0.4,0.4];
			_i setMarkerText ("Firing battery - " + _text);

			_markers pushBack _i;

			_distance = _impactPosM distance _finalimpactM;
			_distance2 = _impactPosM distance _posM1;
			_i = "mark0" + str (_battery1);
			_i = createMarker [_i,_impactPos];
			_i setMarkerColor "ColorBlue";
			_i setMarkerShape "ELLIPSE";
			_i setMarkerSize [_distance, _distance];
			_i setMarkerBrush "Border";

			_markers pushBack _i;

			_dX = (_impactPosM select 0) - (_posM1 select 0);
			_dY = (_impactPosM select 1) - (_posM1 select 1);
			_angle = _dX atan2 _dY;
			if (_angle >= 180) then {_angle = _angle - 180};
			_dXb = (_distance2/2) * (sin _angle);
			_dYb = (_distance2/2) * (cos _angle);
			_posX = (_posM1 select 0) + _dXb;
			_posY = (_posM1 select 1) + _dYb;

			_i = "mark1" + str (_battery1);
			_i = createMarker [_i,[_posX,_posY]];
			_i setMarkerColor "ColorBlack";
			_i setMarkerShape "RECTANGLE";
			_i setMarkerSize [0.5,_distance2/2];
			_i setMarkerBrush "Solid";
			_i setMarkerDir _angle;

			_markers pushBack _i;

			_dX = (_finalimpactM select 0) - (_impactPosM select 0);
			_dY = (_finalimpactM select 1) - (_impactPosM select 1);
			_angle = _dX atan2 _dY;
			if (_angle >= 180) then {_angle = _angle - 180};
			_dXb = (_distance/2) * (sin _angle);
			_dYb = (_distance/2) * (cos _angle);
			_posX2 = (_impactPosM select 0) + _dXb;
			_posY2 = (_impactPosM select 1) + _dYb;

			_i = "mark2" + str (_battery1);
			_i = createMarker [_i,[_posX2,_posY2]];
			_i setMarkerColor "ColorBlack";
			_i setMarkerShape "RECTANGLE";
			_i setMarkerSize [0.5,_distance/2];
			_i setMarkerBrush "Solid";
			_i setMarkerDir _angle;

			_markers pushBack _i;

			_i = "mark3" + str (_battery1);
			_i = createMarker [_i,_impactPosM];
			_i setMarkerColor "ColorBlack";
			_i setMarkerShape "ICON";
			_i setMarkerType "mil_dot";

			_markers pushBack _i;

			_i = "mark4" + str (_battery1);
			_i = createMarker [_i,_finalimpactM];
			_i setMarkerColor "ColorRed";
			_i setMarkerShape "ICON";
			_i setMarkerType "mil_dot";
			_i setMarkerText (str (round _distance) + "m" + " - ETA: " + str (round _eta) + " - " + _ammoG);

			_markers pushBack _i;

			/*_i = "mark5" + str (_battery);
			_i = createMarker [_i,_finalimpactM];
			_i setMarkerColor "ColorRedAlpha";
			_i setMarkerShape "ELLIPSE";
			_i setMarkerSize [_spawndisp,_spawndisp];*/
			};

		_code =
			{
			_SCRname = "ArtyETA";

			private ["_mark","_battery","_distance","_eta","_Ammo","_target","_alive","_stoper","_TOF","_batlead"];

			_battery = _this select 0;
			_distance = _this select 1;
			_eta = _this select 2;
			_ammoG = _this select 3;
			_batlead = _this select 4;
			_target = _this select 5;
			_markers = _this select 6;
			_request = false;
			if ((count _this) > 7) then {_request = _this select 7};

			_battery1 = _battery select 0;

			_alive = true;
			_shot = false;

			waitUntil
				{
				sleep 0.1;
				if (({not (isNull _x)} count _batlead) < 1) then {_alive = false};
				if (isNull _battery1) then {_alive = false};
				if (({(alive _x)} count _batlead) < 1) then {_alive = false};
				if (_battery1 getVariable ["RydHQ_Break",false]) then {_alive = false};

					{
					if not (isNull _x) then
						{
							{
							if ((vehicle _x) getVariable ["RydHQ_ShotFired",false]) exitWith {_shot = true}
							}
						forEach (units _x)
						};

					if (_shot) exitWith {}
					}
				forEach _battery;

				((_shot) or not (_alive))
				};

				{
				if not (isNull _x) then
					{
						{
						(vehicle _x) setVariable ["RydHQ_ShotFired",false]
						}
					forEach (units _x)
					};
				}
			forEach _battery;

			_stoper = time;
			_TOF = 0;
			_rEta = _eta;
			_mark = "";

			if ((count _markers) > 0) then
				{
				_mark = _markers select ((count _markers) -1);
				};

			while {(not (_rEta < 5) and not (_TOF > 200) and (_alive))} do
				{
				if (({not (isNull _x)} count _batlead) < 1) exitWith {_alive = false};
				if (isNull _battery1) exitWith {_alive = false};
				if (({(alive _x)} count _batlead) < 1) exitWith {_alive = false};
				if (_battery1 getVariable ["RydHQ_Break",false]) exitWith {_alive = false};

				_TOF = (round (10 * (time - _stoper)))/10;
				_rEta = _eta - _TOF;

				if ((count _markers) > 0) then
					{
					_mark setMarkerText (str (round _distance) + "m" + " - ETA: " + str (round _rEta) + " - TOF: " + (str _TOF) + " - " + _ammoG);
					};

				sleep 0.1
				};

			if not (_alive) exitWith
				{
				if not (_request) then {(group _target) setVariable ["CFF_Taken",false]};

					{
					deleteMarker _x;
					}
				forEach _markers;
				};

			_battery1 setVariable ["RydHQ_SPLASH",true];

			if ((count _markers) > 0) then
				{
				_mark setMarkerText (str (round _distance) + "m"  + " - SPLASH!" + " - " + _ammoG);
				};
			};

		[[_battery,_distance,_eta,_ammoG,_batlead,_target,_markers,_request],_code] call RYD_Spawn;

		_eta = [_battery,_finalimpact,_ammo,_amount] call RYD_CFF_Fire;

		_UL = _batlead1;

		if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_ArtFire,"ArtFire"] call RYD_AIChatter};

		_alive = (_eta > 0);

		if not (_alive) then {(_battery select 0) setVariable ["RydHQ_Break",true]};

		_stoper = time;

		waitUntil
			{
			sleep 1;

			_available = true;

			switch (true) do
				{
				case (({not (isNull _x)} count _batlead) < 1) : {_alive = false};
				case (isNull _battery1) : {_alive = false};
				case (({(alive _x)} count _batlead) < 1) : {_alive = false};
				case ((time - _stoper) > 120) : {_alive = false};
				};

				{
				if not (isNull _x) then
					{
						{
						if not ((vehicle _x) getVariable ["RydHQ_GunFree",true]) exitWith {_available = false}
						}
					forEach (units _x)
					};

				if not (_available) exitWith {}
				}
			forEach _battery;

			((_available) or not (_alive))
			};

		if not (_alive) exitWith {_waitFor = false};

		if (((count _phaseF) == 2) and (_x == 1)) then
			{
			_alive = true;
			_splash = false;
			_stoper = time;

			waitUntil
				{
				sleep 1;

				switch (true) do
					{
					case (({not (isNull _x)} count _batlead) < 1) : {_alive = false};
					case (isNull _battery1) : {_alive = false};
					case (({(alive _x)} count _batlead) < 1) : {_alive = false};
					case ((time - _stoper) > 240) : {_alive = false};
					};

				if not (isNull _battery1) then {_splash = _battery1 getVariable ["RydHQ_SPLASH",false]};

				((_splash) or not (_alive))
				};

			if not (isNull _battery1) then {_battery1 setVariable ["RydHQ_SPLASH",false]};

			sleep 10;

				{
				deleteMarker _x;
				}
			forEach _markers
			};

		if not (_alive) exitWith {_waitFor = false};
		}
	forEach _phaseF;

	_battery1 setVariable [("CFF_Trg" + _batname),_target];

	_alive = true;
	_splash = false;
	_stoper = time;

	if (_waitFor) then
		{
		waitUntil
			{
			sleep 1;

			switch (true) do
				{
				case (({not (isNull _x)} count _batlead) < 1) : {_alive = false};
				case (isNull _battery1) : {_alive = false};
				case (({(alive _x)} count _batlead) < 1) : {_alive = false};
				case ((time - _stoper) > 240) : {_alive = false};
				};

			if not (isNull _battery1) then {_splash = _battery1 getVariable ["RydHQ_SPLASH",false]};

			((_splash) or not (_alive))
			};

		if not (isNull _battery1) then {_battery1 setVariable ["RydHQ_SPLASH",false]};

		sleep 10
		};

		{
		deleteMarker _x;
		}
	forEach _markers;

	if not (_request) then {(group _target) setVariable ["CFF_Taken",false]};

	_alive = true;
	_stoper = time;

	waitUntil
		{
		sleep 1;

		_available = true;

		switch (true) do
			{
			case (({not (isNull _x)} count _batlead) < 1) : {_alive = false};
			case (({(alive _x)} count _batlead) < 1) : {_alive = false};
			case ((time - _stoper) > 240) : {_alive = false};
			};

			{
			if not (isNull _x) then
				{
					{
					if not ((vehicle _x) getVariable ["RydHQ_GunFree",true]) exitWith {_available = false}
					}
				forEach (units _x)
				};

			if not (_available) exitWith {}
			}
		forEach _battery;

		((_available) or not (_alive))
		};

	//if not (_alive) exitWith {};

		{
		if not (isNull _x) then
			{
			_x setVariable ["RydHQ_BatteryBusy",false]
			}
		}
	forEach _battery
	};

RYD_CFF =
	{//[RydHQ_ArtG,RydHQ_KnEnemies,(RydHQ_EnHArmor + RydHQ_EnMArmor + RydHQ_EnLArmor),RydHQ_Friends,RydHQ_Debug] call RYD_CFF;
	_SCRname = "CFF";
	private ["_amnt","_artG","_knEnemies","_enArmor","_friends","_Debug","_CFFMissions","_tgt","_ammo","_bArr","_possible","_UL","_ldr","_amount","_fr"];

	_artG = _this select 0;
	_knEnemies = _this select 1;
	_enArmor = _this select 2;
	_friends = _this select 3;
	_Debug = _this select 4;
	_ldr = _this select 5;

	_fr = (group _ldr) getVariable ["RydHQ_Front",locationNull];
	if not (isNull _fr) then {
		_knEnemies = [_knEnemies, [], {_ldr distance (vehicle _x) }, "ASCEND",{((getPosATL (vehicle _x)) in _fr)}] call BIS_fnc_sortBy;
	};

	_amount = RydART_Amount;

	_CFFMissions = ceil (random (count _artG));

	for "_i" from 1 to _CFFMissions do
		{
		_tgt = [_knEnemies] call RYD_CFF_TGT;
		if not (isNull _tgt) then
			{
			_ammo = "HE";
			_amnt = _amount;
			if ((random 100) > 85) then {_ammo = "SPECIAL";_amnt = (ceil (_amount/3))};
			//if (_tgt in _enArmor) then {_ammo = "HE";_amnt = 6};

			_bArr = [(getPosATL _tgt),_artG,_ammo,_amnt,objNull] call RYD_ArtyMission;
			_possible = _bArr select 0;

			//_UL = leader (_friends select (floor (random (count _friends))));
			_UL = _tgt getVariable ["RydHQ_MyFO",leader (_friends select (floor (random (count _friends))))];

			if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_ArtyReq,"ArtyReq"] call RYD_AIChatter}};

			if (_possible) then
				{
					{
					if not (isNull _x) then
						{
						_x setVariable ["RydHQ_BatteryBusy",true]
						}
					}
				forEach (_bArr select 1);
				if ((random 100) < RydxHQ_AIChatDensity) then {[_ldr,RydxHQ_AIC_ArtAss,"ArtAss"] call RYD_AIChatter};
				//[_bArr select 1,_tgt,_bArr select 2,_bArr select 3,_friends,_Debug,_ammo,_amnt] spawn RYD_CFF_FFE

				[[_bArr select 1,_tgt,_bArr select 2,_bArr select 3,_friends,_Debug,_ammo,_amnt min (_bArr select 4)],RYD_CFF_FFE] call RYD_Spawn;
				}
			else
				{
				switch (true) do
					{
					case (_ammo in ["SPECIAL","SECONDARY"]) : {_ammo = "HE";_amnt = _amount};
					case (_ammo in ["HE"]) : {_ammo = "SECONDARY";_amnt = _amount};
					};

				_bArr = [(getPosATL _tgt),_artG,_ammo,_amnt,objNull] call RYD_ArtyMission;

				_possible = _bArr select 0;
				if (_possible) then
					{
						{
						if not (isNull _x) then
							{
							_x setVariable ["RydHQ_BatteryBusy",true]
							}
						}
					forEach (_bArr select 1);
					if ((random 100) < RydxHQ_AIChatDensity) then {[_ldr,RydxHQ_AIC_ArtAss,"ArtAss"] call RYD_AIChatter};
					//[_bArr select 1,_tgt,_bArr select 2,_bArr select 3,_friends,_Debug,_ammo,_amnt] spawn RYD_CFF_FFE

					[[_bArr select 1,_tgt,_bArr select 2,_bArr select 3,_friends,_Debug,_ammo,_amnt min (_bArr select 4)],RYD_CFF_FFE] call RYD_Spawn;
					}
				else
					{
					if ((random 100) < RydxHQ_AIChatDensity) then {[_ldr,RydxHQ_AIC_ArtDen,"ArtDen"] call RYD_AIChatter}
					}
				}
			};

		sleep (5 + (random 5));
		};
	};

RYD_WPSync =
	{
	private ["_trg","_otherWP","_group","_pos","_uPos","_gps","_timer","_endThis"];

	_group = _this select 2;
	_trg = group (_this select 1);

	if (isNull _trg) exitWith {};

	_otherWP = _trg getVariable ["RYD_Attacks",[]];

	_gps = [];
	_positions = [];

		{
		_gps pushBack (_x select 0);
		_positions pushBack (_x select 1);
		}
	forEach _otherWP;

	_markT = markerText _i;

	_timer = time;
	_endThis = false;

	waitUntil
		{
		sleep 5;

		switch (true) do
			{
			case (isNull _group): {_endThis = true};
			case ((({alive _x} count (units _group)) < 1)): {_endThis = true};
			case (_unitG getVariable ["Break",false]) : {_endThis = true; _unitG setVariable ["Break",false];};
			case ((_group getVariable [("Resting" + (str _group)),false]) or {(_group getVariable ["RydHQ_MIA",false])}): {_endThis = true};
			case ((fleeing (leader _group)) or {(captive (leader _group))}): {_endThis = true};
			};

		if not (_endThis) then
			{
			_endThis = true;

				{
				_pos = _positions select _foreachIndex;
				_uPos = position (vehicle (leader _x));

				if (((_pos distance2D _uPos) > 40) and {not (_pos isEqualTo [0,0,0])}) exitWith {_endThis = false};
				}
			forEach _gps
			};

		if (_HQ getVariable ["RydHQ_Debug",false]) then
			{
			_i setMarkerText (_markT + "sync: " + (str (round (time - _timer))))
			};

		((_endThis) or {(time - _timer) > 1800})
		};

	if (_HQ getVariable ["RydHQ_Debug",false]) then
		{
		_i setMarkerText _markT
		};

	_trg setVariable ["RYD_Attacks",[]];
	};

RYD_DbgMon =
	{
	_SCRname = "DbgMon";

	private ["_txtArr","_dbgMon","_txt"];

	if (RydBB_Active) then
		{
		waitUntil
			{
			sleep 1;
			not (isNil "RydBB_mapReady")
			}
		};

	_txtArr = [];

	while {((RydHQ_Debug) or (RydHQB_Debug) or (RydHQC_Debug) or (RydHQD_Debug) or (RydHQE_Debug) or (RydHQF_Debug) or (RydHQG_Debug) or (RydHQH_Debug))} do
		{
		if (({(_x getVariable ["RydHQ_KIA",false])} count RydxHQ_AllHQ) == (count RydxHQ_AllHQ)) exitWith {};
		_txtArr = [];

			{
			if not (isNil "_x") then
				{
				if not (isNull _x) then
					{
					if not (_x getVariable ["RydHQ_KIA",false]) then
						{
						_dbgMon = _x getVariable "DbgMon";
						if not (isNil "_dbgMon") then
							{
							_txtArr pushBack _dbgMon;
							_txtArr pushBack lineBreak;
							}
						}
					}
				}
			}
		forEach RydxHQ_AllHQ;

		if ((count _txtArr) > 0) then
			{
			_txt = composeText _txtArr;

			hintSilent _txt
			};

		sleep 15
		};
	};

RYD_LZ =
	{
	private ["_pos","_lz","_rds","_isFlat","_posX","_posY"];

	_pos = _this select 0;

	_posX = -1;
	_posY = -1;
	_rds = 50;

	_lz = objNull;

	_isFlat = [];

	while {_rds <= 400} do
		{
		_isFlat = _pos isFlatEmpty [20,_rds,1,15,0,false,objNull];

		if ((count _isFlat) > 1) exitWith
			{
			_posX = _isFlat select 0;
			_posY = _isFlat select 1;
			};

		_rds = _rds + 50;
		};

	if (_posX > 0) then
		{
		_lz = createVehicle ["Land_HelipadEmpty_F", [_posX,_posY,0], [], 0, "NONE"];
		//_i01 = [[_posX,_posY],str (random 100),"markLZ","ColorRed","ICON","mil_dot","LZ",""] call RYD_Mark
		};

	_lz
	};

RYD_TimeMachine =
	{
	private ["_units","_id"];

	_units = _this select 0;

		{
		_id = _x addAction ["Time: x2", (RYD_Path + "TimeM\TimeFaster.sqf"), "", -50, false, true, "", "(_this == _target)"];
		_id = _x addAction ["Time: x0.5", (RYD_Path + "TimeM\TimeSlower.sqf"), "", -60, false, true, "", "(_this == _target)"];
		_id = _x addAction ["Order pause enabled", (RYD_Path + "TimeM\EnOP.sqf"), "", -70, false, true, "", "(not RydHQ_GPauseActive) and (_this == _target)"];
		_id = _x addAction ["Order pause disabled", (RYD_Path + "TimeM\DisOP.sqf"), "", -80, false, true, "", "RydHQ_GPauseActive and (_this == _target)"];
		}
	forEach _units;

	true
	};

RYD_AddTask =
	{//[(leader _unitG),[],[_posX,_posY]] call RYD_AddTask;
	private ["_unit","_descr","_dstn","_type","_task","_tasks","_tName","_presentplayer"];

	_unit = _this select 0;
	_descr = _this select 1;
	_dstn = _this select 2;
	_type = _this select 3;

	if (isNil "_type") then {_type = "move"};

	_tasks = (group _unit) getVariable ["HACAddedTasks",[]];
	_task = taskNull;

	_presentplayer = true;

	/*
	{
		if (isPlayer _x) exitwith {_presentplayer = true};
	} forEach (units (group _unit));
	*/

	if (_presentplayer) then
		{

		(group _unit) setVariable ["HACAddedTasks",[]];

			{
			[_x] call BIS_fnc_deleteTask;
			}
		forEach _tasks;

		sleep 1;

		_task = [(group _unit),(str (group _unit)) + "HALTask", _descr, _dstn,"ASSIGNED",0,true,_type,true] call BIS_fnc_taskCreate;
		_tasks = [];

		_tasks pushBack _task;

		(group _unit) setVariable ["HACAddedTasks",_tasks];

		};

	_task
	};

RYD_FindHighestWithIndex =
	{
	private ["_array","_ix","_highest","_valMax","_valAct","_index","_clIndex"];

	_array = _this select 0;
	_ix = _this select 1;

	_highest = [];

	if ((count _array) > 0) then
		{
		_highest = _array select 0;
		_index = 0;
		_clIndex = 0;
		_valMax = _highest select _ix;

			{
			_valAct = _x select _ix;

			if (_valAct > _valMax) then
				{
				_highest = _x;
				_valMax = _valAct;
				_clIndex = _index
				};

			_index = _index + 1
			}
		forEach _array
		};

	[_highest,_clIndex]
	};

RYD_ValueOrd =
	{
	private ["_array","_final","_highest","_ix"];

	_array = +(_this select 0);

	_final = [];

	while {((count _array) > 0)} do
		{
		_highest = [_array,3] call RYD_FindHighestWithIndex;
		_ix = _highest select 1;
		_highest = _highest select 0;

		_final pushBack _highest;

		_array deleteAt _ix;
		};

	_final
	};

RYD_FindOverwatchPos =
	{
	private ["_pos","_tgtPos","_radius","_dir","_posASL","_tgtPosASL","_pool","_posX","_posY","_posX2","_posY2","_pool2","_isBlock","_pool3","_elevImp","_terrImp","_terr","_elev","_final","_value",
	"_urban","_forest","_group","_dst","_vh"];

	_pos = _this select 0;//ATL
	_tgtPos = _this select 1;//ATL
	_tgtPos = [_tgtPos select 0,_tgtPos select 1,1.5];
	_radius = _this select 2;
	_elevImp = 1;
	if ((count _this) > 3) then {_elevImp = _this select 3};
	_terrImp = 1;
	if ((count _this) > 4) then {_terrImp = _this select 4};
	_group = grpNull;
	if ((count _this) > 5) then {_group = _this select 5};
	_vh = vehicle (leader _group);

	_tgtPosASL = [_tgtPos select 0,_tgtPos select 1,getTerrainHeightASL [_tgtPos select 0,_tgtPos select 1] + 1.5];

	_pool = [];

	_posX = _pos select 0;
	_posY = _pos select 1;

	for "_i" from 1 to 100 do
		{
		_posX2 = _posX + (random (2 * _radius)) - _radius;
		_posY2 = _posY + (random (2 * _radius)) - _radius;

		if not (surfaceIsWater [_posX2,_posY2]) then {_pool pushBack [_posX2,_posY2,1]}
		};

	_pool2 = [];

		{
		_isBlock = terrainIntersect [_x, _tgtPos];
		if not (_isBlock) then
			{
			_pool2 pushBack _x
			}
		}
	forEach _pool;

	if ((count _pool2) == 0) then {_pool2 = _pool};

	_pool3 = [];

		{
		_isBlock = lineIntersects [[_x select 0,_x select 1,getTerrainHeightASL [_x select 0,_x select 1] + 1], _tgtPosASL];
		if not (_isBlock) then
			{
			_pool3 pushBack _x
			}
		}
	forEach _pool2;

	if ((count _pool3) == 0) then {_pool3 = _pool2};

		{
		_value = [_x,1,1] call RYD_TerraCognita;
		_urban = _value select 0;
		_forest = _value select 1;

		_terr = (_urban + _forest) * 100;

		_posX = _x select 0;
		_posY = _x select 1;
		_elev = getTerrainHeightASL [_posX,_posY];
		_dst = 0;
		if not (isNull _group) then
			{
			_dst = ([_posX,_posY] distance _vh)/1000
			};

		_x pushBack ((_terr * _terrImp) + (_elev * _elevImp))/(1 + _dst)
		}
	forEach _pool3;

	_pool3 = [_pool3] call RYD_ValueOrd;

	_final = [];

		{
		_final pushBack [_x select 0,_x select 1]
		}
	forEach _pool3;

	_final
	};

RYD_KeepAlt =
	{
	private ["_veh","_alt","_keep"];

	_veh = _this select 0;
	_alt = _this select 1;

	_keep = true;

	while {_keep} do
		{
		sleep 0.1;
		if (isNull _veh) exitWith {};
		if not (alive _veh) exitWith {};
		_keep = _veh getVariable ["KeepAlt",true];
		_veh flyInHeight _alt
		};

	_veh setVariable ["KeepAlt",nil]
	};

RYD_AmmoDrop =
	{
	private ["_cargo","_ammoBox","_spawnPos","_parachute","_parachutePos","_height1","_height2","_height3","_speed","_dir","_vel","_pos","_off","_type","_benef","_backLimit"];

	_cargo = _this select 0;
	_ammoBox = _this select 1;
	_benef = _this select 2;
	_type = typeOf _ammoBox;

	_dir = getDir _cargo;

	_backLimit = (((boundingBoxReal _cargo) select 0) select 1);

	_parachutePos = _cargo modelToWorld [0,(_backLimit - 2),-2];

	_parachute = createVehicle ["B_Parachute_02_F", [_parachutePos select 0,_parachutePos select 1,2000], [], 0.5, "NONE"];
	_parachute setPos _parachutePos;
	_parachute setDir _dir;

	_vel = velocity _cargo;

	_parachute setVelocity [(_vel select 0)/2,(_vel select 1)/2,(_vel select 2)/2];

	_ammoBox setDir _dir;

	_ammoBox attachTo [_parachute,[0,0,0]];

	_ammoBox enableSimulationGlobal true;
	_ammoBox hideObjectGlobal false;

	sleep 2;

	waitUntil
		{
		_height1 = (getPosATL _ammoBox) select 2;
		sleep 0.005;
		_height2 = (getPosATL _ammoBox) select 2;
		_speed = abs ((velocity _ammoBox) select 2);
		if (_height2 > _height1) then {_parachute setVelocity [0,0,-20]};
		sleep 0.005;
		_height3 = (getPosATL _ammoBox) select 2;

		((_height2 < 0.05) or {(_height2 < 2) and {(_height3 > _height2) or {(_speed < 0.001) or {(isNull _parachute)}}}})
		};

	detach _ammoBox;

	_pos = getPosATL _ammoBox;

	//deleteVehicle _ammoBox;

	//_ammoBox = createVehicle [_type, _pos, [], 0, "NONE"];

	_off = _ammoBox modelToWorld [0,0,0] select 2;
	if (_off < 2) then
		{
		_ammoBox setPos [_pos select 0,_pos select 1,0];
		}
	else
		{
		_off = getPos _ammoBox select 2;
		_ammoBox setPosATL [_pos select 0,_pos select 1,(_pos select 2)-_off];
		};

	_benef setVariable ["isBoxed",_ammoBox];

	if not (isNull _parachute) then
		{
		_parachute setVelocity [0,0,0]
		};

	sleep 5;

	if not (isNull _parachute) then
		{
		deleteVehicle _parachute
		}
	};

RYD_ResetAI =
	{
	private ["_group","_All","_unit","_pos","_posX","_posY","_type","_muzzles"];

	_group = _this select 0;
	_All = units _group;

		{
		_unit = _x;
		_pos = getPosATL _unit;

		_posX = _pos select 0;
		_posY = _pos select 1;

		_posX = _posX + (random 0.25) - 0.125;
		_posY = _posY + (random 0.25) - 0.125;

		_unit setPos [_posX,_posY,1];

		sleep 0.05;

		_unit doMove [_posX,_posY,0];

		sleep 0.05;

		_unit setDir (getDir player);

		sleep 0.05;

		_unit forceSpeed -1;

		sleep 0.05;

		if ((count (weapons _unit)) > 0) then
			{
			private["_type", "_muzzles"];

			_type = (weapons _unit) select 0;
			_muzzles = getArray(configFile >> "cfgWeapons" >> _type >> "muzzles");

			if (count _muzzles > 1) then
				{
				_unit selectWeapon (_muzzles select 0);
				}
			else
				{
				_unit selectWeapon _type
				}
			}
		}
	forEach _All;

	sleep 0.5;

		{
		_x doWatch objNull;
		sleep 0.05;
		_x doTarget objNull;
		sleep 0.05;
		_x enableReload false;
		sleep 0.05;
		_x stop true;
		sleep 0.05;
		_x setUnitPos "UP";
		sleep 0.05
		}
	forEach _All;

	sleep 0.5;

		{
		_x switchMove "";
		sleep 0.05;
		_x disableAI "TARGET";
		sleep 0.05;
		_x disableAI "AUTOTARGET";
		sleep 0.05;
		_x disableAI "MOVE";
		sleep 0.05;
		_x disableAI "FSM";
		sleep 0.05;
		_x disableAI "ANIM";
		sleep 0.05
		}
	forEach _All;

	sleep 5;

		{
		_x setUnitPos "AUTO";
		sleep 0.05;
		_x enableAI "TARGET";
		sleep 0.05;
		_x enableAI "AUTOTARGET";
		sleep 0.05;
		_x enableAI "MOVE";
		sleep 0.05;
		_x enableAI "FSM";
		sleep 0.05;
		_x enableAI "ANIM";
		sleep 0.05;
		_x stop false;
		sleep 0.05;
		_x enableReload true;
		sleep 0.05
		}
	forEach _All;
	};

RYD_FireCount =
	{
	private ["_unit","_count","_fEH"];

	_unit = _this select 0;

	_count = _unit getVariable "FireCount";
	if (isNil "_count") then {_count = 0};

	if (_count >= 2) exitWith
		{
		_fEH = _unit getVariable "HAC_FEH";
		if not (isNil "_fEH") then
			{
			_unit removeEventHandler ["Fired",_fEH];
			_unit setVariable ["HAC_FEH",nil]
			}
		};

	_unit setVariable ["FireCount",_count + 1]
	};

RYD_HQChatter =
	{//if (RydxHQ_HQChat) then {[_unitG,"HQ_ord_attack",_pos,_HQ] call RYD_HQChatter};
	private ["_group","_sentence","_pos","_HQ","_unit","_comm","_who","_where","_nL"];

	_group = _this select 0;
	_sentence = _this select 1;
	_pos = +(_this select 2);
	_HQ = _this select 3;

	_unit = leader _group;
	_comm = leader _HQ;

	switch (missionNamespace getVariable ["RydxHQ_AIChat_Type" ,"NONE"]) do
		{
		case ("SILENT_M") : {_sentence = "HAC_SILENTM_" + _sentence};
		case ("40K_IMPERIUM") : {_sentence = "HAC_40KImp_" + _sentence};
		};


	_sentence = getText (configFile >> "CfgRadio" >> _sentence >> "title");
	_who = toUpper (getText (configFile >> "CfgVehicles" >> (typeOf (vehicle _unit)) >> "displayName"));

	_who = groupId _group ;

	_where = "";

	_nL = nearestLocations [_pos, ["Hill","NameCityCapital","NameCity","NameVillage","NameLocal","Strategic","StrongpointArea"], 600];

	if ((count _nL) > 0) then
		{
		_nL = _nL select 0;
		_where = (text _nL) + ", ";
		};

	_where = _where + (format ["Grid: %1",mapGridPosition _pos]);

	_sentence = format ["%1. %2 at %3.",_who,_sentence,_where];


	if not (isMultiplayer) then {

		_comm sideChat _sentence
	}
	else
	{
//		[[_comm,_sentence],"RYD_MP_Sidechat",true,false,true] call BIS _fnc_MP;
		[_comm,_sentence] remoteExecCall ["sideChat"];
	};
	};

RYD_OrderPause =
	{
	private ["_unitG","_pos","_sentence","_HQ","_pause","_lastOrd"];

	_unitG = _this select 0;
	_pos = _this select 1;

	if ((typeName _pos) in [(typeName objNull),(typeName locationNull)]) then {_pos = position _pos};

	_pos set [2,0];

	_sentence = _this select 2;
	_HQ = _this select 3;

	_pause = 3 + (random 1.5);

	waitUntil
		{
		sleep 0.1;

		_lastOrd = _HQ getVariable ["RydHQ_MyLastOrder",0];

		((time - _lastOrd) > _pause)
		};

	_HQ setVariable ["RydHQ_MyLastOrder",time];

	if (RydxHQ_HQChat) then
		{
		[_unitG,_sentence,_pos,_HQ] call RYD_HQChatter
		};

	true
	};

RYD_AIChatter =
	{
	//if (isMultiPlayer) exitWith {};

	private ["_unit","_group","_lastComm","_sentences","_side","_lastTime","_varName","_sentence","_kind","_lastKind","_exitNow","_chatRep","_repExChance","_ct","_units","_color","_type","_code","_who"];

	_unit = _this select 0;

	_group = group _unit;

	_lastComm = _group getVariable "HAC_LastComm";
	if (isNil "_lastComm") then {_lastComm = -5};
	if ((time - _lastComm) < 5) exitWith {};

	_sentences = _this select 1;
	_side = side _unit;

	if (({(((side _x) == _side) and (isPlayer _x))} count allUnits) < 1) exitWith {};


	_group setVariable ["HAC_LastComm",time];

	_kind = _this select 2;


	switch (missionNamespace getVariable ["RydxHQ_AIChat_Type" ,"NONE"]) do
		{
		case ("SILENT_M") : {_sentences = (call compile ("RydxHQ_AIC_SILENTM_" + _kind))};
		case ("40K_IMPERIUM") : {_sentences = (call compile ("RydxHQ_AIC_40KImp_" + _kind))};
		};

	_varName = "_West";

	switch (_side) do
		{
		case (east) : {_varName = "_East"};
		case (resistance) : {_varName = "_Guer"};
		};

	_lastTime = missionNamespace getVariable ["HAC_AIChatLT" + _varName,[0,""]];
	_lastKind = _lastTime select 1;
	_lastTime = _lastTime select 0;

	if ((time - _lastTime) < 5) then {sleep 2};

	_lastTime = missionNamespace getVariable ["HAC_AIChatLT" + _varName,[0,""]];
	_lastKind = _lastTime select 1;
	_lastTime = _lastTime select 0;

	if ((time - _lastTime) < 5) then {sleep 2};

	_lastTime = missionNamespace getVariable ["HAC_AIChatLT" + _varName,[0,""]];
	_lastKind = _lastTime select 1;
	_lastTime = _lastTime select 0;

	if ((time - _lastTime) < 5) exitWith {};

	_exitNow = false;

	_chatRep = 0;

	if (_lastKind in [_kind]) then
		{
		_chatRep = missionNamespace getVariable ["HAC_AIChatRep" + _varName,0];
		_repExChance = round (random 2);

		if (_chatRep >= _repExChance) then
			{
			if ((random 100) < (90 + _chatRep)) then
				{
				_exitNow = true
				}
			}
		};

	if (_exitNow) exitWith {};

	missionNamespace setVariable ["HAC_AIChatLT" + _varName,[_lastTime,_kind]];

	if (_lastKind in [_kind]) then
		{
		missionNamespace setVariable ["HAC_AIChatRep" + _varName,_chatRep + 1]
		};

	_sentence = selectRandom _sentences;


//	[[_unit,_sentence],"RYD_MP_SideRadio",true,false,true] call BIS _fnc_MP;
	[_unit,_sentence] remoteExecCall ["sideRadio"];



/*"OrdDen"
"OrdConf"
"OrdFinal"
"OrdEnd"
"ArtAss"
"ArtDen"
"ArtFire"
"ArtyReq"
"SmokeReq"
"IllumReq"
"SuppReq"
"SuppAss"
"SuppDen"
"MedReq"
"EnemySpot"
"InDanger"
"InFear"
"InPanic"
"OffStance"
"DefStance"*/

	if (RydHQ_ChatDebug) then
		{
		_color = "ColorGrey";
		_type = "mil_warning";

		if (_kind in ["ArtyReq","SmokeReq","IllumReq","SuppReq","MedReq"]) then {_type = "mil_unknown"};

		switch (true) do
			{
			case (_kind in ["OffStance","DefStance","OrdConf","OrdFinal","OrdEnd","ArtFire"]) :
				{
				_color = "Color4_FD_F"//light blue
				};

			case (_kind in ["SuppAss","ArtAss"]) :
				{
				_color = "Color2_FD_F"//light khaki
				};

			case (_kind in ["EnemySpot"]) :
				{
				_color = "Color1_FD_F"//light red
				};

			case (_kind in ["MedReq","SuppReq","ArtyReq","SmokeReq","IllumReq"]) :
				{
				_color = "Color3_FD_F"//light orange
				};

			case (_kind in ["ArtDen","SuppDen","OrdDen"]) :
				{
				_color = "ColorOrange"
				};

			case (_kind in ["InDanger","InFear","InPanic"]) :
				{
				_color = "ColorRed"
				};
			};

		_sentence = getText (configFile >> "CfgRadio" >> _sentence >> "title");

		_who = groupId (group _unit);


		_mark = [(getPosATL _unit),_unit,"markChatter" + (str (random 10)),_color,"ICON",_type, _who + " : " + _sentence,"",[0.5,0.5]] call RYD_Mark;

		_code =
			{
			_SCRname = "ChatMark";

			_mark = _this select 0;

			_alpha = 1;

			sleep 27.5;

			for "_i" from 1 to 20 do
				{
				_alpha = _alpha - 0.05;
				_mark setMarkerAlpha _alpha;

				sleep 0.1
				};

			deleteMarker _mark
			};

		[[_mark],_code] call RYD_Spawn;
		};

	missionNamespace setVariable ["HAC_AIChatLT" + _varName,[time,_kind]];
	};

RYD_MP_Sidechat =
	{
	private ["_unit","_sentence"];

	_unit = _this select 0;
	_sentence = _this select 1;
	_unit sideChat _sentence;

	true
	};

RYD_ReqTransport_Actions =
	{
	private ["_ChosenOne","_unitG","_GD","_actionID","_VActArr","_ActArr","_isAir"];

	_ChosenOne = _this select 0;
	_LeaderG = _this select 1;
	_GD = _this select 2;
	_isAir = false;
	if ((count _this) > 3) then {_isAir = _this select 3};


	_ActArr = (_LeaderG getVariable ["HAL_ReqTraActs",[]]);
	_VActArr = (_LeaderG getVariable ["HAL_ReqTraVActs",[]]);

	_actionID = _ChosenOne addAction ["Select New Transport Destination",
	{

	(_this select 1) onMapSingleClick "(group _this) setvariable ['HALReqDest',_pos,true]; _this onMapSingleClick ''; hint 'Destination Selected'";

	openMap true;

	hintC "You can now select the destination on your map. Only select the destination once everyone is aboard as this will order the departure of the vehicle. You can select a new destination at any time as long as the transport support was not terminated.";

	}
	,
	_GD,5,false,false,"","_target isEqualTo (vehicle _this)",15];

	_VActArr pushBack _actionID;

	_actionID = _ChosenOne addAction ["Transport Stealth Mode",
	{

	[(_this select 3),"STEALTH"] remoteExecCall ["setBehaviour",leader (_this select 3)];
	[(_this select 3),"GREEN"] remoteExecCall ["setCombatMode",leader (_this select 3)];

	}
	,
	_GD,5,false,false,"","_target isEqualTo (vehicle _this)",15];

	_VActArr pushBack _actionID;

	_actionID = _ChosenOne addAction ["Transport Normal Mode",
	{

	[(_this select 3),"CARELESS"] remoteExecCall ["setBehaviour",leader (_this select 3)];
	[(_this select 3),"YELLOW"] remoteExecCall ["setCombatMode",leader (_this select 3)];

	}
	,
	_GD,5,false,false,"","_target isEqualTo (vehicle _this)",15];

	_VActArr pushBack _actionID;

	_actionID = _LeaderG addAction ["Dismiss Transport Support [" + (groupId _GD) + "]",
	{

	(_this select 3) setVariable ['HALReqDone',true,true];

	(_this select 0) removeAction (_this select 2);

	}
	,
	_GD,-1.7,false,false,"","true",0.01];

	if (_isAir) then
		{

		_actionID = _LeaderG addAction ["Force Immediate Full-Stop Landing [" + (groupId _GD) + "]",
		{

		[(_this select 3), (currentWaypoint (_this select 3))] setWaypointPosition [getPosATL (vehicle (leader (_this select 3))),0];
		(vehicle (leader (_this select 3))) land 'land';

		}
		,
		_GD,-2,false,false,"","(_this distance ((group _this) getVariable ['AssignedCargo' + (str (group _this)),objNull])) < 250",0.01];

		_ActArr pushBack _actionID;
	};

	_LeaderG setVariable ["HAL_ReqTraActs",_ActArr,true];
	_LeaderG setVariable ["HAL_ReqTraVActs",_VActArr,true];

	true
	};

RYD_ReqLogistics_Actions =
	{
	private ["_ChosenOne","_Type","_actionID"];

	_ChosenOne = _this select 0;

	_Type = _this select 1;

	_actionID = _ChosenOne addAction ["Dismiss " + _Type + " Support [" + (groupId (group (_ChosenOne))) + "]",
	{

	(_this select 3) setVariable ["HAL_Requested",false,true];
	[(_this select 0)] remoteExecCall ["RYD_ReqLogisticsDelete_Actions"];

	}
	,
	_ChosenOne,5,false,false,"","true",15];

	_ChosenOne setVariable ["HAL_ReqTraAct",_actionID];

	true
	};

RYD_ReqLogisticsDelete_Actions =
	{
	private ["_ChosenOne","_actionID"];

	_ChosenOne = _this select 0;

	_actionID = _ChosenOne getVariable ["HAL_ReqTraAct",nil];

	if not (isNil "_actionID") then  {_ChosenOne removeAction _actionID};

	_ChosenOne setVariable ["HAL_ReqTraAct",nil];

	true
	};

RYD_MP_SideRadio =
	{
	private ["_unit","_sentence"];

	_unit = _this select 0;
	_sentence = _this select 1;
	_unit sideRadio _sentence;

	true
	};

RYD_MP_orderGetIn =
	{
	//Obsolete

	private ["_unit","_istrue"];

	_unit = _this select 0;
	_istrue = _this select 1;
	_unit orderGetIn _istrue;
	};

RYD_MP_unassignVehicle =
	{
	private ["_unit"];

	_unit = _this select 0;
	unassignVehicle _unit;
	};

RYD_MP_assignedVehicle =
	{

	//Obsolete from ExecCall delay

	private ["_unit","_vh"];

	_unit = _this select 0;
	[_unit] remoteExecCall ["RYD_MP_assignedVehicle2"];

	_vh = _unit getVariable ["AssVh",objNull];
	_unit setVariable ["AssVh",nil,true];

	_vh
	};

RYD_MP_assignedVehicle2 =
	{

	//Obsolete

	private ["_unit","_vh"];

	_unit = _this select 0;
	_vh = assignedVehicle _unit;
	_unit setVariable ["AssVh",_vh,true];
	};

RYD_FindBiggest =
	{
	private ["_array","_biggest","_valMax","_valAct","_index","_clIndex"];

	_array = _this select 0;

	_biggest = grpNull;

	if ((count _array) > 0) then
		{
		_biggest = _array select 0;
		_index = 0;
		_clIndex = 0;
		_valMax = count (units _biggest);

			{
			_valAct = count (units _x);

			if (_valAct > _valMax) then
				{
				_biggest = _x;
				_valMax = _valAct;
				_clIndex = _index
				};

			_index = _index + 1
			}
		forEach _array
		};

	[_biggest,_clIndex]
	};

RYD_SizeOrd =
	{
	private ["_array","_final","_highest","_ix"];

	_array = +(_this select 0);

	_final = [];

	while {((count _array) > 0)} do
		{
		_highest = [_array] call RYD_FindBiggest;
		_ix = _highest select 1;
		_highest = _highest select 0;

		if not (isNil "_highest") then
			{
			if not (isNull _highest) then
				{
				_final pushBack _highest;
				}
			};

		_array deleteAt _ix;
		};

	_final
	};

RYD_RandomOrd =
	{
	private ["_array","_final","_random","_select"];

	_array = _this select 0;

	_final = [];

	while {((count _array) > 0)} do
		{
		_select = floor (random (count _array));
		_random = _array select _select;

		if not (isNil "_random") then
			{
			if ((typeName _random) in [typeName grpNull]) then
				{
				if not (isNull _random) then
					{
					if (({alive _x} count (units _random)) > 0) then
						{
						_final pushBack _random;
						}
					}
				}
			};

		_array = _array - [_random]
		};

	_final
	};
/*
RYD_RandomOrdB =
	{
	private ["_array","_final","_random","_select"];

	_array = +(_this select 0);

	_final = [];

	while {((count _array) > 0)} do
		{
		_select = floor (random (count _array));
		_random = _array select _select;

		_final pushBack _random;

		_array deleteAt _select;
		};

	_final
	};
*/
RYD_NearestRoad =
	{
	private ["_pos","_radius","_roads","_chosen","_dist","_distC"];

	_pos = _this select 0;
	_radius = _this select 1;

	_chosen = objNull;

	_roads = _pos nearRoads _radius;

	if ((count _roads) > 0) then
		{
		_chosen = _roads select 0;
		_distC = (getPosATL _chosen) distance _pos;

			{
			_dist = (getPosATL _x) distance _pos;
			if (_dist <_distC) then {_chosen = _x;_distC = _dist}
			}
		forEach _roads
		};

	_chosen
	};

RYD_FlatLandNoRoad =
	{
	private ["_pos","_radius","_final","_isGood","_isFlat","_noRoad","_nR","_ct"];

	_pos = _this select 0;
	_radius = _this select 1;

	_final = +_pos;

	_isGood = true;

	_isFlat = _pos isFlatEmpty [5,_radius/2,2,5,0,false,objNull];
	if ((count _isFlat) <= 1) then
		{
		_isGood = false
		}
	else
		{
		_noRoad = true;
		_nR = [_pos,20] call RYD_NearestRoad;
		if (not (isNull _nR) or (isOnRoad _pos)) then
			{
			_isGood = false
			}
		};

	_ct = 0;
	while {not (_isGood)} do
		{
		_ct = _ct + 1;
		if (_ct > 30) exitWith {};
		_pos = [_pos,_radius] call RYD_RandomAround;

		_isGood = true;

		_isFlat = _pos isFlatEmpty [5,_radius/2,2,5,0,false,objNull];
		if ((count _isFlat) <= 1) then
			{
			_isGood = false
			}
		else
			{
			_noRoad = true;
			_nR = [_pos,20] call RYD_NearestRoad;
			if (not (isNull _nR) or (isOnRoad _pos)) then
				{
				_isGood = false
				}
			};
		};

	if (_isGood) then {_final = _pos};

	_final
	};

RYD_GoInside =
	{
	private ["_wp","_pos","_nHouses","_nHouse","_posAll","_posAct","_chosen","_enterable","_stat","_oldStat","_isRoof"];

	_wp = _this select 0;
	_pos = waypointPosition _wp;

	_posAll = [];
	_chosen = -1;

	_nHouses = _pos nearObjects ["House",100];

	_nHouse = objNull;

	if ((count _nHouses) > 0) then
		{
		_nHouse = _nHouses select (floor (random (count _nHouses)));
		_nHouses = _nHouses - [_nHouse];

		_enterable = true;
		if not (((_nHouse buildingPos 0) distance [0,0,0]) > 1) then {_enterable = false};

		if not (_enterable) then
			{
			while {((count _nHouses) > 0)} do
				{
				_nHouse = _nHouses select (floor (random (count _nHouses)));
				_nHouses = _nHouses - [_nHouse];

				_enterable = true;
				if not (((_nHouse buildingPos 0) distance [0,0,0]) > 1) then {_enterable = false};
				if (_enterable) exitWith {}
				}
			};

		if (_enterable) then
			{
			_posAct = [1,1,1];

			_i = 0;
			while {((_posAct distance [0,0,0]) > 0)} do
				{
				_posAct = _nHouse buildingPos _i;
				_i = _i + 1;
				if ((_posAct distance [0,0,0]) > 0) then
					{
					_isRoof = [ATLToASL _posAct,20] call RYD_RoofOver;

					if (_isRoof) then
						{
						_posAll pushBack _posAct
						}
					}
				}
			};

		if ((count _posAll) > 0) then
			{
			_chosen = _posAll select (floor (random (count _posAll)));

			_wp setWaypointPosition [_chosen,0];
			_stat = "this doMove " + (str _chosen);
			_oldStat = (waypointStatements _wp) select 1;
			_stat = _stat + ";" + _oldStat;
			_wp setWaypointStatements ["true",_stat];
			}
		};

	[_nHouse,_chosen]
	};

RYD_RoofOver =
	{
	private ["_pos","_cam","_target","_pX","_pY","_pZ","_pos1","_pos2","_level","_roofed"];

	_pos = _this select 0;
	_level = _this select 1;

	_pX = _pos select 0;
	_pY = _pos select 1;
	_pZ = (_pos select 2) + 1;

	_pos1 = [_pX,_pY,_pZ];
	_pos2 = [_pX,_pY,_pZ + _level];

	_cam = objNull;

	if ((count _this) > 2) then {_cam = _this select 2};

	_target = objNull;

	if ((count _this) > 3) then {_target = _this select 3};

	_roofed = lineIntersects [_pos1, _pos2,_cam,_target];

	_roofed
	};
/*
RYD_RHQCheck =
	{
	private ["_type","_noInTotal","_noInAdditional","_noInBasic","_civF","_total","_basicrhq","_Additionalrhq","_Inf","_Art","_HArmor","_LArmor","_Cars","_Air","_Naval","_Static","_Other","_specFor",
		"_recon","_FO","_snipers","_ATInf","_AAInf","_LArmorAT","_NCAir","_StaticAA","_StaticAT","_Cargo","_NCCargo","_Crew","_MArmor","_BAir","_RAir","_ammo","_fuel","_med","_rep"];

	_specFor = RHQ_SpecFor + RYD_WS_specFor_class - RHQs_SpecFor;

	_recon = RHQ_Recon + RYD_WS_recon_class - RHQs_Recon;

	_FO = RHQ_FO + RYD_WS_FO_class - RHQs_FO;

	_snipers = RHQ_Snipers + RYD_WS_snipers_class - RHQs_Snipers;

	_ATinf = RHQ_ATInf + RYD_WS_ATinf_class - RHQs_ATInf;

	_AAinf = RHQ_AAInf + RYD_WS_AAinf_class - RHQs_AAInf;

	_Inf = RHQ_Inf + RYD_WS_Inf_class - RHQs_Inf;

	_Art = RHQ_Art + RYD_WS_Art_class - RHQs_Art;

	_HArmor = RHQ_HArmor + RYD_WS_HArmor_class - RHQs_HArmor;

	_MArmor = RHQ_MArmor + RYD_WS_MArmor_class - RHQs_MArmor;

	_LArmor = RHQ_LArmor + RYD_WS_LArmor_class - RHQs_LArmor;

	_LArmorAT = RHQ_LArmorAT + RYD_WS_LArmorAT_class - RHQs_LArmorAT;

	_Cars = RHQ_Cars + RYD_WS_Cars_class - RHQs_Cars;

	_Air = RHQ_Air + RYD_WS_Air_class - RHQs_Air;

	_BAir = RHQ_BAir + RYD_WS_BAir_class - RHQs_BAir;

	_RAir = RHQ_RAir + RYD_WS_RAir_class - RHQs_RAir;

	_NCAir = RHQ_NCAir + RYD_WS_NCAir_class - RHQs_NCAir;

	_Naval = RHQ_Naval + RYD_WS_Naval_class - RHQs_Naval;

	_Static = RHQ_Static + RYD_WS_Static_class - RHQs_Static;

	_StaticAA = RHQ_StaticAA + RYD_WS_StaticAA_class - RHQs_StaticAA;

	_StaticAT = RHQ_StaticAT + RYD_WS_StaticAT_class - RHQs_StaticAT;

	_Support = RHQ_Support + RYD_WS_Support_class - RHQs_Support;

	_Cargo = RHQ_Cargo + RYD_WS_Cargo_class - RHQs_Cargo;

	_NCCargo = RHQ_NCCargo + RYD_WS_NCCargo_class - RHQs_NCCargo;

	_Crew = RHQ_Crew + RYD_WS_Crew_class - RHQs_Crew;

	_Other = RHQ_Other + RYD_WS_Other_class;

	_ammo = RHQ_Ammo + RYD_WS_ammo - RHQs_Ammo;

	_fuel = RHQ_Fuel + RYD_WS_fuel - RHQs_Fuel;

	_med = RHQ_Med + RYD_WS_med - RHQs_Med;

	_rep = RHQ_Rep + RYD_WS_rep - RHQs_Rep;

	_civF = ["CIV_F","CIV","CIV_RU","BIS_TK_CIV","BIS_CIV_special"];

	_basicrhq = _Inf + _Art + _HArmor + _LArmor + _Cars + _Air + _Naval + _Static;

	_Additionalrhq = _Other + _specFor + _recon + _FO + _snipers + _ATInf + _AAInf + _LArmorAT + _NCAir + _StaticAA + _StaticAT + _Cargo + _NCCargo + _Crew + _MArmor + _BAir + _RAir + _ammo + _fuel + _med + _rep;

	_total = _basicrhq + _Additionalrhq;

	_noInBasic = [];
	_noInAdditional = [];
	_noInTotal = [];

		{
		if not ((faction _x) in _civF) then
			{
			_type = toLower (typeOf _x);
			if not ((_type in _basicrhq) or (_type in _noInBasic)) then {_noInBasic pushBack _type};
			if not ((_type in _Additionalrhq) or (_type in _noInAdditional)) then {_noInAdditional pushBack _type};
			if not ((_type in _total) or (_type in _noInTotal)) then {_noInTotal pushBack _type};
			}
		}
	forEach (allUnits + vehicles);

	diag_log "-------------------------------------------------------------------------";
	diag_log "-----------------------------RHQCHECK REPORT-----------------------------";
	diag_log "-------------------------------------------------------------------------";
	diag_log "Types not added to basic RHQ:";

		{
		diag_log format ["%1",_x];
		}
	forEach _noInBasic;

	diag_log "-------------------------------------------------------------------------";
	diag_log "Types not added to exact RHQ (not all must be):";

		{
		diag_log format ["%1",_x];
		}
	forEach _noInAdditional;

	diag_log "-------------------------------------------------------------------------";
	diag_log "Types not added anywhere:";

		{
		diag_log format ["%1",_x];
		}
	forEach _noInTotal;
	diag_log "-------------------------------------------------------------------------";
	diag_log "-------------------------END OF RHQCHECK REPORT--------------------------";
	diag_log "-------------------------------------------------------------------------";

	"RHQ CHECK" hintC format ["Forgotten classes: %1\nClasses not present in basic categories: %2\n(see RPT file for detailed forgotten classes list)",count _noInTotal,count _noInBasic];
	};
*/
RYD_LOSCheck =
	{
	private ["_pos1","_pos2","_isLOS","_cam","_target","_pX1","_pY1","_pX2","_pY2","_pos1ATL","_pos2ATL","_level1","_level2"];

	_pos1 = _this select 0;
	_pos2 = _this select 1;
	_level1 = _this select 2;
	_level2 = _this select 3;

	_pX1 = _pos1 select 0;
	_pY1 = _pos1 select 1;

	_pX2 = _pos2 select 0;
	_pY2 = _pos2 select 1;

	_pos1 = [_pX1,_pY1,(_pos1 select 2) + _level1];
	_pos2 = [_pX2,_pY2,(_pos2 select 2) + _level2];

	_pos1ATL = [_pX1,_pY1,_level1];
	_pos2ATL = [_pX2,_pY2,_level2];

	_cam = objNull;

	if ((count _this) > 4) then {_cam = _this select 4};

	_target = objNull;

	if ((count _this) > 5) then {_target = _this select 5};

	_isLOS = not (terrainIntersect [_pos1ATL, _pos2ATL]);

	if (_isLOS) then
		{
		_isLOS = not (lineIntersects [_pos1, _pos2,_cam,_target])
		};

	_isLOS
	};

RYD_KillHetman =
	{
	RydBB_Active = false;
	RydBBa_Urgent = true;
	RydBBb_Urgent = true;

		{
		_gps = [];
		if not (isNull _x) then
			{
			_gps = (_x getVariable ["RydHQ_Friends",[]]) + [_x]
			};

		_x setVariable ["RydHQ_KIA",true];

			{
			_x setVariable ["RydHQ_MIA",true];
			[_x] call CBA_fnc_clearWaypoints;
			_fEH = (leader _x) getVariable "HAC_FEH";

			if not (isNil "_fEH") then
				{
				(leader _x) removeEventHandler ["Fired",_fEH];
				(leader _x) setVariable ["HAC_FEH",nil]
				};

				{
				(vehicle _x) doMove (position _x)
				}
			forEach (units _x)
			}
		forEach _gps;
		}
	forEach RydxHQ_AllHQ;

		{
		terminate _x
		}
	forEach RydxHQ_Handles;

		{
		deleteMarker _x
		}
	forEach RydxHQ_Markers;
	};
