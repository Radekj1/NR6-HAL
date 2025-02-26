_SCRname = "GoAttNaval";

_i = "";

_unitG = _this select 0;_Spos = _unitG getVariable ("START" + (str _unitG));if (isNil ("_Spos")) then {_unitG setVariable [("START" + (str _unitG)),(getPosATL (vehicle (leader _unitG)))];_Spos = _unitG getVariable ("START" + (str _unitG))}; 
_Trg = _this select 1;
_HQ = _this select 2;
_request = false;
if ((count _this) > 3) then {_request = _this select 3};


_isAttacked = (group _Trg) getVariable ("Attacked" + (str (group _Trg)));
if (isNil ("_isAttacked")) then {_isAttacked = 0};


_PosObj1 = getPosATL _Trg;
_unitvar = str (_unitG);
_busy = false;

//if (_isAttacked > 1) exitwith {};

[_unitG] call RYD_WPdel;

_unitG setVariable [("Deployed" + (str _unitG)),false];_unitG setVariable [("Capt" + (str _unitG)),false];

_unitG setVariable [("Busy" + _unitvar), true];

_UL = leader _unitG;
_nothing = true;

_dX = (_PosObj1 select 0) - ((getPosATL (leader _HQ)) select 0);
_dY = (_PosObj1 select 1) - ((getPosATL (leader _HQ)) select 1);

_angle = _dX atan2 _dY;

_distance = (leader _HQ) distance _PosObj1;
_distance2 = 500;

_dXc = _distance2 * (cos _angle);
_dYc = _distance2 * (sin _angle);

if not (_request) then {
	if (_isAttacked == 1) then {(group _Trg) setVariable [("Attacked" + (str (group _Trg))),2,true];_dYc = - _dYc};
	if (_isAttacked < 1) then {(group _Trg) setVariable [("Attacked" + (str (group _Trg))),1,true];_dXc = - _dXc};
	if (_isAttacked > 1) then {_distance = _distance - _distance2;_dXc = 0;_dYc = 0};
};

_dXb = _distance * (sin _angle);
_dYb = _distance * (cos _angle);

_posX = ((getPosATL (leader _HQ)) select 0) + _dXb + _dXc + (random 200) - 100;
_posY = ((getPosATL (leader _HQ)) select 1) + _dYb + _dYc + (random 200) - 100;

if (_request) then {
	_posX = (_PosObj1 select 0) + (random 300) - 150;
	_posY = (_PosObj1 select 1) + (random 300) - 150;
};
	
[_unitG,[_posX,_posY,0],"HQ_ord_attackNaval",_HQ] call RYD_OrderPause;

if ((isPlayer (leader _unitG)) and (RydxHQ_GPauseActive)) then {hintC "New orders from HQ!";setAccTime 1};

_UL = leader _unitG;
 
if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdConf,"OrdConf"] call RYD_AIChatter}};

if (_HQ getVariable ["RydHQ_Debug",false]) then
	{
	_signum = _HQ getVariable ["RydHQ_CodeSign","X"];
	_i = [[_posX,_posY],_unitG,"markAttack","ColorRed","ICON","waypoint","NAVATT " + (groupId _unitG) + " " + _signum," - ATTACK",[0.5,0.5]] call RYD_Mark;
	};

_task = [(leader _unitG),["Engage the designated hostile ships. ROE: WEAPONS FREE.", "Engage Hostile Ship(s)", ""],[_posX,_posY],"attack"] call RYD_AddTask;

_tp = "MOVE";
if (_request) then {_tp = "SAD"};
_wp = [_unitG,[_posX,_posY],_tp,"AWARE","RED","NORMAL"] call RYD_WPadd;
if (isPlayer (leader _unitG)) then {deleteWaypoint _wp};

if (RydxHQ_SynchroAttack) then
	{
	if not (_request) then {[_wp,_Trg] call RYD_WPSync};
	 
	 
	};

if not (_request) then {_unitG setVariable ["RydHQ_WaitingTarget",_trg]};
_cause = [_unitG,6,true,0,24,[],false] call RYD_Wait;
_timer = _cause select 0;
_alive = _cause select 1;

if not (_alive) exitWith 
	{
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markAttack" + str (_unitG))};
	_unitG setVariable [("Busy" + (str _unitG)),false];
	if not (_request) then {[_Trg,"NavAttacked"] call RYD_VarReductor}
	};

