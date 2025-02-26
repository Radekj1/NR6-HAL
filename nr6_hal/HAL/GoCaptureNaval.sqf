_SCRname = "GoCaptureNaval";

_i = "";

_unitG = _this select 0;_Spos = _unitG getVariable ("START" + (str _unitG));if (isNil ("_Spos")) then {_unitG setVariable [("START" + (str _unitG)),(getPosATL (vehicle (leader _unitG)))];_Spos = _unitG getVariable ("START" + (str _unitG))}; 
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


if not (_isWater) exitWith 
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
	
[_unitG,[_posX,_posY,0],"HQ_ord_captureNav",_HQ] call RYD_OrderPause;

if ((isPlayer (leader _unitG)) and (RydxHQ_GPauseActive)) then {hintC "New orders from HQ!";setAccTime 1};

_UL = leader _unitG;
 
if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdConf,"OrdConf"] call RYD_AIChatter}};

if (_HQ getVariable ["RydHQ_Debug",false]) then 
	{
	_signum = _HQ getVariable ["RydHQ_CodeSign","X"];
	_i = [[_posX,_posY],_unitG,"markCapture","ColorRed","ICON","waypoint","CAP " + (groupId _unitG) + " " + _signum," - SECURE AREA",[0.5,0.5]] call RYD_Mark
	};


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


if not (_unitG getVariable [("Busy" + (str _unitG)),false]) exitWith {};


_AV = assignedVehicle _UL;
_DAV = assignedDriver _AV;
_GDV = group _DAV;

_task = [(leader _unitG),["Secure the objective. Neutralize any hostile ships and hold the objective.", "Secure And Hold Objective", ""],[_posX,_posY],"move"] call RYD_AddTask;


_gp = _unitG;
_pos = [_posX,_posY];
_tp = "MOVE";

_beh = "AWARE";
_lz = objNull;


_spd = "NORMAL";
//if ((isNull _AV) and (([_posX,_posY] distance _UL) > 1000) and not (_NeNMode)) then {_spd = "LIMITED";_beh = "SAFE"};
_TO = [0,0,0];
if ((isNull _AV) and (([_posX,_posY] distance _UL) <= 1000) or ((_NeNMode) and (isNull _AV))) then {_TO = [40, 45, 50]};
_crr = false;
if ((_nW == 1) and (isNull _AV)) then {_crr = true};
if not (isNull _AV) then {_crr = true};
_sts = ["true","deletewaypoint [(group this), 0];"];

_EDPos = _GDV getVariable "RydHQ_EDPos";
_earlyD = false;


_wp = [_gp,_pos,_tp,_beh,"YELLOW",_spd,_sts,_crr,0,_TO] call RYD_WPadd;
if ((isPlayer (leader _gp)) and ((_GDV == _unitG) or (isNull _GDV))) then {deleteWaypoint _wp};

_DAV = assignedDriver _AV;
_alive = false;
_timer = 0;
_OtherGroup = false;
_GDV = group _DAV;
_enemy = false;

//_lz = objNull;

_unitG setVariable ["RydHQ_WaitingObjective",[_HQ,_trg]];
_cause = [_unitG,6,true,400,30,[(_HQ getVariable ["RydHQ_AirG",[]]),(_HQ getVariable ["RydHQ_KnEnemiesG",[]])],false] call RYD_Wait;
_timer = _cause select 0;
_alive = _cause select 1;
_enemy = _cause select 2;

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
		}
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

	};

_UL = leader _unitG;if not (isPlayer _UL) then {if (not (_halfway) and (_timer <= 30) and not (_enemy)) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdFinal,"OrdFinal"] call RYD_AIChatter}}};


//if not (isNull _lz) then {deleteVehicle _lz};


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
	};

_timer = 0;


_alive = true;


if not (_task isEqualTo taskNull) then
	{	 
	[_task,(leader _unitG),["Secure the objective. Neutralize any hostile ships and hold the objective.", "Secure And Hold Objective", ""],(getPosATL _Trg),"ASSIGNED",0,false,true] call BIS_fnc_SetTask;
	};

_beh = "AWARE";
_spd = "NORMAL";
//if (not (_enemy) and not (_halfway) and (((vehicle (leader _unitG)) distance _Trg) > 1000) and not (_NeNMode)) then {_spd = "LIMITED";_beh = "SAFE"};
_frm = formation _unitG;
if not (isPlayer (leader _unitG)) then {_frm = "WEDGE"};

_wp = [_unitG,_Trg,"SAD",_beh,"RED",_spd,["true","deletewaypoint [(group this), 0];"],true,100,[0,0,0],_frm] call RYD_WPadd;

_unitG setVariable ["RydHQ_WaitingObjective",[_HQ,_trg]];
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


//if not (_task isEqualTo taskNull) then {[_task,"SUCCEEDED",true] call BIS_fnc_taskSetState};

if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markCapture" + str (_unitG))};

_all = true;

	{
	if ((_x in (_HQ getVariable ["RydHQ_AttackAv",[]])) and not (_x getVariable ("Busy" + str (_x)))) exitWith {_all = false};
	}
forEach (_HQ getVariable ["RydHQ_NavalG",[]]) - (((_HQ getVariable ["RydHQ_AirG",[]]) - (_HQ getVariable ["RydHQ_NCrewInfG",[]])) + (_HQ getVariable ["RydHQ_StaticG",[]]) + (_HQ getVariable ["RydHQ_SupportG",[]]) + (_HQ getVariable ["RydHQ_ArtG",[]]) + ((_HQ getVariable ["RydHQ_NCCargoG",[]]) - ((_HQ getVariable ["RydHQ_NCrewInfG",[]]) - (_HQ getVariable ["RydHQ_SupportG",[]]))));

//_pass orderGetIn true;

_attAv = _HQ getVariable ["RydHQ_AttackAv",[]];
_attAv pushBack _unitG;
_HQ setVariable ["RydHQ_AttackAv",_attAv];

_unitG setVariable [("Busy" + (str _unitG)),false];
_unitG setVariable [("Capt" + (str _unitG)),false];
//if ((((_Trg getvariable ("Capturing" + (str  _Trg) + (str _HQ))) select 0) > 3)  or (_all)) then {_Trg setvariable [("Capturing" + (str  _Trg) + (str _HQ)),[0,0]]};

_UL = leader _unitG;if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdEnd,"OrdEnd"] call RYD_AIChatter}};