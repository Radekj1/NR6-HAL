_SCRname = "OrdersDef";

private ["_HQ","_defRange","_LMCU","_airDef","_recDef","_allInDef","_goodSpots","_inDef","_default","_Epos0","_Epos1","_nObj","_default","_Epos0Max","_Epos0Min","_EposA","_Epos1Max","_Epos1Min",
	"_sel1Max","_sel1Min","_EposB","_PosMid0","_PosMid1","_defRes","_defPoints","_ct","_cl","_clr","_closest","_friend","_dstM","_dstAct","_defPoints0","_defArray","_Lenght1","_Width1",
	"_Lenght2","_Width2","_FreeLOS","_PrimDir","_SecDir","_randomPrimDir","_randomSecDir","_DN","_defPoint","_dX","_dY","_Angle","_dXb","_dYb","_posX","_posY","_Center","_lng","_wdt",
	"_defFront","_goodmark","_spotsN","_goodSpotsRec","_angleV","_Spot","_GS","_recDefSpot","_isDef","_closestArr","_friend","_dstM","_arrP","_AAO","_ad",
	"_dstAct","_aa","_Spot","_defSpot","_def","_bb","_SpotB","_radius","_position","_precision","_sourcesCount","_expression","_NR","_cnt","_Rpoint","_ammo",
	"_dL","_d1","_d2","_d3","_d4","_Unable","_defPointsBB","_defPointsOBJ","_exhausted","_unitvar","_busy","_vehready","_solready","_effective","_Gdamage","_nominal","_current","_veh","_inD","_recvar"];
params ["HQ"];
diag_log text "HQ_OrdersDef started";

_defRange = _HQ getVariable ["RydHQ_DefRange",1];

_LMCU = ((_HQ getVariable ["RydHQ_Friends",[]]) - (((_HQ getVariable ["RydHQ_AirG",[]]) - (_HQ getVariable ["RydHQ_NCrewInfG",[]])) + (_HQ getVariable ["RydHQ_SpecForG",[]]) + (_HQ getVariable ["RydHQ_CargoOnly",[]]) + (_HQ getVariable ["RydHQ_NavalG",[]])  + (_HQ getVariable ["RydHQ_SupportG",[]]) + (_HQ getVariable ["RydHQ_StaticG",[]]) + (_HQ getVariable ["RydHQ_ArtG",[]]) + ((_HQ getVariable ["RydHQ_NCCargoG",[]]) - (_HQ getVariable ["RydHQ_NCrewInfG",[]])))) - (_HQ getVariable ["RydHQ_NoDef",[]]);
_airDef = ((_HQ getVariable ["RydHQ_AirG",[]]) - ((_HQ getVariable ["RydHQ_NCAirG",[]]) + (_HQ getVariable ["RydHQ_NCrewInfG",[]]))) - ((_HQ getVariable ["RydHQ_NoDef",[]]) + (_HQ getVariable ["RydHQ_SpecForG",[]]) + (_HQ getVariable ["RydHQ_CargoOnly",[]]) + (_HQ getVariable ["RydHQ_AmmoDrop",[]]) + (_HQ getVariable ["RydHQ_SupportG",[]]));
_recDef = ((_HQ getVariable ["RydHQ_reconG",[]]) + (_HQ getVariable ["RydHQ_FOG",[]]) + (_HQ getVariable ["RydHQ_snipersG",[]])) - ((_HQ getVariable ["RydHQ_NoDef",[]]) + (_HQ getVariable ["RydHQ_SpecForG",[]]) + (_HQ getVariable ["RydHQ_CargoOnly",[]]) + (_HQ getVariable ["RydHQ_SupportG",[]]));

_LMCU = [_LMCU] call RYD_RandomOrd;
_airDef = [_airDef] call RYD_RandomOrd;
_recDef = [_recDef] call RYD_RandomOrd;

_allInDef = true;
_goodSpots = [];

	{
	_inDef = _x getVariable "Defending";
	if (isNil "_inDef") then {_inDef = false};
	if not (_inDef) exitWith {_allInDef = false}
	}
foreach ((_LMCU + _airDef + _recDef) - ([_HQ] + (_HQ getVariable ["RydHQ_Garrison",[]])));

if (_allInDef) exitWith {};

//if ((_HQ getVariable ["RydHQ_DefDone",false]) and ((_HQ getVariable ["RydHQ_Order","ATTACK"]) == "DEFEND") and not (((_HQ getVariable ["RydHQ_LastE",0]) == 0) and ((count (_HQ getVariable ["RydHQ_KnEnemies",[]])) > 0) and (_HQ getVariable ["RydHQ_FirstEMark",true]))) exitwith {};
if ((_HQ getVariable ["RydHQ_Order","ATTACK"]) == "DEFEND") then 
	{
	_HQ setVariable ["RydHQ_DefDone",true];
	};

if ((_HQ getVariable ["RydHQ_FirstEMark",true]) and ((_HQ getVariable ["RydHQ_LastE",0]) == 0) and ((count (_HQ getVariable ["RydHQ_KnEnemies",[]])) > 0)) then {_HQ setVariable ["RydHQ_FirstEMark",false]};

_default = [];
_Epos0 = [];
_Epos1 = [];

_AAO = _HQ getVariable ["RydHQ_ChosenAAO",false];

_nObj = _HQ getVariable ["RydHQ_NObj",1];

