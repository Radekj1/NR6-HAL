RYD_Marker = 
	{
	private ["_type","_brush","_text","_i"];	
	params ["_name","_pos","_cl","_shape","_size","_dir","_alpha"];
	_shape = toUpper (_shape);

	if not (_shape == "ICON") then {_brush = _this select 7} else {_type = _this select 7};
	_text = _this select 8;

	if not ((typename _pos) == "ARRAY") exitWith {};
	if ((_pos select 0) == 0) exitWith {};
	if ((count _pos) < 2) exitWith {};
//diag_log format ["BB mark: %1 pos: %2 col: %3 size: %4 dir: %5 text: %6",_name,_pos,_cl,_size,_dir,_text];
	if (isNil "_pos") exitWith {};

	_i = _name;
	_i = createMarker [_i,_pos];
	_i setMarkerColor _cl;
	_i setMarkerShape _shape;
	_i setMarkerSize _size;
	_i setMarkerDir _dir;
	if not (_shape == "ICON") then {_i setMarkerBrush _brush} else {_i setMarkerType _type};
	_i setMarkerAlpha _alpha;
	_i setmarkerText _text;
	
	RydxHQ_Markers set [(count RydxHQ_Markers),_i]; 

	_i
	};

RYD_DistOrdB = 
	{
	private ["_point","_dst","_final","_VL"];
	params ["_array","_first","_limit"]; //BB strategic areas

	_first = [];
	_final = [];

		{
		_dst = round ((_x select 0) distance _point);
		if (_dst <= _limit) then {_first set [_dst,_x]}
		}
	foreach _array;

		{
		if not (isNil "_x") then {_final pushBack _x}
		}
	foreach _first;

	_first = nil;

	_final
	};

RYD_WhereIs = 
	{
	private ["_angle","_diffA","_isLeft","_isFlanking","_isBehind"];	
	params ["_point","_rPoint","_axis"];

	_angle = [_rPoint,_point,0] call RYD_AngTowards;

	_isLeft = false;
	_isFlanking = false;
	_isBehind = false;

	if (_angle < 0) then {_angle = _angle + 360};
	if (_axis < 0) then {_axis = _axis + 360};

	_diffA = _angle - _axis;

	if (_diffA < 0) then {_diffA = _diffA + 360};

	if (_diffA > 180) then 
		{
		_isLeft = true
		};

	if ((_diffA > 60) and (_diffA < 300)) then 
		{
		_isFlanking = true
		};

	if ((_diffA > 120) and (_diffA < 240)) then 
		{
		_isBehind = true
		};

	[_isLeft,_isFlanking,_isBehind]
	};
	
RYD_TerraCognita = 
	{
	private ["_radius","_precision","_sourcesCount","_urban","_forest","_hills","_flat","_sea","_valS","_value","_val0","_sGr","_hprev","_hcurr","_samplePos","_i","_rds"];	
	params ["_position","_samples"]; 

	_rds = 100;
	if ((count _this) > 2) then {_rds = _this select 2};

	if not ((typeName _position) == "ARRAY") then {_position = getPosATL _position};
	_position params ["_posX","_posY"];

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
			_val0 params ["_value","val0"];

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
	foreach ["Houses","Trees","Forest","Hills","Meadow","Sea"];

	[_urban,_forest,_hills,_flat,_sea,_sGr]
	};
	
RYD_Sectorize = 
	{
	private ["_EdgeL","_rd","_main","_step","_posX","_posY","_centers","_first",
	"_sectors","_centers2","_dXa","_dYa","_dst","_ang2","_Xb","_Yb","_dXb","_dYb","_center","_crX","_crY","_crPoint","_sec"];
	params ["_ctr","_lng","_ang","_nbr"];

	_EdgeL = _lng/_nbr;
	
	_rd = _lng/2;

	_main = createLocation ["Name", _ctr, _rd, _rd];
	_main setRectangular true;

	_step = _EdgeL;
	_ctr params ["_X1","_Y1"];

	_posX = (_X1 - _rd) + _step/2;
	_posY = (_Y1 - _rd) + _step/2;

	_centers = [[_posX,_posY]];
	_first = false;

	// REPLACE WHILE TRUE WITH PFH
	while {(true)} do
		{
		while {(true)} do
			{
			if not (_first) then {_first = true;_posX = _posX + _step};
			if not ([_posX,_PosY] in _main) exitwith {_posX = ((_ctr select 0) - _rd) + _step/2;_first = true};
			_centers pushBack [_posX,_PosY];
			_first = false
			};
		_posY = _posY + _step;
		if not ([_posX,_PosY] in _main) exitwith {}
		};

	if not (_ang in [0,90,180,270]) then
		{
		_main setDirection _ang;
		_centers2 = +_centers;
		_centers = [];

			{
			_x params ["_Xa","_Ya"];
			_dXa = (_X1 - _Xa);
			_dYa = (_Y1 - _Ya);
			_dst = _ctr distance _x;

			_ang2 = _ang + (_dXa atan2 _dYa);

			_dXb = _dst * (sin _ang2);
			_dYb = _dst * (cos _ang2);

			_Xb = _X1 + _dXb;
			_Yb = _Y1 + _dYb;
			_center = [_Xb,_Yb];
			_centers pushBack _center
			}
		foreach _centers2
		};
	
	_sectors = [];

		{
		_crX = _x select 0;
		_crY = _x select 1;
		_crPoint = [_crX,_crY,0];
		_sec = createLocation ["Name", _crPoint, _EdgeL/2, _EdgeL/2];
		_sec setDirection _ang;
		_sec setRectangular true;

		_sectors pushBack _sec;
		}
	foreach _centers;

	[_sectors,_main]	
	};

RYD_LocLineTransform = 
	{
	private ["_center","_angle","_r1","_r2"];
	params ["_loc","_p1","_p2","_space"];
	//ATL _p1
	//ATL _p2

	_center = [((_p1 select 0) + (_p2 select 0))/2,((_p1 select 1) + (_p2 select 1))/2,0];

	_angle = [_p1,_p2,0] call RYD_AngTowards;

	_r1 = _space;
	_r2 = (_center distance _p1) + _space;

	_loc setPosition _center;
	_loc setDirection _angle;
	_loc setSize [_r1,_r2];

	true
	};

RYD_LocMultiTransform = 
	{
	private ["_center","_angle","_r1","_r2","_sx","_sy","_cnt","_dmax","_pf","_dst","_pfMain","_check","_indx","_pfbis","_dmaxbis","_cX","_cY","_allIn","_mpl","_pX","_pY"];
	params ["_loc","_ps","_space"];
	//array of ATL - _ps

	_sx = 0;
	_sy = 0;

		{
		_x params ["_sx1","_sy1"];
		_sx = _sx + _sx1;
		_sy = _sy + _sy1;
		}
	foreach _ps;

	_cnt = count _ps;

	if not (_cnt > 0) exitWith {};
		
	_center = [_sx/_cnt,_sy/_cnt,0];

	_pf = _ps select 0;

	_dmax = _center distance _pf;

	_indx = 0;

	for "_i" from 0 to ((count _ps) - 1) do
		{
		_check = _ps select _i;

		if (((typeName _check) == "ARRAY") and ((count _check) > 1)) then
			{
			_cX = _check select 0;
			_cY = _check select 1;

			_check = [_cX,_cY,0];

			_dst = _center distance _check;
			if (_dst > _dmax) then
				{
				_pf = _check;
				_indx = _i;
				_dmax = _dst
				}
			}
		};

	_pfMain = _pf;

	_ps set [_indx,"DeleteThis"];
	_ps = _ps - ["DeleteThis"];

	_pf = _ps select 0;

	_dmaxbis = _center distance _pf;

	for "_i" from 0 to ((count _ps) - 1) do
		{
		_check = _ps select _i;

		_cX = _check select 0;
		_cY = _check select 0;

		_check = [_cX,_cY,0];

		_dst = _center distance _check;
		if (_dst > _dmaxbis) then
			{
			_dmaxbis = _dst
			}
		};

	_angle = [_center,_pfMain,0] call RYD_AngTowards;

	_r1 = _dmaxbis;
	_r2 = _dmax;

	_loc setPosition _center;
	_loc setDirection _angle;
	_loc setSize [_r1,_r2];

	_allIn = false;

	_mpl = 10;

	while {(not (_allIn) and (_mpl > 0))} do
		{
		_allIn = true;

		_r1 = _dmaxbis/_mpl;
		_loc setSize [_r1,_r2];

			{
			_pX = _x select 0;
			_pY = _x select 1;

			if not ([_pX,_pY,0] in _loc) exitWith {_allIn = false};
			}
		foreach (_ps + [_pfMain]);

		_mpl = _mpl - 0.1;
		};

	_allIn = false;

	_mpl = 10;

	while {(not (_allIn) and (_mpl > 0))} do
		{
		_allIn = true;

		_r2 = _dmax/_mpl;
		_loc setSize [_r1,_r2];

			{
			_pX = _x select 0;
			_pY = _x select 1;

			if not ([_pX,_pY,0] in _loc) exitWith {_allIn = false};
			}
		foreach (_ps + [_pfMain]);

		_mpl = _mpl - 0.1;
		};

	_r1 = _r1 + _space;
	_r2 = _r2 + _space;

	_loc setSize [_r1,_r2];

	true
	};

