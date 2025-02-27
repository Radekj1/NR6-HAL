_SCRname = "GoAttSniper";

_i = "";

_unitG = _this select 0;
_HQ = _this select 2;

_Spos = _unitG getVariable ("START" + (str _unitG));
if (isNil ("_Spos")) then {_unitG setVariable [("START" + (str _unitG)),(getPosATL (vehicle (leader _unitG)))];_Spos = _unitG getVariable ("START" + (str _unitG))}; 

_Trg = _this select 1;

_isAttacked = (group _Trg) getVariable ("SnpAttacked" + (str (group _Trg)));
if (isNil ("_isAttacked")) then {_isAttacked = 0};

_PosObj1 = getPosATL _Trg;
_unitvar = str (_unitG);

_request = false;

//if (_isAttacked > 2) exitwith {};

[_unitG] call RYD_WPdel;

_unitG setVariable [("Deployed" + (str _unitG)),false];_unitG setVariable [("Capt" + (str _unitG)),false];
if (_isAttacked < 1) then {(group _Trg) setVariable [("SnpAttacked" + (str (group _Trg))),1,true]};

_UL = leader _unitG;
_nothing = true;

_dX = (_PosObj1 select 0) - ((getPosATL (leader _HQ)) select 0);
_dY = (_PosObj1 select 1) - ((getPosATL (leader _HQ)) select 1);

_angle = _dX atan2 _dY;

_distance = (leader _HQ) distance _PosObj1;
_distance2 = 500;

_Armor = (_HQ getVariable ["RydHQ_LArmorG",[]]) + (_HQ getVariable ["RydHQ_HArmorG",[]]);

if (_unitG in _Armor) then {_distance2 = 700};
if (_unitG in (_HQ getVariable ["RydHQ_AirG",[]])) then {_distance2 = 800};

_isAttacked = (group _Trg) getVariable ("SnpAttacked" + (str (group _Trg)));

if (_isAttacked == 1) then {(group _Trg) setVariable [("SnpAttacked" + (str (group _Trg))),2]};
if (_isAttacked < 1) then {(group _Trg) setVariable [("SnpAttacked" + (str (group _Trg))),1]};

_dstMpl = (_HQ getVariable ["RydHQ_AttSnpDistance",1]) * (_unitG getVariable ["RydHQ_myAttDst",1]);
_distance2 = _distance2 * _dstMpl;

_distance = _distance - _distance2;
_dXb = _distance * (sin _angle);
_dYb = _distance * (cos _angle);

_posX = ((getPosATL (leader _HQ)) select 0) + _dXb + (random 200) - 100;
_posY = ((getPosATL (leader _HQ)) select 1) + _dYb + (random 200) - 100;

_isWater = surfaceIsWater [_posX,_posY];

_tposX = (getPosATL _Trg) select 0;
_tposY = (getPosATL _Trg) select 1;

while {((_isWater) and (([_posX,_posY] distance _PosObj1) >= 50))} do
	{
	_posX = (_posX + _tposX)/2;
	_posY = (_posY + _tposY)/2;
	_isWater = surfaceIsWater [_posX,_posY];
	};

_isWater = surfaceIsWater [_posX,_posY];

if (_isWater) exitWith 
	{
	_attAv = _HQ getVariable ["RydHQ_AttackAv",[]];
	_attAv pushBack _unitG;
	_HQ setVariable ["RydHQ_AttackAv",_attAv];
	_unitG setVariable [("Busy" + (str _unitG)),false];
	[_Trg,"SnpAttacked"] call RYD_VarReductor
	};

_positions = [[_posX,_posY,1],(getPosATL _Trg),200,1,1,_unitG] call RYD_FindOverwatchPos;

_cnt = count _positions;

