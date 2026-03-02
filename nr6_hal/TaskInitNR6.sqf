//Tasking

Action1ct = {

	(group (_this select 0)) setVariable [('Resting' + (str (group (_this select 0)))),false]; 
	(group (_this select 0)) setVariable [('Garrisoned' + (str (group (_this select 0)))),false];
	(group (_this select 0)) setVariable [('NOGarrisoned' + (str (group (_this select 0)))),true];


	[(_this select 0),RydxHQ_AIC_OrdDen,'OrdDen'] call RYD_AIChatter;
	deleteWaypoint [(group (_this select 0)),(currentWaypoint (group (_this select 0)))];

	{
	[_x,'CANCELED',true] call BIS_fnc_taskSetState;
	} foreach ((group (_this select 0)) getVariable ['HACAddedTasks',[]]);

	if ((group (_this select 0)) getVariable ["Busy" + str (group (_this select 0)),true]) then {(group (_this select 0)) setVariable ["Break",true]};



};

Action1fnc = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit addAction ["[HAL Tasking] Deny Assigned Task","[_this select 3] remoteExec ['Action1ct',2]",_Unit,-2,false,false,"","_target isEqualTo (vehicle player)",0.01];
	_Unit setVariable ["HAL_TaskAddedID",_Action];
};

ACEAction1fnc = {

	private ["_Unit","_ACEAction","_ACEActionP"];

	_Unit = _this select 0;

	_ACEActionP = ["ACEActionP","HAL Tasking","",{},{true}] call ace_interact_menu_fnc_createAction;
	_ACEAction = ["HALDenyAssignedTask","Deny Assigned Task","",{

		[_target] remoteExec ['Action1ct',2]
				
		},{true},{}] call ace_interact_menu_fnc_createAction;
	[_Unit, 1, ["ACE_SelfActions"], _ACEActionP] call ace_interact_menu_fnc_addActionToObject;
	[_Unit, 1, ["ACE_SelfActions","ACEActionP"], _ACEAction] call ace_interact_menu_fnc_addActionToObject;

};

Action2ct = {

	[(_this select 0),'Command, we are unavailable for further tasking - Over'] remoteExecCall ["RYD_MP_Sidechat"];
	group (_this select 0) setVariable ['Unable',true];
	group (_this select 0) setVariable ['BUnable',true];

};

Action2fnc = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit addAction ["[HAL Tasking] Disable Tasking", 
		"
		[_this select 3] remoteExecCall ['Action2ct',2]
		"
		, 
		_Unit,-2.1,false,false,"","_target isEqualTo (vehicle player)",0.01];

	_Unit setVariable ["HAL_TaskDisabledID",_Action];

};

ACEAction2fnc = {

	private ["_Unit","_ACEAction"];

	_Unit = _this select 0;

	_ACEAction = ["HALDisableTasking","Disable Tasking","",{

			[_target] remoteExecCall ['Action2ct',2]

		},{true},{}] call ace_interact_menu_fnc_createAction;
		[_Unit, 1, ["ACE_SelfActions","ACEActionP"], _ACEAction] call ace_interact_menu_fnc_addActionToObject;

};

Action3ct = {

	[(_this select 0),'Command, we are available for further tasking - Over'] remoteExecCall ["RYD_MP_Sidechat"];
	group (_this select 0) setVariable ['Unable',false];
	group (_this select 0) setVariable ['BUnable',false];

};

Action3fnc = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit addAction ["[HAL Tasking] Enable Tasking", 
		"
		[_this select 3] remoteExecCall ['Action3ct',2]
		"
		, 
		_Unit,-2.2,false,false,"","_target isEqualTo (vehicle player)",0.01];
	
	_Unit setVariable ["HAL_TaskEnabledID",_Action];

};

ACEAction3fnc = {

	private ["_Unit","_ACEAction"];

	_Unit = _this select 0;

	_ACEAction = ["HALEnableTasking","Enable Tasking","",{

			[_target] remoteExecCall ['Action3ct',2]

		},{true},{}] call ace_interact_menu_fnc_createAction;
		[_Unit, 1, ["ACE_SelfActions","ACEActionP"], _ACEAction] call ace_interact_menu_fnc_addActionToObject;


};

Action1fncR = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit getVariable "HAL_TaskAddedID";
	_Unit removeAction _Action;

};

ACEAction1fncR = {

	private ["_Unit"];

	_Unit = _this select 0;

	[_Unit,1,["ACE_SelfActions","ACEActionP","HALDenyAssignedTask"]] call ace_interact_menu_fnc_removeActionFromObject;

};

Action2fncR = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit getVariable "HAL_TaskDisabledID";
	_Unit removeAction _Action;

};

ACEAction2fncR = {

	private ["_Unit"];

	_Unit = _this select 0;

	[_Unit,1,["ACE_SelfActions","ACEActionP","HALDisableTasking"]] call ace_interact_menu_fnc_removeActionFromObject;

};

Action3fncR = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit getVariable "HAL_TaskEnabledID";
	_Unit removeAction _Action;

};

ACEAction3fncR = {

	private ["_Unit"];

	_Unit = _this select 0;

	[_Unit,1,["ACE_SelfActions","ACEActionP","HALEnableTasking"]] call ace_interact_menu_fnc_removeActionFromObject;
	[_Unit,1,["ACE_SelfActions","ACEActionP"]] call ace_interact_menu_fnc_removeActionFromObject;

};

//Supports

Action4ct = {

	private ["_trg","_chosen","_HQ","_dist","_request"];

	_HQ = grpNull;

	if not (isnil "LeaderHQ") then {if ((group (_this select 0)) in ((group LeaderHQ) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQ)}};
	if not (isnil "LeaderHQB") then {if ((group (_this select 0)) in ((group LeaderHQB) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQB)}};
	if not (isnil "LeaderHQC") then {if ((group (_this select 0)) in ((group LeaderHQC) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQC)}};
	if not (isnil "LeaderHQD") then {if ((group (_this select 0)) in ((group LeaderHQD) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQD)}};
	if not (isnil "LeaderHQE") then {if ((group (_this select 0)) in ((group LeaderHQE) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQE)}};
	if not (isnil "LeaderHQF") then {if ((group (_this select 0)) in ((group LeaderHQF) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQF)}};
	if not (isnil "LeaderHQG") then {if ((group (_this select 0)) in ((group LeaderHQG) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQG)}};
	if not (isnil "LeaderHQH") then {if ((group (_this select 0)) in ((group LeaderHQH) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQH)}};

	[(_this select 0), 'Command, requesting close air support at our position - Over'] remoteExecCall ["RYD_MP_Sidechat"];

	sleep 3;

	_trg = (_this select 0) findNearestEnemy (position (_this select 0));
	_request = true;

	if (_trg isEqualTo objNull) then {
		_trg = (_this select 0);
	};

	if (((_this select 0) distance2D _trg) > 300) then {
		_trg = (_this select 0);
	};

	_chosen = grpNull;

	_dist = 10000000;

	{
	if ((typeName _x) == "GROUP") then {
	
		if (not (_x getvariable [("Busy" + (str _x)),false]) and not (_x == (group (_this select 0))) and not (_x getvariable ["Unable",false]) and (((_this select 0) distance2D (leader _x)) < _dist)) then {_chosen = _x; _dist = ((_this select 0) distance2D (leader _x));};
		};
	} forEach (((_HQ getVariable ["RydHQ_BAirG",[]]) + (_HQ getVariable ["RydHQ_RCAS",[]])) - (_HQ getVariable ["RydHQ_Exhausted",[]]));

	if (_chosen isEqualTo grpNull) exitwith {[leader _HQ, (groupId (group (_this select 0))) + ', negative. No air support units are available at the moment - Out'] remoteExecCall ["RYD_MP_Sidechat"]};

	_chosen setVariable ["Busy" + (str _chosen),true];
	_HQ setVariable ["RydHQ_AttackAv",(_HQ getVariable ["RydHQ_AttackAv",[]]) - [_chosen]];								
	[_chosen,_trg,_HQ,_request] spawn (["AIR"] call RYD_GoLaunch);
	[leader _HQ, (groupId (group (_this select 0))) + ', ' + (groupId _chosen) + ' has been dispatched for CAS - Out'] remoteExecCall ["RYD_MP_Sidechat"];


};

Action4fnc = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit addAction ["[HAL Supports] Request Air Support", 
		"
		[_this select 3] remoteExec ['Action4ct',2]
		"
		, 
		_Unit,-3,false,false,"","_target isEqualTo (vehicle player)",0.01];
	
	_Unit setVariable ["HAL_ReqAirID",_Action];

};

ACEAction4fnc = {

	private ["_Unit","_ACEAction","_ACEActionR"];

	_Unit = _this select 0;

	_ACEActionR = ["ACEActionR","HAL Supports","",{},{true}] call ace_interact_menu_fnc_createAction;

	[_Unit, 1, ["ACE_SelfActions"], _ACEActionR] call ace_interact_menu_fnc_addActionToObject;

	_ACEAction = ["HALReqAir","Request Air Support","",{

		[_target] remoteExec ['Action4ct',2]

		},{true},{}] call ace_interact_menu_fnc_createAction;

	[_Unit, 1, ["ACE_SelfActions","ACEActionR"], _ACEAction] call ace_interact_menu_fnc_addActionToObject;


};

