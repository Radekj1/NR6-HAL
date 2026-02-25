_SCRname = "GoAmmoSupp";

_i = "";
params ["_unit","_Trg","_Hollow","_soldiers","_drop","_ammoBox","_HQ"];

_request = false;
if ((count _this) > 7) then {_request = _this select 7};


_AmmoPoints = _HQ getVariable ["RydHQ_AmmoPoints",[]];

_AmmoPoints pushBack _Trg;

_unitG = group (assigneddriver _unit);
_unitvar = str (_unitG);
_startpos = getPosASL _unit;

if (isNil ("_startpos")) then {_unitG setVariable [("START" + _unitvar),(position _unit)]};

if (_unit in _soldiers) then {_unitG = group _unit};

if (isNil "RydxHQ_SlingDrop") then {RydxHQ_SlingDrop = false};

_mtr = _unit;

_mtr disableAI "TARGET";_mtr disableAI "AUTOTARGET";

[_unitG] call RYD_WPdel;

(group (assigneddriver _unit)) setVariable [("Deployed" + (str (group (assigneddriver _unit)))),false];
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
	
[_unitG,[_posX,_posY,0],"HQ_ord_ammoS",_HQ] call RYD_OrderPause;

if ((isPlayer (leader _unitG)) and (RydxHQ_GPauseActive)) then {hintC "New orders from HQ!"; setAccTime 1};

_UL = leader _unitG;

if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdConf,"OrdConf"] call RYD_AIChatter}};

_alive = false;
if (_HQ getVariable ["RydHQ_Debug",false]) then 
	{
	_signum = _HQ getVariable ["RydHQ_CodeSign","X"];
	_i = [[_posX,_posY],_unitG,"markAmmoSupp","ColorKhaki","ICON","waypoint","REARM " + (groupId _unitG) + " " + _signum," - REARM",[0.5,0.5],270] call RYD_Mark
	};

_task = [(leader _unitG),["Deliver Ammo to " + (groupId (group _Trg)), "Rearm " + (groupId (group _Trg)), ""],(position _Trg),"rearm"] call RYD_AddTask;

