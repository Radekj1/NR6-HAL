_SCRname = "GoAttAir";

_i = "";
params ["_unitG","_Trg","_HQ"];

_request = false;
_reqTgtSet = false;
if ((count _this) > 3) then {_request = _this select 3};

_PosObj1 = getPosATL _Trg;
_unitvar = str (_unitG);

_UL = leader _unitG;

_PosLand = _unitG getvariable ("START" + _unitvar); 
if (isNil ("_PosLand")) then {_unitG setVariable [("START" + _unitvar),(position (vehicle _UL))];_PosLand = _unitG getvariable ("START" + _unitvar);};

[_unitG] call RYD_WPdel;

_unitG setVariable [("Deployed" + (str _unitG)),false];_unitG setVariable [("Capt" + (str _unitG)),false];

_flight = [];

{if ((vehicle _x) isKindOf "Air") then {_flight pushBackUnique (vehicle _x)}} foreach (units _unitG);

{_x setVariable ["SortiePylons",(count (getPylonMagazines _x))]} foreach _flight;

if ((_flight isEqualTo []) and ((isNull (assignedVehicle (leader _unitG))) or not (alive (assignedVehicle (leader _unitG))))) exitwith {

	_attAv = _HQ getVariable ["RydHQ_AttackAv",[]];
	_attAv pushBack _unitG;
	_HQ setVariable ["RydHQ_AttackAv",_attAv];

	_unitG setVariable [("Busy" + (str _unitG)),false];

	_HQ setVariable ["RydHQ_Exhausted",(_HQ getVariable ["RydHQ_Exhausted",[]]) + [_unitG]];
	[_unitG,_HQ] call HAL_GoRest;

};
 
//_unitG setVariable [("Busy" + (str _unitG)),true];};

_nothing = true;

_dX = (_PosObj1 select 0) - ((getPosATL (leader _HQ)) select 0);
_dY = (_PosObj1 select 1) - ((getPosATL (leader _HQ)) select 1);

_angle = _dX atan2 _dY;

_distance = (leader _HQ) distance _PosObj1;
_distance2 = 0;

_dXc = _distance2 * (cos _angle);
_dYc = _distance2 * (sin _angle);

_dXb = _distance * (sin _angle);
_dYb = _distance * (cos _angle);

_posX = ((getPosATL (leader _HQ)) select 0) + _dXb;
_posY = ((getPosATL (leader _HQ)) select 1) + _dYb;

if (_request) then {

	_Trg = objNull;

	_newTrg = _Trg;
	_posX = (_PosObj1 select 0) + (random 300) - 150;
	_posY = (_PosObj1 select 1) + (random 300) - 150;

};

[_unitG,[_posX,_posY,0],"HQ_ord_attackAir",_HQ] call RYD_OrderPause;

if ((isPlayer (leader _unitG)) and (RydxHQ_GPauseActive)) then {hintC "New orders from HQ!";setAccTime 1};

_UL = leader _unitG;
 
if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdConf,"OrdConf"] call RYD_AIChatter}};

if (_HQ getVariable ["RydHQ_Debug",false]) then 
	{
	_signum = _HQ getVariable ["RydHQ_CodeSign","X"];
	_i = [[_posX,_posY],_unitG,"markAttack","ColorRed","ICON","waypoint","CAS " + (groupId _unitG) + " " + _signum," - CAS",[0.5,0.5]] call RYD_Mark
	};


private _AddTask = createGroup sideLogic;
_AddTask setVariable ["_continueAfterTask",false];

[_AddTask,(leader _unitG),["Provide close air support and neutralize hostile targets.", "Provide Close Air Support", ""],[_posX,_posY],"destroy"] call RYD_AddTask;

waitUntil {_AddTask getVariable ["_continueAfterTask",false];}; 
diag_log text "RYD_AddTask code finished, waituntil passed";
_AddTask setVariable ["_continueAfterTask",false];
_task = _AddTask getVariable "_task";
deleteGroup _AddTask;
_wp = [_unitG,[_posX,_posY],"SAD","COMBAT","RED","NORMAL",["true", "deletewaypoint [(group this), 0]"],true,0,[0,0,0],"COLUMN"] call RYD_WPadd;