Action4fncR = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit getVariable "HAL_ReqAirID";
	_Unit removeAction _Action;

};

ACEAction4fncR = {

	private ["_Unit"];

	_Unit = _this select 0;

	[_Unit,1,["ACE_SelfActions","ACEActionR","HALReqAir"]] call ace_interact_menu_fnc_removeActionFromObject;

};

Action5ct = {

	private ["_trg","_chosen","_HQ","_dist","_request"];

	_HQ = grpNull;

	if not (isnil "LeaderHQ") then {if ((group (_this select 0)) in ((group LeaderHQ) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQ)}};
	if not (isnil "LeaderHQB") then {if ((group (_this select 0)) in ((group LeaderHQB) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQB)}};
	if not (isnil "LeaderHQC") then {if ((group (_this select 0)) in ((group LeaderHQC) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQC)}};
	if not (isnil "LeaderHQD") then {if ((group (_this select 0)) in ((group LeaderHQD) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQD)}};
	if not (isnil "LeaderHQE") then {if ((group (_this select 0)) in ((group LeaderHQE) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQE)}};
	if not (isnil "LeaderHQF") then {if ((group (_this select 0)) in ((group LeaderHQF) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQF)}};
	if not (isnil "LeaderHQG") then {if ((group (_this select 0)) in ((group LeaderHQG) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQG)}};
	if not (isnil "LeaderHQH") then {if ((group (_this select 0)) in ((group LeaderHQH) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQH)}};

	[(_this select 0), 'Command, requesting infantry support at our position - Over'] remoteExecCall ["RYD_MP_Sidechat"];

	sleep 3;

	_trg = (_this select 0) findNearestEnemy (position (_this select 0));
	_request = true;

	if (_trg isEqualTo objNull) then {
		_trg = (_this select 0);
		_request = true;
	};

	if (((_this select 0) distance2D _trg) > 250) then {
		_trg = (_this select 0);
		_request = true;
	};

	_trg = (vehicle (leader (group _trg)));

	_chosen = grpNull;

	_dist = 10000000;

	{

	if ((typeName _x) == "GROUP") then {
	
	if (not (_x getvariable [("Busy" + (str _x)),false]) and not (_x == (group (_this select 0))) and not (_x getvariable ["Unable",false]) and (((_this select 0) distance2D (leader _x)) < _dist)) then {_chosen = _x; _dist = ((_this select 0) distance2D (leader _x));};
	};
	} forEach (((_HQ getVariable ["RydHQ_NCrewInfG",[]]) - (_HQ getVariable ["RydHQ_SpecForG",[]])) + ((_HQ getVariable ["RydHQ_CarsG",[]]) - ((_HQ getVariable ["RydHQ_ATInfG",[]]) + (_HQ getVariable ["RydHQ_AAInfG",[]]) + (_HQ getVariable ["RydHQ_SupportG",[]]) + (_HQ getVariable ["RydHQ_NCCargoG",[]]))));

	if (_chosen isEqualTo grpNull) exitwith {[leader _HQ, (groupId (group (_this select 0))) + ', negative. No infantry squads are available at the moment - Out'] remoteExecCall ["RYD_MP_Sidechat"]};

	
	_chosen setVariable ["Busy" + (str _chosen),true];
	_HQ setVariable ["RydHQ_AttackAv",(_HQ getVariable ["RydHQ_AttackAv",[]]) - [_chosen]];
								
	[_chosen,_trg,_HQ,_request] spawn (["INF"] call RYD_GoLaunch);
	[leader _HQ, (groupId (group (_this select 0))) + ', ' + (groupId _chosen) + ' has been dispatched - Out'] remoteExecCall ["RYD_MP_Sidechat"];


};

Action5fnc = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit addAction ["[HAL Supports] Request Infantry Support", 
		"
		[_this select 3] remoteExec ['Action5ct',2]
		"
		, 
		_Unit,-3.1,false,false,"","_target isEqualTo (vehicle player)",0.01];
	
	_Unit setVariable ["HAL_ReqInfID",_Action];

};

ACEAction5fnc = {

	private ["_Unit","_ACEAction"];

	_Unit = _this select 0;

	_ACEAction = ["HALReqInf","Request Infantry Support","",{

		[_target] remoteExec ['Action5ct',2]

		},{true},{}] call ace_interact_menu_fnc_createAction;

	[_Unit, 1, ["ACE_SelfActions","ACEActionR"], _ACEAction] call ace_interact_menu_fnc_addActionToObject;


};

Action5fncR = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit getVariable "HAL_ReqInfID";
	_Unit removeAction _Action;

};

ACEAction5fncR = {

	private ["_Unit"];

	_Unit = _this select 0;

	[_Unit,1,["ACE_SelfActions","ACEActionR","HALReqInf"]] call ace_interact_menu_fnc_removeActionFromObject;

};

Action6ct = {

	private ["_trg","_chosen","_HQ","_dist","_request"];

	_HQ = grpNull;

	if not (isnil "LeaderHQ") then {if ((group (_this select 0)) in ((group LeaderHQ) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQ)}};
	if not (isnil "LeaderHQB") then {if ((group (_this select 0)) in ((group LeaderHQB) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQB)}};
	if not (isnil "LeaderHQC") then {if ((group (_this select 0)) in ((group LeaderHQC) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQC)}};
	if not (isnil "LeaderHQD") then {if ((group (_this select 0)) in ((group LeaderHQD) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQD)}};
	if not (isnil "LeaderHQE") then {if ((group (_this select 0)) in ((group LeaderHQE) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQE)}};
	if not (isnil "LeaderHQF") then {if ((group (_this select 0)) in ((group LeaderHQF) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQF)}};
	if not (isnil "LeaderHQG") then {if ((group (_this select 0)) in ((group LeaderHQG) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQG)}};
	if not (isnil "LeaderHQH") then {if ((group (_this select 0)) in ((group LeaderHQH) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQH)}};

	[(_this select 0), 'Command, requesting armored support at our position - Over'] remoteExecCall ["RYD_MP_Sidechat"];

	sleep 3;

	_trg = (_this select 0) findNearestEnemy (position (_this select 0));
	_request = true;

	if (_trg isEqualTo objNull) then {
		_trg = (_this select 0);
		_request = true;
	};

	if (((_this select 0) distance2D _trg) > 250) then {
		_trg = (_this select 0);
		_request = true;
	};

	_trg = (vehicle (leader (group _trg)));

	_chosen = grpNull;

	_dist = 10000000;

	{

	if ((typeName _x) == "GROUP") then {
	
		if (not (_x getvariable [("Busy" + (str _x)),false]) and not (_x == (group (_this select 0))) and not (_x getvariable ["Unable",false]) and (((_this select 0) distance2D (leader _x)) < _dist)) then {_chosen = _x; _dist = ((_this select 0) distance2D (leader _x));};
	};
	} forEach ((_HQ getVariable ["RydHQ_HArmorG",[]]) + (_HQ getVariable ["RydHQ_LArmorATG",[]]));

	if (_chosen isEqualTo grpNull) exitwith {[leader _HQ, (groupId (group (_this select 0))) + ', negative. No armored units are available at the moment - Out'] remoteExecCall ["RYD_MP_Sidechat"]};

	_chosen setVariable ["Busy" + (str _chosen),true];
	_HQ setVariable ["RydHQ_AttackAv",(_HQ getVariable ["RydHQ_AttackAv",[]]) - [_chosen]];
								
	[_chosen,_trg,_HQ,_request] spawn (["ARM"] call RYD_GoLaunch);
	[leader _HQ, (groupId (group (_this select 0))) + ', ' + (groupId _chosen) + ' has been dispatched - Out'] remoteExecCall ["RYD_MP_Sidechat"];


};

Action6fnc = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit addAction ["[HAL Supports] Request Armored Support", 
		"
		[_this select 3] remoteExec ['Action6ct',2]
		"
		, 
		_Unit,-3.2,false,false,"","_target isEqualTo (vehicle player)",0.01];
	
	_Unit setVariable ["HAL_ReqArmID",_Action];

};

ACEAction6fnc = {

	private ["_Unit","_ACEAction"];

	_Unit = _this select 0;

	_ACEAction = ["HALReqArm","Request Armored Support","",{

		[_target] remoteExec ['Action6ct',2]

		},{true},{}] call ace_interact_menu_fnc_createAction;

	[_Unit, 1, ["ACE_SelfActions","ACEActionR"], _ACEAction] call ace_interact_menu_fnc_addActionToObject;


};

Action6fncR = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit getVariable "HAL_ReqArmID";
	_Unit removeAction _Action;

};

