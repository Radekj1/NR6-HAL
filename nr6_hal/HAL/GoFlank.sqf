_SCRname = "GoFlank";

_i1 = "";
_i2 = "";
_i3 = "";
_i4 = "";

_unitG = _this select 0;
_Spos = _unitG getVariable ("START" + (str _unitG));if (isNil ("_Spos")) then {_unitG setVariable [("START" + (str _unitG)),(getPosATL (vehicle (leader _unitG))),true]}; 
_BEnemyPos = _this select 1;
_PosMidX = _this select 2;
_PosMidY = _this select 3;
_angle0 = _this select 4;
_MinSide = _this select 5;
_HQ = _this select 6;

_UL = leader _unitG;

_IsAPlayer = false;
if (RydxHQ_NoCargoPlayers and (isPlayer (leader _unitG))) then {_IsAPlayer = true};

_safeX1 = 0;
_safeY1 = 0;

_safeX2 = 0;
_safeY2 = 0;

_GposX = (getPosATL (leader _unitG)) select 0;
_GposY = (getPosATL (leader _unitG)) select 1;

_BEposX = _BEnemyPos select 0;
_BEposY = _BEnemyPos select 1;

_dX = _BEposX - ((getPosATL (leader _HQ)) select 0);
_dY = _BEposY - ((getPosATL (leader _HQ)) select 1);

_angle = _dX atan2 _dY;

if (_angle < 0) then {_angle = _angle + 360};  
_h = 1;
if ((_angle0 > 45) and (_angle0 <= 225)) then {_h = - 1};

_BorHQD = (leader _HQ) distance _BEnemyPos;

_distanceSafe = 700;

_dstMpl = (_HQ getVariable ["RydHQ_FlankDistance",1]) * (_unitG getVariable ["RydHQ_myAttDst",1]);
_distanceSafe = _distanceSafe * _dstMpl;

_safeX1 = _h * _distanceSafe * (cos _angle);
_safeY1 = _h * _distanceSafe * (sin _angle);

_safeX2 = _distanceSafe * (sin _angle);
_safeY2 = _distanceSafe * (cos _angle);

if (_MinSide) then {_safeX1 = - _safeX1} else {_safeY1 = - _safeY1};

_FlankPosX = _BorHQD * (sin _angle);
_FlankPosY = _BorHQD * (cos _angle);

_posXWP1 = ((getPosATL (leader _HQ)) select 0) + _FlankPosX + _safeX1 + (random 200) - 100;
_posYWP1 = ((getPosATL (leader _HQ)) select 1) + _FlankPosY + _safeY1 + (random 200) - 100;

_isWater = surfaceIsWater [_posXWP1,_posYWP1];

while {((_isWater) and (([_posXWP1,_posYWP1] distance _BEnemyPos) >= 200))} do
	{
	_posXWP1 = _posXWP1 - _safeX1/20;
	_posYWP1 = _posYWP1 - _safeY1/20;
	_isWater = surfaceIsWater [_posXWP1,_posYWP1];
	};

_isWater = surfaceIsWater [_posXWP1,_posYWP1];

if (_isWater) then {_unitG setVariable [("Busy" + (str _unitG)),false];_HQ setVariable ["RydHQ_FlankAv",(_HQ getVariable ["RydHQ_FlankAv",[]]) - [_unitG]]};

_posXWP2 = _posXWP1 + _safeX2 + (random 200) - 100;
_posYWP2 = _posYWP1 + _safeY2 + (random 200) - 100;

_isWater = surfaceIsWater [_posXWP2,_posYWP2];

while {((_isWater) and (([_posXWP2,_posYWP2] distance _BEnemyPos) >= 200))} do
	{
	_posXWP2 = _posXWP2 - _safeX2/20;
	_posYWP2 = _posYWP2 - _safeY2/20;
	_isWater = surfaceIsWater [_posXWP2,_posYWP2];
	};

_isWater = surfaceIsWater [_posXWP2,_posYWP2];

if (_isWater) exitWith {_unitG setVariable [("Busy" + (str _unitG)),false];_HQ setVariable ["RydHQ_FlankAv",(_HQ getVariable ["RydHQ_FlankAv",[]]) - [_unitG]]};

_posXWP3 = _posXWP2 - (_safeX1/2) + (random 200) - 100;
_posYWP3 = _posYWP2 - (_safeY1/2) + (random 200) - 100;