_lasT = ObjNull;


if ((_unitG in (_HQ getVariable ["RydHQ_BAirG",[]])) and not (isPlayer (leader _unitG))) then 
	{
	_eSide = side _unitG;

	_unitG setVariable ["CurrCASLazeOff",false];
	
	_tgt = "LaserTargetW";
	if (_eSide == east) then {_tgt = "LaserTargetE"};
	if (_eSide == resistance) then {_tgt = "LaserTargetC"};

	_tPos = getPosATL _Trg;
	//_tX = (_tPos select 0) + (random 60) - 30;
	//_tY = (_tPos select 1) + (random 60) - 30;
	
	_tpos params ["_tX","_tY"];

	if not (_request) then {
		_lasT = createVehicle [_tgt, _Trg, [], 0, "CAN_COLLIDE"];

		_lasT attachTo [_Trg];

		_wp waypointAttachVehicle _lasT;

		_eSide reportRemoteTarget [_lasT, 600]; 
		_lasT confirmSensorTarget [_eSide, true];

		_unitG setVariable ["CurrCASLaze",_lasT];
		_unitG setVariable ["CurrCASObjSetByLead",_Trg];
	} else {_lasT = objNull; _Trg = objNull;};
	
	_code =
		{
		params ["_Trg","_lasT","_unitG","_HQ","_casPos","_reqTgtSet","_wp","_tgt","_eSide"];
		_endThis = false;

		_VL = vehicle (leader _unitG);
		_ct = 0;
		_range = 3000;


		waituntil
			{
			sleep 5;

			_endThis = false;
				//_Trg = _unitG getVariable ["CurrCASTgt",_Trg];
			_newTrg = objNull;

			if ((isNull (_unitG getVariable ["CurrCASObjSetByLead",objNull])) and not (isNull _Trg)) then {
				_nearEnVeh = [(_unitG targets [true, 1500]), [], {_casPos distance _x }, "ASCEND",{not (_x isKindOf "Man") and (((vehicle _x) distance _casPos) < 750)}] call BIS_fnc_sortBy;
				_nearEnInfHALG = [(_HQ getVariable ["RydHQ_KnEnemiesG",[]]), [], {_casPos distance (vehicle (leader _x))}, "ASCEND",{(((vehicle (leader _x)) distance _casPos) < 750)}] call BIS_fnc_sortBy;
				if (((vehicle _Trg) distance _casPos) > 750) then {{{if (_Trg == (vehicle _x) or _Trg == (_x)) exitwith {_Trg = objNull;}} foreach (units _x)} foreach _nearEnInfHALG};
				if (not (_Trg in _nearEnVeh) and ((count _nearEnVeh) > 0)) then {_Trg = objNull;};
			};

			_friends = [];
			{{_friends pushBackUnique (vehicle _x)} foreach (units _x)} foreach (_HQ getVariable ["RydHQ_Friends",[]]);

			if (not (alive _Trg) or (isNull _Trg)) then {

				_Trg = objNull;
				_newTrg = objNull;

				_nearEnVeh = [(_unitG targets [true, 1500]), [], {_casPos distance _x }, "ASCEND",{not (_x isKindOf "Man")}] call BIS_fnc_sortBy;
				_nearEnInf = [(_unitG targets [true, 1500]), [], {_casPos distance _x }, "ASCEND",{((vehicle _x) isKindOf "Man") and (3 < (count (units (group _x))))}] call BIS_fnc_sortBy;
				_nearEnInfHALG = [(_HQ getVariable ["RydHQ_KnEnemiesG",[]]), [], {_casPos distance (vehicle (leader _x))}, "ASCEND",{((vehicle (leader _x)) isKindOf "Man") and (3 < (count (units _x)))}] call BIS_fnc_sortBy; 
				

				{
					_range = _x;
					{
						_tUnit = (vehicle _x);
						_distOK = true;
						{if ((_tUnit distance (vehicle _x)) < 75) exitwith {_distOK = false} } foreach _friends;
						if ((((vehicle _x) distance _casPos) < _range) and (_distOK) and (((getpos (vehicle _x)) select 2) < 10)) exitwith {_newTrg = _tUnit;}
					} foreach _nearEnVeh;

						
					if (isNull (_newTrg)) then {
						{
							_tUnit = (vehicle _x);
							_distOK = true;
							{if ((_tUnit distance (vehicle _x)) < 75) exitwith {_distOK = false} } foreach _friends;
							if ((((vehicle _x) distance _casPos) < (_range)) and (_distOK)) exitwith {_newTrg = (vehicle _x);}
						} foreach _nearEnInf;
					};	

					if ((isNull (_newTrg)) and (_range < 2000)) then {
						{
							{
								_tUnit = (vehicle _x);
								_distOK = true;
								{if ((_tUnit distance (vehicle _x)) < 75) exitwith {_distOK = false} } foreach _friends;
								if ((((vehicle _x) distance _casPos) < (_range)) and (_distOK) and (((side _unitG) knowsAbout (vehicle _x)) > 0)) exitwith {_newTrg = (vehicle _x);}
							} foreach (units _x);
							if not (isNull (_newTrg)) exitwith {};
						} foreach _nearEnInfHALG;
					};	
					if (isNull (_newTrg)) exitwith {};			
				} foreach [750,1500,3000,6000];
				

				if not (isNull (_newTrg)) then {
					_Trg = _newTrg;
					if not (isNull _lasT) then {deleteVehicle _lasT};
					_lasT = createVehicle [_tgt, _Trg, [], 0, "CAN_COLLIDE"];
					_lasT attachTo [_Trg];

					_eSide reportRemoteTarget [_lasT, 1500]; 
					_lasT confirmSensorTarget [_eSide, true];
					_VL doTarget _lasT;
					_reqTgtSet = true;
					_unitG setVariable ["CurrCASObjSetByLead",objNull];							
							
				};
			};

			_hideNow = false;

			if not (isNull (_lasT)) then {{if (75 >= (_lasT distance2D _x)) exitwith {_hideNow = true;}} foreach (_friends)};
			if (isNull (_Trg)) then {_hideNow = true};

			if (_hideNow) then {if not (isNull (_lasT)) then {_lasT hideObjectGlobal true; deleteVehicle _lasT;};_Trg = objNull;} else {if not (isNull (_lasT)) then {_lasT hideObjectGlobal false};};

				
			if (((getpos (vehicle _Trg)) select 2) > 10) then {_Trg = objNull; deleteVehicle _lasT;};
			if ((isNull _Trg) or not (alive _Trg) or not (((side _unitG) knowsAbout _Trg) > 0)) then {_Trg = objNull; deleteVehicle _lasT;};
			if (not (alive _VL)) then {_endThis = true};
			if (({alive _x} count (units _unitG)) < 1) then {_endThis = true};
			if (_ct >= 1200) then {_endThis = true};
			_isBusy = _unitG getVariable [("Busy" + (str _unitG)),false];
			if not (_isBusy) then {_endThis = true};
			if ((((_VL getVariable ["SortiePylons",0])/4) > (count (getPylonMagazines _VL))) or ((damage _VL) > 0.5) or ((fuel _VL) < 0.3)) then {_endThis = true; if not (_unitG getVariable ["CurrCASLazeOff",false]) then {deletewaypoint [(_unitG), 0]}};

				
			_ct = _ct + 5;

			_unitG setVariable ["CurrCASTgt",_Trg];
			_unitG setVariable ["CurrCASLaze",_lasT];
			_unitG setVariable ["CurrCASDone",_endThis];
			//Variables for testing or for use to fetch current target of CAS run


			(_endThis) or (_unitG getVariable ["CurrCASLazeOff",false])
			};

		if (not (isNull _lasT)) then {deleteVehicle _lasT};
		_unitG setVariable ["RydHQ_WaitingTarget",nil];
		};
		
	[_Trg,_lasT,_unitG,_HQ,[_posX,_posY],_reqTgtSet,_wp,_tgt,_eSide] call _code;
	};

