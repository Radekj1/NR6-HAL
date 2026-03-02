_SCRname = "GoDefRecon";

_i = "";
params ["_unitG","_DefPos","_angleV","_HQ"];

_Spos = _unitG getvariable ("START" + (str _unitG));if (isNil ("_Spos")) then {_unitG setVariable [("START" + (str _unitG)),(getPosATL (vehicle (leader _unitG)))];_Spos = _unitG getVariable ("START" + (str _unitG))}; 

_unitvar = str _unitG;
_busy = false;
_busy = _unitG getvariable ("Busy" + _unitvar);
_isAPlayer = false;

if (isNil ("_busy")) then {_busy = false};

_alive = true;

if (_busy) exitwith {_defSpot = _HQ getVariable ["RydHQ_DefSpot",[]];
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

_attackAllowed = attackEnabled _unitG;
_unitG enableAttack false; 

_unitG setVariable [("Deployed" + (str _unitG)),false];_unitG setVariable [("Capt" + (str _unitG)),false];
_unitG setVariable [("Busy" + _unitvar), true];
_unitG setVariable ["Defending", true];


_UL = leader _unitG;
_AV = assignedVehicle _UL;
_DAV = assigneddriver _AV;
_GDV = group _DAV;

if not (isNull _AV) then { 

	{
		if (isNull (assignedVehicle _x)) then {_x assignAsCargo _AV};
	} forEach (units _unitG);
};

_posX = (_DefPos select 0) + (random 40) - 20;
_posY = (_DefPos select 1) + (random 40) - 20;
_DefPos = [_posX,_posY];

_isWater = surfaceIsWater _DefPos;

while {((_isWater) and ((leader _HQ) distance _DefPos >= 10))} do
	{
	_PosX = ((_DefPos select 0) + ((getPosATL (leader _HQ)) select 0))/2; 
	_PosY = ((_DefPos select 1) + ((getPosATL (leader _HQ)) select 1))/2;
	_DefPos = [_posX,_posY]
	};

_isWater = surfaceIsWater _DefPos;

if (_isWater) then {_DefPos = getPosATL (vehicle (leader _unitG))};

[_unitG,[_posX,_posY,0],"HQ_ord_defend",_HQ] call RYD_OrderPause;

if ((isPlayer (leader _unitG)) and (RydxHQ_GPauseActive)) then {hintC "New orders from HQ!";setAccTime 1};

_UL = leader _unitG;

_nE = _UL findnearestenemy _UL;

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
			if ((vehicle _UL) == _UL) then {sleep 25}
			}
		}
	};

_UL = leader _unitG;
 
if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdConf,"OrdConf"] call RYD_AIChatter}};

if (_HQ getVariable ["RydHQ_Debug",false]) then 
	{
	_signum = _HQ getVariable ["RydHQ_CodeSign","X"];
	_i = [_DefPos,_unitG,"markDef","ColorBrown","ICON","waypoint","REC " + (groupId _unitG) + " " + _signum," - WATCH FOREGROUND",[0.5,0.5]] call RYD_Mark;
	};
	
_AV = assignedVehicle _UL;

if not (isNull _AV) then { 

	{
		if (isNull (assignedVehicle _x)) then {_x assignAsCargo _AV};
	} forEach (units _unitG);
};

private _AddTask = createGroup sideLogic;
_AddTask setVariable ["_continueAfterTask",false];

[_AddTask,(leader _unitG),["Take a defensive position and search for hostile targets.", "Scout The Area", ""],_DefPos,"scout"] call RYD_AddTask;

waitUntil {_AddTask getVariable ["_continueAfterTask",false];}; 
diag_log text "RYD_AddTask code finished, waituntil passed";
_AddTask setVariable ["_continueAfterTask",false];
_task = _AddTask getVariable "_task";
deleteGroup _AddTask;

_frm = formation _unitG;
if not (isPlayer (leader _unitG)) then {_frm = "FILE"};_tp = "MOVE";

_wp = [_unitG,_DefPos,_tp,"AWARE","GREEN","FULL",["true","deletewaypoint [(group this), 0];"],true,0.001,[0,0,0],_frm] call RYD_WPadd;

if not (_isAPlayer) then {_unitG setVariable ["InfGetinCheck" + (str _unitG),true]};
private _WaitCarrier = createGroup sideLogic;

