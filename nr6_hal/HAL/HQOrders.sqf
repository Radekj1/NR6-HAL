//kto si� nadaje do zwiadu, ataku i wsparcia
//cztery (albo tyle, ile cel�w) dywizje
//w kazdej recon i atak
//dodatkowo dywizja rezerwowa dla wzmocnienia ataku najbardziej udanego i oskrzydlenia reszty frontu
//wsparcie strategicznie - lotnictwo i artyleria

_SCRname = "Orders";
diag_log text "HQOrders.sqf started";
private ["_nObj","_Trg","_vHQ","_landE","_dstMin","_dstAct","_dstMin","_PosObj1","_ReconAv","_onlyL","_unitvar","_busy","_Unable","_vehready","_solready","_effective","_ammo","_Gdamage",
	"_nominal","_current","_veh","_forRRes","_RRp","_AttackAv","_FlankAv","_exhausted","_inD","_ResC","_stages","_rcheckArr","_gps","_LMCUA","_reserve","_recvar","_resting","_allT",
	"_deployed","_capturing","_reconthreat","_FOthreat","_snipersthreat","_ATinfthreat","_AAinfthreat","_Infthreat","_Artthreat","_HArmorthreat","_LArmorthreat","_Carsthreat","_reconNr",
	"_Airthreat","_Navalthreat","_Staticthreat","_StaticAAthreat","_StaticATthreat","_Supportthreat","_Cargothreat","_Otherthreat","_GE","_GEvar","_checked","_FPool","_constant",
	"_isAttacked","_captCount","_captLimit","_forCapt","_groupCount","_LMCU","_WADone","_WAchance","_armored","_WAAv","_where","_heldBy","_howMuch","_AAO","_toTake",
	"_taken","_objectives","_BBAOObj","_IsAPlayer","_takenNav","_totakeNav","_forNavCapt","_Navalobjectives"];
params ["_HQ"];

_AAO = _HQ getVariable ["RydHQ_ChosenAAO",false];

_HQ setVariable ["RydHQ_DefDone",false];

_distances = [];

_HQ setVariable ["RydHQ_NearestE",ObjNull];

_nObj = _HQ getVariable ["RydHQ_NObj",1];
_BBAOObj = _HQ getVariable ["RydHQ_BBAOObj",1];
diag_log text "HQOrders get objectives";
switch (_nObj) do
	{
	case (1) : {_HQ setVariable ["RydHQ_Obj",(_HQ getVariable ["RydHQ_Obj1",(leader _HQ)])]};
	case (2) : {_HQ setVariable ["RydHQ_Obj",(_HQ getVariable ["RydHQ_Obj2",(leader _HQ)])]};
	case (3) : {_HQ setVariable ["RydHQ_Obj",(_HQ getVariable ["RydHQ_Obj3",(leader _HQ)])]};
	default {_HQ setVariable ["RydHQ_Obj",(_HQ getVariable ["RydHQ_Obj4",(leader _HQ)])]};
	case (5) : {_HQ setVariable ["RydHQ_Obj",(leader _HQ)]};
	};

//if (_HQ getVariable ["BBDEF",false]) then {_HQ setVariable ["RydHQ_Obj",objNull]};

_Trg = _HQ getVariable ["RydHQ_Obj", (leader _HQ)];

_vHQ = vehicle (leader _HQ);

_landE = (_HQ getVariable ["RydHQ_KnEnemiesG",[]]) - ((_HQ getVariable ["RydHQ_EnNavalG",[]]) + (_HQ getVariable ["RydHQ_EnAirG",[]]));
if ((count _landE) > 0) then 
	{
	_HQ setVariable ["RydHQ_NearestE",_landE select 0];
	_dstMin = (vehicle (leader (_landE select 0))) distance _vHQ;
	
		{
		_dstAct = (vehicle (leader _x)) distance _vHQ;
		if (_dstAct < _dstMin) then
			{
			_dstMin = _dstAct;
			_HQ setVariable ["RydHQ_NearestE",_x];
			}
		
		}
	foreach _landE;
	_Trg = vehicle (leader (_HQ getVariable ["RydHQ_NearestE",grpNull]));
	diag_log text "Land Target Acquired";
	};

_ReconAv = [];
_onlyL = (_HQ getVariable ["RydHQ_LArmorG",[]]) - (_HQ getVariable ["RydHQ_MArmorG",[]]);

if not ((_HQ getVariable ["RydHQ_ReconReserve",0]) > 0) then {_HQ setVariable ["RydHQ_ReconG",[]];};

diag_log text "HQOrders - Air start";
	{
	if not (isNull _x) then
		{
		_unitvar = str _x;
		if (_HQ getVariable ["RydHQ_Orderfirst",true]) then {_x setVariable ["Nominal" + _unitvar,(count (units _x))]};
		_busy = false;
		_Unable = false;
		_busy = _x getVariable ("Busy" + _unitvar);
		_Unable = _x getvariable "Unable";
		if (isNil ("_Unable")) then {_Unable = false};
		if (isNil ("_busy")) then {_busy = false};
		_vehready = true;
		_solready = true;
		_effective = true;
		_ammo = true;
		_Gdamage = 0;
		
		_IsAPlayer = false;
		if (RydxHQ_NoRestPlayers and (isPlayer (leader _x))) then {_IsAPlayer = true};
		
		if (([_x,(_HQ getVariable ["RydHQ_NCVeh",[]])] call RYD_AmmoFullCount) < 0.15) then 
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
			foreach (units _x)
			};
			
		_nominal = _x getVariable ("Nominal" + (str _x));if (isNil "_nominal") then {_x setVariable ["Nominal" + _unitvar,(count (units _x))];_nominal = _x getVariable ("Nominal" + (str _x))};
		_current = count (units _x);
		_Gdamage = _Gdamage + (_nominal - _current);

		if (((_Gdamage/(_current + 0.1)) > (0.4*(((_HQ getVariable ["RydHQ_Recklessness",0.5])/1.2) + 1))) or not (_effective) or not (_ammo)) then 
			{
			_solready = false;
			if not (_ammo) then
				{
				_x setVariable ["LackAmmo",true]
				}
			};

		_ammo = 0;
		_veh = ObjNull;

			{
			_veh = assignedvehicle _x;
			if (not (isNull _veh) and (not (canMove _veh) or ((fuel _veh) <= 0.1) or ((damage _veh) > 0.5) or (((group _x) in (((_HQ getVariable ["RydHQ_AirG",[]]) - ((_HQ getVariable ["RydHQ_NCAirG",[]]) + (_HQ getVariable ["RydHQ_RAirG",[]]))) + ((_HQ getVariable ["RydHQ_HArmorG",[]]) + (_HQ getVariable ["RydHQ_LArmorG",[]]) + ((_HQ getVariable ["RydHQ_CarsG",[]]) - ((_HQ getVariable ["RydHQ_NCCargoG",[]]) + (_HQ getVariable ["RydHQ_SupportG",[]])))))) and ((count (magazines _veh)) == 0)))) exitwith {_vehready = false};
			}
		foreach (units _x);

		if (_IsAPlayer) then {_vehready = true; _solready = true;};

		if (not (_x in (_ReconAv + (_HQ getVariable ["RydHQ_SpecForG",[]]))) and not (_busy) and not (_Unable) and (_vehready) and ((_solready) or (_x in (_HQ getVariable ["RydHQ_RAirG",[]])))) then {_ReconAv pushBack _x};
		}
	}
foreach (((_HQ getVariable ["RydHQ_RAirG",[]]) + (_HQ getVariable ["RydHQ_ReconG",[]]) + (_HQ getVariable ["RydHQ_FOG",[]]) + (_HQ getVariable ["RydHQ_SnipersG",[]]) + (_HQ getVariable ["RydHQ_NCrewInfG",[]]) - ((_HQ getVariable ["RydHQ_SupportG",[]]) + (_HQ getVariable ["RydHQ_NCCargoG",[]])) + _onlyL) - ((_HQ getVariable ["RydHQ_NoRecon",[]]) + (_HQ getVariable ["RydHQ_AmmoDrop",[]]) + (_HQ getVariable ["RydHQ_CargoOnly",[]])));
diag_log text "HQOrders - Air Done, calling RYD_RandomOrd";
_ReconAv = [_ReconAv] call RYD_RandomOrd;
diag_log text "HQOrders - RYD_RandomOrd finished";
_ReconAv = _ReconAv - (_HQ getVariable ["RydHQ_AOnly",[]]);

if not (_HQ getVariable ["RydHQ_ChosenEBDoctrine",false]) then
	{
	if ((_HQ getVariable ["RydHQ_ReconReserve",0]) > 0) then 
		{
		_forRRes = (_ReconAv - (_HQ getVariable ["RydHQ_RAirG",[]]));
		for [{_b = 0},{_b < (floor ((count _forRRes)*(_HQ getVariable ["RydHQ_ReconReserve",0])))},{_b = _b + 1}] do
			{
			_RRp = _forRRes select _b;
			_ReconAv = _ReconAv - [_RRp];
			}
		}
	};
diag_log text "RydHQ_ChosenEBDoctrine passed";		
_HQ setVariable ["RydHQ_ReconAv",_ReconAv];

_AttackAv = [];
_FlankAv = [];
_exhausted = _HQ getVariable ["RydHQ_Exhausted",[]];

