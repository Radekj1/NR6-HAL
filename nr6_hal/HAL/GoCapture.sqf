_SCRname = "GoCapture";

_i = "";

_unitG = _this select 0;
_Spos = _unitG getVariable ("START" + (str _unitG));if (isNil ("_Spos")) then {_unitG setVariable [("START" + (str _unitG)),(getPosATL (vehicle (leader _unitG)))];_Spos = _unitG getVariable ("START" + (str _unitG))}; 
_Trg = objNull;
_isAttacked = _this select 1;
_HQ = _this select 2;

_amountG = count (units _unitG);

//_Trg = _HQ getVariable ["RydHQ_Obj",(leader _HQ)];
_Trg = _this select 3;

_PosObj1 = getPosATL _Trg;
_unitvar = str _unitG;

[_unitG] call RYD_WPdel;

_IsAPlayer = false;
if (RydxHQ_NoCargoPlayers and (isPlayer (leader _unitG))) then {_IsAPlayer = true};

_currentObj = _HQ getVariable ["RydHQ_NObj",1];
_BBProg = _HQ getVariable ["BBProgress",0];

_unitG setVariable [("Capt" + (str _unitG)),true];

_UL = leader _unitG;
_nothing = true;

_dX = (_PosObj1 select 0) - ((getPosATL (leader _HQ)) select 0);
_dY = (_PosObj1 select 1) - ((getPosATL (leader _HQ)) select 1);

_dXD = (_PosObj1 select 0) - ((getPosATL (leader _unitG)) select 0);
_dYD = (_PosObj1 select 1) - ((getPosATL (leader _unitG)) select 1);

_angle = _dX atan2 _dY;
_angleD = _dXD atan2 _dYD;

_distance = (leader _HQ) distance _PosObj1;
_distanceD = (leader _unitG) distance _PosObj1;
_distance2 = 100;

_dstMpl = (_HQ getVariable ["RydHQ_CaptureDistance",1]) * (_unitG getVariable ["RydHQ_myAttDst",1]);
_distance2 = _distance2 * _dstMpl;

_dXc = _distance2 * (cos _angle);
_dYc = _distance2 * (sin _angle);

switch (_isAttacked) do
	{
	case (3) : {_dYc = - _dYc};
	case (2) : {_dXc = - _dXc};
	case (1) : {_distance = _distance - _distance2;_dXc = 0;_dYc = 0};
	default {_dXc = 0;_dYc = 0};
	};

_dXb = _distance * (sin _angle);
_dYb = _distance * (cos _angle);

_posX = ((getPosATL (leader _HQ)) select 0) + _dXb + _dXc + (random 200) -  100;
_posY = ((getPosATL (leader _HQ)) select 1) + _dYb + _dYc + (random 200) -  100;

_dropposX = ((getPosATL (leader _unitG)) select 0) + ((_distanceD - (random [400,500,550]))* (sin _angleD));
_dropposY = ((getPosATL (leader _unitG)) select 1) + ((_distanceD - (random [400,500,550]))* (cos _angleD));

_isWater = surfaceIsWater [_posX,_posY];

while {((_isWater) and (([_posX,_posY] distance _PosObj1) >= 10))} do
	{
	_posX = _posX - _dXc/20;
	_posY = _posY - _dYc/20;
	_isWater = surfaceIsWater [_posX,_posY];
	};

_isWater = surfaceIsWater [_posX,_posY];

if (_isWater) exitWith 
	{
	_isAttacked = _Trg getVariable ("Capturing" + (str _Trg) + (str _HQ));
	_amountC = _isAttacked select 1;
	_amountC = _amountC - _amountG;
	_isAttacked = _isAttacked select 0;
	_isAttacked = _isAttacked - 1;
	_Trg setVariable [("Capturing" + (str _Trg) + (str _HQ)),[_isAttacked,_amountC]];
	_attAv = _HQ getVariable ["RydHQ_AttackAv",[]];
	_attAv pushBack _unitG;
	_HQ setVariable ["RydHQ_AttackAv",_attAv];
	_unitG setVariable [("Busy" + (str _unitG)),false];
	_unitG setVariable [("Capt" + (str _unitG)),false];
	};
	
[_unitG,[_posX,_posY,0],"HQ_ord_capture",_HQ] call RYD_OrderPause;

if ((isPlayer (leader _unitG)) and (RydxHQ_GPauseActive)) then {hintC "New orders from HQ!";setAccTime 1};

_UL = leader _unitG;
 
if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdConf,"OrdConf"] call RYD_AIChatter}};

if (_HQ getVariable ["RydHQ_Debug",false]) then 
	{
	_signum = _HQ getVariable ["RydHQ_CodeSign","X"];
	_i = [[_posX,_posY],_unitG,"markCapture","ColorRed","ICON","waypoint","CAP " + (groupId _unitG) + " " + _signum," - SECURE AREA",[0.5,0.5]] call RYD_Mark
	};

_alive = true;
_timer = 0;
_AV = assignedVehicle _UL;