ACEAction6fncR = {

	private ["_Unit"];

	_Unit = _this select 0;

	[_Unit,1,["ACE_SelfActions","ACEActionR","HALReqArm"]] call ace_interact_menu_fnc_removeActionFromObject;
//	[_Unit,1,["ACE_SelfActions","ACEActionR"]] call ace_interact_menu_fnc_removeActionFromObject;

};

Action7ct = {

	private ["_unitvar","_chosen","_HQ","_dist","_TransportPriority","_timer","_AbortAction","_unitG"];

	_HQ = grpNull;

	if not (isnil "LeaderHQ") then {if ((group (_this select 0)) in ((group LeaderHQ) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQ)}};
	if not (isnil "LeaderHQB") then {if ((group (_this select 0)) in ((group LeaderHQB) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQB)}};
	if not (isnil "LeaderHQC") then {if ((group (_this select 0)) in ((group LeaderHQC) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQC)}};
	if not (isnil "LeaderHQD") then {if ((group (_this select 0)) in ((group LeaderHQD) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQD)}};
	if not (isnil "LeaderHQE") then {if ((group (_this select 0)) in ((group LeaderHQE) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQE)}};
	if not (isnil "LeaderHQF") then {if ((group (_this select 0)) in ((group LeaderHQF) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQF)}};
	if not (isnil "LeaderHQG") then {if ((group (_this select 0)) in ((group LeaderHQG) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQG)}};
	if not (isnil "LeaderHQH") then {if ((group (_this select 0)) in ((group LeaderHQH) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQH)}};

	[(_this select 0), 'Command, requesting airlift - Over'] remoteExecCall ["RYD_MP_Sidechat"];

	_unitG = (group (_this select 0));
	_unitvar = str _unitG;

	if not (_unitG getVariable [("CC" + _unitvar), true]) exitwith {sleep 5; [leader _HQ, (groupId _unitG) + ', negative. Transport already assigned - Out'] remoteExecCall ["RYD_MP_Sidechat"]};
	if (_unitG getVariable ["CargoCheckLoopActive", false]) exitwith {sleep 5; [leader _HQ, (groupId _unitG) + ', request pending. You are already on standby for transport - Over'] remoteExecCall ["RYD_MP_Sidechat"]};

	_unitG setVariable ["CargoCheckLoopActive", true,true];

	_unitG setVariable [("CC" + _unitvar), false, true];

	_TransportPriority = (leader _HQ) getVariable ["RydHQ_TransportPriorityAir",[]];
	_TransportPriority pushBackUnique (group (_this select 0));
	(leader _HQ) setVariable ["RydHQ_TransportPriorityAir",_TransportPriority,true];

	[_unitG,_HQ,getpos (_this select 0),false,true] call HAL_SCargo;

	sleep 15;

	if (_unitG getVariable ["CargoChosen", false]) exitwith {
		[leader _HQ, (groupId (group (_this select 0))) + ', affirmative. ' + (groupId (group (_unitG getVariable ["AssignedCargo" + (str _unitG),objNull]))) + ' has been assigned - Out'] remoteExecCall ["RYD_MP_Sidechat"];
		_TransportPriority = (leader _HQ) getVariable ["RydHQ_TransportPriorityAir",[]];
		_TransportPriority = _TransportPriority - [(group (_this select 0))];
		(leader _HQ) setVariable ["RydHQ_TransportPriorityAir",_TransportPriority,true];

		_unitG setVariable ["CargoCheckLoopActive", false,true];
		};

	if (not (_unitG getVariable ["CargoChosen", false])) then {

		[leader _HQ, (groupId _unitG) + ', copy. No air transport is available at this time. If transport becomes available in the next ' + (str (RydxHQ_PlayerCargoCheckLoopTime)) + ' minutes, it will be assigned to you - Over'] remoteExecCall ["RYD_MP_Sidechat"];

		_AbortAction = (_this select 0) addAction ["Cancel " + "Air" + " Transport Request",
		{

		[(_this select 3), 'Command, cancel air transport request - Over'] remoteExecCall ["RYD_MP_Sidechat"];

		(group (_this select 3)) setVariable ["CargoCheckLoopAbort",true,true];

		(_this select 0) removeAction (_this select 2);

		}
		, 
		(_this select 0),5,false,false,"","_this == _target",15];

		_timer = 0;

		waitUntil {
			if not ((_unitG getVariable ["CargoCheckPending" + _unitvar,false]) and (_unitG getVariable [("CC" + _unitvar), false]) and not (_unitG getVariable ["CargoChosen", false])) then {
				_unitG setVariable [("CC" + _unitvar), false, true];
				[_unitG,_HQ,getpos (_this select 0),false,true] call HAL_SCargo;
				};

			sleep 5;

			_timer = _timer + 5;

			(_unitG getVariable ["CargoChosen", false]) or (_timer > (RydxHQ_PlayerCargoCheckLoopTime*60)) or (_unitG getVariable ["CargoCheckLoopAbort",false]);
		};

		(_this select 0) removeAction _AbortAction;

	};

	_TransportPriority = (leader _HQ) getVariable ["RydHQ_TransportPriorityAir",[]];
	_TransportPriority = _TransportPriority - [(group (_this select 0))];
	(leader _HQ) setVariable ["RydHQ_TransportPriorityAir",_TransportPriority,true];

	_unitG setVariable ["CargoCheckLoopActive", false,true];

	if (_unitG getVariable ["CargoCheckLoopAbort",false]) exitwith {_unitG setVariable ["CargoCheckLoopAbort",false,true]; [leader _HQ, (groupId _unitG) + ', copy. Air transport request canceled - Out'] remoteExecCall ["RYD_MP_Sidechat"];};	

	if (_unitG getVariable ["CargoChosen", false]) exitwith {[leader _HQ, (groupId _unitG) + ', update on your request. ' + (groupId (group (_unitG getVariable ["AssignedCargo" + (str _unitG),objNull]))) + ' has been assigned - Out'] remoteExecCall ["RYD_MP_Sidechat"];};
	if (not (_unitG getVariable ["CargoChosen", false])) exitwith {[leader _HQ, (groupId _unitG) + ', update on your request. No air transport available. - Out'] remoteExecCall ["RYD_MP_Sidechat"]};

};

Action7fnc = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit addAction ["[HAL Supports] Request Transport Support", 
		"
		[_this select 3] remoteExec ['Action7ct',2]
		"
		, 
		_Unit,-3.2,false,false,"","_target isEqualTo (vehicle player)",0.01];
	
	_Unit setVariable ["HAL_ReqTraID",_Action];

};

ACEAction7fnc = {

	private ["_Unit","_ACEAction"];

	_Unit = _this select 0;

	_ACEAction = ["HALReqTra","Request Transport Support","",{

		[_target] remoteExec ['Action7ct',2]

		},{true},{}] call ace_interact_menu_fnc_createAction;

	[_Unit, 1, ["ACE_SelfActions","ACEActionR"], _ACEAction] call ace_interact_menu_fnc_addActionToObject;


};

Action7fncR = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit getVariable "HAL_ReqTraID";
	_Unit removeAction _Action;

};

ACEAction7fncR = {

	private ["_Unit"];

	_Unit = _this select 0;

	[_Unit,1,["ACE_SelfActions","ACEActionR","HALReqTra"]] call ace_interact_menu_fnc_removeActionFromObject;
	[_Unit,1,["ACE_SelfActions","ACEActionR"]] call ace_interact_menu_fnc_removeActionFromObject;

};

//LOGISTICS

Action8ct = {

	private ["_unitvar","_chosen","_HQ","_dist","_FlyBoy","_ammoBox"];

	_HQ = grpNull;

	if not (isnil "LeaderHQ") then {if ((group (_this select 0)) in ((group LeaderHQ) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQ)}};
	if not (isnil "LeaderHQB") then {if ((group (_this select 0)) in ((group LeaderHQB) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQB)}};
	if not (isnil "LeaderHQC") then {if ((group (_this select 0)) in ((group LeaderHQC) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQC)}};
	if not (isnil "LeaderHQD") then {if ((group (_this select 0)) in ((group LeaderHQD) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQD)}};
	if not (isnil "LeaderHQE") then {if ((group (_this select 0)) in ((group LeaderHQE) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQE)}};
	if not (isnil "LeaderHQF") then {if ((group (_this select 0)) in ((group LeaderHQF) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQF)}};
	if not (isnil "LeaderHQG") then {if ((group (_this select 0)) in ((group LeaderHQG) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQG)}};
	if not (isnil "LeaderHQH") then {if ((group (_this select 0)) in ((group LeaderHQH) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQH)}};

	[(_this select 0), 'Command, requesting ammunition drop - Over'] remoteExecCall ["RYD_MP_Sidechat"];

	sleep 5;

	_FlyBoy = objNull;

	{
		_unitvar = str _x;
		if ( not (_x getVariable [("Busy" + _unitvar),false]) and not (_x == (group (_this select 0))) and not (_x getVariable ["Unable",false]) and not (_x isEqualTo grpNull) and (canMove (vehicle (leader _x))) and not ((vehicle (leader _x)) == (leader _x))) exitwith {_FlyBoy = _x};
	} foreach (_HQ getVariable ["RydHQ_AmmoDrop",[]]);

	if (_FlyBoy isEqualTo objNull) exitwith {[leader _HQ, (groupId (group (_this select 0))) + ', negative. No supply services are currently available - Out'] remoteExecCall ["RYD_MP_Sidechat"]};

	if not ((count (_HQ getVariable ["RydHQ_AmmoBoxes",[]])) > 0) exitwith {[leader _HQ, (groupId (group (_this select 0))) + ', negative. Supplies have been depleted - Out'] remoteExecCall ["RYD_MP_Sidechat"]};

	_ammoBox = (_HQ getVariable ["RydHQ_AmmoBoxes",[]]) select 0;
	_HQ setVariable ["RydHQ_AmmoBoxes",(_HQ getVariable ["RydHQ_AmmoBoxes",[]]) - [_ammoBox]];

	[assignedvehicle (leader _FlyBoy),(vehicle (_this select 0)),[],[],true,_ammoBox,_HQ] call HAL_GoAmmoSupp;

	[leader _HQ, (groupId (group (_this select 0))) + ', affirmative. Supplies are on their way - Out'] remoteExecCall ["RYD_MP_Sidechat"];

};

