_SCRname = "Rev";

private ["_HQ","_players","_KnU","_ldr","_dst","_friends","_enemies"];

_HQ = _this select 0;

_players = [];
_friends = (_HQ getVariable ["RydHQ_Friends",[]]);
_enemies = (_HQ getVariable ["RydHQ_KnEnemies",[]]);

if (_HQ getVariable ["RydHQ_KnowTL",true]) then 
	{
		{
		if (isPlayer (leader _x)) then {_players pushBack _x};
		}
	forEach _friends;
	};

for [{_z = 0},{_z < (count _enemies)},{_z = _z + 1}] do
	{
	_KnU = _enemies select _z;

		{
		if ((_x knowsAbout _KnU) > 0.01) then 
			{
				{
				_x reveal [_KnU,2]
				} 
			forEach ([_HQ] + _players);

			if (RydxHQ_NEAware > 0) then
				{
					{
					_ldr = vehicle (leader _x);
					_dst = _ldr distance (vehicle _KnU); 
					if (_dst < RydxHQ_NEAware) then
						{
						_x reveal [_KnU,2]
						}
					}
				forEach _friends;
				}
			}
		}
	forEach _friends 
	};

for [{_z = 0},{_z < (count _friends)},{_z = _z + 1}] do
	{
	_KnU = _friends select _z;

		{
		_x reveal [(vehicle (leader _KnU)),4]
		} 
	forEach ([_HQ] + _players)
	};