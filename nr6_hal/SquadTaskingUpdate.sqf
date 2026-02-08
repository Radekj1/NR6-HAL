params ["_newLeader","LeaderHQ","LeaderHQB","LeaderHQC","LeaderHQD","LeaderHQE","LeaderHQF","LeaderHQG","LeaderHQH"];

	private _HalFriends = [];
	{
		private _hq = missionNamespace getVariable [_newLeader, objNull];
		if (!isNull _hq) then {
			_HalFriends append (group _hq getVariable ["RydHQ_Friends", []]);
		};
	} forEach ["LeaderHQ","LeaderHQB","LeaderHQC","LeaderHQD","LeaderHQE","LeaderHQF","LeaderHQG","LeaderHQH"];

private ["_IsHal"];
{
if ((group _newLeader in _HalFriends) or ((group _newLeader) getVariable ["EnableHALActions",false])) then {
	_IsHal = true;
} else {
	_IsHal = false;
};
{
if (RydxHQ_ActionsMenu) then 
{

		if ((_newLeader == leader _newLeader) and (not (_newLeader getVariable ["HAL_TaskMenuAdded",false]) or not (_newLeader == (_newLeader getVariable ["HAL_PlayerUnit",objnull]))) and (_IsHal)) then 
		{
			if not (RydxHQ_ActionsAceOnly) then 
			{
				[_newLeader] remoteExecCall ["ActionMfnc",_newLeader];					
			};

			if ((isClass(configFile >> "CfgPatches" >> "ace_main")) and not (_newLeader getVariable ["HAL_TaskMenuAdded",false])) then 
			{
				[_newLeader] remoteExecCall ["ACEActionMfnc",_newLeader];				
			};
			_newLeader setVariable ["HAL_TaskMenuAdded",true];
			_newLeader setVariable ["HAL_PlayerUnit",_newLeader];
		};

	if ((not (_newLeader == leader _newLeader) and (_newLeader getVariable ["HAL_TaskMenuAdded",false])) or (not (_IsHal) and (_newLeader getVariable ["HAL_TaskMenuAdded",false]))) then 
	{
		if not (RydxHQ_ActionsAceOnly) then 
			{
				[_newLeader] remoteExecCall ["ActionMfncR",_newLeader];
						
			};
			if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

				[_newLeader] remoteExecCall ["ACEActionMfncR",_newLeader];

			};
		_newLeader setVariable ["HAL_TaskMenuAdded",false];

	};
}; 
		// BELOW IS DEPRECATED
			//Tasking

if (RydxHQ_TaskActions) then {
		
	if ((_newLeader == leader _newLeader) and not (_newLeader getVariable ["HAL_Task1Added",false]) and (_IsHal)) then {

		if not (RydxHQ_ActionsAceOnly) then {

			[_newLeader] remoteExecCall ["Action1fnc",_newLeader];
		};

		if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

			[_newLeader] remoteExecCall ["ACEAction1fnc",_newLeader];				
					
		};
		_newLeader setVariable ["HAL_Task1Added",true];
	};

	if ((_newLeader == leader _newLeader) and not (_newLeader getVariable ["HAL_Task2Added",false]) and (_IsHal)) then {

		if not (RydxHQ_ActionsAceOnly) then {

			[_newLeader] remoteExecCall ["Action2fnc",_newLeader];
					
		};

		if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

			[_newLeader] remoteExecCall ["ACEAction2fnc",_newLeader];
					
		};

		_newLeader setVariable ["HAL_Task2Added",true];
	};

	if ((_newLeader == leader _newLeader) and not (_newLeader getVariable ["HAL_Task3Added",false]) and (_IsHal)) then {

		if not (RydxHQ_ActionsAceOnly) then {

			[_newLeader] remoteExecCall ["Action3fnc",_newLeader];
					
		};

		if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

			[_newLeader] remoteExecCall ["ACEAction3fnc",_newLeader];
					
		};

		_newLeader setVariable ["HAL_Task3Added",true];
	};

	if ((not (_newLeader == leader _newLeader) and (_newLeader getVariable ["HAL_Task1Added",false])) or (not (_IsHal) and (_newLeader getVariable ["HAL_Task1Added",false]))) then {

		if not (RydxHQ_ActionsAceOnly) then {

			[_newLeader] remoteExecCall ["Action1fncR",_newLeader];

		};
				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_newLeader] remoteExecCall ["ACEAction1fncR",_newLeader];

				};
				_newLeader setVariable ["HAL_Task1Added",false];

			};

			if ((not (_newLeader == leader _newLeader) and (_newLeader getVariable ["HAL_Task2Added",false])) or (not (_IsHal) and (_newLeader getVariable ["HAL_Task2Added",false]))) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_newLeader] remoteExecCall ["Action2fncR",_newLeader];
					
				};
				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_newLeader] remoteExecCall ["ACEAction2fncR",_newLeader];

				};
				_newLeader setVariable ["HAL_Task2Added",false];

			};

			if ((not (_newLeader == leader _newLeader) and (_newLeader getVariable ["HAL_Task3Added",false])) or (not (_IsHal) and (_newLeader getVariable ["HAL_Task3Added",false]))) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_newLeader] remoteExecCall ["Action3fncR",_newLeader];
					
				};
				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_newLeader] remoteExecCall ["ACEAction3fncR",_newLeader];
					
				};
				_newLeader setVariable ["HAL_Task3Added",false];

			};
		
		};
	};

		//Supports