{

	if not (_x getvariable [("Resting" + (str _x)),false]) then {_exhausted = _exhausted - [_x]}
} foreach _exhausted;
diag_log text "_exhausted passed";
	{
	if ((typeName _x) in [(typeName grpNull)]) then
		{
		if not (isNull _x) then
			{
			_unitvar = str _x;
			if (_HQ getVariable ["RydHQ_Orderfirst",true]) then {_x setVariable [("Nominal" + _unitvar),(count (units _x))]};
			_busy = false;
			_Unable = false;
			_busy = _x getvariable ("Busy" + _unitvar);
			_Unable = _x getvariable "Unable";
			if (isNil ("_Unable")) then {_Unable = false};
			if (isNil ("_busy")) then {_busy = false};
			_vehready = true;
			_solready = true;
			_effective = true;
			_ammo = true;
			_Gdamage = 0;

			_IsAPlayer = false;
			if (RydxHQ_NoRestPlayers and (isPlayer (leader _x))) then {_IsAPlayer = true};
			
			if (([_x,(_HQ getVariable ["RydHQ_NCVeh",[]])] call RYD_AmmoFullCount) < 0.15) then 
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
				foreach (units _x)
				};
				
			_nominal = _x getVariable ("Nominal" + (str _x));if (isNil "_nominal") then {_x setVariable ["Nominal" + _unitvar,(count (units _x))];_nominal = _x getVariable ("Nominal" + (str _x))};
			_current = count (units _x);
			_Gdamage = _Gdamage + (_nominal - _current);
			if (((_Gdamage/(_current + 0.1)) > (0.4*(((_HQ getVariable ["RydHQ_Recklessness",0.5])/1.2) + 1))) or not (_effective) or not (_ammo)) then {_solready = false};
			_ammo = 0;

				{
				_veh = assignedvehicle _x;
				if (not (isNull _veh) and (not (canMove _veh) or ((fuel _veh) <= 0.1) or ((damage _veh) > 0.5) or (((group _x) in (((_HQ getVariable ["RydHQ_AirG",[]]) - (_HQ getVariable ["RydHQ_NCAirG",[]])) + ((_HQ getVariable ["RydHQ_HArmorG",[]]) + (_HQ getVariable ["RydHQ_LArmorG",[]]) + ((_HQ getVariable ["RydHQ_CarsG",[]]) - ((_HQ getVariable ["RydHQ_NCCargoG",[]]) + (_HQ getVariable ["RydHQ_SupportG",[]])))))) and ((count (magazines _veh)) == 0)))) exitwith {_vehready = false};
				}
			foreach (units _x);

			if (_IsAPlayer) then {_vehready = true; _solready = true;};
			
			if (not (_x in _AttackAv) and not (_busy) and not (_Unable) and not (_x in _FlankAv) and (_vehready) and (_solready) and not (_x in ((_HQ getVariable ["RydHQ_StaticG",[]]) + (_HQ getVariable ["RydHQ_ArtG",[]]) + (_HQ getVariable ["RydHQ_SpecForG",[]]) + (_HQ getVariable ["RydHQ_AmmoDrop",[]]) + (_HQ getVariable ["RydHQ_CargoOnly",[]]) - (_HQ getVariable ["RydHQ_NavalG",[]])))) then {_AttackAv pushBack _x};
			if (not (_x in _exhausted) and ((_HQ getVariable ["RydHQ_Withdraw",1]) > 0) and not (_IsAPlayer) and (not (_vehready) or not (_solready))) then 
				{
				_exhausted pushBack _x;
				};
	 
			if (((_HQ getVariable ["RydHQ_Withdraw",1]) > 0) and not (_x in ((_HQ getVariable ["RydHQ_SpecForG",[]]) + (_HQ getVariable ["RydHQ_SnipersG",[]])))) then
				{
				_inD = _x getVariable "NearE";
				if (isNil "_inD") then {_inD = 0};
				if (not (_x in _exhausted) and (((random (2 + (_HQ getVariable ["RydHQ_Recklessness",0.5]))) max 0.5) < (_inD * (_HQ getVariable ["RydHQ_Withdraw",1])))) then 
					{
					_recvar = str _x;
					_resting = _x getvariable ("Resting" + _recvar);
					if (isNil ("_resting")) then {_resting = false};
					_Unable = _x getvariable "Unable";
					if (isNil ("_Unable")) then {_Unable = false};
					
					if (not (_resting) and not (_Unable) and not (_IsAPlayer)) then
						{
						[_x,_HQ,true] call HAL_GoRest;
						//_exhausted pushBack _x
						}
					}; 
				};
			}
		}
	}
foreach (((_HQ getVariable ["RydHQ_Friends",[]]) - ((_HQ getVariable ["RydHQ_reconG",[]]) + (_HQ getVariable ["RydHQ_FOG",[]]) + ((_HQ getVariable ["RydHQ_NCCargoG",[]]) - (_HQ getVariable ["RydHQ_NCrewInfG",[]])) + (_HQ getVariable ["RydHQ_SupportG",[]]))) - (_HQ getVariable ["RydHQ_NoAttack",[]]));

diag_log text "_AttackAv = [_AttackAv] call RYD_RandomOrd;";
_AttackAv = [_AttackAv] call RYD_RandomOrd;
diag_log text "Call finished";

_AttackAv = _AttackAv - (_HQ getVariable ["RydHQ_ROnly",[]]);

diag_log text "Calling HQOrdersEast";
if (_HQ getVariable ["RydHQ_ChosenEBDoctrine",false]) exitWith {[_HQ,_ReconAv,_AttackAv] call HAL_HQOrdersEast};
diag_log text "Call finished";

if ((_HQ getVariable ["RydHQ_AttackReserve",0]) > 0) then 
	{
	for [{_g = 0},{_g < floor ((count _AttackAv)*(_HQ getVariable ["RydHQ_AttackReserve",0.5]))},{_g = _g + 1}] do
		{
		_ResC = _AttackAv select _g;
		if (not (_ResC in (_HQ getVariable ["RydHQ_FirstToFight",[]])) and not (isPlayer (leader _ResC))) then 
			{
			_AttackAv = _AttackAv - [_ResC];
			if not (_HQ getVariable ["RydHQ_FlankingDone",false]) then {if ((random 100 > (30/(0.5 + (_HQ getVariable ["RydHQ_Fineness",0.5])))) and not (_ResC in _FlankAv)) then {_FlankAv pushBack _ResC}}
			};
		}
	};

{
	if ((({alive _x} count (units _x)) == 0) or (_x == grpNull)) then {_exhausted = _exhausted - [_x]};
} foreach _exhausted;
diag_log text "Attack reserve exhaustion passed";

_FlankAv = _FlankAv - ((_HQ getVariable ["RydHQ_NoFlank",[]]) + (_HQ getVariable ["RydHQ_AOnly",[]]) + (_HQ getVariable ["RydHQ_ROnly",[]]));
_HQ setVariable ["RydHQ_AttackAv",_AttackAv];
_HQ setVariable ["RydHQ_FlankAv",_FlankAv];
_HQ setVariable ["RydHQ_CombatAv",_FlankAv + _AttackAv];
_HQ setVariable ["RydHQ_Exhausted",_exhausted];
_timeStamp = _HQ getVariable ["RydHQ_FlankingTimeStamp",0];

diag_log text "HQOrders Flanking";

if not (_HQ getVariable ["RydHQ_FlankingInit",false]) then 
	{
	if not ((_HQ getVariable ["RydHQ_Order","ATTACK"]) == "DEFEND") then
		{
		if (_HQ getVariable ["RydHQ_FlankReady",false]) then
			{
			if ((_HQ getVariable ["RydHQ_FlankingTimeStamp",0]) == 0) then {_HQ setVariable ["RydHQ_FlankingTimeStamp",time]};
			_timeStamp = _HQ getVariable ["RydHQ_FlankingTimeStamp",0];
			if ((count (_HQ getVariable ["RydHQ_KnEnemies",[]])) > 0) then
				{
				if not (_HQ getVariable ["RydHQ_DefDone",false]) then
					{
					_obj = getPosATL (_HQ getVariable ["RydHQ_Obj",(leader _HQ)]);

					if ((_AAO) or (_HQ getVariable ["RydHQ_SimpleMode",false])) then
						{
						_obj = _HQ getVariable ["RydHQ_EyeOfBattle",getPosATL (vehicle (leader _HQ))]
						};
				
					_gap = (time - _timeStamp) - (60 * (1 + ((vehicle (leader _HQ)) distance _obj)/1000));
					if (_gap > 0) then
						{
						_HQ setVariable ["RydHQ_FlankingInit",true];
						diag_log text "Call HAL_Flanking";
						[_HQ] call HAL_Flanking;
						diag_log text "Call finished";
						}
					}
				}
			}
		}
	};
	
_toRecon = [_HQ getVariable "RydHQ_Obj"];

if (_BBAOObj > 1) then {

	_toRecon = [_HQ getVariable "RydHQ_Obj1",_HQ getVariable "RydHQ_Obj2",_HQ getVariable "RydHQ_Obj3",_HQ getVariable "RydHQ_Obj4"];

	_toRecon resize _BBAOObj;

	if ((_HQ getvariable ["BBObj1Done",false]) and ((_HQ getVariable ["RydHQ_Obj1",(leader _HQ)]) in _toRecon)) then {_toRecon = _toRecon - [(_HQ getVariable ["RydHQ_Obj1",(leader _HQ)])]};
	if ((_HQ getvariable ["BBObj2Done",false]) and ((_HQ getVariable ["RydHQ_Obj2",(leader _HQ)]) in _toRecon)) then {_toRecon = _toRecon - [(_HQ getVariable ["RydHQ_Obj2",(leader _HQ)])]};
	if ((_HQ getvariable ["BBObj3Done",false]) and ((_HQ getVariable ["RydHQ_Obj3",(leader _HQ)]) in _toRecon)) then {_toRecon = _toRecon - [(_HQ getVariable ["RydHQ_Obj3",(leader _HQ)])]};
	if ((_HQ getvariable ["BBObj4Done",false]) and ((_HQ getVariable ["RydHQ_Obj4",(leader _HQ)]) in _toRecon)) then {_toRecon = _toRecon - [(_HQ getVariable ["RydHQ_Obj4",(leader _HQ)])]};
};