RYD_ForceCount = 
	{
	private ["_eInfG","_eCarG","_eArmG","_eAirG","_eNCG","_eAllP","_eInfP","_eCarP","_eArmP","_eAirP","_eNCP","_allP","_infP","_carP","_armP","_airP","_ncP","_frRep","_enRep"];

	params ["_friends","_inf","_car","_arm","_air","_nc","_current","_initial","_value","_morale","_enemies","_einf","_ecar","_earm","_eair","_enc","_evalue","_frArr","_enArr","_enG","_gpHQ"];

	_eInfG = [];
	_eCarG = [];
	_eArmG = [];
	_eAirG = [];
	_eNCG = [];	

	_eInfP = 0;
	_eCarP = 0;
	_eArmP = 0;
	_eAirP = 0;
	_eNCP = 0;

	_infP = 0;
	_carP = 0;
	_armP = 0;
	_airP = 0;
	_ncP = 0;

	if ((count _enemies) > 0) then 
		{
			{
			if (not (_x in _enG) and (_x in _einf)) then {_eInfG pushBack _x};
			if (not (_x in _enG) and (_x in _ecar)) then {_eCarG pushBack _x};
			if (not (_x in _enG) and (_x in _earm)) then {_eArmG pushBack _x};
			if (not (_x in _enG) and (_x in _eair)) then {_eAirG pushBack _x};
			if (not (_x in _enG) and (_x in _enc)) then {_eNCG pushBack _x};	
			}
		foreach _enemies;

		_eAllP = {not (_x in _enG)} count _enemies;

		if (_eAllP > 0) then
			{
			_eInfP = (count _eInf)/_eAllP;
			_eCarP = (count _eCar)/_eAllP;
			_eArmP = (count _eArm)/_eAllP;
			_eAirP = (count _eAir)/_eAllP;
			_eNCP = (count _eNC)/_eAllP
			}
		};
		
	_allP = count _friends;

	if (_allP > 0) then
		{	
		_infP = (count _inf)/_allP;
		_carP = (count _car)/_allP;
		_armP = (count _arm)/_allP;
		_airP = (count _air)/_allP;
		_ncP = (count _nc)/_allP
		};

	_frRep = [_allP,_current,_current - _initial,_value,_morale,[_infP,_carP,_armP,_airP,_ncP]];//liczba grup-liczba jednostek-straty-wartosc-morale-rozklad
	_enRep = [count _enemies,_evalue,[_eInfP,_eCarP,_eArmP,_eAirP,_eNCP]];//liczba grup-wartosc-rozklad

	_gpHQ setVariable ["ForceRep",[_frRep,_enRep]];

	_frArr pushBack _frRep;
	_enArr pushBack _enRep;

	[_frArr,_enArr]
	};

RYD_ForceAnalyze = 
	{
	private ["_frArr","_enArr","_frG","_enG","_HQs","_arr","_HQ"];
	params ["_HQarr"];

	_frArr = [];
	_enArr = [];

	_frG = [];
	_enG = [];

	_HQs = [];

		{
		_HQ = _x;
		if not (isNil "_HQ") then
			{
			if not (isNull _HQ) then 
				{
				_arr = 
					[
					(_HQ getVariable ["RydHQ_Friends",[]]),
					(_HQ getVariable ["RydHQ_NCrewInfG",[]]),
					(_HQ getVariable ["RydHQ_CarsG",[]]),
					(_HQ getVariable ["RydHQ_HArmorG",[]]) + (_HQ getVariable ["RydHQ_LArmorG",[]]),
					(_HQ getVariable ["RydHQ_AirG",[]]),
					(_HQ getVariable ["RydHQ_NCAirG",[]]) + ((_HQ getVariable ["RydHQ_NCCargoG",[]]) - (_HQ getVariable ["RydHQ_NCAirG",[]])) + ((_HQ getVariable ["RydHQ_SupportG",[]]) - ((_HQ getVariable ["RydHQ_NCAirG",[]]) + ((_HQ getVariable ["RydHQ_NCCargoG",[]]) - (_HQ getVariable ["RydHQ_NCAirG",[]])))),
					(_HQ getVariable ["RydHQ_CCurrent",0]),
					(_HQ getVariable ["RydHQ_CInitial",0]),
					(_HQ getVariable ["RydHQ_FValue",0]),
					(_HQ getVariable ["RydHQ_Morale",0]),
					(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),
					(_HQ getVariable ["RydHQ_EnInfG",[]]),
					(_HQ getVariable ["RydHQ_EnCarsG",[]]),
					(_HQ getVariable ["RydHQ_EnHArmorG",[]]) + (_HQ getVariable ["RydHQ_EnLArmorG",[]]),
					(_HQ getVariable ["RydHQ_EnAirG",[]]),
					(_HQ getVariable ["RydHQ_EnNCAirG",[]]) + ((_HQ getVariable ["RydHQ_EnNCCargoG",[]]) - (_HQ getVariable ["RydHQ_EnNCAirG",[]])) + ((_HQ getVariable ["RydHQ_EnSupportG",[]]) - ((_HQ getVariable ["RydHQ_EnNCAirG",[]]) + ((_HQ getVariable ["RydHQ_EnNCCargoG",[]]) - (_HQ getVariable ["RydHQ_EnNCAirG",[]])))),
					(_HQ getVariable ["RydHQ_EValue",0])
					];
					
				_arr = (_arr + [_frArr,_enArr,_enG,_HQ]) call RYD_ForceCount;
				_arr params ["_frARR","_enArr"];
				
				_HQs pushBack _x;
				_frG = _frG + (_HQ getVariable ["RydHQ_Friends",[]]) - (_HQ getVariable ["RydHQ_Exhausted",[]]);

					{
					if not (_x in _enG) then {_enG pushBack _x};
					}
				foreach (_HQ getVariable ["RydHQ_KnEnemiesG",[]])
				}
			}	
		}
	foreach _HQarr;

	_frArr pushBack _frG;
	_enArr pushBack _enG;

	[_frArr,_enArr,_HQs]
	};

RYD_TopoAnalize = 
	{
	private ["_sectors0","_infF","_vehF","_ct","_urbanF","_forestF","_hillsF","_flatF","_seaF","_roadsF","_grF","_actInf","_actVeh"];
	params ["_sectors"];

	_sectors0 = _sectors;


	_infF = 0;
	_vehF = 0;
	_ct = 0;

		{
		_urbanF = _x getVariable "Topo_Urban";
		_forestF = _x getVariable "Topo_Forest";
		_hillsF = _x getVariable "Topo_Hills";
		_flatF = _x getVariable "Topo_Flat";
		_seaF = _x getVariable "Topo_Sea";
		_roadsF = _x getVariable "Topo_Roads";
		_grF = _x getVariable "Topo_Grd";

		if not (_seaF >= 90) then 
			{
			//diag_log format ["L - U: %1 F: %2 H: %3, Fl: %4 S: %5 R: %6 G: %7 ",_urbanF,_forestF,_hillsF,_flatF,_seaF,_roadsF,_grF];

			_actInf = _urbanF + _forestF + _grF - _flatF - _hillsF;
			_actVeh = _flatF + _hillsF + _roadsF - _urbanF - _forestF - _grF;

			_x setVariable ["InfFr",_actInf];
			_x setVariable ["VehFr",_actVeh];

			_infF = _infF + _actInf;
			_vehF = _vehF + _actVeh;

			//_txt = format ["Inf: %1 - Veh: %2",_urbanF + _forestF + _grF - _flatF - _hillsF,_flatF + _hillsF + _roadsF - _urbanF - _forestF - _grF];

			//_x setText _txt;
			_ct = _ct + 1
			}
		else
			{
			_sectors = _sectors - [_x];
			}
		}
	foreach _sectors0;

	if (_ct > 0) then {_infF = _infF/_ct};
	if (_ct > 0) then {_vehF = _vehF/_ct};

	[_sectors,_infF,_vehF]
	};

