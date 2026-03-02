_SCRname = "GoAttInf";

_i = "";
params ["_unitG","_trg","_HQ"];

_Spos = _unitG getvariable ("START" + (str _unitG));
if (isNil ("_Spos")) then {_unitG setVariable [("START" + (str _unitG)),(getPosATL (vehicle (leader _unitG)))];_Spos = _unitG getVariable ("START" + (str _unitG))};
 
_request = false;
if ((count _this) > 3) then {_request = _this select 3};


_isAttacked = (group _trg) getvariable ("InfAttacked" + (str (group _trg)));
if (isNil ("_isAttacked")) then {_isAttacked = 0};

_PosObj1 = getPosATL _trg;
_unitvar = str (_unitG);

//if (_isAttacked > 2) exitwith {};

[_unitG] call RYD_WPdel;

_IsAPlayer = false;
if (RydxHQ_NoCargoPlayers and (isPlayer (leader _unitG))) then {_IsAPlayer = true};

_unitG setVariable [("Deployed" + (str _unitG)),false];_unitG setVariable [("Capt" + (str _unitG)),false];

_UL = leader _unitG;
_nothing = true;

_dX = (_PosObj1 select 0) - ((getPosATL (leader _HQ)) select 0);
_dY = (_PosObj1 select 1) - ((getPosATL (leader _HQ)) select 1);

_angle = _dX atan2 _dY;

_distance = (leader _HQ) distance _PosObj1;
_distance2 = 350;

_Armor = (_HQ getVariable ["RydHQ_LArmorG",[]]) + (_HQ getVariable ["RydHQ_HArmorG",[]]);

if (_unitG in _Armor) then {_distance2 = 500};
if (_unitG in (_HQ getVariable ["RydHQ_AirG",[]])) then {_distance2 = 750};

_dstMpl = (_HQ getVariable ["RydHQ_AttInfDistance",1]) * (_unitG getVariable ["RydHQ_myAttDst",1]);
_distance2 = _distance2 * _dstMpl;

_dXc = _distance2 * (cos _angle);
_dYc = _distance2 * (sin _angle);

if not (_request) then {
	if (_isAttacked == 2) then {(group _trg) setvariable [("InfAttacked" + (str (group _trg))),3];_dYc = - _dYc};
	if (_isAttacked == 1) then {(group _trg) setvariable [("InfAttacked" + (str (group _trg))),2];_dXc = - _dXc};
	if (_isAttacked < 1) then {(group _trg) setvariable [("InfAttacked" + (str (group _trg))),1];_distance = _distance - _distance2;_dXc = 0;_dYc = 0};
	if (_isAttacked > 2) then {_distance = _distance - _distance2;_dXc = 0;_dYc = 0};
};

_dXb = _distance * (sin _angle);
_dYb = _distance * (cos _angle);

_posX = ((getPosATL (leader _HQ)) select 0) + _dXb + _dXc + (random 200) - 100;
_posY = ((getPosATL (leader _HQ)) select 1) + _dYb + _dYc + (random 200) - 100;

if (_request) then {
	_posX = (_PosObj1 select 0) + (random 200) - 100;
	_posY = (_PosObj1 select 1) + (random 200) - 100;
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
	if not (_request) then {[_trg,"InfAttacked"] call RYD_VarReductor};
	};
	
[_unitG,[_posX,_posY,0],"HQ_ord_attack",_HQ] call RYD_OrderPause;

if ((isPlayer (leader _unitG)) and (RydxHQ_GPauseActive)) then {hintC "New orders from HQ!";setAccTime 1};

_UL = leader _unitG;
 
if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdConf,"OrdConf"] call RYD_AIChatter}};