Action8fnc = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit addAction ["[HAL Logistics] Request Ammunition Drop", 
		"
		[_this select 3] remoteExec ['Action8ct',2]
		"
		, 
		_Unit,-4,false,false,"","_target isEqualTo (vehicle player)",0.01];
	
	_Unit setVariable ["HAL_ReqDSuppID",_Action];

};

ACEAction8fnc = {

	private ["_Unit","_ACEAction","_ACEActionL"];

	_Unit = _this select 0;


	_ACEActionL = ["ACEActionL","HAL Logistics","",{},{true}] call ace_interact_menu_fnc_createAction;
	[_Unit, 1, ["ACE_SelfActions"], _ACEActionL] call ace_interact_menu_fnc_addActionToObject;

	_ACEAction = ["HALReqDSupp","Request Ammunition Drop","",{

		[_target] remoteExec ['Action8ct',2]

		},{true},{}] call ace_interact_menu_fnc_createAction;

	[_Unit, 1, ["ACE_SelfActions","ACEActionL"], _ACEAction] call ace_interact_menu_fnc_addActionToObject;


};

Action8fncR = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit getVariable "HAL_ReqDSuppID";
	_Unit removeAction _Action;

};

ACEAction8fncR = {

	private ["_Unit"];

	_Unit = _this select 0;

	[_Unit,1,["ACE_SelfActions","ACEActionL","HALReqDSupp"]] call ace_interact_menu_fnc_removeActionFromObject;

};

Action9ct = {

	private ["_unitvar","_chosen","_HQ","_dist","_AmmoBoy"];

	_HQ = grpNull;

	if not (isnil "LeaderHQ") then {if ((group (_this select 0)) in ((group LeaderHQ) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQ)}};
	if not (isnil "LeaderHQB") then {if ((group (_this select 0)) in ((group LeaderHQB) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQB)}};
	if not (isnil "LeaderHQC") then {if ((group (_this select 0)) in ((group LeaderHQC) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQC)}};
	if not (isnil "LeaderHQD") then {if ((group (_this select 0)) in ((group LeaderHQD) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQD)}};
	if not (isnil "LeaderHQE") then {if ((group (_this select 0)) in ((group LeaderHQE) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQE)}};
	if not (isnil "LeaderHQF") then {if ((group (_this select 0)) in ((group LeaderHQF) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQF)}};
	if not (isnil "LeaderHQG") then {if ((group (_this select 0)) in ((group LeaderHQG) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQG)}};
	if not (isnil "LeaderHQH") then {if ((group (_this select 0)) in ((group LeaderHQH) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQH)}};

	[(_this select 0), 'Command, requesting ammunition truck - Over'] remoteExecCall ["RYD_MP_Sidechat"];

	sleep 5;

	_Pool = RHQ_Ammo + RYD_WS_ammo - RHQs_Ammo;

	_AmmoBoy = objNull;

	{
		_unitvar = str (group _x);
		if ( not ((group _x) getVariable [("Busy" + _unitvar),false]) and not ((group _x) == (group (_this select 0))) and not ((group _x) getVariable ["Unable",false]) and not ((group _x) isEqualTo grpNull) and (canMove _x) and ((toLower (typeOf (assignedvehicle (leader (group _x))))) in _Pool) and not ((group _x) in ((_HQ getVariable ["RydHQ_SpecForG",[]]) + (_HQ getVariable ["RydHQ_CargoOnly",[]]))))  exitwith {_AmmoBoy = _x};
	} foreach (_HQ getVariable ["RydHQ_Support",[]]);

	if (_AmmoBoy isEqualTo objNull) exitwith {[leader _HQ, (groupId (group (_this select 0))) + ', negative. No rearming services are currently available - Out'] remoteExecCall ["RYD_MP_Sidechat"]};

	[_AmmoBoy,(vehicle (_this select 0)),[],[],false,objNull,_HQ,true] call HAL_GoAmmoSupp;

	[leader _HQ, (groupId (group (_this select 0))) + ', affirmative. Ammunition truck is on its way - Out'] remoteExecCall ["RYD_MP_Sidechat"];

};

Action9fnc = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit addAction ["[HAL Logistics] Request Ammunition Truck", 
		"
		[_this select 3] remoteExec ['Action9ct',2]
		"
		, 
		_Unit,-4.1,false,false,"","_target isEqualTo (vehicle player)",0.01];
	
	_Unit setVariable ["HAL_ReqASuppID",_Action];

};

ACEAction9fnc = {

	private ["_Unit","_ACEAction","_ACEActionL"];

	_Unit = _this select 0;

	_ACEAction = ["HALReqASupp","Request Ammunition Truck","",{

		[_target] remoteExec ['Action9ct',2]

		},{true},{}] call ace_interact_menu_fnc_createAction;

	[_Unit, 1, ["ACE_SelfActions","ACEActionL"], _ACEAction] call ace_interact_menu_fnc_addActionToObject;


};

Action9fncR = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit getVariable "HAL_ReqASuppID";
	_Unit removeAction _Action;

};

ACEAction9fncR = {

	private ["_Unit"];

	_Unit = _this select 0;

	[_Unit,1,["ACE_SelfActions","ACEActionL","HALReqASupp"]] call ace_interact_menu_fnc_removeActionFromObject;

};

Action10ct = {

	private ["_unitvar","_chosen","_HQ","_dist","_FuelBoy","_Pool"];

	_HQ = grpNull;

	if not (isnil "LeaderHQ") then {if ((group (_this select 0)) in ((group LeaderHQ) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQ)}};
	if not (isnil "LeaderHQB") then {if ((group (_this select 0)) in ((group LeaderHQB) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQB)}};
	if not (isnil "LeaderHQC") then {if ((group (_this select 0)) in ((group LeaderHQC) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQC)}};
	if not (isnil "LeaderHQD") then {if ((group (_this select 0)) in ((group LeaderHQD) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQD)}};
	if not (isnil "LeaderHQE") then {if ((group (_this select 0)) in ((group LeaderHQE) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQE)}};
	if not (isnil "LeaderHQF") then {if ((group (_this select 0)) in ((group LeaderHQF) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQF)}};
	if not (isnil "LeaderHQG") then {if ((group (_this select 0)) in ((group LeaderHQG) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQG)}};
	if not (isnil "LeaderHQH") then {if ((group (_this select 0)) in ((group LeaderHQH) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQH)}};

	[(_this select 0), 'Command, requesting fuel truck - Over'] remoteExecCall ["RYD_MP_Sidechat"];

	sleep 5;

	_Pool = RHQ_Fuel + RYD_WS_fuel - RHQs_Fuel;

	_FuelBoy = objNull;

	{
		_unitvar = str (group _x);
		if ( not ((group _x) getVariable [("Busy" + _unitvar),false]) and not ((group _x) == (group (_this select 0))) and not ((group _x) getVariable ["Unable",false]) and not ((group _x) isEqualTo grpNull) and (canMove _x) and ((toLower (typeOf (assignedvehicle (leader (group _x))))) in _Pool) and not ((group _x) in ((_HQ getVariable ["RydHQ_SpecForG",[]]) + (_HQ getVariable ["RydHQ_CargoOnly",[]]))))  exitwith {_FuelBoy = _x};
	} foreach (_HQ getVariable ["RydHQ_Support",[]]);

	if (_FuelBoy isEqualTo objNull) exitwith {[leader _HQ, (groupId (group (_this select 0))) + ', negative. No refueling services are currently available - Out'] remoteExecCall ["RYD_MP_Sidechat"]};

	[_FuelBoy,(vehicle (_this select 0)),[],_HQ,true] call HAL_GoFuelSupp;

	[leader _HQ, (groupId (group (_this select 0))) + ', affirmative. Fuel truck is on its way - Out'] remoteExecCall ["RYD_MP_Sidechat"];

};

