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

	[{
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

		// BELOW IS DEPRECATED - Moved out

		//Tasking
		if (RydxHQ_TaskActions) then {
		call FUNC(Dep_TaskActions);
		};

		//Supports

		if (RydxHQ_SupportActions) then {
		call FUNC(Dep_SupportActions);
		};

	} forEach allPlayers;

	}, 15] call CBA_fnc_waitAndExecute;
};