if (_HQ getVariable ["RydHQ_Debug",false]) then 
	{
	_signum = _HQ getVariable ["RydHQ_CodeSign","X"];
	_i = [[_posX,_posY],_unitG,"markAttack","ColorRed","ICON","waypoint", "INF " + (groupId _unitG) + " " + _signum," - ATTACK",[0.5,0.5]] call RYD_Mark
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
if (((_HQ getVariable ["RydHQ_CargoFind",0]) > 0) and not (_IsAPlayer) and (isNull _AV) and (([_posX,_posY] distance (vehicle _UL)) > 1000)) then 
	{
	[_unitG,_HQ,[_posX,_posY]] call HAL_SCargo;
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
			case (_unitG getVariable ["Break",false]) : {_alive = false; _unitG setVariable ["Break",false];}
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
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markAttack" + str (_unitG))};
	_unitG setVariable [("Busy" + (str _unitG)),false];
	if not (_request) then {[_trg,"InfAttacked"] call RYD_VarReductor};
	};


_AV = assignedVehicle _UL;

_DAV = assigneddriver _AV;
_GDV = group _DAV;

_task = taskNull;
_timer = 0;

[_unitG] call RYD_WPdel;

if (not (isNull _AV) and ((_HQ getVariable ["RydHQ_CargoFind",0]) > 0) and not (_GDV == _unitG) and not (_IsAPlayer)) then
	{
	_task = [(leader _unitG),["Embark your lift to your target", "Get In Lift", ""],(getPosATL (leader _unitG)),"getin"] call RYD_AddTask-OLD;

	_wp = [_unitG,_AV,"GETIN"] call RYD_WPadd;
	_wp waypointAttachVehicle _AV;
	_wp setWaypointCompletionRadius 750;

	{if (not (isPlayer (leader _unitG)) and not (_GDV == _unitG))  then {_x assignAsCargo _AV; [[_x],true] remoteExecCall ["orderGetIn",0];}} foreach (units _unitG);

	private _WaitCarrier = createGroup sideLogic;

						_WaitCarrier setVariable ["_continueAW",false];
						[_WaitCarrier,_unitG,1,false,0,300,[],true,false,true,false,false,false] call RYD_Wait; 
						waitUntil {_WaitCarrier getVariable ["_continueAW",false];}; diag_log text "RYD_Wait code finished, waituntil passed";
						_WaitCarrier setVariable ["_continueAW",false];
						_timer = _WaitCarrier getVariable "_timer";
						deleteGroup _WaitCarrier;

	_AV land 'NONE';
	};

if (isNil "_timer") then {_timer = 0};

if ((({alive _x} count (units _unitG)) < 1) or (_timer > 300)) exitwith {
	if not (_request) then {[_trg,"InfAttacked"] call RYD_VarReductor};if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markAttack" + str (_unitG))};if not (isNull _GDV) then {[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 0];_GDV setVariable [("Busy" + _unitvar), false];};
	
	{if (not (isPlayer (leader _unitG)) and not (_GDV == _unitG)) then {[_x] remoteExecCall ["RYD_MP_unassignVehicle",0]; [[_x],false] remoteExecCall ["orderGetIn",0];}} foreach (units _unitG);
	if not (_task isEqualTo taskNull) then {[_task,"CANCELED",true] call BIS_fnc_taskSetState};
	_unitG setVariable [("Busy" + (str _unitG)),false];
	if not (isNull _GDV) then 
		{
		[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 0];
		_GDV setVariable [("CargoM" + (str _GDV)), false];
		//_pass orderGetIn true;
		}
	};

if not (_task isEqualTo taskNull) then {[_task,"SUCCEEDED",true] call BIS_fnc_taskSetState};
*/
_AV = assignedVehicle _UL;

_DAV = assigneddriver _AV;
_GDV = group _DAV;
_wp0 = [];_wp = [];
_nW = 1;

_LX1 = _posX;
_LY1 = _posY;
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
	_eClose2 = [_UL,(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),400] call RYD_CloseEnemyB;
	_tooC2 = _eClose2 select 0;
	_dstEM2 = _eClose2 select 1;
	_eClose3 = [(leader _HQ),(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),400] call RYD_CloseEnemyB;
	_tooC3 = _eClose3 select 0;

	if ((_tooC1) or (_tooC2) or (_tooC3) or (((_UL distance [_posX,_posY]) - _dstEM2) > _dstEM1)) then {_EnNearTrg = true}
	};