if (_nObj == 5) then {_toRecon = []};

//if (_toRecon isEqualTo [(leader _HQ)]) then {_toRecon = []};

_objectives = _HQ getVariable ["RydHQ_Objectives",[]];
diag_log text "HQOrders Line 330";
_stages = 3;
if ([] call RYD_isNight) then {_stages = 5};

if ((_AAO) or (_HQ getVariable ["RydHQ_SimpleMode",false])) then
	{
	_taken = _HQ getVariable ["RydHQ_Taken",[]];
	_toRecon = _objectives - _taken;

	_toRecon = [_toRecon,(leader _HQ),250000] call RYD_DistOrdD;
	if ((_HQ getVariable ["RydHQ_MaxSimpleObjs",5]) < (count _toRecon)) then {_toRecon resize (_HQ getVariable ["RydHQ_MaxSimpleObjs",5])};

	if not (_HQ getVariable ["RydHQ_UnlimitedCapt",false]) then
		{
		_allAttackers = 0;
			
			{
			_allAttackers = _allAttackers + (count (units _x))
			}
		foreach _AttackAv;

		/*

		while {(((_allAttackers/(_HQ getVariable ["RydHQ_CaptLimit",10])) < (count _toRecon)) or ((count _AttackAv) < (((1.5 + _stages) * (count _toRecon)))))} do
			{
			if ((count _toRecon) < 2) exitWith {};
			_toRecon resize ((count _toRecon) - 1)
			}
		*/
		}
	};

	
if (_HQ getVariable ["RydHQ_KIA",false]) exitWith {RydxHQ_AllHQ = RydxHQ_AllHQ - [_HQ]};
	
if (((_HQ getVariable ["RydHQ_NoRec",1]) * ((_HQ getVariable ["RydHQ_Recklessness",0.5]) + 0.01)) < (random 100)) then 
	{
	if (((count (_HQ getVariable ["RydHQ_KnEnemiesG",[]])) == 0) and not (_toRecon isEqualTo [(leader _HQ)])) then
		{
			{
			_HQ setVariable ["RydHQ_ReconStage2",1];
			_reconNr = [_foreachIndex,_stages];
			_PosObj1 = getPosATL (vehicle _x);
			_rcheckArr = [(_HQ getVariable ["RydHQ_Garrison",[]]),_ReconAv,_FlankAv,(_HQ getVariable ["RydHQ_NoRecon",[]]),_exhausted,(_HQ getVariable ["RydHQ_NCCargoG",[]]),_x,(_HQ getVariable ["RydHQ_NCVeh",[]])];
			if (not ((count (_HQ getVariable ["RydHQ_RAirG",[]])) == 0) and ((count (_HQ getVariable ["RydHQ_ReconAv",[]])) > 0) and not (_HQ getVariable ["RydHQ_ReconDone",false]) and not ((_HQ getVariable ["RydHQ_ReconStage",1]) > (_stages * (count _toRecon)))) then
				{
				_gps = (([(_HQ getVariable ["RydHQ_RAirG",[]]),"R",_rcheckArr,200000,true] call RYD_Recon) - (_HQ getVariable ["RydHQ_AmmoDrop",[]]) - (_HQ getVariable ["RydHQ_CargoOnly",[]]) - (_HQ getVariable ["RydHQ_ArtG",[]]));

					{
					if ((_HQ getVariable ["RydHQ_ReconStage2",1]) > _stages) exitWith {};
					_HQ setVariable ["RydHQ_ReconStage",(_HQ getVariable ["RydHQ_ReconStage",1]) + 1];
					_HQ setVariable ["RydHQ_ReconStage2",(_HQ getVariable ["RydHQ_ReconStage2",1]) + 1];
					_x setVariable ["Busy" + (str _x),true];
					_reconAv = _HQ getVariable ["RydHQ_ReconAv",[]];
					_reconAv = _reconAv - [_x];
					_HQ setVariable ["RydHQ_ReconAv",_reconAv];
					[_x,_PosObj1,(_HQ getVariable ["RydHQ_ReconStage",1]),_HQ,_reconNr,true] call HAL_GoRecon;
					}
				foreach _gps
				};

			if (not ((count (_HQ getVariable ["RydHQ_reconG",[]])) == 0) and ((count (_HQ getVariable ["RydHQ_ReconAv",[]])) > 0) and not (_HQ getVariable ["RydHQ_ReconDone",false]) and not ((_HQ getVariable ["RydHQ_ReconStage",1]) > (_stages * (count _toRecon)))) then
				{
				_gps = (([(_HQ getVariable ["RydHQ_ReconG",[]]),"R",_rcheckArr,50000,false] call RYD_Recon) - (_HQ getVariable ["RydHQ_AmmoDrop",[]]) - (_HQ getVariable ["RydHQ_CargoOnly",[]]) - (_HQ getVariable ["RydHQ_ArtG",[]]));

					{
					if ((_HQ getVariable ["RydHQ_ReconStage2",1]) > _stages) exitWith {};
					_HQ setVariable ["RydHQ_ReconStage",(_HQ getVariable ["RydHQ_ReconStage",1]) + 1];
					_HQ setVariable ["RydHQ_ReconStage2",(_HQ getVariable ["RydHQ_ReconStage2",1]) + 1];
					_x setVariable ["Busy" + (str _x),true];
					_reconAv = _HQ getVariable ["RydHQ_ReconAv",[]];
					_reconAv = _reconAv - [_x];
					_HQ setVariable ["RydHQ_ReconAv",_reconAv];
					[_x,_PosObj1,(_HQ getVariable ["RydHQ_ReconStage",1]),_HQ,_reconNr,true] call HAL_GoRecon;
					}
				foreach _gps
				};

			if (not ((count (_HQ getVariable ["RydHQ_FOG",[]])) == 0) and ((count (_HQ getVariable ["RydHQ_ReconAv",[]])) > 0) and not (_HQ getVariable ["RydHQ_ReconDone",false]) and not ((_HQ getVariable ["RydHQ_ReconStage",1]) > (_stages * (count _toRecon)))) then
				{
				_gps = (([(_HQ getVariable ["RydHQ_FOG",[]]),"R",_rcheckArr,50000,false] call RYD_Recon) - (_HQ getVariable ["RydHQ_AmmoDrop",[]]) - (_HQ getVariable ["RydHQ_CargoOnly",[]]) - (_HQ getVariable ["RydHQ_ArtG",[]]));

					{
					if ((_HQ getVariable ["RydHQ_ReconStage2",1]) > _stages) exitWith {};
					_HQ setVariable ["RydHQ_ReconStage",(_HQ getVariable ["RydHQ_ReconStage",1]) + 1];
					_HQ setVariable ["RydHQ_ReconStage2",(_HQ getVariable ["RydHQ_ReconStage2",1]) + 1];
					_x setVariable ["Busy" + (str _x),true];
					_reconAv = _HQ getVariable ["RydHQ_ReconAv",[]];
					_reconAv = _reconAv - [_x];
					_HQ setVariable ["RydHQ_ReconAv",_reconAv];
					[_x,_PosObj1,(_HQ getVariable ["RydHQ_ReconStage",1]),_HQ,_reconNr,true] call HAL_GoRecon;
					}
				foreach _gps
				};

			if (not ((count (_HQ getVariable ["RydHQ_snipersG",[]])) == 0) and ((count (_HQ getVariable ["RydHQ_ReconAv",[]])) > 0) and not (_HQ getVariable ["RydHQ_ReconDone",false]) and not ((_HQ getVariable ["RydHQ_ReconStage",1]) > (_stages * (count _toRecon)))) then
				{
				_gps = (([(_HQ getVariable ["RydHQ_snipersG",[]]),"R",_rcheckArr,50000,false] call RYD_Recon) - (_HQ getVariable ["RydHQ_AmmoDrop",[]]) - (_HQ getVariable ["RydHQ_CargoOnly",[]]) - (_HQ getVariable ["RydHQ_ArtG",[]]));

					{
					if ((_HQ getVariable ["RydHQ_ReconStage2",1]) > _stages) exitWith {};
					_HQ setVariable ["RydHQ_ReconStage",(_HQ getVariable ["RydHQ_ReconStage",1]) + 1];
					_HQ setVariable ["RydHQ_ReconStage2",(_HQ getVariable ["RydHQ_ReconStage2",1]) + 1];
					_x setVariable ["Busy" + (str _x),true];
					_reconAv = _HQ getVariable ["RydHQ_ReconAv",[]];
					_reconAv = _reconAv - [_x];
					_HQ setVariable ["RydHQ_ReconAv",_reconAv];
					[_x,_PosObj1,(_HQ getVariable ["RydHQ_ReconStage",1]),_HQ,_reconNr,true] call HAL_GoRecon;
					}
				foreach _gps
				};

			_onlyL = (_HQ getVariable ["RydHQ_LArmorG",[]]) - (_HQ getVariable ["RydHQ_MArmorG",[]]);
			if (not ((count _onlyL) == 0) and ((count (_HQ getVariable ["RydHQ_ReconAv",[]])) > 0) and not (_HQ getVariable ["RydHQ_ReconDone",false]) and not ((_HQ getVariable ["RydHQ_ReconStage",1]) > (_stages * (count _toRecon)))) then
				{
				_gps = (([_onlyL,"R",_rcheckArr,200000,false] call RYD_Recon) - (_HQ getVariable ["RydHQ_AmmoDrop",[]]) - (_HQ getVariable ["RydHQ_CargoOnly",[]]) - (_HQ getVariable ["RydHQ_ArtG",[]]));

					{
					if ((_HQ getVariable ["RydHQ_ReconStage2",1]) > _stages) exitWith {};
					_HQ setVariable ["RydHQ_ReconStage",(_HQ getVariable ["RydHQ_ReconStage",1]) + 1];
					_HQ setVariable ["RydHQ_ReconStage2",(_HQ getVariable ["RydHQ_ReconStage2",1]) + 1];
					_x setVariable ["Busy" + (str _x),true];
					_reconAv = _HQ getVariable ["RydHQ_ReconAv",[]];
					_reconAv = _reconAv - [_x];
					_HQ setVariable ["RydHQ_ReconAv",_reconAv];
					[_x,_PosObj1,(_HQ getVariable ["RydHQ_ReconStage",1]),_HQ,_reconNr,true] call HAL_GoRecon;
					}
				foreach _gps
				};

			if (not ((count ((_HQ getVariable ["RydHQ_NCrewInfG",[]]) - (_HQ getVariable ["RydHQ_SpecForG",[]]))) == 0) and ((count (_HQ getVariable ["RydHQ_ReconAv",[]])) > 0) and not (_HQ getVariable ["RydHQ_ReconDone",false]) and not ((_HQ getVariable ["RydHQ_ReconStage",1]) > (_stages * (count _toRecon)))) then
				{
				_gps = (([((_HQ getVariable ["RydHQ_NCrewInfG",[]]) - (_HQ getVariable ["RydHQ_SpecForG",[]])),"NR",_rcheckArr,100000,false] call RYD_Recon) - (_HQ getVariable ["RydHQ_AmmoDrop",[]]) - (_HQ getVariable ["RydHQ_CargoOnly",[]]) - (_HQ getVariable ["RydHQ_ArtG",[]]));

					{
					if ((_HQ getVariable ["RydHQ_ReconStage2",1]) > _stages) exitWith {};
					_HQ setVariable ["RydHQ_ReconStage",(_HQ getVariable ["RydHQ_ReconStage",1]) + 1];
					_HQ setVariable ["RydHQ_ReconStage2",(_HQ getVariable ["RydHQ_ReconStage2",1]) + 1];
					_x setVariable ["Busy" + (str _x),true];
					_reconAv = _HQ getVariable ["RydHQ_ReconAv",[]];
					_reconAv = _reconAv - [_x];
					_HQ setVariable ["RydHQ_ReconAv",_reconAv];
					[_x,_PosObj1,(_HQ getVariable ["RydHQ_ReconStage",1]),_HQ,_reconNr,false] call HAL_GoRecon;
					}
				foreach _gps
				};

			_LMCUA = (_HQ getVariable ["RydHQ_Friends",[]]) - ((_HQ getVariable ["RydHQ_AOnly",[]]) + (_HQ getVariable ["RydHQ_NavalG",[]]) + (_HQ getVariable ["RydHQ_StaticG",[]]) + (_HQ getVariable ["RydHQ_SupportG",[]]) + (_HQ getVariable ["RydHQ_ArtG",[]]) + (_HQ getVariable ["RydHQ_NoRecon",[]]) + (_HQ getVariable ["RydHQ_SpecForG",[]]) + (_HQ getVariable ["RydHQ_AmmoDrop",[]]) + (_HQ getVariable ["RydHQ_CargoOnly",[]]));
			if (not ((count _LMCUA) == 0) and not (_HQ getVariable ["RydHQ_ReconDone",false]) and not ((_HQ getVariable ["RydHQ_ReconStage",1]) > (_stages * (count _toRecon)))) then
				{
				_gps = (([_LMCUA,"NR",_rcheckArr,200000,false] call RYD_Recon) - (_HQ getVariable ["RydHQ_AmmoDrop",[]]) - (_HQ getVariable ["RydHQ_CargoOnly",[]]) - (_HQ getVariable ["RydHQ_ArtG",[]]));

					{
					if ((_HQ getVariable ["RydHQ_ReconStage2",1]) > _stages) exitWith {};
					_HQ setVariable ["RydHQ_ReconStage",(_HQ getVariable ["RydHQ_ReconStage",1]) + 1];
					_HQ setVariable ["RydHQ_ReconStage2",(_HQ getVariable ["RydHQ_ReconStage2",1]) + 1];
					_x setVariable ["Busy" + (str _x),true];
					_reconAv = _HQ getVariable ["RydHQ_ReconAv",[]];
					_reconAv = _reconAv - [_x];
					_HQ setVariable ["RydHQ_ReconAv",_reconAv];
					[_x,_PosObj1,(_HQ getVariable ["RydHQ_ReconStage",1]),_HQ,_reconNr,false] call HAL_GoRecon;
					}
				foreach _gps
				}
			}
		foreach _toRecon
		}
	}