Action10fnc = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit addAction ["[HAL Logistics] Request Fuel Truck", 
		"
		[_this select 3] remoteExec ['Action10ct',2]
		"
		, 
		_Unit,-4.2,false,false,"","_target isEqualTo (vehicle player)",0.01];
	
	_Unit setVariable ["HAL_ReqFSuppID",_Action];

};

ACEAction10fnc = {

	private ["_Unit","_ACEAction","_ACEActionL"];

	_Unit = _this select 0;

	_ACEAction = ["HALReqFSupp","Request Fuel Truck","",{

		[_target] remoteExec ['Action10ct',2]

		},{true},{}] call ace_interact_menu_fnc_createAction;

	[_Unit, 1, ["ACE_SelfActions","ACEActionL"], _ACEAction] call ace_interact_menu_fnc_addActionToObject;


};

Action10fncR = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit getVariable "HAL_ReqFSuppID";
	_Unit removeAction _Action;

};

ACEAction10fncR = {

	private ["_Unit"];

	_Unit = _this select 0;

	[_Unit,1,["ACE_SelfActions","ACEActionL","HALReqFSupp"]] call ace_interact_menu_fnc_removeActionFromObject;

};

Action11ct = {

	private ["_unitvar","_chosen","_HQ","_dist","_MedBoy"];

	_HQ = grpNull;

	if not (isnil "LeaderHQ") then {if ((group (_this select 0)) in ((group LeaderHQ) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQ)}};
	if not (isnil "LeaderHQB") then {if ((group (_this select 0)) in ((group LeaderHQB) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQB)}};
	if not (isnil "LeaderHQC") then {if ((group (_this select 0)) in ((group LeaderHQC) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQC)}};
	if not (isnil "LeaderHQD") then {if ((group (_this select 0)) in ((group LeaderHQD) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQD)}};
	if not (isnil "LeaderHQE") then {if ((group (_this select 0)) in ((group LeaderHQE) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQE)}};
	if not (isnil "LeaderHQF") then {if ((group (_this select 0)) in ((group LeaderHQF) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQF)}};
	if not (isnil "LeaderHQG") then {if ((group (_this select 0)) in ((group LeaderHQG) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQG)}};
	if not (isnil "LeaderHQH") then {if ((group (_this select 0)) in ((group LeaderHQH) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQH)}};

	[(_this select 0), 'Command, requesting ambulance - Over'] remoteExecCall ["RYD_MP_Sidechat"];

	sleep 5;

	_Pool = RHQ_Med + RYD_WS_med - RHQs_Med;

	_MedBoy = objNull;

	{
		_unitvar = str (group _x);
		if ( not ((group _x) getVariable [("Busy" + _unitvar),false]) and not ((group _x) == (group (_this select 0))) and not ((group _x) getVariable ["Unable",false]) and not ((group _x) isEqualTo grpNull) and (canMove _x) and ((toLower (typeOf (assignedvehicle (leader (group _x))))) in _Pool) and not (_x in (_HQ getVariable ["RydHQ_AirG",[]])) and not ((group _x) in ((_HQ getVariable ["RydHQ_SpecForG",[]]) + (_HQ getVariable ["RydHQ_CargoOnly",[]]))))  exitwith {_MedBoy = _x};
	} foreach (_HQ getVariable ["RydHQ_Support",[]]);

	if (_MedBoy isEqualTo objNull) exitwith {[leader _HQ, (groupId (group (_this select 0))) + ', negative. No ambulances are currently available - Out'] remoteExecCall ["RYD_MP_Sidechat"]};

	[_MedBoy,(vehicle (_this select 0)),[],_HQ,true] call HAL_GoMedSupp;

	[leader _HQ, (groupId (group (_this select 0))) + ', affirmative. Ambulance is on its way - Out'] remoteExecCall ["RYD_MP_Sidechat"];

};

Action11fnc = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit addAction ["[HAL Logistics] Request Ambulance", 
		"
		[_this select 3] remoteExec ['Action11ct',2]
		"
		, 
		_Unit,-4.3,false,false,"","_target isEqualTo (vehicle player)",0.01];
	
	_Unit setVariable ["HAL_ReqMSuppID",_Action];

};

ACEAction11fnc = {

	private ["_Unit","_ACEAction","_ACEActionL"];

	_Unit = _this select 0;

	_ACEAction = ["HALReqMSupp","Request Ambulance","",{

		[_target] remoteExec ['Action11ct',2]

		},{true},{}] call ace_interact_menu_fnc_createAction;

	[_Unit, 1, ["ACE_SelfActions","ACEActionL"], _ACEAction] call ace_interact_menu_fnc_addActionToObject;


};

Action11fncR = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit getVariable "HAL_ReqMSuppID";
	_Unit removeAction _Action;

};

ACEAction11fncR = {

	private ["_Unit"];

	_Unit = _this select 0;

	[_Unit,1,["ACE_SelfActions","ACEActionL","HALReqMSupp"]] call ace_interact_menu_fnc_removeActionFromObject;

};

Action12ct = {

	private ["_unitvar","_chosen","_HQ","_dist","_MedBoy"];

	_HQ = grpNull;

	if not (isnil "LeaderHQ") then {if ((group (_this select 0)) in ((group LeaderHQ) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQ)}};
	if not (isnil "LeaderHQB") then {if ((group (_this select 0)) in ((group LeaderHQB) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQB)}};
	if not (isnil "LeaderHQC") then {if ((group (_this select 0)) in ((group LeaderHQC) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQC)}};
	if not (isnil "LeaderHQD") then {if ((group (_this select 0)) in ((group LeaderHQD) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQD)}};
	if not (isnil "LeaderHQE") then {if ((group (_this select 0)) in ((group LeaderHQE) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQE)}};
	if not (isnil "LeaderHQF") then {if ((group (_this select 0)) in ((group LeaderHQF) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQF)}};
	if not (isnil "LeaderHQG") then {if ((group (_this select 0)) in ((group LeaderHQG) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQG)}};
	if not (isnil "LeaderHQH") then {if ((group (_this select 0)) in ((group LeaderHQH) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQH)}};

	[(_this select 0), 'Command, requesting aerial medical support - Over'] remoteExecCall ["RYD_MP_Sidechat"];

	sleep 5;

	_Pool = RHQ_Med + RYD_WS_med - RHQs_Med;

	_MedBoy = objNull;

	{
		_unitvar = str (group _x);
		if ( not ((group _x) getVariable [("Busy" + _unitvar),false]) and not ((group _x) == (group (_this select 0))) and not ((group _x) getVariable ["Unable",false]) and not ((group _x) isEqualTo grpNull) and (canMove _x) and ((toLower (typeOf (assignedvehicle (leader (group _x))))) in _Pool) and (_x in (_HQ getVariable ["RydHQ_AirG",[]])) and not ((group _x) in ((_HQ getVariable ["RydHQ_SpecForG",[]]) + (_HQ getVariable ["RydHQ_CargoOnly",[]]))))  exitwith {_MedBoy = _x};
	} foreach (_HQ getVariable ["RydHQ_Support",[]]);

	if (_MedBoy isEqualTo objNull) exitwith {[leader _HQ, (groupId (group (_this select 0))) + ', negative. No MEDEVAC helicopters are currently available - Out'] remoteExecCall ["RYD_MP_Sidechat"]};

	[_MedBoy,(vehicle (_this select 0)),[],_HQ,true] call HAL_GoMedSupp;

	[leader _HQ, (groupId (group (_this select 0))) + ', affirmative. Helicopter is on its way - Out'] remoteExecCall ["RYD_MP_Sidechat"];

};

Action12fnc = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit addAction ["[HAL Logistics] Request Aerial Medical Support", 
		"
		[_this select 3] remoteExec ['Action12ct',2]
		"
		, 
		_Unit,-4.4,false,false,"","_target isEqualTo (vehicle player)",0.01];
	
	_Unit setVariable ["HAL_ReqMASuppID",_Action];

};

ACEAction12fnc = {

	private ["_Unit","_ACEAction","_ACEActionL"];

	_Unit = _this select 0;

	_ACEAction = ["HALReqMASupp","Request Aerial Medical Support","",{

		[_target] remoteExec ['Action12ct',2]

		},{true},{}] call ace_interact_menu_fnc_createAction;

	[_Unit, 1, ["ACE_SelfActions","ACEActionL"], _ACEAction] call ace_interact_menu_fnc_addActionToObject;


};

Action12fncR = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit getVariable "HAL_ReqMASuppID";
	_Unit removeAction _Action;

};

ACEAction12fncR = {

	private ["_Unit"];

	_Unit = _this select 0;

	[_Unit,1,["ACE_SelfActions","ACEActionL","HALReqMASupp"]] call ace_interact_menu_fnc_removeActionFromObject;

};