if (_EnNearTrg) then {_NeNMode = true};
if (not (isNull _GDV) and (_GDV in ((_HQ getVariable ["RydHQ_NCCargoG",[]]) + (_HQ getVariable ["RydHQ_AirG",[]]))) and (_NeNMode)) then {_LX1 = (getPosATL _UL) select 0;_LY1 = (getPosATL _UL) select 1;_halfway = true};

//if ((_GDV == _unitG) and not (isNull _AV) and not (_IsAPlayer)) then {_AV setUnloadInCombat [false, false]};
//Mech or motorized groups do not getout in combat until at obj or close contact with enemy (Added in wait Loop)

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

	waituntil
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
		_CargoCheck = _unitG getvariable ("CC" + _unitvar);
		if (isNil ("_CargoCheck")) then {_unitG setVariable [("CC" + _unitvar), true]};

		_AV = assignedVehicle _UL;

		if not (isNull _AV) then {

			{
				if (isNull (assignedVehicle _x)) then {_x assignAsCargo _AV};
			} forEach (units _unitG);

		};

		if (((_HQ getVariable ["RydHQ_CargoFind",0]) > 0) and not (_IsAPlayer) and (isNull _AV) and (([_posX,_posY] distance (vehicle _UL)) > 1000) and not (_unitG getVariable ["CargoCheckPending" + (str _unitG),false])) then 
			{
			[_unitG,_HQ,[_posX,_posY]] call HAL_SCargo;
			} 
		else 
			{
			if not (_unitG getVariable ["CargoCheckPending" + (str _unitG),false]) then {_unitG setVariable [("CC" + _unitvar), true]};
			};
			
		if (((_HQ getVariable ["RydHQ_CargoFind",0]) > 0) and not (_IsAPlayer) and not (_unitG getVariable ["CargoCheckPending" + (str _unitG),false])) then 
			{	
			waituntil 
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
					_cc = (_unitG getvariable ("CC" + _unitvar))
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
			if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markAttack" + str (_unitG))};
			if not (_request) then {[_trg,"InfAttacked"] call RYD_VarReductor};
			_unitG setVariable [("Busy" + (str _unitG)),false];
			(true)
			};

		_AV = assignedVehicle _UL;

		_DAV = assigneddriver _AV;
		_GDV = group _DAV;

		if (not (isNull _AV) and ((_HQ getVariable ["RydHQ_CargoFind",0]) > 0) and not (_GDV == _unitG) and not (_IsAPlayer)) then
			{
			_task = taskNull;
			_timer2 = 0;	

			_endThis = true;
			
			[_unitG] call RYD_WPdel;

			
			private _AddTask = createGroup sideLogic;
			_AddTask setVariable ["_continueAfterTask",false];

			[_AddTask,(leader _unitG),["Embark your lift.", "Get In Lift", ""],(getPosATL (leader _unitG)),"getin"] call RYD_AddTask;

			waitUntil {_AddTask getVariable ["_continueAfterTask",false];}; 
			diag_log text "RYD_AddTask code finished, waituntil passed";
			_AddTask setVariable ["_continueAfterTask",false];
			_task = _AddTask getVariable "_task";
			deleteGroup _AddTask;

			_wp = [_unitG,_AV,"GETIN"] call RYD_WPadd;
			_wp waypointAttachVehicle _AV;
			_wp setWaypointCompletionRadius 750;

			{if (not (isPlayer (leader _unitG)) and not (_GDV == _unitG))  then {_x assignAsCargo _AV; [[_x],true] remoteExecCall ["orderGetIn",0];}} foreach (units _unitG);

			if not (_request) then {_unitG setVariable ["RydHQ_WaitingTarget",_trg]};
			private _WaitCarrier = createGroup sideLogic;

			_WaitCarrier setVariable ["_continueAW",false];
			[_WaitCarrier,_unitG,1,false,0,300,[],true,false,true,false,false,false] call RYD_Wait; 
			waitUntil {_WaitCarrier getVariable ["_continueAW",false];}; diag_log text "RYD_Wait code finished, waituntil passed";
			_WaitCarrier setVariable ["_continueAW",false];
			_timer2 =_WaitCarrier getVariable "_timer";
			deleteGroup _WaitCarrier;

			_AV land 'NONE';

			if not (_task isEqualTo taskNull) then {[_task,"SUCCEEDED",true] call BIS_fnc_taskSetState};

			if (isNil "_timer2") then {_timer2 = 0};

			if ((({alive _x} count (units _unitG)) < 1) or (_timer2 > 300)) exitwith 
				{
				if not (_request) then {[_trg,"InfAttacked"] call RYD_VarReductor};
				if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markAttack" + str (_unitG))};
				
				if not (isNull _GDV) then {
					[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 0];
					_GDV setVariable [("CargoM" + (str _GDV)), false];
					};
				
				{if (not (isPlayer (leader _unitG)) and not (_GDV == _unitG)) then {[_x] remoteExecCall ["RYD_MP_unassignVehicle",0]; [[_x],false] remoteExecCall ["orderGetIn",0];}} foreach (units _unitG);
				if not (_task isEqualTo taskNull) then {[_task,"CANCELED",true] call BIS_fnc_taskSetState};
				_unitG setVariable [("Busy" + (str _unitG)),false];
				(true)
				};
			};

		//New Cargo!!!

		(_endThis)
		};
	};

