_SCRname = "GoRecon";

_i = "";


_unitG = _this select 0;_Spos = _unitG getVariable ("START" + (str _unitG));if (isNil ("_Spos")) then {_unitG setVariable [("START" + (str _unitG)),(getPosATL (vehicle (leader _unitG)))];_Spos = _unitG getVariable ("START" + (str _unitG))}; 
_stage = _this select 2;
_HQ = _this select 3;

_reconNr = _this select 4;
_stages = _reconNr select 1;
_reconNr = _reconNr select 0;

_stage = _stage - (_stages * _reconNr);

_PosObj1 = _this select 1;

_specialized = _this select 5;

_recvar = str (_unitG);
_unitvar = str _unitG;

_IsAPlayer = false;
if (RydxHQ_NoCargoPlayers and (isPlayer (leader _unitG))) then {_IsAPlayer = true};

[_unitG] call RYD_WPdel;

_unitG setVariable [("Deployed" + (str _unitG)),false];
_unitG setVariable [("Capt" + (str _unitG)),false];

_reconAv = _HQ getVariable ["RydHQ_ReconAv",[]];
_reconAv = _reconAv - [_unitG];
_HQ setVariable ["RydHQ_ReconAv",_reconAv];

_UL = leader _unitG;

_PosLand = _unitG getVariable ("START" + _unitvar); 
if (isNil ("_PosLand")) then {_unitG setVariable [("START" + _unitvar),(position (vehicle _UL))];_PosLand = _unitG getVariable ("START" + _unitvar);};

_nothing = true;
_End = [((getPosATL (leader _HQ)) select 0) + (random 400) - 200,((getPosATL (leader _HQ)) select 1) + (random 400) - 200];
_rd = 200;

_dX = (_PosObj1 select 0) - ((getPosATL (leader _HQ)) select 0);
_dY = (_PosObj1 select 1) - ((getPosATL (leader _HQ)) select 1);

_angle = _dX atan2 _dY;

_distance = (leader _HQ) distance _PosObj1;

_distance2 = 600;

_dstMpl = (_HQ getVariable ["RydHQ_ReconDistance",1]) * (_unitG getVariable ["RydHQ_myReconDst",1]);
_distance2 = _distance2 * _dstMpl;

_dXc = _distance2 * (cos _angle);
_dYc = _distance2 * (sin _angle);

switch (_stage) do
	{
	case (6) : {_distance = _distance - _distance2/2;_dYc = - _dYc/2};
	case (5) : {_distance = _distance - _distance2/2;_dXc = - _dXc/2};
	case (4) : {_dYc = - _dYc};
	case (3) : {_dXc = - _dXc};
	case (2) : {_distance = _distance - _distance2;_dXc = 0;_dYc = 0};
	};

_dXb = _distance * (sin _angle);
_dYb = _distance * (cos _angle);

_isLOS = false;
_ct = 0;

_posX = 0;
_posY = 0;

_POASL = ATLToASL _PosObj1;

//_tgtV = vehicle (_this select 4);
_VL = vehicle _UL;

while {not _isLOS} do
	{
	_posX = ((getPosATL (leader _HQ)) select 0) + _dXb + _dXc + (random 200) - 100;
	_posY = ((getPosATL (leader _HQ)) select 1) + _dYb + _dYc + (random 200) - 100;
	
	_MElevated = [_posX,_posY];
	_MElev = getTerrainHeightASL [_posX,_posY];

	if (_unitG in (_HQ getVariable ["RydHQ_FOG",[]])) then 
		{
		for [{_a = 0},{_a <= 50},{_a = _a + 1}] do
			{
			_posX0 = _posX + (random 500) - 250;
			_posY0 = _posY + (random 500) - 250;
			_Elev = getTerrainHeightASL [_posX0,_posY0];
			if (_Elev > _MElev) then 
				{
				_MElev = _Elev;
				_MElevated = [_posX0,_posY0]
				}
			}
		};

	_posX = _MElevated select 0;
	_posY = _MElevated select 1;
	
	_isWater = surfaceIsWater [_posX,_posY];
	if not (_isWater) then 
		{
		_isLOS = [[_posX,_posY,_MElev],_POASL,0.5,1,_VL,objNull] call RYD_LOSCheck
		};
	
	_ct = _ct + 1;
	if (_ct > 50) exitWith {}
	};

_isWater = surfaceIsWater [_posX,_posY];

while {((_isWater) and (([_posX,_posY] distance _PosObj1) >= 250))} do
	{
	_posX = _posX - _dXc/20;
	_posY = _posY - _dYc/20;
	_isWater = surfaceIsWater [_posX,_posY];
	};

_isWater = surfaceIsWater [_posX,_posY];

