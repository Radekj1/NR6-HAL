_SCRname = "GoRest";
params ["_unitG","_HQ"];
_Spos = _unitG getvariable ("START" + (str _unitG));if (isNil ("_Spos")) then {_unitG setVariable [("START" + (str _unitG)),(getPosATL (vehicle (leader _unitG)))];_Spos = _unitG getVariable ("START" + (str _unitG))}; 
_pos = getPosATL (leader _unitG);
_UL = leader _unitG;
_VLU = vehicle _UL;

_inDanger = false;
if ((count _this) > 2) then {_inDanger = _this select 2};

_IsAPlayer = false;
if (RydxHQ_NoCargoPlayers and (isPlayer (leader _unitG))) then {_IsAPlayer = true};

_unitVar = str _unitG;

if (_unitG getVariable [("Resting" + _unitVar),false]) exitwith {};

_AV = assignedVehicle _UL;

_DAV = assigneddriver _AV;
_GDV = group _DAV;

_AAO = _HQ getVariable ["RydHQ_ChosenAAO",false];

_obj = getPosATL (_HQ getVariable ["RydHQ_Obj",(leader _HQ)]);

if (_AAO) then
	{
	_obj = _HQ getVariable ["RydHQ_EyeOfBattle",getPosATL (vehicle (leader _HQ))]
	};

if not (isNull _AV) then
	{
	_GDV = group (assignedDriver _AV);
	if not (_GDV == _unitG) then
		{
		if not (_GDV in (_HQ getVariable ["RydHQ_Exhausted",[]])) then
			{
			{[_x] remoteExecCall ["RYD_MP_unassignVehicle",0]; [[_x],false] remoteExecCall ["orderGetIn",0];} foreach (units _unitG);
			}
		}
	else
		{
			{
			if not ((group _x) == _unitG) then 
				{
				if not ((group _x) in (_HQ getVariable ["RydHQ_Exhausted",[]])) then
					{
					[_x] remoteExecCall ["RYD_MP_unassignVehicle",0]; [[_x],false] remoteExecCall ["orderGetIn",0];
					}
				} 
			}
		foreach (crew _AV);

		_ac = assignedCargo _AV;
		if ((count _ac) > 0) then
			{
				{
				if not ((group _x) == _unitG) then 
					{
					if not ((group _x) in (_HQ getVariable ["RydHQ_Exhausted",[]])) then
						{
						[_x] remoteExecCall ["RYD_MP_unassignVehicle",0]; [[_x],false] remoteExecCall ["orderGetIn",0];
						}
					}
				}
			foreach _ac;
			}
		}
	};


_attackAllowed = attackEnabled _unitG;
_unitG enableAttack false; 

if (_unitG getVariable [("Busy" + (str _unitG)),false]) then {
	_unitG setVariable ["Break",true];
	waitUntil {sleep 5; not (_unitG getVariable ["Break",false])};
};

[_unitG] call RYD_WPdel;

_unitG setVariable [("Resting" + (str _unitG)),true];
_unitG setVariable [("Busy" + (str _unitG)), true];
_unitG setVariable [("Deployed" + (str _unitG)),false];
//_unitG setVariable [("Capt" + (str _unitG)),false];

_Xpos = ((getPosATL (leader _HQ)) select 0) + ((random 500) - 250);
_Ypos = ((getPosATL (leader _HQ)) select 1) + ((random 500) - 250);

_posX = _Xpos;
_posY = _Ypos;

_isDecoy = false;
_enemyMatters = true;

if not (isNull (_HQ getVariable ["RydHQ_RestDecoy",objNull])) then
	{
	_isDecoy = true;

//	_tRadius = (triggerArea (_HQ getVariable ["RydHQ_RestDecoy",objNull])) select 0;

	if ((random 100) >= (_HQ getVariable ["RydHQ_RDChance",100])) exitWith {_unitG setVariable [("Busy" + (str _unitG)),false];_isDecoy = false};

	_tPos = getPosATL (_HQ getVariable ["RydHQ_RestDecoy",objNull]);
//_enemyMatters = (triggerArea (_HQ getVariable ["RydHQ_RestDecoy",objNull])) select 3; - comment here _area = triggerArea sensor1; // result is [200 -0, 120 -1, 45 -2, false -3, -1 -4]; so select 3 would be a check of "isRectangle"....

//	_posX = (_tPos select 0) + (random (2 * _tRadius)) - (_tRadius);
//	_posY = (_tPos select 1) + (random (2 * _tRadius)) - (_tRadius);
	_posX = (_tPos select 0) + (random 200) - 100;
	_posY = (_tPos select 1) + (random 200) - 100;
	};