if not (isNull _AV) then { 

	{
		if (isNull (assignedVehicle _x)) then {_x assignAsCargo _AV};
	} forEach (units _unitG);
};
/*
if (((_HQ getVariable ["RydHQ_CargoFind",0]) > 0) and not (_IsAPlayer) and (isNull _AV) and (([_posX,_posY] distance (vehicle _UL)) > 1500)) then 
	{
	//[_unitG,_HQ,[_posX,_posY]] spawn HAL_SCargo
	[[_unitG,_HQ,[_posX,_posY]],HAL_SCargo] call RYD_Spawn;
	} 
else 
	{
	_unitG setVariable [("CC" + _unitvar), true]
	};
	
if (((_HQ getVariable ["RydHQ_CargoFind",0]) > 0) and not (_IsAPlayer)) then 
	{	
	waituntil 
		{
		sleep 0.05;
		switch (true) do
			{
			case (isNull _unitG) : {_alive = false};
			case (({alive _x} count (units _unitG)) < 1) : {_alive = false};
			case ((_this select 0) getVariable ["RydHQ_MIA",false]) : {_alive = false;(_this select 0) setVariable ["RydHQ_MIA",nil]};
			case (_unitG getVariable ["Break",false]) : {_alive = false; _unitG setVariable ["Break",false];};
			};
			
		_cc = false;
		if (_alive) then
			{
			_cc = (_unitG getvariable ("CC" + _unitvar))
			};
			
		(not (_alive) or (_cc))
		};
		
	if not (isNull _unitG) then {_unitG setVariable [("CC" + _unitvar), false]};
	};

if not (_alive) exitWith 
	{
	_isAttacked = _Trg getVariable ("Capturing" + (str _Trg) + (str _HQ));
	_amountC = _isAttacked select 1;
	_amountC = _amountC - _amountG;
	_isAttacked = _isAttacked select 0;
	_isAttacked = _isAttacked - 1;
	_unitG setVariable [("Capt" + (str _unitG)),false];
	_unitG setVariable [("Busy" + (str _unitG)),false];
	_Trg setVariable [("Capturing" + (str _Trg) + (str _HQ)),[_isAttacked,_amountC]];
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
		{
		deleteMarker ("markCapture" + str (_unitG))
		}
	};
	
_AV = assignedVehicle _UL;
_DAV = assigneddriver _AV;
_GDV = group _DAV;
_alive = false;
_timer = 0;
_task = taskNull;

[_unitG] call RYD_WPdel;


if (not (isNull _AV) and ((_HQ getVariable ["RydHQ_CargoFind",0]) > 0) and not (_GDV == _unitG) and not (_IsAPlayer)) then
	{
	_task = [(leader _unitG),["Embark your lift", "Get In Lift", ""],(getPosATL (leader _unitG)),"getin"] call RYD_AddTask;
	
	_wp = [_unitG,_AV,"GETIN"] call RYD_WPadd;
	_wp waypointAttachVehicle _AV;
	_wp setWaypointCompletionRadius 750;

	{if (not (isPlayer (leader _unitG)) and not (_GDV == _unitG))  then {_x assignAsCargo _AV; [[_x],true] remoteExecCall ["orderGetIn",0]}} foreach (units _unitG);

	_cause = [_unitG,1,false,0,300,[],true,false,true,false,false,false] call RYD_Wait;
	_timer = _cause select 0;
	_AV land 'NONE';
	};
	
if (isNil "_timer") then {_timer = 0};

if ((({alive _x} count (units _unitG)) < 1) or (_timer > 300)) exitwith 
	{
	if not (({alive _x} count (units _unitG)) < 1) then {_unitG setVariable [("Capt" + (str _unitG)),false]};
	_isAttacked = _Trg getVariable ("Capturing" + (str _Trg) + (str _HQ));
	_amountC = _isAttacked select 1;
	_amountC = _amountC - _amountG;
	_isAttacked = _isAttacked select 0;
	_isAttacked = _isAttacked - 1;
	_unitG setVariable [("Busy" + (str _unitG)),false];

	{if (not (isPlayer (leader _unitG)) and not (_GDV == _unitG)) then {[_x] remoteExecCall ["RYD_MP_unassignVehicle",0]; [[_x],false] remoteExecCall ["orderGetIn",0];}} foreach (units _unitG);

	if not (_task isEqualTo taskNull) then {[_task,"CANCELED",true] call BIS_fnc_taskSetState};

	_Trg setVariable [("Capturing" + (str _Trg) + (str _HQ)),[_isAttacked,_amountC]];
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markCapture" + str (_unitG))};
	if not (isNull _GDV) then 
		{
		[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 0];
		_GDV setVariable [("CargoM" + (str _GDV)), false];
		}
	};

if not (_task isEqualTo taskNull) then {[_task,"SUCCEEDED",true] call BIS_fnc_taskSetState};
*/
_AV = assignedVehicle _UL;
_DAV = assignedDriver _AV;
_GDV = group _DAV;
_wp0 = [];_wp = [];
_nW = 1;

_LX1 = _posX;
_LY1 = _posY;
_EnNearTrg = false;
_NeNMode = false;
_halfway = false;
_mpl = 1;

_eClose1 = [[_posX,_posY],(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),300] call RYD_CloseEnemyB;

_tooC1 = _eClose1 select 0;
_dstEM1 = _eClose1 select 1;
_NeN = _eClose1 select 2;

if not (isNull _NeN) then
	{
	_eClose2 = [_UL,(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),300] call RYD_CloseEnemyB;
	_tooC2 = _eClose2 select 0;
	_dstEM2 = _eClose2 select 1;
	_eClose3 = [(leader _HQ),(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),300] call RYD_CloseEnemyB;
	_tooC3 = _eClose3 select 0;

	if ((_tooC1) or (_tooC2) or (_tooC3) or (((_UL distance [_posX,_posY]) - _dstEM2) > _dstEM1)) then {_EnNearTrg = true}
	};

if (_EnNearTrg) then {_NeNMode = true};
if (not (isNull _GDV) and (_GDV in ((_HQ getVariable ["RydHQ_NCCargoG",[]]) + (_HQ getVariable ["RydHQ_AirG",[]]))) and (_NeNMode) and not (isPlayer (leader _GDV))) then {_LX1 = (getPosATL _UL) select 0;_LY1 = (getPosATL _UL) select 1;_halfway = true};