_isWater = surfaceIsWater [_posXWP3,_posYWP3];

while {((_isWater) and (([_posXWP3,_posYWP3] distance _BEnemyPos) >= 150))} do
	{
	_posXWP3 = (_posXWP3 + (_BEnemyPos select 0))/2;
	_posYWP3 = (_posYWP3 + (_BEnemyPos select 1))/2;
	_isWater = surfaceIsWater [_posXWP3,_posYWP3];
	};

_isWater = surfaceIsWater [_posXWP3,_posYWP3];

if (_isWater) exitWith {_unitG setVariable [("Busy" + (str _unitG)),false];_HQ setVariable ["RydHQ_FlankAv",(_HQ getVariable ["RydHQ_FlankAv",[]]) - [_unitG]]};

_posXWP4 = _PosMidX + (random 200) - 100;
_posYWP4 = _PosMidY + (random 200) - 100;

_isWater = surfaceIsWater [_posXWP4,_posYWP4];

while {((_isWater) and (([_posXWP4,_posYWP4] distance _BEnemyPos) >= 150))} do
	{
	_posXWP3 = (_posXWP4 + (_BEnemyPos select 0))/2;
	_posYWP3 = (_posYWP4 + (_BEnemyPos select 1))/2;
	_isWater = surfaceIsWater [_posXWP4,_posYWP4];
	};

_isWater = surfaceIsWater [_posXWP4,_posYWP4];

if (_isWater) exitWith {_unitG setVariable [("Busy" + (str _unitG)),false];_HQ setVariable ["RydHQ_FlankAv",(_HQ getVariable ["RydHQ_FlankAv",[]]) - [_unitG]]};

if (((leader _HQ) distance [_posXWP1,_posYWP1]) > ((leader _HQ) distance [_posXWP2,_posYWP2])) then 
	{
	_posXWP2 = _posXWP1 - _safeX2;
	_posYWP2 = _posYWP1 - _safeY2;

	_isWater = surfaceIsWater [_posXWP2,_posYWP2];

	while {((_isWater) and (([_posXWP2,_posYWP2] distance _BEnemyPos) >= 200))} do
		{
		_posXWP2 = _posXWP2 + _safeX2/20;
		_posYWP2 = _posYWP2 + _safeY2/20;
		_isWater = surfaceIsWater [_posXWP2,_posYWP2];
		};

	_isWater = surfaceIsWater [_posXWP2,_posYWP2];
	};

if (_isWater) exitWith {_unitG setVariable [("Busy" + (str _unitG)),false];_HQ setVariable ["RydHQ_FlankAv",(_HQ getVariable ["RydHQ_FlankAv",[]]) - [_unitG]]};

if (((leader _unitG) distance [_posXWP2,_posYWP2]) < ((leader _unitG) distance [_posXWP1,_posYWP1])) then {_posXWP1 = _GposX;_posYWP1 = _GposY};

_ammo = [_unitG,(_HQ getVariable ["RydHQ_NCVeh",[]])] call RYD_AmmoCount;