if not (_isDecoy) then 
	{
	_safedist = 1000/(0.75 + ((_HQ getVariable ["RydHQ_Recklessness",0.5])/2));
	_behind = false;
	_behind2 = false;
	if ((_HQ getVariable ["RydHQ_Cyclecount",1]) > (4 + (((leader _HQ) distance _obj)/1000))) then {_behind2 = true};
	_counterU = 0;

		{
		_VL = vehicle (leader _x);
		if (((_VL distance _obj) < ([_Xpos,_Ypos] distance _obj)) or (((_VL distance _obj) < ([_Xpos,_Ypos] distance _VL)) and ((_VL distance _obj) < (_obj distance _VLU)))) then {_counterU = _counterU + 1};
		if ((_counterU >= (round (2/(0.5 + ((_HQ getVariable ["RydHQ_Recklessness",0.5])/2))))) or (_counterU >= ((count (_HQ getVariable ["RydHQ_Friends",[]]))/(4*(0.5 + ((_HQ getVariable ["RydHQ_Recklessness",0.5])/2)))))) exitwith {_behind = true}
		}
	foreach (_HQ getVariable ["RydHQ_Friends",[]]);

	_Xpos2 = _Xpos;
	_Ypos2 = _Ypos;

	while {(((_obj distance [_Xpos,_Ypos]) > _safedist) and (_behind2) and (_behind))} do
		{
		_Xpos3 = _Xpos2;
		_Ypos3 = _Ypos2;
		_behind2 = false;
		_counterU = 0;
		_Xpos2 = (_Xpos2 + (_obj select 0))/2;
		_Ypos2 = (_Ypos2 + (_obj select 1))/2;
		if not ((_obj distance [_Xpos2,_Ypos2]) > _safedist) exitWith {_Xpos = _Xpos3;_Ypos = _Ypos3};

			{
			_VL = vehicle (leader _x);
			if (((_VL distance _obj) < ([_Xpos2,_Ypos2] distance _obj)) or (((_VL distance _obj) < ([_Xpos2,_Ypos2] distance _VL)) and ((_VL distance _obj) < (_obj distance _VLU)))) then {_counterU = _counterU + 1};
			if ((_counterU >= (round (2/(0.5 + ((_HQ getVariable ["RydHQ_Recklessness",0.5])/2))))) or (_counterU >= ((count (_HQ getVariable ["RydHQ_Friends",[]]))/(4*(0.5 + ((_HQ getVariable ["RydHQ_Recklessness",0.5])/2)))))) exitwith {_behind2 = true}
			}
		foreach (_HQ getVariable ["RydHQ_Friends",[]]);
		if not (_behind2) exitwith {_Xpos = _Xpos3;_Ypos = _Ypos3};
		if (_behind2) then {_Xpos = _Xpos2;_Ypos = _Ypos2};
		};

	_posX = _Xpos;
	_posY = _Ypos;
	};

_isWater = true;
_counter = 0;


waituntil
	{
	_counter = _counter + 1;
	_isWater = surfaceIsWater [_posX,_posY];
	if (_iswater) then 
		{
		_posX = _posX + (random 500) - 250;
		_posY = _posY + (random 500) - 250;
		};

	(not (_isWater) and ((isNull ((leader _HQ) FindNearestEnemy [_posX,_posY])) or ((((leader _HQ) FindNearestEnemy [_posX,_posY]) distance [_posX,_posY]) >= 500) or not (_enemyMatters)) or (_counter > 30))
	};

if ((_counter > 30) or (not (isNull ((leader _HQ) FindNearestEnemy [_posX,_posY])) and ((((leader _HQ) FindNearestEnemy [_posX,_posY]) distance [_posX,_posY]) < 500) and (_enemyMatters))) then {_posX = ((getPosATL (leader _HQ)) select 0) + (random 500) - 250;_posY = ((getPosATL (leader _HQ)) select 1) + (random 500) - 250};