_onlyL = (_HQ getVariable ["RydHQ_LArmorG",[]]) - (_HQ getVariable ["RydHQ_MArmorG",[]]);

if (_isWater) exitWith 
	{
	if (_unitG in (((_HQ getVariable ["RydHQ_RAirG",[]]) + (_HQ getVariable ["RydHQ_ReconG",[]]) + (_HQ getVariable ["RydHQ_FOG",[]]) + (_HQ getVariable ["RydHQ_SnipersG",[]]) + (_HQ getVariable ["RydHQ_NCrewInfG",[]]) - ((_HQ getVariable ["RydHQ_SupportG",[]]) + (_HQ getVariable ["RydHQ_NCCargoG",[]])) + _onlyL) - ((_HQ getVariable ["RydHQ_NoRecon",[]]) + (_HQ getVariable ["RydHQ_CargoOnly",[]])))) then
		{
		_reconAv = _HQ getVariable ["RydHQ_ReconAv",[]];
		_reconAv pushBack _unitG;
		_HQ setVariable ["RydHQ_ReconAv",_reconAv]
		};
		
	_unitG setVariable [("Busy" + (str _unitG)),false]
	};
	
[_unitG,[_posX,_posY,0],"HQ_ord_recon",_HQ] call RYD_OrderPause;

if ((isPlayer (leader _unitG)) and (RydxHQ_GPauseActive)) then {hintC "New orders from HQ!";setAccTime 1};

_UL = leader _unitG;
 
if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdConf,"OrdConf"] call RYD_AIChatter}};

if (_HQ getVariable ["RydHQ_Debug",false]) then 
	{
	_signum = _HQ getVariable ["RydHQ_CodeSign","X"];
	_i = [[_posX,_posY],_unitG,"markRecon","ColorRed","ICON","waypoint","REC " + (groupId _unitG) + " " + _signum," - RECON",[0.5,0.5]] call RYD_Mark;
	};

//---------------- ADDED CARGO

_alive = true;
_timer = 0;
_AV = assignedVehicle _UL;

if not (isNull _AV) then { 

	{
		if (isNull (assignedVehicle _x)) then {_x assignAsCargo _AV};
	} forEach (units _unitG);
};

/*
if (((_HQ getVariable ["RydHQ_CargoFind",0]) > 0) and (RydxHQ_ReconCargo) and not (_IsAPlayer) and (isNull _AV) and (([_posX,_posY] distance (vehicle _UL)) > 1500)) then 
	{
	//[_unitG,_HQ,[_posX,_posY]] spawn HAL_SCargo
	[[_unitG,_HQ,[_posX,_posY]],HAL_SCargo] call RYD_Spawn;
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
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
		{
		deleteMarker ("markRecon" + str (_unitG))
		};
	_unitG setVariable [("Busy" + (str _unitG)),false];
	};
	
_AV = assignedVehicle _UL;
_DAV = assigneddriver _AV;
_GDV = group _DAV;
_alive = false;
_timer = 0;
_task = taskNull;

[_unitG] call RYD_WPdel;


if (not (isNull _AV) and ((_HQ getVariable ["RydHQ_CargoFind",0]) > 0) and not (_GDV == _unitG) and not (_IsAPlayer)) then
	{
	_task = [(leader _unitG),["Embark your lift to the objective for reconnaissance.", "Get In Lift", ""],(getPosATL (leader _unitG)),"getin"] call RYD_AddTask;
	
	_wp = [_unitG,_AV,"GETIN"] call RYD_WPadd;
	_wp waypointAttachVehicle _AV;
	_wp setWaypointCompletionRadius 750;

	{if (not (isPlayer (leader _unitG)) and not (_GDV == _unitG))  then {_x assignAsCargo _AV; [[_x],true] remoteExecCall ["orderGetIn",0]}} foreach (units _unitG);

	_cause = [_unitG,1,false,0,300,[],true,false,true,false,false,false] call RYD_Wait;
	_timer = _cause select 0;
	_AV land 'NONE';
	};

if (isNil "_timer") then {_timer = 0};

if ((isNull (leader (_this select 0))) or (_timer > 300)) exitwith 
	{

	{if (not (isPlayer (leader _unitG)) and not (_GDV == _unitG)) then {[_x] remoteExecCall ["RYD_MP_unassignVehicle",0]; [[_x],false] remoteExecCall ["orderGetIn",0];}} foreach (units _unitG);

	if not (_task isEqualTo taskNull) then {[_task,"CANCELED",true] call BIS_fnc_taskSetState};
	_unitG setVariable [("Busy" + (str _unitG)),false];

	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markRecon" + str (_unitG))};
	if not (isNull _GDV) then 
		{
		[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 0];
		_GDV setVariable [("CargoM" + (str _GDV)), false];
		}
	};

if not (_task isEqualTo taskNull) then {[_task,"SUCCEEDED",true] call BIS_fnc_taskSetState};

*/
_AV = assignedVehicle _UL;
_DAV = assignedDriver _AV;
_GDV = group _DAV;
_EnNearTrg = false;
_NeNMode = false;
_halfway = false;