RYD_Itinerary = 
	{
	private ["_bound","_secIn","_tgtIn","_topoAn","_infF","_vehF","_cSum","_varName","_HandledArray"];	
	params ["_sectors","_targets","_pos1","_pos2","_side"];

	_bound = createLocation ["Name", _pos1, 1, 1];
	_bound setRectangular true;

	[_bound,_pos1,_pos2,120000] call RYD_LocLineTransform;

	_secIn = [];
	_tgtIn = [];

		{
		if ((position _x) in _bound) then {_secIn pushBack _x}
		}
	foreach _sectors;

		{
		if ((_x select 0) in _bound) then 
			{
			_cSum = 0;

				{
				_cSum = _cSum + _x
				}
			foreach (_x select 0);

			_varName = "HandledAreas" + _side;

			_HandledArray = missionNameSpace getVariable _varName;

			if (isNil "_HandledArray") then 
				{
				missionNameSpace setVariable [_varName,[]];
				_HandledArray = missionNameSpace getVariable _varName
				};

			if not (_cSum in _HandledArray) then 
				{
				_tgtIn pushBack _x;
				_HandledArray pushBack _cSum;
				missionNameSpace setVariable [_varName,_HandledArray];
				}
			}
		}
	foreach _targets;

	deleteLocation _bound;

	_topoAn = [_secIn] call RYD_TopoAnalize;
	_topoAn params ["_secIn"];

	_topoAn = [_secIn] call RYD_TopoAnalize;
	_topoAn params ["_placebo1","_infF","_vehF"];

	[_secIn,_tgtIn,_infF,_vehF]
	};

