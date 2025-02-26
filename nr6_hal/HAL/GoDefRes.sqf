_SCRname = "GoDefRes";

_i = "";

_unitG = _this select 0;_Spos = _unitG getVariable ("START" + (str _unitG));if (isNil ("_Spos")) then {_unitG setVariable [("START" + (str _unitG)),(getPosATL (vehicle (leader _unitG)))];_Spos = _unitG getVariable ("START" + (str _unitG))}; 
_Spot = _this select 1;
_HQ = _this select 2;

_unitvar = str _unitG;
_busy = false;
_busy = _unitG getVariable ("Busy" + _unitvar);
if (isNil ("_busy")) then {_busy = false};
_isAPlayer = false;

_alive = true;

if ((_busy) or (_unitG in (_HQ getVariable ["RydHQ_SupportG",[]]))) exitWith {_defSpot = _HQ getVariable ["RydHQ_DefSpot",[]];
	_defSpot = _defSpot - [_unitG];
	_HQ setVariable ["RydHQ_DefSpot",_defSpot];
	_def = _HQ getVariable ["RydHQ_Def",[]];
	_def = _def - [_unitG];
	_HQ setVariable ["RydHQ_Def",_def];};

/*
if (_busy) then 
	{
	_unitG setVariable ["RydHQ_MIA",true];
	_ct = time;
	
	waitUntil
		{
		sleep 0.1;
		
		switch (true) do
			{
			case (isNull (_unitG)) : {_alive = false};
			case (({alive _x} count (units _unitG)) < 1) : {_alive = false};
			case ((time - _ct) > 300) : {_alive = false};
			};
			
		_MIApass = false;
		if (_alive) then
			{
			_MIAPass = not (_unitG getVariable ["RydHQ_MIA",false]);
			};
			
		(not (_alive) or (_MIApass))	
		}
	};
*/

[_unitG] call RYD_WPdel;


_unitG setVariable [("Deployed" + (str _unitG)),false];
_unitG setVariable [("Capt" + (str _unitG)),false];
//_unitG setVariable [("Busy" + _unitvar), false];
_unitG setVariable ["Defending", true];

_UL = leader _unitG;
_AV = assignedVehicle _UL;
_DAV = assignedDriver _AV;
_GDV = group _DAV;

if not (isNull _AV) then { 

	{
		if (isNull (assignedVehicle _x)) then {_x assignAsCargo _AV};
	} forEach (units _unitG);
};

_DefPos = [((getPosATL _Spot) select 0) + (random 1000) - 500,((getPosATL _Spot) select 1) + (random 1000) - 500];

_posX = (_DefPos select 0);
_posY = (_DefPos select 1);
_DefPos = [_posX,_posY];

_isWater = surfaceIsWater _DefPos;

while {((_isWater) and ((leader _HQ) distance _DefPos >= 10))} do
	{
	_PosX = ((_DefPos select 0) + ((getPosATL (leader _HQ)) select 0))/2; 
	_PosY = ((_DefPos select 1) + ((getPosATL (leader _HQ)) select 1))/2;
	_DefPos = [_posX,_posY]
	};

if ((_unitG in (_HQ getVariable ["RydHQ_NCCargoG",[]])) and ((count (units _unitG)) <= 1)) then 
	{
	_PosX = ((getPosATL (leader _HQ)) select 0) + (random 200) - 100;
	_PosY = ((getPosATL (leader _HQ)) select 1) + (random 200) - 100;
	_DefPos = [_posX,_posY]
	};

_isWater = surfaceIsWater _DefPos;

if (_isWater) then {_DefPos = getPosATL (vehicle (leader _unitG))};

[_unitG,[_posX,_posY,0],"HQ_ord_defendR",_HQ] call RYD_OrderPause;

if ((isPlayer (leader _unitG)) and (RydxHQ_GPauseActive)) then {hintC "New orders from HQ!";setAccTime 1};

_UL = leader _unitG;

_nE = _UL findNearestEnemy _UL;

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
			//[_unitG,_nE] spawn RYD_Smoke;
			[[_unitG,_nE],RYD_Smoke] call RYD_Spawn;
			sleep 10;
			if ((vehicle _UL) == _UL) then {sleep 25}
			}
		}
	};

_UL = leader _unitG;
 
if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdConf,"OrdConf"] call RYD_AIChatter}};

if (_HQ getVariable ["RydHQ_Debug",false]) then 
	{
	_signum = _HQ getVariable ["RydHQ_CodeSign","X"];
	_i = [_DefPos,_unitG,"markDef","ColorWhite","ICON","waypoint","DEFR " + (groupId _unitG) + " " + _signum," - DEFEND POSITION",[0.5,0.5]] call RYD_Mark
	};

_AV = assignedVehicle _UL;

if not (isNull _AV) then { 

	{
		if (isNull (assignedVehicle _x)) then {_x assignAsCargo _AV};
	} forEach (units _unitG);
};

_task = [(leader _unitG),["Patrol towards the designated area and standby for further orders. ", "Patrol Area And Standby", ""],_DefPos,"defend"] call RYD_AddTask;

_tp = "MOVE";

_frm = formation _unitG;
if not (isPlayer (leader _unitG)) then {_frm = "FILE"};


//if not ((_HQ getVariable ["RydHQ_Order","ATTACK"]) == "DEFEND") then {_unitG setVariable [("Busy" + _unitvar), false];};