else
	{
	_HQ setVariable ["RydHQ_ReconDone",true]
	};
	
_reserve = (_HQ getVariable ["RydHQ_Friends",[]]) - ((_HQ getVariable ["RydHQ_SpecForG",[]]) + (_HQ getVariable ["RydHQ_AmmoDrop",[]]) + (_HQ getVariable ["RydHQ_CargoOnly",[]]) + (_HQ getVariable ["RydHQ_AOnly",[]]) + (_HQ getVariable ["RydHQ_ROnly",[]]) + (_HQ getVariable ["RydHQ_Exhausted",[]]) + (_HQ getVariable ["RydHQ_ArtG",[]]) + (_HQ getVariable ["RydHQ_AirG",[]]) + (_HQ getVariable ["RydHQ_NavalG",[]]) + (_HQ getVariable ["RydHQ_StaticG",[]]) + (_HQ getVariable ["RydHQ_SupportG",[]]) + ((_HQ getVariable ["RydHQ_NCCargoG",[]]) - ((_HQ getVariable ["RydHQ_NCrewInfG",[]]) + (_HQ getVariable ["RydHQ_SupportG",[]]))));
if (not ((_HQ getVariable ["RydHQ_ReconDone",false])) and ((count (_HQ getVariable ["RydHQ_KnEnemies",[]])) == 0)) exitwith 
	{
	if (_HQ getVariable ["RydHQ_Orderfirst",true]) then 
		{
		_HQ setVariable ["RydHQ_Orderfirst",false]
		};

		{
		_recvar = str _x;
		_resting = false;
		_resting = _x getvariable ("Resting" + _recvar);
		if (isNil ("_resting")) then {_resting = false};
		_Unable = _x getvariable "Unable";
		if (isNil ("_Unable")) then {_Unable = false};
		_IsAPlayer = false;
		if (RydxHQ_NoRestPlayers and (isPlayer (leader _x))) then {_IsAPlayer = true};
		if (not (_resting) and not (_Unable) and not (_IsAPlayer)) then 
			{
			[_x,_HQ] call HAL_GoRest;
			}
		}
	foreach ((_HQ getVariable ["RydHQ_Exhausted",[]]) - ((_HQ getVariable ["RydHQ_AirG",[]]) + (_HQ getVariable ["RydHQ_StaticG",[]]) + (_HQ getVariable ["RydHQ_ArtG",[]]) + (_HQ getVariable ["RydHQ_SupportG",[]]) + (_HQ getVariable ["RydHQ_NavalG",[]])));

	if (_HQ getVariable ["RydHQ_IdleOrd",true]) then
		{

			{
			_recvar = str _x;
			_busy = false;
			_Unable = false;
			_isDef = false;
			_deployed = false;
			_capturing = false;
			_capturing = _x getVariable ("Capt" + _recvar);
			if (isNil ("_capturing")) then {_capturing = false};
			_deployed = _x getvariable ("Deployed" + _recvar);
			_busy = _x getvariable ("Busy" + _recvar);
			_isDef = _x getVariable "Defending";
			_Unable = _x getvariable "Unable";
			if (isNil ("_Unable")) then {_Unable = false};
			if (isNil ("_isDef")) then {_isDef = false};
			if (isNil ("_busy")) then {_busy = false};
			if (isNil ("_deployed")) then {_deployed = false};
			if (not (_busy) and not (_Unable) and ((count (waypoints _x)) <= 1) and not (_deployed) and not (_isDef) and not (_capturing) and (not (_x in ((_HQ getVariable ["RydHQ_NCCargoG",[]]) + (_HQ getVariable ["RydHQ_SupportG",[]]) + (_HQ getVariable ["RydHQ_AirG",[]]))) or ((count (units _x)) > 1))) then 
				{
				deleteWaypoint ((waypoints _x) select 0);
				//[_x,_HQ] spawn HAL_GoIdle

				if ((_HQ getVariable ["RydHQ_IdleDef",true]) and not (isPlayer (leader _x)) and not ((_HQ getVariable ["RydHQ_Taken",[]]) isEqualTo [])) then {
					[_x,selectrandom (_HQ getVariable ["RydHQ_Taken",[]]),_HQ] call HAL_GoDefRes;
					} else {
					[_x,_HQ] call HAL_GoIdle;
					};
				};
			}
		foreach _reserve;
		}
	};

_HQ setVariable ["RydHQ_FlankReady",true];