if (not (_request) and not (_unitG in (_HQ getVariable ["RydHQ_BAirG",[]]))) then {_unitG setVariable ["RydHQ_WaitingTarget",_this select 1]};
private _WaitCarrier = createGroup sideLogic;

_WaitCarrier setVariable ["_continueAW",false];
[_WaitCarrier,_unitG,6,true,0,120,[],false] call RYD_Wait; 
waitUntil {_WaitCarrier getVariable ["_continueAW",false];}; diag_log text "RYD_Wait code finished, waituntil passed";
_WaitCarrier setVariable ["_continueAW",false];
_timer = _WaitCarrier getVariable "_timer";
_alive = _WaitCarrier getVariable "_alive";
deleteGroup _WaitCarrier;


_unitG setVariable ["CurrCASLazeOff",true];
_unitG setVariable ["CurrCASObjSetByLead",objNull];

if not (_alive) exitwith 
	{
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markAttack" + str (_unitG))};
	if not (isNull _lasT) then {deleteVehicle _lasT};
	_unitG setVariable [("Busy" + (str _unitG)),false];
	if not (_request) then {[_Trg,"AirAttacked"] call RYD_VarReductor}
	};

if (_timer > 120) then {deleteWaypoint _wp};

if not (_task isEqualTo taskNull) then
	{
	
	[_task,(leader _unitG),["Return to base.", "Return To Base", ""],_Posland,"ASSIGNED",0,false,true] call BIS_fnc_SetTask;
	
	};