_wp0 = [];
_wp = [];
_nW = 1;

_LX1 = _posX;
_LY1 = _posY;

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

if ((isNull _AV) and (([_posX,_posY] distance _UL) > RydxHQ_CargoObjRange) and (RydxHQ_ReconCargo) and not (_isAPlayer)) then
	{
	_LX = (getPosATL _UL) select 0;
	_LY = (getPosATL _UL) select 1;

//	_beh = "SAFE";
//	_spd = "LIMITED";
	_spd = "NORMAL";
	_beh = "AWARE";
	_TO = [0,0,0];
	if (_NeNMode) then {_spd = "NORMAL";_TO = [40, 45, 50];_beh = "AWARE"};

	_wp0 = [_unitG,[_posX,_posY],"MOVE",_beh,"GREEN",_spd,["true","deletewaypoint [(group this), 0];"],true,0,_TO] call RYD_WPadd;
	
	_nW = 2;

	_endThis = false;

	waitUntil
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
		_CargoCheck = _unitG getVariable ("CC" + _unitvar);
		if (isNil ("_CargoCheck")) then {_unitG setVariable [("CC" + _unitvar), true]};
		
		_AV = assignedVehicle _UL;

		if not (isNull _AV) then { 

			{
				if (isNull (assignedVehicle _x)) then {_x assignAsCargo _AV};
			} forEach (units _unitG);
		};

		if (((_HQ getVariable ["RydHQ_CargoFind",0]) > 0) and not (_IsAPlayer) and (isNull _AV) and (([_posX,_posY] distance (vehicle _UL)) > 1000) and not (_unitG getVariable ["CargoCheckPending" + (str _unitG),false])) then 
			{
			//[_unitG,_HQ,[_posX,_posY]] spawn HAL_SCargo
			[[_unitG,_HQ,[_posX,_posY]],HAL_SCargo] call RYD_Spawn;
			} 
		else 
			{
			if not (_unitG getVariable ["CargoCheckPending" + (str _unitG),false]) then {_unitG setVariable [("CC" + _unitvar), true]};
			};
			
		if (((_HQ getVariable ["RydHQ_CargoFind",0]) > 0) and not (_IsAPlayer) and not (_unitG getVariable ["CargoCheckPending" + (str _unitG),false])) then 
			{	
			waitUntil 
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
					_cc = (_unitG getVariable ("CC" + _unitvar))
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
			if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
				{
				deleteMarker ("markRecon" + str (_unitG))
				};
			_unitG setVariable [("Busy" + (str _unitG)),false];
			(true)
			};

		_AV = assignedVehicle _UL;

		_DAV = assignedDriver _AV;
		_GDV = group _DAV;

		if (not (isNull _AV) and ((_HQ getVariable ["RydHQ_CargoFind",0]) > 0) and not (_GDV == _unitG) and not (_IsAPlayer)) then
			{
			_task = taskNull;
			_timer2 = 0;	

			_endThis = true;
			
			[_unitG] call RYD_WPdel;

			_task = [(leader _unitG),["Embark your lift", "Get In Lift", ""],(getPosATL (leader _unitG)),"getin"] call RYD_AddTask;

			_wp = [_unitG,_AV,"GETIN"] call RYD_WPadd;
			_wp waypointAttachVehicle _AV;
			_wp setWaypointCompletionRadius 750;

			{if (not (isPlayer (leader _unitG)) and not (_GDV == _unitG))  then {_x assignAsCargo _AV; [[_x],true] remoteExecCall ["orderGetIn",0];}} forEach (units _unitG);

			_cause = [_unitG,1,false,0,300,[],true,false,true,false,false,false] call RYD_Wait;
			_timer2 = _cause select 0;
			_AV land 'NONE';

			if not (_task isEqualTo taskNull) then {[_task,"SUCCEEDED",true] call BIS_fnc_taskSetState};

			if (isNil "_timer2") then {_timer2 = 0};

			if ((isNull (leader (_this select 0))) or (_timer2 > 300)) exitWith 
				{

				{if (not (isPlayer (leader _unitG)) and not (_GDV == _unitG)) then {[_x] remoteExecCall ["RYD_MP_unassignVehicle",0]; [[_x],false] remoteExecCall ["orderGetIn",0];}} forEach (units _unitG);

				if not (_task isEqualTo taskNull) then {[_task,"CANCELED",true] call BIS_fnc_taskSetState};

				if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markRecon" + str (_unitG))};
				if not (isNull _GDV) then 
					{
					[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 0];
					_GDV setVariable [("CargoM" + (str _GDV)), false];
					};
				_unitG setVariable [("Busy" + (str _unitG)),false];
				(true)
				};
			};

		//New Cargo!!!

		(_endThis)
		};	
	};