Action13ct = {

	private ["_unitvar","_chosen","_HQ","_dist","_FixBoy"];

	_HQ = grpNull;

	if not (isnil "LeaderHQ") then {if ((group (_this select 0)) in ((group LeaderHQ) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQ)}};
	if not (isnil "LeaderHQB") then {if ((group (_this select 0)) in ((group LeaderHQB) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQB)}};
	if not (isnil "LeaderHQC") then {if ((group (_this select 0)) in ((group LeaderHQC) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQC)}};
	if not (isnil "LeaderHQD") then {if ((group (_this select 0)) in ((group LeaderHQD) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQD)}};
	if not (isnil "LeaderHQE") then {if ((group (_this select 0)) in ((group LeaderHQE) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQE)}};
	if not (isnil "LeaderHQF") then {if ((group (_this select 0)) in ((group LeaderHQF) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQF)}};
	if not (isnil "LeaderHQG") then {if ((group (_this select 0)) in ((group LeaderHQG) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQG)}};
	if not (isnil "LeaderHQH") then {if ((group (_this select 0)) in ((group LeaderHQH) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQH)}};

	[(_this select 0), 'Command, requesting repair support - Over'] remoteExecCall ["RYD_MP_Sidechat"];

	sleep 5;

	_Pool = RHQ_Rep + RYD_WS_rep - RHQs_Rep;

	_FixBoy = objNull;

	{
		_unitvar = str (group _x);
		if ( not ((group _x) getVariable [("Busy" + _unitvar),false]) and not ((group _x) == (group (_this select 0))) and not ((group _x) getVariable ["Unable",false]) and not ((group _x) isEqualTo grpNull) and (canMove _x) and ((toLower (typeOf (assignedvehicle (leader (group _x))))) in _Pool) and not ((group _x) in ((_HQ getVariable ["RydHQ_SpecForG",[]]) + (_HQ getVariable ["RydHQ_CargoOnly",[]]))))  exitwith {_FixBoy = _x};
	} foreach (_HQ getVariable ["RydHQ_Support",[]]);

	if (_FixBoy isEqualTo objNull) exitwith {[leader _HQ, (groupId (group (_this select 0))) + ', negative. No repair trucks are currently available - Out'] remoteExecCall ["RYD_MP_Sidechat"]};

	[_FixBoy,(vehicle (_this select 0)),[],_HQ,true] call HAL_GoRepSupp;

	[leader _HQ, (groupId (group (_this select 0))) + ', affirmative. Repair truck is on its way - Out'] remoteExecCall ["RYD_MP_Sidechat"];

};

Action13fnc = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit addAction ["[HAL Logistics] Request Repair Support", 
		"
		[_this select 3] remoteExec ['Action13ct',2]
		"
		, 
		_Unit,-4.5,false,false,"","_target isEqualTo (vehicle player)",0.01];
	
	_Unit setVariable ["HAL_ReqRSuppID",_Action];

};

ACEAction13fnc = {

	private ["_Unit","_ACEAction","_ACEActionL"];

	_Unit = _this select 0;

	_ACEAction = ["HALReqRSupp","Request Repair Support","",{

		[_target] remoteExec ['Action13ct',2]

		},{true},{}] call ace_interact_menu_fnc_createAction;

	[_Unit, 1, ["ACE_SelfActions","ACEActionL"], _ACEAction] call ace_interact_menu_fnc_addActionToObject;


};

Action13fncR = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit getVariable "HAL_ReqRSuppID";
	_Unit removeAction _Action;

};

ACEAction13fncR = {

	private ["_Unit"];

	_Unit = _this select 0;

	[_Unit,1,["ACE_SelfActions","ACEActionL","HALReqRSupp"]] call ace_interact_menu_fnc_removeActionFromObject;
	[_Unit,1,["ACE_SelfActions","ACEActionL"]] call ace_interact_menu_fnc_removeActionFromObject;

};

// MENU

ActionMfnc = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit addAction ["[HAL] Show Communication Menu", 
		"
		showCommandingMenu '#USER:NR6_Player_Menu';
		"
		, 
		_Unit,-4.5,false,false,"","_target isEqualTo (vehicle player)",50];
	
	_Unit setVariable ["HAL_ReqMenuID",_Action];

};

ACEActionMfnc = {

	private ["_Unit","_ACEAction"];

	_Unit = _this select 0;

	_ACEAction = ["HALMenu","[HAL] Show Communication Menu","",{

		showCommandingMenu '#USER:NR6_Player_Menu';

		},{true},{}] call ace_interact_menu_fnc_createAction;

	[_Unit, 1, ["ACE_SelfActions"], _ACEAction] call ace_interact_menu_fnc_addActionToObject;


};

ActionMfncR = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit getVariable "HAL_ReqMenuID";
	_Unit removeAction _Action;

};

ACEActionMfncR = {

	private ["_Unit"];

	_Unit = _this select 0;

	[_Unit,1,["ACE_SelfActions","HALMenu"]] call ace_interact_menu_fnc_removeActionFromObject;

};

ActionGTct = {

	private ["_unitvar","_chosen","_HQ","_dist","_TransportPriority","_timer","_AbortAction","_unitG"];

	_HQ = grpNull;

	if not (isnil "LeaderHQ") then {if ((group (_this select 0)) in ((group LeaderHQ) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQ)}};
	if not (isnil "LeaderHQB") then {if ((group (_this select 0)) in ((group LeaderHQB) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQB)}};
	if not (isnil "LeaderHQC") then {if ((group (_this select 0)) in ((group LeaderHQC) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQC)}};
	if not (isnil "LeaderHQD") then {if ((group (_this select 0)) in ((group LeaderHQD) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQD)}};
	if not (isnil "LeaderHQE") then {if ((group (_this select 0)) in ((group LeaderHQE) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQE)}};
	if not (isnil "LeaderHQF") then {if ((group (_this select 0)) in ((group LeaderHQF) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQF)}};
	if not (isnil "LeaderHQG") then {if ((group (_this select 0)) in ((group LeaderHQG) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQG)}};
	if not (isnil "LeaderHQH") then {if ((group (_this select 0)) in ((group LeaderHQH) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQH)}};

	[(_this select 0), 'Command, requesting ground transport - Over'] remoteExecCall ["RYD_MP_Sidechat"];

	_unitG = (group (_this select 0));
	_unitvar = str _unitG;

	if not (_unitG getVariable [("CC" + _unitvar), true]) exitwith {sleep 5; [leader _HQ, (groupId _unitG) + ', negative. Transport already assigned - Out'] remoteExecCall ["RYD_MP_Sidechat"]};
	if (_unitG getVariable ["CargoCheckLoopActive", false]) exitwith {sleep 5; [leader _HQ, (groupId _unitG) + ', request pending. You are already on standby for transport - Over'] remoteExecCall ["RYD_MP_Sidechat"]};

	_unitG setVariable ["CargoCheckLoopActive", true,true];

	_unitG setVariable [("CC" + _unitvar), false, true];

	_TransportPriority = (leader _HQ) getVariable ["RydHQ_TransportPriorityGnd",[]];
	_TransportPriority pushBackUnique (group (_this select 0));
	(leader _HQ) setVariable ["RydHQ_TransportPriorityGnd",_TransportPriority,true];

	[_unitG,_HQ,getpos (_this select 0),false,true,true] call HAL_SCargo;

	sleep 15;

	if (_unitG getVariable ["CargoChosen", false]) exitwith {
		[leader _HQ, (groupId (group (_this select 0))) + ', affirmative. ' + (groupId (group (_unitG getVariable ["AssignedCargo" + (str _unitG),objNull]))) + ' has been assigned - Out'] remoteExecCall ["RYD_MP_Sidechat"];
		_TransportPriority = (leader _HQ) getVariable ["RydHQ_TransportPriorityGnd",[]];
		_TransportPriority = _TransportPriority - [(group (_this select 0))];
		(leader _HQ) setVariable ["RydHQ_TransportPriorityGnd",_TransportPriority,true];

		_unitG setVariable ["CargoCheckLoopActive", false,true];
		};

	if (not (_unitG getVariable ["CargoChosen", false])) then {

		[leader _HQ, (groupId _unitG) + ', copy. No ground transport is available at this time. If transport becomes available in the next ' + (str (RydxHQ_PlayerCargoCheckLoopTime)) + ' minutes, it will be assigned to you - Over'] remoteExecCall ["RYD_MP_Sidechat"];

		_AbortAction = (_this select 0) addAction ["Cancel " + "Ground" + " Transport Request",
		{

		[(_this select 3), 'Command, cancel ground transport request - Over'] remoteExecCall ["RYD_MP_Sidechat"];

		(group (_this select 3)) setVariable ["CargoCheckLoopAbort",true,true];

		(_this select 0) removeAction (_this select 2);

		}
		, 
		(_this select 0),5,false,false,"","_this == _target",15];

		_timer = 0;

		waitUntil {
			if not ((_unitG getVariable ["CargoCheckPending" + _unitvar,false]) and (_unitG getVariable [("CC" + _unitvar), false]) and not (_unitG getVariable ["CargoChosen", false])) then {
				_unitG setVariable [("CC" + _unitvar), false, true];
				[_unitG,_HQ,getpos (_this select 0),false,true,true] call HAL_SCargo;
				};

			sleep 5;

			_timer = _timer + 5;

			(_unitG getVariable ["CargoChosen", false]) or (_timer > (RydxHQ_PlayerCargoCheckLoopTime*60)) or (_unitG getVariable ["CargoCheckLoopAbort",false]);
		};

		(_this select 0) removeAction _AbortAction;

	};

	_TransportPriority = (leader _HQ) getVariable ["RydHQ_TransportPriorityGnd",[]];
	_TransportPriority = _TransportPriority - [(group (_this select 0))];
	(leader _HQ) setVariable ["RydHQ_TransportPriorityGnd",_TransportPriority,true];

	_unitG setVariable ["CargoCheckLoopActive", false,true];

	if (_unitG getVariable ["CargoCheckLoopAbort",false]) exitwith {_unitG setVariable ["CargoCheckLoopAbort",false,true]; [leader _HQ, (groupId _unitG) + ', copy. Ground transport request canceled - Out'] remoteExecCall ["RYD_MP_Sidechat"];};	

	if (_unitG getVariable ["CargoChosen", false]) exitwith {[leader _HQ, (groupId _unitG) + ', update on your request. ' + (groupId (group (_unitG getVariable ["AssignedCargo" + (str _unitG),objNull]))) + ' has been assigned - Out'] remoteExecCall ["RYD_MP_Sidechat"];};
	if (not (_unitG getVariable ["CargoChosen", false])) exitwith {[leader _HQ, (groupId _unitG) + ', update on your request. No ground transport available. - Out'] remoteExecCall ["RYD_MP_Sidechat"]};

};