_reconthreat = [];
_FOthreat = [];
_snipersthreat = [];
_ATinfthreat = [];
_AAinfthreat = [];
_Infthreat = [];
_Artthreat = [];
_HArmorthreat = [];
_LArmorthreat = [];
_LArmorATthreat = [];
_Carsthreat = [];
_Airthreat = [];
_Navalthreat = [];
_Staticthreat = [];
_StaticAAthreat = [];
_StaticATthreat = [];
_Supportthreat = [];
_Cargothreat = [];
_Otherthreat = [];

	{
	_GE = (group _x);
	_GEvar = str _GE;
	_checked = _GE getvariable ("Checked" + _GEvar);
	if (isNil ("_checked")) then {_GE setvariable [("Checked" + _GEvar),false]};
	_checked = false;
	diag_log text "HQOrders Line 590";
	if ((_x in (_HQ getVariable ["RydHQ_Enrecon",[]])) and not (_GE in _reconthreat) and not (_checked)) then {_reconthreat pushBack _GE};
	if ((_x in (_HQ getVariable ["RydHQ_EnFO",[]])) and not (_GE in _FOthreat) and not (_checked)) then {_FOthreat pushBack _GE};
	if ((_x in (_HQ getVariable ["RydHQ_Ensnipers",[]])) and not (_GE in _snipersthreat) and not (_checked)) then {_snipersthreat pushBack _GE};
	if ((_x in (_HQ getVariable ["RydHQ_EnATinf",[]])) and not (_GE in _ATinfthreat) and not (_checked)) then {_ATinfthreat pushBack _GE};
	if ((_x in (_HQ getVariable ["RydHQ_EnAAinf",[]])) and not (_GE in _AAinfthreat) and not (_checked)) then {_AAinfthreat pushBack _GE};
	if ((_x in (_HQ getVariable ["RydHQ_EnInf",[]])) and not (_GE in _Infthreat) and not (_checked)) then {_Infthreat pushBack _GE};
	if ((_x in (_HQ getVariable ["RydHQ_EnArt",[]])) and not (_GE in _Artthreat) and not (_checked)) then {_Artthreat pushBack _GE};
	if ((_x in (_HQ getVariable ["RydHQ_EnHArmor",[]])) and not (_GE in _LArmorthreat) and not (_checked)) then {_LArmorthreat pushBack _GE};
	if ((_x in (_HQ getVariable ["RydHQ_EnLArmor",[]])) and not (_GE in _reconthreat) and not (_checked)) then {_reconthreat pushBack _GE};
	if ((_x in (_HQ getVariable ["RydHQ_EnLArmorAT",[]])) and not (_GE in _LArmorATthreat) and not (_checked)) then {_LArmorATthreat pushBack _GE;};
	if ((_x in (_HQ getVariable ["RydHQ_EnCars",[]])) and not (_GE in _Carsthreat) and not (_checked)) then {_Carsthreat pushBack _GE};
	if ((_x in (_HQ getVariable ["RydHQ_EnAir",[]])) and not (_GE in _Airthreat) and not (_checked)) then {_Airthreat pushBack _GE};
	if ((_x in (_HQ getVariable ["RydHQ_EnNaval",[]])) and not (_GE in _Navalthreat) and not (_checked)) then {_Navalthreat pushBack _GE};
	if ((_x in (_HQ getVariable ["RydHQ_EnStatic",[]])) and not (_GE in _Staticthreat) and not (_checked)) then {_Staticthreat pushBack _GE};
	if ((_x in (_HQ getVariable ["RydHQ_EnStaticAA",[]])) and not (_GE in _StaticAAthreat) and not (_checked)) then {_StaticAAthreat pushBack _GE};
	if ((_x in (_HQ getVariable ["RydHQ_EnStaticAT",[]])) and not (_GE in _StaticATthreat) and not (_checked)) then {_StaticATthreat pushBack _GE};
	if ((_x in (_HQ getVariable ["RydHQ_EnSupport",[]])) and not (_GE in _Supportthreat) and not (_checked)) then {_Supportthreat pushBack _GE};
	if ((_x in (_HQ getVariable ["RydHQ_EnCargo",[]])) and not (_GE in _Cargothreat) and not (_checked)) then {_Cargothreat pushBack _GE};

	if ((_x in (_HQ getVariable ["RydHQ_EnInf",[]])) and ((vehicle _x) in (_HQ getVariable ["RydHQ_EnCargo",[]])) and not (_x in (_HQ getVariable ["RydHQ_EnCrew",[]])) and not (_GE in _Infthreat) and not (_checked)) then {_Infthreat pushBack _GE};

	if ((isNil ("_checked")) or not (_checked)) then {_GE setVariable [("Checked" + _GEvar), true]};
	}
foreach (_HQ getVariable ["RydHQ_KnEnemies",[]]);

_HQ setVariable ["RydHQ_AAthreat",(_AAinfthreat + _StaticAAthreat)];
_HQ setVariable ["RydHQ_ATthreat",(_ATinfthreat + _StaticATthreat + _HArmorthreat + _LArmorATthreat)];
_HQ setVariable ["RydHQ_Airthreat",_Airthreat];
_reconthreat = _reconthreat - _Airthreat;
diag_log text "HQOrders Line 620";
_FPool = 
	[
	(_HQ getVariable ["RydHQ_snipersG",[]]),
	(_HQ getVariable ["RydHQ_NCrewInfG",[]]) - (_HQ getVariable ["RydHQ_SpecForG",[]]),
	(_HQ getVariable ["RydHQ_AirG",[]]) - ((_HQ getVariable ["RydHQ_NCAirG",[]]) + (_HQ getVariable ["RydHQ_NCrewInfG",[]]) + (_HQ getVariable ["RydHQ_AmmoDrop",[]])),
	(_HQ getVariable ["RydHQ_LArmorG",[]]),
	(_HQ getVariable ["RydHQ_HArmorG",[]]),
	(_HQ getVariable ["RydHQ_CarsG",[]]) - ((_HQ getVariable ["RydHQ_ATInfG",[]]) + (_HQ getVariable ["RydHQ_AAInfG",[]]) + (_HQ getVariable ["RydHQ_SupportG",[]]) + (_HQ getVariable ["RydHQ_NCCargoG",[]])),
	(_HQ getVariable ["RydHQ_LArmorATG",[]]),
	(_HQ getVariable ["RydHQ_ATInfG",[]]),
	(_HQ getVariable ["RydHQ_AAInfG",[]]),
	(_HQ getVariable ["RydHQ_Recklessness",0.5]),
	(_HQ getVariable ["RydHQ_AttackAv",[]]),
	(_HQ getVariable ["RydHQ_Garrison",[]]),
	(_HQ getVariable ["RydHQ_GarrR",500]),
	(_HQ getVariable ["RydHQ_FlankAv",[]]),
	(_HQ getVariable ["RydHQ_AirG",[]]),
	(_HQ getVariable ["RydHQ_NCVeh",[]]),
	(_HQ getVariable ["RydHQ_NavalG",[]]),
	(_HQ getVariable ["RydHQ_RCAS",[]]),
	(_HQ getVariable ["RydHQ_RCAP",[]]),
	(_HQ getVariable ["RydHQ_BAirG",[]])
	];

_constant = [(_HQ getVariable ["RydHQ_AAthreat",[]]),(_HQ getVariable ["RydHQ_ATthreat",[]]),_HArmorthreat + _LArmorATthreat,_FPool];
diag_log text "HQOrders Line 646";
if (count (_reconthreat + _FOthreat + _snipersthreat) > 0) then 
	{
	diag_log text "HQOrders Recon calling RYD_Dispatcher";
	([_reconthreat + _FOthreat + _snipersthreat,"Recon",_HQ,0,0,0] + _constant) call RYD_Dispatcher;
	diag_log text "Call finished";
	};

if (count _ATinfthreat > 0) then 
	{
		diag_log text "HQOrders ATInf calling RYD_Dispatcher";
	([_ATinfthreat,"ATInf",_HQ,0,0,85] + _constant) call RYD_Dispatcher;
	diag_log text "Call finished";
	};

if (count _Infthreat > 0) then 
	{
		diag_log text "HQOrders Inf calling RYD_Dispatcher";
	([_Infthreat,"Inf",_HQ,75,80,85] + _constant) call RYD_Dispatcher;
	diag_log text "Call finished";
	};

if (count (_LArmorthreat + _HArmorthreat) > 0) then 
	{
		diag_log text "HQOrders Armor calling RYD_Dispatcher";
	([_LArmorthreat + _HArmorthreat,"Armor",_HQ,50,0,85] + _constant) call RYD_Dispatcher;
	diag_log text "Call finished";
	};

if (count _Carsthreat > 0) then 
	{
		diag_log text "HQOrders Cars calling RYD_Dispatcher";
	([_Carsthreat,"Cars",_HQ,75,80,85] + _constant) call RYD_Dispatcher;
	diag_log text "Call finished";
	};

if (count _Artthreat > 0) then 
	{
		diag_log text "HQOrders Art calling RYD_Dispatcher";
	([_Artthreat,"Art",_HQ,70,75,75] + _constant) call RYD_Dispatcher;
	diag_log text "Call finished";
	};

if (count _Airthreat > 0) then 
	{
		diag_log text "HQOrders Air calling RYD_Dispatcher";
	([_Airthreat,"Air",_HQ,0,0,75] + _constant) call RYD_Dispatcher;
	diag_log text "Call finished";
	};

if (count (_Staticthreat - _Artthreat) > 0) then 
	{
		diag_log text "HQOrders static calling RYD_Dispatcher";
	([_Staticthreat - _Artthreat,"Static",_HQ,75,80,85] + _constant) call RYD_Dispatcher;
	diag_log text "Call finished";
	};