if (_drop) then
	{
	_dst = _unit distance _Trg;

	if (_dst > 100) then
		{
		if (_unit isKindOf "Air") then
			{
			//_ammoBox = _this select 5;
			_abPos = getPosATL _ammoBox;
			_pos = _Trg;
			(group _Trg) setVariable ["ForBoxing",_pos];
			
			if not (RydxHQ_SlingDrop) then
				{
				_ammoBox setPos [0,0,2000];
				_ang = [(getPosATL _unit),(getPosATL _Trg),5] call RYD_AngTowards;
				_nextPos1 = [(getPosATL _unit),_ang,(_unit distance _Trg) + 200] call RYD_PosTowards2D;

				_tp = "MOVE";

				_wp = [_unitG,_pos,_tp,"STEALTH","BLUE","FULL",["true","deletewaypoint [(group this), 0]"]] call RYD_WPadd;

				_unit flyInHeight 150;
				//[_unit,100] spawn RYD_KeepAlt;

				

				_timer = 0;
				_endThis = false;
				_alive = true;

				if (_unit isKindOf "Plane") then {
					waitUntil {
						sleep 0.5;
						
						if (abs (speed (vehicle (leader _unitG))) < 0.05) then {_timer = _timer + 0.5};

						if ((isNull _unitG) or (isNull _HQ)) then {_endThis = true;_alive = false};
						if (({alive _x} count (units _unitG)) < 1) then {_endThis = true;_alive = false};
						if ((count (waypoints _unitG)) < 1) then {_endThis = true;};
						if (_unitG getVariable ["Break",false]) then {_endThis = true;_alive = false; _unitG setVariable ["Break",false];};

						if (((vehicle (leader _unitG)) distance2D _Trg) < 250) then {_endThis = true;[_unitG, (currentWaypoint _unitG)] setWaypointPosition [position (vehicle (leader _unitG)), 0];};
						if (_timer > 240) then {_endThis = true};

						(_endThis)
						};
					} else {
						private _WaitCarrier = objNull;
						_WaitCarrier setVariable ["_continueAW",false];
						[_WaitCarrier,_unitG,1,true,0,240,[],true,true,true,true] call RYD_Wait; 
						waitUntil {_WaitCarrier getVariable ["_continueAW",false];}; 
						_WaitCarrier setVariable ["_continueAW",false];
						_timer = _WaitCarrier getVariable "_timer";
						_alive = _WaitCarrier getVariable "_alive";
					};

				if not (_alive) exitwith {if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
					{
					deleteVehicle _ammoBox;
					deleteMarker ("markAmmoSupp" + str (_unitG))};
					_AmmoPoints = _AmmoPoints - [_Trg];
					_HQ setVariable ["RydHQ_AmmoPoints",_AmmoPoints];
					_unitG setVariable [("Busy" + _unitvar), false];
					};
					
				if (_timer > 240) then 
					{
					[_unitG, (currentWaypoint _unitG)] setWaypointPosition [position (vehicle (leader _unitG)), 0];
					_ammoBox setPos _abPos
					}
			else
					{
					_UL = leader _unitG;if not (isPlayer _UL) then {if (_timer <= 240) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdFinal,"OrdFinal"] call RYD_AIChatter}}};
					[_unit,_ammoBox,(group _Trg)] call RYD_AmmoDrop;
					_boxed = (_HQ getVariable ["RydHQ_Boxed",[]]);
					_boxed pushBack (group _Trg);
					_HQ setVariable ["RydHQ_Boxed",_boxed];
					_HQ setVariable ["RydHQ_OrdnanceDrops",(_HQ getVariable ["RydHQ_OrdnanceDrops",[]]) + [_ammoBox]];
					};

				_wp = [_unitG,_nextPos1,_tp,"STEALTH","BLUE","FULL",["true","deletewaypoint [(group this), 0]"]] call RYD_WPadd;


				private _WaitCarrier = objNull;
						_WaitCarrier setVariable ["_continueAW",false];
						[_WaitCarrier,_unitG,6,true,0,24,[],true,true,true,true] call RYD_Wait; 
						waitUntil {_WaitCarrier getVariable ["_continueAW",false];};
						_WaitCarrier setVariable ["_continueAW",false];
						_timer = _WaitCarrier getVariable "_timer";
						_alive = _WaitCarrier getVariable "_alive";

				//_unit setVariable ["KeepAlt",false];

				if not (_alive) exitwith 
					{
					if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
						{
						deleteMarker ("markAmmoSupp" + str (_unitG))
						};
						
					_AmmoPoints = _AmmoPoints - [_Trg];
					_HQ setVariable ["RydHQ_AmmoPoints",_AmmoPoints];
					_unitG setVariable [("Busy" + _unitvar), false];
					};
						
				if (_timer > 24) then 
					{
					[_unitG, (currentWaypoint _unitG)] setWaypointPosition [position (vehicle (leader _unitG)), 0]
					}
				}
				else
				{
				_pos2 = position _pos;
				_pos = position _ammoBox;

				if (_unit canSlingLoad _ammoBox) then
					{
					
					_unitG setVariable ["AmmBox" + (str _unitG),_ammoBox];
					_wp = [_unitG,_pos,"HOOK","STEALTH","BLUE","FULL",["true","deletewaypoint [(group this), 0]"]] call RYD_WPadd;

					_wp waypointAttachVehicle _ammoBox;
					
					private _WaitCarrier = objNull;
						_WaitCarrier setVariable ["_continueAW",false];
						[_WaitCarrier,_unitG,6,true,0,24,[],true,true,true,true] call RYD_Wait; 
						waitUntil {_WaitCarrier getVariable ["_continueAW",false];};
						_WaitCarrier setVariable ["_continueAW",false];
						_timer = _WaitCarrier getVariable "_timer";
						_alive = _WaitCarrier getVariable "_alive";

					
					if (not (_alive) or {(_timer > 24)}) exitwith 
						{
						if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
							{
							deleteMarker ("markAmmoSupp" + str (_unitG))
							};
							
						_AmmoPoints = _AmmoPoints - [_Trg];
						_HQ setVariable ["RydHQ_AmmoPoints",_AmmoPoints];
						_unitG setVariable [("Busy" + _unitvar), false];
						};
					
					_wp = [_unitG,_pos2,"UNHOOK","STEALTH","BLUE","FULL",["true","deletewaypoint [(group this), 0]"]] call RYD_WPadd;
					
					_wp waypointAttachVehicle _Trg;
					
					private _WaitCarrier = objNull;
					_WaitCarrier setVariable ["_continueAW",false];
					[_WaitCarrier,_unitG,6,true,0,24,[],true,true,true,true] call RYD_Wait; 
					waitUntil {_WaitCarrier getVariable ["_continueAW",false];};
					_WaitCarrier setVariable ["_continueAW",false];
					_timer = _WaitCarrier getVariable "_timer";
					_alive = _WaitCarrier getVariable "_alive";

					if not (_alive) exitwith 
						{
						if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
							{
							deleteMarker ("markAmmoSupp" + str (_unitG))
							};
							
						_AmmoPoints = _AmmoPoints - [_Trg];
						_HQ setVariable ["RydHQ_AmmoPoints",_AmmoPoints];
						_unitG setVariable [("Busy" + _unitvar), false];
						};

					_HQ setVariable ["RydHQ_OrdnanceDrops",(_HQ getVariable ["RydHQ_OrdnanceDrops",[]]) + [_ammoBox]];
						
					if (_timer > 24) then 
						{
						[_unitG, (currentWaypoint _unitG)] setWaypointPosition [position (vehicle (leader _unitG)), 0]
						}
					}
				else
					{	
					_unitG setVariable ["AmmBox" + (str _unitG),_ammoBox];				
					_wp = [_unitG,_pos,"HOOK","STEALTH","BLUE","FULL",["true","deletewaypoint [(group this), 0]"]] call RYD_WPadd;
										
					_sl = configFile >> "CfgVehicles" >> (typeOf _unit) >> "slingLoadMemoryPoint";
					
					if (isText _sl) then
						{
						_sl = getText _sl
						}
					else
						{
						_sl = [0,0,-2]
						};
						
					_bb = boundingBox _ammoBox;
					_sizeZ = (((((_bb select 1) select 2) - ((_bb select 0) select 2)) * 3) max 5) min 12;
					_alive = true;
					_p1 = (getPosATL _unit);
					_l1 = _p1 select 2;
					_l2 = _p1 select 2; 
					_p2 = (getPosATL _ammoBox); 
					_cnt = 0;
						
					waitUntil
						{						
						_alive = switch (true) do
							{
							case (isNil "_unit") : {false};
							case not ((typeName _unit) isEqualTo (typename objNull)) : {false};
							case (isNull _unit) : {false};
							case not (alive _unit) : {false};
							};
						
						if (_alive) then
							{
							if (((velocity _unit) distance [0,0,0]) < 0.1) then
								{
								_cnt = _cnt + 0.01
								};
								
							if (_cnt > 60) exitWith {_alive = false};
							
							_p1 = (getPosATL _unit);
							_l1 = _p1 select 2; 
							sleep 0.1;
							_p1 = (getPosATL _unit);
							_l2 = _p1 select 2; 
							_p2 = (getPosATL _ammoBox);
							
							_p1 set [2,0];
							_p2 set [2,0];
							};
									
						(not (_alive) or {(((_p1 distance _p2) < 10) and {(_l2 > 10) and {(_l1 > _l2)}})})
						};
						
					if not (_alive) exitwith 
						{
						if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
							{
							deleteMarker ("markAmmoSupp" + str (_unitG))
							};
							
						_AmmoPoints = _AmmoPoints - [_Trg];
						_HQ setVariable ["RydHQ_AmmoPoints",_AmmoPoints];
						_unitG setVariable [("Busy" + _unitvar), false];
						};
						
					deleteWaypoint _wp;
					
					_unit flyInHeight _sizeZ;
					
					_cnt = 0;
						
					waitUntil
						{						
						_alive = switch (true) do
							{
							case (isNil "_unit") : {false};
							case not ((typeName _unit) isEqualTo (typename objNull)) : {false};
							case (isNull _unit) : {false};
							case not (alive _unit) : {false};
							};
						
						if (_alive) then
							{
							if (((velocity _unit) distance [0,0,0]) < 0.1) then
								{
								_cnt = _cnt + 0.01
								};
								
							if (_cnt > 60) exitWith {_alive = false};
							
							_l1 = (getPosATL _unit) select 2; 
							sleep 0.01;
							_l2 = (getPosATL _unit) select 2; 
							};
									
						(not (_alive) or {(_l1 < (_sizeZ + 1))})
						};					
	
					if not (_alive) exitwith 
						{
						if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
							{
							deleteMarker ("markAmmoSupp" + str (_unitG))
							};
							
						_AmmoPoints = _AmmoPoints - [_Trg];
						_HQ setVariable ["RydHQ_AmmoPoints",_AmmoPoints];
						_unitG setVariable [("Busy" + _unitvar), false];
						};

					_lvl = (_unit distance _ammoBox) + 1;
					_rope = ropeCreate [_unit, _sl, _ammoBox, [0, 0, 0],_lvl];
					
					[_ammoBox,[0,0,0.5],[0,0,-1]] ropeAttachTo _rope;
					
					_unit flyInHeight (_lvl + 30);
					
					sleep 3;
					
					_wp = [_unitG,_pos2,"MOVE","STEALTH","BLUE","FULL",["true","deletewaypoint [(group this), 0]"]] call RYD_WPadd;
					
					_wp waypointAttachVehicle _Trg;
					
					private _WaitCarrier = objNull;
					_WaitCarrier setVariable ["_continueAW",false];
					[_WaitCarrier,_unitG,6,true,0,24,[],true,true,true,true] call RYD_Wait; 
					waitUntil {_WaitCarrier getVariable ["_continueAW",false];}; 
					_WaitCarrier setVariable ["_continueAW",false];
					_timer = _WaitCarrier getVariable "_timer";
					_alive = _WaitCarrier getVariable "_alive";

					if not (_alive) exitwith 
						{
						if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
							{
							deleteMarker ("markAmmoSupp" + str (_unitG))
							};
							
						_AmmoPoints = _AmmoPoints - [_Trg];
						_HQ setVariable ["RydHQ_AmmoPoints",_AmmoPoints];
						_unitG setVariable [("Busy" + _unitvar), false];
						};
						
					if (_timer > 24) then 
						{
						[_unitG, (currentWaypoint _unitG)] setWaypointPosition [position (vehicle (leader _unitG)), 0]
						};
						
					_unit flyInHeight (_lvl + 1);
					
					sleep 6;
					
						{
						_unit ropeDetach _x;
						ropeDestroy _x;
						}
					foreach (ropes _unit);
					
					_ammoBox allowDamage false;
					
					_unit flyInHeight (_lvl + 30);
					
					[_ammoBox,(group _Trg)] spawn
						{
						_ammoBox = _this select 0;
						_benef = _this select 1;
						
						waitUntil
							{
							sleep 0.01;
							(((position _ammoBox) select 2) < 2)
							};
							
						sleep 2;
						
						_benef setVariable ["isBoxed",_ammoBox];
						
						_ammoBox allowDamage true;
						};
						
					_boxed = (_HQ getVariable ["RydHQ_Boxed",[]]);
					_boxed pushBack (group _Trg);
					_HQ setVariable ["RydHQ_Boxed",_boxed];
					_HQ setVariable ["RydHQ_OrdnanceDrops",(_HQ getVariable ["RydHQ_OrdnanceDrops",[]]) + [_ammoBox]];
					}				
				}
			}
		}
	}