if not (_unitG getVariable [("Busy" + (str _unitG)),false]) exitwith {};

_AV = assignedVehicle _UL;
_DAV = assigneddriver _AV;
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
	_eClose2 params ["_tooC2","_dstEM2"];

	_eClose3 = [(leader _HQ),(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),600] call RYD_CloseEnemyB;
	_tooC3 = _eClose3 select 0;

	if ((_tooC1) or (_tooC2) or (_tooC3) or (((_UL distance [_posX,_posY]) - _dstEM2) > _dstEM1)) then {_EnNearTrg = true}
	};

if (_EnNearTrg) then {_NeNMode = true};
if (not (isNull _GDV) and (_GDV in ((_HQ getVariable ["RydHQ_NCCargoG",[]]) + (_HQ getVariable ["RydHQ_AirG",[]]))) and (_NeNMode)) then {_LX1 = (getPosATL _UL) select 0;_LY1 = (getPosATL _UL) select 1;_halfway = true};

_dropposX = _posX;
_dropposY = _posY;

if ((_halfway) and not (_IsAPlayer)) then {

	_dropposX = (_posX + _LX1)/2;
	_dropposY = (_posY + _LY1)/2;
};

private _AddTask = createGroup sideLogic;
_AddTask setVariable ["_continueAfterTask",false];

[_AddTask,(leader _unitG),["Engage the designated hostile forces. ROE: WEAPONS FREE.", "Engage Hostile Forces", ""],[_posX,_posY],"attack"] call RYD_AddTask;
			
waitUntil {_AddTask getVariable ["_continueAfterTask",false];}; 
diag_log text "RYD_AddTask code finished, waituntil passed";
_AddTask setVariable ["_continueAfterTask",false];
_task = _AddTask getVariable "_task";
deleteGroup _AddTask;

_Ctask = taskNull;

if (not ((leader _GDV) == (leader _unitG)) and not (_GDV == _unitG)) then
	{
	private _AddTask = createGroup sideLogic;
	_AddTask setVariable ["_continueAfterTask",false];

	[_AddTask,(leader _GDV),["Disembark " + (groupId _unitG) + " at  their designated destination.", "Drop Off " + (groupId _unitG), ""],[_dropposX,_dropposY],"getout"] call RYD_AddTask;
	
	waitUntil {_AddTask getVariable ["_continueAfterTask",false];}; 
	diag_log text "RYD_AddTask code finished, waituntil passed";
	_AddTask setVariable ["_continueAfterTask",false];
	_Ctask = _AddTask getVariable "_task";
	deleteGroup _AddTask;
	};