_unitvar = str (_unitG);
_busy = false;
_busy = _unitG getVariable ("Busy" + _unitvar);
if (isNil ("_busy")) then {_busy = false};
_task = taskNull;
if ((_ammo > 0) and not (_busy)) then
	{
	_unitG setVariable [("Deployed" + (str _unitG)),false];_unitG setVariable [("Capt" + (str _unitG)),false];
	_unitG setVariable [("Busy" + (str _unitG)),true];

	[_unitG] call RYD_WPdel;
	
	[_unitG,[_posXWP4,_posYWP4,0],"HQ_ord_flank",_HQ] call RYD_OrderPause;

	if ((isPlayer (leader _unitG)) and (RydxHQ_GPauseActive)) then {hintC "New orders from HQ!";setAccTime 1};

	_UL = leader _unitG;
	 
	if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdConf,"OrdConf"] call RYD_AIChatter}};

	
	if (_HQ getVariable ["RydHQ_Debug",false]) then 
		{
		_signum = _HQ getVariable ["RydHQ_CodeSign","X"];
		_i1 = [[_posXWP1,_posYWP1],_unitG,"markFlank1","ColorOrange","ICON","waypoint","FLANK1 "  + (groupId _unitG) + " " + _signum," - FLANK 1",[0.5,0.5]] call RYD_Mark;
		_i2 = [[_posXWP2,_posYWP2],_unitG,"markFlank2","ColorOrange","ICON","waypoint","FLANK2 "  + (groupId _unitG) + " " + _signum," - FLANK 2",[0.5,0.5]] call RYD_Mark;
		_i3 = [[_posXWP3,_posYWP3],_unitG,"markFlank3","ColorOrange","ICON","waypoint","FLANK3 "  + (groupId _unitG) + " " + _signum," - FLANK 3",[0.5,0.5]] call RYD_Mark;
		_i4 = [[_posXWP4,_posYWP4],_unitG,"markFlank4","ColorOrange","ICON","waypoint","FLANK4 "  + (groupId _unitG) + " " + _signum," - FLANKING ATTACK",[0.5,0.5]] call RYD_Mark
		};

	_alive = true;
	_CargoCheck = _unitG getVariable ("CC" + _unitvar);
	if (isNil ("_CargoCheck")) then {_unitG setVariable [("CC" + _unitvar), false]};

	_AV = assignedVehicle _UL;

	if not (isNull _AV) then { 

		{
			if (isNull (assignedVehicle _x)) then {_x assignAsCargo _AV};
		} forEach (units _unitG);
	};

	if (((_HQ getVariable ["RydHQ_CargoFind",0]) > 0) and not (_IsAPlayer) and (isNull _AV) and (([_posXWP4,_posYWP4] distance (vehicle _UL)) > RydxHQ_CargoObjRange)) then 
		{
		//[_unitG,_HQ,[_posXWP4,_posYWP4]] spawn HAL_SCargo
		[[_unitG,_HQ,[_posXWP4,_posYWP4]],HAL_SCargo] call RYD_Spawn;
		} 
	else 
		{
		_unitG setVariable [("CC" + _unitvar), true]
		};
		
	if (((_HQ getVariable ["RydHQ_CargoFind",0]) > 0) and not (_IsAPlayer)) then 
		{	
		waitUntil 
			{
			sleep 0.05;
			switch (true) do
				{
				case (isNull _unitG) : {_alive = false};
				case (({alive _x} count (units _unitG)) < 1) : {_alive = false};
				case ((_this select 0) getVariable ["RydHQ_MIA",false]) : {_alive = false;(_this select 0) setVariable ["RydHQ_MIA",nil]};
				case (_unitG getVariable ["Break",false]) : {_alive = false; _unitG setVariable ["Break",false]; _unitG setVariable [("Busy" + (str _unitG)),false]}
				};
				
			_cc = false;
			if (_alive) then
				{
				_cc = (_unitG getVariable ("CC" + _unitvar))
				};
				
			(not (_alive) or (_cc))
			};
			
		if not (isNull _unitG) then {_unitG setVariable [("CC" + _unitvar), false]};
		};

	if not (_alive) exitWith 
		{
		_unitG setVariable [("Busy" + (str _unitG)),false]; if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {{deleteMarker _x} forEach [_i1,_i2,_i3,_i4]}
		};
		
	_AV = assignedVehicle _UL;
	_DAV = assignedDriver _AV;
	_GDV = group _DAV;
	_alive = true;
	_timer = 0;
	
	[_unitG] call RYD_WPdel;

	if (not (isNull _AV) and ((_HQ getVariable ["RydHQ_CargoFind",0]) > 0) and not (_GDV == _unitG) and not (_IsAPlayer)) then
		{
		_task = [(leader _unitG),["Wait for your lift to your destination.", "Get In Lift", ""],(getPosATL (leader _unitG)),"getin"] call RYD_AddTask;

		_wp = [_unitG,_AV,"GETIN"] call RYD_WPadd;
		_wp waypointAttachVehicle _AV;
		_wp setWaypointCompletionRadius 750;
		{if (not (isPlayer (leader _unitG)) and not (_GDV == _unitG))  then {_x assignAsCargo _AV; [[_x],true] remoteExecCall ["orderGetIn",0];}} forEach (units _unitG);
		_cause = [_unitG,1,false,0,300,[],true,false,true,false,false,false] call RYD_Wait;
		_timer = _cause select 0;
		_AV land 'NONE';
		};

	
	if ((({alive _x} count (units _unitG)) < 1) or (_timer > 300)) exitWith {_unitG setVariable [("Busy" + (str _unitG)),false];if not (_task isEqualTo taskNull) then {[_task,"CANCELED",true] call BIS_fnc_taskSetState}; if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {{deleteMarker _x} forEach [_i1,_i2,_i3,_i4]};if not (isNull _GDV) then {[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 1];
	_GDV setVariable [("CargoM" + (str _GDV)), false];
	}};
	
	if not (_task isEqualTo taskNull) then {[_task,"SUCCEEDED",true] call BIS_fnc_taskSetState};

	_AV = assignedVehicle _UL;
	_DAV = assignedDriver _AV;
	_GDV = group _DAV;
	_wp1 = [];
	_wp2 = [];
	_wp3 = [];

	_task = [(leader _unitG),["Flank hostile forces and standby for further orders.", "Take Flanking Position", ""],[_posXWP1,_posYWP1],"navigate"] call RYD_AddTask;

	_Ctask = taskNull;
	if (not ((leader _GDV) == (leader _unitG)) and not (_GDV == _unitG)) then
		{
		_Ctask = [(leader _GDV),["", "Provide Lift", ""],[_posXWP1,_posYWP1],"navigate"] call RYD_AddTask
		};

	[_unitG] call RYD_WPdel;

	_grp = _unitG;
	_beh = "AWARE";
	if not (isNull _AV) then {_grp = _GDV;_beh = "SAFE"};
	if (not (isNull _AV) and (_GDV in (_HQ getVariable ["RydHQ_AirG",[]]))) then {_beh = "STEALTH"};
	_TO = [0,0,0];
	if ((isNull _AV) and (([_posXWP1,_posYWP1] distance _UL) > 1000)) then {_TO = [40, 45, 50]};
	_formation = formation _grp;
	if not (isPlayer (leader _grp)) then {_formation = "STAG COLUMN"};
	_wp1 = [_grp,[_posXWP1,_posYWP1],"MOVE",_beh,"GREEN","NORMAL",["true","deletewaypoint [(group this), 0];"],true,0,_TO,_formation] call RYD_WPadd;

	_DAV = assignedDriver _AV;
	_OtherGroup = false;
	_GDV = group _DAV;
	_enemy = false;
	_alive = true;

	if not (_IsAPlayer) then {
		if not (((group _DAV) == (group _UL)) or (isNull (group _DAV))) then 
			{
			_OtherGroup = true;

			_cause = [_GDV,6,true,300,30,[(_HQ getVariable ["RydHQ_AirG",[]]),(_HQ getVariable ["RydHQ_KnEnemiesG",[]])],true] call RYD_Wait;
			_timer = _cause select 0;
			_alive = _cause select 1;
			_enemy = _cause select 2;
			}
		else 
			{
			if not (_isAPlayer) then {_unitG setVariable ["InfGetinCheck" + (str _unitG),true]};
			_cause = [_unitG,6,true,300,30,[(_HQ getVariable ["RydHQ_AirG",[]]),(_HQ getVariable ["RydHQ_KnEnemiesG",[]])],false] call RYD_Wait;
			_timer = _cause select 0;
			_alive = _cause select 1;
			_enemy = _cause select 2;
			};
	};

	if (((_timer > 30) or (_enemy)) and (_OtherGroup)) then {if not (isNull _GDV) then {[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle _UL), 1]}};
	if (((_timer > 30) or (_enemy)) and not (_OtherGroup)) then {[_unitG, (currentWaypoint _unitG)] setWaypointPosition [getPosATL (vehicle _UL), 1]};
	_GDV setVariable [("CargoM" + (str _GDV)), false];
	if (not (_alive) and not (_OtherGroup)) exitWith {_unitG setVariable [("Busy" + (str _unitG)),false];if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {{deleteMarker _x} forEach [_i1,_i2,_i3,_i4]}};
	if (({alive _x} count (units _unitG)) < 1) exitWith {_unitG setVariable [("Busy" + (str _unitG)),false];if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {{deleteMarker _x} forEach [_i1,_i2,_i3,_i4]};if not (isNull _GDV) then {[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 1];
	}};

	if not (_task isEqualTo taskNull) then
		{
		
		[_task,(leader _unitG),["Flank hostile forces and standby for further orders.", "Take Flanking Position", ""],[_posXWP2,_posYWP2],"ASSIGNED",0,false,true] call BIS_fnc_SetTask; 

		};

	if (not (_Ctask isEqualTo taskNull) and not ((leader _GDV) == (leader _unitG))) then
		{
		
		[_Ctask,(leader _GDV),["", "Provide Lift", ""],[_posXWP2,_posYWP2],"ASSIGNED",0,false,true] call BIS_fnc_SetTask;
			 
		};

	[_unitG] call RYD_WPdel;

	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {_i1 setMarkerColor "ColorBlue"};

	_grp = _unitG;
	if not (isNull _AV) then {_grp = _GDV};
	_beh = "AWARE";
	if (not (isNull _AV) and (_GDV in (_HQ getVariable ["RydHQ_AirG",[]]))) then {_beh = "STEALTH"};
	_TO = [0,0,0];
	if ((isNull _AV) and (([_posXWP2,_posYWP2] distance _UL) > 1000)) then {_TO = [40, 45, 50]};
	_formation = formation _grp;
	if not (isPlayer (leader _grp)) then {_formation = "STAG COLUMN"};

	_wp2 = [_grp,[_posXWP2,_posYWP2],"MOVE",_beh,"GREEN","NORMAL",["true","deletewaypoint [(group this), 0];"],true,0,_TO,_formation] call RYD_WPadd;

	_DAV = assignedDriver _AV;
	_OtherGroup = false;
	_GDV = group _DAV;
	_enemy = false;
	_alive = true;

	if not (_IsAPlayer) then {
		if not (((group _DAV) == (group _UL)) or (isNull (group _DAV))) then 
			{
			_OtherGroup = true;

			_cause = [_GDV,6,true,300,30,[(_HQ getVariable ["RydHQ_AirG",[]]),(_HQ getVariable ["RydHQ_KnEnemiesG",[]])],true] call RYD_Wait;
			_timer = _cause select 0;
			_alive = _cause select 1;
			_enemy = _cause select 2;
			}
		else 
			{
			if not (_isAPlayer) then {_unitG setVariable ["InfGetinCheck" + (str _unitG),true]};
			_cause = [_unitG,6,true,300,30,[(_HQ getVariable ["RydHQ_AirG",[]]),(_HQ getVariable ["RydHQ_KnEnemiesG",[]])],false] call RYD_Wait;
			_timer = _cause select 0;
			_alive = _cause select 1;
			_enemy = _cause select 2;
			};
	};

	if (((_timer > 30) or (_enemy)) and (_OtherGroup)) then {if not (isNull _GDV) then {[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle _UL), 1]}};
	if (((_timer > 30) or (_enemy)) and not (_OtherGroup)) then {[_unitG, (currentWaypoint _unitG)] setWaypointPosition [getPosATL (vehicle _UL), 1]};
	_GDV setVariable [("CargoM" + (str _GDV)), false];
	if (not (_alive) and not (_OtherGroup)) exitWith {_unitG setVariable [("Busy" + (str _unitG)),false];if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {{deleteMarker _x} forEach [_i1,_i2,_i3,_i4]}};
	if (({alive _x} count (units _unitG)) < 1) exitWith {_unitG setVariable [("Busy" + (str _unitG)),false];if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {{deleteMarker _x} forEach [_i1,_i2,_i3,_i4]};if not (isNull _GDV) then {[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 1];
	}};

	if not (_task isEqualTo taskNull) then
		{
		
		[_task,(leader _unitG),["Flank hostile forces and standby for further orders.", "Take Flanking Position", "Move", ""],[_posXWP3,_posYWP3],"ASSIGNED",0,false,true] call BIS_fnc_SetTask;
			 
		};

	if (not (_Ctask isEqualTo taskNull) and not ((leader _GDV) == (leader _unitG))) then
		{
		
		[_Ctask,(leader _GDV),["", "Provide Lift", ""],[_posXWP3,_posYWP3],"ASSIGNED",0,false,true] call BIS_fnc_SetTask;
			 
		};

	[_unitG] call RYD_WPdel;

	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {_i2 setMarkerColor "ColorBlue"};

	_tp = "MOVE";
	//if (not (isNull _AV) and (_unitG in (_HQ getVariable ["RydHQ_NCrewInfG",[]])) and not ((_GDV == _unitG) or (_GDV in (_HQ getVariable ["RydHQ_AirG",[]])))) then {_tp = "UNLOAD"};
	_grp = _unitG;
	if not (isNull _AV) then {_grp = _GDV};
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

	_sts = ["true","deletewaypoint [(group this), 0];"];
	if (((group (assignedDriver _AV)) in (_HQ getVariable ["RydHQ_AirG",[]])) and (_unitG in (_HQ getVariable ["RydHQ_NCrewInfG",[]]))) then {_sts = ["true","(vehicle this) land 'GET OUT';deletewaypoint [(group this), 0]"]};
	_TO = [0,0,0];
	if ((isNull _AV) and (([_posXWP3,_posYWP3] distance _UL) > 1000)) then {_TO = [40, 45, 50]};
	_formation = formation _grp;
	if not (isPlayer (leader _grp)) then {_formation = "STAG COLUMN"};
	
	_EDPos = _GDV getVariable "RydHQ_EDPos";
	_posDis = [_posXWP3,_posYWP3];

	if not (isNil "_EDPos") then
		{
		_EDPos = +_EDPos;
		_GDV setVariable ["RydHQ_EDPos",nil];
		_posDis = _EDPos select 1
		};

	_wp3 = [_grp,_posDis,_tp,_beh,"GREEN","NORMAL",_sts,true,0,_TO,_formation] call RYD_WPadd;

	_DAV = assignedDriver _AV;
	_OtherGroup = false;
	_GDV = group _DAV;
	_enemy = false;
	_alive = true;

	if not (_IsAPlayer) then {
		if not (((group _DAV) == (group _UL)) or (isNull (group _DAV))) then 
			{
			_OtherGroup = true;

			_cause = [_GDV,6,true,400,30,[(_HQ getVariable ["RydHQ_AirG",[]]),(_HQ getVariable ["RydHQ_KnEnemiesG",[]])],true] call RYD_Wait;
			_timer = _cause select 0;
			_alive = _cause select 1;
			_enemy = _cause select 2;
			}
		else 
			{
			if not (_isAPlayer) then {_unitG setVariable ["InfGetinCheck" + (str _unitG),true]};
			_cause = [_unitG,6,true,400,30,[(_HQ getVariable ["RydHQ_AirG",[]]),(_HQ getVariable ["RydHQ_KnEnemiesG",[]])],false] call RYD_Wait;
			_timer = _cause select 0;
			_alive = _cause select 1;
			_enemy = _cause select 2;
			};
	};

	if (((_timer > 30) or (_enemy)) and (_OtherGroup)) then {if not (isNull _GDV) then {[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 1]}};
	if (((_timer > 30) or (_enemy)) and not (_OtherGroup)) then {[_unitG, (currentWaypoint _unitG)] setWaypointPosition [getPosATL (vehicle _UL), 1]};
	_GDV setVariable [("CargoM" + (str _GDV)), false];
	if (not (_alive) and not (_OtherGroup)) exitWith {_unitG setVariable [("Busy" + (str _unitG)),false];if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {{deleteMarker _x} forEach [_i1,_i2,_i3,_i4]}};
	if (({alive _x} count (units _unitG)) < 1) exitWith {_unitG setVariable [("Busy" + (str _unitG)),false];if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {{deleteMarker _x} forEach [_i1,_i2,_i3,_i4]};if not (isNull _GDV) then {[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 1];
	}};

	_UL = leader _unitG;if not (isPlayer _UL) then {if ((_timer <= 30) and not (_enemy)) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdFinal,"OrdFinal"] call RYD_AIChatter}}};

	_AV = assignedVehicle _UL;
	_pass = assignedCargo _AV;
	_allowed = true;
	if not ((_GDV == _unitG) or (isNull _GDV)) then 
		{
		{[[_x],false] remoteExecCall ["orderGetIn",0]} forEach _pass;
		_allowed = false;
		(units _unitG) allowGetIn false;
		[_unitG] call RYD_WPdel;
		//if (player in (units _unitG)) then {diag_log "NOT ALLOW flank"};
		}
	else
		{
		//if (_unitG in (_HQ getVariable ["RydHQ_NCrewInfG",[]])) then {_pass orderGetIn false};
		};

	_DAV = assignedDriver _AV;
	_GDV = group _DAV;

	if (not (isNull _AV) and ((_HQ getVariable ["RydHQ_CargoFind",0]) > 0) and (_unitG in (_HQ getVariable ["RydHQ_NCrewInfG",[]])) and not (_GDV == _unitG) and not (_IsAPlayer)) then
		{
		_pass = (units _unitG);	
		_cause = [_unitG,1,false,0,240,[],true,true,false,false,false,false,false,_pass,_AV] call RYD_Wait;
		_timer = _cause select 0
		};

	if not (_allowed) then {(units _unitG) allowGetIn true};

	if (_HQ getVariable ["RydHQ_LZ",false]) then {deleteVehicle _lz};

	if not ((_GDV == _unitG) or (isNull _GDV)) then 
		{
		{[[_x],false] remoteExecCall ["orderGetIn",0]} forEach (units _unitG);
		{[_x] remoteExecCall ["RYD_MP_unassignVehicle",0];} forEach (units _unitG);
		};
	
	if ((({alive _x} count (units _unitG)) < 1) or (_timer > 240)) exitWith {_unitG setVariable [("Busy" + (str _unitG)),false];if not (_Ctask isEqualTo taskNull) then {[_Ctask,"CANCELED",true] call BIS_fnc_taskSetState}; if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {{deleteMarker _x} forEach [_i1,_i2,_i3,_i4]};if not (isNull _GDV) then {[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 1];
	_GDV setVariable [("CargoM" + (str _GDV)), false];
	}};
	
	if not (_Ctask isEqualTo taskNull) then {[_Ctask,"SUCCEEDED",true] call BIS_fnc_taskSetState};

	_unitvar = str _GDV;
	_timer = 0;
	if (not (isNull _GDV) and (_GDV in (_HQ getVariable ["RydHQ_AirG",[]])) and not (isPlayer (leader _GDV)) and not (_IsAPlayer)) then
		{
		_wp = [_GDV,[((getPosATL _AV) select 0) + (random 200) - 100,((getPosATL _AV) select 1) + (random 200) - 100,1000],"MOVE","STEALTH","GREEN","NORMAL"] call RYD_WPadd;

		_cause = [_GDV,3,true,0,8,[],false] call RYD_Wait;
		_timer = _cause select 0;

		if (_timer > 8) then {[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 1]};
		};

	if not (_IsAPlayer) then {_GDV setVariable [("CargoM" + _unitvar), false]};

	if not (_task isEqualTo taskNull) then
		{
		
		[_task,(leader _unitG),["Engage the designated hostile forces. ROE: WEAPONS FREE.", "Engage Hostile Forces", ""],[_posXWP4,_posYWP4],"ASSIGNED",0,false,true] call BIS_fnc_SetTask;
		
		};

	[_unitG] call RYD_WPdel;

	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {_i3 setMarkerColor "ColorBlue"};

	_beh = "AWARE";
	_spd = "NORMAL";
	//if (not (_enemy) and (((vehicle (leader _unitG)) distance [_posXWP4,_posYWP4]) > 1000)) then {_spd = "LIMITED";_beh = "SAFE"};
	_formation = formation _unitG;
	if not (isPlayer (leader _unitG)) then {_formation = "WEDGE"};

	_wp4 = [_unitG,[_posXWP4,_posYWP4],"SAD",_beh,"RED",_spd,["true","deletewaypoint [(group this), 0];"],true,200,[0,0,0],_formation] call RYD_WPadd;

	_cause = [_unitG,6,true,0,30,[],false] call RYD_Wait;
	_timer = _cause select 0;
	_alive = _cause select 1;

	if not (_alive) exitWith 
		{
		if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
			{
				{
				deleteMarker _x
				}
			forEach [_i1,_i2,_i3,_i4]
			};
		_unitG setVariable [("Busy" + (str _unitG)),false];
		};

	if (_timer > 30) then {[_unitG, (currentWaypoint _unitG)] setWaypointPosition [getPosATL (vehicle _UL), 0]};

	if (not (_task isEqualTo taskNull) and (((leader _unitG) distance [_posXWP4,_posYWP4]) < 250)) then {[_task,"SUCCEEDED",true] call BIS_fnc_taskSetState};
	_HQ setVariable ["RydHQ_FlankAv",(_HQ getVariable ["RydHQ_FlankAv",[]]) - [_unitG]];
	_unitG setVariable [("Busy" + _unitvar), false];

	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {_i4 setMarkerColor "ColorBlue"};
	sleep 30;
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
		{
			{
			deleteMarker _x
			}
		forEach [_i1,_i2,_i3,_i4]
		};

	_UL = leader _unitG;if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdEnd,"OrdEnd"] call RYD_AIChatter}};
	};	