ActionArtct = {

	private ["_unitvar","_chosen","_HQ","_dist"];

	if not (isnil {(_this select 0) getvariable "HALArtPos"}) exitwith {hint "Artillery Request Already In Progress";};

	_HQ = grpNull;
	_Arts = [];
	_ArtyFriends = [];
	_Marks = false;

	if (not (isnil "LeaderHQ") and not (isnil "ArtyFriendsA")) then {if ((group (_this select 0)) in (ArtyFriendsA)) then {_HQ = (group LeaderHQ); _Arts = ArtyArtGA;}};
	if (not (isnil "LeaderHQB") and not (isnil "ArtyFriendsB")) then {if ((group (_this select 0)) in (ArtyFriendsB)) then {_HQ = (group LeaderHQB);_Arts = ArtyArtGB;}};
	if (not (isnil "LeaderHQC") and not (isnil "ArtyFriendsC")) then {if ((group (_this select 0)) in (ArtyFriendsC)) then {_HQ = (group LeaderHQC);_Arts = ArtyArtGC;}};
	if (not (isnil "LeaderHQD") and not (isnil "ArtyFriendsD")) then {if ((group (_this select 0)) in (ArtyFriendsD)) then {_HQ = (group LeaderHQD);_Arts = ArtyArtGD;}};
	if (not (isnil "LeaderHQE") and not (isnil "ArtyFriendsE")) then {if ((group (_this select 0)) in (ArtyFriendsE)) then {_HQ = (group LeaderHQE);_Arts = ArtyArtGE;}};
	if (not (isnil "LeaderHQF") and not (isnil "ArtyFriendsF")) then {if ((group (_this select 0)) in (ArtyFriendsF)) then {_HQ = (group LeaderHQF);_Arts = ArtyArtGF;}};
	if (not (isnil "LeaderHQG") and not (isnil "ArtyFriendsG")) then {if ((group (_this select 0)) in (ArtyFriendsG)) then {_HQ = (group LeaderHQG);_Arts = ArtyArtGG;}};
	if (not (isnil "LeaderHQH") and not (isnil "ArtyFriendsH")) then {if ((group (_this select 0)) in (ArtyFriendsH)) then {_HQ = (group LeaderHQH);_Arts = ArtyArtGH;}};

	(_this select 0) onMapSingleClick "_this setvariable ['HALArtPos',_pos,true]; _this onMapSingleClick ''; hint 'Fire Mission Coordinates Selected'";

	openMap true;

	_reqArtyMarks = [];

	{
		_lPiece = (vehicle (leader _x));
		_veh = toLower (typeOf _lPiece);
		_pos = position _lPiece;
		if ((vehicle (leader _x)) == (leader _x)) exitwith {};
		_MrkTxt = (getText (configfile >> "CfgVehicles" >> typeOf (vehicle (leader _x)) >> "displayName")) + " (" + (groupId _x) + ")";
		_minRange = missionNamespace getVariable ["RHQ_ClassRangeMin" + str (_veh),0];
		_maxRange = missionNamespace getVariable ["RHQ_ClassRangeMax" + str (_veh),0];

		_ctrPosMrk = createMarkerLocal ["ctrMark" + (str _x), position _lPiece];
		_ctrPosMrk setMarkerTypeLocal "mil_triangle";
		_ctrPosMrk setMarkerColorLocal "ColorRed";
		_ctrPosMrk setMarkerTextLocal _MrkTxt;
		_reqArtyMarks pushBack _ctrPosMrk;

		if (_minRange > 0) then {
			_minRangeMrk = createMarkerLocal ["minMark" + (str _x), position _lPiece]; 
			_minRangeMrk setMarkerShapeLocal "ELLIPSE"; 
			_minRangeMrk setMarkerSizeLocal [_minRange, _minRange];
			_minRangeMrk setMarkerBrushLocal "Border";
			_minRangeMrk setMarkerColorLocal "ColorBlue";
			_reqArtyMarks pushBack _minRangeMrk;
		};
		
		if (_maxRange > 0) then {
			_maxRangeMrk = createMarkerLocal ["maxMark" + (str _x), position _lPiece]; 
			_maxRangeMrk setMarkerShapeLocal "ELLIPSE"; 
			_maxRangeMrk setMarkerSizeLocal [_maxRange, _maxRange];
			_maxRangeMrk setMarkerBrushLocal "Border";
			_maxRangeMrk setMarkerColorLocal "ColorRed";
			_reqArtyMarks pushBack _maxRangeMrk;
		};

	} forEach _Arts;

	hintC "Select artillery strike coordinates. Closing the map will cancel the request.";

	waitUntil {sleep 0.2; (not isnil {(_this select 0) getvariable "HALArtPos"} or not (alive (_this select 0)) or not ((_this select 0) == (leader (group (_this select 0)))) or not (visibleMap))};

	if (isnil {(_this select 0) getvariable "HALArtPos"}) exitwith {hint "Artillery Request Cancelled";(_this select 0) setvariable ["HALArtPos",nil,true];{deleteMarkerLocal _x} foreach _reqArtyMarks;};

	if (not (visibleMap)) exitwith {hint "Artillery Request Cancelled";(_this select 0) setvariable ["HALArtPos",nil,true];{deleteMarkerLocal _x} foreach _reqArtyMarks;};

	_ArtyMenu = [["Artillery Pieces",false]];
	_ArtyOptions = [];
	_selectedPiece = grpNull;

	{
	
	_ArtyOptions pushBack [(count _ArtyMenu),_x];
	_ArtyMenu pushBack [ (getText (configfile >> "CfgVehicles" >> typeOf (vehicle (leader _x)) >> "displayName")) + " (" + (groupId _x) + ")" , [((count _ArtyMenu) + 1)] , "", -5, [["expression", "player setvariable ['HALArtPiece'," + (str (count _ArtyMenu)) +",true]"]], "1", "1"];

	} foreach _Arts;

	_ArtyMenu pushBack ["Cancel Fire Mission", [((count _ArtyMenu) + 1)] , "", -5, [["expression", "player setvariable ['HALArtPiece',0,true]"]], "1", "1"];

	showCommandingMenu "#USER:_ArtyMenu";

	waitUntil {sleep 0.2; (not (isnil {(_this select 0) getvariable "HALArtPiece"}) or not (alive (_this select 0)) or not ((_this select 0) == (leader (group (_this select 0)))) or not (visibleMap) or not (commandingMenu == "#USER:_ArtyMenu"))};

	if (isnil {(_this select 0) getvariable "HALArtPiece"}) exitwith {hint "Artillery Request Cancelled";(_this select 0) setvariable ["HALArtPos",nil,true];{deleteMarkerLocal _x} foreach _reqArtyMarks;};

	if (not (visibleMap)) exitwith {hint "Artillery Request Cancelled";(_this select 0) setvariable ["HALArtPiece",nil,true];(_this select 0) setvariable ["HALArtPos",nil,true];{deleteMarkerLocal _x} foreach _reqArtyMarks;};

	if (((_this select 0) getvariable "HALArtPiece") isEqualTo 0) exitwith {hint "Artillery Request Cancelled";(_this select 0) setvariable ["HALArtPiece",nil,true];(_this select 0) setvariable ["HALArtPos",nil,true];{deleteMarkerLocal _x} foreach _reqArtyMarks;};

	{
		if ((_x select 0) isEqualTo ((_this select 0) getvariable "HALArtPiece")) exitwith {_selectedPiece = (_x select 1);(_this select 0) setvariable ["HALArtPiece",nil,true];};

	} foreach _ArtyOptions;

	{deleteMarkerLocal _x} foreach _reqArtyMarks;

	_ArtyMenuOrd = [["Ordnance Options",false]];
	_OrdOptions = [];
	_selectedOrd = "";


	{
		if ((typeOf (vehicle (leader _selectedPiece))) in (_x select 0)) exitwith {

			if not (((_x select 1) select 0) isEqualTo "") then {
				_OrdOptions pushBack [(count _ArtyMenuOrd),"HE"];
				_ArtyMenuOrd pushBack ["High Explosive", [((count _ArtyMenuOrd) + 1)] , "", -5, [["expression", "player setvariable ['HALArtord'," + (str (count _ArtyMenuOrd)) +",true]"]], "1", "1"];
			};

			if not (((_x select 1) select 1) isEqualTo "") then {
				_OrdOptions pushBack [(count _ArtyMenuOrd),"SPECIAL"];
				_ArtyMenuOrd pushBack ["Special", [((count _ArtyMenuOrd) + 1)] , "", -5, [["expression", "player setvariable ['HALArtord'," + (str (count _ArtyMenuOrd)) +",true]"]], "1", "1"];
			};

			if not (((_x select 1) select 2) isEqualTo "") then {
				_OrdOptions pushBack [(count _ArtyMenuOrd),"SECONDARY"];
				_ArtyMenuOrd pushBack ["Guided/Secondary", [((count _ArtyMenuOrd) + 1)] , "", -5, [["expression", "player setvariable ['HALArtord'," + (str (count _ArtyMenuOrd)) +",true]"]], "1", "1"];
			};

			if not (((_x select 1) select 3) isEqualTo "") then {
				_OrdOptions pushBack [(count _ArtyMenuOrd),"SMOKE"];
				_ArtyMenuOrd pushBack ["Smoke", [((count _ArtyMenuOrd) + 1)] , "", -5, [["expression", "player setvariable ['HALArtord'," + (str (count _ArtyMenuOrd)) +",true]"]], "1", "1"];
			};

			if not (((_x select 1) select 4) isEqualTo "") then {
				_OrdOptions pushBack [(count _ArtyMenuOrd),"ILLUM"];
				_ArtyMenuOrd pushBack ["Illumination", [((count _ArtyMenuOrd) + 1)] , "", -5, [["expression", "player setvariable ['HALArtord'," + (str (count _ArtyMenuOrd)) +",true]"]], "1", "1"];
			};

		};

	} foreach RydHQ_OtherArty;

	if ((count _ArtyMenuOrd) == 1) then {_OrdOptions = [[1,"HE"]];_ArtyMenuOrd pushBack ["High Explosive", [((count _ArtyMenuOrd) + 1)] , "", -5, [["expression", "player setvariable ['HALArtord',1,true]"]], "1", "1"];};

	_ArtyMenuOrd pushBack ["Cancel Fire Mission", [((count _ArtyMenuOrd) + 1)] , "", -5, [["expression", "player setvariable ['HALArtord',0,true]"]], "1", "1"];

	showCommandingMenu "#USER:_ArtyMenuOrd";
	params ["_HalArtVar"];
	waitUntil {sleep 0.2; (not (isnil {_HalArtVar getvariable "HALArtord"}) or not (alive _HalArtVar) or not (_HalArtVar == (leader (group _HalArtVar))) or not (visibleMap) or not (commandingMenu == "#USER:_ArtyMenuOrd"))};

	if (isnil {_HalArtVar getvariable "HALArtord"}) exitwith {hint "Artillery Request Cancelled";_HalArtVar setvariable ["HALArtPos",nil,true];_HalArtVar setvariable ["HALArtPiece",nil,true]};

	if (not (visibleMap)) exitwith {hint "Artillery Request Cancelled";_HalArtVar setvariable ["HALArtord",nil,true];_HalArtVar setvariable ["HALArtPiece",nil,true];_HalArtVar setvariable ["HALArtPos",nil,true]};

	if ((_HalArtVar getvariable "HALArtord") isEqualTo 0) exitwith {hint "Artillery Request Cancelled";_HalArtVar setvariable ["HALArtord",nil,true];_HalArtVar setvariable ["HALArtPiece",nil,true];_HalArtVar setvariable ["HALArtPos",nil,true]};

	{
		if ((_x select 0) isEqualTo (_HalArtVar getvariable "HALArtord")) exitwith {_selectedOrd = (_x select 1);_HalArtVar setvariable ["HALArtord",nil,true];};

	} foreach _OrdOptions;
	

	_ArtyMenuAmnt = [["Ordnance Strength",false]];

	{

	_ArtyMenuAmnt pushBack [(str _x), [((count _ArtyMenuAmnt) + 1)] , "", -5, [["expression", "player setvariable ['HALArtAmnt'," + (str _x) +",true]"]], "1", "1"];

	} foreach [1,2,3,4,5,6,7,8,9];

	_ArtyMenuAmnt pushBack ["Cancel Fire Mission", [((count _ArtyMenuAmnt) + 1)] , "", -5, [["expression", "player setvariable ['HALArtAmnt',0,true]"]], "1", "1"];

	showCommandingMenu "#USER:_ArtyMenuAmnt";

	waitUntil {sleep 0.2; (not (isnil {(_HalArtVar getvariable "HALArtAmnt")}) or not (alive _HalArtVar) or not (_HalArtVar == (leader (group _HalArtVar))) or not (visibleMap) or not (commandingMenu == "#USER:_ArtyMenuAmnt"))};

	if (isnil {_HalArtVar getvariable "HALArtAmnt"}) exitwith {hint "Artillery Request Cancelled";_HalArtVar setvariable ["HALArtPos",nil,true];_HalArtVar setvariable ["HALArtord",nil,true];_HalArtVar setvariable ["HALArtPiece",nil,true]};

	if (not (visibleMap)) exitwith {hint "Artillery Request Cancelled";_HalArtVar setvariable ["HALArtAmnt",nil,true];_HalArtVar setvariable ["HALArtord",nil,true];_HalArtVar setvariable ["HALArtPiece",nil,true];_HalArtVar setvariable ["HALArtPos",nil,true]};

	if ((_HalArtVar getvariable "HALArtAmnt") == 0) exitwith {hint "Artillery Request Cancelled";_HalArtVar setvariable ["HALArtAmnt",nil,true];_HalArtVar setvariable ["HALArtord",nil,true];_HalArtVar setvariable ["HALArtPiece",nil,true];_HalArtVar setvariable ["HALArtPos",nil,true]};



	[_HalArtVar, "Command, requesting fire support at GRID: " + (mapGridPosition (_HalArtVar getvariable ["HALArtPos",nil])) + " - Over"] remoteExecCall ["RYD_MP_Sidechat"];

	[_HQ,_HalArtVar,_HalArtVar getvariable ["HALArtPos",nil],_selectedPiece,_selectedOrd,_HalArtVar getvariable ["HALArtAmnt",nil]] remoteExec ["ActionArt2ct",2];

	
	_HalArtVar setvariable ["HALArtAmnt",nil,true];
	_HalArtVar setvariable ["HALArtord",nil,true];
	_HalArtVar setvariable ["HALArtPiece",nil,true];
//	(_this select 0) setvariable ["HALArtPos",nil,true];

};