RYD_ExecuteObj =
	{
	_SCRname = "ExecuteObj";

		private ["_areas","_HQpos","_i","_nObj","_actO","_nObj","_KnEn","_KnEnAct","_VLpos","_enX","_enY","_ct","_VHQpos","_afront",
				"_chosenPos","_maxTempt","_actTempt","_sectors","_ownKnEn","_ownForce","_ctOwn","_alliedForce","_alliedGarrisons","_alliedExhausted","_inFlank","_Garrisons","_exhausted",
				"_prop","_enPos","_dst","_val","_profile","_j","_pCnt","_marker","_markerVar","_markerName","_checkPos","_actPos","_indx","_check","_garrPool","_fG","_garrison","_chosen","_dstMin","_actG","_actDst",
				"_AllV","_Civs","_AllV2","_Civs2","_AllV0","_AllV20","_NearAllies","_NearEnemies","_actOPos","_mChange","_marksT","_firstP","_actP","_angleM","_centerPoint","_mr1","_mr2","_lM","_wp",
				"_cSum","_reck","_cons","_limit","_lColor","_alive","_AAOPts","_Unable","_UnableArr","_noGarrAround","_SideAllies","_SideEnemies"];	
		params ["_sortedA","_HQ","_side","_BBAOObj","_AAO","_allied","_front","_frPos","_frDir","_frDim","_reserve","_HandledArray","_varName","_o1","_o2","_o3","_o4"];

		_actO = _sortedA select (_BBAOObj - 1);

		//[_actO,_HQ,_side,_BBAOObj,_AAO,_allied,_front,_frPos,_frDir,_frDim,_reserve,_HandledArray,_varName]

		if (_BBAOObj == 1) then {_HQ setVariable ["BBObj1Done",false]};
		if (_BBAOObj == 2) then {_HQ setVariable ["BBObj2Done",false]};
		if (_BBAOObj == 3) then {_HQ setVariable ["BBObj3Done",false]};
		if (_BBAOObj == 4) then {_HQ setVariable ["BBObj4Done",false]};

		_cSum = 0;

			{
			_cSum = _cSum + _x
			}
		foreach (_actO select 0);

		_actOPos = [(_actO select 0) select 0,(_actO select 0) select 1,0];

		_lColor = switch (side _HQ) do
			{
			case (west) : {"colorBLUFOR"};
			case (east) : {"colorOPFOR"};
			default {"colorIndependent"};
			};

		if ((RydBB_Debug) or ((RydBBa_SimpleDebug) and (_Side == "A")) or ((RydBBb_SimpleDebug) and (_Side == "B"))) then
			{
			_markerVar = format ["RydHQ_DebugMarker_%1", _BBAOObj];
			_markerName = format ["markBBCurrent_%1_%2", _BBAOObj, round(time)]; // unique markername

			// remove old marker if exist
			if (!isNil {_HQ getVariable _markerVar}) then {
			    deleteMarker (_HQ getVariable _markerVar);
			};

			// create new marker
			_marker = [(_actO select 0), _HQ, _markerName, _lColor, "ICON", "mil_triangle", (str _BBAOObj) + " Current target for " + (str (leader _HQ)), "", [0.5, 0.5]] call RYD_Mark;
			_HQ setVariable [_markerVar, _marker];
			};
				
		if (_BBAOObj == 1) then {_HQ setVariable ["RydHQ_EyeOfBattle",_actOPos]};

		if (_BBAOObj == 1) then
			{
				{
				_x setPosATL _actOPos;
				if not (_AAO) then
					{
					_x setVariable [("Capturing" + (str _x) + (str _HQ)),[0,0]];
					}
				}
			foreach [_o1];
			};

		if (_BBAOObj == 2) then
			{
				{
				_x setPosATL _actOPos;
				if not (_AAO) then
					{
					_x setVariable [("Capturing" + (str _x) + (str _HQ)),[0,0]];
					}
				}
			foreach [_o2];
			};

		if (_BBAOObj == 3) then
			{
				{
				_x setPosATL _actOPos;
				if not (_AAO) then
					{
					_x setVariable [("Capturing" + (str _x) + (str _HQ)),[0,0]];
					}
				}
			foreach [_o3];
			};

		if (_BBAOObj == 4) then
			{
				{
				_x setPosATL _actOPos;
				if not (_AAO) then
					{
					_x setVariable [("Capturing" + (str _x) + (str _HQ)),[0,0]];
					}
				}
			foreach [_o4];
			};

		//if (_AAOPts) then {_HQ setVariable ["RydHQ_Objectives",_AAOPts]};
			
		_alive = true;

		waitUntil
			{
			sleep 15;//120
				
			_alive = true;
				
			switch (true) do
				{
				case (isNil "_HQ") : {_alive = false};
				case (isNull _HQ) : {_alive = false};
				case (({alive _x} count (units _HQ) < 1)) : {_alive = false};
				case not (RydBB_Active) : {_alive = false};
				};
					
			if (_alive) then
				{
				_KnEn = [];

				_inFlank = _HQ getVariable "inFlank";
				if (isNil "_inFlank") then {_inFlank = false};

				if not (_inFlank) then
					{
					_ownKnEn = _HQ getVariable ["RydHQ_KnEnemiesG",[]];

					_ownForce = _HQ getVariable ["RydHQ_Friends",[]];
					_Garrisons = _HQ getVariable ["RydHQ_Garrison",[]];
					_exhausted = _HQ getVariable ["RydHQ_Exhausted",[]];

					_ownForce = _ownForce - (_Garrisons + _exhausted);
					_alliedForce = 0;

					_ctOwn = 0;

						{
						if ((position (vehicle (leader _x))) in _front) then {_ctOwn = _ctOwn + 1}
						}
					foreach _ownKnEn;

					_prop = 100;

					if (_ctOwn > 0) then {_prop = (count _ownForce)/_ctOwn};

					if (_prop > (8 * (0.5 + (random 1)))) then
						{
							{
							
							_KnEnAct = _x getVariable ["RydHQ_KnEnemiesG",[]];
							_afront = _x getVariable ["RydHQ_Front",locationNull];	

							_alliedForce = _x getVariable ["RydHQ_Friends",[]];
							_alliedGarrisons = _x getVariable ["RydHQ_Garrison",[]];
							_alliedExhausted = _x getVariable ["RydHQ_Exhausted",[]];	

							_alliedForce =  _alliedForce - (_alliedGarrisons + _alliedExhausted);

							if ((count _KnEnAct) > 0) then
								{
								_ct = 0;
								
									{
									_enX = 0;
									_enY = 0;				

									_VLpos = getPosATL (vehicle (leader _x));
									if (_VLpos in _afront) then 
										{
										_ct = _ct + 1;
										_enX = _enX + (_VLpos select 0);
										_enY = _enY + (_VLpos select 1);
										}
									}
								foreach _KnEnAct;
									
								if (_ct > 0) then
									{
									_enX = _enX/_ct;
									_enY = _enY/_ct;
									};

								_KnEn pushBack [[_enX,_enY,0],_ct];
								};

							}
						foreach _allied;

						if ((count _KnEn) > 0) then
							{
							_chosenPos = [];	
							_maxTempt = 0;			

								{
								_VHQpos = getPosATL (vehicle (leader _HQ));
								_enPos = _x select 0;
								_dst = _VHQpos distance _enPos;
								_val = _x select 1;
								_actTempt = 0;

								if ((_dst > 0) and ((count _ownForce) > (_val * (0.1 + (random 1)))) and (_val > ((count _alliedForce) * (0.5 + (random 0.5))))) then {_actTempt = (1000 * (sqrt _val))/_dst};

								if (_actTempt > _maxTempt) then
									{
									_maxTempt = _actTempt;
									_chosenPos = _enPos;
									}
								}
							foreach _KnEn;

							if ((count _chosenPos) > 1) then {_chosenPos = [(_chosenPos select 0),(_chosenPos select 1),0]};

							if (_maxTempt > (0.1 + (random 2))) then 
								{
								_HQ setVariable ["inFlank",true];
								//[_front,_VHQpos,_chosenPos,2000] call RYD_LocLineTransform;

								if (_BBAOObj == 1) then
									{
										{
										_x setPosATL _chosenPos;
										}
									foreach [_o1];
									};

								if (_BBAOObj == 2) then
									{
										{
										_x setPosATL _chosenPos;
										}
									foreach [_o2];
									};

								if (_BBAOObj == 3) then
									{
										{
										_x setPosATL _chosenPos;
										}
									foreach [_o3];
									};

								if (_BBAOObj == 4) then
									{
										{
										_x setPosATL _chosenPos;
										}
									foreach [_o4];
									};
									
									
								_alive = true;

								waitUntil 
									{
									sleep 15;//120
										
									_alive = true;
										
									switch (true) do
										{
										case (isNil "_HQ") : {_alive = false};
										case (isNull _HQ) : {_alive = false};
										case (({alive _x} count (units _HQ)) < 1) : {_alive = false};
										case not (RydBB_Active) : {_alive = false};
										};
											
									if (_alive) then
										{
										_nObj = _HQ getVariable ["RydHQ_NObj",1];
										_reck = _HQ getVariable ["RydHQ_Recklessness",0.5];
										_cons = _HQ getVariable ["RydHQ_Consistency",0.5];

										_limit = _HQ getVariable ["RydHQ_CaptLimit",10];
										
										_SideAllies = [];
										_SideEnemies = [];

										{
											if (((side _HQ) getFriend _x) >= 0.6) then {_SideAllies pushBack _x} else {_SideEnemies pushBack _x};
										} foreach [west,east,resistance];

										if (isNull _HQ) then {_nObj = 100};
										if (({alive _x} count (units _HQ)) < 1) then {_nObj = 100};

										_AllV = _chosenPos nearEntities [["AllVehicles"],300];
										_Civs = _chosenPos nearEntities [["Civilian"],300];
										_AllV2 = _chosenPos nearEntities [["AllVehicles"],400];
										_Civs2 = _chosenPos nearEntities [["Civilian"],400];

										_AllV = _AllV - _Civs;
										_AllV2 = _AllV2 - _Civs2;

										_AllV0 = _AllV;
										_AllV20 = _AllV2;

											{
											if not (_x isKindOf "Man") then
												{
												if ((count (crew _x)) == 0) then {_AllV = _AllV - [_x]};
												if ((count (crew _x)) > 0) then {_AllV = _AllV - [_x] + (crew _x)};
												}
											}
										foreach _AllV0;

											{
											if not (_x isKindOf "Man") then
												{
												if ((count (crew _x)) == 0) then {_AllV2 = _AllV2 - [_x]};
												if ((count (crew _x)) > 0) then {_AllV2 = _AllV2 - [_x] + (crew _x)};
												}
											}
										foreach _AllV20;

										//_NearAllies = (leader _HQ) countfriendly _AllV;
										_NearAllies = ({(side _x) in _SideAllies} count _AllV);
										//_NearEnemies = (leader _HQ) countenemy _AllV2;
										_NearEnemies = ({(side _x) in _SideEnemies} count _AllV2);
										};

									(not (_alive) or (_nObj >= 5) or ((_NearAllies >= _limit) and (_NearEnemies <= ((_reck/(0.5 + _cons))*10))))
									};
									
								if not (_alive) exitWith {};

								if not (isNull _HQ) then 
									{
									_front setPosition _frPos;
									_front setDirection _frDir;
									_front setSize _frDim; 

									if (_BBAOObj == 1) then
										{
											{
											_x setPosATL _chosenPos;
											}
										foreach [_o1];
										};

									if (_BBAOObj == 2) then
										{
											{
											_x setPosATL _chosenPos;
											}
										foreach [_o2];
										};

										if (_BBAOObj == 3) then
										{
											{
											_x setPosATL _chosenPos;
											}
										foreach [_o3];
										};

										if (_BBAOObj == 4) then
										{
											{
											_x setPosATL _chosenPos;
											}
										foreach [_o4];
										};
										

									_HQ setVariable ["inFlank",false]
									};
								}
							}
						}
					}
				};

			((_actO select 2) or not (_alive))
			};

		if not (_alive) exitWith {};

		_garrPool = 0;
		_UnableArr = [];
		_noGarrAround = true;

			{
			{
				if (((_actO select 0) distance (leader _x)) < 200) exitwith {_noGarrAround = false};
			} foreach (_x getVariable ["RydHQ_Garrison",[]]);

			_fG = (_x getVariable ["RydHQ_NCrewInfG",[]]) - ((_x getVariable ["RydHQ_Exhausted",[]]) + (_x getVariable ["RydHQ_Garrison",[]]));

			{
				if (((_x getvariable ["Unable",false]) or (isPlayer (leader _x))) or (_x getVariable ["Busy" + (str _x),false])) then {_UnableArr pushBack _x};
			} foreach _fG;

			_fG = _fG - (_UnableArr);

			if ((count _fG) > 2) then {_garrPool = _garrPool + 1}
			}
		foreach _reserve;

		{
			if (((_actO select 0) distance (leader _x)) < 200) exitwith {_noGarrAround = false};
		} foreach (_HQ getVariable ["RydHQ_Garrison",[]]);

		if (_garrPool == 0) then
			{
			_UnableArr = [];

			_garrison = _HQ getVariable ["RydHQ_Garrison",[]];
			_fG = (_HQ getVariable ["RydHQ_NCrewInfG",[]]) - ((_HQ getVariable ["RydHQ_Exhausted",[]]) + (_garrison));

			{
				if (_x getvariable ["Unable",false]) then {_UnableArr pushBack _x};
			} foreach _fG;

			_fG = _fG - (_UnableArr);

			if ((((count _fG)/5) >= 1) and (_noGarrAround)) then
				{
				_chosen = _fG select 0;

				_dstMin = (_actO select 0) distance (vehicle (leader _chosen));

					{
					_actG = _x;
					_actDst = (_actO select 0) distance (vehicle (leader _actG));
		
					if (_actDst < _dstMin) then 
						{
						_dstMin = _actDst;
						_chosen = _actG
						}
					}
				foreach _fG;
					
				_code =
					{
					_unitG = _this select 0;
					_HQ = _this select 1;
			
					_busy = _unitG getvariable [("Busy" + (str _unitG)),false];

					_alive = true;

					if (_busy) then 
						{
						_unitG setVariable ["RydHQ_MIA",true];
						_ct = time;
							
						waitUntil
							{
							sleep 0.1;
							
							switch (true) do
								{
								case (isNull (_unitG)) : {_alive = false};
								case (({alive _x} count (units _unitG)) < 1) : {_alive = false};
								case ((time - _ct) > 60) : {_alive = false};
								case not (RydBB_Active) : {_alive = false};
								};
									
							_MIApass = false;
							if (_alive) then
								{
								_MIAPass = not (_unitG getVariable ["RydHQ_MIA",false]);
								};
									
							(not (_alive) or (_MIApass))	
							}
						};
							
					_unitG setVariable ["Busy" + (str _unitG),true];
					_garrison = _HQ getVariable ["RydHQ_Garrison",[]];
					_garrison pushBack _unitG;
					_HQ setVariable ["RydHQ_Garrison",_garrison];
					};
						
				[_chosen,_HQ] call _code;
				}
			};
				
		_BBProg = _HQ getVariable ["BBProgress",0];
		_HQ setVariable ["BBProgress",_BBProg + 1];

		_HandledArray = _HandledArray - [_cSum];
		missionNameSpace setVariable [_varName,_HandledArray];
			
		if not (RydBB_Active) exitWith {};

		if (RydBB_LRelocating) then
			{
			[_HQ] call RYD_WPdel;
			_wp = [_HQ,_actOPos,"HOLD","AWARE","GREEN","LIMITED",["true",""],true,50,[0,0,0],"FILE"] call RYD_WPadd
			};

		if (_BBAOObj == 1) then {
		    _HQ setVariable ["BBObj1Done", true];
		    if (RydBB_Debug) then { deleteMarker (_HQ getVariable "RydHQ_DebugMarker_1"); };
		};
		if (_BBAOObj == 2) then {
		    _HQ setVariable ["BBObj2Done", true];
		    if (RydBB_Debug) then { deleteMarker (_HQ getVariable "RydHQ_DebugMarker_2"); };
		};
		if (_BBAOObj == 3) then {
		    _HQ setVariable ["BBObj3Done", true];
		    if (RydBB_Debug) then { deleteMarker (_HQ getVariable "RydHQ_DebugMarker_3"); };
		};
		if (_BBAOObj == 4) then {
		    _HQ setVariable ["BBObj4Done", true];
		    if (RydBB_Debug) then { deleteMarker (_HQ getVariable "RydHQ_DebugMarker_4"); };
		};
	};