if ((isNull _AV) and (([_posX,_posY] distance _UL) > RydxHQ_CargoObjRange) and not (_isAPlayer)) then
	{
	_LX = (getPosATL _UL) select 0;
	_LY = (getPosATL _UL) select 1;

//	_beh = "SAFE";
//	_spd = "LIMITED";
	_spd = "NORMAL";
	_beh = "AWARE";
	_TO = [0,0,0];
	if (_NeNMode) then {_spd = "NORMAL";_TO = [40, 45, 50];_beh = "AWARE"};

	_wp0 = [_unitG,[_posX,_posY],"MOVE",_beh,"YELLOW",_spd,["true","deletewaypoint [(group this), 0];"],true,0,_TO] call RYD_WPadd;
	
	_nW = 2;

	_endThis = false;

	waitUntil
		{
		sleep 5;

//		if not ((_HQ getVariable ["RydHQ_Order","ATTACK"]) == "DEFEND") then {_unitG setVariable [("Busy" + _unitvar), false];} else {_unitG setVariable [("Busy" + _unitvar), true];};
		
		if ((abs (speed (vehicle (leader _unitG))) < 0.05) and not (_unitG getVariable ["CargoChosen",false])) then {_timer = _timer + 5};

		if ((isNull _unitG) or (isNull _HQ)) then {_endThis = true;_alive = false};
		if (({alive _x} count (units _unitG)) < 1) then {_endThis = true;_alive = false};
		if (_unitG getVariable ["Break",false]) then {_endThis = true;_alive = false; _unitG setVariable ["Break",false];};

		if (((vehicle (leader _unitG)) distance [_posX,_posY]) < 1500) then {_endThis = true;};

		if (_timer > 30) then {_endThis = true};

		//New Cargo???

		_alive = true;
		_CargoCheck = _unitG getVariable ("CC" + _unitvar);
		if (isNil ("_CargoCheck")) then {_unitG setVariable [("CC" + _unitvar), true]};
		_AV = assignedVehicle _UL;

		if not (isNull _AV) then { 

			{
				if (isNull (assignedVehicle _x)) then {_x assignAsCargo _AV};
			} forEach (units _unitG);
		};

		if (((_HQ getVariable ["RydHQ_CargoFind",0]) > 0) and not (_IsAPlayer) and (isNull _AV) and (([_posX,_posY] distance (vehicle _UL)) > 1000) and not (_unitG getVariable ["CargoCheckPending" + (str _unitG),false])) then 
			{
			//[_unitG,_HQ,[_posX,_posY]] spawn HAL_SCargo
			[[_unitG,_HQ,[_posX,_posY]],HAL_SCargo] call RYD_Spawn;
			} 
		else 
			{
			if not (_unitG getVariable ["CargoCheckPending" + (str _unitG),false]) then {_unitG setVariable [("CC" + _unitvar), true]};
			};
			
		if (((_HQ getVariable ["RydHQ_CargoFind",0]) > 0) and not (_IsAPlayer) and not (_unitG getVariable ["CargoCheckPending" + (str _unitG),false])) then 
			{	
			waitUntil 
				{
				sleep 2;
				switch (true) do
					{
					case (isNull _unitG) : {_alive = false};
					case (({alive _x} count (units _unitG)) < 1) : {_alive = false};
					case ((_this select 0) getVariable ["RydHQ_MIA",false]) : {_alive = false;(_this select 0) setVariable ["RydHQ_MIA",nil]};
					case (_unitG getVariable ["Break",false]) : {_alive = false; _unitG setVariable ["Break",false];}
					};
					
				_cc = false;
				if (_alive) then
					{
					_cc = (_unitG getVariable ("CC" + _unitvar))
					};

				if ((_unitG getVariable ["CargoChosen",false]) and not ((count (waypoints _unitG)) < 1)) then {[_unitG, (currentWaypoint _unitG)] setWaypointPosition [getPosATL (vehicle (leader _unitG)), 0]; _wp0 = [];};
					
				(not (_alive) or (_cc))
				};
				
			if not (isNull _unitG) then {_unitG setVariable [("CC" + _unitvar), false]};
			};

		if (not (_unitG getVariable ["CargoChosen",false]) and not (_unitG getVariable ["CargoCheckPending" + (str _unitG),false])) then 
			{
				if (_wp0 isEqualTo []) then {_wp0 = [_unitG,[_posX,_posY],"MOVE",_beh,"YELLOW",_spd,["true","deletewaypoint [(group this), 0];"],true,0,_TO] call RYD_WPadd;}
			} else {
				if not ((count (waypoints _unitG)) < 1) then {[_unitG, (currentWaypoint _unitG)] setWaypointPosition [getPosATL (vehicle (leader _unitG)), 0]; _wp0 = []};
			};

		if not (_alive) exitWith 
			{
			_isAttacked = _Trg getVariable ("Capturing" + (str _Trg) + (str _HQ));
			_amountC = _isAttacked select 1;
			_amountC = _amountC - _amountG;
			_isAttacked = _isAttacked select 0;
			_isAttacked = _isAttacked - 1;
			_unitG setVariable [("Capt" + (str _unitG)),false];
			_unitG setVariable [("Busy" + (str _unitG)),false];
			_Trg setVariable [("Capturing" + (str _Trg) + (str _HQ)),[_isAttacked,_amountC]];
			if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
				{
				deleteMarker ("markCapture" + str (_unitG))
				};
			(true)
			};

		_AV = assignedVehicle _UL;

		_DAV = assignedDriver _AV;
		_GDV = group _DAV;

		if (not (isNull _AV) and ((_HQ getVariable ["RydHQ_CargoFind",0]) > 0) and not (_GDV == _unitG) and not (_IsAPlayer)) then
			{
			_task = taskNull;
			_timer2 = 0;	

			_endThis = true;
			
			[_unitG] call RYD_WPdel;

			_task = [(leader _unitG),["Embark your lift", "Get In Lift", ""],(getPosATL (leader _unitG)),"getin"] call RYD_AddTask;

			_wp = [_unitG,_AV,"GETIN"] call RYD_WPadd;
			_wp waypointAttachVehicle _AV;
			_wp setWaypointCompletionRadius 750;

			{if (not (isPlayer (leader _unitG)) and not (_GDV == _unitG))  then {_x assignAsCargo _AV; [[_x],true] remoteExecCall ["orderGetIn",0];}} forEach (units _unitG);

			_cause = [_unitG,1,false,0,300,[],true,false,true,false,false,false] call RYD_Wait;
			_timer2 = _cause select 0;
			_AV land 'NONE';

			if not (_task isEqualTo taskNull) then {[_task,"SUCCEEDED",true] call BIS_fnc_taskSetState};

			if (isNil "_timer2") then {_timer2 = 0};

			if ((({alive _x} count (units _unitG)) < 1) or (_timer2 > 300)) exitWith 
				{
				if not (({alive _x} count (units _unitG)) < 1) then {_unitG setVariable [("Capt" + (str _unitG)),false]};
				_isAttacked = _Trg getVariable ("Capturing" + (str _Trg) + (str _HQ));
				_amountC = _isAttacked select 1;
				_amountC = _amountC - _amountG;
				_isAttacked = _isAttacked select 0;
				_isAttacked = _isAttacked - 1;
				_unitG setVariable [("Busy" + (str _unitG)),false];
				_unitG setVariable [("Capt" + (str _unitG)),false];
				{if (not (isPlayer (leader _unitG)) and not (_GDV == _unitG)) then {[_x] remoteExecCall ["RYD_MP_unassignVehicle",0]; [[_x],false] remoteExecCall ["orderGetIn",0];}} forEach (units _unitG);

				if not (_task isEqualTo taskNull) then {[_task,"CANCELED",true] call BIS_fnc_taskSetState};

				_Trg setVariable [("Capturing" + (str _Trg) + (str _HQ)),[_isAttacked,_amountC]];
				if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markCapture" + str (_unitG))};
				if not (isNull _GDV) then 
					{
					[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 0];
					_GDV setVariable [("CargoM" + (str _GDV)), false];
					};
				(true)
				};
			};

		//New Cargo!!!

		(_endThis)
		};	
	};

