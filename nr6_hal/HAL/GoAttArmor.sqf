_SCRname = "GoAttArmor";
Diag_log text "HAL GoAttArmor started";
_i = "";

_unitG = _this select 0;_Spos = _unitG getvariable ("START" + (str _unitG));if (isNil ("_Spos")) then {_unitG setVariable [("START" + (str _unitG)),(getPosATL (vehicle (leader _unitG)))];_Spos = _unitG getVariable ("START" + (str _unitG))}; 
_Trg = _this select 1;
_HQ = _this select 2;
_request = false;
if ((count _this) > 3) then {_request = _this select 3};


_isAttacked = (group _Trg) getvariable ("ArmorAttacked" + (str (group _Trg)));
if (isNil ("_isAttacked")) then {_isAttacked = 0};


_PosObj1 = getPosATL _Trg;
_unitvar = str (_unitG);
_busy = false;

_IsAPlayer = false;
if (RydxHQ_NoCargoPlayers and (isPlayer (leader _unitG))) then {_IsAPlayer = true};

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

_dstMpl = (_HQ getVariable ["RydHQ_AttArmDistance",1]) * (_unitG getVariable ["RydHQ_myAttDst",1]);
_distance2 = _distance2 * _dstMpl;

_dXc = _distance2 * (cos _angle);
_dYc = _distance2 * (sin _angle);

if not (_request) then {
	if (_isAttacked == 1) then {(group _Trg) setvariable [("ArmorAttacked" + (str (group _Trg))),2,true];_dYc = - _dYc};
	if (_isAttacked < 1) then {(group _Trg) setvariable [("ArmorAttacked" + (str (group _Trg))),1,true];_dXc = - _dXc};
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

_isWater = surfaceIsWater [_posX,_posY];

while {((_isWater) and (([_posX,_posY] distance _PosObj1) >= 50))} do
	{
	_posX = _posX - _dXc/20;
	_posY = _posY - _dYc/20;
	_isWater = surfaceIsWater [_posX,_posY];
	};

_isWater = surfaceIsWater [_posX,_posY];

if (_isWater) exitwith 
	{
	_attAv = _HQ getVariable ["RydHQ_AttackAv",[]];
	_attAv pushBack _unitG;
	_HQ setVariable ["RydHQ_AttackAv",_attAv];
	_unitG setVariable [("Busy" + (str _unitG)),false];
	if not (_request) then {[_Trg,"ArmorAttacked"] call RYD_VarReductor};
	};

if ((RydxHQ_SynchroAttack) and not (isPlayer (leader _unitG)) and not (_request)) then
	{
	_attackedBy = (group _trg) getVariable ["RYD_Attacks",[]];
	_attackedBy pushBack [_unitG,[_posX,_posY,0]];
	(group _trg) setVariable ["RYD_Attacks",_attackedBy];
	};
	
[_unitG,[_posX,_posY,0],"HQ_ord_attackArmor",_HQ] call RYD_OrderPause;

if ((isPlayer (leader _unitG)) and (RydxHQ_GPauseActive)) then {hintC "New orders from HQ!";setAccTime 1};

_UL = leader _unitG;

_AV = assignedVehicle _UL;

Diag_log text "GoAttArmor line 100";
if not (isNull _AV) then { 

	{
		if (isNull (assignedVehicle _x)) then {_x assignAsCargo _AV};
	} forEach (units _unitG);
};
 Diag_log text "GoAttArmor call RYD_AIChatter";
if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdConf,"OrdConf"] call RYD_AIChatter}};
 Diag_log text "GoAttArmor called RYD_AIChatter";

if (_HQ getVariable ["RydHQ_Debug",false]) then
	{
	_signum = _HQ getVariable ["RydHQ_CodeSign","X"];
	 Diag_log text "GoAttArmor call RYD_MARK";
	_i = [[_posX,_posY],_unitG,"markAttack","ColorRed","ICON","waypoint","ARM " + (groupId _unitG) + " " + _signum," - ATTACK",[0.5,0.5]] call RYD_Mark;
	 Diag_log text "GoAttArmor called RYD_MARK";
	};
 Diag_log text "GoAttArmor call RYD_AddTask";
_task = [(leader _unitG),["Engage the designated hostile forces. ROE: WEAPONS FREE.", "Engage Hostile Forces", ""],[_posX,_posY],"attack"] call RYD_AddTask;
 Diag_log text "GoAttArmor called RYD_AddTask";

_tp = "MOVE";
if (_request) then {_tp = "SAD"};

 Diag_log text "GoAttArmor call RYD_WPadd";
_wp = [_unitG,[_posX,_posY],_tp,"AWARE","RED","NORMAL"] call RYD_WPadd;
 Diag_log text "GoAttArmor called RYD_WPadd";

if (isPlayer (leader _unitG)) then {deleteWaypoint _wp};


if not (_request) then {_unitG setVariable ["RydHQ_WaitingTarget",_trg]};
if not (_isAPlayer) then {_unitG setVariable ["InfGetinCheck" + (str _unitG),true]};
private _WaitCarrier = objNull;
_WaitCarrier setVariable ["_continueAW",false];
 Diag_log text "GoAttArmor call RYD_WPadd";
[_WaitCarrier,_unitG,6,true,0,24,[],false] call RYD_Wait; 
 Diag_log text "GoAttArmor called RYD_WPadd";