if (count _Navalthreat > 0) then 
	{
		diag_log text "HQOrders Naval calling RYD_Dispatcher";
	([_Navalthreat,"Naval",_HQ,0,0,0] + _constant) call RYD_Dispatcher;
	diag_log text "Call finished";
	};

/////////////////////////////////////////
// Capture Objective
diag_log text "HQOrders line 703";
_toTake = [_HQ getVariable "RydHQ_Obj"];

if (_BBAOObj > 1) then {

	_toTake = [_HQ getVariable "RydHQ_Obj1",_HQ getVariable "RydHQ_Obj2",_HQ getVariable "RydHQ_Obj3",_HQ getVariable "RydHQ_Obj4"];

	_toTake resize _BBAOObj;

	if ((_HQ getvariable ["BBObj1Done",false]) and ((_HQ getVariable ["RydHQ_Obj1",(leader _HQ)]) in _toTake)) then {_toTake = _toTake - [(_HQ getVariable ["RydHQ_Obj1",(leader _HQ)])]};
	if ((_HQ getvariable ["BBObj2Done",false]) and ((_HQ getVariable ["RydHQ_Obj2",(leader _HQ)]) in _toTake)) then {_toTake = _toTake - [(_HQ getVariable ["RydHQ_Obj2",(leader _HQ)])]};
	if ((_HQ getvariable ["BBObj3Done",false]) and ((_HQ getVariable ["RydHQ_Obj3",(leader _HQ)]) in _toTake)) then {_toTake = _toTake - [(_HQ getVariable ["RydHQ_Obj3",(leader _HQ)])]};
	if ((_HQ getvariable ["BBObj4Done",false]) and ((_HQ getVariable ["RydHQ_Obj4",(leader _HQ)]) in _toTake)) then {_toTake = _toTake - [(_HQ getVariable ["RydHQ_Obj4",(leader _HQ)])]};
};

if (_nObj == 5) then {_toTake = []};

//if (_toTake isEqualTo [(leader _HQ)]) then {_toTake = []};
diag_log text "HQOrders line 721";
if ((_AAO) or (_HQ getVariable ["RydHQ_SimpleMode",false])) then
	{
	_taken = _HQ getVariable ["RydHQ_Taken",[]]; 
	_toTake = _objectives - _taken;

	_toTake = [_toTake,(leader _HQ),250000] call RYD_DistOrdD;
	if ((_HQ getVariable ["RydHQ_MaxSimpleObjs",5]) < (count _toTake)) then {_toTake resize (_HQ getVariable ["RydHQ_MaxSimpleObjs",5])};
	
		{
		if not (_x in _toRecon) then
			{
			_toTake set [_foreachIndex,objNull];
			}
		}
	foreach _toTake;
	diag_log text "HQOrders foreach _toTake";

	_toTake = _toTake - [objNull];
		
	_allAttackers = 0;
		
		{
		_allAttackers = _allAttackers + (count (units _x))
		}
	foreach _AttackAv;

	diag_log text "HQOrders foreach _AttackAv";

	/*			
	while {(((_allAttackers/(_HQ getVariable ["RydHQ_CaptLimit",10])) < (count _toTake)) or ((count _AttackAv) < ((1.5 * (count _toTake)))))} do
		{
		if ((count _toTake) < 2) exitWith {};
		_toTake resize ((count _toTake) - 1)
		}
	*/
	};
	diag_log text "HQOrders Line 758";
	{
	if (isNil {_x}) then {_toTake set [_foreachIndex,objNull]};
	}
foreach _toTake;
diag_log text "HQOrders Line 763";

_toTake = _toTake - [objNull];
	
	{
	_Trg = _x;

	if not ((_AAO) or (_HQ getVariable ["RydHQ_SimpleMode",false])) then
		{
			{
			_x setVariable [("Capturing" + (str _x) + (str _HQ)),[0,0]]
			}
		foreach (_objectives - [(_HQ getVariable ["RydHQ_Obj",nil])]);
		};

	_isAttacked = _Trg getvariable ("Capturing" + (str _Trg) + (str _HQ));

	if (isNil ("_isAttacked")) then {_isAttacked = [0,0]};
	_isAttacked params ["_isAttacked","_captCount"];
	_captLimit = (_HQ getVariable ["RydHQ_CaptLimit",10]) * (1 + ((_HQ getVariable ["RydHQ_Circumspection",0.5])/(2 + (_HQ getVariable ["RydHQ_Recklessness",0.5]))));
	if ((_isAttacked <= 3) or (_captCount < _captLimit)) then
		{
		_allT = _HQ getVariable ["RydHQ_NObj",1];
		if ((_AAO) or (_HQ getVariable ["RydHQ_SimpleMode",false])) then
			{
			_allT = ((count _taken)/(count _objectives))*5
			};
		
		if  ((not (_allT >= 5) and ((random 100) > ((count (_HQ getVariable ["RydHQ_KnEnemies",[]]))*(5/(0.5 + (2*(_HQ getVariable ["RydHQ_Recklessness",0.5])))))) and  
				(_HQ getVariable ["RydHQ_ReconDone",false])) or
					((((_HQ getVariable ["RydHQ_RapidCapt",10]) * ((_HQ getVariable ["RydHQ_Recklessness",0.5]) + 0.01)) > (random 100)) and ((_HQ getVariable ["RydHQ_NObj",1]) <= 4))) then   
			{
			_checked = [];
			_forCapt = (_HQ getVariable ["RydHQ_NCrewInfG",[]]) - ((_HQ getVariable ["RydHQ_Exhausted",[]]) + (_HQ getVariable ["RydHQ_SupportG",[]]) + (_HQ getVariable ["RydHQ_NavalG",[]]) + (_HQ getVariable ["RydHQ_SpecForG",[]]) + (_HQ getVariable ["RydHQ_AmmoDrop",[]]) + (_HQ getVariable ["RydHQ_CargoOnly",[]]) + (_HQ getVariable ["RydHQ_Garrison",[]]));
			_forCapt = _forCapt - ((_HQ getVariable ["RydHQ_AOnly",[]]) + (_HQ getVariable ["RydHQ_ROnly",[]]));
			_forCapt = [_forCapt] call RYD_SizeOrd;

			if (not ((count _forCapt) == 0) and ((count (_HQ getVariable ["RydHQ_AttackAv",[]])) > 0) and not (_toTake isEqualTo [(leader _HQ)])) then
				{
				for [{_m = 500},{_m <= 50000},{_m = _m + 500}] do
					{
					_isAttacked = _Trg getvariable ("Capturing" + (str _Trg) + (str _HQ));
					if (isNil ("_isAttacked")) then {_isAttacked = [1,0]};
					_isAttacked params ["_isAttacked","_captCount"];

					if ((_isAttacked > 3) and (_captCount >= _captLimit)) exitwith {};

						{
						_isAttacked = _Trg getvariable ("Capturing" + (str _Trg) + (str _HQ));
						if (isNil ("_isAttacked")) then {_isAttacked = [1,0]};
						_isAttacked params ["_isAttacked","_captCount"];

						if ((_isAttacked > 3) and (_captCount >= _captLimit)) exitwith {};

						if (_x in (_HQ getVariable ["RydHQ_AttackAv",[]])) then
							{

							if (((leader _x) distance _Trg) <= _m) then
								{
								if (not (_x in (_HQ getVariable ["RydHQ_NCCargoG",[]])) or ((count (units _x)) > 1)) then 
									{
									_ammo = [_x,(_HQ getVariable ["RydHQ_NCVeh",[]])] call RYD_AmmoCount;

									if (_ammo > 0) then
										{
										_busy = _x getVariable [("Busy" + (str _x)),false];
										_Unable = _x getVariable ["Unable",false];

										if (not (_busy) and not (_Unable)) then
											{
											_x setVariable [("Busy" + (str _x)),true];
											_HQ setVariable ["RydHQ_AttackAv",(_HQ getVariable ["RydHQ_AttackAv",[]]) - [_x]];
											_checked pushBack _x;
											_groupCount = count (units _x);

											switch (_isAttacked) do
												{
												case (4) : {_Trg setvariable [("Capturing" + (str  _Trg) + (str _HQ)),[5,_captCount + _groupCount]]};
												case (3) : {_Trg setvariable [("Capturing" + (str  _Trg) + (str _HQ)),[4,_captCount + _groupCount]]};
												case (2) : {_Trg setvariable [("Capturing" + (str  _Trg) + (str _HQ)),[3,_captCount + _groupCount]]};
												case (1) : {_Trg setvariable [("Capturing" + (str  _Trg) + (str _HQ)),[2,_captCount + _groupCount]]};
												case (0) : {_Trg setVariable [("Capturing" + (str  _Trg) + (str _HQ)),[1,_captCount + _groupCount]]};
												};

											[_x,_isAttacked,_HQ,_Trg] call HAL_GoCapture;
											}
										}
									}
								}
							}
						}
					foreach _forCapt;
					_forCapt = _forCapt - _checked
					}
				};

			if ((_isAttacked > 3) and (_captCount >= _captLimit)) exitwith {};

			_LMCU = (_HQ getVariable ["RydHQ_Friends",[]]) - ((_HQ getVariable ["RydHQ_Exhausted",[]]) + ((_HQ getVariable ["RydHQ_AirG",[]]) - (_HQ getVariable ["RydHQ_NCrewInfG",[]])) + (_HQ getVariable ["RydHQ_SpecForG",[]]) + (_HQ getVariable ["RydHQ_AmmoDrop",[]]) + (_HQ getVariable ["RydHQ_CargoOnly",[]]) + (_HQ getVariable ["RydHQ_NavalG",[]]) + (_HQ getVariable ["RydHQ_StaticG",[]]) + (_HQ getVariable ["RydHQ_SupportG",[]]) + (_HQ getVariable ["RydHQ_ArtG",[]]) + (_HQ getVariable ["RydHQ_Garrison",[]]) + ((_HQ getVariable ["RydHQ_NCCargoG",[]]) - ((_HQ getVariable ["RydHQ_NCrewInfG",[]]) - (_HQ getVariable ["RydHQ_SupportG",[]]))));
			_LMCU = _LMCU - ((_HQ getVariable ["RydHQ_AOnly",[]]) + (_HQ getVariable ["RydHQ_ROnly",[]]));
			_LMCU = [_LMCU] call RYD_SizeOrd;
			if (not ((count _LMCU) == 0) and ((count (_HQ getVariable ["RydHQ_AttackAv",[]])) > 0) and not (_toRecon isEqualTo [(leader _HQ)])) then
				{
				for [{_m = 1000},{_m <= 200000},{_m = _m + 1000}] do
					{
					_isAttacked = _Trg getvariable ("Capturing" + (str _Trg) + (str _HQ));
					if (isNil ("_isAttacked")) then {_isAttacked = [1,0]};
					_isAttacked params ["_isAttacked","_captCount"];
					if ((_isAttacked > 3) and (_captCount >= _captLimit)) exitwith {};

						{
						_isAttacked = _Trg getvariable ("Capturing" + (str _Trg) + (str _HQ));
						if (isNil ("_isAttacked")) then {_isAttacked = [1,0]};
						_isAttacked params ["_isAttacked","_captCount"];

						if ((_isAttacked > 3) and (_captCount >= _captLimit)) exitwith {};
						if (_x in (_HQ getVariable ["RydHQ_AttackAv",[]])) then
							{
							if (((leader _x) distance _Trg) <= _m) then
								{
								_ammo = [_x,(_HQ getVariable ["RydHQ_NCVeh",[]])] call RYD_AmmoCount;
								if (_ammo > 0) then
									{
									_busy = _x getVariable [("Busy" + (str _x)),false];
									_Unable = _x getVariable ["Unable",false];

									if (not (_busy) and not (_Unable)) then
										{
										_x setVariable [("Busy" + (str _x)),true];
										_HQ setVariable ["RydHQ_AttackAv",(_HQ getVariable ["RydHQ_AttackAv",[]]) - [_x]];
										_checked pushBack _x;
										_groupCount = count (units _x);

										switch (_isAttacked) do
											{
											case (4) : {_Trg setvariable [("Capturing" + (str  _Trg) + (str _HQ)),[5,_captCount + _groupCount]]};
											case (3) : {_Trg setvariable [("Capturing" + (str  _Trg) + (str _HQ)),[4,_captCount + _groupCount]]};
											case (2) : {_Trg setvariable [("Capturing" + (str  _Trg) + (str _HQ)),[3,_captCount + _groupCount]]};
											case (1) : {_Trg setvariable [("Capturing" + (str  _Trg) + (str _HQ)),[2,_captCount + _groupCount]]};
											case (0) : {_Trg setVariable [("Capturing" + (str  _Trg) + (str _HQ)),[1,_captCount + _groupCount]]};
											};

										[_x,_isAttacked,_HQ,_Trg] call HAL_GoCapture;										}
									}
								}
							}
						}
					foreach _LMCU;
					_LMCU = _LMCU - _checked
					}
				}
			}
		}
	}