if not (_unitG getVariable [("Busy" + (str _unitG)),false]) exitWith {};

_AV = assignedVehicle _UL;
_DAV = assignedDriver _AV;
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
	_tooC2 = _eClose2 select 0;
	_dstEM2 = _eClose2 select 1;
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

_task = [(leader _unitG),["Perform reconnaissance of the designated area. Identify enemy positions. Avoid detection.", "Perform Recon", ""],[_posX,_posY],"scout"] call RYD_AddTask;

_Ctask = taskNull;

if (not ((leader _GDV) == (leader _unitG)) and not (_GDV == _unitG)) then
	{
	_Ctask = [(leader _GDV),["Disembark " + (groupId _unitG) + " at  their designated destination.", "Drop Off " + (groupId _unitG), ""],[_dropposX,_dropposY],"getout"] call RYD_AddTask
	};

_gp = _unitG;
if (not (isNull _AV) and not (_GDV == _unitG) and not (_isAPlayer)) then {_gp = _GDV;_posX = _dropposX;_posY = _dropposY};
_pos = [_posX,_posY];
_tp = "MOVE";
//if (not (isNull _AV) and (_unitG in (_HQ getVariable ["RydHQ_NCrewInfG",[]]))) then {_tp = "UNLOAD"};
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


if (not (isNull _AV) and (_GDV in (_HQ getVariable ["RydHQ_AirG",[]])) or (_unitG in (_HQ getVariable ["RydHQ_RAirG",[]]))) then {_beh = "STEALTH"};
_spd = "NORMAL";
//if ((isNull _AV) and (([_posX,_posY] distance _UL) > 1000) and not (_NeNMode)) then {_spd = "LIMITED";_beh = "SAFE"};
_TO = [0,0,0];
if ((isNull _AV) and (([_posX,_posY] distance _UL) <= 1000) or ((_NeNMode) and (isNull _AV))) then {_TO = [40, 45, 50]};
_crr = false;
if ((_nW == 1) and (isNull _AV)) then {_crr = true};
if not (isNull _AV) then {_crr = true};
_sts = ["true","deletewaypoint [(group this), 0];"];
if (((group (assignedDriver _AV)) in (_HQ getVariable ["RydHQ_AirG",[]])) and (_unitG in (_HQ getVariable ["RydHQ_NCrewInfG",[]]))) then {_sts = ["true","(vehicle this) land 'GET OUT';deletewaypoint [(group this), 0]"]};

_wp = [_gp,_pos,_tp,_beh,"GREEN",_spd,_sts,_crr,0.001,_TO] call RYD_WPadd;

//---------------------------------

_posX = _SpX;
_posY = _SpY;
_pos = [_posX,_posY];

_DAV = assignedDriver _AV;
_alive = true;
_timer = 0;
_OtherGroup = false;
_GDV = group _DAV;
_enemy = false;

if not (_IsAPlayer) then {
	if not (((group _DAV) == (group _UL)) or (isNull (group _DAV))) then 
		{
		//if (_AV isKindOf "Air") then {_lz = [_pos] call RYD_LZ};

		_OtherGroup = true;

		_cause = [_GDV,6,true,400,30,[(_HQ getVariable ["RydHQ_AirG",[]]),(_HQ getVariable ["RydHQ_KnEnemiesG",[]])],false] call RYD_Wait;
		_timer = _cause select 0;
		_alive = _cause select 1;
		_enemy = _cause select 2;
		}
	else 
		{
	//	_unitG setVariable ["RydHQ_WaitingObjective",[_HQ,_trg]];
		if not (_isAPlayer) then {_unitG setVariable ["InfGetinCheck" + (str _unitG),true]};
		_enRg = 400;
		if (_unitG in (_HQ getVariable ["RydHQ_AirG",[]])) then {_enRg = 1000};
		_cause = [_unitG,6,true,_enRG,30,[(_HQ getVariable ["RydHQ_AirG",[]]),(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),_HQ],false] call RYD_Wait;
		_timer = _cause select 0;
		_alive = _cause select 1;
		_enemy = _cause select 2;
		};
};

