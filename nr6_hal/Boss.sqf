_SCRname = "Boss";

private 
	[
	"_cntr","_lng","_nmbr","_sectors","_markers","_mark","_secpos","_sPosX","_sPosY","_sUrban","_sForest","_sHills","_sFlat","_sSea","_samplePos","_topArr","_sRoads","_bbCycle",
	"_text","_nbr","_sum","_alpha","_count","_strArea","_loc10","_loc5","_loc2","_loc1","_locHill","_topArr","_frstV","_nmbr","_posGrpX","_sGr","_urgent",
	"_posGrpY","_posGrp","_valGrp","_armyPos","_ct","_change","_mainPos","_taken","_posStr","_valStr","_posStrX","_posStrY","_amDist","_mDist","_aDist","_gDst","_actDist","_BBStr",
	"_attackAxis","_color","_k","_j","_fAr","_fPnt","_fVal","_fTkn","_fX","_fY","_sAr","_sPnt","_sVal","_sTkn","_sX","_sY","_ForcesRep","_ownGroups","_hostileGroups",
	"_isCiv","_civF","_enemyClose","_allCount","_resCount","_actCount","_flankCount","_centerCount","_resArr","_chsn","_resDst","_dst","_centerArr","_centerDst","_allAreTaken",
	"_isLeft","_where","_isFlank","_isRear","_leftSectors","_rightSectors","_frontSectors","_leftAn","_leftInf","_leftVeh","_rightAn","_rightInf","_rightVeh","_frontAn","_BBSAL",
	"_frontInf","_frontVeh","_leftSANmbr","_rightSANmbr","_frontSANmbr","_leftSA","_rightSA","_frontSA","_leftSANmbr","_rightSANmbr","_frontSANmbr","_leftSpace","_rightSpace","_ctWait",
	"_frontSpace","_LmaxSpace","_RmaxSpace","_FmaxSpace","_LmaxSA","_RmaxSA","_FmaxSA","_LmaxVeh","_RmaxVeh","_FmaxVeh","_lFlank","_rFlank","_cFront","_flSMaxStr","_flSpace","_pathDone",
	"_flSAMaxStr","_flSA","_fl","_spaceF","_SAF","_flVMaxStr","_flVeh","_vehF","_vehAll","_ldrRep","_forceChar","_vehPerc","_vehAll","_vehAv","_moreVehHQ","_numAll","_forceNum",
	"_numAv","_moreNumHQ","_goingLeft","_goingRight","_goingAhead","_goingReserve","_restHQ","_ldr","_rndF","_leftNotTaken","_tkn","_rightNotTaken","_frontNotTaken","_fPos","_takenPoints",
	"_chosenT","_indx","_cPos","_cVal","_cTaken","_dstFC","_tempMax","_actT","_front","_tObj1","_tObj2","_tObj3","_tObj4","_areas","_sctrs","_pathRep","_tgtsAround","_HQpos","_HQPoints",
	"_acT","_points","_tempAct","_secsAround","_notTaken","_indx","_in","_check","_checkPos","_actPos","_losses","_currentNumber","_ownVal","_enemyVal","_enemyFactor","_lossesFactor","_actRep",
	"_nilStance","_stance","_inert","_knEnemy","_ownVal","_perDirPos","_dpX","_dpY","_dirAdd","_angle","_perPos","_perX","_perY","_BBalive","_HQ","_BBUnit","_leftFlankName",
	"_rightFlankName","_leftName","_rightName","_frontName","_isLeftName","_isFlankName","_isRearName","_centerFrontName","_xPr","_yPr","_objCount","_QH","_initD","_aliveHQ","_objRad",
	"_goingReserve0","_lastGLeft","_lastGRight","_lastGAhead","_aliveHQ","_newL","_lastGLeftN","_lastGRightN","_lastGAheadN","_fixedInitStatus","_pos","_enAr","_eA","_eP","_eT","_sA","_sP",
	"_strArea0","_k","_j","_flankOne","_goingOne","_flankTwo","_goingTwo","_resCand","_ctVal","_mapSize","_DEFpoints","_defPointsBB","_AAOPts","_goingOverall"
	];
params ["_BBHQs","_BBHQGrps"];
_BBHQs params ["_BBHQs","_BBSide"]; 

if ((_BBSide == "B") and ((count RydBBa_HQs) > 0)) then 
	{
	waitUntil
		{
		sleep 5;
		(RydBBa_Init)
		}
	};

if (RydBB_Debug) then
	{
	RydBBa_SAL globalChat format ["Big Boss %1 awakes (time: %2)",_BBSide,time];
	diag_log format ["Big Boss %1 awakes (time: %2)",_BBSide,time]
	};

	{
	waitUntil
		{
		sleep 0.1;
		_ready = _x getVariable ["RydHQ_readyForBB",false];
		(_ready)
		};
	}
foreach _BBHQGrps;

_cntr = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");

if (_BBSide == "A") then
	{
	if not (isNil "RydBB_MC") then
		{
		if ((typeName RydBB_MC) isEqualTo "OBJECT") then {_cntr = getPosATL RydBB_MC} else {_cntr = RydBB_MC};
		RydBB_MapC = _cntr;
		}
	else
		{
		_mapSize = getNumber (configFile >> "CfgWorlds" >> worldName >> "mapSize");
		
		RydBB_MapXMax = _mapSize;
		RydBB_MapYMax = RydBB_MapXMax;
		RydBB_MapC = [_mapSize/2,_mapSize/2];

		_cntr = RydBB_MapC
		};

	//if ((_cntr select 0) < 1000) then {_cntr = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition")};

	//_mark = "center" + str (random 1000);
	//_mark = [_mark,_cntr,"ColorBlue","ICON",[1.5,1.5],0,1,"DOT",(str _cntr)] call RYD_Marker;

	_lng = (_cntr select 0)*2;
	if not (isNil "RydBB_MC") then
		{
		if ((typeName RydBB_MC) isEqualTo "OBJECT") then
			{
			_lng = ((triggerArea RydBB_MC) select 0)*2
			}
		else
			{
			_lng = RydBB_MapLng
			};

		RydBB_MapXMax = (RydBB_MapC select 0) + _lng/2;
		RydBB_MapYMax = (RydBB_MapC select 1) + _lng/2;
		RydBB_MapXMin = (RydBB_MapC select 0) - _lng/2;
		RydBB_MapYMin = (RydBB_MapC select 1) - _lng/2;
		};

	_nmbr = round (_lng/500);

	missionNameSpace setVariable ["BattleF",[_cntr,_lng,_nmbr]];

	RydBB_Sectors = ([_cntr,_lng,0,_nmbr] call RYD_Sectorize) select 0;
	/*
	//_markers = [];
	
		{
		diag_log format ["Sector: %1",_x];
		//_mark = "sector" + str (random 1000);
		//_mark = [_mark,position _x,"ColorBlue","RECTANGLE",size _x,direction _x,1,"Border",""] call RYD_Marker;
		//_markers set [(count _markers),_mark];
		//_x setVariable ["Over_Mark",_mark];
		}
	foreach RydBB_Sectors;*/
	

	_nbr = 0;

	startloadingscreen ["Big Boss studies the map","RscDisplayLoadCustom"];
	if (RydBB_Debug) then {diag_log "Big Boss studies the map."};

		{
		_x setVariable ["BBSec",true];		

		_secpos = position _x;
		_secpos params ["_sPosX","_sPosY"];

		_sUrban = 0;
		_sForest = 0;
		_sHills = 0;
		_sFlat = 0;
		_sSea = 0;
		_sGr = 0;
		_count = 10;

		for "_i" from 1 to _count do
			{
			_samplePos = [_sPosX + ((random 500) - 250),_sPosY + ((random 500) - 250)];

			_topArr = [_samplePos,1] call RYD_TerraCognita;
			_topArr params ["_sU1","_sFo1","_sH1","_sFl1","_sS1","_sG1"]; 
			_sUrban = _sUrban + _sU1;
			_sForest = _sForest + _sFo1;
			_sHills = _sHills + _sH1;
			_sFlat = _sFlat + _sFl1;
			_sSea = _sSea + _sS1;
			_sGr = _sGr + _sG1;
			};

		_sUrban = round (_sUrban*100/_count);
		_sForest =  round (_sForest*100/_count);
		_sHills =  round(_sHills*100/_count);
		_sFlat =  round (_sFlat*100/_count);
		_sSea = round (_sSea*100/_count);
		_sGr = round (_sGr/_count);

		_x setVariable ["Topo_Urban",_sUrban];
		_x setVariable ["Topo_Forest",_sForest];
		_x setVariable ["Topo_Hills",_sHills];
		_x setVariable ["Topo_Flat",_sFlat];
		_x setVariable ["Topo_Sea",_sSea];
		_x setVariable ["Topo_Grd",_sGr * 10];

		_sRoads = count (_secpos nearRoads 250);

		_x setVariable ["Topo_roads",_sRoads];

		_mark = _x getVariable "Over_Mark";

		_nbr = _nbr + 1;
		_sum = count RydBB_Sectors;

		if not (isMultiplayer) then
			{
			progressLoadingScreen (_nbr/_sum)
			}
		}
	foreach RydBB_Sectors;
	endLoadingScreen;
	};