if not (_unitG getVariable [("Busy" + (str _unitG)),false]) exitWith {};

_AV = assignedVehicle _UL;
_DAV = assignedDriver _AV;
_GDV = group _DAV;

_LX1 = _posX;
_LY1 = _posY;

_SpX = _posX;
_SpY = _posY;

_EnNearTrg = false;
_NeNMode = false;
_halfway = false;
_mpl = 1;

_eClose1 = [[_posX,_posY],(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),400] call RYD_CloseEnemyB;

_tooC1 = _eClose1 select 0;
_dstEM1 = _eClose1 select 1;
_NeN = _eClose1 select 2;

if not (isNull _NeN) then
	{
	_eClose2 = [_UL,(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),600] call RYD_CloseEnemyB;
	_tooC2 = _eClose2 select 0;
	_dstEM2 = _eClose2 select 1;
	_eClose3 = [(leader _HQ),(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),600] call RYD_CloseEnemyB;
	_tooC3 = _eClose3 select 0;

	if ((_tooC1) or (_tooC2) or (_tooC3) or (((_UL distance [_posX,_posY]) - _dstEM2) > _dstEM1)) then {_EnNearTrg = true}
	};

if (_EnNearTrg) then {_NeNMode = true};
if (not (isNull _GDV) and (_GDV in ((_HQ getVariable ["RydHQ_NCCargoG",[]]) + (_HQ getVariable ["RydHQ_AirG",[]]))) and (_NeNMode)) then {_LX1 = (getPosATL _UL) select 0;_LY1 = (getPosATL _UL) select 1;_halfway = true};

if ((_halfway) and not (_IsAPlayer)) then {

	_dropposX = (_posX + _LX1)/2;
	_dropposY = (_posY + _LY1)/2;
};


_task = [(leader _unitG),["Secure the objective. Neutralize any hostile forces and hold the objective.", "Secure And Hold Objective", ""],[_posX,_posY],"move"] call RYD_AddTask;

_Ctask = taskNull;
if (not ((leader _GDV) == (leader _unitG)) and not (_GDV == _unitG)) then
	{
	_Ctask = [(leader _GDV),["Disembark " + (groupId _unitG) + " at  their designated destination.", "Drop Off " + (groupId _unitG), ""],[_dropposX,_dropposY],"getout"] call RYD_AddTask
	};

_gp = _unitG;
if (not (isNull _AV) and not (_GDV == _unitG) and not (_isAPlayer)) then {_gp = _GDV;_posX = _dropposX;_posY = _dropposY};
_pos = [_posX,_posY];
_tp = "MOVE";

_beh = "AWARE";
_lz = objNull;
if (not (isNull _AV) and (_GDV in (_HQ getVariable ["RydHQ_AirG",[]]))) then 
	{
	_beh = "STEALTH";
	if (_HQ getVariable ["RydHQ_LZ",false]) then
		{
		if not (isNull (_GDV getVariable ["tempLZ",objNull])) then {deleteVehicle (_GDV getVariable ["tempLZ",objNull])};
		
		_lz = [[_posX,_posY]] call RYD_LZ;
		_GDV setVariable ["TempLZ",_lz];
		if not (isNull _lz) then
			{
			_pos = getPosATL _lz;
			_posX = _pos select 0;
			_posY = _pos select 1
			}
		}
	};

