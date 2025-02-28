_SCRname = "GoRepSupp";

_i = "";

_unit = _this select 0;
_Trg = _this select 1;
_damaged = _this select 2;
_HQ = _this select 3;
_request = false;
if ((count _this) > 4) then {_request = _this select 4};

_RepPoints = _HQ getVariable ["RydHQ_RepPoints",[]];

_RepPoints pushBack _Trg;

_unitG = group (assignedDriver _unit);
_unitvar = str (_unitG);
_startpos = getPosASL _unit;

if (isNil ("_startpos")) then {_unitG setVariable [("START" + _unitvar),(position _unit)]};

_rtr = _unit;

_rtr disableAI "TARGET";_rtr disableAI "AUTOTARGET";

[_unitG] call CBA_fnc_clearWaypoints;

(group (assignedDriver _unit)) setVariable [("Deployed" + (str (group (assignedDriver _unit)))),false,true];
_unitvar = str (_unitG);
_unitG setVariable [("Busy" + _unitvar), true];

_posX = ((position _Trg) select 0) + (random 100) - 50;
_posY = ((position _Trg) select 1) + (random 100) - 50;

_isWater = surfaceIsWater [_posX,_posY];

_cnt = 0;

while {((_isWater) and (_cnt <= 20))} do
	{
	_posX = _posX + (random 200) - 100;
	_posY = _posY + (random 200) - 100;
	_isWater = surfaceIsWater [_posX,_posY];
	_cnt = _cnt + 1;
	};

[_unitG,[_posX,_posY,0],"HQ_ord_repS",_HQ] call RYD_OrderPause;

_alive = false;

if ((isPlayer (leader _unitG)) and (RydxHQ_GPauseActive)) then {hintC "New orders from HQ!";setAccTime 1};

_UL = leader _unitG;

if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdConf,"OrdConf"] call RYD_AIChatter}};

if (_HQ getVariable ["RydHQ_Debug",false]) then
	{
	_signum = _HQ getVariable ["RydHQ_CodeSign","X"];
	_i = [[_posX,_posY],_unitG,"markRepSupp","ColorKhaki","ICON","waypoint","REPAIR " + (groupId _unitG) + " " + _signum," - REPAIR SUPPORT",[0.5,0.5],180] call RYD_Mark
	};

_task = [(leader _unitG),["Perform field repairs for " + (groupId (group _Trg)), "Repair " + (groupId (group _Trg)), ""],(position _Trg),"repair"] call RYD_AddTask;

_counter = 0;
_timer = 0;

if (_request) then {

	[_rtr,"Repair"] remoteExecCall ["RYD_ReqLogistics_Actions"];

	_rtr setVariable ["HAL_Requested",true,true];

};

while {(_counter <= 3)} do
	{
	[_unitG] call CBA_fnc_clearWaypoints;

	if not (_counter == 0) then
		{
		_posX = ((position _unit) select 0) + (random 100) -  50;
		_posY = ((position _unit) select 1) + (random 100) -  50;

		_isWater = surfaceIsWater [_posX,_posY];

		_cnt = 0;

		while {((_isWater) and (_cnt <= 20))} do
			{
			_posX = _posX + (random 200) -  100;
			_posY = _posY + (random 200) -  100;
			_isWater = surfaceIsWater [_posX,_posY];
			_cnt = _cnt + 1;
			};

		if not (_task isEqualTo taskNull) then
			{

			[_task,(leader _unitG),["Conduct repairs on damaged friendly vehicles.", "Conduct Repairs", ""],[_posX,_posY],"ASSIGNED",0,false,true] call BIS_fnc_SetTask;

			}
		};

	_pos = [_posX,_posY];
	if (_counter == 0) then {_pos = _Trg};
	_tp = "MOVE";
	if (_HQ getVariable ["RydHQ_SupportWP",false]) then {_tp = "SUPPORT"};

	_wp = [_unitG,_pos,_tp,"SAFE","BLUE","FULL",["true","(vehicle this) land 'GET IN';deletewaypoint [(group this), 0]"]] call RYD_WPadd;
	if (_counter == 0) then {_wp waypointAttachVehicle _Trg};

	_cause = [_unitG,6,true,0,24,[],true,true,true,true] call RYD_Wait;
	_timer = _cause select 0;
	_alive = _cause select 1;

	if (((_rtr distance _Trg) < 50) and not (canMove _Trg)) then {_Trg setDamage ((damage _Trg) - 0.1)};
	if not (_alive) exitWith
		{
		if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then
			{
			deleteMarker ("markRepSupp" + str (_unitG))
			};

		_RepPoints = _RepPoints - [_Trg];
		_HQ setVariable ["RydHQ_RepPoints",_RepPoints];
		_unitG setVariable [("Busy" + _unitvar), false];
		_rtr setVariable ["HAL_Requested",false,true];
		};

	if (_timer > 24) then {_counter = _counter + 1;[_unitG, (currentWaypoint _unitG)] setWaypointPosition [position (vehicle (leader _unitG)), 0];} else {_counter = _counter + 1};

	if ((RydxHQ_MagicRepair) and (_timer <= 24)) then { {if (((side _x) getFriend (side _unitG)) >= 0.6) then {_x setDamage 0; if (isPlayer _x) then {"Vehicle Repaired" remoteExec ["hint", _x]};}} forEach ((vehicle (leader _unitG)) nearEntities [["Air", "LandVehicle"], 100]);};

//	if ((_request) and ((_rtr getVariable ["HAL_Requested",false]) or ((_rtr distance _Trg) > 500))) then {_counter = 5};

	if ((_request) and (_rtr getVariable ["HAL_Requested",false]) and ((_rtr distance _Trg) < 500)) then {_counter = 0};

	if ((_request) and not (_rtr getVariable ["HAL_Requested",false])) then {_counter = 5};

	_UL = leader _unitG;if not (isPlayer _UL) then {if ((_timer <= 24) and (_counter == 1)) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdFinal,"OrdFinal"] call RYD_AIChatter}}};

	if (((damage _Trg) < 0.1) or ((damage _Trg) >= 0.9) or (isNull (group (assignedDriver (_this select 1))))) then {_damaged = _damaged - [_Trg]};
	};

