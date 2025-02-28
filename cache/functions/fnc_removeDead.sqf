params [];

{
    if !(alive _x) then {
		_x enableSimulationGlobal true;
		_x hideObjectGlobal false;
		[_x,false] remoteExecCall ["hideobject",0];
		[_x,true] remoteExecCall ["enableSimulation",0];
		if (zbe_debug) then {
			diag_log format ["ZBE_Cache %1 died while cached from group %2, uncaching and removing from cache loop", _x, _group];
		};
	    _toCache = _toCache - [_x];
	};
} forEach _toCache;