switch (_nObj) do
	{
	case (1) : {_HQ setVariable ["RydHQ_Obj",(_HQ getVariable ["RydHQ_Obj1",(leader _HQ)])]};
	case (2) : {_HQ setVariable ["RydHQ_Obj",(_HQ getVariable ["RydHQ_Obj2",(leader _HQ)])]};
	case (3) : {_HQ setVariable ["RydHQ_Obj",(_HQ getVariable ["RydHQ_Obj3",(leader _HQ)])]};
	default {_HQ setVariable ["RydHQ_Obj",(_HQ getVariable ["RydHQ_Obj4",(leader _HQ)])]};
	};
		
_default = getPosATL (_HQ getVariable ["RydHQ_Obj",(leader _HQ)]);

if (_AAO) then
	{
	_default = _HQ getVariable ["RydHQ_EyeOfBattle",getPosATL (vehicle (leader _HQ))]
	};

if not ((count (_HQ getVariable ["RydHQ_KnEnPos",[]])) == 0) then 
	{
		{
		_Epos0 pushBack (_x select 0);
		_Epos1 pushBack (_x select 1)
		}
	foreach (_HQ getVariable ["RydHQ_KnEnPos",[]])
	}
else
	{
	if not (isNull (leader _HQ)) then 
		{
		_Epos0 = [(position (leader _HQ)) select 0];
		_Epos1 = [(position (leader _HQ)) select 1]
		}
	else 
		{
		_Epos0 = [(position (leader ((_HQ getVariable ["RydHQ_Friends",[]]) select (random (floor (count (_HQ getVariable ["RydHQ_Friends",[]]))))))) select 0];
		_Epos1 = [(position (leader ((_HQ getVariable ["RydHQ_Friends",[]]) select (random (floor (count (_HQ getVariable ["RydHQ_Friends",[]]))))))) select 1]
		}
	};

_Epos0Max = _default select 0;
_Epos0Min = _default select 0;

for [{_a = 0},{_a < (count _Epos0)},{_a = _a + 1}] do 
	{
	_EposA = _Epos0 select _a;
	if (_a == 0) then {_Epos0Min = _EposA};
	if (_a == 0) then {_Epos0Max = _EposA};
	if (_Epos0Min >= _EposA) then {_Epos0Min = _EposA};
	if (_Epos0Max < _EposA) then {_Epos0Max = _EposA};
	};

_Epos1Max = _default select 1;
_Epos1Min = _default select 1;
_sel1Max = 1;
_sel1Min = 1;

for [{_b = 0},{_b < (count _Epos1)},{_b = _b + 1}] do 
	{
	_EposB = _Epos1 select _b;
	if (_b == 0) then {_Epos1Min = _EposB};
	if (_b == 0) then {_Epos1Max = _EposB};
	if (_Epos1Min >= _EposB) then {_Epos1Min = _EposB};
	if (_Epos1Max < _EposB) then {_Epos1Max = _EposB};
	};

_PosMid0 = (_Epos0Min + _Epos0Max)/2;
_PosMid1 = (_Epos1Min + _Epos1Max)/2;

_defRes = [];

if ((_HQ getVariable ["RydHQ_CRDefRes",0]) == 0) then {

		{
		if ((not (_x in ((_HQ getVariable ["RydHQ_NCCargoG",[]]) + (_HQ getVariable ["RydHQ_AirG",[]]))) or ((count (units _x)) > 1)) and ((random 100) > (70/(0.75 + ((_HQ getVariable ["RydHQ_Fineness",0.5])/4))))) then 
			{
			_defRes pushBack _x
			};
		}
	foreach _LMCU;

	} else {

		{
		if ((not (_x in ((_HQ getVariable ["RydHQ_NCCargoG",[]]) + (_HQ getVariable ["RydHQ_AirG",[]]))) or ((count (units _x)) > 1)) and ((random 1) <= (_HQ getVariable ["RydHQ_CRDefRes",0]))) then 
			{
			_defRes pushBack _x
			};
		}
	foreach _LMCU;

	};

_HQ setVariable ["RydHQ_DefRes",_defRes];


_defPoints = [];
_defPointsOBJ = [];

{
deleteVehicle _x;
} foreach (_HQ getVariable ["DeldefPointsOBJ",[]]);

//waitUntil {if (_HQ getVariable ["BBDEF",false]) then  {_HQ getVariable ["BBDEFSPts",false]} else {true} };

if (_HQ getVariable ["BBDEF",false]) then {

	_defPointsBB = (_HQ getVariable ["BBDEFPts",[]]);

	{
		private ["_obj"];
		_obj = createSimpleObject ["Land_HelipadEmpty_F",[0,0,0]];
		_obj setPosATL _x;
		_defPoints pushBack _obj;
		_defPointsOBJ pushBack _obj;
	} foreach _defPointsBB;
};

_defPoints = _defPoints + [(leader _HQ)];