_DAV = assignedDriver _AV;
if (((_timer > 30) or (_enemy)) and (_OtherGroup)) then {if not (isNull _GDV) then {[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 0]}};
if (((_timer > 30) or (_enemy)) and not (_OtherGroup)) then {[_unitG, (currentWaypoint _unitG)] setWaypointPosition [getPosATL (vehicle _UL), 0]};
if (not (_alive) and not (_OtherGroup)) exitWith 
	{
	_unitG setVariable [("Busy" + (str _unitG)),false];
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
		{
		deleteMarker ("markRecon" + str (_unitG))
		};
	if not (isNull _GDV) then 
		{
		[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 0];
		_GDV setVariable [("CargoM" + (str _GDV)), false];
		};
	};

if (isNull (leader (_this select 0))) exitWith 
	{
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
		{
		deleteMarker ("markRecon" + str (_unitG))
		};

	_unitG setVariable [("Busy" + (str _unitG)),false];

	if not (isNull _GDV) then 
		{
		[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 0];
		_GDV setVariable [("CargoM" + (str _GDV)), false];
		};
	};

_UL = leader _unitG;if not (isPlayer _UL) then {if (not (_halfway) and (_timer <= 30) and not (_enemy)) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdFinal,"OrdFinal"] call RYD_AIChatter}}};

_AV = assignedVehicle _UL;
_pass = assignedCargo _AV;

_allowed = true;
if not ((_GDV == _unitG) or (isNull _GDV)) then 
	{
	{[[_x],false] remoteExecCall ["orderGetIn",0]} forEach _pass;
	_allowed = false;
	(units _unitG) allowGetIn false;
	[_unitG] call RYD_WPdel;
	//if (player in (units _unitG)) then {diag_log "NOT ALLOW capt"};
	}
else
	{
	//if (_unitG in (_HQ getVariable ["RydHQ_NCrewInfG",[]])) then {_pass orderGetIn false};
	};

//if not (isNull _lz) then {deleteVehicle _lz};

_DAV = assignedDriver _AV;
_GDV = group _DAV;

if (not (isNull _AV) and ((_HQ getVariable ["RydHQ_CargoFind",0]) > 0) and (_unitG in (_HQ getVariable ["RydHQ_NCrewInfG",[]])) and not (_GDV == _unitG) and not (_IsAPlayer)) then
	{
	_pass = (units _unitG);
	_cause = [_unitG,1,false,0,240,[],true,true,false,false,false,false,false,_pass,_AV] call RYD_Wait;
	_timer = _cause select 0
	};

if not ((_GDV == _unitG) or (isNull _GDV)) then 
	{
	{[[_x],false] remoteExecCall ["orderGetIn",0]} forEach (units _unitG);
	{[_x] remoteExecCall ["RYD_MP_unassignVehicle",0];} forEach (units _unitG);
	};

if not (_allowed) then {(units _unitG) allowGetIn true};
if (_HQ getVariable ["RydHQ_LZ",false]) then {deleteVehicle _lz};

if ((({alive _x} count (units _unitG)) < 1) or (_timer > 240)) exitWith 
	{
	if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
		{
		deleteMarker ("markRecon" + str (_unitG))
		};

	_unitG setVariable [("Busy" + (str _unitG)),false];

	if not (_Ctask isEqualTo taskNull) then {[_Ctask,"CANCELED",true] call BIS_fnc_taskSetState};

	if not (isNull _GDV) then 
		{
		[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 0];
		_GDV setVariable [("CargoM" + (str _GDV)), false];
		//_pass orderGetIn true;
		}
	};

if not (_Ctask isEqualTo taskNull) then {[_Ctask,"SUCCEEDED",true] call BIS_fnc_taskSetState};

_unitvar = str _GDV;
_timer = 0;
if (not (isNull _GDV) and not (_GDV == _unitG) and (_GDV in (_HQ getVariable ["RydHQ_AirG",[]])) and not (isPlayer (leader _GDV)) and not (_IsAPlayer)) then
	{
	_wp = [_GDV,[((getPosATL _AV) select 0) + (random 200) - 100,((getPosATL _AV) select 1) + (random 200) - 100,1000],"MOVE","STEALTH","YELLOW","NORMAL"] call RYD_WPadd;
	
	_cause = [_GDV,3,true,0,8,[],false] call RYD_Wait;
	_timer = _cause select 0;

	if (_timer > 8) then {[_GDV, (currentWaypoint _GDV)] setWaypointPosition [getPosATL (vehicle (leader _GDV)), 0]};
	};

if not (_IsAPlayer) then {_GDV setVariable [("CargoM" + (str _GDV)), false]};