if (_cnt > 0) then
	{
	_rnd = random 100;

	switch (true) do
		{
		case ((_rnd < 25) or (_cnt == 1)) : 
			{
			_posX = (_positions select 0) select 0;
			_posY = (_positions select 0) select 1
			};

		case (((_rnd >= 25) and (_rnd < 45)) or (_cnt == 2)) : 
			{
			_posX = (_positions select 1) select 0;
			_posY = (_positions select 1) select 1
			};

		case (((_rnd >= 45) and (_rnd < 60)) or (_cnt == 3)) : 
			{
			_posX = (_positions select 2) select 0;
			_posY = (_positions select 2) select 1
			};

		case (((_rnd >= 60) and (_rnd < 70)) or (_cnt == 4)) : 
			{
			_posX = (_positions select 3) select 0;
			_posY = (_positions select 3) select 1
			};

		default 
			{
			_posR = _positions select (floor (random (count _positions)));
			_posX = _posR select 0;
			_posY = _posR select 1
			};
		}
	};
	
[_unitG,[_posX,_posY,0],"HQ_ord_attackSnip",_HQ] call RYD_OrderPause;

if ((isPlayer (leader _unitG)) and (RydxHQ_GPauseActive)) then {hintC "New orders from HQ!";setAccTime 1};

_UL = leader _unitG;
 
if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdConf,"OrdConf"] call RYD_AIChatter}};

if (_HQ getVariable ["RydHQ_Debug",false]) then 
	{
	_signum = _HQ getVariable ["RydHQ_CodeSign","X"];
	_i = [[_posX,_posY],_unitG,"markAttack","ColorRed","ICON","waypoint","SNP " + (groupId _unitG) + " " + _signum," - ATTACK",[0.5,0.5]] call RYD_Mark
	};

_AV = assignedVehicle _UL;
_DAV = assignedDriver _AV;
_GDV = group _DAV;
_EnNearTrg = false;
_NeNMode = false;
_halfway = false;

_wp0 = [];
_wp = [];
_nW = 1;

_LX1 = _posX;
_LY1 = _posY;

_eClose1 = [[_posX,_posY],(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),400] call RYD_CloseEnemyB;

_tooC1 = _eClose1 select 0;
_dstEM1 = _eClose1 select 1;
_NeN = _eClose1 select 2;

if not (isNull _NeN) then
	{
	_eClose2 = [_UL,(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),400] call RYD_CloseEnemyB;
	_tooC2 = _eClose2 select 0;
	_dstEM2 = _eClose2 select 1;
	_eClose3 = [(leader _HQ),(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),400] call RYD_CloseEnemyB;
	_tooC3 = _eClose3 select 0;

	if ((_tooC1) or (_tooC2) or (_tooC3) or (((_UL distance [_posX,_posY]) - _dstEM2) > _dstEM1)) then {_EnNearTrg = true}
	};

if (_EnNearTrg) then {_NeNMode = true};
if (not (isNull _GDV) and (_GDV in ((_HQ getVariable ["RydHQ_NCCargoG",[]]) + (_HQ getVariable ["RydHQ_AirG",[]]))) and (_NeNMode)) then {_LX1 = (getPosATL _UL) select 0;_LY1 = (getPosATL _UL) select 1;_halfway = true};

if ((isNull _AV) and (([_posX,_posY] distance _UL) > RydxHQ_CargoObjRange) and not (isPlayer (leader _unitG))) then
	{
	_LX = (getPosATL _UL) select 0;
	_LY = (getPosATL _UL) select 1;

	_spd = "LIMITED";
	_TO = [0,0,0];
	if (_NeNMode) then {_spd = "NORMAL";_TO = [40, 45, 50]};

	_wp0 = [_unitG,[(_posX + _LX)/2,(_posY + _LY)/2],"MOVE","SAFE","YELLOW",_spd,["true","deletewaypoint [(group this), 0];"],true,0.001,_TO] call RYD_WPadd;

	_nW = 2;
	};

_task = [(leader _unitG),["Take out the designated hostile targets", "Neutralize Hostile Targets", ""],[_posX,_posY],"target"] call RYD_AddTask;