if (_request) then {[_rtr] remoteExecCall ["RYD_ReqLogisticsDelete_Actions"]};
_rtr setVariable ["HAL_Requested",false,true];

if not (_alive) exitWith
	{
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then
		{
		deleteMarker ("markRepSupp" + str (_unitG))
		};

	_RepPoints = _RepPoints - [_Trg];
	_HQ setVariable ["RydHQ_RepPoints",_RepPoints];
	_unitG setVariable [("Busy" + _unitvar), false];
	};

[_unitG, (currentWaypoint _unitG)] setWaypointPosition [position (vehicle (leader _unitG)), 0];

_tp = "MOVE";
if (_HQ getVariable ["RydHQ_SupportWP",false]) then {_tp = "SUPPORT"};

_pos = [_posX,_posY];

if (_HQ getVariable ["RydHQ_SupportRTB",false]) then {_pos = _startpos; if not (isNull (_HQ getVariable ["RydHQ_SupportDecoy",objNull])) then {if ((random 100) <= (_HQ getVariable ["RydHQ_SDChance",100])) then {_pos = (getPos (_HQ getVariable ["RydHQ_SupportDecoy",objNull]))}}; _RepPoints = _RepPoints - [_Trg]; if not (_task isEqualTo taskNull) then {[_task,(leader _unitG),["Return to base.", "Return To Base", ""],_pos,"ASSIGNED",0,false,true] call BIS_fnc_SetTask;}};

_rrr = (_unitG getVariable ["Ryd_RRR",false]);

_radd = "";
if (_rrr) then {_radd = "; {(vehicle _x) setFuel 1; (vehicle _x) setVehicleAmmo 1; (vehicle _x) setDamage 0;} foreach (units (group this))"};

_wp = [_unitG,_pos,_tp,"SAFE","BLUE","FULL",["true","{(vehicle _x) land 'LAND'} foreach (units (group this));deletewaypoint [(group this), 0]" + _radd]] call RYD_WPadd;

_timer = 0;
_alive = true;

if not (_HQ getVariable ["RydHQ_SupportRTB",false]) then {
	_cause = [_unitG,6,true,0,24,[],true,true,true,true] call RYD_Wait;
	_timer = _cause select 0;
	_alive = _cause select 1;
};

if (((_rtr distance _Trg) < 50) and not (canMove _Trg)) then {_Trg setDamage ((damage _Trg) - 0.1)};

if not (_alive) exitWith
	{
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then
		{
		deleteMarker ("markRepSupp" + str (_unitG))
		};

	_RepPoints = _RepPoints - [_Trg];
	_HQ setVariable ["RydHQ_RepPoints",_RepPoints];
	_unitG setVariable [("Busy" + _unitvar), false];
	};

if (_timer > 24) then {[_unitG, (currentWaypoint _unitG)] setWaypointPosition [position (vehicle _UL), 0]};

_RepPoints = _RepPoints - [_Trg];
_HQ setVariable ["RydHQ_RepPoints",_RepPoints];
if not (_HQ getVariable ["RydHQ_SupportRTB",false]) then {if not (_task isEqualTo taskNull) then {[_task,"SUCCEEDED",true] call BIS_fnc_taskSetState}};

_rtr enableAI "TARGET";_rtr enableAI "AUTOTARGET";
_unitG setVariable [("Busy" + _unitvar), false];

if (((damage _Trg) < 0.1) or ((damage _Trg) >= 0.9) or (isNull (group (assignedDriver (_this select 1))))) then {_damaged = _damaged - [_Trg]};
if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markRepSupp" + str (_unitG))};
_lastOne = true;

	{
	if (((group (assignedDriver _x)) == (group (assignedDriver _Trg))) and not (_x == _Trg)) exitWith {_lastOne = false};
	}
forEach _damaged;

if (_lastOne) then
	{
	_rSupp = _HQ getVariable ["RydHQ_RSupportedG",[]];
	_rSupp = _rSupp - [(group _Trg)];
	_HQ setVariable ["RydHQ_RSupportedG",_rSupp]
	};

_UL = leader _unitG;if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdEnd,"OrdEnd"] call RYD_AIChatter}};