if (_HQ getVariable ["RydHQ_Debug",false]) then {_i setMarkerColor "ColorBlue"};
if (_unitG in (_HQ getVariable ["RydHQ_BAirG",[]])) then {if not (isNull _lasT) then {deleteVehicle _lasT}};

_rrr = (_unitG getVariable ["Ryd_RRR",false]);

_radd = "";
if (_rrr) then {_radd = "; {(vehicle _x) setFuel 1; (vehicle _x) setVehicleAmmo 1; (vehicle _x) setDamage 0;} foreach (units (group this))"};

_wp = [_unitG,_Posland,"MOVE","SAFE","GREEN","NORMAL",["true", "if not ((group this) getVariable ['AirNoLand',false]) then {{(vehicle _x) land 'LAND'} foreach (units (group this))}; deletewaypoint [(group this), 0]" + _radd],true,0,[0,0,0],"COLUMN"] call RYD_WPadd;

_mustRTB = false;

{
	if ((((_x getVariable ["SortiePylons",0])/2) > (count (getPylonMagazines _x))) or ((damage _x) > 0.5) or ((fuel _x) < 0.3)) then {_mustRTB = true;};

} foreach _flight;


if (_mustRTB) then {
	private _WaitCarrier = createGroup sideLogic;

	_WaitCarrier setVariable ["_continueAW",false];
	[_WaitCarrier,_unitG,6,true,0,24,[],false] call RYD_Wait; 
	waitUntil {_WaitCarrier getVariable ["_continueAW",false];}; diag_log text "RYD_Wait code finished, waituntil passed";
	_WaitCarrier setVariable ["_continueAW",false];
	_timer = _WaitCarrier getVariable "_timer";
	_alive = _WaitCarrier getVariable "_alive";
	deleteGroup _WaitCarrier;

	if not (_alive) exitwith 
		{
		if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markAttack" + str (_unitG))};
		_unitG setVariable [("Busy" + (str _unitG)),false];
		if not (_request) then {[_Trg,"AirAttacked"] call RYD_VarReductor}
		};
	if (_timer > 24) then {deleteWaypoint _wp};

};


if (not (_task isEqualTo taskNull) and not (alive _Trg)) then {[_task,"SUCCEEDED",true] call BIS_fnc_taskSetState};

if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markAttack" + str (_unitG))};

_attAv = _HQ getVariable ["RydHQ_AttackAv",[]];
_attAv pushBack _unitG;
_HQ setVariable ["RydHQ_AttackAv",_attAv];
 
_unitG setVariable [("Busy" + (str _unitG)),false];

if not (_request) then {[_Trg,"AirAttacked"] call RYD_VarReductor};


_UL = leader _unitG;
if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdEnd,"OrdEnd"] call RYD_AIChatter}};