_spd = "NORMAL";
//if ((isNull _AV) and (([_posX,_posY] distance _UL) > 1000) and not (_NeNMode)) then {_spd = "LIMITED";_beh = "SAFE"};
_TO = [0,0,0];
if ((isNull _AV) and (([_posX,_posY] distance _UL) <= 1000) or ((_NeNMode) and (isNull _AV))) then {_TO = [40, 45, 50]};
_crr = false;
if ((_nW == 1) and (isNull _AV)) then {_crr = true};
if not (isNull _AV) then {_crr = true};
_sts = ["true","deletewaypoint [(group this), 0];"];
if (((group (assignedDriver _AV)) in (_HQ getVariable ["RydHQ_AirG",[]])) and (_unitG in (_HQ getVariable ["RydHQ_NCrewInfG",[]]))) then {_sts = ["true","(vehicle this) land 'GET OUT';deletewaypoint [(group this), 0]"]};

_EDPos = _GDV getVariable "RydHQ_EDPos";
_earlyD = false;

if not (isNil "_EDPos") then
	{
	_earlyD = true;
	_EDPos = +_EDPos;
	_GDV setVariable ["RydHQ_EDPos",nil];
	
	if not (_halfway) then
		{
		_pos = _EDPos select 1
		}
	else
		{
		for "_i" from 100 to 600 step 100 do
			{
			_nR = _pos nearRoads _i;
			
			if ((count _nR) > 0) exitWith
				{
				_cR = [_pos,_nR] call RYD_FindClosest;
				
				_pos = getPosATL _cR;
				_ct = 0;
				
				while {(isOnRoad _pos)} do
					{
					_pos = [_pos,30] call RYD_RandomAround;
					_ct = _ct + 1;
					if (_ct > 50) exitWith {}
					}
				}
			}		
		}
	};


_wp = [_gp,_pos,_tp,_beh,"YELLOW",_spd,_sts,_crr,0,_TO] call RYD_WPadd;
if ((isPlayer (leader _gp)) and ((_GDV == _unitG) or (isNull _GDV))) then {deleteWaypoint _wp};

_posX = _SpX;
_posY = _SpY;
_pos = [_posX,_posY];

_DAV = assignedDriver _AV;
_alive = true;
_timer = 0;
_OtherGroup = false;
_GDV = group _DAV;
_enemy = false;

//_lz = objNull;

if not (_IsAPlayer) then {
	if not (((group _DAV) == (group _UL)) or (isNull (group _DAV))) then 
		{
		//if (_AV isKindOf "Air") then {_lz = [_pos] call RYD_LZ};

		_OtherGroup = true;

		_cause = [_GDV,6,true,300,30,[(_HQ getVariable ["RydHQ_AirG",[]]),(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),_HQ],false] call RYD_Wait;
		_timer = _cause select 0;
		_alive = _cause select 1;
		_enemy = _cause select 2;
		}
	else 
		{
		if not (_isAPlayer) then {_unitG setVariable ["InfGetinCheck" + (str _unitG),true]};
		_unitG setVariable ["RydHQ_WaitingObjective",[_HQ,_trg]];
		_cause = [_unitG,6,true,300,30,[(_HQ getVariable ["RydHQ_AirG",[]]),(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),_HQ],false] call RYD_Wait;
		_timer = _cause select 0;
		_alive = _cause select 1;
		_enemy = _cause select 2;
		};
};

_DAV = assignedDriver _AV;
if (((_timer > 30) or (_enemy)) and (_OtherGroup)) then {if not (isNull _GDV) then {[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 0]}};
if (((_timer > 30) or (_enemy)) and not (_OtherGroup)) then {[_unitG, (currentWaypoint _unitG)] setWaypointPosition [getPosATL (vehicle _UL), 0]};
if (not (_alive) and not (_OtherGroup)) exitWith 
	{
	_isAttacked = _Trg getVariable ("Capturing" + (str _Trg) + (str _HQ));
	_amountC = _isAttacked select 1;
	_amountC = _amountC - _amountG;
	_isAttacked = _isAttacked select 0;
	_isAttacked = _isAttacked - 1;
	_unitG setVariable [("Busy" + (str _unitG)),false];
	_unitG setVariable [("Capt" + (str _unitG)),false];
	_Trg setVariable [("Capturing" + (str _Trg) + (str _HQ)),[_isAttacked,_amountC]];
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
		{
		deleteMarker ("markCapture" + str (_unitG))
		};
	if not (isNull _GDV) then 
		{
		[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 0];
		_GDV setVariable [("CargoM" + (str _GDV)), false];
		};
	};

if (({alive _x} count (units _unitG)) < 1) exitWith 
	{
	_isAttacked = _Trg getVariable ("Capturing" + (str _Trg) + (str _HQ));
	_amountC = _isAttacked select 1;
	_amountC = _amountC - _amountG;
	_isAttacked = _isAttacked select 0;
	_isAttacked = _isAttacked - 1;
	_unitG setVariable [("Busy" + (str _unitG)),false];
	_unitG setVariable [("Capt" + (str _unitG)),false];
	_Trg setVariable [("Capturing" + (str _Trg) + (str _HQ)),[_isAttacked,_amountC]];
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
		{
		deleteMarker ("markCapture" + str (_unitG))
		};

	if not (isNull _GDV) then 
		{
		[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 0];
		_GDV setVariable [("CargoM" + (str _GDV)), false];
		};
	};

_UL = leader _unitG;if not (isPlayer _UL) then {if (not (_halfway) and (_timer <= 30) and not (_enemy)) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdFinal,"OrdFinal"] call RYD_AIChatter}}};

_AV = assignedVehicle _UL;
_pass = assignedCargo _AV;

_allowed = true;
if not ((_GDV == _unitG) or (isNull _GDV)) then 
	{
	{[[_x],false] remoteExecCall ["orderGetIn",0]} forEach _pass;
	_allowed = false;
	(units _unitG) allowGetIn false;
	[_unitG] call RYD_WPdel;
	//if (player in (units _unitG)) then {diag_log "NOT ALLOW capt"};
	}
