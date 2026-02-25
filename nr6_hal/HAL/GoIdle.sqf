_SCRname = "GoIdle";

_unitG = _this select 0;_Spos = _unitG getvariable ("START" + (str _unitG));if (isNil ("_Spos")) then {_unitG setVariable [("START" + (str _unitG)),(getPosATL (vehicle (leader _unitG)))];_Spos = _unitG getVariable ("START" + (str _unitG))}; 
_pos = getPosATL (leader _unitG);
_LU = leader _unitG;
_VLU = vehicle _LU;
_HQ = _this select 1;

if (_unitG in (_HQ getVariable ["RydHQ_Garrison",[]])) exitwith {};

_AAO = _HQ getVariable ["RydHQ_ChosenAAO",false];

_unitG setVariable [("Deployed" + (str _unitG)),true];

_obj = getPosATL (_HQ getVariable ["RydHQ_Obj",(leader _HQ)]);

if (_AAO) then
	{
	_obj = _HQ getVariable ["RydHQ_EyeOfBattle",getPosATL (vehicle (leader _HQ))]
	};

//_Xpos = ((((getPosATL (leader _HQ)) select 0) + (_obj select 0))/2) + (random 100) - 50;
//_Ypos = ((((getPosATL (leader _HQ)) select 1) + (_obj select 1))/2) + (random 100) - 50;

_Xpos = ((getPosATL (leader _unitG)) select 0);
_Ypos = ((getPosATL (leader _unitG)) select 1);

_posX = _Xpos;
_posY = _Ypos;

_isDecoy = false;
_enemyMatters = true;
_roadG = false;
_patrol = false;

if (not (isNull (_HQ getVariable ["RydHQ_IdleDecoy",objNull])) and not (_unitG in (_HQ getVariable ["RydHQ_SupportG",[]]))) then
	{
	_isDecoy = true;

	//_tRadius = (triggerArea (_HQ getVariable ["RydHQ_IdleDecoy",objNull])) select 0;

	if ((random 100) >= (_HQ getVariable ["RydHQ_IDChance",100])) exitWith {_isDecoy = false};

	_tPos = getPosATL (_HQ getVariable ["RydHQ_IdleDecoy",objNull]);
	//_enemyMatters = (triggerArea (_HQ getVariable ["RydHQ_IdleDecoy",objNull])) select 3;

	_posX = (_tPos select 0) + (random 200) - 100;
	_posY = (_tPos select 1) + (random 200) - 100;
	};

if (not (isNull (_HQ getVariable ["RydHQ_SupportDecoy",objNull])) and (_unitG in (_HQ getVariable ["RydHQ_SupportG",[]]))) then
	{
	//_tRadius = (triggerArea (_HQ getVariable ["RydHQ_SupportDecoy",objNull])) select 0;

	if ((random 100) >= (_HQ getVariable ["RydHQ_SDChance",100])) exitWith {_isDecoy = false};

	_tPos = getPosATL (_HQ getVariable ["RydHQ_SupportDecoy",objNull]);
	//_enemyMatters = (triggerArea (_HQ getVariable ["RydHQ_SupportDecoy",objNull])) select 3;
	_posX = (_tPos select 0) + (random 200) - 100;
	_posY = (_tPos select 1) + (random 200) - 100;
	};