else
	{
	_counter = 0;
	_timer = 0;

	if (_request) then {

		[_mtr,"Ammunition"] remoteExecCall ["RYD_ReqLogistics_Actions"];

		_mtr setVariable ["HAL_Requested",true,true];
		
	};

	while {(_counter <= 3)} do
		{
		[_unitG] call RYD_WPdel;

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
	
				[_task,(leader _unitG),["Deliver the ammunition to the designated forces.", "Provide Ammunition Support", ""],[_posX,_posY],"ASSIGNED",0,false,true] call BIS_fnc_SetTask;
			
				}
			};

		_pos = [_posX,_posY];
		if (_counter == 0) then {_pos = _Trg};
		_tp = "MOVE";
		if (_HQ getVariable ["RydHQ_SupportWP",false]) then {_tp = "SUPPORT"};

		_wp = [_unitG,_pos,_tp,"SAFE","BLUE","FULL",["true","(vehicle this) land 'GET IN';deletewaypoint [(group this), 0]"]] call RYD_WPadd;
		if (_counter == 0) then {_wp waypointAttachVehicle _Trg};

		private _WaitCarrier = objNull;
		_WaitCarrier setVariable ["_continueAW",false];
		[_WaitCarrier,_unitG,6,true,0,24,[],true,true,true,true] call RYD_Wait; 
		waitUntil {_WaitCarrier getVariable ["_continueAW",false];}; 
		_WaitCarrier setVariable ["_continueAW",false];
		_timer = _WaitCarrier getVariable "_timer";
		_alive = _WaitCarrier getVariable "_alive";

						
		if not (_alive) exitwith 
			{
			if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
				{
				deleteMarker ("markAmmoSupp" + str (_unitG))
				};
				
			_AmmoPoints = _AmmoPoints - [_Trg];
			_HQ setVariable ["RydHQ_AmmoPoints",_AmmoPoints];
			_unitG setVariable [("Busy" + _unitvar), false];
			_mtr setVariable ["HAL_Requested",false,true];
			};
			
		if (_timer > 24) then {_counter = _counter + 1;[_unitG, (currentWaypoint _unitG)] setWaypointPosition [position (vehicle (leader _unitG)), 0];} else {_counter = _counter + 1}; 

		if ((RydxHQ_MagicRearm) and (_timer <= 24)) then { {if (((side _x) getFriend (side _unitG)) >= 0.6) then {_x setVehicleAmmo 1; if (isPlayer _x) then {"Vehicle Rearmed" remoteExec ["hint", _x]};}} foreach ((vehicle (leader _unitG)) nearEntities [["Air", "LandVehicle"], 100]);};
		