_isWater = surfaceIsWater [_posX,_posY];
if ((_isWater) or (not (isNull ((leader _HQ) FindNearestEnemy [_posX,_posY])) and ((((leader _HQ) FindNearestEnemy [_posX,_posY]) distance [_posX,_posY]) < 500) and (_enemyMatters))) exitwith 
	{
	_unitG setVariable [("Resting" + (str _unitG)),false,true];
	_unitG setVariable [("Busy" + (str _unitG)), false, true];
	_exh = (_HQ getVariable ["RydHQ_Exhausted",[]]);
	_exh = _exh - [_unitG];
	_HQ setVariable ["RydHQ_Exhausted",_exh];
	};
	
[_unitG,[_posX,_posY,0],"HQ_ord_withdraw",_HQ] call RYD_OrderPause;

_nE = _UL findnearestenemy _UL;

_alive = true;

_timer = 0;

if ((isPlayer (leader _unitG)) and (RydxHQ_GPauseActive)) then {hintC "New orders from HQ!";setAccTime 1};

if not (isNull _nE) then
	{
	if ((_HQ getVariable ["RydHQ_Smoke",true]) and ((_nE distance (vehicle _UL)) <= 500) and not (isPlayer _UL)) then
		{
		_posSL = getPosASL _UL;
		_posSL2 = getPosASL _nE;

		_angle = [_posSL,_posSL2,15] call RYD_AngTowards;

		_dstB = _posSL distance _posSL2;
		_pos = [_posSL,_angle,_dstB/4 + (random 100) - 50] call RYD_PosTowards2D;

		_CFF = false;

		if ((_HQ getVariable ["RydHQ_ArtyShells",1]) > 0) then 
			{
			_CFF = ([_pos,(_HQ getVariable ["RydHQ_ArtG",[]]),"SMOKE",9,_UL] call RYD_ArtyMission) select 0;
			if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_SmokeReq,"SmokeReq"] call RYD_AIChatter}};
			};

		if (_CFF) then 
			{
			if ((_HQ getVariable ["RydHQ_ArtyShells",1]) > 0) then {if ((random 100) < RydxHQ_AIChatDensity) then {[(leader _HQ),RydxHQ_AIC_ArtAss,"ArtAss"] call RYD_AIChatter}};
			sleep 60
			}
		else
			{
			if ((_HQ getVariable ["RydHQ_ArtyShells",1]) > 0) then {if ((random 100) < RydxHQ_AIChatDensity) then {[(leader _HQ),RydxHQ_AIC_ArtDen,"ArtDen"] call RYD_AIChatter}};
			[_unitG,_nE] call RYD_Smoke;
			sleep 10;
			if ((vehicle _UL) == _UL) then {sleep 15}
			}
		};
	};
		