_alive = true;
if ((_halfway) and not (_IsAPlayer)) then
	{
	_beh = "AWARE";
	if (_unitG in (_HQ getVariable ["RydHQ_RAirG",[]])) then {_beh = "STEALTH"};
	_frm = formation _unitG;
	if not (isPlayer (leader _unitG)) then {_frm = "STAG COLUMN"};

	_wp = [_unitG,[_posX,_posY],"MOVE",_beh,"GREEN","NORMAL",["true","deletewaypoint [(group this), 0];"],true,0.001,[0,0,0],_frm] call RYD_WPadd;

//	_unitG setVariable ["RydHQ_WaitingObjective",[_HQ,_trg]];
	if not (_isAPlayer) then {_unitG setVariable ["InfGetinCheck" + (str _unitG),true]};
	_cause = [_unitG,6,true,0,30,[],false] call RYD_Wait;
	_timer = _cause select 0;
	_alive = _cause select 1;

	if not (_alive) exitWith {_unitG setVariable [("Busy" + (str _unitG)),false];if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markAttack" + str (_unitG))}};
	if (_timer > 30) then {[_unitG, (currentWaypoint _unitG)] setWaypointPosition [getPosATL (vehicle _UL), 0]};
	};

if not (_alive) exitWith {_unitG setVariable [("Busy" + (str _unitG)),false];};

if ((_HQ getVariable ["RydHQ_UAVAlt",150]) > 0) then
	{
	[_unitG,_PosObj1,_HQ] call RYD_deployUAV
	};

_beh = "AWARE";
if (_unitG in (_HQ getVariable ["RydHQ_RAirG",[]])) then {_beh = "STEALTH"};
_frm = formation _unitG;
if not (isPlayer (leader _unitG)) then {_frm = "WEDGE"};

_UL = leader _unitG;if not (isPlayer _UL) then {if ((_halfway) and (_timer <= 30)) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdFinal,"OrdFinal"] call RYD_AIChatter}}};

_wp = [_unitG,[_posX,_posY],"SAD",_beh,"GREEN","NORMAL",["true","deletewaypoint [(group this), 0];"],true,0.001,[0,0,0],_frm] call RYD_WPadd;

//_unitG setVariable ["RydHQ_WaitingObjective",[_HQ,_trg]];
if not (_isAPlayer) then {_unitG setVariable ["InfGetinCheck" + (str _unitG),true]};
_enRg = 250;
if (_unitG in (_HQ getVariable ["RydHQ_AirG",[]])) then {_enRg = 1000};
_cause = [_unitG,6,true,_enRg,30,[(_HQ getVariable ["RydHQ_AirG",[]]),(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),_HQ],false] call RYD_Wait;
_alive = _cause select 1;