foreach _toTake;
diag_log text "HQOrders Line 906";

// NAVAL OBJECTIVES

_Navalobjectives = _HQ getVariable ["RydHQ_NavalObjectives",[]];
_toTakeNav = [];

if (((_AAO) or (_HQ getVariable ["RydHQ_SimpleMode",false]))) then
	{
	_takenNav = _HQ getVariable ["RydHQ_TakenNaval",[]]; 
	_toTakeNav = _Navalobjectives - _takenNav;

	_toTakeNav = [_toTakeNav,(leader _HQ),250000] call RYD_DistOrdD;
	if ((_HQ getVariable ["RydHQ_MaxNavalObjs",5]) < (count _toTakeNav)) then {_toTakeNav resize (_HQ getVariable ["RydHQ_MaxNavalObjs",5])};
		
/*	_allAttackers = 0;
		
		{
		_allAttackers = _allAttackers + (count (units _x))
		}
	foreach _AttackAvNav;
*/

	};
	
	{
	if (isNil {_x}) then {_toTakeNav set [_foreachIndex,objNull]};
	}
foreach _toTakeNav;
diag_log text "HQOrders Line 935";

_toTakeNav = _toTakeNav - [objNull];
	
	{
	_Trg = _x;

	_isAttacked = _Trg getvariable ("Capturing" + (str _Trg) + (str _HQ));

	if (isNil ("_isAttacked")) then {_isAttacked = [0,0]};

	_isAttacked params ["_isAttacked","_captCount"];
	_captLimit = 1 * (1 + ((_HQ getVariable ["RydHQ_Circumspection",0.5])/(2 + (_HQ getVariable ["RydHQ_Recklessness",0.5]))));
	if ((_isAttacked <= 3) or (_captCount < _captLimit)) then
		{
		_allT = 5;
		if ((_AAO) or (_HQ getVariable ["RydHQ_SimpleMode",false])) then
			{
			_allT = ((count _taken)/(count _Navalobjectives))*5
			};
		
		if ((not (_allT >= 5) and ((random 100) > ((count (_HQ getVariable ["RydHQ_EnNaval",[]]))*(5/(0.5 + (2*(_HQ getVariable ["RydHQ_Recklessness",0.5])))))) and 
				(true)) or
					((((_HQ getVariable ["RydHQ_RapidCapt",10]) * ((_HQ getVariable ["RydHQ_Recklessness",0.5]) + 0.01)) > (random 100)) and ((_HQ getVariable ["RydHQ_NObj",1]) <= 4))) then   
			{
			_checked = [];
			_forNavCapt = (_HQ getVariable ["RydHQ_NavalG",[]]) - ((_HQ getVariable ["RydHQ_Exhausted",[]]) + (_HQ getVariable ["RydHQ_SupportG",[]]) + (_HQ getVariable ["RydHQ_SpecForG",[]]) + (_HQ getVariable ["RydHQ_AmmoDrop",[]]) + (_HQ getVariable ["RydHQ_CargoOnly",[]]) + (_HQ getVariable ["RydHQ_Garrison",[]]));
			_forNavCapt = _forNavCapt - ((_HQ getVariable ["RydHQ_AOnly",[]]) + (_HQ getVariable ["RydHQ_ROnly",[]]));
			_forNavCapt = [_forNavCapt] call RYD_SizeOrd;

			if (not ((count _forNavCapt) == 0)) then
				{
				for [{_m = 500},{_m <= 50000},{_m = _m + 500}] do
					{
					_isAttacked = _Trg getvariable ("Capturing" + (str _Trg) + (str _HQ));
					if (isNil ("_isAttacked")) then {_isAttacked = [1,0]};
					_isAttacked params ["_isAttacked","_captCount"];

					if ((_isAttacked > 3) and (_captCount >= _captLimit)) exitwith {};

						{
						_isAttacked = _Trg getvariable ("Capturing" + (str _Trg) + (str _HQ));
						if (isNil ("_isAttacked")) then {_isAttacked = [1,0]};
						_isAttacked params ["_isAttacked","_captCount"];

						if ((_isAttacked > 3) and (_captCount >= _captLimit)) exitwith {};

						if (true) then
							{

							if (((vehicle (leader _x)) distance _Trg) <= _m) then
								{
								if (not (_x in (_HQ getVariable ["RydHQ_NCCargoG",[]])) or ((count (units _x)) > 1)) then 
									{
									_ammo = [_x,(_HQ getVariable ["RydHQ_NCVeh",[]])] call RYD_AmmoCount;

									if (_ammo > 0) then
										{
										_busy = _x getVariable [("Busy" + (str _x)),false];
										_Unable = _x getVariable ["Unable",false];

										if (not (_busy) and not (_Unable)) then
											{
											_x setVariable [("Busy" + (str _x)),true];
											_HQ setVariable ["RydHQ_AttackAv",(_HQ getVariable ["RydHQ_AttackAv",[]]) - [_x]];
											_checked pushBack _x;
											_groupCount = count (units _x);

											switch (_isAttacked) do
												{
												case (4) : {_Trg setvariable [("Capturing" + (str  _Trg) + (str _HQ)),[5,_captCount + _groupCount]]};
												case (3) : {_Trg setvariable [("Capturing" + (str  _Trg) + (str _HQ)),[4,_captCount + _groupCount]]};
												case (2) : {_Trg setvariable [("Capturing" + (str  _Trg) + (str _HQ)),[3,_captCount + _groupCount]]};
												case (1) : {_Trg setvariable [("Capturing" + (str  _Trg) + (str _HQ)),[2,_captCount + _groupCount]]};
												case (0) : {_Trg setVariable [("Capturing" + (str  _Trg) + (str _HQ)),[1,_captCount + _groupCount]]};
												};

											[_x,_isAttacked,_HQ,_Trg] call HAL_GoCaptureNaval;
											}
										}
									}
								}
							}
						}
					foreach _forNavCapt;
					_forNavCapt = _forNavCapt - _checked
					}
				};
			}
		}
	}