if ((isNull _AV) and (([_posX,_posY] distance _UL) > RydxHQ_CargoObjRange) and not (_isAPlayer)) then
	{
	_endThis = false;
	_alive = true;
	_timer = 0;
	_wp0 = [];_wp = [];
	_CargoCheck = _unitG getvariable ("CC" + _unitvar);
	if (isNil ("_CargoCheck")) then {_unitG setVariable [("CC" + _unitvar), false]};

	waituntil
		{
		sleep 5;

	//	if not ((_HQ getVariable ["RydHQ_Order","ATTACK"]) == "DEFEND") then {_unitG setVariable [("Busy" + _unitvar), false];} else {_unitG setVariable [("Busy" + _unitvar), true];};
			
		if ((abs (speed (vehicle (leader _unitG))) < 0.05) and not (_unitG getVariable ["CargoChosen",false])) then {_timer = _timer + 5};

		if ((isNull _unitG) or (isNull _HQ)) then {_endThis = true;_alive = false};
		if (({alive _x} count (units _unitG)) < 1) then {_endThis = true;_alive = false};
		if (_unitG getVariable ["Break",false]) then {_endThis = true;_alive = false; _unitG setVariable ["Break",false];};

		if (((vehicle (leader _unitG)) distance [_posX,_posY]) < 1000) then {_endThis = true;};

		if (_timer > 30) then {_endThis = true};

		//New Cargo???

		_alive = true;
		_CargoCheck = _unitG getvariable ("CC" + _unitvar);
		if (isNil ("_CargoCheck")) then {_unitG setVariable [("CC" + _unitvar), false]};

		_AV = assignedVehicle _UL;

		if not (isNull _AV) then {

			{
				if (isNull (assignedVehicle _x)) then {_x assignAsCargo _AV};
			} forEach (units _unitG);

		};

		if (((_HQ getVariable ["RydHQ_CargoFind",0]) > 0) and not (_IsAPlayer) and (isNull _AV) and (([_posX,_posY] distance (vehicle _UL)) > RydxHQ_CargoObjRange) and not (_unitG getVariable ["CargoCheckPending" + (str _unitG),false])) then 
			{
			[_unitG,_HQ,[_posX,_posY],true] call HAL_SCargo;
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
					_cc = (_unitG getvariable ("CC" + _unitvar));
					if (isNil ("_cc")) then {_unitG setVariable [("CC" + _unitvar), true];_cc = true};
					};

//				if ((_unitG getVariable ["CargoChosen",false]) and not ((count (waypoints _unitG)) < 1)) then {[_unitG, (currentWaypoint _unitG)] setWaypointPosition [getPosATL (vehicle (leader _unitG)), 0]; _wp0 = [];};
						
				(not (_alive) or (_cc))
				};
					
			if not (isNull _unitG) then {_unitG setVariable [("CC" + _unitvar), false]};
			};

		if (not (_unitG getVariable ["CargoChosen",false]) and not (_unitG getVariable ["CargoCheckPending" + (str _unitG),false])) then 
			{
				if (_wp0 isEqualTo []) then {_wp0 = [_unitG,[_posX,_posY],"MOVE","AWARE","YELLOW","FULL",["true","deletewaypoint [(group this), 0];"],true,0] call RYD_WPadd;}
			} else {
				if (_wp0 isEqualTo []) then {_wp0 = [_unitG,[_posX,_posY],"MOVE","AWARE","YELLOW","FULL",["true","deletewaypoint [(group this), 0];"],true,0] call RYD_WPadd;};
	//			if not ((count (waypoints _unitG)) < 1) then {[_unitG, (currentWaypoint _unitG)] setWaypointPosition [getPosATL (vehicle (leader _unitG)), 0]; _wp0 = []};
			};

		if not (_alive) exitWith 
				{
				_exh = (_HQ getVariable ["RydHQ_Exhausted",[]]);
				_exh = _exh - [_unitG];
				_HQ setVariable ["RydHQ_Exhausted",_exh];
				_unitG setVariable [("Busy" + (str _unitG)),false];
				_unitG setVariable [("Resting" + (str _unitG)),false];
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

			_task = [(leader _unitG),["Embark your lift.", "Get In Lift", ""],(getPosATL (leader _unitG)),"getin"] call RYD_AddTask;

			_wp = [_unitG,_AV,"GETIN"] call RYD_WPadd;
			_wp waypointAttachVehicle _AV;
			_wp setWaypointCompletionRadius 750;

			{if (not (isPlayer (leader _unitG)) and not (_GDV == _unitG))  then {_x assignAsCargo _AV; [[_x],true] remoteExecCall ["orderGetIn",0];}} foreach (units _unitG);

			_cause = [_unitG,1,false,0,300,[],true,false,true,false,false,false] call RYD_Wait;
			_timer2 = _cause select 0;
			_AV land 'NONE';

			if not (_task isEqualTo taskNull) then {[_task,"SUCCEEDED",true] call BIS_fnc_taskSetState};

			if (isNil "_timer2") then {_timer2 = 0};

			if ((({alive _x} count (units _unitG)) < 1) or (_timer2 > 300)) exitwith 
				{

				{if (not (isPlayer (leader _unitG)) and not (_GDV == _unitG)) then {[_x] remoteExecCall ["RYD_MP_unassignVehicle",0]; [[_x],false] remoteExecCall ["orderGetIn",0];}} foreach (units _unitG);

				_unitG setVariable [("Resting" + (str _unitG)),false];
				_unitG setVariable [("Busy" + (str _unitG)), false];
				_endThis = true;
					
				_exh = (_HQ getVariable ["RydHQ_Exhausted",[]]);
				_exh = _exh - [_unitG];
				_HQ setVariable ["RydHQ_Exhausted",_exh];

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

if not (_unitG getVariable [("Busy" + (str _unitG)),false]) exitwith {};


_AV = assignedVehicle _UL;

_DAV = assigneddriver _AV;
_GDV = group _DAV;

_UL = leader _unitG;
 
if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdConf,"OrdConf"] call RYD_AIChatter}};