_gp = _unitG;
if not (isNull _AV) then {_gp = _GDV;_posX = (_posX + _LX1)/2;_posY = (_posY + _LY1)/2};
_pos = [_posX,_posY];
_tp = "MOVE";
//if (not (isNull _AV) and (_unitG in (_HQ getVariable ["RydHQ_NCrewInfG",[]]))) then {_tp = "UNLOAD"};
_beh = "STEALTH";
if (_halfway) then {_beh = "SAFE"};
if (not (isNull _AV) and (_GDV in (_HQ getVariable ["RydHQ_AirG",[]]))) then {_beh = "CARELESS"};
_spd = "NORMAL";
if ((isNull _AV) and (([_posX,_posY] distance _UL) > 1000) and not (_NeNMode)) then {_spd = "LIMITED"};
_TO = [0,0,0];
if ((isNull _AV) and (([_posX,_posY] distance _UL) <= 1000) or ((_NeNMode) and (isNull _AV))) then {_TO = [40, 45, 50]};
_crr = false;
if ((_nW == 1) and (isNull _AV)) then {_crr = true};
if not (isNull _AV) then {_crr = true};
_sts = ["true","deletewaypoint [(group this), 0];"];
if (((group (assignedDriver _AV)) in (_HQ getVariable ["RydHQ_AirG",[]])) and (_unitG in (_HQ getVariable ["RydHQ_NCrewInfG",[]]))) then {_sts = ["true","(vehicle this) land 'GET OUT';deletewaypoint [(group this), 0]"]};

_wp = [_gp,_pos,_tp,_beh,"YELLOW",_spd,_sts,_crr,0.001,_TO] call RYD_WPadd;

if ((RydxHQ_SynchroAttack) and not (isPlayer (leader _unitG))) then
	{
	_attackedBy = (group _trg) getVariable ["RYD_Attacks",[]];
	_attackedBy pushBack [_unitG,[_posX,_posY,0]];
	(group _trg) setVariable ["RYD_Attacks",_attackedBy];
	};

_DAV = assignedDriver _AV;

if not (_request) then {_unitG setVariable ["RydHQ_WaitingTarget",_trg]};
_cause = [_unitG,6,true,0,300,[],false] call RYD_Wait;
_timer = _cause select 0;
_alive = _cause select 1;

if (_timer > 300) then {[_unitG, (currentWaypoint _unitG)] setWaypointPosition [getPosATL (vehicle _UL), 0];[_unitG] call RYD_ResetAI};
if not (_alive) exitWith 
	{
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markAttack" + str (_unitG))};
	_unitG setVariable [("Busy" + (str _unitG)),false];
	[_Trg,"SnpAttacked"] call RYD_VarReductor
	};

_pass = assignedCargo _AV;
if (_unitG in (_HQ getVariable ["RydHQ_NCrewInfG",[]])) then {_pass orderGetIn false};
sleep 5;
_alive = true;
if (_halfway) then
	{
	_formation = formation _unitG;
	if not (isPlayer (leader _unitG)) then {_formation = "STAG COLUMN"};

	_wp = [_unitG,[_posX,_posY],"MOVE","STEALTH","YELLOW","NORMAL",["true","deletewaypoint [(group this), 0];"],true,0.001,[0,0,0],_formation] call RYD_WPadd;


	if not (_request) then {_unitG setVariable ["RydHQ_WaitingTarget",_trg]};
	_cause = [_unitG,6,true,0,300,[],false] call RYD_Wait;
	_timer = _cause select 0;
	_alive = _cause select 1;

	if not (_alive) exitWith {_unitG setVariable [("Busy" + (str _unitG)),false];if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markAttack" + str (_unitG))}};
	if (_timer > 300) then {[_unitG, (currentWaypoint _unitG)] setWaypointPosition [getPosATL (vehicle _UL), 0];[_unitG] call RYD_ResetAI};
	};

if not (_alive) exitWith {_unitG setVariable [("Busy" + (str _unitG)),false];[_Trg,"SnpAttacked"] call RYD_VarReductor};

if ((RydxHQ_SynchroAttack) and not (isPlayer (leader _unitG))) then
	{
	[_wp,_Trg,_unitG,_HQ] call RYD_WPSync;
	 
	 
	};

if not (_task isEqualTo taskNull) then
	{
		 
	[_task,(leader _unitG),["Take out the designated hostile targets", "Neutralize Hostile Targets", ""],(getPosATL _Trg),"ASSIGNED",0,false,true] call BIS_fnc_SetTask;
		
	};

_formation = formation _unitG;
if not (isPlayer (leader _unitG)) then {_formation = "WEDGE"};
_unitG enableAttack false; 
_cur = true;
//if (RydxHQ_SynchroAttack) then {_cur = false};

_UL = leader _unitG;if not (isPlayer _UL) then {if (_timer <= 300) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdFinal,"OrdFinal"] call RYD_AIChatter}}};