_gp = _unitG;
if (not (isNull _AV) and not (_GDV == _unitG) and not (_isAPlayer)) then {_gp = _GDV;_posX = _dropposX;_posY = _dropposY};
_pos = [_posX,_posY];
_tp = "MOVE";
//if (not (isNull _AV) and (_unitG in (_HQ getVariable ["RydHQ_NCrewInfG",[]])) and not ((_GDV == _unitG) or (_GDV in (_HQ getVariable ["RydHQ_AirG",[]])))) then {_tp = "UNLOAD"};
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
			_pos params ["_posX","_posY"];
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
if (((group (assigneddriver _AV)) in (_HQ getVariable ["RydHQ_AirG",[]])) and (_unitG in (_HQ getVariable ["RydHQ_NCrewInfG",[]]))) then {_sts = ["true","(vehicle this) land 'GET OUT';deletewaypoint [(group this), 0]"]};

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
if (_request) then {_tp = "SAD"};
_wp = [_gp,_pos,_tp,_beh,"YELLOW",_spd,_sts,_crr,0,_TO] call RYD_WPadd;
if ((isPlayer (leader _gp)) and ((_GDV == _unitG) or (isNull _GDV))) then {deleteWaypoint _wp};

_posX = _SpX;
_posY = _SpY;
_pos = [_posX,_posY];

if ((RydxHQ_SynchroAttack) and not (isPlayer (leader _unitG)) and not (_request)) then
	{
	_attackedBy = (group _trg) getVariable ["RYD_Attacks",[]];
	_attackedBy pushBack [_unitG,[_posX,_posY,0]];
	(group _trg) setVariable ["RYD_Attacks",_attackedBy];
	};

_DAV = assigneddriver _AV;
_OtherGroup = false;
_GDV = group _DAV;
_alive = true;
_enemy = false;
_timer = 0;

if not (_IsAPlayer) then {
	if not (((group _DAV) == (group _UL)) or (isNull (group _DAV))) then 
		{
		_OtherGroup = true;

		private _WaitCarrier = createGroup sideLogic;

		_WaitCarrier setVariable ["_continueAW",false];
		[_WaitCarrier,_GDV,6,true,300,30,[(_HQ getVariable ["RydHQ_AirG",[]]),(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),_HQ],false] call RYD_Wait; 
		waitUntil {_WaitCarrier getVariable ["_continueAW",false];}; diag_log text "RYD_Wait code finished, waituntil passed";
		_WaitCarrier setVariable ["_continueAW",false];
		_timer = _WaitCarrier getVariable "_timer";
		_alive = _WaitCarrier getVariable "_alive";
		_enemy = _WaitCarrier getVariable "_enemy";
		deleteGroup _WaitCarrier;

		}
	else 
		{
		if not (_isAPlayer) then {_unitG setVariable ["InfGetinCheck" + (str _unitG),true]};
		if not (_request) then {_unitG setVariable ["RydHQ_WaitingTarget",_trg]};
		private _WaitCarrier = createGroup sideLogic;

		_WaitCarrier setVariable ["_continueAW",false];
		[_WaitCarrier,_unitG,6,true,300,30,[(_HQ getVariable ["RydHQ_AirG",[]]),(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),_HQ],false] call RYD_Wait; 
		waitUntil {_WaitCarrier getVariable ["_continueAW",false];}; diag_log text "RYD_Wait code finished, waituntil passed";
		_WaitCarrier setVariable ["_continueAW",false];
		_timer = _WaitCarrier getVariable "_timer";
		_alive = _WaitCarrier getVariable "_alive";
		_enemy = _WaitCarrier getVariable "_enemy";
		deleteGroup _WaitCarrier;

		if not (_isAPlayer) then {_unitG setVariable ["InfGetinCheck" + (str _unitG),false]};
		};
};

_DAV = assigneddriver _AV;
if (((_timer > 30) or (_enemy)) and (_OtherGroup)) then {if not (isNull _GDV) then {[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 0]}};
if (((_timer > 30) or (_enemy)) and not (_OtherGroup)) then {[_unitG, (currentWaypoint _unitG)] setWaypointPosition [getPosATL (vehicle _UL), 0]};
if (not (_alive) and not (_OtherGroup)) exitwith 
	{
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markAttack" + str (_unitG))};
	if not (_request) then {[_trg,"InfAttacked"] call RYD_VarReductor};
	_unitG setVariable [("Busy" + (str _unitG)),false];
	if not (isNull _GDV) then 
		{
		[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 0];
		_GDV setVariable [("CargoM" + (str _GDV)), false];
		//_pass orderGetIn true;
		};
	};