if not (_alive) exitWith {_unitG setVariable [("Busy" + (str _unitG)),false];if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markRecon" + str (_unitG))}};
if ((count (waypoints _unitG)) >= 1) then {deleteWaypoint [_unitG, 1]};

if (_stage >= 4) then {_HQ setVariable ["RydHQ_ReconDone",true]};

if (_unitG in (_HQ getVariable ["RydHQ_FOG",[]])) then
	{
	_beh = "STEALTH";
	if (_unitG in (_HQ getVariable ["RydHQ_RAirG",[]])) then {_beh = "STEALTH"};
	_frm = formation _unitG;
	if not (isPlayer (leader _unitG)) then {_frm = "WEDGE"};

	_wp = [_unitG,[_posX,_posY],"MOVE",_beh,"GREEN","NORMAL",["true","deletewaypoint [(group this), 0];"],true,0.001,[0,0,0],_frm] call RYD_WPadd;

	if not (_isAPlayer) then {_unitG setVariable ["InfGetinCheck" + (str _unitG),true]};
	_enRg = 150;
	if (_unitG in (_HQ getVariable ["RydHQ_AirG",[]])) then {_enRg = 750};
	_cause = [_unitG,6,true,_enRg,120,[(_HQ getVariable ["RydHQ_AirG",[]]),(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),_HQ],false] call RYD_Wait;
	_timer = _cause select 0;
	_alive = _cause select 1;
	_enemy = _cause select 2
	};

if not (_alive) exitWith {_unitG setVariable [("Busy" + (str _unitG)),false];if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markRecon" + str (_unitG))}};
if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {_i setMarkerColor "ColorBlue"};

[_unitG] call RYD_WPdel;


//Specialised behavior disabled until bug fixing complete
//if not (_specialized) exitWith
if (true) exitWith	
	{

	if not (isNull _unitG) then
		{
		if (({alive _x} count (units _unitG)) > 0) then
			{
			if not (isNull (_UL findNearestEnemy _UL)) then
				{
				if (_unitG in (_HQ getVariable ["RydHQ_AirG",[]])) then {
					_End = _PosLand;_rd = 0
				} else {
					if ((count (_HQ getVariable ["RydHQ_Taken",[]])) > 0) then {_End = (([(_HQ getVariable ["RydHQ_Taken",[]]), [], {(position (leader _unitG)) distance _x }, "ASCEND",{true}] call BIS_fnc_sortBy) select 0); _End = getPosATL _End;} else {_End = [((getPosATL (leader _HQ)) select 0) + (random 400) - 200,((getPosATL (leader _HQ)) select 1) + (random 400) - 200];};
					_isWater = surfaceIsWater _End; 
					if (_isWater) then {_End = [((getPosATL (leader _HQ)) select 0) + (random 40) - 20,((getPosATL (leader _HQ)) select 1) + (random 40) - 20]}
				};

				if not (_task isEqualTo taskNull) then
					{
						
					[_task,(leader _unitG),["Break away from enemy contact. Stand-by for new orders.", "Break Enemy Contact", ""],_End,"ASSIGNED",0,true,true] call BIS_fnc_SetTask;
						
					};

				_beh = "AWARE";
				if (_unitG in (_HQ getVariable ["RydHQ_RAirG",[]])) then {_beh = "STEALTH"};
				_sts = ["true", "deletewaypoint [(group this), 0];"];
				if (_unitG in (_HQ getVariable ["RydHQ_AirG",[]])) then {_sts = ["true", "{(vehicle _x) land 'LAND'} foreach (units (group this));deletewaypoint [(group this), 0];"]};

				[_unitG] call RYD_WPdel;

				_wp = [_unitG,_End,"MOVE",_beh,"GREEN","FULL",_sts] call RYD_WPadd;
				};

			if not (_unitG getVariable ["RydHQ_MIA",false]) then
				{
				if (_unitG in (_HQ getVariable ["RydHQ_NCrewInfG",[]])) then 
					{
					//_pass allowGetIn true;
					//_pass orderGetIn true
					};
					
				_unitG setVariable [("Busy" + (str _unitG)), false];
				if (not (_task isEqualTo taskNull) and (((leader _unitG) distance _PosObj1) < 750)) then {[_task,"SUCCEEDED",true] call BIS_fnc_taskSetState};
				_UL = leader _unitG;
				if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdEnd,"OrdEnd"] call RYD_AIChatter}};
				}
			else
				{
				_unitG setVariable ["RydHQ_MIA",nil]
				};
				
			if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markRecon" + str (_unitG))}
			};
		};
		_unitG setVariable [("Busy" + (str _unitG)),false];
	};

_timer2 = 0;
_alive = true;