if not (_isDecoy) then 
	{
	_safedist = 100/(0.75 + ((_HQ getVariable ["RydHQ_Recklessness",0.5])/2));
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
			if ((_counterU >= (round (2/(0.5 + ((_HQ getVariable ["RydHQ_Recklessness",0.5])/2))))) or (_counterU >= ((count (_HQ getVariable ["RydHQ_Friends",[]]))/(4*(0.5 + ((_HQ getVariable ["RydHQ_Recklessness",0.5])/2)))))) exitwith {_behind2 = false}
			}
		foreach (_HQ getVariable ["RydHQ_Friends",[]]);
		if not (_behind2) exitwith {_Xpos = _Xpos3;_Ypos = _Ypos3};
		if (_behind2) then {_Xpos = _Xpos2;_Ypos = _Ypos2};
		};

	_position = [_Xpos,_Ypos];
	_allowed = false;

	_HQ setVariable ["RydHQ_Bpoint",_position];

	if (not (_unitG in ((_HQ getVariable ["RydHQ_SupportG",[]]) + (_HQ getVariable ["RydHQ_NCCargoG",[]]))) and ((random 100) >= 50) and ((_VLU distance [_Xpos,_Ypos]) > (_VLU distance (leader _HQ)))) then 
		{
		//_position = [((getPosATL (leader _HQ)) select 0) + (random 400) - 200,((getPosATL (leader _HQ)) select 1) + (random 400) - 200]
		_position = [((getPosATL _VLU) select 0) + (random 200) - 100,((getPosATL _VLU) select 1) + (random 200) - 100]
		}
	else
		{
		if (not (_unitG in ((_HQ getVariable ["RydHQ_NCCargoG",[]]) - (_HQ getVariable ["RydHQ_SupportG",[]]))) and ((_VLU distance [_Xpos,_Ypos]) < (_VLU distance _obj)) and (_behind)) then 
			{
			_position = [_Xpos + (random 400) - 200,_Ypos + (random 400) - 200];
			_allowed = true;
			}
		else
			{
			if not (_unitG in ((_HQ getVariable ["RydHQ_SupportG",[]]) + (_HQ getVariable ["RydHQ_NCCargoG",[]]))) then 
				{
				_position = [((getPosATL _VLU) select 0) + (random 200) - 100,((getPosATL _VLU) select 1) + (random 200) - 100]
				};
			}
		};

	if (not (_allowed) and (_unitG in (_HQ getVariable ["RydHQ_SupportG",[]]))) exitwith {};

	_radius = 100;
	_precision = 20;
	_sourcesCount = 1;
	_expression = "Meadow";
	switch (true) do 
		{
		case (_unitG in ((_HQ getVariable ["RydHQ_NCrewInfG",[]]) - (_HQ getVariable ["RydHQ_SupportG",[]]))) : {_expression = "(1 + (2 * Houses)) * (1 + (1.5 * Forest)) * (1 + Trees) * (1 - Meadow) * (1 - (10 * sea))"};
		case (not (_unitG in ((_HQ getVariable ["RydHQ_NCrewInfG",[]]) - (_HQ getVariable ["RydHQ_SupportG",[]])))) : {_expression = "(1 + (2 * Meadow)) * (1 - Forest) * (1 - (0.5 * Trees)) * (1 - (10 * sea)) * (1 - (2 * Houses))"};
		};

	_Spot = selectBestPlaces [_position,_radius,_expression,_precision,_sourcesCount];
	_Spot = _Spot select 0;
	_Spot = _Spot select 0;

	_posX = _Spot select 0;
	_posY = _Spot select 1;

	if (((_unitG in ((_HQ getVariable ["RydHQ_NCrewInfG",[]]) - (_HQ getVariable ["RydHQ_SupportG",[]]) - (_HQ getVariable ["RydHQ_CargoG",[]]))) and ((random 100) > (20/0.5 + (_HQ getVariable ["RydHQ_Activity",0.5])))) or (((random 100) > (80/0.5 + (_HQ getVariable ["RydHQ_Activity",0.5]))) and not (_unitG in (_HQ getVariable ["RydHQ_SupportG",[]])))) then {_patrol = true};
	if (isPlayer (leader _unitG)) then {_patrol = false};
	_sec = false;

	if  ((not (_unitG in (_HQ getVariable ["RydHQ_NCCargoG",[]])) or ((count (units _unitG)) > 1)) and not (_unitG in (_HQ getVariable ["RydHQ_SupportG",[]])) and ((_VLU distance _obj) > (_VLU distance (leader _HQ)))) then 
		{
		_rnd = random 100;

		switch (true) do 
			{
			case ((_rnd > 50) and (_rnd <= 75)) : {if not (isNull (_HQ getVariable ["RydHQ_Sec1",objNull])) then {_posX = ((getPosATL (_HQ getVariable ["RydHQ_Sec1",objNull])) select 0) + (random 200) - 100;_posY = ((getPosATL (_HQ getVariable ["RydHQ_Sec1",objNull])) select 1) + (random 200) - 100};_sec = true};
			case (_rnd > 75) : {if not (isNull (_HQ getVariable ["RydHQ_Sec2",objNull])) then {_posX = ((getPosATL (_HQ getVariable ["RydHQ_Sec2",objNull])) select 0) + (random 200) - 100;_posY = ((getPosATL (_HQ getVariable ["RydHQ_Sec2",objNull])) select 1) + (random 200) - 100};_sec = true};
			};
		};

	_NR = _pos nearRoads 400;
	_cnt = 0;
	if (not (_patrol) and not (_sec) and not ((random 100) < (20/(0.5 + (_HQ getVariable ["RydHQ_Fineness",0.5])))) and not ((count _NR) == 0) and not (_unitG in ((_HQ getVariable ["RydHQ_SupportG",[]]) + (_HQ getVariable ["RydHQ_NCCargoG",[]])))) then 
		{
		while {(true)} do
			 {
			 _cnt = _cnt + 1;
			_Rpoint = _NR select (floor (random (count _NR)));
			_posX = ((getPosATL _Rpoint) select 0) + (random 100) - 50;
			_posY = ((getPosATL _Rpoint) select 1) + (random 100) - 50;
			if (not (isOnRoad [_posX,_posY]) and (([_posX,_posY] distance _Rpoint) > 10) or (_cnt > 20)) exitwith {if not (_cnt > 20) then {_roadG = true}};
			}
		};
	};