waitUntil {_WaitCarrier getVariable ["_continueAW",false];}; 
 Diag_log text "GoAttArmor waituntil ended";
_WaitCarrier setVariable ["_continueAW",false];
_timer = _WaitCarrier getVariable "_timer";
_alive = _WaitCarrier getVariable "_alive";

Diag_log text "GoAttArmor line 134";
if not (_alive) exitwith 
	{
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markAttack" + str (_unitG))};
	_unitG setVariable [("Busy" + (str _unitG)),false];
	if not (_request) then {[_Trg,"ArmorAttacked"] call RYD_VarReductor}
	};

if (_timer > 24) then {deleteWaypoint _wp};
Diag_log text "GoAttArmor line 143";
if ((RydxHQ_SynchroAttack) and not (isPlayer (leader _unitG)) and not (_request)) then
	{
	[_wp,_Trg,_unitG,_HQ] call RYD_WPSync;
	 
	 
	};
Diag_log text "GoAttArmor line 150";

if not (_task isEqualTo taskNull) then
	{
	
	[_task,(leader _unitG),["Engage the designated hostile forces. ROE: WEAPONS FREE.", "Engage Hostile Forces"],(getPosATL _Trg),"ASSIGNED",0,false,true] call BIS_fnc_SetTask;
		
	};

_cur = true;
//if (RydxHQ_SynchroAttack) then {_cur = false};
_frm = formation _unitG;
if not (isPlayer (leader _unitG)) then {_frm = "WEDGE"};

_UL = leader _unitG;if not (isPlayer _UL) then {if (_timer <= 24) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdFinal,"OrdFinal"] call RYD_AIChatter}}};

_tPos = getPosATL _Trg;
_tPosX = _tPos select 0;
_tPosY = _tPos select 1;

_tPosX = (_tPosX + _posX)/2;
_tPosY = (_tPosY + _posY)/2;
Diag_log text "GoAttArmor line 172";

if not (_request) then {
	if not (isPlayer (leader _unitG)) then {
		_wp = [_unitG,[_tPosX,_tPosY],"SAD","AWARE","RED","NORMAL",["true","deletewaypoint [(group this), 0];"],_cur,0,[0,0,0],_frm] call RYD_WPadd;

		} else {

		_wp = [_unitG,_Trg,"SAD","AWARE","RED","NORMAL",["true","deletewaypoint [(group this), 0];"],_cur,0,[0,0,0],_frm] call RYD_WPadd;
		_wp waypointAttachVehicle _Trg;
		
		};
};
Diag_log text "GoAttArmor line 185";

if not (_request) then {_unitG setVariable ["RydHQ_WaitingTarget",_trg]};
if not (_isAPlayer) then {_unitG setVariable ["InfGetinCheck" + (str _unitG),true]};
private _WaitCarrier = objNull;
_WaitCarrier setVariable ["_continueAW",false];
[_WaitCarrier,_unitG,6,true,0,24,[],false] call RYD_Wait; 
waitUntil {_WaitCarrier getVariable ["_continueAW",false];}; 
_WaitCarrier setVariable ["_continueAW",false];
_timer = _WaitCarrier getVariable "_timer";
_alive = _WaitCarrier getVariable "_alive";
Diag_log text "GoAttArmor line 196";

if not (_alive) exitwith 
	{
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markAttack" + str (_unitG))};
	_unitG setVariable [("Busy" + (str _unitG)),false];
	if not (_request) then {[_Trg,"ArmorAttacked"] call RYD_VarReductor}
	};
Diag_log text "HAL_GoAttArmor line 200";
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

	private _WaitCarrier = objNull;
	_WaitCarrier setVariable ["_continueAW",false];
	[_WaitCarrier,_unitG,6,true,0,30,[],false] call RYD_Wait; 
	waitUntil {_WaitCarrier getVariable ["_continueAW",false];}; 
	_WaitCarrier setVariable ["_continueAW",false];
	_timer = _WaitCarrier getVariable "_timer";
	_alive = _WaitCarrier getVariable "_alive";

Diag_log text "GoAttArmor line 234";

	if not (_alive) exitwith {_unitG setVariable [("Busy" + (str _unitG)),false];if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markAttack" + str (_unitG))}};
	if (_timer > 30) then {[_unitG, (currentWaypoint _unitG)] setWaypointPosition [getPosATL (vehicle _UL), 0]};
	_unitG setVariable ["Garrisoned" + (str _unitG),false];
	};
Diag_log text "GoAttArmor line 240 sleep 20....";
sleep 20;
Diag_log text "GoAttArmor line 242";

if (not (_task isEqualTo taskNull) and not (alive _Trg)) then {[_task,"SUCCEEDED",true] call BIS_fnc_taskSetState};

if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker _i};

_attAv = _HQ getVariable ["RydHQ_AttackAv",[]];
_attAv pushBack _unitG;
_HQ setVariable ["RydHQ_AttackAv",_attAv];

_unitG setVariable [("Busy" + (str _unitG)),false];
Diag_log text "GoAttArmor line 253";
if not (_request) then {[_Trg,"ArmorAttacked"] call RYD_VarReductor};

_UL = leader _unitG;if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdEnd,"OrdEnd"] call RYD_AIChatter}};
Diag_log text "HAL_GoAttArmor ended";