if ((_HQ getVariable ["RydHQ_DefendObjectives",0]) > 0) then 
	{
	_defPoints = _defPoints + (_HQ getVariable ["RydHQ_Taken",[]]); 
	
	/*switch (_HQ getVariable ["RydHQ_NObj",(leader _HQ)]) do
		{
		case (2) : {_defPoints = [(leader _HQ),(_HQ getVariable ["RydHQ_Obj1",(leader _HQ)])]};
		case (3) : {_defPoints = [(leader _HQ),(_HQ getVariable ["RydHQ_Obj1",(leader _HQ)]),(_HQ getVariable ["RydHQ_Obj2",(leader _HQ)])]};
		case (4) : {_defPoints = [(leader _HQ),(_HQ getVariable ["RydHQ_Obj1",(leader _HQ)]),(_HQ getVariable ["RydHQ_Obj2",(leader _HQ)]),(_HQ getVariable ["RydHQ_Obj3",(leader _HQ)])]};
		case (5) : {_defPoints = [(leader _HQ),(_HQ getVariable ["RydHQ_Obj1",(leader _HQ)]),(_HQ getVariable ["RydHQ_Obj2",(leader _HQ)]),(_HQ getVariable ["RydHQ_Obj3",(leader _HQ)]),(_HQ getVariable ["RydHQ_Obj4",(leader _HQ)])]};
		default {_defPoints = [(leader _HQ)]};
		}*/
	};

_ct = 1;
_cl = 0;
_clr = 0;


while {(_ct < 3)} do
	{
		{
		_x setVariable ["ClosestFor",0];
		_x setVariable ["ClosestForRec",0];
		}
	foreach _defPoints;

		{
		_closest = _defPoints select 0;
		_friend = vehicle (leader _x);
		_dstM = (_friend distance _closest);
			
			{
			_dstAct = _x distance _friend;
			if (_dstAct < _dstM) then {_dstM = _dstAct;_closest = _x};
			} 
		foreach _defPoints;

		_cl = _closest getVariable "ClosestFor";
		_clr = _closest getVariable "ClosestForRec";

		_closest setVariable ["ClosestFor",_cl + 1];
		if (_x in ((_HQ getVariable ["RydHQ_reconG",[]]) + (_HQ getVariable ["RydHQ_FOG",[]]) + (_HQ getVariable ["RydHQ_snipersG",[]]))) then {_closest setVariable ["ClosestForRec",_clr + 1]}
		}
	foreach _LMCU;

	/*if (_ct == 1) then
		{
		_defPoints0 = _defPoints - [(leader _HQ)];

			{
			_cl = _x getVariable "ClosestFor";
			if (_cl < (_HQ getVariable ["RydHQ_DefendObjectives",0])) then {_defPoints = _defPoints - [_x]}
			}
		foreach _defPoints0;
		};*/

	_ct = _ct + 1
	};

_exhausted = _HQ getVariable ["RydHQ_Exhausted",[]];

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
			
			if (not (_x in _exhausted) and not (_IsAPlayer) and (not (_vehready) or not (_solready))) then  
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
foreach (_LMCU + _airDef + _recDef);
_HQ setVariable ["RydHQ_Exhausted",_exhausted];

_HQ setVariable ["debugdef",_defPoints];

_defArray = [];
_Lenght1 = 500;
_Width1 = 500;
_Lenght2 = 500;
_Width2 = 500;
_FreeLOS = 320;

_PrimDir = "";
_SecDir = "";

_randomPrimDir = ["N","S","W","E"];
_randomSecDir = ["W","E"];

_DN = false;