while {(_nothing)} do
	{
	sleep 5;
	_unitG = group (leader (_this select 0));
	if (_unitG getVariable ["Break",false]) then {_nothing = false;_unitG setVariable ["Break",false]};
	if (((not (isNull (_UL findNearestEnemy _UL)) or (_timer2 > 4)) and not (isNull _unitG) and not (_unitG in (_HQ getVariable ["RydHQ_FOG",[]]))) or ((_timer2 > 40) and not (isNull _unitG))) then 
		{

		if (isNull (_UL findNearestEnemy _UL)) exitWith {
			if (_unitG in (((_HQ getVariable ["RydHQ_RAirG",[]]) + (_HQ getVariable ["RydHQ_ReconG",[]]) + (_HQ getVariable ["RydHQ_FOG",[]]) + (_HQ getVariable ["RydHQ_SnipersG",[]]) + (_HQ getVariable ["RydHQ_NCrewInfG",[]]) - ((_HQ getVariable ["RydHQ_SupportG",[]]) + (_HQ getVariable ["RydHQ_NCCargoG",[]])) + _onlyL) - ((_HQ getVariable ["RydHQ_NoRecon",[]]) + (_HQ getVariable ["RydHQ_CargoOnly",[]])))) then 
				{
				_reconAv = _HQ getVariable ["RydHQ_ReconAv",[]];
				_reconAv pushBack _unitG;
				_HQ setVariable ["RydHQ_ReconAv",_reconAv];
				};
				
//			if not (_unitG getVariable ["Break",false]) then {_unitG setVariable [("Busy" + (str _unitG)), false]} else {_unitG setVariable ["Break",false]};
			if (_unitG getVariable ["Break",false]) then {_nothing = false;_unitG setVariable ["Break",false]};
			if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markRecon" + str (_unitG))};
			};

		if (_unitG in (_HQ getVariable ["RydHQ_NCrewInfG",[]])) then 
			{
			//_pass allowGetIn true;
			//_pass orderGetIn true
			};
			
		_rd = 0;
		if (_unitG in (_HQ getVariable ["RydHQ_AirG",[]])) then {
			_End = _PosLand;_rd = 0
		} else {
			if ((count (_HQ getVariable ["RydHQ_Taken",[]])) > 0) then {_End = (([(_HQ getVariable ["RydHQ_Taken",[]]), [], {(position (leader _unitG)) distance _x }, "ASCEND",{true}] call BIS_fnc_sortBy) select 0)} else {_End = [((getPosATL (leader _HQ)) select 0) + (random 400) - 200,((getPosATL (leader _HQ)) select 1) + (random 400) - 200];};
			_isWater = surfaceIsWater _End; 
			if (_isWater) then {_End = [((getPosATL (leader _HQ)) select 0) + (random 40) - 20,((getPosATL (leader _HQ)) select 1) + (random 40) - 20]}
		};

		if not (_task isEqualTo taskNull) then
			{
				
			[_task,(leader _unitG),["Break away from enemy contact. Stand-by for new orders.", "Break Enemy Contact", ""],_End,"ASSIGNED",0,true,true] call BIS_fnc_SetTask;
				
			};

//		_beh = "SAFE";
		_beh = "AWARE";
		if (_unitG in (_HQ getVariable ["RydHQ_RAirG",[]])) then {_beh = "STEALTH"};
		_sts = ["true", "deletewaypoint [(group this), 0];"];
		if (_unitG in (_HQ getVariable ["RydHQ_AirG",[]])) then {_sts = ["true", "{(vehicle _x) land 'LAND'} foreach (units (group this));deletewaypoint [(group this), 0];"]};

		[_unitG] call RYD_WPdel;

		_wp = [_unitG,_End,"MOVE",_beh,"GREEN","FULL",_sts] call RYD_WPadd;

		if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markRecon" + str (_unitG))};
		_nothing = false;
//		_alive = true;

		if not (_nothing) exitWith
			{
			if (_unitG in (((_HQ getVariable ["RydHQ_RAirG",[]]) + (_HQ getVariable ["RydHQ_ReconG",[]]) + (_HQ getVariable ["RydHQ_FOG",[]]) + (_HQ getVariable ["RydHQ_SnipersG",[]]) + (_HQ getVariable ["RydHQ_NCrewInfG",[]]) - ((_HQ getVariable ["RydHQ_SupportG",[]]) + (_HQ getVariable ["RydHQ_NCCargoG",[]])) + _onlyL) - ((_HQ getVariable ["RydHQ_NoRecon",[]]) + (_HQ getVariable ["RydHQ_CargoOnly",[]])))) then 
				{
				_reconAv = _HQ getVariable ["RydHQ_ReconAv",[]];
				_reconAv pushBackUnique _unitG;
				_HQ setVariable ["RydHQ_ReconAv",_reconAv];
				};
				
			if (_unitG getVariable ["Break",false]) then {_nothing = false;_unitG setVariable ["Break",false]};
			_unitG setVariable [("Busy" + (str _unitG)), false];
			}
		};

	if (isNull _unitG) then {_alive = false} else {if (({alive _x} count (units _unitG)) < 1) then {_alive = false;}};
	if (_unitG getVariable ["Break",false]) then {_nothing = false;_alive=false;_unitG setVariable ["Break",false]};
	if not (_alive) exitWith {
		if (isNull (_UL findNearestEnemy _UL)) then {
			if (_unitG in (((_HQ getVariable ["RydHQ_RAirG",[]]) + (_HQ getVariable ["RydHQ_ReconG",[]]) + (_HQ getVariable ["RydHQ_FOG",[]]) + (_HQ getVariable ["RydHQ_SnipersG",[]]) + (_HQ getVariable ["RydHQ_NCrewInfG",[]]) - ((_HQ getVariable ["RydHQ_SupportG",[]]) + (_HQ getVariable ["RydHQ_NCCargoG",[]])) + _onlyL) - ((_HQ getVariable ["RydHQ_NoRecon",[]]) + (_HQ getVariable ["RydHQ_CargoOnly",[]])))) then 
				{
				_reconAv = _HQ getVariable ["RydHQ_ReconAv",[]];
				_reconAv pushBackUnique _unitG;
				_HQ setVariable ["RydHQ_ReconAv",_reconAv];
				};
			};
		if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then {deleteMarker ("markRecon" + str (_unitG))};
		if (_unitG getVariable ["Break",false]) then {_nothing = false;_unitG setVariable ["Break",false]};
		_unitG setVariable [("Busy" + (str _unitG)), false];
		};
	if (_unitG getVariable ["Break",false]) then {_nothing = false;_unitG setVariable ["Break",false]};
	_timer2 = _timer2 + 1;
	};

_unitG setVariable [("Busy" + (str _unitG)), false];

_UL = leader _unitG;if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdEnd,"OrdEnd"] call RYD_AIChatter}};