if (RydxHQ_SupportActions) then {

			if ((_newLeader == leader _newLeader) and not (_newLeader getVariable ["HAL_Task4Added",false]) and (_IsHal)) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_newLeader] remoteExecCall ["Action4fnc",_newLeader];
					
				};

				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_newLeader] remoteExecCall ["ACEAction4fnc",_newLeader];
					
				};

				_newLeader setVariable ["HAL_Task4Added",true];
			};

			if ((not (_newLeader == leader _newLeader) and (_newLeader getVariable ["HAL_Task4Added",false])) or (not (_IsHal) and (_newLeader getVariable ["HAL_Task4Added",false]))) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_newLeader] remoteExecCall ["Action4fncR",_newLeader];
					
				};
				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_newLeader] remoteExecCall ["ACEAction4fncR",_newLeader];

				};
				_newLeader setVariable ["HAL_Task4Added",false];

			};

			if ((_newLeader == leader _newLeader) and not (_newLeader getVariable ["HAL_Task5Added",false]) and (_IsHal)) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_newLeader] remoteExecCall ["Action5fnc",_newLeader];
					
				};

				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_newLeader] remoteExecCall ["ACEAction5fnc",_newLeader];
					
				};

				_newLeader setVariable ["HAL_Task5Added",true];
			};

			if ((not (_newLeader == leader _newLeader) and (_newLeader getVariable ["HAL_Task5Added",false])) or (not (_IsHal) and (_newLeader getVariable ["HAL_Task5Added",false]))) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_newLeader] remoteExecCall ["Action5fncR",_newLeader];
					
				};
				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_newLeader] remoteExecCall ["ACEAction5fncR",_newLeader];

				};
				_newLeader setVariable ["HAL_Task5Added",false];

			};

			if ((_newLeader == leader _newLeader) and not (_newLeader getVariable ["HAL_Task6Added",false]) and (_IsHal)) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_newLeader] remoteExecCall ["Action6fnc",_newLeader];
					
				};

				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_newLeader] remoteExecCall ["ACEAction6fnc",_newLeader];
					
				};

				_newLeader setVariable ["HAL_Task6Added",true];
			};

			if ((not (_newLeader == leader _newLeader) and (_newLeader getVariable ["HAL_Task6Added",false])) or (not (_IsHal) and (_newLeader getVariable ["HAL_Task6Added",false]))) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_newLeader] remoteExecCall ["Action6fncR",_newLeader];
					
				};
				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_newLeader] remoteExecCall ["ACEAction6fncR",_newLeader];

				};
				_newLeader setVariable ["HAL_Task6Added",false];

			};

			if ((_newLeader == leader _newLeader) and not (_newLeader getVariable ["HAL_Task7Added",false]) and (_IsHal)) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_newLeader] remoteExecCall ["Action7fnc",_newLeader];
					
				};

				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_newLeader] remoteExecCall ["ACEAction7fnc",_newLeader];
					
				};

				_newLeader setVariable ["HAL_Task7Added",true];
			};

			if ((not (_newLeader == leader _newLeader) and (_newLeader getVariable ["HAL_Task7Added",false])) or (not (_IsHal) and (_newLeader getVariable ["HAL_Task7Added",false]))) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_newLeader] remoteExecCall ["Action7fncR",_newLeader];
					
				};
				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_newLeader] remoteExecCall ["ACEAction7fncR",_newLeader];

				};
				_newLeader setVariable ["HAL_Task7Added",false];

			};

		//LOGISTICS

		if ((_newLeader == leader _newLeader) and not (_newLeader getVariable ["HAL_Task8Added",false]) and (_IsHal)) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_newLeader] remoteExecCall ["Action8fnc",_newLeader];
					
				};

				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_newLeader] remoteExecCall ["ACEAction8fnc",_newLeader];
					
				};

				_newLeader setVariable ["HAL_Task8Added",true];
			};

			if ((not (_newLeader == leader _newLeader) and (_newLeader getVariable ["HAL_Task8Added",false])) or (not (_IsHal) and (_newLeader getVariable ["HAL_Task8Added",false]))) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_newLeader] remoteExecCall ["Action8fncR",_newLeader];
					
				};
				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_newLeader] remoteExecCall ["ACEAction8fncR",_newLeader];

				};
				_newLeader setVariable ["HAL_Task8Added",false];

			};

			if ((_newLeader == leader _newLeader) and not (_newLeader getVariable ["HAL_Task9Added",false]) and (_IsHal)) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_newLeader] remoteExecCall ["Action9fnc",_newLeader];
					
				};

				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_newLeader] remoteExecCall ["ACEAction9fnc",_newLeader];
					
				};

				_newLeader setVariable ["HAL_Task9Added",true];
			};

			if ((not (_newLeader == leader _newLeader) and (_newLeader getVariable ["HAL_Task9Added",false])) or (not (_IsHal) and (_newLeader getVariable ["HAL_Task9Added",false]))) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_newLeader] remoteExecCall ["Action9fncR",_newLeader];
					
				};
				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_newLeader] remoteExecCall ["ACEAction9fncR",_newLeader];

				};
				_newLeader setVariable ["HAL_Task9Added",false];

			};

			if ((_newLeader == leader _newLeader) and not (_newLeader getVariable ["HAL_Task10Added",false]) and (_IsHal)) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_newLeader] remoteExecCall ["Action10fnc",_newLeader];
					
				};

				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_newLeader] remoteExecCall ["ACEAction10fnc",_newLeader];
					
				};

				_newLeader setVariable ["HAL_Task10Added",true];
			};

			if ((not (_newLeader == leader _newLeader) and (_newLeader getVariable ["HAL_Task10Added",false])) or (not (_IsHal) and (_newLeader getVariable ["HAL_Task10Added",false]))) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_newLeader] remoteExecCall ["Action10fncR",_newLeader];
					
				};
				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_newLeader] remoteExecCall ["ACEAction10fncR",_newLeader];

				};
				_newLeader setVariable ["HAL_Task10Added",false];

			};

			if ((_newLeader == leader _newLeader) and not (_newLeader getVariable ["HAL_Task11Added",false]) and (_IsHal)) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_newLeader] remoteExecCall ["Action11fnc",_newLeader];
					
				};

				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_newLeader] remoteExecCall ["ACEAction11fnc",_newLeader];
					
				};

				_newLeader setVariable ["HAL_Task11Added",true];
			};

			if ((not (_newLeader == leader _newLeader) and (_newLeader getVariable ["HAL_Task11Added",false])) or (not (_IsHal) and (_newLeader getVariable ["HAL_Task11Added",false]))) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_newLeader] remoteExecCall ["Action11fncR",_newLeader];
					
				};
				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_newLeader] remoteExecCall ["ACEAction11fncR",_newLeader];

				};
				_newLeader setVariable ["HAL_Task11Added",false];

			};

			if ((_newLeader == leader _newLeader) and not (_newLeader getVariable ["HAL_Task12Added",false]) and (_IsHal)) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_newLeader] remoteExecCall ["Action12fnc",_newLeader];
					
				};

				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_newLeader] remoteExecCall ["ACEAction12fnc",_newLeader];
					
				};

				_newLeader setVariable ["HAL_Task12Added",true];
			};

			if ((not (_newLeader == leader _newLeader) and (_newLeader getVariable ["HAL_Task12Added",false])) or (not (_IsHal) and (_newLeader getVariable ["HAL_Task12Added",false]))) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_newLeader] remoteExecCall ["Action12fncR",_newLeader];
					
				};
				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_newLeader] remoteExecCall ["ACEAction12fncR",_newLeader];

				};
				_newLeader setVariable ["HAL_Task12Added",false];

			};

			if ((_newLeader == leader _newLeader) and not (_newLeader getVariable ["HAL_Task13Added",false]) and (_IsHal)) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_newLeader] remoteExecCall ["Action13fnc",_newLeader];
					
				};

				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_newLeader] remoteExecCall ["ACEAction13fnc",_newLeader];
					
				};

				_newLeader setVariable ["HAL_Task13Added",true];
			};

			if ((not (_newLeader == leader _newLeader) and (_newLeader getVariable ["HAL_Task13Added",false])) or (not (_IsHal) and (_newLeader getVariable ["HAL_Task13Added",false]))) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_newLeader] remoteExecCall ["Action13fncR",_newLeader];
					
				};
				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_newLeader] remoteExecCall ["ACEAction13fncR",_newLeader];

				};
				_newLeader setVariable ["HAL_Task13Added",false];

			};
	};
};