if (({alive _x} count (units _unitG)) < 1) exitwith 
	{
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markAttack" + str (_unitG))};
	if not (isNull _GDV) then {[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 0];};
	_unitG setVariable [("Busy" + (str _unitG)),false];
	if not (isNull _GDV) then 
		{
		[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 0];
		_GDV setVariable [("CargoM" + (str _GDV)), false];
		//_pass orderGetIn true;
		};
	if not (_request) then {[_trg,"InfAttacked"] call RYD_VarReductor}
	};

_UL = leader _unitG;if not (isPlayer _UL) then {if (not (_halfway) and (_timer <= 30) and not (_enemy)) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdFinal,"OrdFinal"] call RYD_AIChatter}}};

_AV = assignedVehicle _UL;

_pass = assignedCargo _AV;
_allowed = true;
if not ((_GDV == _unitG) or (isNull _GDV)) then 
	{
	{[[_x],false] remoteExecCall ["orderGetIn",0];} foreach _pass;
	_allowed = false;
	(units _unitG) allowGetIn false;
	[_unitG] call RYD_WPdel;

	}
else
	{
	//if (_unitG in (_HQ getVariable ["RydHQ_NCrewInfG",[]])) then {_pass orderGetIn false};
	};

_DAV = assigneddriver _AV;
_GDV = group _DAV;

if (not (isNull _AV) and ((_HQ getVariable ["RydHQ_CargoFind",0]) > 0) and (_unitG in (_HQ getVariable ["RydHQ_NCrewInfG",[]])) and not (_GDV == _unitG) and not (_IsAPlayer)) then
	{
	_pass = (units _unitG);
	if not (_request) then {_unitG setVariable ["RydHQ_WaitingTarget",_trg]};
	private _WaitCarrier = createGroup sideLogic;

	_WaitCarrier setVariable ["_continueAW",false];
	[_WaitCarrier,_unitG,1,false,0,240,[],true,true,false,false,false,false,false,_pass,_AV] call RYD_Wait; 
	waitUntil {_WaitCarrier getVariable ["_continueAW",false];}; diag_log text "RYD_Wait code finished, waituntil passed";
	_WaitCarrier setVariable ["_continueAW",false];
	_timer = _WaitCarrier getVariable "_timer";
	deleteGroup _WaitCarrier;
	};

if (not ((_GDV == _unitG) or (isNull _GDV)) and not (_IsAPlayer)) then 
	{
	{[_x] remoteExecCall ["RYD_MP_unassignVehicle",0]; [[_x],false] remoteExecCall ["orderGetIn",0];} foreach (units _unitG);
	};

if not (_allowed) then {(units _unitG) allowGetIn true};

if (_HQ getVariable ["RydHQ_LZ",false]) then {deleteVehicle _lz};

_unitvar = str _GDV;

if ((({alive _x} count (units _unitG)) < 1) or (_timer > 240)) exitwith 
	{
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markAttack" + str (_unitG))};
	if not (isNull _GDV) then {[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 0];};//;_pass orderGetIn true};
	if not (_request) then {[_trg,"InfAttacked"] call RYD_VarReductor};
	_unitG setVariable [("Busy" + (str _unitG)),false];
	if not (isNull _GDV) then 
		{
		[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 0];
		_GDV setVariable [("CargoM" + (str _GDV)), false];
		};
	if not (_Ctask isEqualTo taskNull) then {[_Ctask,"CANCELED",true] call BIS_fnc_taskSetState};
	};

if not (_Ctask isEqualTo taskNull) then {[_Ctask,"SUCCEEDED",true] call BIS_fnc_taskSetState};

