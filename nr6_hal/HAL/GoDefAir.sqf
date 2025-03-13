_SCRname = "GoDefAir";

_i = "";

_unitG = _this select 0;
_Spot = _this select 1;
_HQ = _this select 2;

_unitvar = str _unitG;
_busy = false;
_busy = _unitG getVariable ("Busy" + _unitvar);

_startpos = getPosASL (leader _unitG);
if (isNil ("_StartPos")) then {_unitG setVariable [("START" + _unitvar),(position (vehicle (leader _unitG)))]};

if (isNil ("_busy")) then {_busy = false};

_alive = true;

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

[_unitG] call CBA_fnc_clearWaypoints;

_unitG setVariable [("Deployed" + (str _unitG)),false];
_unitG setVariable [("Capt" + (str _unitG)),false];
//_unitG setVariable [("Busy" + _unitvar), false];
_unitG setVariable ["Defending", true];

[_unitG,_Spot,"HQ_ord_defend",_HQ] call RYD_OrderPause;

if ((isPlayer (leader _unitG)) and (RydxHQ_GPauseActive)) then {hintC "New orders from HQ!";setAccTime 1};

_UL = leader _unitG;
_plane = vehicle _UL;

if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdConf,"OrdConf"] call RYD_AIChatter}};

_endThis = false;
_alive = true;


_DefPos = [((getPosATL _Spot) select 0) + (random 1000) - 500,((getPosATL _Spot) select 1) + (random 1000) - 500];
if (_HQ getVariable ["RydHQ_Debug",false]) then
	{
	_signum = _HQ getVariable ["RydHQ_CodeSign","X"];
	_i = [_DefPos,_unitG,"markDef","ColorBrown","ICON","waypoint","CAP " + (groupId _unitG) + " " + _signum," - DEFEND AREA",[0.5,0.5]] call RYD_Mark
	};

_task = [(leader _unitG),["Provide air coverage of the area.", "Close Air Patrol", ""],_DefPos,"plane"] call RYD_AddTask;

if not (isNull _Spot) then { _wp = [_unitG,_DefPos,"SAD","AWARE","YELLOW","NORMAL"] call RYD_WPadd};


_alive = true;
_endThis = false;
_timer = 0;


waitUntil
	{
	sleep 5;

	if (abs (speed (vehicle (leader _unitG))) < 0.05) then {_timer = _timer + 5};

	if ((isNull _unitG) or (isNull _HQ)) then {_endThis = true;_alive = false} else {if not (_unitG getVariable "Defending") then {_endThis = true}};
	if (({alive _x} count (units _unitG)) < 1) then {_endThis = true;_alive = false};
	if ((count (waypoints _unitG)) < 1) then {_endThis = true;};
	if (_unitG getVariable [("Busy" + _unitvar),false]) then {_endThis = true;};
	if (_unitG getVariable ["Break",false]) then {_endThis = true;_alive = false; _unitG setVariable ["Break",false];_unitG setVariable ["Defending", false];};

	if (_timer > 240) then {_endThis = true};

	(_endThis)
	};

if (_unitG getVariable [("Busy" + _unitvar),false]) exitWith
	{
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then
		{
		deleteMarker ("markDef" + _unitVar);
		};

	_AirInDef = _HQ getVariable ["RydHQ_AirInDef",[]];
	_AirInDef = _AirInDef - [_unitG];
	_HQ setVariable ["RydHQ_AirInDef",_AirInDef];
	_unitG setVariable ["Defending", false];
	};

if not (_task isEqualTo taskNull) then {[_task,"SUCCEEDED",true] call BIS_fnc_taskSetState};


if not (_alive) exitWith
	{
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then
		{
		deleteMarker ("markDef" + _unitVar);
		};

	_AirInDef = _HQ getVariable ["RydHQ_AirInDef",[]];
	_AirInDef = _AirInDef - [_unitG];
	_unitG setVariable ["Defending", false];
	_HQ setVariable ["RydHQ_AirInDef",_AirInDef]
	};

_task = [(leader _unitG),["Return to Base", "Return To Base", ""],_StartPos,"land"] call RYD_AddTask;

_rrr = (_unitG getVariable ["Ryd_RRR",false]);

_radd = "";
if (_rrr) then {_radd = "; {(vehicle _x) setFuel 1; (vehicle _x) setVehicleAmmo 1; (vehicle _x) setDamage 0;} foreach (units (group this))"};

_wp = [_unitG,_StartPos,"MOVE","SAFE","GREEN","NORMAL",["true", "if not ((group this) getVariable ['AirNoLand',false]) then {{(vehicle _x) land 'LAND'} foreach (units (group this))}; deletewaypoint [(group this), 0]" + _radd]] call RYD_WPadd;

_alive = true;
_endThis = false;
_timer = 0;

waitUntil
	{
	sleep 5;

	if (abs (speed (vehicle (leader _unitG))) < 0.05) then {_timer = _timer + 5};

	if ((isNull _unitG) or (isNull _HQ)) then {_endThis = true;_alive = false} else {if not (_unitG getVariable "Defending") then {_endThis = true}};
	if (({alive _x} count (units _unitG)) < 1) then {_endThis = true;_alive = false};
	if ((count (waypoints _unitG)) < 1) then {_endThis = true;};
	if (_unitG getVariable [("Busy" + _unitvar),false]) then {_endThis = true;};
	if (_unitG getVariable ["Break",false]) then {_endThis = true;_alive = false; _unitG setVariable ["Break",false];_unitG setVariable ["Defending", false];};

	if (_timer > 240) then {_endThis = true};

	(_endThis)
	};

if (_unitG getVariable [("Busy" + _unitvar),false]) exitWith
	{
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then
		{
		deleteMarker ("markDef" + _unitVar);
		};

	_AirInDef = _HQ getVariable ["RydHQ_AirInDef",[]];
	_AirInDef = _AirInDef - [_unitG];
	_HQ setVariable ["RydHQ_AirInDef",_AirInDef];
	_unitG setVariable ["Defending", false];
	};

if not (_alive) exitWith
	{
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then
		{
		deleteMarker ("markDef" + (str _unitG))
		};

	_AirInDef = _HQ getVariable ["RydHQ_AirInDef",[]];
	_AirInDef = _AirInDef - [_unitG];
	_unitG setVariable ["Defending", false];
	_HQ setVariable ["RydHQ_AirInDef",_AirInDef]
	};

//if not (_task isEqualTo taskNull) then {[_task,"SUCCEEDED",true] call BIS_fnc_taskSetState};

//sleep 30;

if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markDef" + (str _unitG))};

_AirInDef = _HQ getVariable ["RydHQ_AirInDef",[]];
_AirInDef = _AirInDef - [_unitG];
_HQ setVariable ["RydHQ_AirInDef",_AirInDef];

//_unitG setVariable [("Busy" + _unitvar), false];
_unitG setVariable ["Defending", false];

_UL = leader _unitG;if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdEnd,"OrdEnd"] call RYD_AIChatter}};
