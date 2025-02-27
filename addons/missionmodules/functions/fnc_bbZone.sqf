private ["_logic","_Commanders","_Leader","_prefix","_area","_trig"];

_logic = (_this select 0);

_area = _logic getVariable ["objectArea",[0,0,0,true,0]];

_trig = createTrigger ["EmptyDetector",getPos _logic];
_trig setTriggerArea [_area select 0,_area select 1, _area select 2, _area select 3];

_trig call compile ("RydBB_MC" + " = _this");