_wp = [_unitG,getPosATL (vehicle (leader _unitG)),"SENTRY","STEALTH","RED","NORMAL",["true",""],_cur,0.001,[0,0,0],_formation] call RYD_WPadd;

_fEH = (leader _unitG) addEventHandler ["Fired",{[_this,RYD_FireCount] call RYD_Spawn}];
(leader _unitG) setVariable ["HAC_FEH",_fEH];
[_unitG,_Trg] spawn {_unitG = _this select 0;_Trg = _this select 1; sleep (5 + (random 5));_unitG reveal [_Trg,3]};
if not (_request) then {_unitG setVariable ["RydHQ_WaitingTarget",_trg]};
_cause = [_unitG,5,true,0,240,[],false,true,true,false,false,false,true] call RYD_Wait;
_timer = _cause select 0;
_alive = _cause select 1;

_unitG enableAttack true; 
_fEH = (leader _unitG) getVariable "HAC_FEH";
(leader _unitG) setVariable ["FireCount",nil];

if not (isNil "_fEH") then
	{
	(leader _unitG) removeEventHandler ["Fired",_fEH];
	(leader _unitG) setVariable ["HAC_FEH",nil]
	};

if not (_alive) exitWith 
	{
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markAttack" + str (_unitG))};
	_unitG setVariable [("Busy" + (str _unitG)),false];
	[_Trg,"SnpAttacked"] call RYD_VarReductor
	};

if (_timer > 240) then {[_unitG] call RYD_WPdel};

if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {_i setMarkerColor "ColorBlue"};

_sPosX = _Spos select 0;
_sPosY = _Spos select 1;

_wPosX = (_sPosX + _posX)/2;
_wPosY = (_sPosY + _posY)/2;

_formation = formation _unitG;
if not (isPlayer (leader _unitG)) then {_formation = "DIAMOND"};

_wp = [_unitG,[_wPosX,_wPosY],"MOVE","STEALTH","GREEN","NORMAL",["true","deletewaypoint [(group this), 0];"],true,0,[0,0,0],_formation] call RYD_WPadd;
if not (_request) then {_unitG setVariable ["RydHQ_WaitingTarget",_trg]};
_cause = [_unitG,6,true,0,300,[],false] call RYD_Wait;
_timer = _cause select 0;
_alive = _cause select 1;

if not (_alive) exitWith {_unitG setVariable [("Busy" + (str _unitG)),false];[_Trg,"SnpAttacked"] call RYD_VarReductor;if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markAttack" + str (_unitG))}};
if (_timer > 300) then {[_unitG, (currentWaypoint _unitG)] setWaypointPosition [getPosATL (vehicle _UL), 0]};

if not (_task isEqualTo taskNull) then
	{
	
	[_task,(leader _unitG),["Withdraw.", "Withdraw", ""],_Spos,"ASSIGNED",0,false,true] call BIS_fnc_SetTask;
		 
		
	};

_wp = [_unitG,_Spos,"MOVE","SAFE","YELLOW","NORMAL",["true","deletewaypoint [(group this), 0];"],true,5] call RYD_WPadd;
if not (_request) then {_unitG setVariable ["RydHQ_WaitingTarget",_trg]};
_cause = [_unitG,6,true,0,30,[],false] call RYD_Wait;
_timer = _cause select 0;
_alive = _cause select 1;

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

if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markAttack" + str (_unitG))};

_pass orderGetIn true;

_attAv = _HQ getVariable ["RydHQ_AttackAv",[]];
_attAv pushBack _unitG;
_HQ setVariable ["RydHQ_AttackAv",_attAv];

_unitG setVariable [("Busy" + (str _unitG)),false];

[_Trg,"SnpAttacked"] call RYD_VarReductor;

_UL = leader _unitG;if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdEnd,"OrdEnd"] call RYD_AIChatter}};