_wp = [_unitG,_DefPos,"SENTRY","SAFE","YELLOW","NORMAL",["true","deletewaypoint [(group this), 0];"],true,0,[0,0,0],_frm] call RYD_WPadd;

/*

_TED = getPosATL (leader _HQ);

_dX = 2000 * (sin (_HQ getVariable ["RydHQ_Angle",0]));
_dY = 2000 * (cos (_HQ getVariable ["RydHQ_Angle",0]));

_posX = ((getPosATL (leader _HQ)) select 0) + _dX + (random 2000) - 1000;
_posY = ((getPosATL (leader _HQ)) select 1) + _dY + (random 2000) - 1000;

_TED = [_posX,_posY];

if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
	{
	_signum = _HQ getVariable ["RydHQ_CodeSign","X"];
	_i = [_TED,_unitG,"markWatch","Default","ICON","waypoint", (groupId _unitG) + " " + _signum,_signum,[0.2,0.2]] call RYD_Mark
	};

_dir = [(getPosATL (vehicle (leader _unitG))),_TED,10] call RYD_AngTowards;
if (_dir < 0) then {_dir = _dir + 360};

_unitG setFormDir _dir;

(units _unitG) doWatch _TED;

*/


//[_unitG,(_HQ getVariable ["RydHQ_Flare",true]),(_HQ getVariable ["RydHQ_ArtG",[]]),(_HQ getVariable ["RydHQ_ArtyShells",1]),(leader _HQ)] spawn RYD_Flares;
//[[_unitG,(_HQ getVariable ["RydHQ_Flare",true]),(_HQ getVariable ["RydHQ_ArtG",[]]),(_HQ getVariable ["RydHQ_ArtyShells",1]),(leader _HQ)],RYD_Flares] call RYD_Spawn;

_alive = true;
_endThis = false;
_suppHQ = false;
_timer = 0;

_AV = assignedVehicle _UL;
_DAV = assignedDriver _AV;
_GDV = group _DAV;

waitUntil
	{
	sleep 5;

//	if not ((_HQ getVariable ["RydHQ_Order","ATTACK"]) == "DEFEND") then {_unitG setVariable [("Busy" + _unitvar), false];} else {_unitG setVariable [("Busy" + _unitvar), true];};
	
	if (abs (speed (vehicle (leader _unitG))) < 0.05) then {_timer = _timer + 5};

	if ((isNull _unitG) or (isNull _HQ)) then {_endThis = true;_alive = false} else {if not (_unitG getVariable "Defending") then {_endThis = true}};
	if (({alive _x} count (units _unitG)) < 1) then {_endThis = true;_alive = false};
	if ((count (waypoints _unitG)) < 1) then {_endThis = true;};
	if (_unitG getVariable [("Busy" + _unitvar),false]) then {_endThis = true;};
	if (_unitG getVariable ["Break",false]) then {_endThis = true;_alive = false; _unitG setVariable ["Break",false];_unitG setVariable ["Defending", false];};

	if ((_GDV == _unitG) and not (_endThis) and not (isNull _AV) and not (isNull ((vehicle (leader _unitG)) findNearestEnemy (vehicle (leader _unitG))))) then 
		{
//		_AV setUnloadInCombat [true, false];
		_dw = false;
		{
			// Workaround for braindead BIS AI when using mech or mot infantry...
			if (not ((_x == (assignedCommander _AV)) or (_x == (assignedDriver _AV)) or (_x == (assignedGunner _AV))) and not ((vehicle _x) == _AV)) then { if (_x == (leader _unitG)) then {_x assignAsCommander _AV};_x assignAsCargo _AV;};
			if (((assignedVehicle _x) == _AV) and (_x == (vehicle _x))) then {[_x] orderGetIn true; doStop _AV; _dw = true;};
		} forEach (units _unitG);
//		if (not (_dw)) then {_AV setVariable ["WaitForCargo" + (str _AV),false];};
		if ((abs (speed (_AV)) < 0.05) and not (_dw) and not ((count (waypoints _unitG)) < 1) and ((time - (_AV getVariable ["LastMoveOR",0])) > 10) ) then {_AV doMove [((position _AV) select 0) +5,((position _AV) select 1) +5,(position _AV) select 2]; _AV setVariable ["LastMoveOR",time];}
	};

	if (((vehicle (leader _unitG)) distance _DefPos) < 50) then {_endThis = true;};
	if (_timer > 240) then {_endThis = true};

	(_endThis)
	};

if not (_alive) exitWith 
	{
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
		{
		deleteMarker ("markDef" + _unitVar);
		};

	_def = _HQ getVariable ["RydHQ_Def",[]];
	_def = _def - [_unitG];
	_HQ setVariable ["RydHQ_Def",_def];
	_unitG setVariable ["Defending", false];
	};

//if not (_task isEqualTo taskNull) then {[_task,"SUCCEEDED",true] call BIS_fnc_taskSetState};

if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markDef" + (str _unitG));};

//(units _unitG) doWatch ObjNull;
//(units _unitG) allowGetIn true;
//(units _unitG) orderGetIn true;
_def = _HQ getVariable ["RydHQ_Def",[]];
_def = _def - [_unitG];
_HQ setVariable ["RydHQ_Def",_def];
_unitG setVariable ["Defending", false];

//_UL = leader _unitG;if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdEnd,"OrdEnd"] call RYD_AIChatter}};