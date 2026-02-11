_SCRname = "GoAttAirCAP";

_i = "";
params ["_unitG","_Trg","_HQ"];

_request = false;
if ((count _this) > 3) then {_request = _this select 3};

_PosObj1 = getPosATL _Trg;
_unitvar = str (_unitG);

_UL = leader _unitG;
_PosLand = _unitG getvariable ("START" + _unitvar); 
if (isNil ("_PosLand")) then {_unitG setVariable [("START" + _unitvar),(position (vehicle _UL))];_PosLand = _unitG getvariable ("START" + _unitvar);};

[_unitG] call RYD_WPdel;

_unitG setVariable [("Deployed" + (str _unitG)),false];_unitG setVariable [("Capt" + (str _unitG)),false];

_flight = [];

{if ((vehicle _x) isKindOf "Air") then {_flight pushBackUnique (vehicle _x)}} foreach (units _unitG);

{_x setVariable ["SortiePylons",(count (getPylonMagazines _x))]} foreach _flight;

if ((_flight isEqualTo []) and ((isNull (assignedVehicle (leader _unitG))) or not (alive (assignedVehicle (leader _unitG))))) exitwith {

	_attAv = _HQ getVariable ["RydHQ_AttackAv",[]];
	_attAv pushBack _unitG;
	_HQ setVariable ["RydHQ_AttackAv",_attAv];

	_unitG setVariable [("Busy" + (str _unitG)),false];

	_HQ setVariable ["RydHQ_Exhausted",(_HQ getVariable ["RydHQ_Exhausted",[]]) + [_unitG]];
	[_unitG,_HQ] call HAL_GoRest;

};

_nothing = true;
_PosObj1 params ["_dXPosObj1","_dYPosObj1"];
_dX = _dXPosObj1 - ((getPosATL (leader _HQ)) select 0);
_dY = _dYPosObj1 - ((getPosATL (leader _HQ)) select 1);

_angle = _dX atan2 _dY;

_distance = (leader _HQ) distance _PosObj1;
_distance2 = 0;

_dXc = _distance2 * (cos _angle);
_dYc = _distance2 * (sin _angle);

_dXb = _distance * (sin _angle);
_dYb = _distance * (cos _angle);

_posX = ((getPosATL (leader _HQ)) select 0) + _dXb;
_posY = ((getPosATL (leader _HQ)) select 1) + _dYb;

if (_request) then {
	_posX = (_PosObj1 select 0) + (random 300) - 150;
	_posY = (_PosObj1 select 1) + (random 300) - 150;
};

[_unitG,[_posX,_posY,0],"HQ_ord_attackAirCAP",_HQ] call RYD_OrderPause;

if ((isPlayer (leader _unitG)) and (RydxHQ_GPauseActive)) then {hintC "New orders from HQ!";setAccTime 1};

_UL = leader _unitG;
 
if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdConf,"OrdConf"] call RYD_AIChatter}};

if (_HQ getVariable ["RydHQ_Debug",false]) then 
	{
	_signum = _HQ getVariable ["RydHQ_CodeSign","X"];
	_i = [[_posX,_posY],_unitG,"markAttack","ColorRed","ICON","waypoint","CAP " + (groupId _unitG) + " " + _signum," - CAS",[0.5,0.5]] call RYD_Mark
	};

_task = [(leader _unitG),["Perform combat air patrol and intercept any hostile airborne assets.", "Perform Combat Air Patrol", ""],[_posX,_posY],"plane"] call RYD_AddTask;

_wp = [_unitG,[_posX,_posY],"SAD","COMBAT","RED","NORMAL",["true", "deletewaypoint [(group this), 0]"],true,0,[0,0,0],"COLUMN"] call RYD_WPadd;

_lasT = ObjNull;


if not (_request) then {_unitG setVariable ["RydHQ_WaitingTarget",_trg]};
_cause = [_unitG,6,true,0,120,[],false] call RYD_Wait;
_cause params ["_timer","_alive"];


if not (_alive) exitwith 
	{
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markAttack" + str (_unitG))};
	if not (isNull _lasT) then {deleteVehicle _lasT};
	_unitG setVariable [("Busy" + (str _unitG)),false];
	if not (_request) then {[_Trg,"AirAttacked"] call RYD_VarReductor}
	};

if (_timer > 120) then {deleteWaypoint _wp};

if not (_task isEqualTo taskNull) then
	{
	
	[_task,(leader _unitG),["Return to base.", "Return To Base", ""],_Posland,"ASSIGNED",0,false,true] call BIS_fnc_SetTask;
	
	};

if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {_i setMarkerColor "ColorBlue"};
if (_unitG in (_HQ getVariable ["RydHQ_BAirG",[]])) then {deleteVehicle _lasT};

_rrr = (_unitG getVariable ["Ryd_RRR",false]);

_radd = "";
if (_rrr) then {_radd = "; {(vehicle _x) setFuel 1; (vehicle _x) setVehicleAmmo 1; (vehicle _x) setDamage 0;} foreach (units (group _this))"};

_wp = [_unitG,_Posland,"MOVE","SAFE","GREEN","NORMAL",["true", "if not ((group this) getVariable ['AirNoLand',false]) then {{(vehicle _x) land 'LAND'} foreach (units (group this))}; deletewaypoint [(group this), 0]" + _radd],true,0,[0,0,0],"COLUMN"] call RYD_WPadd;

_mustRTB = false;

{
	if ((((_x getVariable ["SortiePylons",0])/2) > (count (getPylonMagazines _x))) or ((damage _x) > 0.5) or ((fuel _x) < 0.3)) then {_mustRTB = true;};

} foreach _flight;


if not (_mustRTB) then {
	_cause = [_unitG,6,true,0,24,[],false] call RYD_Wait;
	_cause params ["_timer","_alive"];

	if not (_alive) exitwith 
		{
		if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markAttack" + str (_unitG))};
		_unitG setVariable [("Busy" + (str _unitG)),false];
		if not (_request) then {[_Trg,"AirAttacked"] call RYD_VarReductor}
		};
	if (_timer > 24) then {deleteWaypoint _wp};
};

if (not (_task isEqualTo taskNull) and not (alive _Trg)) then {[_task,"SUCCEEDED",true] call BIS_fnc_taskSetState};

if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markAttack" + str (_unitG))};

_attAv = _HQ getVariable ["RydHQ_AttackAv",[]];
_attAv pushBack _unitG;
_HQ setVariable ["RydHQ_AttackAv",_attAv];
 
_unitG setVariable [("Busy" + (str _unitG)),false];

if not (_request) then {[_Trg,"AirAttacked"] call RYD_VarReductor};


_UL = leader _unitG;if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdEnd,"OrdEnd"] call RYD_AIChatter}};