else
	{
	//if (_unitG in (_HQ getVariable ["RydHQ_NCrewInfG",[]])) then {_pass orderGetIn false};
	};

//if not (isNull _lz) then {deleteVehicle _lz};

_DAV = assignedDriver _AV;
_GDV = group _DAV;

if (not (isNull _AV) and ((_HQ getVariable ["RydHQ_CargoFind",0]) > 0) and (_unitG in (_HQ getVariable ["RydHQ_NCrewInfG",[]])) and not (_GDV == _unitG) and not (_IsAPlayer)) then
	{
	_pass = (units _unitG);
	_cause = [_unitG,1,false,0,240,[],true,true,false,false,false,false,false,_pass,_AV] call RYD_Wait;
	_timer = _cause select 0
	};

if not ((_GDV == _unitG) or (isNull _GDV)) then 
	{
	{[[_x],false] remoteExecCall ["orderGetIn",0]} forEach (units _unitG);
	{[_x] remoteExecCall ["RYD_MP_unassignVehicle",0];} forEach (units _unitG);
	};

if not (_allowed) then {(units _unitG) allowGetIn true};
if (_HQ getVariable ["RydHQ_LZ",false]) then {deleteVehicle _lz};

if ((({alive _x} count (units _unitG)) < 1) or (_timer > 240)) exitWith 
	{
	if not (({alive _x} count (units _unitG)) < 1) then {_unitG setVariable [("Capt" + (str _unitG)),false]};
	_isAttacked = _Trg getVariable ("Capturing" + (str _Trg) + (str _HQ));
	_amountC = _isAttacked select 1;
	_amountC = _amountC - _amountG;
	_isAttacked = _isAttacked select 0;
	_isAttacked = _isAttacked - 1;
	_unitG setVariable [("Busy" + (str _unitG)),false];
	_unitG setVariable [("Capt" + (str _unitG)),false];
	_Trg setVariable [("Capturing" + (str _Trg) + (str _HQ)),[_isAttacked,_amountC]];
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
		{
		deleteMarker ("markCapture" + str (_unitG))
		};

	if not (_Ctask isEqualTo taskNull) then {[_Ctask,"CANCELED",true] call BIS_fnc_taskSetState};

	if not (isNull _GDV) then 
		{
		[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 0];
		_GDV setVariable [("CargoM" + (str _GDV)), false];
		//_pass orderGetIn true;
		}
	};

if not (_Ctask isEqualTo taskNull) then {[_Ctask,"SUCCEEDED",true] call BIS_fnc_taskSetState};

_unitvar = str _GDV;
_timer = 0;
if (not (isNull _GDV) and (_GDV in (_HQ getVariable ["RydHQ_AirG",[]])) and not (isPlayer (leader _GDV)) and not (_IsAPlayer)) then
	{
	_wp = [_GDV,[((getPosATL _AV) select 0) + (random 200) - 100,((getPosATL _AV) select 1) + (random 200) - 100,1000],"MOVE","STEALTH","YELLOW","NORMAL"] call RYD_WPadd;
	
	_cause = [_GDV,3,true,0,8,[],false] call RYD_Wait;
	_timer = _cause select 0;

	if (_timer > 8) then {[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 0]};
	};

if not (_IsAPlayer) then {_GDV setVariable [("CargoM" + (str _GDV)), false]};

_BBProgN = _HQ getVariable ["BBProgress",0];
if (_BBProgN > _BBProg) exitWith 
	{
	_unitG setVariable [("Capt" + (str _unitG)),false];
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markCapture" + str (_unitG))};
	//_pass orderGetIn true;
	_attAv = _HQ getVariable ["RydHQ_AttackAv",[]];
	_attAv pushBack _unitG;
	_HQ setVariable ["RydHQ_AttackAv",_attAv];
	_unitG setVariable [("Busy" + (str _unitG)),false];
	//_Trg setvariable [("Capturing" + (str  _Trg) + (str _HQ)),[0,0]]
	};

_alive = true;
if (((_halfway) or (_earlyD)) and not (_IsAPlayer)) then
	{
	_frm = formation _unitG;
	if not (isPlayer (leader _unitG)) then {_frm = "STAG COLUMN"};

	_wp = [_unitG,[_posX,_posY],"MOVE","AWARE","YELLOW","NORMAL",["true","deletewaypoint [(group this), 0];"],true,0,[0,0,0],_frm] call RYD_WPadd;
	if (isPlayer (leader _unitG)) then {deleteWaypoint _wp};

	_unitG setVariable ["RydHQ_WaitingObjective",[_HQ,_trg]];
	if not (_isAPlayer) then {_unitG setVariable ["InfGetinCheck" + (str _unitG),true]};
	_cause = [_unitG,6,true,0,30,[],false] call RYD_Wait;
	_timer = _cause select 0;
	_alive = _cause select 1;
	_enemy = _cause select 2;

	if not (_alive) exitWith 
		{
		_isAttacked = _Trg getVariable ("Capturing" + (str _Trg) + (str _HQ));
		_amountC = _isAttacked select 1;
		_amountC = _amountC - _amountG;
		_isAttacked = _isAttacked select 0;
		_isAttacked = _isAttacked - 1;
		_Trg setVariable [("Capturing" + (str _Trg) + (str _HQ)),[_isAttacked,_amountC]];
		_unitG setVariable [("Busy" + (str _unitG)),false];
		_unitG setVariable [("Capt" + (str _unitG)),false];
		if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
			{
			deleteMarker ("markCapture" + str (_unitG))
			}
		};

	if (_timer > 30) then {[_unitG, (currentWaypoint _unitG)] setWaypointPosition [getPosATL (vehicle _UL), 0]};

	_BBProgN = _HQ getVariable ["BBProgress",0];
	if (_BBProgN > _BBProg) exitWith 
		{
		if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markCapture" + str (_unitG))};
		//_pass orderGetIn true;
		_attAv = _HQ getVariable ["RydHQ_AttackAv",[]];
		_attAv pushBack _unitG;
		_HQ setVariable ["RydHQ_AttackAv",_attAv];
		_unitG setVariable [("Busy" + (str _unitG)),false];
		_unitG setVariable [("Capt" + (str _unitG)),false];
		//_Trg setvariable [("Capturing" + (str  _Trg) + (str _HQ)),[0,0]]
		}
	};