_Angle = 0;

	{
	_PrimDir = "";
	_SecDir = "";
	_defPoint = _x;
	_dX = (_PosMid0) - ((getPos _defPoint) select 0);
	_dY = (_Posmid1) - ((getPos _defPoint) select 1);
		
	if not ((_dX == 0) or (_dY == 0)) then
		{
		_Angle = _dX atan2 _dY;
		};
	
	if ((count (_HQ getVariable ["RydHQ_KnEnPos",[]])) == 0) then
		{
		_Angle = getDir _defPoint
		};
	
	if (_Angle < 0) then {_Angle = _Angle + 360}; 
	
	_defFront = [];
	
	switch (_defPoint) do
		{
		case (_HQ getVariable ["leaderHQ",leader _HQ]) : 
			{
			_dL = _HQ getVariable "RydHQ_DefFrontL";
			if not (isNil "_dL") then {_defFront = _dL}
			};
			
		case (_HQ getVariable ["RydHQ_Obj1",leader _HQ]) : 
			{
			_d1 = _HQ getVariable "RydHQ_DefFront1";
			if not (isNil "_d1") then {_defFront = _d1}
			};
			
		case (_HQ getVariable ["RydHQ_Obj2",leader _HQ]) : 
			{
			_d2 = _HQ getVariable "RydHQ_DefFront2";
			if not (isNil "_d2") then {_defFront = _d2}
			};
			
		case (_HQ getVariable ["RydHQ_Obj3",leader _HQ]) : 
			{
			_d3 = _HQ getVariable "RydHQ_DefFront3";
			if not (isNil "_d3") then {_defFront = _d3}
			};
			
		case (_HQ getVariable ["RydHQ_Obj4",leader _HQ]) : 
			{
			_d4 = _HQ getVariable "RydHQ_DefFront4";
			if not (isNil "_d4") then {_defFront = _d4}
			};
		};

	if not ((count _defFront) == 0) then
		{
		_PrimDir = _defFront select 0;
		_SecDir = _defFront select 1;	
		
		switch (true) do
			{
			case ((_PrimDir == "N") and (_SecDir == "")) : {_Angle = 0};
			case ((_PrimDir == "N") and (_SecDir == "E")) : {_Angle = 45};
			case ((_PrimDir == "E") and (_SecDir == "")) : {_Angle = 90};
			case ((_PrimDir == "S") and (_SecDir == "E")) : {_Angle = 135};
			case ((_PrimDir == "S") and (_SecDir == "")) : {_Angle = 180};
			case ((_PrimDir == "S") and (_SecDir == "W")) : {_Angle = 225};
			case ((_PrimDir == "W") and (_SecDir == "")) : {_Angle = 270};
			case ((_PrimDir == "N") and (_SecDir == "W")) : {_Angle = 315};
			};
		};

	_dXb = 400 * (sin _Angle);
	_dYb = 400 * (cos _Angle);
	_posX = ((getPos _defPoint) select 0) + _dXb;

	_posY = ((getPos _defPoint) select 1) + _dYb;
	
	switch (true) do
		{
		case ((_Angle < 30) or (_Angle >= 330)) : {_PrimDir = "N"};
		case ((_Angle >= 30) and (_Angle < 60)) : {_PrimDir = "N";_SecDir = "E"};
		case ((_Angle >= 60) and (_Angle < 120)) : {_PrimDir = "E"};
		case ((_Angle >= 120) and (_Angle < 150)) : {_PrimDir = "S";_SecDir = "E"};
		case ((_Angle >= 150) and (_Angle < 210)) : {_PrimDir = "S"};
		case ((_Angle >= 210) and (_Angle < 240)) : {_PrimDir = "S";_SecDir = "W"};
		case ((_Angle >= 240) and (_Angle < 300)) : {_PrimDir = "W"};
		case ((_Angle >= 300) and (_Angle < 330)) : {_PrimDir = "N";_SecDir = "W"};
		};
		
	_HQ setVariable ["RydHQ_Angle",_Angle];

	_cl = _defPoint getVariable "ClosestFor";
	_clr = _defPoint getVariable "ClosestForRec";

	_Center = [_posX,_posY];
	_DN = false;

	_Lenght1 = 50 * _clr * _defRange;
	_Width1 = (100 + (5*_clr)) * _defRange;
	_Lenght2 = 50 * _cl * _defRange;
	_Width2 = (100 + (5*_cl)) * _defRange;

	_lng = _Lenght2;
	_wdt = _Width2;

	if (((_Angle >= 45) and (_Angle < 135)) or ((_Angle >= 225) and (_Angle < 315))) then 
		{
		_Lenght1 = 100 + (5*_clr);
		_Width1 = 50 * _clr;
		_Lenght2 = 100 + (5*_cl);
		_Width2 = 50 * _cl;
		};

	if ((_Center distance [_PosMid0,_PosMid1]) < 500) then 
		{
		_Lenght1 = 50 * _clr;
		_Width1 = 50 * _clr;
		_Lenght2 = 50 * _cl;
		_Width2 = 50 * _cl;
		};
		
	_defFront = [];
	_isHQ = false;
	
	switch (_defPoint) do
		{
		case (_HQ getVariable ["leaderHQ",leader _HQ]) : 
			{
			_dL = _HQ getVariable "RydHQ_DefFrontL";
			if not (isNil "_dL") then {_defFront = _dL;_isHQ = true}
			};
			
		case (_HQ getVariable ["RydHQ_Obj1",leader _HQ]) : 
			{
			_d1 = _HQ getVariable "RydHQ_DefFront1";
			if not (isNil "_d1") then {_defFront = _d1}
			};
			
		case (_HQ getVariable ["RydHQ_Obj2",leader _HQ]) : 
			{
			_d2 = _HQ getVariable "RydHQ_DefFront2";
			if not (isNil "_d2") then {_defFront = _d2}
			};
			
		case (_HQ getVariable ["RydHQ_Obj3",leader _HQ]) : 
			{
			_d3 = _HQ getVariable "RydHQ_DefFront3";
			if not (isNil "_d3") then {_defFront = _d3}
			};
			
		case (_HQ getVariable ["RydHQ_Obj4",leader _HQ]) : 
			{
			_d4 = _HQ getVariable "RydHQ_DefFront4";
			if not (isNil "_d4") then {_defFront = _d4}
			};
		};

	if not ((count _defFront) == 0) then
		{
		_PrimDir = _defFront select 0;
		_SecDir = _defFront select 1;

		_DN = true;
		_defDir = 0;

		switch (true) do
			{
			case ((_PrimDir == "N") and (_SecDir == "")) : {_defDir = 0};
			case ((_PrimDir == "N") and (_SecDir == "E")) : {_defDir = 45};
			case ((_PrimDir == "E") and (_SecDir == "")) : {_defDir = 90};
			case ((_PrimDir == "S") and (_SecDir == "E")) : {_defDir = 135};
			case ((_PrimDir == "S") and (_SecDir == "")) : {_defDir = 180};
			case ((_PrimDir == "S") and (_SecDir == "W")) : {_defDir = 225};
			case ((_PrimDir == "W") and (_SecDir == "")) : {_defDir = 270};
			case ((_PrimDir == "N") and (_SecDir == "W")) : {_defDir = 315};
			};
		
		_HQ setVariable ["RydHQ_Angle",_defDir];
		if (_isHQ) then
			{
			_HQ setVariable ["RydHQ_AngleR",_defDir];
			}
		};

	if ((_Center distance [_PosMid0,_PosMid1]) < 500) then {_Center = position _defPoint};

	if (_HQ getVariable ["RydHQ_Debug",false]) then 
		{
		_goodmark = [_Center,_defPoint,"Center","ColorGreen","ICON","mil_dot","Def Center","Def Center"] call RYD_Mark
		};

	_spotsN = _clr * 2;
	_goodSpotsRec = [_spotsN,_PrimDir,_SecDir,_FreeLOS,_Lenght1,_Width1,_Center,_HQ] call HAL_Spotscan;

	switch (true) do
		{
		case ((_PrimDir == "N") and (_SecDir == "")) : {_PrimDir = "S"};
		case ((_PrimDir == "N") and (_SecDir == "E")) : {_PrimDir = "S";_SecDir = "W"};
		case ((_PrimDir == "E") and (_SecDir == "")) : {_PrimDir = "W"};
		case ((_PrimDir == "S") and (_SecDir == "E")) : {_PrimDir = "N";_SecDir = "W"};
		case ((_PrimDir == "S") and (_SecDir == "")) : {_PrimDir = "N"};
		case ((_PrimDir == "S") and (_SecDir == "W")) : {_PrimDir = "N";_SecDir = "E"};
		case ((_PrimDir == "W") and (_SecDir == "")) : {_PrimDir = "E"};
		case ((_PrimDir == "N") and (_SecDir == "W")) : {_PrimDir = "S";_SecDir = "E"};
		};

	_spotsN = round (_cl * 1.5);
	_goodSpots = [_spotsN,_PrimDir,_SecDir,_FreeLOS,_Lenght2,_Width2,_Center,_HQ] call HAL_Spotscan;

	_angleV = _HQ getVariable ["RydHQ_Angle",0];

	_defArray pushBack [_defPoint,_goodSpotsRec,_goodSpots,_DN,[_dXb,_dYb],_angleV];
	}