_WaitCarrier setVariable ["_continueAW",false];
[_WaitCarrier,_unitG,6,true,0,24,[],false] call RYD_Wait;
waitUntil {_WaitCarrier getVariable ["_continueAW",false];}; diag_log text "RYD_Wait code finished, waituntil passed";
_WaitCarrier setVariable ["_continueAW",false];
_timer = _WaitCarrier getVariable "_timer";
deleteGroup _WaitCarrier;
if not (_alive) exitwith 
	{
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
		{
		deleteMarker ("markDef" + str (_unitG))
		};
		
	_RecDefSpot = _HQ getVariable ["RydHQ_RecDefSpot",[]];
	_RecDefSpot = _RecDefSpot - [_unitG];
	_unitG setVariable [("Busy" + (str _unitG)),false];
	_unitG setVariable ["Defending", false];
	_HQ setVariable ["RydHQ_RecDefSpot",_RecDefSpot]
	};
/*
if ((_unitG in ((_HQ getVariable ["RydHQ_CargoG",[]]) - ((_HQ getVariable ["RydHQ_HArmorG",[]]) + (_HQ getVariable ["RydHQ_LArmorG",[]]) + (_HQ getVariable ["RydHQ_SupportG",[]]) + ((_HQ getVariable ["RydHQ_CarsG",[]]) - (_HQ getVariable ["RydHQ_NCCargoG",[]]))))) or (not (isNull _AV) and not (_unitG == (group (assigneddriver _AV))))) then 
	{
	(units _unitG) allowGetIn false;
	(units _unitG) orderGetIn false
	};
*/
_frm = formation _unitG;
if not (isPlayer (leader _unitG)) then {_frm = "WEDGE"};

_wp = [_unitG,_DefPos,"SENTRY","STEALTH","YELLOW","FULL",["true","deletewaypoint [(group this), 0];"],true,0.001,[0,0,0],_frm] call RYD_WPadd;

_TED = getPosATL (leader _HQ);

_dX = 2000 * (sin _angleV);
_dY = 2000 * (cos _angleV);

_posX = ((getPosATL (leader _HQ)) select 0) + _dX + (random 2000) - 1000;
_posY = ((getPosATL (leader _HQ)) select 1) + _dY + (random 2000) - 1000;

_TED = [_posX,_posY];

if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
	{
	_signum = _HQ getVariable ["RydHQ_CodeSign","X"];
	_i = [_TED,_unitG,"markWatch","Default","ICON","waypoint", (groupId _unitG) + _signum,_signum,[0.2,0.2]] call RYD_Mark
	};

_dir = [(getPosATL (vehicle (leader _unitG))),_TED,10] call RYD_AngTowards;
if (_dir < 0) then {_dir = _dir + 360};

_unitG setFormDir _dir;
(units _unitG) doWatch _TED;

_UL = leader _unitG;if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdFinal,"OrdFinal"] call RYD_AIChatter}};

[_unitG,(_HQ getVariable ["RydHQ_Flare",true]),(_HQ getVariable ["RydHQ_ArtG",[]]),(_HQ getVariable ["RydHQ_ArtyShells",1]),(leader _HQ)] call RYD_Flares;

_alive = true;
/*
waituntil 
	{
	sleep 10;
	_endThis = false;
	
	switch (true) do
		{
		case not (_unitG getVariable "Defending") : {_endThis = true};
		case (isNull _unitG) : {_endThis = true;_alive = false};
		case (({alive _x} count (units _unitG)) < 1) : {_endThis = true;_alive = false};
		};	
	
	(_endThis)
	};
*/
if not (_alive) exitWith 
	{
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markDef" + _unitVar);deleteMarker ("markWatch" + _unitVar)};
	_RecDefSpot = _HQ getVariable ["RydHQ_RecDefSpot",[]];
	_RecDefSpot = _RecDefSpot - [_unitG];
	_unitG setVariable [("Busy" + (str _unitG)),false];
	_unitG setVariable ["Defending", false];
	_HQ setVariable ["RydHQ_RecDefSpot",_RecDefSpot]
	};

//if not (_task isEqualTo taskNull) then {[_task,"SUCCEEDED",true] call BIS_fnc_taskSetState};

if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markDef" + (str _unitG));deleteMarker ("markWatch" + (str _unitG))};

(units _unitG) doWatch ObjNull;
//(units _unitG) allowGetIn true;
//(units _unitG) orderGetIn true;
if (_attackAllowed) then {_unitG enableAttack true};

_RecDefSpot = _HQ getVariable ["RydHQ_RecDefSpot",[]];
_RecDefSpot = _RecDefSpot - [_unitG];
_HQ setVariable ["RydHQ_RecDefSpot",_RecDefSpot];

_unitG setVariable [("Busy" + _unitvar), false];
_unitG setVariable ["Defending", false];


_UL = leader _unitG;if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdEnd,"OrdEnd"] call RYD_AIChatter}};