if (not (_alive) or (_BBProgN > _BBProg)) exitWith
	{
	if (_alive) then {_unitG setVariable [("Capt" + (str _unitG)),false]};
	_isAttacked = _Trg getVariable ("Capturing" + (str _Trg) + (str _HQ));
	_amountC = _isAttacked select 1;
	_amountC = _amountC - _amountG;
	_isAttacked = _isAttacked select 0;
	_isAttacked = _isAttacked - 1;
	_unitG setVariable [("Busy" + (str _unitG)),false];
	_unitG setVariable [("Capt" + (str _unitG)),false];
	_Trg setVariable [("Capturing" + (str _Trg) + (str _HQ)),[_isAttacked,_amountC]];
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
		{
		deleteMarker ("markCapture" + str (_unitG))
		}
	};

_UL = leader _unitG;if not (isPlayer _UL) then {if ((_halfway) and (_timer <= 30)) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdFinal,"OrdFinal"] call RYD_AIChatter}}};

if not (_task isEqualTo taskNull) then
	{	 
	[_task,(leader _unitG),["Secure the objective. Neutralize any hostile forces and hold the objective.", "Secure And Hold Objective", ""],(getPosATL _Trg),"ASSIGNED",0,false,true] call BIS_fnc_SetTask;
	};

_beh = "AWARE";
_spd = "NORMAL";
//if (not (_enemy) and not (_halfway) and (((vehicle (leader _unitG)) distance _Trg) > 1000) and not (_NeNMode)) then {_spd = "LIMITED";_beh = "SAFE"};
_frm = formation _unitG;
if not (isPlayer (leader _unitG)) then {_frm = "WEDGE"};

_wp = [_unitG,_Trg,"SAD",_beh,"RED",_spd,["true","deletewaypoint [(group this), 0];"],true,100,[0,0,0],_frm] call RYD_WPadd;

_unitG setVariable ["RydHQ_WaitingObjective",[_HQ,_trg]];
if not (_isAPlayer) then {_unitG setVariable ["InfGetinCheck" + (str _unitG),true]};
_cause = [_unitG,6,true,0,30,[],false] call RYD_Wait;
_timer = _cause select 0;
_alive = _cause select 1;

if not (_alive) exitWith 
	{
	_isAttacked = _Trg getVariable ("Capturing" + (str _Trg) + (str _HQ));
	_amountC = _isAttacked select 1;
	_amountC = _amountC - _amountG;
	_isAttacked = _isAttacked select 0;
	_isAttacked = _isAttacked - 1;
	_unitG setVariable [("Busy" + (str _unitG)),false];
	_unitG setVariable [("Capt" + (str _unitG)),false];
	_Trg setVariable [("Capturing" + (str _Trg) + (str _HQ)),[_isAttacked,_amountC]];
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
		{
		deleteMarker ("markCapture" + str (_unitG))
		}
	};

if (_timer > 30) then {[_unitG, (currentWaypoint _unitG)] setWaypointPosition [getPosATL (vehicle _UL), 0]};

if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {_i setMarkerColor "ColorBlue"};

_isTaken = false;
_waitTime = _HQ getVariable ["RydHQ_ObjHoldTime",600];

//_trg = (leader _HQ);
_nObj = _HQ getVariable ["RydHQ_NObj",1];
/*
switch (_nObj) do
	{
	case (1) : {_trg = (_HQ getVariable ["RydHQ_Obj1",(leader _HQ)])};
	case (2) : {_trg = (_HQ getVariable ["RydHQ_Obj2",(leader _HQ)])};
	case (3) : {_trg = (_HQ getVariable ["RydHQ_Obj3",(leader _HQ)])};
	default {_trg = (_HQ getVariable ["RydHQ_Obj4",(leader _HQ)])};
	};
*/
_mGain = 20;

if ((leader _HQ) in (RydBBa_HQs + RydBBb_HQs)) then {_mGain = 0};

_lastObj = _nObj;