foreach _defPoints;

_Spot = [];
_GS = [];
_recDefSpot = _HQ getVariable ["RydHQ_RecDefSpot",[]];
		
	{
	if not (isNull _x) then
		{
		if (({alive _x} count (units _x)) > 0) then
			{
			_isDef = _x getVariable "Defending";
			if (isNil "_isDef") then {_isDef = false};
			_Unable = _x getvariable "Unable";
			if (isNil ("_Unable")) then {_Unable = false};

			if (not (_isDef) and not (_Unable)) then
				{
				if not (_x in (_HQ getVariable ["RydHQ_Garrison",[]])) then
					{
					_ammo = [_x,(_HQ getVariable ["RydHQ_NCVeh",[]])] call RYD_AmmoCount;
					
					if (_ammo > 0) then
						{
						if (not (_x getVariable ["Busy" + (str _x),false]) and not (_x in (_HQ getVariable ["RydHQ_RecDefSpot",[]]))) then
							{
							_closestArr = _defArray select 0;
							_friend =  vehicle (leader _x);
							_dstM = _friend distance (_closestArr select 0);
								
								{
								_arrP = _x select 0;
								_dstAct = _arrP distance _friend;
								if (_dstAct < _dstM) then {_dstM = _dstAct;_closestArr = _x}
								}
							foreach _defArray;

							_goodSpots = _closestArr select 1;
							_angleV = _closestArr select 5;	

							if ((count _goodSpots) == 0) exitwith {};
							if not (_x in _recDefSpot) then 
								{
								_aa = 0;
								_Spot = _goodSpots select 0;
								for [{_a = 0},{_a < (count _goodSpots)},{_a = _a + 1}] do 
									{
									_GS = _goodSpots select _a;
									if (_a == 0) then {_Spot = _GS;_aa = 0};
									if ((_Spot distance (vehicle (leader _x))) > (_GS distance (vehicle (leader _x)))) then {_Spot = _GS;_aa = _a};
									};

								_goodSpots set [_aa,0]; 
								_goodSpots = _goodSpots - [0];
								_closestArr set [1,_goodSpots];
								[_x,_Spot,_angleV,_HQ] call HAL_GoDefRecon;
								_recDefSpot pushBack _x;
								_HQ setVariable ["RydHQ_RecDefSpot",_recDefSpot];
								}
							}
						}
					};
				}
			};
			
		if ((count _goodSpots) == 0) exitwith {};
		};
	if ((count _goodSpots) == 0) exitwith {}
	}
foreach (_recDef - (_HQ getVariable ["RydHQ_Exhausted",[]]));

_defSpot = _HQ getVariable ["RydHQ_DefSpot",[]];
			