RYD_ExecutePath = 
	{
	_SCRname = "ExecutePath";
    
	private ["_sortedA","_i","_nObj","_actO","_nObj","_KnEn","_KnEnAct","_VLpos","_enX","_enY","_ct","_VHQpos","_afront",
	"_frPos","_frDir","_frDim","_chosenPos","_maxTempt","_actTempt","_ownKnEn","_ownForce","_ctOwn","_alliedForce","_alliedGarrisons","_alliedExhausted","_inFlank","_Garrisons","_exhausted",
	"_prop","_enPos","_dst","_val","_profile","_j","_pCnt","_m","_checkPos","_actPos","_indx","_check","_garrPool","_fG","_garrison","_chosen","_dstMin","_actG","_actDst",
	"_AllV","_Civs","_AllV2","_Civs2","_AllV0","_AllV20","_NearAllies","_NearEnemies","_actOPos","_mChange","_marksT","_firstP","_actP","_angleM","_centerPoint","_mr1","_mr2","_lM","_wp",
	"_varName","_HandledArray","_cSum","_reck","_cons","_limit","_lColor","_alive","_AAO","_BBAOObj","_AssObj","_ObjDone","_ObjVar","_anyTaskDone"];    
	params ["_HQ","_areas","_o1","_o2","_o3","_o4","_allied","_HQpos","_front","_sectors","_reserve","_side","_AAOPts"];

	_allied = _allied - [_HQ];
    
	_AAO = _HQ getVariable ["RydHQ_ChosenAAO",false];
	_BBAOObj = _HQ getVariable ["RydHQ_BBAOObj",1];

	_varName = "HandledAreas" + _side;
	_HandledArray = missionNameSpace getVariable _varName;

	_frPos = position _front;
	_frDir = direction _front;
	_frDim = size _front;

	_profile = _HQ getVariable "ForceProfile";
	_sortedA = [_areas,_HQpos,250000] call RYD_DistOrdB;
	_HQ setVariable ["SortedDebug",_sortedA];

	_pCnt = 0;
	_m = "";
	_marksT = [];        

	_HQ setVariable ["PathDone",false];

	if (RydBB_Debug) then {
		_lColor = switch (side _HQ) do {
			case (west): {"colorBLUFOR"};
			case (east): {"colorOPFOR"};
			default {"colorIndependent"};
		};

		{ deleteMarker _x } forEach (_marksT + [_m]);

		{
		_pCnt = _pCnt + 1;
		_j = [(_x select 0), random 1000, "markBBPath", "ColorBlack", "ICON", "mil_box", (str _pCnt), "", [0.35, 0.35]] call RYD_Mark;
		_marksT pushBack _j;
		} forEach _sortedA;


		for "_i" from 0 to ((count _sortedA) - 1) do {
			_firstP = if (_i == 0) then { _HQpos } else { (_sortedA select (_i - 1)) select 0 };
			_firstP = [_firstP select 0, _firstP select 1, 0];
			_actP = (_sortedA select _i) select 0;
			_actP = [_actP select 0, _actP select 1, 0];
			_angleM = [_firstP, _actP, 0] call RYD_AngTowards;
			_centerPoint = [((_firstP select 0) + (_actP select 0))/2, ((_firstP select 1) + (_actP select 1))/2, 0];
			_mr1 = 1.5;
			_mr2 = _actP distance _centerPoint;
			_lM = [_centerPoint, random 1000, "markBBline", _lColor, "RECTANGLE", "Solid", "", "", [_mr1, _mr2], _angleM] call RYD_Mark;
			_marksT pushBack _lM;
		};
	};

	if ( not (_BBAOObj <= (count _sortedA))) then {_BBAOObj = (count _sortedA)};

	for "_i" from 1 to 4 do {
		_HQ setVariable [format["BBObj%1Done", _i], true];
	};

	if (_BBAOObj >= 1) then {_AssObj = 1; [_sortedA,_HQ,_side,_AssObj,_AAO,_allied,_front,_frPos,_frDir,_frDim,_reserve,_HandledArray,_varName,_o1,_o2,_o3,_o4] call RYD_ExecuteObj;};
	if ((_BBAOObj >= 2) && (_AAO)) then {_AssObj = 2; [_sortedA,_HQ,_side,_AssObj,_AAO,_allied,_front,_frPos,_frDir,_frDim,_reserve,_HandledArray,_varName,_o1,_o2,_o3,_o4] call RYD_ExecuteObj;};
	if ((_BBAOObj >= 3) && (_AAO)) then {_AssObj = 3; [_sortedA,_HQ,_side,_AssObj,_AAO,_allied,_front,_frPos,_frDir,_frDim,_reserve,_HandledArray,_varName,_o1,_o2,_o3,_o4] call RYD_ExecuteObj;};
	if ((_BBAOObj == 4) && (_AAO)) then {_AssObj = 4; [_sortedA,_HQ,_side,_AssObj,_AAO,_allied,_front,_frPos,_frDir,_frDim,_reserve,_HandledArray,_varName,_o1,_o2,_o3,_o4] call RYD_ExecuteObj;};

	sleep 1;

	_HQ setVariable ["ObjInit",true];
	_HQ setVariable ["RydHQ_Taken",[]]; 

	_anyTaskDone = false;

	waitUntil {
		sleep 15; 
	
		if ((_AAO) && (_BBAOObj > 1)) then {
	    
			for "_i" from 1 to _BBAOObj do {
				_ObjVar = format ["BBObj%1Done", _i];
				_ObjDone = _HQ getVariable [_ObjVar, false];
				if (_ObjDone) then {_anyTaskDone = true};
			};
		} else	{
			_anyTaskDone = (_HQ getvariable ["BBObj1Done",false])
		};
		_anyTaskDone;
	};

	switch (_side) do {
		case ("A"): {RydBBa_Urgent = true};
		case ("B"): {RydBBb_Urgent = true};
	};
		
	if not (RydBB_Active) exitWith {};

	if (RydBB_Debug) then
		{
			{
			deleteMarker _x
			}
		foreach (_marksT + [_m])
		};

	if not (isNull _HQ) then {_HQ setVariable ["PathDone",true]; _HQ setvariable ["RydHQ_NObj",5]};
};

