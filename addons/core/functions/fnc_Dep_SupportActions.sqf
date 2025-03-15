//DEPRECATED - Replaced by Task Menu - Moved out.
if ((_x == leader _x) and not (_x getVariable ["HAL_Task1Added",false]) and (_IsHal)) then {

	if not (RydxHQ_ActionsAceOnly) then {

		[_x] remoteExecCall ["Action1fnc",_x];
	};

	if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

		[_x] remoteExecCall ["ACEAction1fnc",_x];				
					
	};
		_x setVariable ["HAL_Task1Added",true];
	};

	if ((_x == leader _x) and not (_x getVariable ["HAL_Task2Added",false]) and (_IsHal)) then {

		if not (RydxHQ_ActionsAceOnly) then {

			[_x] remoteExecCall ["Action2fnc",_x];
					
		};

		if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

			[_x] remoteExecCall ["ACEAction2fnc",_x];
					
		};

		_x setVariable ["HAL_Task2Added",true];
	};

	if ((_x == leader _x) and not (_x getVariable ["HAL_Task3Added",false]) and (_IsHal)) then {

		if not (RydxHQ_ActionsAceOnly) then {

			[_x] remoteExecCall ["Action3fnc",_x];
					
		};

		if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

			[_x] remoteExecCall ["ACEAction3fnc",_x];
					
		};

		_x setVariable ["HAL_Task3Added",true];
	};

	if ((not (_x == leader _x) and (_x getVariable ["HAL_Task1Added",false])) or (not (_IsHal) and (_x getVariable ["HAL_Task1Added",false]))) then {

		if not (RydxHQ_ActionsAceOnly) then {

			[_x] remoteExecCall ["Action1fncR",_x];

		};
		if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

			[_x] remoteExecCall ["ACEAction1fncR",_x];

		};
		_x setVariable ["HAL_Task1Added",false];

	};

	if ((not (_x == leader _x) and (_x getVariable ["HAL_Task2Added",false])) or (not (_IsHal) and (_x getVariable ["HAL_Task2Added",false]))) then {

		if not (RydxHQ_ActionsAceOnly) then {

			[_x] remoteExecCall ["Action2fncR",_x];
					
		};
		if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

			[_x] remoteExecCall ["ACEAction2fncR",_x];

		};
		_x setVariable ["HAL_Task2Added",false];

	};

	if ((not (_x == leader _x) and (_x getVariable ["HAL_Task3Added",false])) or (not (_IsHal) and (_x getVariable ["HAL_Task3Added",false]))) then {

		if not (RydxHQ_ActionsAceOnly) then {

			[_x] remoteExecCall ["Action3fncR",_x];
					
		};
		if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

			[_x] remoteExecCall ["ACEAction3fncR",_x];
				
		};
	_x setVariable ["HAL_Task3Added",false];
};