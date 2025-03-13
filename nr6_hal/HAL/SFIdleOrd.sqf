_SCRname = "SFIdleOrd";

private [];

_HQ = _this select 0;

_pos = getPosATL (vehicle (leader _HQ));

	{
	_isBad = false;
	if (isNull _x) then
		{
		_isBad = true
		}
	else
		{
		if not (alive (leader _x)) then
			{
			_isBad = true
			}
		else
			{
			_isBad = _x getVariable [("Resting" + (str _x)),false];
			if not (_isBad) then
				{
				_isBad = _x getVariable [("Busy" + (str _x)),false]
				}
			}
		};

	if not (_isBad) then
		{
		_unitG = _x;
		[_unitG] call CBA_fnc_clearWaypoints;

		_pos = getPosATL (vehicle (leader _HQ));
		_posX = (_pos select 0) + (random 200) - 100;
		_posY = (_pos select 1) + (random 200) - 100;

		_isWater = surfaceIsWater [_posX,_posY];
		_cnt = 0;

		while {((_isWater) or (_cnt > 100))} do
			{
			_cnt = _cnt + 1;
			_posX = (_pos select 0) + (random 200) - 100;
			_posY = (_pos select 1) + (random 200) - 100;
			_isWater = surfaceIsWater [_posX,_posY]
			};

		if not (_isWater) then
			{
			_UL = leader _unitG;

			_tasks = _unitG getVariable ["HACAddedTasks",[]];

			if ((count _tasks) == 0) then
				{
				_task = [_UL,["Guard HQ.", "Guard", ""],[_posX,_posY]] call RYD_AddTask
				};

			_wp = [_unitG,[_posX,_posY],"HOLD","AWARE","RED","NORMAL"] call RYD_WPadd
			}
		}
	}
forEach  (_HQ getVariable ["RydHQ_SpecForG",[]]);