RydBB_mapReady = true;

_sectors = [];

_sectors = RydBB_Sectors;

_strArea = [];


if (RydBB_Debug) then
	{
	RydBBa_SAL globalChat format ["Big Boss %1 is looking for strategic objectives.",_BBSide];
	diag_log format ["Big Boss %1 is looking for strategic objectives.",_BBSide]
	};

_objRad = 25000;

_cntr = (missionNameSpace getVariable "BattleF") select 0;
_lng = (missionNameSpace getVariable "BattleF") select 1;

if not (isNil "RydBB_MC") then
	{
	_objRad = _lng/2
	};

_loc10 = nearestLocations [_cntr, ["NameCityCapital"], _objRad]; 
_loc5 = nearestLocations [_cntr, ["NameCity","Airport"], _objRad]; 
_loc2 = nearestLocations [_cntr, ["NameVillage"], _objRad]; 
_loc1 = nearestLocations [_cntr, ["BorderCrossing"], _objRad]; 
_locHill = nearestLocations [_cntr, ["Hill","ViewPoint"], _objRad]; 

	{
	_strArea pushBack [(position _x),10,false]
	}
foreach _loc10;

	{
	_strArea pushBack [(position _x),5,false]
	}
foreach _loc5;

	{
	_strArea pushBack [(position _x),2,false]
	}
foreach _loc2;

	{
	_strArea pushBack [(position _x),1,false]
	}
foreach _loc1;


	{
	_topArr = [(position _x),3] call RYD_TerraCognita;
	_frstV = _topArr select 1;
	if (_frstV > 0.25) then 
		{
		_strArea pushBack [(position _x),1,false]
		}
	else
		{
		_strArea pushBack [(position _x),2,false]
		}
	}
foreach _locHill;

_BBStr = [];

if (_BBSide == "A") then {if not (isNil "RydBBa_Str") then {_BBStr = RydBBa_Str}};
if (_BBSide == "B") then {if not (isNil "RydBBb_Str") then {_BBStr = RydBBb_Str}};

_fixedInitStatus = [];

	{
	_x params ["_pos"];
	_pos params ["_pos0","_pos1"];
	_pos = _pos0 + _pos1;

	_fixedInitStatus pushBack _pos
	}
foreach _BBStr;

_BBSAL = RydBBa_SAL;
if (_BBSide == "B") then {_BBSAL = RydBBb_SAL};

	{
	_vTkn = (_x getVariable ["AreaTakenA",false]);
	if (_BBSide == "B") then {_vTkn = (_x getVariable ["AreaTakenB",false])};
	if (!isNil {_x getVariable "AreaValue"}) then 
		{
			_BBStr pushBack [(position _x),_x getVariable "AreaValue",_vTkn];
		};
	}
foreach (synchronizedObjects _BBSAL);

_strArea = _strArea + _BBStr;

if (RydBB_CustomObjOnly) then {_strArea = _BBStr};


_strArea0 = [] + _strArea;

	{
	_fAr = _x;
	_k = _foreachIndex;
	_fAr params ["_fPnt","_fVal","_fTkn"];
	_fPnt params ["_fX","_fY"];

		{
		_sAr = _x;
		_j = _foreachIndex;
		_sAr params ["_sPnt","_sVal","_sTkn"];
		_sPnt params ["_sX","_sY"];

		if (((_fPnt distance _sPnt) < 400) and not ((_fPnt select 0) == (_sPnt select 0))) then 
			{
			
			if (_fVal > _sVal) then
				{
				_strArea set [_k,[[(_fX + _sX)/2,(_fY + _sY)/2,0],_fVal + _sVal,_fTkn]];
				_strArea set [_j,0]
				}
			else
				{
				_strArea set [_j,[[(_fX + _sX)/2,(_fY + _sY)/2,0],_fVal + _sVal,_sTkn]];
				_strArea set [_k,0]
				}
			}
		}
	foreach _strArea0
	}
foreach _strArea0;

_strArea = _strArea - [0];

_strArea0 = nil;

{ 
	if (isNil {_x select 1}) then {_strArea set [_foreachIndex,[_x select 0,5,_x select 2]]}
} foreach _strArea;


if not (isNil "Debug") then {Debug setVariable ["d",_strArea]};

switch (_BBSide) do
	{
	case ("A") : {missionNameSpace setVariable ["A_SAreas",_strArea]};
	case ("B") : {missionNameSpace setVariable ["B_SAreas",_strArea]};
	};
	
////////////////////////////////////////////////////////////////////

_bbCycle = 0;
_leftSA = [];
_rightSA = [];
_frontSA = [];
_stance = "";

_leftFlankName = "LeftFlank";
_rightFlankName = "RightFlank";
_centerFrontName = "CenterFront";
_leftName = "A_Left";
_rightName = "A_Right";
_frontName = "A_Front";
_isLeftName = "A_isLeft";
_isFlankName = "A_isFlank";
_isRearName = "A_isRear";

if (_BBSide == "B") then 
	{
	_leftFlankName = "LeftFlankB";
	_rightFlankName = "RightFlankB";
	_centerFrontName = "CenterFrontB";
	_leftName = "B_Left";
	_rightName = "B_Right";
	_frontName = "B_Front";
	_isLeftName = "B_isLeft";
	_isFlankName = "B_isFlank";
	_isrearName = "B_isRear";
	};

_mainPos = _cntr;
_BBalive = true;
_allAreTaken = true;