if (not (isNull _GDV) and (_GDV in (_HQ getVariable ["RydHQ_AirG",[]])) and not (isPlayer (leader _GDV) and not (_IsAPlayer))) then
	{
	_wp = [_GDV,[((getPosATL _AV) select 0) + (random 200) - 100,((getPosATL _AV) select 1) + (random 200) - 100,1000],"MOVE","STEALTH","YELLOW","NORMAL"] call RYD_WPadd;

	private _WaitCarrier = createGroup sideLogic;

	_WaitCarrier setVariable ["_continueAW",false];
	[_WaitCarrier,_GDV,3,true,0,8,[],false] call RYD_Wait; 
	waitUntil {_WaitCarrier getVariable ["_continueAW",false];}; diag_log text "RYD_Wait code finished, waituntil passed";
	_WaitCarrier setVariable ["_continueAW",false];
	_timer = _WaitCarrier getVariable "_timer";
	deleteGroup _WaitCarrier;

	if (_timer > 8) then {[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 0]};
	};

if not (_IsAPlayer) then {_GDV setVariable [("CargoM" + _unitvar), false]};

_UL = leader _unitG;
_AV = assignedVehicle _UL;
_DAV = assigneddriver _AV;
_GDV = group _DAV;



_alive = true;
if (((_halfway) or (_earlyD)) and not (_IsAPlayer)) then
	{
	_frm = formation _unitG;
	if not (isPlayer (leader _unitG)) then {_frm = "STAG COLUMN"};

	_wp = [_unitG,[_posX,_posY],"MOVE","AWARE","YELLOW","NORMAL",["true","deletewaypoint [(group this), 0];"],true,0,[0,0,0],_frm] call RYD_WPadd;
	if (isPlayer (leader _unitG)) then {deleteWaypoint _wp};

	if ((RydxHQ_SynchroAttack) and not (isPlayer (leader _unitG)) and not (_request)) then
		{
		[_wp,_trg,_unitG,_HQ] call RYD_WPSync;
		
		
		};

	if not (_request) then {_unitG setVariable ["RydHQ_WaitingTarget",_trg]};
	if not (_isAPlayer) then {_unitG setVariable ["InfGetinCheck" + (str _unitG),true]};
	private _WaitCarrier = createGroup sideLogic;

	_WaitCarrier setVariable ["_continueAW",false];
	[_WaitCarrier,_unitG,6,true,0,30,[],false] call RYD_Wait; 
	waitUntil {_WaitCarrier getVariable ["_continueAW",false];}; diag_log text "RYD_Wait code finished, waituntil passed";
	_WaitCarrier setVariable ["_continueAW",false];
	_timer = _WaitCarrier getVariable "_timer";
	_alive = _WaitCarrier getVariable "_alive";
	deleteGroup _WaitCarrier;

	if not (_alive) exitwith 
		{
		if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markAttack" + str (_unitG))};
		_unitG setVariable [("Busy" + (str _unitG)),false];
		};

	if (_timer > 30) then {[_unitG, (currentWaypoint _unitG)] setWaypointPosition [getPosATL (vehicle _UL), 0]};
	};

if not (_alive) exitwith {_unitG setVariable [("Busy" + (str _unitG)),false];if not (_request) then {[_trg,"InfAttacked"] call RYD_VarReductor}};

if not (_task isEqualTo taskNull) then
	{
	
	[_task,(leader _unitG),["Engage the designated hostile forces. ROE: WEAPONS FREE.", "Engage Hostile Forces", ""],(getPosATL _trg),"ASSIGNED",0,false,true] call BIS_fnc_SetTask;

	};

_beh = "AWARE";
_spd = "NORMAL";
//if (not (_enemy) and not (_halfway) and (((vehicle (leader _unitG)) distance _trg) > 1000) and not (_NeNMode)) then {_spd = "LIMITED";_beh = "SAFE"};
_frm = formation _unitG;
if not (isPlayer (leader _unitG)) then {_frm = "WEDGE"};
_cur = true;
//if (RydxHQ_SynchroAttack) then {_cur = false};

_UL = leader _unitG;if not (isPlayer _UL) then {if ((_halfway) and (_timer <= 30)) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdFinal,"OrdFinal"] call RYD_AIChatter}}};

