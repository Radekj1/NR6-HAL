_SCRname = "Flanking";

private ["_ldr","_Fineness","_obj","_KnEnemies","_FlankAv","_Epos0","_Epos1","_default","_Epos0Max","_Epos0Min","_sel0Max","_sel0Min","_Epos1Max","_Epos1Min","_sel1Max","_sel1Min",
	"_EposA","_EposB","_max0Enemy","_min0Enemy","_max1Enemy","_min1Enemy","_PosMid0","_PosMid1","_dX","_dY","_angle0","_BEnemyPosA","_BEnemyPosB","_BEnemyPos","_rnd1","_rnd2","_minF",
	"_maxF","_bothF","_FlankU","_AAO"];
params ["_HQ"];

_AAO = _HQ getVariable ["RydHQ_ChosenAAO",false];

_ldr = vehicle (leader _HQ);
_Fineness = _HQ getVariable ["RydHQ_Fineness",0.5];
_obj = _HQ getVariable ["RydHQ_Obj",_ldr];

if (_AAO) then
	{
	_nT = ((_HQ getVariable ["RydHQ_Objectives",[]]) - (_HQ getVariable ["RydHQ_Taken",[]]));
	if ((count _nT) < 1) then {_nT = (_HQ getVariable ["RydHQ_Objectives",[]])};
	if ((count _nT) > 0) then {_obj = _nT select 0};
	};

_KnEnemies = _HQ getVariable ["RydHQ_KnEnemies",[]];
_FlankAv = _HQ getVariable ["RydHQ_FlankAv",[]];

_Epos0 = [];
_Epos1 = [];

_default = getPosATL _obj;

if (_AAO) then
	{
	_default = _HQ getVariable ["RydHQ_EyeOfBattle",getPosATL _obj]
	};

if not ((count _KnEnemies) == 0) then 
	{
		{
		_Epos0 pushBack ((getPosATL _x) select 0);
		_Epos1 pushBack ((getPosATL _x) select 1)
		}
	foreach _KnEnemies
	};

_Epos0Max = _default select 0;
_Epos0Min = _default select 0;
_sel0Max = 0;
_sel0Min = 0;

for [{_a = 0},{_a < (count _Epos0)},{_a = _a + 1}] do 
	{
	_EposA = _Epos0 select _a;
	if (_a == 0) then {_Epos0Min = _EposA;_sel0Min = _a};
	if (_a == 0) then {_Epos0Max = _EposA;_sel0Max = _a};
	if (_Epos0Min >= _EposA) then {_Epos0Min = _EposA;_sel0Min = _a};
	if (_Epos0Max < _EposA) then {_Epos0Max = _EposA;_sel0Max = _a};
	};

_Epos1Max = _default select 1;
_Epos1Min = _default select 1;
_sel1Max = 1;
_sel1Min = 1;

for [{_b = 0},{_b < (count _Epos1)},{_b = _b + 1}] do 
	{
	_EposB = _Epos1 select _b;
	if (_b == 0) then {_Epos1Min = _EposB;_sel1Min = _b};
	if (_b == 0) then {_Epos1Max = _EposB;_sel1Max = _b};
	if (_Epos1Min >= _EposB) then {_Epos1Min = _EposB;_sel1Min = _b};
	if (_Epos1Max < _EposB) then {_Epos1Max = _EposB;_sel1Max = _b};
	};

_max0Enemy = _obj;
_min0Enemy = _obj;

_max1Enemy = _obj;
_min1Enemy = _obj;

if not ((count _KnEnemies) == 0) then 
	{
	_max0Enemy = _KnEnemies select _sel0Max;
	_min0Enemy = _KnEnemies select _sel0Min;

	_max1Enemy = _KnEnemies select _sel1Max;
	_min1Enemy = _KnEnemies select _sel1Min
	};

_PosMid0 = (_Epos0Min + _Epos0Max)/2;
_PosMid1 = (_Epos1Min + _Epos1Max)/2;

_dX = (_PosMid0) - ((getPosATL _ldr) select 0);
_dY = (_Posmid1) - ((getPosATL _ldr) select 1);

_angle0 = _dX atan2 _dY;

if (_angle0 < 0) then {_angle0 = _angle0 + 360}; 

_BEnemyPosA = [];
_BEnemyPosB = [];
_BEnemyPos = [];

if ((_angle0 <= 45) or ((_angle0 > 135) and (_angle0 <= 225)) or (_angle0 > 315)) then 
	{
	_BEnemyPosA = getPosATL _min0Enemy;
	_BEnemyPosB = getPosATL _max0Enemy
	} 
else 
	{
	_BEnemyPosA = getPosATL _min1Enemy;
	_BEnemyPosB = getPosATL _max1Enemy
	};

_rnd1 = random 100;
_rnd2 = random 100;

_minF = false;
_maxF = false;
_bothF = false;

switch true do
	{
	case ((_rnd1 >= (10/(0.5 + _Fineness))) and  (_rnd1 < (55/(0.5 + _Fineness))) and (_rnd2 < 50)) : {_minF =  true};
	case ((_rnd1 >= (10/(0.5 + _Fineness))) and  (_rnd1 < (55/(0.5 + _Fineness))) and (_rnd2 >= 50)) : {_maxF = true};
	case (_rnd1 >= (55/(0.5 + _Fineness))) : {_bothF = true};
	};
	
	{
	_del = false;
	
	switch (true) do
		{
		case (_x in (_HQ getVariable ["RydHQ_Garrison",[]])) : {_del = true};
		};
		
	if (_del) then 
		{
		_FlankAv set [_foreachIndex,grpNull]
		}
	}
foreach _FlankAv;

_FlankAv = _FlankAv - [grpNull];

switch true do
	{
	case (_minF or _maxF) : 
		{
			{
			if (_minF) then 
				{
				[_x,_BEnemyPosA,_PosMid0,_PosMid1,_angle0,true,_HQ] call HAL_GoFlank;
				} 
			else 
				{
				[_x,_BEnemyPosB,_PosMid0,_PosMid1,_angle0,false,_HQ] call HAL_GoFlank;
				};
			}
		foreach _FlankAv;
		
		};
	case (_bothF) : 
		{

		for [{_b = 0},{_b < (count _FlankAv)},{_b = _b + 1}] do
			{
			_FlankU = _FlankAv select _b;
			if ((_b/2 - floor (_b/2)) == 0) then 
				{
				[_FlankU,_BEnemyPosA,_PosMid0,_PosMid1,_angle0,true,_HQ] call HAL_GoFlank;
				} 
			else 
				{
				[_FlankU,_BEnemyPosB,_PosMid0,_PosMid1,_angle0,false,_HQ] call HAL_GoFlank; 
				}
			}		
		}
	};

_HQ setVariable ["RydHQ_FlankingDone",true];

_HQ setVariable ["RydHQ_FlankAv",[]];