//		if ((_request) and ((_mtr getVariable ["HAL_Requested",false]) or ((_mtr distance _Trg) > 500))) then {_counter = 5};

		if ((_request) and (_mtr getVariable ["HAL_Requested",false]) and ((_mtr distance _Trg) < 500)) then {_counter = 0};

		if ((_request) and not (_mtr getVariable ["HAL_Requested",false])) then {_counter = 5};
		
		_UL = leader _unitG; if not (isPlayer _UL) then {if ((_timer <= 24) and (_counter == 1)) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdFinal,"OrdFinal"] call RYD_AIChatter}}};

		if ((damage _Trg) >= 0.9) then {_Hollow = _Hollow - [_Trg]};
		}
	};

if (_request) then {[_mtr] remoteExecCall ["RYD_ReqLogisticsDelete_Actions"]};
_mtr setVariable ["HAL_Requested",false,true];

if not (_alive) exitwith 
	{
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
		{
		deleteMarker ("markAmmoSupp" + str (_unitG))
		};
		
	_AmmoPoints = _AmmoPoints - [_Trg];
	_HQ setVariable ["RydHQ_AmmoPoints",_AmmoPoints];
	_unitG setVariable [("Busy" + _unitvar), false];
	};
	
[_unitG, (currentWaypoint _unitG)] setWaypointPosition [position (vehicle (leader _unitG)), 0];