if (_HQ getVariable ["RydHQ_Debug",false]) then
	{
	_signum = _HQ getVariable ["RydHQ_CodeSign","X"];
	_i = [[_posX,_posY],_unitG,"markRest","Default","ICON","waypoint", (groupId _unitG) + " " + _signum," - WITHDRAW",[0.5,0.5]] call RYD_Mark
	};

_task = [(leader _unitG),["Withdraw. Take care of your wounded, rearm and wait for further orders.", "Withdraw", ""],[_posX,_posY],"run"] call RYD_AddTask;

_Ctask = taskNull;

if (not ((leader _GDV) == (leader _unitG))) then
	{
	_Ctask = [(leader _GDV),["Drop off " + (groupId _unitG) + " for MEDEVAC.", "Withdraw " + (groupId _unitG), ""],[_posX,_posY],"heal"] call RYD_AddTask;
	};

if (isNull _unitG) exitWith {_unitG setVariable [("Busy" + (str _unitG)),false];_unitG setVariable [("Resting" + (str _unitG)),false];};
_lackAmmo = _unitG getVariable ["LackAmmo",false];
_counts = 6;
if (_lackAmmo) then 
	{
	_counts = 6.1
	};
	
_gp = _unitG;
if (not (isNull _AV) and not (_GDV == _unitG) and not (_isAPlayer)) then {_gp = _GDV;};
_beh = "AWARE";
_cm = "GREEN";
if (not (isNull _AV) and not ((_GDV == _unitG) or (_GDV in (_HQ getVariable ["RydHQ_AirG",[]])))) then {_beh = "STEALTH";_cm = "YELLOW"};
_sts = ["true","deletewaypoint [(group this), 0];"];
if (((group (assigneddriver _AV)) in (_HQ getVariable ["RydHQ_AirG",[]])) and (_unitG in (_HQ getVariable ["RydHQ_NCrewInfG",[]]))) then {_sts = ["true","(vehicle this) land 'GET OUT';deletewaypoint [(group this), 0]"]};

_wp = [_gp,[_posX,_posY],"MOVE",_beh,_cm,"FULL",_sts] call RYD_WPadd;

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

_DAV = assigneddriver _AV;
_OtherGroup = false;
_GDV = group _DAV;
_alive = true;
_enemy = false;
_timer = 0;

if ((_GDV == _unitG) and not (isNull _AV) and not (_IsAPlayer)) then {_AV setUnloadInCombat [false, false]};

if not (_IsAPlayer) then {
	if not (((group _DAV) == (group _UL)) or (isNull (group _DAV))) then 
		{
		_OtherGroup = true;

		_cause = [_GDV,6,true,400,30,[(_HQ getVariable ["RydHQ_AirG",[]]),(_HQ getVariable ["RydHQ_KnEnemiesG",[]])],false] call RYD_Wait;
		_cause params ["_timer","_alive","_enemy"];
		}
	else 
		{
		if not (_isAPlayer) then {_unitG setVariable ["InfGetinCheck" + (str _unitG),true]};
		_cause = [_unitG,_counts,true,0,60,[],false] call RYD_Wait;
		_cause params ["_timer","_alive"];
		};
};

if ((_GDV == _unitG) and not (isNull _AV) and not (_IsAPlayer)) then {_AV setUnloadInCombat [true, false]};

_DAV = assigneddriver _AV;
if (((_timer > 30) or (_enemy)) and (_OtherGroup)) then {if not (isNull _GDV) then {[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 0]}};
if ((_timer > 60) and not (_otherGroup)) then {[_unitG, (currentWaypoint _unitG)] setWaypointPosition [getPosATL (vehicle _UL), 0]};

if (not (_alive) and not (_OtherGroup)) exitwith 
	{
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
		{
		deleteMarker ("markRest" + str (_unitG))
		};
		
	_exh = (_HQ getVariable ["RydHQ_Exhausted",[]]);
	_exh = _exh - [_unitG];
	_HQ setVariable ["RydHQ_Exhausted",_exh];
	_unitG setVariable [("Busy" + (str _unitG)),false];
	_unitG setVariable [("Resting" + (str _unitG)),false];
	if not (isNull _GDV) then 
		{
		[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 0];
		_GDV setVariable [("CargoM" + (str _GDV)), false];
		//_pass orderGetIn true;
		};
	};