RYD_ReserveExecuting = 
	{
	_SCRname = "ReserveExecuting";
	
	private ["_HQpos","_angle","_dst","_dstF","_dDst","_stancePos","_fG","_val","_forGarr","_ct","_ct2","_garrison","_task","_hMany","_busy","_Wpos","_mark","_wp","_aheadL",
	"_aliveHQ","_assg","_possPos","_enV","_posArr","_enV2","_nr","_sX","_sY","_dstA","_amnt","_actT","_maxT","_poss","_m","_rColor","_frontPos"];
	params ["_HQ","_ahead","_o1","_o2","_o3","_o4","_allied","_front","_taken","_hostileG","_side"];
	//leader units - _allied
	_HQpos = getPosATL (vehicle (leader _HQ));


	_frontPos = _HQpos;
	if ((count _ahead) > 0) then 
		{
		_aheadL = _ahead select (floor (random (count _ahead)));
		_aliveHQ = true;
		switch (true) do
			{
			case (isNull _HQ) : {_aliveHQ = false};
			case (({alive _x} count (units _HQ)) < 1) : {_aliveHQ = false};
			case not (RydBB_Active) : {_alive = false};
			};

		if (_aliveHQ) then
			{
			_frontPos = getPosATL (vehicle (leader _aheadL))
			}
		};

	_dst = _HQpos distance _frontPos;

	_dDst = 1000 + (random 1000);

	_dstF = _dst - _dDst;
	if (_dstF < 0) then {_dstF = _dst/2};

	_angle = [_HQpos,_frontPos,10] call RYD_AngTowards;

	if (_angle < 0) then {_angle = _angle + 360};

	_angle = _angle + 180;

	_stancePos = [_frontPos,_angle,_dstF] call RYD_PosTowards2D;

	_stancePos = [(_stancePos select 0),(_stancePos select 1),0];
	if (surfaceIsWater [(_stancePos select 0),(_stancePos select 1)]) then {_stancePos = _HQpos};

	_AAO = _HQ getVariable ["RydHQ_ChosenAAO",false];

	_garrison = _HQ getVariable ["RydHQ_Garrison",[]];
	_fG = (_HQ getVariable ["RydHQ_NCrewInfG",[]]) - ((_HQ getVariable ["RydHQ_Exhausted",[]]) + (_garrison));

	_fG = _fG - [_HQ];

		{
		if ((count _x) < 5) then {_x set [4,false]};
		if not (_x select 4) then
			{
			_Wpos = _x select 0;
			_val = _x select 1;
			if (_val > 5) then {_val = 5};
			_hMany = floor ((_val/10) * (count _fG));

			//if (_hMany > (ceil (_val/2))) then {_hMany = ceil (_val/2)};
			if (_hMany > 2) then {_hMany = 2};
			//if ((_hMany == 0) and ((random 100) > (90 - (count _fG)))) then {_hMany = 1};

			_ct = 0;

			while {((_ct < _hMany) and ((count _fG) > 0))} do
				{
				_ct = _ct + 1;
				_forGarr = _fG select (floor (random (count _fG)));
				_busy = _forGarr getVariable ("Busy" + (str _forGarr));
				_Unable = _forGarr getVariable ["Unable",false];
				if (isNil "_busy") then {_busy = false};

				_ct2 = 0;

				while {(_busy) and (_ct2 <= (count _fG))} do
					{
					_ct2 = _ct2 + 1;
					_forGarr = _fG select (floor (random (count _fG)));
					_busy = _forGarr getVariable ("Busy" + (str _forGarr));
					if (isNil "_busy") then {_busy = false};
					};

				if (not (_busy) and not (_Unable)) then
					{
					_x set [4,true];
					_fG = _fG - [_forGarr];

					_code =
						{
						_SCRname = "ReserveExecutingC1";
						
						private ["_timer","_alive","_task","_form","_wp"];
						params ["_unitG","_garrison","_Wpos"];

						_form = "DIAMOND";
						if (isPlayer (leader _unitG)) then {_form = formation _unitG};
						_unitG setVariable ["Busy" + (str _unitG),true];

						if not (isPlayer (leader _unitG)) then {if ((random 100) < RydxHQ_AIChatDensity) then {[(leader _unitG),RydxHQ_AIC_OrdConf,"OrdConf"] call RYD_AIChatter}};

						_task = [(leader _unitG),["Reach the designated position.", "Move", ""],_Wpos] call RYD_AddTask;

						[_unitG] call RYD_WPdel;

						_wp = [_unitG,_Wpos,"MOVE","AWARE","YELLOW","NORMAL",["true","deletewaypoint [(group this), 0]"],true,250,[0,0,0],_form] call RYD_WPadd;
						private _WaitCarrier = objNull;
						_WaitCarrier setVariable ["_continueAW",false];
						[_unitG,6,true,0,30,[],false,_WaitCarrier] call RYD_Wait; 
						waitUntil {_WaitCarrier getVariable ["_continueAW",false];}; 
						_WaitCarrier setVariable ["_continueAW",false];
						_timer = _WaitCarrier getVariable "_timer";
						_alive = _WaitCarrier getVariable "_alive";


						if not (_alive) exitwith {};
						if (_timer > 30) then {[_unitG, (currentWaypoint _unitG)] setWaypointPosition [position (vehicle (leader _unitG)), 1]};

						if ((isPlayer (leader _unitG)) and not (isMultiplayer)) then {(leader _unitG) removeSimpleTask _task};

						if not (_timer > 30) then {_garrison pushBack _unitG};
						};
						
					[_forGarr,_garrison,_Wpos] call _code;
					}
				}
			}
		}
	foreach _taken;
	
	_middlePos = [((_HQpos select 0) + (_StancePos select 0))/2,((_HQpos select 1) + (_StancePos select 1))/2,0];
	_closeMid = false;

	if ((count _hostileG) > 0) then
		{
		_assg = [];
		_possPos = [];

			{
			if not (_x in _assg) then
				{
				_enV = vehicle (leader _x);
				_posArr = [];

					{
					_enV2 = vehicle (leader _x);

					if ((_enV distance _enV2) < 600) then 
						{
						_posArr pushBack (getPosATL _enV2);
						_assg pushBack _x;			
						}				
					}
				foreach _hostileG;

				_nr = count _posArr;

				if (_nr > 0) then
					{
					_sX = 0;
					_sY = 0;

						{
						_sX = _sX + (_x select 0);
						_sY = _sY + (_x select 1);
						}
					foreach _posArr;
					
					_poss = [[_sX/_nr,_sY/_nr,0],_nr];
					if not (surfaceIsWater [_sX/_nr,_sY/_nr]) then {_possPos pushBack _poss}
					};
					
				if ((_enV distance _middlePos) < 600) then 
					{
					_closeMid = true		
					};	
				};
			}
		foreach _hostileG;

		_stancePos = (_possPos select 0) select 0;
		_maxT = 0;

			{
			_dstA = (_x select 0) distance _HQpos;
			_amnt = _x select 1;
			_actT = (_amnt/((_dstA/1000) * (_dstA/1000))) * (0.5 + (random 0.5) + (random 0.5));

			if (_actT > _maxT) then
				{
				_maxT = _actT;
				_stancePos = _x select 0;
				}

			}
		foreach _possPos
		};

		{
		_x setPosATL _stancePos;
		if not (_AAO) then
			{
			_x setVariable [("Capturing" + (str _x) + (str _HQ)),[0,0]];
			}
		}
	foreach [_o1,_o2,_o3,_o4];
	
	_HQ setVariable ["RydHQ_NObj",1];
	_HQ setVariable ["RydHQ_Taken",[]]; 
	_HQ setVariable ["ObjInit",true];
	
	[_HQ] call RYD_WPdel;
	
	_HQnewPos = _StancePos;
	
	if ((count _hostileG) > 0) then
		{	
		_HQnewPos = _middlePos;
		
		if (_closeMid) then
			{
			_HQnewPos = _HQpos
			};
		};
	
	_wp = [_HQ,_HQnewPos,"HOLD","AWARE","GREEN","LIMITED",["true",""],true,50,[0,0,0],"FILE"] call RYD_WPadd;

	if (RydBB_Debug) then
		{
		_m = _HQ getVariable "ResMark";
		if (isNil "_m") then 
			{
			_rColor = switch (side _HQ) do
				{
				case (west) : {"colorBLUFOR"};
				case (east) : {"colorOPFOR"};
				default {"colorIndependent"};
				};
			_m = [_StancePos,_HQ,"markBBCurrent",_rColor,"ICON","mil_triangle","Reserve area for " + (str (leader _HQ)),"",[0.5,0.5]] call RYD_Mark;
			_HQ setVariable ["ResMark",_m]
			}
		else
			{
			_m setMarkerPos _StancePos
			};
		};
	};