_tp = "MOVE";
if ((_HQ getVariable ["RydHQ_SupportWP",false]) and not (_drop)) then {_tp = "SUPPORT"};
_pos = [_posX,_posY];

if (_HQ getVariable ["RydHQ_SupportRTB",false]) then {_pos = _startpos; if not (isNull (_HQ getVariable ["RydHQ_SupportDecoy",objNull])) then {if ((random 100) <= (_HQ getVariable ["RydHQ_SDChance",100])) then {_pos = (getpos (_HQ getVariable ["RydHQ_SupportDecoy",objNull]))}}; _AmmoPoints = _AmmoPoints - [_Trg];};

if (_drop) then 
	{
	_AmmoPoints = _AmmoPoints - [_Trg];
	_pos = _startpos;
	if (_task isNotEqualTo taskNull) then
		{
		
		[_task,(leader _unitG),["Return to base.", "Return To Base", ""],_pos,"ASSIGNED",0,false,true] call BIS_fnc_SetTask;
			 
		}
	};

_beh = "SAFE";
if (_drop) then {_beh = "STEALTH"};

_rrr = (_unitG getVariable ["Ryd_RRR",false]);

_radd = "";
if (_rrr) then {_radd = "; {(vehicle _x) setFuel 1; (vehicle _x) setVehicleAmmo 1; (vehicle _x) setDamage 0;} foreach (units (group this))"};