_eClose = [[_posX,_posY],(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),500] call RYD_CloseEnemy;

if (((([_posX,_posY] distance _VLU) < 100) and not (_patrol) and not (_roadG)) or ((_eClose) and (_enemyMatters))) exitwith {_unitG setVariable [("Deployed" + (str _unitG)),false]};

_isWater = surfaceIsWater [_posX,_posY];

if (_isWater) exitwith {_unitG setVariable [("Deployed" + (str _unitG)),false]};

[_unitG] call RYD_WPdel;

[_unitG,[_posX,_posY,0],"HQ_ord_idle",_HQ] call RYD_OrderPause;

if ((isPlayer (leader _unitG)) and (RydxHQ_GPauseActive)) then {hintC "New orders from HQ!";setAccTime 1};

_UL = leader _unitG;
 
if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdConf,"OrdConf"] call RYD_AIChatter}};

_i = "";
if (_HQ getVariable ["RydHQ_Debug",false]) then
	{
	_pltxt = " - HOLD POSITION";
	if (_patrol) then {_pltxt = " - PATROL AREA"};
	_signum = _HQ getVariable ["RydHQ_CodeSign","X"];
	_i = [[_posX,_posY],_unitG,"markIdle","ColorWhite","ICON","waypoint","STB " + (groupId _unitG) + " " + _signum,_pltxt,[0.5,0.5]] call RYD_Mark;
	};

_task = taskNull;
if (not (_patrol)) then
	{
	_task = [(leader _unitG),["Hold position and wait for orders.", "Wait For Orders", ""],[_posX,_posY],"radio"] call RYD_AddTask
	};

_tp = "MOVE";
if not (_patrol) then {_tp = "MOVE"};
if (_unitG in ((_HQ getVariable ["RydHQ_NCrewInfG",[]]) - (_HQ getVariable ["RydHQ_SupportG",[]]))) then {_tp = "MOVE"};
_CM = "YELLOW";
_spd = "LIMITED";
if (_unitG in ((_HQ getVariable ["RydHQ_SupportG",[]]))) then {_CM = "BLUE";_tp = "MOVE";_spd = "NORMAL"};
_sts = ["true","deletewaypoint [(group this), 0];"];
if (_unitG in (_HQ getVariable ["RydHQ_AirG",[]])) then {_sts = ["true", "{(vehicle _x) land 'LAND'} foreach (units (group this)); deletewaypoint [(group this), 0]"]};