if (({alive _x} count (units _unitG)) < 1) exitwith 
	{
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
		{
		deleteMarker ("markRest" + str (_unitG))
		};
		
	_exh = (_HQ getVariable ["RydHQ_Exhausted",[]]);
	_exh = _exh - [_unitG];
	_HQ setVariable ["RydHQ_Exhausted",_exh];
	_unitG setVariable [("Busy" + (str _unitG)),false];
	_unitG setVariable [("Resting" + (str _unitG)),false];
	if not (isNull _GDV) then 
		{
		[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 0];
		_GDV setVariable [("CargoM" + (str _GDV)), false];
		//_pass orderGetIn true;
		};
	};

_UL = leader _unitG;

_AV = assignedVehicle _UL;

_pass = assignedCargo _AV;
_allowed = true;
if not ((_GDV == _unitG) or (isNull _GDV)) then 
	{
	{[[_x],false] remoteExecCall ["orderGetIn",0];} foreach _pass;
	_allowed = false;
	(units _unitG) allowGetIn false;
	[_unitG] call RYD_WPdel;
	//if (player in (units _unitG)) then {diag_log "NOT ALLOW rest"};
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
	_cause = [_unitG,1,false,0,240,[],true,true,false,false,false,false,false,_pass,_AV] call RYD_Wait;
	_timer = _cause select 0
	};

if not ((_GDV == _unitG) or (isNull _GDV)) then 
	{
	{[_x] remoteExecCall ["RYD_MP_unassignVehicle",0]; [[_x],false] remoteExecCall ["orderGetIn",0];} foreach (units _unitG);
	};

if not (_allowed) then {(units _unitG) allowGetIn true};

if (_HQ getVariable ["RydHQ_LZ",false]) then {deleteVehicle _lz};

_unitvar = str _GDV;

if ((isNull (leader (_this select 0))) or (_timer > 240)) exitwith 
	{
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
		{
		deleteMarker ("markRest" + str (_unitG))
		};
	_exh = (_HQ getVariable ["RydHQ_Exhausted",[]]);
	_exh = _exh - [_unitG];
	_HQ setVariable ["RydHQ_Exhausted",_exh];
	_unitG setVariable [("Busy" + (str _unitG)),false];
	_unitG setVariable [("Resting" + (str _unitG)),false];
	if not (isNull _GDV) then 
		{
		[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 0];
		_GDV setVariable [("CargoM" + (str _GDV)), false];
		//_pass orderGetIn true;
		}
	};

if not (_Ctask isEqualTo taskNull) then {[_Ctask,"SUCCEEDED",true] call BIS_fnc_taskSetState};

if (not (isNull _GDV) and (_GDV in (_HQ getVariable ["RydHQ_AirG",[]])) and not (isPlayer (leader _GDV)) and not (_IsAPlayer)) then
	{
	_wp = [_GDV,[((getPosATL _AV) select 0) + (random 200) - 100,((getPosATL _AV) select 1) + (random 200) - 100,1000],"MOVE","STEALTH","YELLOW","NORMAL"] call RYD_WPadd;

	_cause = [_GDV,3,true,0,8,[],false] call RYD_Wait;
	_timer = _cause select 0;
	if (_timer > 8) then {[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 0]};
	};

if not (_IsAPlayer) then {_GDV setVariable [("CargoM" + _unitvar), false]};

_UL = leader _unitG;if not (isPlayer _UL) then {if (_timer <= 60) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdFinal,"OrdFinal"] call RYD_AIChatter}}};

//diag_log format ["rest: %1",_unitG];

_noDanger = not _inDanger;