ActionArt2ct = {

	_HQ = (_this select 0);
	_FO = (_this select 1);
	_pos = (_this select 2);
	_selectedPiece = (_this select 3);
	_selectedOrd = (_this select 4);
	_amnt = (_this select 5);


	_bArr = [_pos,[_selectedPiece],_selectedOrd,_amnt,_FO] call RYD_ArtyMission;

	if ((_bArr select 0) and not (_selectedPiece getVariable ["RydHQ_BatteryBusy",false])) then {
		_selectedPiece setVariable ["RydHQ_BatteryBusy",true];
		[_bArr select 1,_pos,_bArr select 2,_bArr select 3,_HQ getVariable ["RydHQ_Friends",[]],_HQ getVariable ["RydHQ_ArtyMarks",false],_selectedOrd,(_amnt) min (_bArr select 4),true] spawn RYD_CFF_FFE;
		sleep 5;
		[leader _HQ, "Affirmative. " + (groupId _selectedPiece) + " executing requested fire support - Out"] remoteExecCall ["RYD_MP_Sidechat"];
		_FO setvariable ["HALArtPos",nil,true];
	} else {
		sleep 5;
		[leader _HQ, "Negative. " + (groupId _selectedPiece) + " unable to execute requested fire support - Out"] remoteExecCall ["RYD_MP_Sidechat"];
		_FO setvariable ["HALArtPos",nil,true];
	};

};