while {(RydBB_Active)} do
	{
	if not (_BBalive) exitWith 
		{
		if (RydBB_Debug) then
			{
			RydBBa_SAL globalChat format ["Big Boss %1 has no army!",_BBSide];
			diag_log format ["Big Boss %1 has no army!",_BBSide]
			};
		};
/*
	waitUntil 
		{
		sleep 5;
*/
		_allAreTaken = true;

			{
			if not (_x select 2) exitWith {_allAreTaken = false}
			}
		foreach _strArea;

		//not (_allAreTaken)
		//};

	_bbCycle = _bbCycle + 1;

	if (_bbCycle == 1) then
		{
		_code =
			{
			_SCRName = "BossC1";
			
			private ["_HQg","_side","_HQg0"];

			_HQg = _this select 0;
			_side = _this select 1;	

			_HQg0 = +_HQg;

			while {(RydBB_Active)} do
				{
					{
					if (isNull (group _x)) then
						{
						_HQg = _HQg - [_x]
						}
					else 
						{
						if (({(alive _x)} count (units (group _x))) == 0) then
							{
							_HQg = _HQg - [_x]
							}
						}
					}
				foreach _HQg0;

				if ((count _HQg) == 0) exitWith 
					{
					if (RydBB_Debug) then
						{
						RydBBa_SAL globalChat format ["Big Boss %1 has no army!",_side];
						diag_log format ["Big Boss %1 has no army!",_side]
						};
					};

				sleep 10;
				};
			};
			
		[_BBHQs,_BBSide] call _code;
		};

	_BBHQs = [];

		{
		if not (isNull _x) then 
			{
			if (({(alive _x)} count (units _x)) > 0) then
				{
				_BBHQs pushBack (leader _x)
				}
			};
		}
	foreach _BBHQGrps;

	if ((count _BBHQs) == 0) exitWith 
		{
		if (RydBB_Debug) then
			{
			RydBBa_SAL globalChat format ["Big Boss %1 has no army!",_BBSide];
			diag_log format ["Big Boss %1 has no army!",_BBSide]
			};
		};

	if (RydBB_Debug) then
		{
		RydBBa_SAL globalChat format ["Big Boss %1 is analyzing forces...",_BBSide];
		diag_log format ["Big Boss %1 is analyzing forces...",_BBSide]
		};

	_ForcesRep = [_BBHQGrps] call RYD_ForceAnalyze;

	_ownGroups = (_ForcesRep select 0) select ((count (_ForcesRep select 0)) - 1);
	_hostileGroups = (_ForcesRep select 1) select ((count (_ForcesRep select 1)) - 1);

	if (_BBCycle == 1) then
		{
		if (RydBB_Debug) then
			{
			RydBBa_SAL globalChat format ["Big Boss %1 is checking own forces placement...",_BBSide];
			diag_log format ["Big Boss %1 is checking own forces placement...",_BBSide]
			};

		_nmbr = 0;
		_posGrpX = 0;
		_posGrpY = 0;

			{
			_posGrp = position (vehicle (leader _x));
			_valGrp = count (units _x);

			//_mark = "GrpPos" + (str (random 1000));
			//_mark = [_mark,_posGrp,"ColorGreen","ICON",[_valGrp/10,_valGrp/10],0,0.5,"DOT",(str _valGrp)] call RYD_Marker;

			for "_j" from 1 to _valGrp do
				{
				_posGrpX = _posGrpX + (_posGrp select 0);
				_posGrpY = _posGrpY + (_posGrp select 1);
				};

			_nmbr = _nmbr + _valGrp
			}
		foreach _ownGroups;

		_armyPos = _cntr;

		if (_nmbr > 0) then {_armyPos = [_posGrpX/_nmbr,_posGrpY/_nmbr,0]};

		//_mark = "Army" + (str (random 1000));
		//_mark = [_mark,_ArmyPos,"ColorGreen","ICON",[1,1],0,1,"mil_triangle",""] call RYD_Marker;


		_ct = 0;
		_change = true;

		_enAr = missionNameSpace getVariable ["B_SAreas",[]];
		if (_BBSide == "B") then {_enAr = missionNameSpace getVariable ["A_SAreas",[]]};

		while {(_change)} do
			{
			_nmbr = 0;
			_posStrX = 0;
			_posStrY = 0;

				{
				_taken = _x select 2;

				if not (_taken) then 
					{
					_x params ["_posStr","_valStr"];

					for "_j" from 1 to _valStr do
						{
						_posStrX = _posStrX + (_posStr select 0);
						_posStrY = _posStrY + (_posStr select 1);
						};

					_nmbr = _nmbr + (_x select 1)
					}
				}
			foreach _strArea;

			if (_nmbr > 0) then {_mainPos = [_posStrX/_nmbr,_posStrY/_nmbr,0]};

			_amDist = _armyPos distance _mainPos;

			_change = false;

			_civF = ["CIV_F","CIV","CIV_RU","BIS_TK_CIV","BIS_CIV_special"];
			if not (isNil ("RydBB_CivF")) then {_civF = RydBB_CivF};

				{
				_x params ["_posStr","_valStr","_taken"];

				_mDist = _posStr distance _mainPos;
				_aDist = _posStr distance _ArmyPos;

				_enemyClose = false;

					{
					if (((side _x) getFriend (side (_ownGroups select 0))) < 0.6) then
						{
						_isCiv = false;
						if ((faction (leader _x)) in _civF) then {_isCiv = true};
						if not (_isCiv) then
							{
							if (((vehicle (leader _x)) distance _posStr) < 500) exitwith {_enemyClose = true}
							}
						};

					if (_enemyClose) exitwith {}
					}
				foreach (Allgroups - _ownGroups);

				_gDst = 1000000;
				
					{
					_actDist = (vehicle (leader _x)) distance _posStr;
					if (_actDist < _gDst) then {_gDst = _actDist}
					}
				foreach _ownGroups;

				if (RydBB_CustomObjOnly) then 
				
					{
					if ((((_mDist > _amDist) and (_mDist > _aDist) and (_amDist > _aDist) and (_aDist < 1000000)) or (_gDst < 500) or (_aDist < 1000)) and not (_enemyClose)) then 
						{
						if not (_taken) then {_change = true};
						_x params ["_pos"];
						_pos params ["_pos0","_pos1"];
						_pos = _pos0 + _pos1;
						if not (_pos in _fixedInitStatus) then {_x set [2,true]};
						}
					else
						{
						if (_taken) then {_change = true};
						_x params ["_pos"];
						_pos params ["_pos0","_pos1"];
						_pos = _pos0 + _pos1;
						if not (_pos in _fixedInitStatus) then {_x set [2,false]};
						}

					} else {

					if ((((_mDist > _amDist) and (_mDist > _aDist) and (_amDist > _aDist) and (_aDist < 5000)) or (_gDst < 500) or (_aDist < 1000)) and not (_enemyClose)) then 
						{
						if not (_taken) then {_change = true};
						_x params ["_pos"];
						_pos params ["_pos0","_pos1"];
						_pos = _pos0 + _pos1;
						if not (_pos in _fixedInitStatus) then {_x set [2,true]};
						}
					else
						{
						if (_taken) then {_change = true};
						_x params ["_pos"];
						_pos params ["_pos0","_pos1"];
						_pos = _pos0 + _pos1;
						if not (_pos in _fixedInitStatus) then {_x set [2,false]};
						}
					}
				}
			foreach _strArea;

			_ct = _ct + 1;

			if (_ct > 10) then {_change = false}
			};

		if ((count _enAr) > 0) then
			{
				{
				_eA = _x;
				_eA params ["_eP"];
				_eT = _eA select 2;

					{
					_sA = _x;
					_sA params ["_sP"];

					if ((_sP distance _eP) < 100) then
						{
						if (_eT) then
							{
							_sA set [2,false];
							}
						}
					}
				foreach _strArea
				}
			foreach _enAr
			};


		//_mark = "Main" + (str (random 1000));
		//_mark = [_mark,_mainPos,"ColorRed","ICON",[1,1],0,1,"mil_triangle",""] call RYD_Marker;

		_attackAxis = [_ArmyPos,_mainPos,10] call RYD_AngTowards;

		if (RydBB_Debug) then
			{			
			[_strArea,_BBSide] call RYD_ObjMark;
			};
			
		if (RydBB_Debug) then
			{
			RydBBa_SAL globalChat format ["Big Boss %1 orients the flanks.",_BBSide];
			diag_log format ["Big Boss %1 orients the flanks.",_BBSide];
			};

			{
			_isLeft = ([(getPosATL (vehicle (leader _x))),_ArmyPos,_attackAxis] call RYD_WhereIs) select 0;
			_x setVariable ["isLeft",_isLeft]
			}
		foreach _BBHQGrps;

			{
			_isLeft = ([(_x select 0),_ArmyPos,_attackAxis] call RYD_WhereIs) select 0;
			_x set [3,_isLeft]
			}
		foreach _strArea;



		_leftSectors = [];
		_rightSectors = [];
		_frontSectors = [];

			{
			_where = [(position _x),_ArmyPos,_attackAxis] call RYD_WhereIs;
			_where params ["_isLeft","_isFlank","_isRear"];

			if (_isLeft) then 
				{
				_leftSectors pushBack _x
				} 
			else 
				{
				_rightSectors pushBack _x
				};

			if not (_isFlank) then 
				{
				_frontSectors pushBack _x
				};

			_x setVariable [_isLeftName,_isLeft];
			_x setVariable [_isFlankName,_isFlank];
			_x setVariable [_isRearName,_isRear];
			}
		foreach _sectors;

		if (RydBB_Debug) then
			{
			RydBBa_SAL globalChat format ["Big Boss %1 assigns front sections to divisions.",_BBSide];
			diag_log format ["Big Boss %1 assigns front sections to divisions.",_BBSide]
			};

		_leftAn = [_leftSectors] call RYD_TopoAnalize;
		_leftAn params ["_leftSectors","_leftInf","_leftVeh"];

		_rightAn = [_rightSectors] call RYD_TopoAnalize;
		_rightAn params ["_rightSectors","_rightInf","_rightVeh"];


		_frontAn = [_frontSectors] call RYD_TopoAnalize;
		_frontAn params ["_frontSectors","_frontInf","_frontVeh"];

		_leftSANmbr = 0;
		_rightSANmbr = 0;
		_frontSANmbr = 0;
		_leftSA = [];
		_rightSA = [];
		_frontSA = [];

			{
			_where = [(_x select 0),_ArmyPos,_attackAxis] call RYD_WhereIs;
			_isLeft = _where select 0;
			_isFlank = _where select 1;
			_isRear = _where select 2;

			if (_isFlank) then
				{
				if (_isLeft) then 
					{
					_x set [3,_leftName];
					_leftSA pushBack _x;
					_leftSANmbr = _leftSANmbr + 1
					} 
				else 
					{
					_x set [3,_rightName];
					_rightSA pushBack _x;
					_rightSANmbr = _rightSANmbr + 1
					}
				}
			else
				{
				_x set [3,_frontName];
				_frontSA pushBack _x;
				_frontSANmbr = _frontSANmbr + 1
				}
			}
		foreach _strArea;

		_leftSpace = count _leftSectors;
		_rightSpace = count _rightSectors;
		_frontSpace = count _frontSectors;

		_LmaxSpace = false;
		_RmaxSpace = false;
		_FmaxSpace = false;

		_LmaxSA = false;
		_RmaxSA = false;
		_FmaxSA = false;

		_LmaxVeh = false;
		_RmaxVeh = false;
		_FmaxVeh = false;

		switch (true) do
			{
			case ((_leftSpace >= _rightSpace) and (_leftSpace >= _frontSpace)) : {_LmaxSpace = true};
			case ((_rightSpace >= _leftSpace) and (_rightSpace >= _frontSpace)) : {_RmaxSpace = true};
			case ((_frontSpace >= _leftSpace) and (_frontSpace >= _rightSpace)) : {_FmaxSpace = true};
			};

		switch (true) do
			{
			case (((count _leftSA) >= (count _rightSA)) and ((count _leftSA) >= (count _frontSA))) : {_LmaxSA = true};
			case (((count _rightSA) >= (count _leftSA)) and ((count _rightSA) >= (count _frontSA))) : {_RmaxSA = true};
			case (((count _frontSA) >= (count _leftSA)) and ((count _frontSA) >= (count _rightSA))) : {_FmaxSA = true};
			};

		switch (true) do
			{
			case ((_leftVeh >= _rightVeh) and (_leftVeh >= _frontVeh)) : {_LmaxVeh = true};
			case ((_rightVeh >= _leftVeh) and (_rightVeh >= _frontVeh)) : {_RmaxVeh = true};
			case ((_frontVeh >= _leftVeh) and (_frontVeh >= _rightVeh)) : {_FmaxVeh = true};
			};

		missionNamespace setVariable [_leftFlankName,[_leftSectors,_LmaxSpace,_LmaxSA,_LmaxVeh,_leftSpace,_leftSA,_leftInf,_leftVeh]];
		missionNamespace setVariable [_rightFlankName,[_rightSectors,_RmaxSpace,_RmaxSA,_RmaxVeh,_rightSpace,_rightSA,_rightInf,_rightVeh]];
		missionNamespace setVariable [_centerFrontName,[_frontSectors,_FmaxSpace,_FmaxSA,_FmaxVeh,_frontSpace,_frontSA,_frontInf,_frontVeh]];

		_lFlank = missionNamespace getVariable _leftFlankName;
		_rFlank = missionNamespace getVariable _rightFlankName;
		_cFront = missionNamespace getVariable _centerFrontName;

		_flSMaxStr = _leftFlankName;
		_flSpace = (missionNamespace getVariable _leftFlankName) select 1;

		if not (_flSpace) then
			{
				{
				_fl = missionNamespace getVariable _x;
				_spaceF = _fl select 1;
				if (_spaceF) exitWith {_flSMaxStr = _x}
				}
			foreach [_rightFlankName,_centerFrontName];
			};

		_flSAMaxStr = _leftFlankName;
		_flSA = (missionNamespace getVariable _leftFlankName) select 2;

		if not (_flSA) then
			{
				{
				_fl = missionNamespace getVariable _x;
				_SAF = _fl select 2;
				if (_SAF) exitWith {_flSAMaxStr = _x}
				}
			foreach [_rightFlankName,_centerFrontName];
			};

		_flVMaxStr = _leftFlankName;
		_flVeh = (missionNamespace getVariable _leftFlankName) select 3;

		if not (_flVeh) then
			{
				{
				_fl = missionNamespace getVariable _x;
				_vehF = _fl select 3;
				if (_vehF) exitWith {_flVMaxStr = _x}
				}
			foreach [_rightFlankName,_centerFrontName];
			};



		_vehAll = 0;

			{
			_ldrRep = (_x getVariable "ForceRep") select 0;
			_forceChar = _ldrRep select 5;
			_vehPerc = (_forceChar select 1) + (_forceChar select 2) + (_forceChar select 3);

			_vehAll = _vehAll + _vehPerc
			}
		foreach _BBHQGrps;

		_vehAv = _vehAll/(count _BBHQGrps);

		_moreVehHQ = [];

			{
			_ldrRep = (_x getVariable "ForceRep") select 0;
			_forceChar = _ldrRep select 5;
			_vehPerc = (_forceChar select 1) + (_forceChar select 2) + (_forceChar select 3);

			if (_vehPerc >= _vehAv) then 
				{
				_moreVehHQ pushBack _x;
				_x setVariable ["ForceProfile","V"]
				}
			else
				{
				_x setVariable ["ForceProfile","I"]
				}
			}
		foreach _BBHQGrps;

		_numAll = 0;

			{
			_ldrRep = (_x getVariable "ForceRep") select 0;
			_forceNum = _ldrRep select 1;

			_numAll = _numAll + _forceNum
			}
		foreach _BBHQGrps;

		_numAv = _numAll/(count _BBHQGrps);

		_moreNumHQ = [];

			{
			_ldrRep = (_x getVariable "ForceRep") select 0;
			_forceNum = _ldrRep select 1;

			if (_forceNum >= _numAv) then 
				{
				_moreNumHQ pushBack _x;
				_x setVariable ["NumProfile","A"]
				}
			else
				{
				_x setVariable ["NumProfile","B"]
				}

			}
		foreach _BBHQGrps;

		_goingLeft = [];
		_goingRight = [];
		_goingAhead = [];

		_allCount = count _BBHQGrps;
		_resCount = floor ((count _BBHQGrps)/3);

		_actCount = _allCount - _resCount;

		_flankCount = floor (2 * (_actCount/3));

		_centerCount = _actCount - _flankCount;

		_restHQ = _BBHQGrps - (_moreVehHQ + _moreNumHQ);

		_goingReserve = [];
		
		_resCand = [];

			{
			if ((_x getVariable ["ForceProfile","V"]) == "I") then {_resCand pushBack _x}
			}
		foreach _moreNumHQ;
		
		while {(_resCount > 0)} do
			{

			if (((count _resCand) > 0) and ((random 100) < 90)) then
				{
				_ldr = _resCand select (floor (random (count _resCand)));

				_goingReserve pushBack _ldr;
				_moreVehHQ = _moreVehHQ - [_ldr];
				_moreNumHQ = _moreNumHQ - [_ldr];
				_resCand = _resCand - [_ldr];
				_resCount = _resCount - 1;

				};

			if (_resCount <= 0) exitWith {};

			_ldr = (_BBHQGrps - _goingReserve) select (floor (random (count (_BBHQGrps - _goingReserve))));

			_goingReserve pushBack _ldr;
			_moreVehHQ = _moreVehHQ - [_ldr];
			_moreNumHQ = _moreNumHQ - [_ldr];
			_resCand = _resCand - [_ldr];
			_resCount = _resCount - 1;
			};
	
		if not (_allAreTaken) then
			{
			if ((count _BBHQGrps) > 1) then
				{
				if (((count _moreVehHQ) > 0) and ((random 100) < 90)) then
					{
					_ldr = _moreVehHQ select (floor (random (count _moreVehHQ)));
					switch (_flVMaxStr) do
						{
						case (_leftFlankName) : 
							{
							_goingLeft pushBack _ldr;
							_moreVehHQ = _moreVehHQ - [_ldr];
							_moreNumHQ = _moreNumHQ - [_ldr];
							_flankCount = _flankCount - 1;
							};

						case (_rightFlankName) : 
							{
							_goingRight pushBack _ldr;
							_moreVehHQ = _moreVehHQ - [_ldr];
							_moreNumHQ = _moreNumHQ - [_ldr];
							_flankCount = _flankCount - 1
							};

						case (_centerFrontName) : 
							{
							_goingAhead pushBack _ldr;
							_moreVehHQ = _moreVehHQ - [_ldr];
							_moreNumHQ = _moreNumHQ - [_ldr];
							_centerCount = _centerCount - 1
							};
						};
					};

				if (((count _moreNumHQ) > 0) and ((random 100) < 90)) then
					{
					_ldr = _moreNumHQ select (floor (random (count _moreNumHQ)));
					switch (_flSAMaxStr) do
						{
						case (_leftFlankName) : 
							{
							_goingLeft pushBack _ldr;
							_moreVehHQ = _moreVehHQ - [_ldr];
							_moreNumHQ = _moreNumHQ - [_ldr];
							_flankCount = _flankCount - 1;
							};

						case (_rightFlankName) : 
							{
							_goingRight pushBack _ldr;
							_moreVehHQ = _moreVehHQ - [_ldr];
							_moreNumHQ = _moreNumHQ - [_ldr];
							_flankCount = _flankCount - 1
							};

						case (_centerFrontName) : 
							{
							_goingAhead pushBack _ldr;
							_moreVehHQ = _moreVehHQ - [_ldr];
							_moreNumHQ = _moreNumHQ - [_ldr];
							_centerCount = _centerCount - 1
							};
						};
					};

				_allFree = +(_BBHQGrps - (_goingReserve + _goingLeft + _goingRight + _goingAhead));

					{
					_ldr = _x;
					_rndF = random 100;

					_flankOne = _leftFlankName;
					_goingOne = _goingLeft;
					_flankTwo = _rightFlankName;
					_goingTwo = _goingRight;

					if ((random 100) >= 50) then 
						{
						_flankOne = _rightFlankName;
						_goingOne = _goingRight;
						_flankTwo = _leftFlankName;
						_goingTwo = _goingLeft;
						};

					switch (true) do
						{
						case ((_ldr in _moreVehHQ) and (_ldr in _moreNumHQ) and (_rndF < 90)) : 
							{
							switch (true) do
								{
								case ((((_flVMaxStr == _flankOne) and (((count _goingOne) <= (count _goingTwo)) or ((random 100) < 10))) or (((count _goingOne) == 0) and ((count _goingTwo) > 0) and ((random 100) > 75))) and (_flankCount > 0)) : 
									{
									_goingOne pushBack _ldr;
									_moreVehHQ = _moreVehHQ - [_ldr];
									_moreNumHQ = _moreNumHQ - [_ldr];
									_flankCount = _flankCount - 1;
									};

								case ((((_flVMaxStr == _flankTwo) and (((count _goingTwo) <= (count _goingOne)) or ((random 100) < 10))) or (((count _goingTwo) == 0) and ((count _goingOne) > 0) and ((random 100) > 75))) and (_flankCount > 0)) : 
									{
									_goingTwo pushBack _ldr;
									_moreVehHQ = _moreVehHQ - [_ldr];
									_moreNumHQ = _moreNumHQ - [_ldr];
									_flankCount = _flankCount - 1
									};

								case ((_centerCount > 0) and ((count _moreNumHQ) == 0)) : 
									{
									_goingAhead pushBack _ldr;
									_moreVehHQ = _moreVehHQ - [_ldr];
									_moreNumHQ = _moreNumHQ - [_ldr];
									_centerCount = _centerCount - 1
									};

								case ((((_flSAMaxStr == _flankOne) and (((count _goingOne) <= (count _goingTwo)) or ((random 100) < 10))) or (((count _goingOne) == 0) and ((count _goingTwo) > 0) and ((random 100) > 75))) and (_flankCount > 0)) : 
									{
									_goingOne pushBack _ldr;
									_moreVehHQ = _moreVehHQ - [_ldr];
									_moreNumHQ = _moreNumHQ - [_ldr];
									_flankCount = _flankCount - 1;
									};

								case ((((_flSAMaxStr == _flankTwo) and (((count _goingTwo) <= (count _goingOne)) or ((random 100) < 10))) or (((count _goingTwo) == 0) and ((count _goingOne) > 0) and ((random 100) > 75))) and (_flankCount > 0)) : 
									{
									_goingTwo pushBack _ldr;
									_moreVehHQ = _moreVehHQ - [_ldr];
									_moreNumHQ = _moreNumHQ - [_ldr];
									_flankCount = _flankCount - 1
									};

								case (_centerCount > 0) : 
									{
									_goingAhead pushBack _ldr;
									_moreVehHQ = _moreVehHQ - [_ldr];
									_moreNumHQ = _moreNumHQ - [_ldr];
									_centerCount = _centerCount - 1
									};

								default 
									{
									_rndF = random 100;

									if (_rndF < 50) then
										{
										_goingLeft pushBack _ldr;
										_moreVehHQ = _moreVehHQ - [_ldr];
										_moreNumHQ = _moreNumHQ - [_ldr];
										_flankCount = _flankCount - 1;
										}
									else
										{
										_goingRight pushBack _ldr;
										_moreVehHQ = _moreVehHQ - [_ldr];
										_moreNumHQ = _moreNumHQ - [_ldr];
										_flankCount = _flankCount - 1
										}
									};
								};
							};

						case ((_ldr in _moreVehHQ) and (_rndF < 90)) : 
							{

							switch (true) do
								{
								case ((((_flVMaxStr == _flankOne) and (((count _goingOne) <= (count _goingTwo)) or ((random 100) < 10))) or (((count _goingOne) == 0) and ((count _goingTwo) > 0) and ((random 100) > 75))) and (_flankCount > 0)) : 
									{
									_goingOne pushBack _ldr;
									_moreVehHQ = _moreVehHQ - [_ldr];
									_moreNumHQ = _moreNumHQ - [_ldr];
									_flankCount = _flankCount - 1;
									};

								case ((((_flVMaxStr == _flankTwo) and (((count _goingTwo) <= (count _goingOne)) or ((random 100) < 10))) or (((count _goingTwo) == 0) and ((count _goingOne) > 0) and ((random 100) > 75))) and (_flankCount > 0)) : 
									{
									_goingTwo pushBack _ldr;
									_moreVehHQ = _moreVehHQ - [_ldr];
									_moreNumHQ = _moreNumHQ - [_ldr];
									_flankCount = _flankCount - 1
									};

								case (_centerCount > 0) : 
									{
									_goingAhead pushBack _ldr;
									_moreVehHQ = _moreVehHQ - [_ldr];
									_moreNumHQ = _moreNumHQ - [_ldr];
									_centerCount = _centerCount - 1
									};

								default 
									{
									_rndF = random 100;

									if (_rndF < 50) then
										{
										_goingLeft pushBack _ldr;
										_moreVehHQ = _moreVehHQ - [_ldr];
										_moreNumHQ = _moreNumHQ - [_ldr];
										_flankCount = _flankCount - 1;
										}
									else
										{
										_goingRight pushBack _ldr;
										_moreVehHQ = _moreVehHQ - [_ldr];
										_moreNumHQ = _moreNumHQ - [_ldr];
										_flankCount = _flankCount - 1
										}
									};
								};
							};

						case ((_ldr in _moreNumHQ) and (_rndF < 90)) : 
							{

							switch (true) do
								{
								case ((((_flSAMaxStr == _flankOne) and (((count _goingOne) <= (count _goingTwo)) or ((random 100) < 10))) or (((count _goingOne) == 0) and ((count _goingTwo) > 0) and ((random 100) > 75))) and (_flankCount > 0)) : 
									{
									_goingOne pushBack _ldr;
									_moreVehHQ = _moreVehHQ - [_ldr];
									_moreNumHQ = _moreNumHQ - [_ldr];
									_flankCount = _flankCount - 1;
									};

								case ((((_flSAMaxStr == _flankTwo) and (((count _goingTwo) <= (count _goingOne)) or ((random 100) < 10))) or (((count _goingTwo) == 0) and ((count _goingOne) > 0) and ((random 100) > 75))) and (_flankCount > 0)) : 
									{
									_goingTwo pushBack _ldr;
									_moreVehHQ = _moreVehHQ - [_ldr];
									_moreNumHQ = _moreNumHQ - [_ldr];
									_flankCount = _flankCount - 1
									};

								case (_centerCount > 0) : 
									{
									_goingAhead pushBack _ldr;
									_moreVehHQ = _moreVehHQ - [_ldr];
									_moreNumHQ = _moreNumHQ - [_ldr];
									_centerCount = _centerCount - 1
									};

								default 
									{
									_rndF = random 100;

									if (_rndF < 50) then
										{
										_goingLeft pushBack _ldr;
										_moreVehHQ = _moreVehHQ - [_ldr];
										_moreNumHQ = _moreNumHQ - [_ldr];
										_flankCount = _flankCount - 1;
										}
									else
										{
										_goingRight pushBack _ldr;
										_moreVehHQ = _moreVehHQ - [_ldr];
										_moreNumHQ = _moreNumHQ - [_ldr];
										_flankCount = _flankCount - 1
										}
									};
								};
							};

						default 
							{
							if ((({((_x in _moreVehHQ) or (_x in _moreNumHQ))} count (_BBHQGrps - _goingReserve)) < (_flankCount + _centerCount)) or (_rndF >= 90)) then
								{
								_rndF = random 100;

								switch (true) do
									{
									case (_rndF < 33) :
										{
										_goingLeft pushBack _ldr;
										_moreVehHQ = _moreVehHQ - [_ldr];
										_moreNumHQ = _moreNumHQ - [_ldr];
										_flankCount = _flankCount - 1;
										};

									case (_rndF < 66) :
										{ 
										_goingRight pushBack _ldr;
										_moreVehHQ = _moreVehHQ - [_ldr];
										_moreNumHQ = _moreNumHQ - [_ldr];
										_flankCount = _flankCount - 1
										};

									default 
										{
										_goingAhead pushBack _ldr;
										_moreVehHQ = _moreVehHQ - [_ldr];
										_moreNumHQ = _moreNumHQ - [_ldr];
										_centerCount = _centerCount - 1
										};
									}
								}
							};
						};
					}
				foreach _allFree;

				if ((count (_BBHQGrps - (_goingReserve + _goingLeft + _goingRight + _goingAhead))) > 0) then 
					{

						{
						_ldr = _x;
						if (_flankCount > 0) then 
							{
							_rndF = random 100;

							switch (true) do
								{
								case (_rndF < 50) :
									{
									_goingLeft pushBack _ldr;
									_moreVehHQ = _moreVehHQ - [_ldr];
									_moreNumHQ = _moreNumHQ - [_ldr];
									_flankCount = _flankCount - 1;
									};

								case (_rndF >= 50) :
									{ 
									_goingRight pushBack _ldr;
									_moreVehHQ = _moreVehHQ - [_ldr];
									_moreNumHQ = _moreNumHQ - [_ldr];
									_flankCount = _flankCount - 1
									};
								}
							}
						else
							{
							_goingAhead pushBack _ldr;
							_moreVehHQ = _moreVehHQ - [_ldr];
							_moreNumHQ = _moreNumHQ - [_ldr];
							_centerCount = _centerCount - 1
							}
						}
					foreach (_BBHQGrps - (_goingReserve + _goingLeft + _goingRight + _goingAhead))
					}
				}
			else
				{
				_goingAhead pushBack (_BBHQGrps select 0);
				_centerCount = _centerCount - 1
				}
			}
		else
			{
			for "_i" from 0 to (_actCount - 1) do
				{
				_ldr = _BBHQGrps select _i;
				_goingAhead pushBack _ldr
				}
			};

		if (RydBB_Debug) then
			{
			RydBBa_SAL globalChat format ["Assignment of Big Boss %5 : Left: %1 Right: %2 Front: %3 Reserve: %4",_goingLeft,_goingRight,_goingAhead,_goingReserve,_BBSide];
			diag_log format ["Assignment of Big Boss %5 : Left: %1 Right: %2 Front: %3 Reserve: %4",_goingLeft,_goingRight,_goingAhead,_goingReserve,_BBSide];
			};

		if (((RydBBa_SimpleDebug) and (_BBSide == "A")) or ((RydBBb_SimpleDebug) and (_BBSide == "B"))) then 
			{
			[_BBHQGrps,_BBSide] call RYD_BBSimpleD;
			};
		};

	if (RydBB_Debug) then
		{
		RydBBa_SAL globalChat format ["Big Boss %1 issues orders.",_BBSide];
		diag_log format ["Big Boss %1 issues orders.",_BBSide];
		};

	_goingReserve0 = _goingReserve;

		{
		_aliveHQ = true;
		switch (true) do
			{
			case (isNull _x) : {_aliveHQ = false};
			case (({alive _x} count (units _x)) < 1) : {_aliveHQ = false};
			};
			
		if not (_aliveHQ) then {_goingReserve = _goingReserve - [_x]};
		}
	foreach _goingReserve0;

	if ((count _goingReserve) > 0) then
		{
		_lastGLeft = _goingLeft;
		_lastGRight = _goingRight;
		_lastGAhead = _goingAhead;

		_lastGLeftN = count _goingLeft;
		_lastGRightN = count _goingRight;
		_lastGAheadN = count _goingAhead;

			{
			_aliveHQ = true;
			switch (true) do
				{
				case (isNull _x) : {_aliveHQ = false};
				case (({alive _x} count (units _x)) < 1) : {_aliveHQ = false};
				};
			if not (_aliveHQ) then {_goingAhead = _goingAhead - [_x]};
			}
		foreach _lastGAhead;

		if ((count _goingAhead) < _lastGAheadN) then
			{
			if ((count _goingReserve) > 0) then 
				{
				_goingReserve params ["_newL"];
				_goingReserve = _goingReserve - [_newL];
				_goingAhead pushBack _newL;
				}
			};

			{
			_aliveHQ = true;
			switch (true) do
				{
				case (isNull _x) : {_aliveHQ = false};
				case (({alive _x} count (units _x)) < 1) : {_aliveHQ = false};
				};
				
			if not (_aliveHQ) then {_goingLeft = _goingLeft - [_x]};
			}
		foreach _lastGLeft;

		if ((count _goingLeft) <  _lastGLeftN) then
			{
			if ((count _goingReserve) > 0) then 
				{
				_goingReserve params ["_newL"];
				_goingReserve = _goingReserve - [_newL];
				_goingLeft pushBack _newL;
				}
			};

			{
			_aliveHQ = true;
			switch (true) do
				{
				case (isNull _x) : {_aliveHQ = false};
				case (({alive _x} count (units _x)) < 1) : {_aliveHQ = false};
				};
				
			if not (_aliveHQ) then {_goingRight = _goingRight - [_x]};
			}
		foreach _lastGRight;

		if ((count _goingRight) < _lastGRightN) then
			{
			if ((count _goingReserve) > 0) then 
				{
				_goingReserve params ["_newL"];
				_goingReserve = _goingReserve - [_newL];
				_goingRight pushBack _newL;
				}
			};
		};

	if (_stance == "") then {_stance = "O"};

	_losses = 0;
	_currentNumber = 0;
	_ownVal = 0;

	for "_i" from 0 to ((count (_ForcesRep select 0)) - 2) do
		{
		_actRep = (_ForcesRep select 0) select _i;
		_actRep params ["_placebofor0","_curr1","_loss1","_ownV1"];
		_losses = _losses - _loss1;
		_currentNumber = _currentNumber + _curr1;
		_ownVal = _ownVal + _ownV1;
		};

	_enemyVal = 0;

	for "_i" from 0 to ((count (_ForcesRep select 1)) - 2) do
		{
		_actRep = (_ForcesRep select 1) select _i;
		_enemyVal = _enemyVal + (_actRep select 1)
		};

	_inert = 1;

	if (_stance == "D") then {_inert = 1.2};
	//if (_stance == "O") then {_inert = 0.8};
	_enemyFactor = _ownVal/((_enemyVal + 1) * _inert);

	_lossesFactor = (_losses/(_currentNumber + 1)) * _inert;


	if (RydBB_Debug) then
		{
		RydBBa_SAL globalChat format ["Side: %7 - Losses: %1 Number: %2 Value: %3 enValue: %4 enFactor: %5 lossFactor: %6",_losses,_currentNumber,_ownVal,_enemyVal,_enemyFactor,_lossesFactor,_BBSide];
		diag_log format ["Side: %7 - Losses: %1 Number: %2 Value: %3 enValue: %4 enFactor: %5 lossFactor: %6",_losses,_currentNumber,_ownVal,_enemyVal,_enemyFactor,_lossesFactor,_BBSide];
		};

	if ((_lossesFactor > (0.6 + (random 0.15))) or (_allAreTaken)) then
		{
		_stance = "D";

			{
			_aliveHQ = true;
			switch (true) do
				{
				case (isNull _x) : {_aliveHQ = false};
				case (({alive _x} count (units _x)) < 1) : {_aliveHQ = false};
				};

			if (_aliveHQ) then
				{
				_HQ = _x;
				_front = _HQ getVariable ["RydHQ_Front",locationNull];
				_tObj1 = _HQ getVariable ["RydHQ_Obj1",objNull];
				_tObj2 = _HQ getVariable ["RydHQ_Obj2",objNull];
				_tObj3 = _HQ getVariable ["RydHQ_Obj3",objNull];
				_tObj4 = _HQ getVariable ["RydHQ_Obj4",objNull];
				_knEnemy = _HQ getVariable ["RydHQ_KnEnPos",[]];
				_HQ setVariable ["RydHQ_Order","DEFEND"];
				_HQ setVariable ["RydHQ_NObj",5];
				_HQ setVariable ["BBDEF",true];

				_HQ setVariable ["BBTakenDebug",_allAreTaken];

				_perDirPos = _mainPos;
				_actT = _x getVariable "ActualTarget";
				if not (isNil "_actT") then {_perDirPos = _actT select 0};
				if not ((count _knEnemy) == 0) then
					{
					_dpX = 0;
					_dpY = 0;

						{
						_dpX = _dpX + (_x select 0);
						_dpY = _dpY + (_x select 1)
						}
					foreach _knEnemy;

					_dpX = _dpX/(count _knEnemy);
					_dpY = _dpY/(count _knEnemy);

					_perDirPos = [_dpX,_dpY,0];
					};

				_HQPos = getPosATL (vehicle (leader _HQ));

				_dirAdd = -60;

					{
					_angle = [_HQPos,_perDirPos,10] call RYD_AngTowards;
					_angle = _angle + _dirAdd;

					_dirAdd = _dirAdd + 40;

					_perPos = [_HQPos,_angle,(350 + (random 100))] call RYD_PosTowards2D;

					_perX = _perPos select 0;
					_perY = _perPos select 1;

					_x setPosATL [_perX,_perY,0];

					//_mark = [(str (random 1000)),[_perX,_perY,0],"ColorPink","ICON",[0.5,0.5],0,1,"DOT",(str _HQ)] call RYD_Marker;
					}
				foreach [_tObj1,_tObj2,_tObj3,_tObj4];

				[_front,_HQPos,_perDirPos,1500] call RYD_LocLineTransform;
				}
			}
		foreach (_goingLeft + _goingRight + _goingAhead)
		}
	else
		{
		_stance = "O";
		_leftNotTaken = [];

			{
			_tkn = _x select 2;
			if not (_tkn) then {_leftNotTaken pushBack _x}
			}
		foreach _leftSA;

		_rightNotTaken = [];

			{
			_tkn = _x select 2;
			if not (_tkn) then {_rightNotTaken pushBack _x}
			}
		foreach _rightSA;

		_frontNotTaken = [];

			{
			_tkn = _x select 2;
			if not (_tkn) then {_frontNotTaken pushBack _x}
			}
		foreach _frontSA;

			{
			_notTaken = _leftNotTaken;
			if ((count _notTaken) == 0) then {_notTaken = _frontNotTaken};
			if ((count _notTaken) == 0) then {_notTaken = _rightNotTaken};

			_fPos = getPosATL (vehicle (leader _x));

			if ((count _notTaken) == 0) exitWith {_x setVariable ["ActualTarget",[_fPos,1,false,"Zero"]]};
			_notTaken params ["_chosenT"];
			_indx = 0;
			_chosenT params ["_cPos","_cVal","_cTaken"];
			_dstFC = _fPos distance _cPos;
			_tempMax = 0;
			if (_dstFC > 0) then {_tempMax = _cVal/((_dstFC/1000) * (_dstFC/1000))};

			for "_i" from 1 to ((count _notTaken) - 1) do
				{
				_actT = _notTaken select _i;
				_actT params ["_cPos","_cVal","_cTaken"];
				_dstFC = _fPos distance _cPos;
				_tempAct = 0;
				if (_dstFC > 0) then {_tempAct = (_cVal/((_dstFC/1000) * (_dstFC/1000))) * (0.5 + (random 0.5) + (random 0.5))};

				if (_tempAct > _tempMax) then {_chosenT = _actT;_tempMax = _tempAct;_indx = _i};
				};

			_x setVariable ["ActualTarget",_chosenT];

			if ((count _leftNotTaken) > 0) then 
				{
				_leftNotTaken set [_indx,0]; 
				_leftNotTaken = _leftNotTaken - [0]
				}
			else
				{
				if ((count _frontNotTaken) > 0) then 
					{
					_frontNotTaken set [_indx,0]; 
					_frontNotTaken = _frontNotTaken - [0]
					}
				else
					{
					if ((count _rightNotTaken) > 0) then 
						{
						_rightNotTaken set [_indx,0]; 
						_rightNotTaken = _rightNotTaken - [0]
						}
					}
				}
			}
		foreach _goingLeft;

			{
			_notTaken = _rightNotTaken;
			if ((count _notTaken) == 0) then {_notTaken = _frontNotTaken};
			if ((count _notTaken) == 0) then {_notTaken = _leftNotTaken};

			_fPos = getPosATL (vehicle (leader _x));

			if ((count _notTaken) == 0) exitWith {_x setVariable ["ActualTarget",[_fPos,1,false,"Zero"]]};
			
			_notTaken params ["_chosenT"];
			_indx = 0;
			_chosenT params ["_cPos","_cVal","_cTaken"];
			_dstFC = _fPos distance _cPos;
			_tempMax = 0;
			if (_dstFC > 0) then {_tempMax = _cVal/((_dstFC/1000) * (_dstFC/1000))};

			for "_i" from 1 to ((count _notTaken) - 1) do
				{
				_actT = _notTaken select _i;
				_actT params ["_cPos","_cVal","_cTaken"];
				_dstFC = _fPos distance _cPos;
				_tempAct = 0;
				if (_dstFC > 0) then {_tempAct = (_cVal/((_dstFC/1000) * (_dstFC/1000))) * (0.5 + (random 0.5) + (random 0.5))};

				if (_tempAct > _tempMax) then {_chosenT = _actT;_tempMax = _tempAct;_indx = _i};
				};

			_x setVariable ["ActualTarget",_chosenT];

			if ((count _rightNotTaken) > 0) then 
				{
				_rightNotTaken set [_indx,0]; 
				_rightNotTaken = _rightNotTaken - [0]
				}
			else
				{
				if ((count _frontNotTaken) > 0) then 
					{
					_frontNotTaken set [_indx,0]; 
					_frontNotTaken = _frontNotTaken - [0]
					}
				else
					{
					if ((count _leftNotTaken) > 0) then 
						{
						_leftNotTaken set [_indx,0]; 
						_leftNotTaken = _leftNotTaken - [0]
						}
					}
				}
			}
		foreach _goingRight;

			{
			_notTaken = _frontNotTaken;
			if ((count _notTaken) == 0) then {_notTaken = _leftNotTaken};
			if ((count _notTaken) == 0) then {_notTaken = _rightNotTaken};
			_fPos = getPosATL (vehicle (leader _x));

			if ((count _notTaken) == 0) exitWith {_x setVariable ["ActualTarget",[_fPos,1,false,"Zero"]]};

			_notTaken params ["_chosenT"];
			_indx = 0;
			_chosenT params ["_cPos","_cVal","_cTaken"];
			_dstFC = _fPos distance _cPos;
			_tempMax = 0;
			if (_dstFC > 0) then {_tempMax = _cVal/((_dstFC/1000) * (_dstFC/1000))};


			for "_i" from 1 to ((count _notTaken) - 1) do
				{
				_actT = _notTaken select _i;
				_actT params ["_cPos","_cVal","_cTaken"];
				_dstFC = _fPos distance _cPos;
				_tempAct = 0;
				if (_dstFC > 0) then {_tempAct = (_cVal/((_dstFC/1000) * (_dstFC/1000))) * (0.5 + (random 0.5) + (random 0.5))};

				if (_tempAct > _tempMax) then {_chosenT = _actT;_tempMax = _tempAct;_indx = _i};
				};

			_x setVariable ["ActualTarget",_chosenT];

			if ((count _frontNotTaken) > 0) then 
				{
				_frontNotTaken set [_indx,0]; 
				_frontNotTaken = _frontNotTaken - [0]
				}
			else
				{
				if ((count _leftNotTaken) > 0) then 
					{
					_leftNotTaken set [_indx,0]; 
					_leftNotTaken = _leftNotTaken - [0]
					}
				else
					{
					if ((count _rightNotTaken) > 0) then 
						{
						_rightNotTaken set [_indx,0]; 
						_rightNotTaken = _rightNotTaken - [0]
						}
					}
				}
			}
		foreach _goingAhead;

			{
				{
				_aliveHQ = true;
				switch (true) do
					{
					case (isNull _x) : {_aliveHQ = false};
					case (({alive _x} count (units _x)) < 1) : {_aliveHQ = false};
					};

				if (_aliveHQ) then
					{
					_pathDone = _x getVariable "PathDone";
					if (isNil "_pathDone") then {_pathDone = true};		
					
					if (_pathDone) then
						{
						_HQ = _x;
						_front = _HQ getVariable ["RydHQ_Front",locationNull];
						_tObj1 = _HQ getVariable ["RydHQ_Obj1",objNull];
						_tObj2 = _HQ getVariable ["RydHQ_Obj2",objNull];
						_tObj3 = _HQ getVariable ["RydHQ_Obj3",objNull];
						_tObj4 = _HQ getVariable ["RydHQ_Obj4",objNull];
						_HQ setVariable ["RydHQ_Order","ATTACK"];
						_HQ setVariable ["RydHQ_NObj",1];
						_HQ setVariable ["BBDEF",false];

						_areas = _leftNotTaken; 
						_sctrs = _leftSectors;

						switch (true) do
							{
							case (_x in _goingRight) : {_areas = _rightNotTaken;_sctrs = _rightSectors};
							case (_x in _goingAhead) : {_areas = _frontNotTaken;_sctrs = _frontSectors};
							};

						_goingOverall = (_goingLeft + _goingAhead + _goingRight);

						if ((count _areas) == 0) then {_areas = (_leftNotTaken + _rightNotTaken + _frontNotTaken)};

						_acT = _x getVariable "ActualTarget";

						_areas pushBack _acT;

						_acT params ["_act"];

						if ((count _goingOverall) == 1) then {_areas = (_leftNotTaken + _rightNotTaken + _frontNotTaken)};

						_HQpos = getPosATL (vehicle (leader _x));

						_pathRep = [_sctrs,_areas,_HQpos,_acT,_BBSide] call RYD_Itinerary;

						_pathRep params ["_secsAround"];

						_tgtsAround = _areas;

						_points = [];

							{
							_points pushBack (_x select 0)
							}
						foreach _tgtsAround;

						_AAOPts = [];
						
						{
							_AAOPts pushBack (_x select 0)
							}
						foreach _tgtsAround;

							{
							_points pushBack _x
							}
						foreach [_HQpos,_acT];
					
						[_front,+_points,1200] call RYD_LocMultiTransform;

						[_x,_tgtsAround,_tObj1,_tObj2,_tObj3,_tObj4,_BBHQGrps,_HQpos,_front,_secsAround,_goingReserve,_BBSide,_AAOPts] call RYD_ExecutePath;

						waitUntil
							{
							sleep 0.01;
							_initD = _x getVariable "ObjInit";
							if (isNil "_initD") then {_initD = false};
							(_initD)
							};
						}
					}
				}
			foreach _x
			}
		foreach [_goingLeft,_goingRight,_goingAhead]
		};

	_points = [];

		{
		_tkn = _x select 2;
		if (_tkn) then {_points pushBack _x}
		}
	foreach _strArea;

	_HQpoints = [];

		{
		_HQpoints pushBack (getPosATL (vehicle (leader _x)))
		}
	foreach _BBHQGrps;
	
	_takenPoints = _points;

	_points = [];

		{
		_points pushBack (_x select 0)
		}
	foreach _takenPoints;

	_HQ setVariable ["BBDEFPts",_points];

	_points = _points + _HQpoints;

		{
		_aliveHQ = true;
		switch (true) do
			{
			case (isNull _x) : {_aliveHQ = false};
			case (({alive _x} count (units _x)) < 1) : {_aliveHQ = false};
			};

		if (_aliveHQ) then
			{
			_HQ = _x;
			_front = _HQ getVariable ["RydHQ_Front",locationNull];
			_tObj1 = _HQ getVariable ["RydHQ_Obj1",objNull];
			_tObj2 = _HQ getVariable ["RydHQ_Obj2",objNull];
			_tObj3 = _HQ getVariable ["RydHQ_Obj3",objNull];
			_tObj4 = _HQ getVariable ["RydHQ_Obj4",objNull];

	/*
				{
				_mark = [(str (random 1000)),_x,"ColorOrange","ICON",[0.5,0.5],0,1,"DOT","R"] call RYD_Marker;
				}
			foreach _points;
	*/
			[_front,+_points,1000] call RYD_LocMultiTransform;

			[_x,_goingAhead,_tObj1,_tObj2,_tObj3,_tObj4,_BBHQs,_front,_takenPoints,_hostileGroups,_BBSide] call RYD_ReserveExecuting;

			waitUntil
				{
				sleep 0.01;
				_initD = _x getVariable "ObjInit";
				if (isNil "_initD") then {_initD = false};
				(_initD)
				};
			}
		}
	foreach _goingReserve;

	if (_BBcycle == 1) then
		{
		if (_BBSide == "A") then {RydBBa_InitDone = true} else {RydBBb_InitDone = true}
		};

	if (_BBSide == "A") then {RydBBa_Urgent = false} else {RydBBb_Urgent = false};

	if (_BBCycle == 1) then 
		{
		[_strArea,_BBSide,(_BBHQGrps select 0),_BBHQGrps] call RYD_ObjectivesMon;
		};

	if ((_BBSide == "A") and (_BBCycle == 1)) then {RydBBa_Init = true};

	if (RydBB_Debug) then
		{
		RydBBa_SAL globalChat format ["For Big Boss %3 cycle is completed: %1 (mission time: %2)",_BBCycle,time,_BBSide];
		diag_log format ["For Big Boss %3 cycle is completed: %1 (mission time: %2)",_BBCycle,time,_BBSide]
		};

	_ctWait = time;
	_ctVal = 20;
	if not (isNil "RydBB_MainInterval") then {_ctVal = RydBB_MainInterval};

	if (RydBB_Debug) then
		{
		RydBBa_SAL globalChat format ["Big Boss %1 will now take a moment to ash his cigar.",_BBSide];
		diag_log format ["Big Boss %1 will now take a moment to ash his cigar.",_BBSide];
		};

	waitUntil
		{
		sleep 60;

		if (_BBSide == "A") then 
			{
			if (RydBBa_Urgent) then 
				{
				_ctVal = 0
				}
			}
		else 
			{
			if (RydBBb_Urgent) then 
				{
				_ctVal = 0
				}
			};

		if not (RydBB_Active) then {_ctVal = 0};

		((time - _ctWait) >= (_ctVal * 60))
		};
		
	if not (RydBB_Active) exitWith {};
		
	_urgent = RydBBa_Urgent;
	if (_BBSide == "B") then {_urgent = RydBBb_Urgent};

	if (RydBB_Debug) then
		{
		if (_urgent) then
			{
			RydBBa_SAL globalChat format ["Situation on the frontline forces Big Boss %1 to react quickly.",_BBSide];
			diag_log format ["Situation on the frontline forces Big Boss %1 to react quickly.",_BBSide];
			}
		else
			{
			RydBBa_SAL globalChat format ["For Big Boss %1 it is time to a routine review the situation.",_BBSide];
			diag_log format ["For Big Boss %1 it is time to a routine review the situation.",_BBSide];
			}
		};

	if (_urgent) then
		{
			{
			if not (isNull (group _x)) then {(group _x) setVariable ["PathDone",true]};
			}
		foreach _BBHQs
		};

	_BBalive = true;

	if (RydBB_BBOnMap) then
		{
		_BBUnit = RydBBaHQ;
		if (_BBSide == "B") then {_BBUnit = RydBBbHQ};

		if (isNull _BBUnit) exitWith {_BBalive = false};
		if not (alive _BBUnit) exitWith {_BBalive = false};
		if (captive _BBUnit) then {_BBalive = false}
		};

	if not (_BBalive) then 
		{
		if (_BBSide == "A") then {RydBBa_HQs = []} else {RydBBb_HQs = []}
		};

	if not (_BBalive) exitWith 
		{
		if (RydBB_Debug) then
			{
			RydBBa_SAL globalChat format ["Big Boss %1 is dead!",_BBSide];
			diag_log format ["Big Boss %1 is dead!",_BBSide];
			}
		};
	};