_wp = [_unitG,_pos,_tp,_beh,"BLUE","FULL",["true","if not ((group this) getVariable ['AirNoLand',false]) then {{(vehicle _x) land 'LAND'} foreach (units (group this))}; deletewaypoint [(group this), 0]" + _radd]] call RYD_WPadd;

if (not (_task isEqualTo taskNull) and (_HQ getVariable ["RydHQ_SupportRTB",false]) and not (_drop)) then
	{
		
	[_task,(leader _unitG),["Return to base.", "Return To Base", ""],_pos,"ASSIGNED",0,false,true] call BIS_fnc_SetTask;
			 
	};

_timer = 0;
_alive = true;

if not (_HQ getVariable ["RydHQ_SupportRTB",false]) then {
	private _WaitCarrier = objNull;
	_WaitCarrier setVariable ["_continueAW",false];
	[_WaitCarrier,_unitG,6,true,0,24,[],true,true,true,true] call RYD_Wait; 
	waitUntil {_WaitCarrier getVariable ["_continueAW",false];}; 
	_WaitCarrier setVariable ["_continueAW",false];
	_timer = _WaitCarrier getVariable "_timer";
	_alive = _WaitCarrier getVariable "_alive";
};

if not (_alive) exitwith 
	{
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
		{
		deleteMarker ("markAmmoSupp" + str (_unitG))
		};
		
	_AmmoPoints = _AmmoPoints - [_Trg];
	_HQ setVariable ["RydHQ_AmmoPoints",_AmmoPoints];
	_unitG setVariable [("Busy" + _unitvar), false];
	};
	
if (_timer > 24) then {[_unitG, (currentWaypoint _unitG)] setWaypointPosition [position (vehicle (leader _unitG)), 0]}; 

_AmmoPoints = _AmmoPoints - [_Trg];
_HQ setVariable ["RydHQ_AmmoPoints",_AmmoPoints];
if not (_HQ getVariable ["RydHQ_SupportRTB",false]) then {if (_task isNotEqualTo taskNull) then {[_task,"SUCCEEDED",true] call BIS_fnc_taskSetState}};

_mtr enableAI "TARGET";_mtr enableAI "AUTOTARGET";
_unitG setVariable [("Busy" + _unitvar), false];

if ((damage _Trg) >= 0.9) then {_Hollow = _Hollow - [_Trg]};
if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markAmmoSupp" + str (_unitG))};
_lastOne = true;

	{
	if (((group (assigneddriver _x)) == (group (assigneddriver _Trg))) and (_x != _Trg)) exitwith {_lastOne = false};
	if (((group _x) == (group _Trg)) and (_x != _Trg)) exitwith {_lastOne = false};
	}
foreach _Hollow;

if (_lastOne) then 
	{
	_aSupp = _HQ getVariable ["RydHQ_ASupportedG",[]];
	_aSupp = _aSupp - [(group _Trg)];
	_HQ setVariable ["RydHQ_ASupportedG",_aSupp]
	};


_UL = leader _unitG; if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdEnd,"OrdEnd"] call RYD_AIChatter}};