RYD_ObjectivesMon = 
	{
	_SCRName = "ObjectivesMon";
	
	private ["_isTaken","_AllV","_Civs","_AllV2","_Civs2","_NearAllies","_NearEnemies","_trg","_AllV0","_AllV20","_mChange","_enArea","_enPos","_BBProg","_SideAllies","_SideEnemies"];
	params ["_area","_BBSide","_HQ","_HQs"];
	

	while {(RydBB_Active)} do
		{
		sleep 15;//60
		if not (RydBB_Active) exitWith {};

		_SideAllies = [];
		_SideEnemies = [];

		{
			if (((side _HQ) getFriend _x) >= 0.6) then {_SideAllies pushBack _x} else {_SideEnemies pushBack _x};
		} foreach [west,east,resistance];

			{
			_isTaken = _x select 2;
			_trg = _x select 0;

			_trg = [_trg select 0,_trg select 1,0];

			if (_isTaken) then
				{
				_AllV = _trg nearEntities [["AllVehicles"],500];
				_Civs = _trg nearEntities [["Civilian"],500];
				_AllV2 = _trg nearEntities [["AllVehicles"],300];
				_Civs2 = _trg nearEntities [["Civilian"],300];

				_AllV = _AllV - _Civs;
				_AllV2 = _AllV2 - _Civs2;

				_AllV0 = _AllV;
				_AllV20 = _AllV2;

					{
					if not (_x isKindOf "Man") then
						{
						if ((count (crew _x)) == 0) then {_AllV = _AllV - [_x]}
						else {_AllV = _AllV - [_x] + (crew _x)};
						}
					}
				foreach _AllV0;

					{
					if not (_x isKindOf "Man") then
						{
						if ((count (crew _x)) == 0) then {_AllV2 = _AllV2 - [_x]}
						else {_AllV2 = _AllV2 - [_x] + (crew _x)};
						}
					}
				foreach _AllV20;

				//_NearAllies = (leader _HQ) countfriendly _AllV;
				_NearAllies = ({(side _x) in _SideAllies} count _AllV);
				//_NearEnemies = (leader _HQ) countenemy _AllV2;
				_NearEnemies = ({(side _x) in _SideEnemies} count _AllV2);

				if (_NearAllies < _NearEnemies) then 
					{
					_x set [2,false];
					if (_BBSide == "A") then {RydBBa_Urgent = true} else {RydBBb_Urgent = true};

					_mChange = 10/(count _HQs);

						{
						_morale = _x getVariable ["RydHQ_Morale",0];
						_x setVariable ["RydHQ_Morale",_morale - _mChange]
						}
					foreach _HQs
					}
				}
			else
				{
				_AllV = _trg nearEntities [["AllVehicles"],300];
				_Civs = _trg nearEntities [["Civilian"],300];
				_AllV2 = _trg nearEntities [["AllVehicles"],500];
				_Civs2 = _trg nearEntities [["Civilian"],500];

				_AllV = _AllV - _Civs;
				_AllV2 = _AllV2 - _Civs2;

				_AllV0 = _AllV;
				_AllV20 = _AllV2;

					{
					if not (_x isKindOf "Man") then
						{
						if ((count (crew _x)) == 0) then {_AllV = _AllV - [_x]}
						else {_AllV = _AllV - [_x] + (crew _x)};
						}
					}
				foreach _AllV0;

					{
					if not (_x isKindOf "Man") then
						{
						if ((count (crew _x)) == 0) then {_AllV2 = _AllV2 - [_x]}
						else {_AllV2 = _AllV2 - [_x] + (crew _x)};
						}
					}
				foreach _AllV20;

				//_NearAllies = (leader _HQ) countfriendly _AllV;
				_NearAllies = ({(side _x) in _SideAllies} count _AllV);
				//_NearEnemies = (leader _HQ) countenemy _AllV2;
				_NearEnemies = ({(side _x) in _SideEnemies} count _AllV2);

				if ((_NearAllies >= (_HQ getVariable ["RydHQ_CaptLimit",10])) and (_NearEnemies <= (0 + (((_HQ getVariable ["RydHQ_Recklessness",0.5])/(0.5 + (_HQ getVariable ["RydHQ_Consistency",0.5])))*10)))) then 
					{
					_x set [2,true];

					_enArea = missionNameSpace getVariable ["B_SAreas",[]];
					if (_BBSide == "B") then {_enArea = missionNameSpace getVariable ["A_SAreas",[]]};

						{
						_x params ["_enPos"];
						_enPos = [_enPos select 0,_enPos select 1,0];
						if (((_enPos distance _trg) < 50) and {(_x select 2)}) exitWith
							{
							_x set [2,false]
							}
						}
					foreach _enArea;

					if (_BBSide == "A") then {RydBBb_Urgent = true} else {RydBBa_Urgent = true};

					_mChange = 20/(count _HQs);

						{
						_morale = _x getVariable ["RydHQ_Morale",0];
						_x setVariable ["RydHQ_Morale",_morale + _mChange]
						}
					foreach _HQs
					}
				}
			}
		foreach _area
		}
	};

RYD_ObjMark = 
	{
	_SCRName = "ObjMark";
	params ["_strArea","_BBSide"];
	
	_clA = switch (side (RydBBa_HQs select 0)) do
		{
		case (west) : {"colorBLUFOR"};
		case (east) : {"colorOPFOR"};
		default {"colorIndependent"};
		};
		
	_clB = switch (side (RydBBb_HQs select 0)) do
		{
		case (west) : {"colorBLUFOR"};
		case (east) : {"colorOPFOR"};
		default {"colorIndependent"};
		};
	
	_markers = [];

		{
		_posStr = _x select 0;
		_valStr = _x select 1;
		_taken = _x select 2;
		_mark = "StrArea" + (str (random 1000));
		_color = "ColorCivilian";
		_alpha = 0.1;

		if ((_taken) and (_BBSide == "A")) then {_color = _clA;_alpha = 0.5};
		if ((_taken) and (_BBSide == "B")) then {_color = _clB;_alpha = 0.5};
		_mark = [_mark,_posStr,_color,"ICON",[_valStr/2,_valStr/2],0,_alpha,"mil_dot",(str _valStr)] call RYD_Marker;
		_markers pushBack _mark	
		}
	foreach _strArea;

	while {((RydBB_Active) and (RydBB_Debug))} do
		{
		sleep 10;
		if not (RydBB_Active) exitWith {};

			{
			_obj = _x;
			_taken = _obj select 2;
			_color = "ColorCivilian";
			_alpha = 0.1;

			if ((_taken) and (_BBSide == "A")) then {_color = _clA;_alpha = 0.5};
			if ((_taken) and (_BBSide == "B")) then {_color = _clB;_alpha = 0.5};

			_mark = _markers select _foreachIndex;

			_mark setMarkerColor _color;
			_mark setMarkerAlpha _alpha;			
			}
		foreach _strArea;
		};			
	};

RYD_ClusterA = 
	{
	private ["_clusters","_checked","_newCluster","_point","_sum"];
	params ["_points","_range"];

	_clusters = [];
	_checked = [];
	_newCluster = [];

	//_points2 = +_points;

		{
		_sum = (_x select 0) + (_x select 1);
		if not (_sum in _checked) then
			{
			_checked pushBack _sum;
			_point = _x;
			_newCluster = [_point];

				{
				_sum = (_x select 0) + (_x select 1);
				if not (_sum in _checked) then
					{
					if ((_point distance _x) <= _range) then 
						{
						_checked pushBack _sum;
						_newCluster pushBack _x;
						}
					}
				}
			foreach _points;

			_clusters pushBack _newCluster
			}
		}
	foreach _points;

	_clusters
	};

RYD_ClusterB = 
	{
	private ["_clusters","_point","_sumC","_sumS","_sumMin","_pointMin","_dstMin","_sum","_dstAct","_added","_cluster","_inside"];
	params ["_points"];

	_clusters = [];

		{
		_point = _x;
		_sumC = (_point select 0) + (_point select 1);

		_added = false;
		_inside = false;

			{
				{
				_sum = (_x select 0) + (_x select 1);
				if (_sum == _sumC) exitWith {_inside = true}
				}
			foreach _x;

			if (_inside) exitWith {}
			}
		foreach _clusters;

		if not (_inside) then
			{
			_sumMin = _sumC;
			_pointMin = _point;
			_dstMin = 100000;

				{
				_sum = (_x select 0) + (_x select 1);

				if not (_sumC == _sum) then
					{
					_dstAct = _point distance _x;
					if (_dstAct < _dstMin) then
						{
						_dstMin = _dstAct;
						_pointMin = _x;
						_sumMin = _sum;
						}
					}
				}
			foreach _points;

				{
				_cluster = _x;

					{
					_sumS = (_x select 0) + (_x select 1);
					if (_sumS == _sumMin) exitWith 
						{
						_added = true;
						_cluster pushBack _point
						};
					}
				foreach _cluster;

				if (_added) exitWith {}
				}
			foreach _clusters;

			if not (_added) then 
				{
				_clusters pushBack [_point,_pointMin];
				};
			}
		}
	foreach _points;

	_clusters
	};

