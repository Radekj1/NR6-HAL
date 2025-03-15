#include "..\script_component.hpp"
//Moved from main directory 
//Adds Hal Interaction menu? for squad leaders. Might move the "deprecated" code to a different file later.
while {true} do {

	private ["_HalFriends"];

	if (isNil ("LeaderHQ")) then {LeaderHQ = objNull};
	if (isNil ("LeaderHQB")) then {LeaderHQB = objNull};
	if (isNil ("LeaderHQC")) then {LeaderHQC = objNull};
	if (isNil ("LeaderHQD")) then {LeaderHQD = objNull};
	if (isNil ("LeaderHQE")) then {LeaderHQE = objNull};
	if (isNil ("LeaderHQF")) then {LeaderHQF = objNull};
	if (isNil ("LeaderHQG")) then {LeaderHQG = objNull};
	if (isNil ("LeaderHQH")) then {LeaderHQH = objNull};


	_HalFriends = (group LeaderHQ getVariable ["RydHQ_Friends",[]]) + (group LeaderHQB getVariable ["RydHQ_Friends",[]]) + (group LeaderHQC getVariable ["RydHQ_Friends",[]]) + (group LeaderHQD getVariable ["RydHQ_Friends",[]]) + (group LeaderHQE getVariable ["RydHQ_Friends",[]]) + (group LeaderHQF getVariable ["RydHQ_Friends",[]]) + (group LeaderHQG getVariable ["RydHQ_Friends",[]]) + (group LeaderHQH getVariable ["RydHQ_Friends",[]]);

	[
	{
	{
		private ["_IsHal"];

		if ((group _x in _HalFriends) or ((group _x) getVariable ["EnableHALActions",false])) then {
			_IsHal = true;
		} else {
			_IsHal = false;
		};

		if (RydxHQ_ActionsMenu) then {

			if ((_x == leader _x) and (not (_x getVariable ["HAL_TaskMenuAdded",false]) or not (_x == (_x getVariable ["HAL_PlayerUnit",objNull]))) and (_IsHal)) then {

					if not (RydxHQ_ActionsAceOnly) then {

						[_x] remoteExecCall ["ActionMfnc",_x];
						
					};

					if ((isClass(configFile >> "CfgPatches" >> "ace_main")) and not (_x getVariable ["HAL_TaskMenuAdded",false])) then {

					[_x] remoteExecCall ["ACEActionMfnc",_x];				
					
					};
					_x setVariable ["HAL_TaskMenuAdded",true];
					_x setVariable ["HAL_PlayerUnit",_x];
				};

			if ((not (_x == leader _x) and (_x getVariable ["HAL_TaskMenuAdded",false])) or (not (_IsHal) and (_x getVariable ["HAL_TaskMenuAdded",false]))) then {

					if not (RydxHQ_ActionsAceOnly) then {

						[_x] remoteExecCall ["ActionMfncR",_x];
						
					};
					if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

						[_x] remoteExecCall ["ACEActionMfncR",_x];

					};
					_x setVariable ["HAL_TaskMenuAdded",false];

				};
			};

		// BELOW IS DEPRECATED

		//Tasking

		if (RydxHQ_TaskActions) then {
		
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
		
		};

		//Supports

		if (RydxHQ_SupportActions) then {

			if ((_x == leader _x) and not (_x getVariable ["HAL_Task4Added",false]) and (_IsHal)) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_x] remoteExecCall ["Action4fnc",_x];
					
				};

				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_x] remoteExecCall ["ACEAction4fnc",_x];
					
				};

				_x setVariable ["HAL_Task4Added",true];
			};

			if ((not (_x == leader _x) and (_x getVariable ["HAL_Task4Added",false])) or (not (_IsHal) and (_x getVariable ["HAL_Task4Added",false]))) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_x] remoteExecCall ["Action4fncR",_x];
					
				};
				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_x] remoteExecCall ["ACEAction4fncR",_x];

				};
				_x setVariable ["HAL_Task4Added",false];

			};

			if ((_x == leader _x) and not (_x getVariable ["HAL_Task5Added",false]) and (_IsHal)) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_x] remoteExecCall ["Action5fnc",_x];
					
				};

				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_x] remoteExecCall ["ACEAction5fnc",_x];
					
				};

				_x setVariable ["HAL_Task5Added",true];
			};

			if ((not (_x == leader _x) and (_x getVariable ["HAL_Task5Added",false])) or (not (_IsHal) and (_x getVariable ["HAL_Task5Added",false]))) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_x] remoteExecCall ["Action5fncR",_x];
					
				};
				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_x] remoteExecCall ["ACEAction5fncR",_x];

				};
				_x setVariable ["HAL_Task5Added",false];

			};

			if ((_x == leader _x) and not (_x getVariable ["HAL_Task6Added",false]) and (_IsHal)) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_x] remoteExecCall ["Action6fnc",_x];
					
				};

				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_x] remoteExecCall ["ACEAction6fnc",_x];
					
				};

				_x setVariable ["HAL_Task6Added",true];
			};

			if ((not (_x == leader _x) and (_x getVariable ["HAL_Task6Added",false])) or (not (_IsHal) and (_x getVariable ["HAL_Task6Added",false]))) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_x] remoteExecCall ["Action6fncR",_x];
					
				};
				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_x] remoteExecCall ["ACEAction6fncR",_x];

				};
				_x setVariable ["HAL_Task6Added",false];

			};

			if ((_x == leader _x) and not (_x getVariable ["HAL_Task7Added",false]) and (_IsHal)) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_x] remoteExecCall ["Action7fnc",_x];
					
				};

				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_x] remoteExecCall ["ACEAction7fnc",_x];
					
				};

				_x setVariable ["HAL_Task7Added",true];
			};

			if ((not (_x == leader _x) and (_x getVariable ["HAL_Task7Added",false])) or (not (_IsHal) and (_x getVariable ["HAL_Task7Added",false]))) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_x] remoteExecCall ["Action7fncR",_x];
					
				};
				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_x] remoteExecCall ["ACEAction7fncR",_x];

				};
				_x setVariable ["HAL_Task7Added",false];

			};

			//LOGISTICS

			if ((_x == leader _x) and not (_x getVariable ["HAL_Task8Added",false]) and (_IsHal)) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_x] remoteExecCall ["Action8fnc",_x];
					
				};

				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_x] remoteExecCall ["ACEAction8fnc",_x];
					
				};

				_x setVariable ["HAL_Task8Added",true];
			};

			if ((not (_x == leader _x) and (_x getVariable ["HAL_Task8Added",false])) or (not (_IsHal) and (_x getVariable ["HAL_Task8Added",false]))) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_x] remoteExecCall ["Action8fncR",_x];
					
				};
				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_x] remoteExecCall ["ACEAction8fncR",_x];

				};
				_x setVariable ["HAL_Task8Added",false];

			};

			if ((_x == leader _x) and not (_x getVariable ["HAL_Task9Added",false]) and (_IsHal)) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_x] remoteExecCall ["Action9fnc",_x];
					
				};

				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_x] remoteExecCall ["ACEAction9fnc",_x];
					
				};

				_x setVariable ["HAL_Task9Added",true];
			};

			if ((not (_x == leader _x) and (_x getVariable ["HAL_Task9Added",false])) or (not (_IsHal) and (_x getVariable ["HAL_Task9Added",false]))) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_x] remoteExecCall ["Action9fncR",_x];
					
				};
				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_x] remoteExecCall ["ACEAction9fncR",_x];

				};
				_x setVariable ["HAL_Task9Added",false];

			};

			if ((_x == leader _x) and not (_x getVariable ["HAL_Task10Added",false]) and (_IsHal)) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_x] remoteExecCall ["Action10fnc",_x];
					
				};

				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_x] remoteExecCall ["ACEAction10fnc",_x];
					
				};

				_x setVariable ["HAL_Task10Added",true];
			};

			if ((not (_x == leader _x) and (_x getVariable ["HAL_Task10Added",false])) or (not (_IsHal) and (_x getVariable ["HAL_Task10Added",false]))) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_x] remoteExecCall ["Action10fncR",_x];
					
				};
				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_x] remoteExecCall ["ACEAction10fncR",_x];

				};
				_x setVariable ["HAL_Task10Added",false];

			};

			if ((_x == leader _x) and not (_x getVariable ["HAL_Task11Added",false]) and (_IsHal)) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_x] remoteExecCall ["Action11fnc",_x];
					
				};

				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_x] remoteExecCall ["ACEAction11fnc",_x];
					
				};

				_x setVariable ["HAL_Task11Added",true];
			};

			if ((not (_x == leader _x) and (_x getVariable ["HAL_Task11Added",false])) or (not (_IsHal) and (_x getVariable ["HAL_Task11Added",false]))) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_x] remoteExecCall ["Action11fncR",_x];
					
				};
				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_x] remoteExecCall ["ACEAction11fncR",_x];

				};
				_x setVariable ["HAL_Task11Added",false];

			};

			if ((_x == leader _x) and not (_x getVariable ["HAL_Task12Added",false]) and (_IsHal)) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_x] remoteExecCall ["Action12fnc",_x];
					
				};

				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_x] remoteExecCall ["ACEAction12fnc",_x];
					
				};

				_x setVariable ["HAL_Task12Added",true];
			};

			if ((not (_x == leader _x) and (_x getVariable ["HAL_Task12Added",false])) or (not (_IsHal) and (_x getVariable ["HAL_Task12Added",false]))) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_x] remoteExecCall ["Action12fncR",_x];
					
				};
				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_x] remoteExecCall ["ACEAction12fncR",_x];

				};
				_x setVariable ["HAL_Task12Added",false];

			};

			if ((_x == leader _x) and not (_x getVariable ["HAL_Task13Added",false]) and (_IsHal)) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_x] remoteExecCall ["Action13fnc",_x];
					
				};

				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_x] remoteExecCall ["ACEAction13fnc",_x];
					
				};

				_x setVariable ["HAL_Task13Added",true];
			};

			if ((not (_x == leader _x) and (_x getVariable ["HAL_Task13Added",false])) or (not (_IsHal) and (_x getVariable ["HAL_Task13Added",false]))) then {

				if not (RydxHQ_ActionsAceOnly) then {

					[_x] remoteExecCall ["Action13fncR",_x];
					
				};
				if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {

					[_x] remoteExecCall ["ACEAction13fncR",_x];

				};
				_x setVariable ["HAL_Task13Added",false];

			};
		};
		
	} forEach allPlayers;

	}, 15] call CBA_fnc_waitAndExecute;
};