if not (_request) then {
	if not (isPlayer (leader _unitG)) then {
		_wp = [_unitG,_trg,"SAD",_beh,"YELLOW",_spd,["true","deletewaypoint [(group this), 0];"],_cur,0,[0,0,0],_frm] call RYD_WPadd;

		} else {

		_wp = [_unitG,_trg,"SAD",_beh,"YELLOW",_spd,["true","deletewaypoint [(group this), 0];"],_cur,0,[0,0,0],_frm] call RYD_WPadd;
		_wp waypointAttachVehicle _trg;
		};
};

if not (_request) then {_unitG setVariable ["RydHQ_WaitingTarget",_trg]};
if not (_isAPlayer) then {_unitG setVariable ["InfGetinCheck" + (str _unitG),true]};
private _WaitCarrier = createGroup sideLogic;

_WaitCarrier setVariable ["_continueAW",false];
[_WaitCarrier,_unitG,6,true,0,30,[(_HQ getVariable ["RydHQ_AirG",[]]),(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),_HQ],false] call RYD_Wait; 
waitUntil {_WaitCarrier getVariable ["_continueAW",false];}; diag_log text "RYD_Wait code finished, waituntil passed";
_WaitCarrier setVariable ["_continueAW",false];
_timer = _WaitCarrier getVariable "_timer";
_alive = _WaitCarrier getVariable "_alive";
deleteGroup _WaitCarrier;
//if ((_GDV == _unitG) and not (isNull _AV) and not (_IsAPlayer)) then {_AV setUnloadInCombat [true, false]};
//Mech or motorized groups getout in combat now (added in wait loop)

if not (_alive) exitwith 
	{
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markAttack" + str (_unitG))};
	_unitG setVariable [("Busy" + (str _unitG)),false];
	if not (_request) then {[_trg,"InfAttacked"] call RYD_VarReductor}
	};

if (_timer > 30) then {[_unitG, (currentWaypoint _unitG)] setWaypointPosition [getPosATL (vehicle _UL), 0]};

if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {_i setMarkerColor "ColorBlue"};

if ((_unitG in (_HQ getVariable ["RydHQ_Garrison",[]])) and not (isPlayer (leader _unitG))) then
	{
	if not (_task isEqualTo taskNull) then
		{
		
		[_task,(leader _unitG),["Hold position and standby for further orders.", "Standby", ""],_Spos,"ASSIGNED",0,false,true] call BIS_fnc_SetTask;
			 
		};
	
	_wp = [_unitG,_Spos,"MOVE","AWARE","YELLOW","NORMAL",["true","deletewaypoint [(group this), 0];"],true,5] call RYD_WPadd;

	private _WaitCarrier = createGroup sideLogic;

	_WaitCarrier setVariable ["_continueAW",false];
	[_WaitCarrier,_unitG,6,true,0,30,[],false] call RYD_Wait; 
	waitUntil {_WaitCarrier getVariable ["_continueAW",false];}; diag_log text "RYD_Wait code finished, waituntil passed";
	_WaitCarrier setVariable ["_continueAW",false];
	_timer = _WaitCarrier getVariable "_timer";
	_alive = _WaitCarrier getVariable "_alive";
	deleteGroup _WaitCarrier;

	if not (_alive) exitwith {_unitG setVariable [("Busy" + (str _unitG)),false];if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markAttack" + str (_unitG))}};
	if (_timer > 30) then {[_unitG, (currentWaypoint _unitG)] setWaypointPosition [getPosATL (vehicle _UL), 0]};
	_unitG setVariable ["Garrisoned" + (str _unitG),false];
	};

sleep 20;

if (not (_task isEqualTo taskNull) and not (alive _trg)) then {[_task,"SUCCEEDED",true] call BIS_fnc_taskSetState};

if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markAttack" + str (_unitG))};

//_pass orderGetIn true;

_attAv = _HQ getVariable ["RydHQ_AttackAv",[]];
_attAv pushBack _unitG;
_HQ setVariable ["RydHQ_AttackAv",_attAv];

_unitG setVariable [("Busy" + (str _unitG)),false];

if not (_request) then {[_trg,"InfAttacked"] call RYD_VarReductor};

_UL = leader _unitG;if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdEnd,"OrdEnd"] call RYD_AIChatter}};