if (_timer > 24) then {deleteWaypoint _wp};

if not (_task isEqualTo taskNull) then
	{
	
	[_task,(leader _unitG),["Engage the designated hostile ship(s). ROE: WEAPONS FREE.", "Engage Hostile Ship(s)"],(getPosATL _Trg),"ASSIGNED",0,false,true] call BIS_fnc_SetTask;
		
	};

_cur = true;
if (RydxHQ_SynchroAttack) then {_cur = false};
_frm = formation _unitG;
if not (isPlayer (leader _unitG)) then {_frm = "WEDGE"};

_UL = leader _unitG;if not (isPlayer _UL) then {if (_timer <= 24) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdFinal,"OrdFinal"] call RYD_AIChatter}}};

_tPos = getPosATL _Trg;
_tPosX = _tPos select 0;
_tPosY = _tPos select 1;

_tPosX = (_tPosX + _posX)/2;
_tPosY = (_tPosY + _posY)/2;

if not (_request) then {
	if not (isPlayer (leader _unitG)) then {
		_wp = [_unitG,[_tPosX,_tPosY],"SAD","AWARE","RED","NORMAL",["true","deletewaypoint [(group this), 0];"],_cur,0,[0,0,0],_frm] call RYD_WPadd;

		} else {

		_wp = [_unitG,_Trg,"SAD","AWARE","RED","NORMAL",["true","deletewaypoint [(group this), 0];"],_cur,0,[0,0,0],_frm] call RYD_WPadd;
		_wp waypointAttachVehicle _Trg;
		
		};
};

if not (_request) then {_unitG setVariable ["RydHQ_WaitingTarget",_trg]};
_cause = [_unitG,6,true,0,24,[],false] call RYD_Wait;
_timer = _cause select 0;
_alive = _cause select 1;

if not (_alive) exitWith 
	{
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markAttack" + str (_unitG))};
	_unitG setVariable [("Busy" + (str _unitG)),false];
	if not (_request) then {[_Trg,"NavAttacked"] call RYD_VarReductor}
	};

if (_timer > 24) then {deleteWaypoint _wp};

if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {_i setMarkerColor "ColorBlue"};

	if not (_task isEqualTo taskNull) then
		{
		
//		[_task,(leader _unitG),["Hold position and standby for further orders.", "Standby", ""],_Spos,"ASSIGNED",0,false,true] call BIS_fnc_SetTask;
			 
		};

if ((_unitG in (_HQ getVariable ["RydHQ_Garrison",[]])) and not (isPlayer (leader _unitG))) then
	{
	if not (_task isEqualTo taskNull) then
		{
		
		[_task,(leader _unitG),["Hold position and standby for further orders.", "Standby", ""],_Spos,"ASSIGNED",0,false,true] call BIS_fnc_SetTask; 
			
		};
	_wp = [_unitG,_Spos,"MOVE","SAFE","YELLOW","NORMAL",["true","deletewaypoint [(group this), 0];"],true,5] call RYD_WPadd;

	_cause = [_unitG,6,true,0,30,[],false] call RYD_Wait;
	_timer = _cause select 0;
	_alive = _cause select 1;

	if not (_alive) exitWith {_unitG setVariable [("Busy" + (str _unitG)),false];if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markAttack" + str (_unitG))}};
	if (_timer > 30) then {[_unitG, (currentWaypoint _unitG)] setWaypointPosition [getPosATL (vehicle _UL), 0]};
	_unitG setVariable ["Garrisoned" + (str _unitG),false];
	};

sleep 20;

if (not (_task isEqualTo taskNull) and not (alive _Trg)) then {[_task,"SUCCEEDED",true] call BIS_fnc_taskSetState};

if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker _i};

_attAv = _HQ getVariable ["RydHQ_AttackAv",[]];
_attAv pushBack _unitG;
_HQ setVariable ["RydHQ_AttackAv",_attAv];

_unitG setVariable [("Busy" + (str _unitG)),false];

if not (_request) then {[_Trg,"NavAttacked"] call RYD_VarReductor};

_UL = leader _unitG;if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdEnd,"OrdEnd"] call RYD_AIChatter}};