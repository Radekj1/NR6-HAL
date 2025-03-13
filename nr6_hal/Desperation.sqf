_SCRname = "Desperado";

private ["_HQ","_rInit","_reck","_ally","_enemy","_leader","_distAllyS","_dist","_cAlly","_midD","_distEnemyS","_nearE","_distE","_distEnemyS","_cEnemy","_midDE"];

_HQ = _this select 0;

_rInit = _HQ getVariable ["RydHQ_Recklessness_Init",0.5];

_reck = _HQ getVariable ["RydHQ_Recklessness",0.5];
_ally = _HQ getVariable ["RydHQ_Friends",[]];
_enemy = _HQ getVariable ["RydHQ_KnEnemiesG",[]];

_leader = leader _HQ;
_distAllyS = 0;

	{
	_dist = (vehicle (leader _x)) distance _leader;
	_distAllyS = _distAllyS + _dist;
	}
forEach _ally;

_cAlly = count _ally;
_midD = 20000;
if not (_cAlly == 0) then {_midD = _distAllyS/_cAlly};


_distEnemyS = 0;
_nearE = false;

	{
	_distE = (vehicle (leader _x)) distance _leader;
	_distEnemyS = _distEnemyS + _distE;
	if (_distE < 600) then {_nearE = true};
	}
forEach _enemy;

_cEnemy = count _enemy;
_midDE = 20000;
if not (_cEnemy == 0) then {_midDE = _distEnemyS/_cEnemy};

if (((_midD > _midDE) and (_midDE < 2000)) or (_nearE)) then 
	{
	_HQ setVariable ["RydHQ_Recklessness",(_rInit + 0.2) * 10]
	}
else
	{
	_HQ setVariable ["RydHQ_Recklessness",_rInit]
	};