_wp = [_unitG,[_posX,_posY],_tp,"SAFE",_CM,_spd,_sts,true,0,[0,0,0],"STAG COLUMN"] call RYD_WPadd;

if (_patrol) then 
	{
	[_unitG] call RYD_WPdel;

	_firstpos = [_posX,_posY];
	_Nway = (ceil (random 4)) + 2;
	if (isPlayer (leader _unitG)) then {_Nway = 1};
	for [{_a = 1},{_a <= _Nway},{_a = _a + 1}] do
		{
		_posX = _posX + (random 500) - 250;
		_posY = _posY + (random 500) - 250;

		_ct = 0;
		_pos = [_posX,_posY];

		_posX2 = _posX;
		_posY2 = _posY;

		while {((surfaceIsWater _pos) and (_ct < 50))} do
			{
			_posX2 = _posX + (random 500) - 250;
			_posY2 = _posY + (random 500) - 250;
			_pos = [_posX2,_posY2];
			_ct = _ct + 1;
			};

		_posX = _posX2;
		_posY = _posY2;

		_isWater = surfaceIsWater [_posX,_posY];

		if not (_isWater) then 
			{
			_task = [(leader _unitG),["Patrol area.", "Patrol area", ""],[_posX,_posY],"walk"] call RYD_AddTask;

			_tp = "CYCLE";
			_pos = _firstpos;
			if (not (_a == _Nway) or (isPlayer (leader _unitG))) then {_pos = [_posX,_posY];_tp = "MOVE"};
			_crr = false;
			if (_a == 1) then {_crr = true};

			_wp = [[_unitG],_pos,_tp,"SAFE","YELLOW","LIMITED",["true",""],_crr,0.01,[20,25,30],"STAG COLUMN"] call RYD_WPadd
			};
		}
	};

private _WaitCarrier = objNull;
_WaitCarrier setVariable ["_continueAW",false];
[_WaitCarrier,_unitG,6,true,0,50,[],false,true,true,false,true] call RYD_Wait; 
waitUntil {_WaitCarrier getVariable ["_continueAW",false];}; 
_WaitCarrier setVariable ["_continueAW",false];
_timer = _WaitCarrier getVariable "_timer";
_alive = _WaitCarrier getVariable "_alive";
_busy = _WaitCarrier getVariable "_busy";


if (not (_patrol) and not (_busy) and (_alive)) then 
	{
	_UL = leader _unitG;if not (isPlayer _UL) then {if (_timer <= 24) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdFinal,"OrdFinal"] call RYD_AIChatter}}};
	_frm = formation _unitG;
	if not (isPlayer (leader _unitG)) then {_frm = "DIAMOND"};
	_wp = [_unitG,[_posX,_posY],"MOVE","AWARE","YELLOW","NORMAL",["true","deletewaypoint [(group this), 0];"],false,0,[0,0,0],_frm] call RYD_WPadd;
	};

//if not (isNull _task) then {[_task,"SUCCEEDED",true] call BIS_fnc_taskSetState};

if not (_alive) exitwith {if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markIdle" + str (_unitG))}};

if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markIdle" + str (_unitG))};

if (_alive) then 
	{
	private _WaitCarrier = objNull;
	_WaitCarrier setVariable ["_continueAW",false];
	[_WaitCarrier,_unitG,6,false,0,0,[],true,true,false,true] call RYD_Wait; 
	waitUntil {_WaitCarrier getVariable ["_continueAW",false];}; 
	_WaitCarrier setVariable ["_continueAW",false];
	_alive = _WaitCarrier getVariable "_alive";
	_busy = _WaitCarrier getVariable "_busy";

	if not (_alive) exitwith {};
	if not (isPlayer (leader _unitG)) then {_unitG setFormation "WEDGE"};
	};