_logic = _this select 0;
 
sleep 5; 
 
_FPool = call compile (_logic getvariable "_Pool");
_reqObject = objNull;
 
if (isServer) then {

{
	if not ((typeOf _x) == "NR6_AssetCompiler_Module") exitwith {_reqObject = _x};
} foreach (synchronizedObjects _logic);

_Pool = []; 
{
	{
	_Pool = _Pool + [_x]; 
	} foreach _x; 
	
} foreach _FPool; 

_side = call compile (_logic getvariable "_side");

_objPos = getpos _logic;
_nearObjs = [];
_Commanders = [];
_leader = objNull;

_nearObjs = _objPos nearEntities ["NR6_HAL_Leader_SimpleObjective_Module", 300];
_nearObjs = [_nearObjs, [], {_objPos distance _x }, "ASCEND",{true}] call BIS_fnc_sortBy;

{
	if ((typeOf _x) == "NR6_HAL_Leader_SimpleObjective_Module") exitwith {
		_Objective = _x;		
		{
			if ((typeOf _x) == "NR6_HAL_Leader_Module") then {_Commanders pushback _x};
		} foreach (synchronizedObjects _Objective);

		{
			_leader = (_x getvariable "LeaderType");
			
			_leader = call compile _leader;
			
			if ((side _leader) isEqualTo _side) exitwith {};
		} foreach _Commanders;
	};
} foreach _nearObjs;

 
//_logic setVariable ["NR6Supplies",200,true];

_cond = "((side _this) isEqualTo west)";

if not (isNull _leader) then {
	_cond = "((side _this) isEqualTo west)";
	if ((side _leader) isEqualTo east) then {_cond = "((side _this) isEqualTo east)"};
	if ((side _leader) isEqualTo resistance) then {_cond = "((side _this) isEqualTo resistance)"};
} else {
	_cond = "((side _this) isEqualTo west)";
	if ((_side) isEqualTo east) then {_cond = "((side _this) isEqualTo east)"};
	if ((_side) isEqualTo resistance) then {_cond = "((side _this) isEqualTo resistance)"};
};


{
	_class = (_x select 0);
	_cost = (_logic getvariable ["NR6OtherCost",50]);
	_emptyS = (_logic getvariable ["NR6EmptySpawn",true]);

	if (_class isKindOf "Man") then {_cost = (_logic getvariable ["NR6ManCost",5])};
	if ((_class isKindOf "Car") or (_class isKindOf "Truck")) then {_cost = (_logic getvariable ["NR6CarCost",5])};

	if not ((missionNamespace getVariable ["NR6ClassCost_" + (_class),-1]) == -1) then {_cost = (missionNamespace getVariable ["NR6ClassCost_" + (_class),-1])};

	_reqObject addAction ["Request " + (getText (configfile >> "CfgVehicles" >> (_x select 0) >> "displayName")) + " [" + str _cost + " Supplies]"," 
	[(_this select 0),(_this select 1),(_this select 3)] remoteExecCall ['NR6_GetUnit',2]; 
	",[_x,_leader,_logic,_side,_cost,_emptyS],1,true,false,"",_cond, 5];
} forEach _Pool; 

_reqObject addAction ["Check Supplies Level"," 
[(_this select 0),(_this select 1),(_this select 3)] remoteExecCall ['NR6_CheckSupplies',2]; 
",_logic,1,true,false,"",_cond, 5];

_reqObject addAction ["Dsimiss All AI From Squad"," 
[(_this select 0),(_this select 1),(_this select 3)] remoteExecCall ['NR6_DimsmissAllAI',2]; 
",_reqObject,1,true,false,"","true", 5];


}; 
 
 

 
