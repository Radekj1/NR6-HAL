private ["_logic","_Commanders","_Boxes","_Leader","_prefix","_area","_trig"];

_logic = (_this select 0);
_Commanders = [];
_Boxes = [];

{
	if ((typeOf _x) == "NR6_HAL_Leader_Module") then {_Commanders pushBack _x} else {_Boxes pushBack _x};
} forEach (synchronizedObjects _logic);

{
	_Leader = (_x getVariable "LeaderType");

	if (_Leader == "LeaderHQ") then {_prefix = "RydHQ_"};
	if (_Leader == "LeaderHQB") then {_prefix = "RydHQB_"};
	if (_Leader == "LeaderHQC") then {_prefix = "RydHQC_"};
	if (_Leader == "LeaderHQD") then {_prefix = "RydHQD_"};
	if (_Leader == "LeaderHQE") then {_prefix = "RydHQE_"};
	if (_Leader == "LeaderHQF") then {_prefix = "RydHQF_"};
	if (_Leader == "LeaderHQG") then {_prefix = "RydHQG_"};
	if (_Leader == "LeaderHQH") then {_prefix = "RydHQH_"};

	if not (_Boxes isEqualTo []) then {

		_Boxes call compile (_prefix + "AmmoBoxes" + " = _this");

		if (_logic getVariable ["VirtualBoxes",false]) then {
			{_x enableSimulationGlobal false; _x hideObjectGlobal true;} forEach _Boxes;
		};

		} else {

		_area = _logic getVariable ["objectArea",[0,0,0,true,0]];
		_trig = createTrigger ["EmptyDetector",getPos _logic];
		_trig setTriggerArea [_area select 0,_area select 1, _area select 2, _area select 3];
		_trig call compile (_prefix + "AmmoDepot" + " = _this");

		};




} forEach _Commanders;