RYD_Cluster = 
	{
	private ["_clusters","_centers","_cluster","_midX","_midY","_center","_clustersC","_newClusters","_newCluster","_clusterNearby","_centerC"];
	params ["_points"];


	_clusters = [_points] call RYD_ClusterB;

	_centers = [];


		{
		_cluster = _x;	

		_midX = 0;
		_midY = 0;

			{
			_midX = _midX + (_x select 0);
			_midY = _midY + (_x select 1);
			}
		foreach _cluster;

		_center = [_midX/(count _cluster),_midY/(count _cluster),0];
		_centers pushBack _center;
		}
	foreach _clusters;

	_clusters pushBack _centers;

	_clustersC = [_centers,500] call RYD_ClusterA;

	_newClusters = [];

		{
		_newCluster = [];
		_clusterNearby = [];

			{
			_centerC = _x;

				{
				if (((_centers select _foreachIndex) select 0) == (_centerC select 0)) then {_clusterNearby pushBack (_clusters select _foreachIndex)}
				}
			foreach _clusters
			}
		foreach _x;

			{
				{
				_newCluster pushBack _x
				}
			foreach _x
			}
		foreach _clusterNearby;

		_newClusters pushBack _newCluster
		}
	foreach _clustersC;

	_clusters = _newClusters;

	_clusters
	};

RYD_isOnMap = 
	{
	private ["_onMap","_mapMinX","_mapMinY"];
	params ["_pos"];

	_onMap = true;
	_pos params ["_pX","_pY"];

	_mapMinX = 0;
	_mapMinY = 0;

	if not (isNil "RydBB_MC") then
		{
		_mapMinX = RydBB_MapXMin;
		_mapMinY = RydBB_MapYMin;
		};

	if (_pX < _mapMinX) then 
		{
		_onMap = false;
		}
	else
		{
		if (_pY < _mapMinY) then
			{
			_onMap = false;
			}
		else
			{
			if (_pX > RydBB_MapXMax) then
				{
				_onMap = false;
				}
			else
				{
				if (_pY > RydBB_MapYMax) then
					{
					_onMap = false;
					}
				}
			}
		};

	_onMap
	};

RYD_BBSimpleD = 
	{
	private ["_clusters","_enPos","_ens","_centers","_center","_amounts","_amount","_midX","_midY","_frs","_frCenters","_frCenter","_lPos","_lng","_angle","_arrow","_colorArr","_mainCenter",
	"_amounts","_amount","_battles","_battle","_angleBatt","_tooClose","_mPos","_mSize","_dstAct","_colorBatt","_sizeBatt","_oldSize","_HQPosMark","_HQ"];
	params ["_HQs","_BBSide"];

	sleep 60;

	while {(({not (isNull _x)} count _HQs) > 0)} do
		{
		if (({not (isNull _x)} count _HQs) == 0) exitWith {};
		if not (RydBB_Active) exitWith {};

		_enPos = [];
		_frCenters = [];

			{
			_HQ = _x;
			_alive = true;
			
			switch (true) do
				{
				case (isNil "_HQ") : {_alive = false};
				case (isNull _HQ) : {_alive = false};
				case (({alive _x} count (units _HQ)) < 1) : {_alive = false};
				};			
			
			if (_alive) then
				{
				_ens = _x getVariable ["RydHQ_KnEnPos",[]];
				_frs = _x getVariable ["RydHQ_Friends",[]];

				_enPos = _enPos + _ens;
				
				_lPos = _x getVariable "LastCenter";
				_frCenter = getPosATL (vehicle (leader _x));
				if not (isNil "_lPos") then {_frCenter = _lPos};

				_midX = 0;
				_midY = 0;

					{
					_midX = _midX + ((getPosATL (vehicle (leader _x))) select 0);
					_midY = _midY + ((getPosATL (vehicle (leader _x))) select 1);
					}
				foreach _frs;

				if ((count _frs) > 0) then
					{
					if ([[_midX/(count _frs),_midY/(count _frs)]] call RYD_isOnMap) then 
						{
						_frCenter = [_midX/(count _frs),_midY/(count _frs),0]
						}
					else 
						{
						if (isNil "_lPos") then
							{
							_frCenter = getPosATL (vehicle (leader _x));
							}
						}
					};

				_x setVariable ["LastCenter",_frCenter];

				_frCenters pushBack _frCenter;

				_colorArr = switch (side _HQ) do
					{
					case (west) : {"colorBLUFOR"};
					case (east) : {"colorOPFOR"};
					default {"colorIndependent"};
					};
	
					if not (isNil "_lPos") then
					{
					_lng = _lPos distance _frCenter;

					if (_lng > 100) then
						{
						_angle = [_lPos,_frCenter,5] call RYD_AngTowards;

						_arrow = _x getVariable ["ArrowMark",""];

						if (_arrow == "") then 
							{
							_arrow = [_frCenter,_x,"markArrow",_colorArr,"ICON","mil_arrow","","",[({(({alive _x} count (units _x)) > 0)} count _frs)/10,_lng/500],_angle] call RYD_Mark;
							_x setVariable ["ArrowMark",_arrow];
							}
						else
							{
							_arrow setMarkerPos _frCenter;
							_arrow setMarkerDir _angle;
							_arrow setMarkerSize [({(({alive _x} count (units _x)) > 0)} count _frs)/10,_lng/500]
							}
						}
					};
					
				_HQPosMark = _x getVariable ["HQPosMark",""];
				if (_HQPosMark == "") then
					{
					_HQPosMark = [(getPosATL (vehicle (leader _x))),_x,"HQMark",_colorArr,"ICON","mil_box","Position of " + (str (leader _x)),"",[0.5,0.5]] call RYD_Mark;
					_x setVariable ["HQPosMark",_HQPosMark]
					}
				else
					{
					_HQPosMark setMarkerPos (getPosATL (vehicle (leader _x)));
					}
				}
			else
				{
				deleteMarker ("HQMark" + (str _x))
				}
			}
		foreach _HQs;

		_midX = 0;
		_midY = 0;

			{
			_midX = _midX + (_x select 0);
			_midY = _midY + (_x select 1);
			}
		foreach _frCenters;

		_mainCenter = [_midX/(count _HQs),_midY/(count _HQs),0];

		_clusters = [];

		if ((count _enPos) > 0) then {_clusters = [_enPos] call RYD_Cluster};

		_centers = [];
		_amounts = [];

			{
			_amount = count _x;

			if (_amount > 2) then
				{
				_midX = 0;
				_midY = 0;

					{
					_midX = _midX + (_x select 0);
					_midY = _midY + (_x select 1);
					}
				foreach _x;

				_centers pushBack [_midX/(count _x),_midY/(count _x),0];
				_amounts pushBack _amount;
				}
			}
		foreach _clusters;

		_battles = missionNamespace getVariable ["Battlemarks",[]];
		_battle = "";


			{
			_center = _x;
			if ([_center] call RYD_isOnMap) then
				{
				_tooClose = false;

					{
					_mPos = getMarkerPos _x;
					_mSize = getMarkerSize _x;
					_mSize = ((_mSize select 0) + (_mSize select 1)) * 100;
					_dstAct = _center distance _mPos;

					if (_mSize > _dstAct) exitWith {_tooClose = true;_battle = _x}
					}
				foreach _battles;

				_colorBatt = switch (side _HQ) do
					{
					case (west) : {"colorBLUFOR"};
					case (east) : {"colorOPFOR"};
					default {"colorIndependent"};
					};
				_sizeBatt = (_amounts select _foreachIndex)/6;
				if (_sizeBatt > 5) then {_sizeBatt = 5};

				_angleBatt = [_mainCenter,_x,0] call RYD_AngTowards;

				if not (_tooClose) then
					{
					_battle = [_x,(random 10000),"markBattle",_colorBatt,"ICON","mil_ambush","","",[_sizeBatt,_sizeBatt],_angleBatt - 90] call RYD_Mark;
					_battles pushBack _battle;
					missionNamespace setVariable ["Battlemarks",_battles];
					}
				else
					{
					_oldSize = getMarkerSize _battle;
					_oldSize = _oldSize select 0;
				
					if (_sizeBatt > _oldSize) then
						{
						_battle setMarkerColor _colorBatt;
						_battle setMarkerSize [_sizeBatt,_sizeBatt];
						_battle setMarkerDir (_angleBatt - 90)
						}
					}
				}
			}
		foreach _centers;

		sleep 300
		}
	};