foreach _toTakeNav;
diag_log text "HQOrders Line 1027";
/*if (_HQ getVariable ["RydHQ_WA",true]) then
	{
	_WADone = _HQ getVariable ["RydHQ_WADone",0];
	_WAchance = ((1 + (_HQ getVariable ["RydHQ_Activity",0.5]) + (_HQ getVariable ["RydHQ_Recklessness",0.5]))^2)/(10 + (10 * (_WADone^2)));

	if (_WAchance > (random 1)) then
		{
		_armored = (_HQ getVariable ["RydHQ_HArmorG",[]]) + (_HQ getVariable ["RydHQ_LArmorG",[]]);
		_LMCU = (_HQ getVariable ["RydHQ_Friends",[]]) - (((_HQ getVariable ["RydHQ_AirG",[]]) - (_HQ getVariable ["RydHQ_NCrewInfG",[]])) + (_HQ getVariable ["RydHQ_Exhausted",[]]) + (_HQ getVariable ["RydHQ_NoAttack",[]]) + (_HQ getVariable ["RydHQ_SpecForG",[]]) + (_HQ getVariable ["RydHQ_CargoOnly",[]]) + (_HQ getVariable ["RydHQ_NavalG",[]]) + (_HQ getVariable ["RydHQ_StaticG",[]]) + (_HQ getVariable ["RydHQ_SupportG",[]]) + (_HQ getVariable ["RydHQ_ArtG",[]]) + (_HQ getVariable ["RydHQ_Garrison",[]]) + ((_HQ getVariable ["RydHQ_NCCargoG",[]]) - ((_HQ getVariable ["RydHQ_NCrewInfG",[]]) - (_HQ getVariable ["RydHQ_SupportG",[]]))));
		
		_WAAv = [];
		
			{
			if not (_x getVariable ["Busy" + (str _x),false]) then
				{
				_WAAv pushBack _x
				}
			}
		foreach _LMCU;
		
		if ((count _WAAv) == 0) exitWith {};
		
		_WAAv = [_WAAv] call RYD_RandomOrd;
		
		_where = [];
		
			{
			_heldBy = _x getVariable ["RydHQ_HeldBy",0];
			if not (_heldBy > ((random 4) * (0.5 + (_HQ getVariable ["RydHQ_Consistency",0.5])))) then
				{
				if (((1 + (_HQ getVariable ["RydHQ_Consistency",0.5]) + (_HQ getVariable ["RydHQ_Fineness",0.5]))/4) > (random 1)) then
					{
					_where pushBack _x
					}
				}
			}
		foreach [(_HQ getVariable ["RydHQ_Obj1",(leader _HQ)]),(_HQ getVariable ["RydHQ_Obj2",(leader _HQ)]),(_HQ getVariable ["RydHQ_Obj3",(leader _HQ)]),(_HQ getVariable ["RydHQ_Obj4",(leader _HQ)])];
		
		if ((count _where) == 0) then {_where = [(_HQ getVariable ["RydHQ_Obj",(leader _HQ)])]};
		
		_howMuch = ((_HQ getVariable ["RydHQ_Recklessness",[]]) + (random 0.5))/1.5;
		if (_howMuch > 1) then {_howMuch = 1};
		_howMuch = floor (_howMuch * (count _WAAv));
		
		while {((_howMuch > 0) and ((count _WAAv) > 0))} do
			{
				{
				_WAAv params ["_gp"];
				_code = HAL_GoHoldInf;
				if (_gp in _armored) then {_code = HAL_GoHoldArmor};
				_WAAv = _WAAv - [_gp];
				_gp setVariable ["Busy" + (str _gp),true];
				
				[_gp,_x] call _code;
				
				_howMuch = _howMuch - 1;
				
				if ((_howMuch < 1) or ((count _WAAv) < 1)) exitWith {}
				}
			foreach _where
			}
		}
	};*/
diag_log text "HQOrders Line 1091";
if (_HQ getVariable ["RydHQ_IdleOrd",true]) then
	{
	_reserve = (_HQ getVariable ["RydHQ_Friends",[]]) - ((_HQ getVariable ["RydHQ_SpecForG",[]]) + (_HQ getVariable ["RydHQ_AmmoDrop",[]]) + (_HQ getVariable ["RydHQ_CargoOnly",[]]) + (_HQ getVariable ["RydHQ_NoRecon",[]]) + (_HQ getVariable ["RydHQ_NoAttack",[]]) + (_HQ getVariable ["RydHQ_Exhausted",[]]) + (_HQ getVariable ["RydHQ_ArtG",[]]) + (_HQ getVariable ["RydHQ_AirG",[]]) + (_HQ getVariable ["RydHQ_NavalG",[]]) + (_HQ getVariable ["RydHQ_StaticG",[]]) + (_HQ getVariable ["RydHQ_SupportG",[]]) + ((_HQ getVariable ["RydHQ_NCCargoG",[]]) - (_HQ getVariable ["RydHQ_NCrewInfG",[]])));

		{
		_recvar = str _x;
		_busy = false;
		_Unable = false;
		_deployed = false;
		_capturing = false;
		_capturing = _x getVariable ("Capt" + _recvar);
		if (isNil ("_capturing")) then {_capturing = false};
		_deployed = _x getvariable ("Deployed" + _recvar);
		_isDef = _x getVariable "Defending";
		_busy = _x getvariable ("Busy" + _recvar);
		_Unable = _x getvariable "Unable";
		if (isNil ("_Unable")) then {_Unable = false};
		if (isNil ("_isDef")) then {_isDef = false};
		if (isNil ("_busy")) then {_busy = false};
		if (isNil ("_deployed")) then {_deployed = false};
		if (not (_busy) and not (_Unable) and ((count (waypoints _x)) <= 1) and not (_deployed) and not (_isDef) and not (_capturing) and (not (_x in ((_HQ getVariable ["RydHQ_NCCargoG",[]]) + (_HQ getVariable ["RydHQ_SupportG",[]]) + (_HQ getVariable ["RydHQ_AirG",[]]))) or ((count (units _x)) > 1))) then 
			{
			deleteWaypoint ((waypoints _x) select 0);
			//[_x,_HQ] spawn HAL_GoIdle

			if ((_HQ getVariable ["RydHQ_IdleDef",true]) and not (isPlayer (leader _x)) and not ((_HQ getVariable ["RydHQ_Taken",[]]) isEqualTo [])) then {
				[_x,selectrandom (_HQ getVariable ["RydHQ_Taken",[]]),_HQ] call HAL_GoDefRes;
				} else {
				[_x,_HQ] call HAL_GoIdle;
				};
			};
		}
	foreach _reserve;
diag_log text "HQOrders Line 1125";

		{
		_recvar = str _x;
		_busy = false;
		_Unable = false;
		_deployed = false;
		_capturing = false;
		_capturing = _x getVariable ("Capt" + _recvar);
		if (isNil ("_capturing")) then {_capturing = false};
		_deployed = _x getvariable ("Deployed" + _recvar);
		_isDef = _x getVariable "Defending";
		_busy = _x getvariable ("Busy" + _recvar);
		_Unable = _x getvariable "Unable";
		if (isNil ("_Unable")) then {_Unable = false};
		if (isNil ("_isDef")) then {_isDef = false};
		if (isNil ("_busy")) then {_busy = false};
		if (isNil ("_deployed")) then {_deployed = false};
		if (not (_busy) and not (_Unable) and ((count (waypoints _x)) <= 1) and not (_deployed) and not (_isDef) and not (_capturing) and (not (_x in (_HQ getVariable ["RydHQ_NCCargoG",[]])) or ((count (units _x)) > 1))) then 
			{
			deleteWaypoint ((waypoints _x) select 0);
			//[_x,_HQ] spawn HAL_GoIdle

			if ((_HQ getVariable ["RydHQ_IdleDef",true]) and not (isPlayer (leader _x)) and not ((_HQ getVariable ["RydHQ_TakenNaval",[]]) isEqualTo [])) then {
				[_x,selectrandom (_HQ getVariable ["RydHQ_TakenNaval",[]]),_HQ] call HAL_GoDefNav;
				};
			};
		}
	foreach (_HQ getVariable ["RydHQ_NavalG",[]]);

	};

	{
	_recvar = str _x;
	_resting = false;
	_Unable = false;
	_resting = _x getvariable ("Resting" + _recvar);
	if (isNil ("_resting")) then {_resting = false};
	_Unable = _x getvariable "Unable";
	if (isNil ("_Unable")) then {_Unable = false};
	_IsAPlayer = false;
	if (RydxHQ_NoRestPlayers and (isPlayer (leader _x))) then {_IsAPlayer = true};
	if (not (_resting) and not (_Unable) and not (_IsAPlayer)) then 
		{
		if not (_x in (_HQ getVariable ["RydHQ_Garrison",[]])) then
			{
			[_x,_HQ] call HAL_GoRest;
			}
		}
	}
foreach ((_HQ getVariable ["RydHQ_Exhausted",[]]) - ((_HQ getVariable ["RydHQ_AirG",[]]) + (_HQ getVariable ["RydHQ_StaticG",[]]) + (_HQ getVariable ["RydHQ_ArtG",[]]) + (_HQ getVariable ["RydHQ_NavalG",[]])));
diag_log text "HQOrders Line 1176";

	{
	_GE = (group _x);
	_GEvar = str _GE;
	_GE setvariable [("Checked" + _GEvar),false];
	}
foreach (_HQ getVariable ["RydHQ_KnEnemies",[]]);


if (_HQ getVariable ["RydHQ_Orderfirst",true]) then {_HQ setVariable ["RydHQ_Orderfirst",false]};
diag_log text "HQOrders done";