waituntil 
	{
	sleep 60;
	
	_vehready = true;
	_solready = true;
	_effective = true;
	_ammo = true;
	_Gdamage = 0;
	_alive = true;
	_transfers = [];
	
	if not (isNull _unitG) then
		{
		if (({alive _x} count (units _unitG)) > 0) then
			{
			if (([_unitG,(_HQ getVariable ["RydHQ_NCVeh",[]])] call RYD_AmmoFullCount) < 0.15) then 
				{
				_ammo = false
				}
			else
				{
					{
					_Gdamage = _Gdamage + (damage _x);
					if (((count (magazines _x)) == 0) and (((vehicle _x) == _x) or ((vehicle _x) in (_HQ getVariable ["RydHQ_NCVeh",[]])))) exitWith {_ammo = false};
					if (((damage _x) > 0.5) or not (canStand _x)) exitWith {_effective = false};
					}
				foreach (units _unitG)
				};

			_nominal = _unitG getVariable [("Nominal" + (str _unitG)),count (units _unitG)];
			_current = count (units _unitG);
			_Gdamage = _Gdamage + (_nominal - _current);
			if (((_Gdamage/(_current + 0.1)) > (0.4*(((_HQ getVariable ["RydHQ_Recklessness",0.5])/1.2) + 1))) or not (_effective) or not (_ammo)) then {_solready = false};

				{
				_veh = assignedvehicle _x;
				if (not (isNull _veh) and (not (canMove _veh) or ((fuel _veh) <= 0.1) or ((damage _veh) > 0.5) or (((group _x) in (((_HQ getVariable ["RydHQ_AirG",[]]) - (_HQ getVariable ["RydHQ_NCAirG",[]])) + ((_HQ getVariable ["RydHQ_HArmorG",[]]) + (_HQ getVariable ["RydHQ_LArmorG",[]]) + ((_HQ getVariable ["RydHQ_CarsG",[]]) - ((_HQ getVariable ["RydHQ_NCCargoG",[]]) + (_HQ getVariable ["RydHQ_SupportG",[]])))))) and ((count (magazines _veh)) == 0)) and not ((group _x) in (_HQ getVariable ["RydHQ_RAirG",[]])))) exitwith {_vehready = false};
				}
			foreach (units _unitG);
			}
		else
			{
			_alive = false
			}
		}
	else
		{
		_alive = false
		};
		
	if (_alive) then
		{
		if (_inDanger) then
			{
			_inD = _unitG getVariable ["NearE",0];
			
			if not ((_inD * (_HQ getVariable ["RydHQ_Withdraw",1])) > 0.5) then
				{
				_noDanger = true
				}
			};
		if ((_unitG in (_HQ getVariable ["RydHQ_InfG",[]])) and not ((_vehready) and (_solready) and (_noDanger))) then {
			{if ((_x in ((_HQ getVariable ["RydHQ_Inf",[]]) - (_HQ getVariable ["RydHQ_Crew",[]]))) and (someAmmo _x) and ((damage _x) < 0.2)) then {_transfers pushBack _x}} foreach (units _unitG);
			};
		};

	{
		_trs = _x;
		{
			if ((((vehicle (leader _x)) distance (_trs)) < 600) and (_x in ((_HQ getVariable ["RydHQ_Inf",[]]) - (_HQ getVariable ["RydHQ_Crew",[]]))) and ((count (units _x)) >= (count (units _unitG))) and not (_x getVariable ["RestTransf",false])) then {[_trs] join _x};
			_unitG setVariable ["RestTransf",true];

		} foreach (_HQ getVariable ["RydHQ_Exhausted",[]]);

	} foreach _transfers;

	if (_unitG getVariable ["Break",false]) then {_unitG setVariable ["Break",false]; _alive = false};
		
	(((_vehready) and (_solready) and (_noDanger)) or not (_alive))
	};
	
//diag_log format ["endrest: %1 alive: %2",_unitG,_alive];

_exh = (_HQ getVariable ["RydHQ_Exhausted",[]]);

if not (_alive) exitWith 
	{
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
		{
		deleteMarker ("markRest" + str (_unitG))
		};
	
	_exh = _exh - [_unitG];
	_unitG setVariable [("Busy" + (str _unitG)),false];
	_unitG setVariable [("Resting" + (str _unitG)),false];
	_unitG setVariable ["LackAmmo",false];
	_HQ setVariable ["RydHQ_Exhausted",_exh]
	};
	
if not (_task isEqualTo taskNull) then {[_task,"SUCCEEDED",true] call BIS_fnc_taskSetState};

if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markRest" + str (_unitG))};

_exh = _exh - [_unitG];
_HQ setVariable ["RydHQ_Exhausted",_exh];

if (_attackAllowed) then {_unitG enableAttack true}; 

_unitG setVariable [("Resting" + (str _unitG)),false];
_unitG setVariable [("Busy" + (str _unitG)), false];
_unitG setVariable ["LackAmmo",false];

_UL = leader _unitG;if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdEnd,"OrdEnd"] call RYD_AIChatter}};
