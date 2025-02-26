params [];

private _toCache = (units _group) - [(_leader)];
{
    if (!(isPlayer _x)) then {
        if ((unitReady _x) && (isNull objectParent _x)) then {
            _x enableSimulationGlobal false;
            _x hideObjectGlobal true;
            [_x,true] remoteExecCall ["hideobject",0];
            [_x,false] remoteExecCall ["enableSimulation",0];
        } else {
            _x enableSimulationGlobal true;
            _x hideObjectGlobal false;
            [_x,false] remoteExecCall ["hideobject",0];
            [_x,true] remoteExecCall ["enableSimulation",0];
        };
    };
} forEach _toCache;