waitUntil
	{
	sleep 30;//60
	_BBProgN = _HQ getVariable "BBProgress";
	if (isNil "_BBProgN") then {_BBProgN = 0};

	_SideAllies = [];
	_SideEnemies = [];

	{
		if (((side _HQ) getFriend _x) >= 0.6) then {_SideAllies pushBack _x} else {_SideEnemies pushBack _x};
	} forEach [west,east,resistance];
	
	if (not (_BBProgN > _BBProg)) then
		{
		_waitTime = _waitTime - 30;

		_AllV0 = _Trg nearEntities [["AllVehicles"],_HQ getVariable ["RydHQ_ObjRadius1",300]];

		_AllV = [];

			{
			_AllV = _AllV + (crew _x)
			}
		forEach _AllV0;

		_Civs0 = _Trg nearEntities [["Civilian"],_HQ getVariable ["RydHQ_ObjRadius1",300]];

		_Civs = [];

			{
			_Civs = _Civs + (crew _x)
			}
		forEach _Civs0;

		_AllV20 = _Trg nearEntities [["AllVehicles"],_HQ getVariable ["RydHQ_ObjRadius2",500]];

		_AllV2 = [];

			{
			_AllV2 = _AllV2 + (crew _x)
			}
		forEach _AllV20;

		_Civs20 = _Trg nearEntities [["Civilian"],_HQ getVariable ["RydHQ_ObjRadius2",500]];

		_Civs2 = [];

			{
			_Civs2 = _Civs2 + (crew _x)
			}
		forEach _Civs20;

		_AllV = _AllV - _Civs;
		_AllV2 = _AllV2 - _Civs2;

		_AllV0 = +_AllV;
		_AllV20 = +_AllV2;

			{
			if not (_x isKindOf "Man") then
				{
				if ((count (crew _x)) == 0) then {_AllV = _AllV - [_x]}
				}
			}
		forEach _AllV0;

			{
			if not (_x isKindOf "Man") then
				{
				if ((count (crew _x)) == 0) then {_AllV2 = _AllV2 - [_x]}
				}
			}
		forEach _AllV20;

		//_NearAllies = (leader _HQ) countfriendly _AllV;
		_NearAllies = ({(side _x) in _SideAllies} count _AllV);
		//_NearEnemies = (leader _HQ) countenemy _AllV2;
		_NearEnemies = ({(side _x) in _SideEnemies} count _AllV2);

		if (_trg in (_HQ getVariable ["RydHQ_Taken",[]])) then {_isTaken = true};

		if (not (_HQ getVariable ["RydHQ_UnlimitedCapt",false]) and (_NearAllies >= (_HQ getVariable ["RydHQ_CaptLimit",10])) and (_NearEnemies <= (0 + (((_HQ getVariable ["RydHQ_Recklessness",0.5])/(0.5 + (_HQ getVariable ["RydHQ_Consistency",0.5])))*10)))) then 
			{
			if (((_HQ getVariable ["BBProgress","nope"]) isEqualTo "nope") and not (_HQ getVariable ["RydHQ_SimpleMode",false])) then {_HQ setVariable ["RydHQ_NObj",(_HQ getVariable ["RydHQ_NObj",1]) + 1];};
			if ((random 100) < (15*(_HQ getVariable ["RydHQ_NObj",1]))) then 
				{
				_HQ setVariable ["RydHQ_FlankingDone",false];
				_HQ setVariable ["RydHQ_FlankingInit",false];
				_HQ setVariable ["RydHQ_FlankingTimeStamp",time];
				};
				
			_HQ setVariable ["RydHQ_Morale",(_HQ getVariable ["RydHQ_Morale",0]) + _mGain];
			_taken = _HQ getVariable ["RydHQ_Taken",[]];
			_taken pushBackUnique _trg;
			_HQ setVariable ["RydHQ_Taken",_taken]; 
			_isTaken = true
			};

		if ((_HQ getVariable ["RydHQ_NObj",1]) < 1) then {_HQ setVariable ["RydHQ_NObj",1]};
		if ((_HQ getVariable ["RydHQ_NObj",1]) > 5) then {_HQ setVariable ["RydHQ_NObj",5]};

		_HQ setVariable ["RydHQ_Progress",0];
		if (_lastObj > (_HQ getVariable ["RydHQ_NObj",1])) then {_HQ setVariable ["RydHQ_Progress",-1]};	
		if (_lastObj < (_HQ getVariable ["RydHQ_NObj",1])) then {_HQ setVariable ["RydHQ_Progress",1]}
		}
	else
		{
		if (not ((_HQ getVariable ["RydHQ_NObj",1]) < _currentObj) or (RydBB_Active)) then
			{
			_isTaken = true
			}
		else
			{
			_waitTime == 0
			}
		};

	((_isTaken) or (_waitTime <= 0))
	};

if ((_HQ getVariable ["RydHQ_UnlimitedCapt",false]) or not (_isTaken)) then {_Trg setVariable [("Capturing" + (str _Trg) + (str _HQ)),[0,0]]};

//if not (_task isEqualTo taskNull) then {[_task,"SUCCEEDED",true] call BIS_fnc_taskSetState};

if (not (_task isEqualTo taskNull) and (_isTaken)) then {[_task,"SUCCEEDED",true] call BIS_fnc_taskSetState};

if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markCapture" + str (_unitG))};

_all = true;

	{
	if ((_x in (_HQ getVariable ["RydHQ_AttackAv",[]])) and not (_x getVariable ("Busy" + str (_x)))) exitWith {_all = false};
	}
forEach (_HQ getVariable ["RydHQ_Friends",[]]) - (((_HQ getVariable ["RydHQ_AirG",[]]) - (_HQ getVariable ["RydHQ_NCrewInfG",[]])) + (_HQ getVariable ["RydHQ_NavalG",[]]) + (_HQ getVariable ["RydHQ_StaticG",[]]) + (_HQ getVariable ["RydHQ_SupportG",[]]) + (_HQ getVariable ["RydHQ_ArtG",[]]) + ((_HQ getVariable ["RydHQ_NCCargoG",[]]) - ((_HQ getVariable ["RydHQ_NCrewInfG",[]]) - (_HQ getVariable ["RydHQ_SupportG",[]]))));

//_pass orderGetIn true;

_attAv = _HQ getVariable ["RydHQ_AttackAv",[]];
_attAv pushBack _unitG;
_HQ setVariable ["RydHQ_AttackAv",_attAv];

_unitG setVariable [("Busy" + (str _unitG)),false];
_unitG setVariable [("Capt" + (str _unitG)),false];
//if ((((_Trg getvariable ("Capturing" + (str  _Trg) + (str _HQ))) select 0) > 3)  or (_all)) then {_Trg setvariable [("Capturing" + (str  _Trg) + (str _HQ)),[0,0]]};

_UL = leader _unitG;if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdEnd,"OrdEnd"] call RYD_AIChatter}};