switch ((random 100) >= (50/(0.5 + (_HQ getVariable ["RydHQ_Fineness",0.5])))) do
	{
	case true : 
		{			
			{
			if not (isNull _x) then
				{
				if (({alive _x} count (units _x)) > 0) then
					{
					_isDef = _x getVariable "Defending";
					if (isNil "_isDef") then {_isDef = false};
					_Unable = _x getvariable "Unable";
					if (isNil ("_Unable")) then {_Unable = false};

					if (not (_isDef) and not (_Unable)) then
						{
						if not (_x in (_HQ getVariable ["RydHQ_Garrison",[]])) then
							{
							_ammo = [_x,(_HQ getVariable ["RydHQ_NCVeh",[]])] call RYD_AmmoCount;
							
							if (_ammo > 0) then
								{
								if (not (_x getVariable ["Busy" + (str _x),false]) and not (_x in (_HQ getVariable ["RydHQ_DefSpot",[]]))) then
									{
									_closestArr = _defArray select 0;
									_friend =  vehicle (leader _x);
									_dstM = _friend distance (_closestArr select 0);
										
										{
										_arrP = _x select 0;
										_dstAct = _arrP distance _friend;
										if (_dstAct < _dstM) then {_dstM = _dstAct;_closestArr = _x}
										}
									foreach _defArray;

									_goodSpots = _closestArr select 2;_angleV = _closestArr select 5;_dXb = (_closestArr select 4) select 0;_dYb = (_closestArr select 4) select 1;	
									_DN = _closestArr select 3;

									if ((count _goodSpots) == 0) exitwith {};
									if not (_x in _defSpot) then 
										{
										_bb = 0;
										_Spot = _goodSpots select 0;
										for [{_b = 0},{_b < (count _goodSpots)},{_b = _b + 1}] do 
											{
											_GS = _goodSpots select _b;
											if ((_Spot distance (vehicle (leader _x))) > (_GS distance (vehicle (leader _x)))) then {_Spot = _GS;_bb = _b};
											};

										_goodSpots set [_bb,0]; 
										_goodSpots = _goodSpots - [0];
										_closestArr set [2,_goodSpots];
										[_x,_Spot,_dXb,_dYb,_DN,_angleV,_HQ] call HAL_GoDef;
										_defSpot = _HQ getVariable ["RydHQ_DefSpot",[]];
										_defSpot pushBack _x;
										_HQ setVariable ["RydHQ_DefSpot",_defSpot];
										};
									};
								};
							};
						};
					};

				if ((count _goodSpots) == 0) exitwith {}
				};

			if ((count _goodSpots) == 0) exitwith {}
			}
		foreach ((_LMCU - ((_HQ getVariable ["RydHQ_RecDefSpot",[]]) + (_HQ getVariable ["RydHQ_Exhausted",[]]) + (_HQ getVariable ["RydHQ_DefRes",[]]))) - (_HQ getVariable ["RydHQ_NoDef",[]]));

		for "_k" from 1 to ((count _airDef) - 1) do
			{
			_ad = _airDef select _k;
			if not (isNull _ad) then
			//if (false) then

				{
				if (({alive _x} count (units _ad)) > 0) then
					{
					_isDef = _ad getVariable "Defending";
					if (isNil "_isDef") then {_isDef = false};
					_Unable = _ad getvariable "Unable";
					if (isNil ("_Unable")) then {_Unable = false};

					if (not (_isDef) and not (_Unable)) then
						{
						_ammo = [_ad,(_HQ getVariable ["RydHQ_NCVeh",[]])] call RYD_AmmoCount;
						
						if (_ammo > 0) then
							{
							if ( not (_ad getVariable ["Busy" + (str _ad),false]) and not (_ad in (_HQ getVariable ["RydHQ_AirInDef",[]]))) then
								{
								_closestArr = _defArray select 0;
								_friend =  vehicle (leader _ad);
								_dstM = _friend distance (_closestArr select 0);
									
									{
									_arrP = _x select 0;
									_dstAct = _arrP distance _friend;
									if (_dstAct < _dstM) then {_dstM = _dstAct;_closestArr = _x}
									}
								foreach _defArray;

								//_Spot = _closestArr select 0;
								_Spot = (selectrandom _defArray) select 0;

								_AirInDef = _HQ getVariable ["RydHQ_AirInDef",[]];
								_AirInDef pushBack _ad;
								_HQ setVariable ["RydHQ_AirInDef",_AirInDef];	

								_ad setVariable [("Busy" + (str _ad)), false];
								[_ad,_Spot,_HQ] call HAL_GoDefAir;
								}
							}
						}
					}
				}
			};


			{
			if not (isNull _x) then
				{
				if (({alive _x} count (units _x)) > 0) then
					{
					_isDef = _x getVariable "Defending";
					if (isNil "_isDef") then {_isDef = false};
					_Unable = _x getvariable "Unable";
					if (isNil ("_Unable")) then {_Unable = false};

					if (not (_isDef) and not (_Unable)) then
						{
						if not (_x in []) then 
							{
							if not (_x in (_HQ getVariable ["RydHQ_Garrison",[]])) then
								{
								_ammo = [_x,(_HQ getVariable ["RydHQ_NCVeh",[]])] call RYD_AmmoCount;
								
								if (_ammo > 0) then
									{
									if not ((_x getVariable ["Busy" + (str _x),false]) and (_x in ((_HQ getVariable ["RydHQ_DefSpot",[]]) + (_HQ getVariable ["RydHQ_Def",[]])))) then
										{
										_closestArr = _defArray select 0;
										_friend =  vehicle (leader _x);
										_dstM = _friend distance (_closestArr select 0);
											
											{
											_arrP = _x select 0;
											_dstAct = _arrP distance _friend;
											if (_dstAct < _dstM) then {_dstM = _dstAct;_closestArr = _x}
											}
										foreach _defArray;

										_SpotB = _closestArr select 0;
										_angleV = _closestArr select 5;

										_ct = _SpotB getVariable "ClosestFor";

										_SpotB = position _SpotB;
										_DN = _closestArr select 3;
										_dXb = (_closestArr select 4) select 0;
										_dYb = (_closestArr select 4) select 1;



										_radius = (50 + (50 * _ct)) * _defRange;
										_position = [(_SpotB select 0) + (random (2*_radius)) - _radius,(_SpotB select 1) + (random (2*_radius)) - _radius];
										_radius = 100 * _defRange;;
										_precision = 20 * _defRange;;
										_sourcesCount = 1;
										_expression = "Meadow";
										switch (true) do 
											{
											case (_x in (_HQ getVariable ["RydHQ_InfG",[]])) : {_expression = "(1 + (2 * Houses)) * (1 + (1.5 * Forest)) * (1 + Trees) * (1 - Meadow) * (1 - (10 * sea))"};
											case (not (_x in (_HQ getVariable ["RydHQ_InfG",[]]))) : {_expression = "(1 + (2 * Meadow)) * (1 - Forest) * (1 - (0.5 * Trees)) * (1 - (10 * sea))"};
											};
										_Spot = selectBestPlaces [_position,_radius,_expression,_precision,_sourcesCount];
										
										if ((count _Spot) < 1) exitWith {};
										
										_Spot = _Spot select 0;
										_Spot = _Spot select 0;
										if ((random 100) > 70/(0.75 + ((_HQ getVariable ["RydHQ_Fineness",0.5])/2))) then 
											{
											_NR = _Spot nearRoads (200 * _defRange);
											_cnt = 0;
											if not ((count _NR) == 0) then 
												{
												while {(true)} do
													{
													_cnt = _cnt + 1;
													_Rpoint = _NR select (floor (random (count _NR)));
													_posX = ((position _Rpoint) select 0) + (((random 100) - 50) * _defRange);
													_posY = ((position _Rpoint) select 1) + (((random 100) - 50) * _defRange);
													if (not (isOnRoad [_posX,_posY]) and (([_posX,_posY] distance _Rpoint) > 10) or (_cnt > 10)) exitwith {if (_cnt <= 10) then {_Spot = [_posX,_posY]}};
													}
												};
											};

										[_x,_Spot,_dXb,_dYb,_DN,_angleV,_HQ] call HAL_GoDef;
										};
									};
								};
							};
						};
					}
				}
			}
		foreach ((_LMCU - ((_HQ getVariable ["RydHQ_DefSpot",[]]) + (_HQ getVariable ["RydHQ_Exhausted",[]]) + (_HQ getVariable ["RydHQ_RecDefSpot",[]]) + (_HQ getVariable ["RydHQ_DefRes",[]])) + (_HQ getVariable ["RydHQ_NCCargoG",[]])) - (_HQ getVariable ["RydHQ_NoDef",[]]));
		};
		
	case false : 
		{
			{
			if not (isNull _x) then
				{
				if (({alive _x} count (units _x)) > 0) then
					{
					_isDef = _x getVariable "Defending";
					if (isNil "_isDef") then {_isDef = false};
					_Unable = _x getvariable "Unable";
					if (isNil ("_Unable")) then {_Unable = false};

					if (not (_isDef) and not (_Unable)) then
						{
						if not (_x in []) then 
							{
							if not (_x in (_HQ getVariable ["RydHQ_Garrison",[]])) then
								{
								_ammo = [_x,(_HQ getVariable ["RydHQ_NCVeh",[]])] call RYD_AmmoCount;
								
								if (_ammo > 0) then
									{
									if not ((_x getVariable ["Busy" + (str _x),false]) and (_x in ((_HQ getVariable ["RydHQ_DefSpot",[]]) + (_HQ getVariable ["RydHQ_Def",[]])))) then
										{
										_closestArr = _defArray select 0;
										_friend =  vehicle (leader _x);
										_dstM = _friend distance (_closestArr select 0);
											
											{
											_arrP = _x select 0;
											_dstAct = _arrP distance _friend;
											if (_dstAct < _dstM) then {_dstM = _dstAct;_closestArr = _x}
											}
										foreach _defArray;

										_SpotB = _closestArr select 0;_angleV = _closestArr select 5;
										_ct = _SpotB getVariable "ClosestFor";
										_SpotB = position _SpotB;
										_DN = _closestArr select 3;
										_dXb = (_closestArr select 4) select 0;
										_dYb = (_closestArr select 4) select 1;

										_radius = (50 + (50 * _ct)) * _defRange;
										_position = [(_SpotB select 0) + (random (2*_radius)) - _radius,(_SpotB select 1) + (random (2*_radius)) - _radius];
										_radius = 100 * _defRange;
										_precision = 20 * _defRange;
										_sourcesCount = 1;
										_expression = "Meadow";
										switch (true) do 
											{
											case (_x in (_HQ getVariable ["RydHQ_InfG",[]])) : {_expression = "(1 + (2 * Houses)) * (1 + (1.5 * Forest)) * (1 + Trees) * (1 - Meadow) * (1 - (10 * sea))"};
											case (not (_x in (_HQ getVariable ["RydHQ_InfG",[]]))) : {_expression = "(1 + (2 * Meadow)) * (1 - Forest) * (1 - (0.5 * Trees)) * (1 - (10 * sea))"};
											};
										_Spot = selectBestPlaces [_position,_radius,_expression,_precision,_sourcesCount];
										
										if ((count _Spot) < 1) exitWith {};
										
										_Spot = _Spot select 0;
										_Spot = _Spot select 0;
										if ((random 100) > 70/(0.75 + ((_HQ getVariable ["RydHQ_Fineness",0.5])/2))) then 
											{
											_NR = _Spot nearRoads (200 * _defRange);
											_cnt = 0;
											if not ((count _NR) == 0) then 
												{
												while {(true)} do
													{
													 _cnt = _cnt + 1;
													_Rpoint = _NR select (floor (random (count _NR)));
													_posX = ((position _Rpoint) select 0) + (((random 100) - 50) * _defRange);
													_posY = ((position _Rpoint) select 1) + (((random 100) - 50) * _defRange);
													if (not (isOnRoad [_posX,_posY]) and (([_posX,_posY] distance _Rpoint) > 10) or (_cnt > 10)) exitwith {if (_cnt <= 10) then {_Spot = [_posX,_posY]}};
													}
												};
											};
										
										[_x,_Spot,_dXb,_dYb,_DN,_angleV,_HQ] call HAL_GoDef;
										}
									}
								}
							}
						}
					}
				}
			}
		foreach ((_LMCU - ((_HQ getVariable ["RydHQ_RecDefSpot",[]]) + (_HQ getVariable ["RydHQ_Exhausted",[]]) + (_HQ getVariable ["RydHQ_DefRes",[]])) + (_HQ getVariable ["RydHQ_NCCargoG",[]])) - (_HQ getVariable ["RydHQ_NoDef",[]]));

		for "_k" from 0 to ((count _airDef) - 1) do
			{
			_ad = _airDef select _k;
			if not (isNull _ad) then
				{
				if (({alive _x} count (units _ad)) > 0) then
					{
					_isDef = _ad getVariable "Defending";
					if (isNil "_isDef") then {_isDef = false};
					_Unable = _ad getvariable "Unable";
					if (isNil ("_Unable")) then {_Unable = false};

					if (not (_isDef) and not (_Unable)) then
					//if (false) then

						{
						_ammo = [_ad,(_HQ getVariable ["RydHQ_NCVeh",[]])] call RYD_AmmoCount;
						
						if (_ammo > 0) then
							{
							if (not (_ad getVariable ["Busy" + (str _ad),false]) and not (_ad in (_HQ getVariable ["RydHQ_AirInDef",[]]))) then
								{
								_defArray params ["_closestArr"];
								_friend =  vehicle (leader _ad);
								_dstM = _friend distance (_closestArr select 0);
									
									{
									_x params ["_arrP"];
									_dstAct = _arrP distance _friend;
									if (_dstAct < _dstM) then {_dstM = _dstAct;_closestArr = _x}
									}
								foreach _defArray;

								//_Spot = _closestArr select 0;
								_Spot = (selectrandom _defArray) select 0;


								_AirInDef = _HQ getVariable ["RydHQ_AirInDef",[]];
								_AirInDef pushBack _ad;
								_HQ setVariable ["RydHQ_AirInDef",_AirInDef];
								
								_ad setVariable [("Busy" + (str _ad)), false];
								[_ad,_Spot,_HQ] call HAL_GoDefAir
								}
							}
						}
					}
				}
			}
		};
	};
	
	{
	if not (isNull _x) then
		{
		if (({alive _x} count (units _x)) > 0) then
			{
			_isDef = _x getVariable "Defending";
			if (isNil "_isDef") then {_isDef = false};
			_Unable = _x getvariable "Unable";
			if (isNil ("_Unable")) then {_Unable = false};

			if (not (_isDef) and not (_Unable)) then
			//if (false) then
				{
				if not (_x in []) then 
					{
					if not (_x in (_HQ getVariable ["RydHQ_Garrison",[]])) then
						{
						_ammo = [_x,(_HQ getVariable ["RydHQ_NCVeh",[]])] call RYD_AmmoCount;
						
						if (_ammo > 0) then
							{
							if (not (_x getVariable ["Busy" + (str _x),false]) and not (_x in (_HQ getVariable ["RydHQ_DefSpot",[]]))) then
								{
								//_posX = ((position ((selectrandom _defArray) select 0)) select 0) + (random 200) - 50;
								//_posY = ((position ((selectrandom _defArray) select 0)) select 1) + (random 200) - 50;
								//_Spot = [_posX,_posY];

								_Spot = (selectrandom _defArray) select 0;

								[_x,_Spot,_HQ] call HAL_GoDefRes;
								
								}
							}
						}
					}
				}
			}
		}
	}
foreach ((_HQ getVariable ["RydHQ_DefRes",[]]) - (_HQ getVariable ["RydHQ_NoDef",[]]) - (_HQ getVariable ["RydHQ_Exhausted",[]]));

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
	if (not (_busy) and not (_Unable) and ((count (waypoints _x)) <= 1) and not (_deployed) and not (_isDef) and not (_capturing) and not ((_HQ getVariable ["RydHQ_TakenNaval",[]]) isEqualTo []) and (not (_x in (_HQ getVariable ["RydHQ_NCCargoG",[]])) or ((count (units _x)) > 1))) then 
		{
		deleteWaypoint ((waypoints _x) select 0);
		//[_x,_HQ] spawn HAL_GoIdle
			[_x,selectrandom (_HQ getVariable ["RydHQ_TakenNaval",[]]),_HQ] call HAL_GoDefNav;
		};
	}
foreach (_HQ getVariable ["RydHQ_NavalG",[]]);

_HQ setVariable ["DeldefPointsOBJ",_defPointsOBJ];

